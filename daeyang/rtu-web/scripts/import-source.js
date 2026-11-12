// 원본 장부 → rtm_* 1회 이관
//   원본: 대양모니터링 원격 관리.xlsx (원격관리·SN·라우터 관리·다르고스 장애현황 시트)
//         0. 다르고스 세팅 관리.xlsm (관리 시트)
//
// 1) 확인표 만들기 — 원본에 글자로 적힌 발전소 이름을 dy_power_plant 와 짝지어 엑셀로 낸다
//    node scripts/import-source.js match <원격관리.xlsx> <세팅관리.xlsm> <확인표.xlsx 저장 경로> [--hint 통합관리.xlsx]
// 2) 미리보기 / 입력 — 확인표의 "확정 keyno" 칸을 그대로 쓴다
//    node scripts/import-source.js preview <원격관리.xlsx> <세팅관리.xlsm> <확인표.xlsx>
//    node scripts/import-source.js apply   <원격관리.xlsx> <세팅관리.xlsm> <확인표.xlsx>   (rtm_* 가 비어 있을 때만, 한 트랜잭션)
//
// 원격관리 시트의 아이디·비밀번호 칸(13열 이후)은 읽지 않는다. dy_power_plant 는 읽기만 한다.
require('dotenv').config({ path: require('path').join(__dirname, '..', '.env'), quiet: true });
const XLSX = require('xlsx');
const mysql = require('mysql2/promise');
const path = require('path');
const { norm, buildIndex, matchName } = require('../lib/match');

// 하드웨어 버전별 마지막 사용 번호를 장부와 다르게 정할 곳 (2026-11-02 사용자: DR-26-010 은 0037 까지 사용)
const LAST_SEQ_FIX = { 'DR-26-010': 37 };
const CURRENT_VERSION = 'DR-26-010';

// ─── 엑셀 읽기 ───────────────────────────────────────────────────────────
function sheetAoa(wb, name) {
  const ws = wb.Sheets[name];
  if (!ws) throw new Error(`"${name}" 시트가 없습니다.`);
  const ref = XLSX.utils.decode_range(ws['!ref']);
  // A1 부터 읽어 열·행 번호를 엑셀과 같게 둔다 (0부터: A열=0, 1행=0)
  return XLSX.utils.sheet_to_json(ws, { header: 1, defval: null, raw: true, range: { s: { r: 0, c: 0 }, e: ref.e } });
}

function text(v) {
  if (v === null || v === undefined) return null;
  const s = (typeof v === 'number' && Number.isInteger(v) ? String(v) : String(v)).replace(/\r\n?/g, '\n').trim();
  return s === '' || s === '-' ? null : s;
}

// 날짜: 20260129 / 260915 / 2026.02.06 / 엑셀 날짜 일련번호 → YYYY-MM-DD
function date(v) {
  if (v === null || v === undefined || v === '') return { v: null };
  if (typeof v === 'number') {
    if (v > 19000000 && v < 21000000) v = String(v);
    else if (v > 20000 && v < 80000) {
      const d = XLSX.SSF.parse_date_code(v);
      return { v: `${d.y}-${String(d.m).padStart(2, '0')}-${String(d.d).padStart(2, '0')}` };
    } else v = String(v);
  }
  const s = String(v).trim();
  if (s === '' || s === '-') return { v: null };
  let m = /^(\d{4})[-./]?(\d{1,2})[-./]?(\d{1,2})/.exec(s);
  if (m) return { v: `${m[1]}-${m[2].padStart(2, '0')}-${m[3].padStart(2, '0')}` };
  m = /^(\d{2})(\d{2})(\d{2})$/.exec(s);
  if (m) return { v: `20${m[1]}-${m[2]}-${m[3]}` };
  return { v: null, bad: s };
}

function readSources(remoteFile, setupFile) {
  const R = XLSX.readFile(remoteFile);
  const S = XLSX.readFile(setupFile);
  const src = { remote: [], sn: [], hw: [], sw: [], router: [], issue: [], setup: [] };

  // 원격관리: B~L 열 (1~11). 13열 이후(아이디·비밀번호)는 읽지 않음
  sheetAoa(R, '원격관리').forEach((r, i) => {
    if (i < 3) return;
    const keyno = text(r[2]);
    if (!keyno && !text(r[6])) return;
    src.remote.push({ line: i + 1, jubok: text(r[1]), keyno, use: text(r[3]), method: text(r[4]), addr: text(r[5]),
      name: text(r[6]), sn: text(r[7]), invCount: text(r[8]), invType: text(r[9]), protocol: text(r[10]), note: text(r[11]) });
  });

  // SN: 사용현황 B~K(1~10), 하드웨어 표 M~P(12~15), SW 표도 같은 열에 이어서 있음
  sheetAoa(R, 'SN').forEach((r, i) => {
    if (i < 3) return;
    const sn = text(r[3]);
    if (sn && /^DR-/.test(sn)) {
      src.sn.push({ line: i + 1, version: text(r[2]), sn, mfg: date(r[4]), inst: date(r[5]), lte: text(r[6]),
        plant: text(r[7]), status: text(r[8]), note: text(r[9]), sw: text(r[10]) });
    }
    const code = text(r[13]);
    if (code && /^DR-\d{2}-\d{3}$/.test(code)) src.hw.push({ prefix: code, title: text(r[14]), detail: text(r[15]) });
    if (code && /^sw_v\d+$/i.test(code)) src.sw.push({ code, title: text(r[14]), detail: text(r[15]) });
  });

  // 라우터 관리: B~M (1~12)
  sheetAoa(R, '라우터 관리').forEach((r, i) => {
    if (i < 3) return;
    const serial = text(r[3]);
    const ctn = text(r[7]);
    if (!serial && !ctn) return;
    src.router.push({ line: i + 1, no: text(r[1]), modem: text(r[2]), serial, imei: text(r[4]), usimModel: text(r[5]), usimNo: text(r[6]),
      ctn, lteIp: text(r[8]), use: text(r[9]), plant: text(r[10]), installed: date(r[11]), note: text(r[12]) });
  });

  // 다르고스 장애현황: B~H (1~7) — 지금은 관리하지 않는 시트, 과거 기록으로 1회 이관
  sheetAoa(R, '다르고스 장애현황').forEach((r, i) => {
    if (i < 3) return;
    if (!text(r[2]) && !text(r[5])) return;
    src.issue.push({ line: i + 1, date: date(r[2]), plant: text(r[3]), inverter: text(r[4]), symptom: text(r[5]), action: text(r[6]), note: text(r[7]) });
  });

  // 세팅 관리(관리 시트): 5행 머리글, 6행부터
  sheetAoa(S, '관리').forEach((r, i) => {
    if (i < 5 || !text(r[2])) return;
    const invs = [];
    for (const c of [7, 11, 15]) {
      if (text(r[c]) || text(r[c + 1]) || text(r[c + 3])) invs.push({ maker: text(r[c]), model: text(r[c + 1]), kw: text(r[c + 2]), qty: text(r[c + 3]) });
    }
    src.setup.push({ line: i + 1, no: text(r[1]), name: text(r[2]), capacity: text(r[3]), address: text(r[4]), kind: text(r[5]), comm: text(r[6]),
      invs, due: date(r[19]), ampm: text(r[20]), owner: text(r[21]), file: text(r[22]), sheet: text(r[23]) });
  });
  return src;
}

// ─── 발전소 이름 짝짓기 (lib/match.js) ─────────────────────────────────────

// ─── 통합관리.xlsx 의 연결 (참고용 힌트) ───────────────────────────────────────
function readHints(file) {
  const wb = XLSX.readFile(file);
  const table = (name, idLabel) => {
    const aoa = sheetAoa(wb, name);
    const h = aoa.findIndex(r => r && r.some(c => String(c ?? '').trim() === idLabel));
    const hd = aoa[h].map(c => (c == null ? '' : String(c).trim()));
    return aoa.slice(h + 1).map(r => Object.fromEntries(hd.map((k, j) => [k, text(r[j])]))).filter(x => x[idLabel]);
  };
  const plants = table('발전소장비', '발전소 ID');
  const pk = Object.fromEntries(plants.map(p => [p['발전소 ID'], Number(p['대양 keyno'])]));
  const devices = table('장비이력', '기록 ID');
  const devSn = Object.fromEntries(devices.map(d => [d['기록 ID'], d['S/N · 일련번호']]));
  const sn = {};
  const addSn = (s, k) => { if (s && k) (sn[s] = sn[s] || new Set()).add(k); };
  for (const d of devices) addSn(d['S/N · 일련번호'], pk[d['발전소 ID']]);
  for (const p of plants) {
    for (const s of String(p['등록 RTU S/N'] || '').split(/[,\n]/).map(x => x.trim()).filter(Boolean)) addSn(s, pk[p['발전소 ID']]);
    for (const d of String(p['공유 RTU ID'] || '').split(/[,\n]/).map(x => x.trim()).filter(Boolean)) addSn(devSn[d], pk[p['발전소 ID']]);
  }
  const routers = table('라우터관리', '라우터 ID');
  const router = {};
  const rSerial = Object.fromEntries(routers.map(r => [r['라우터 ID'], r['일련번호']]));
  for (const r of routers) if (pk[r['발전소 ID']]) (router[r['일련번호']] = router[r['일련번호']] || new Set()).add(pk[r['발전소 ID']]);
  for (const p of plants) if (p['라우터 ID'] && rSerial[p['라우터 ID']]) {
    const s = rSerial[p['라우터 ID']];
    (router[s] = router[s] || new Set()).add(pk[p['발전소 ID']]);
  }
  const setup = table('세팅출고', '작업 ID').map(s => new Set(pk[s['발전소 ID']] ? [pk[s['발전소 ID']]] : []));
  const issue = table('작업장애', '이력 ID').map(s => new Set(pk[s['발전소 ID']] ? [pk[s['발전소 ID']]] : []));
  return { sn, router, setup, issue };
}

// ─── 확인표 ──────────────────────────────────────────────────────────────
function decide(m, hint) {
  const H = hint ? [...hint].filter(Boolean) : [];
  const M = m.keynos;
  const same = (a, b) => a.length === b.length && a.every(x => b.includes(x));
  if (m.verdict === '연결 안 함') return { verdict: '연결 안 함', final: [] };
  if (m.verdict === '일치') {
    if (!H.length || same(M, H) || H.every(x => M.includes(x))) return { verdict: '일치', final: M };
    // 통합관리는 S/N 으로 묶어서, 같은 S/N 장비가 2대면 두 곳이 섞여 있다 → 이름이 정확히 맞으면 이름을 따른다
    if (M.every(x => H.includes(x))) return { verdict: '일치', final: M, why: `통합관리는 ${H.join(',')} (같은 S/N이 여러 장비에 붙은 경우)` };
    return { verdict: '통합관리와 다름', final: M, why: `통합관리는 ${H.join(',')}` };
  }
  if (H.length) return { verdict: '통합관리 연결 사용', final: H, why: m.why };
  return { verdict: m.verdict, final: M, why: m.why };
}

const SHEET_LABEL = { sn: 'SN', router: '라우터 관리', setup: '세팅 관리', issue: '장애현황' };

function buildCheckRows(src, idx, hints, dppName) {
  const rows = [];
  const push = (kind, item, key, raw, hint) => {
    const m = matchName(idx, raw);
    const d = decide(m, hint);
    rows.push({
      '구분': SHEET_LABEL[kind], '원본 행': item.line, '키': key, '원본 발전소 글자': raw || '',
      '판정': d.verdict, '자동 keyno': m.keynos.join(','), '자동 연결 이름 (DB)': m.keynos.map(k => dppName[k] || '?').join(' / '),
      '통합관리 keyno': hint ? [...hint].join(',') : '', '확정 keyno': d.final.join(','),
      '설명': d.why || m.why || '',
    });
  };
  for (const x of src.sn) push('sn', x, x.sn, x.plant, hints && hints.sn[x.sn]);
  for (const x of src.router) push('router', x, x.serial || x.ctn, x.plant, hints && hints.router[x.serial]);
  src.setup.forEach((x, i) => push('setup', x, `No ${x.no}`, x.name, hints && hints.setup[i]));
  src.issue.forEach((x, i) => push('issue', x, `${x.date.v || ''}`, x.plant, hints && hints.issue[i]));
  return rows;
}

function readCheck(file) {
  const wb = XLSX.readFile(file);
  const rows = XLSX.utils.sheet_to_json(wb.Sheets['확인표'], { defval: '' });
  const map = {};
  for (const r of rows) {
    const keynos = String(r['확정 keyno'] ?? '').split(/[,\s/]+/).map(s => s.trim()).filter(Boolean).map(Number);
    if (keynos.some(k => !Number.isInteger(k))) throw new Error(`확인표 ${r['구분']} ${r['원본 행']}행: 확정 keyno "${r['확정 keyno']}"가 숫자가 아닙니다.`);
    map[`${r['구분']}|${r['원본 행']}`] = keynos;
  }
  return map;
}

// ─── 이관 데이터 만들기 ─────────────────────────────────────────────────────
function build(src, dppKeys, check) {
  const problems = [];
  const fin = (kind, item) => {
    const k = check[`${SHEET_LABEL[kind]}|${item.line}`];
    if (!k) throw new Error(`확인표에 ${SHEET_LABEL[kind]} ${item.line}행이 없습니다. 확인표를 다시 만드세요.`);
    const bad = k.filter(x => !dppKeys.has(x));
    if (bad.length) throw new Error(`확인표 ${SHEET_LABEL[kind]} ${item.line}행: keyno ${bad.join(',')}가 모니터링에 없습니다.`);
    return k;
  };
  const out = { plant: [], device: [], link: [], router: [], rlink: [], setup: [], inverter: [], issue: [], hw: [], sw: [] };
  const plantByKey = new Map();
  const id = (p, n) => p + String(n).padStart(4, '0');
  const ensurePlant = keyno => {
    if (!plantByKey.has(keyno)) {
      const row = { plant_id: id('P', plantByKey.size + 1), dpp_keyno: keyno, use_yn: '사용' };
      plantByKey.set(keyno, row);
      out.plant.push(row);
    }
    return plantByKey.get(keyno);
  };

  // 원격관리 → rtm_plant
  for (const r of src.remote) {
    if (!r.keynoFixed) { problems.push(`원격관리 ${r.line}행 "${r.name || ''}": keyno ${r.keyno}가 모니터링에 없어 넣지 않음`); continue; }
    if (plantByKey.has(r.keynoFixed)) { problems.push(`원격관리 ${r.line}행: keyno ${r.keynoFixed} 중복 — 첫 행만 사용`); continue; }
    const p = ensurePlant(r.keynoFixed);
    Object.assign(p, {
      use_yn: r.use || '사용', jubok_keyno: r.jubok, remote_method: r.method, remote_address: r.addr, remote_note: r.note,
      legacy_inv_count: r.invCount, legacy_inv_type: r.invType, legacy_protocol: r.protocol,
    });
  }

  // SN → rtm_device, 연결 (사용중·전달·빈칸인 장비만 지금 연결로 본다)
  const ACTIVE = new Set([null, '사용중', '전달']);
  const devBySn = new Map();
  const snPlants = new Map(); // S/N → SN 시트 기준 연결 keyno
  src.sn.forEach((x, i) => {
    const row = { device_id: id('D', i + 1), device_type: 'RTU', serial_no: x.sn, hw_version: x.version, made_date: x.mfg.v, install_date: x.inst.v,
      status: x.status, ctn: x.lte, sw_version: x.sw, legacy_site: x.plant, note: x.note };
    for (const [k, d] of [['MFG', x.mfg], ['INST', x.inst]]) if (d.bad) {
      problems.push(`SN ${x.line}행 ${k} "${d.bad}" 날짜로 읽을 수 없음 → 비고에 남김`);
      row.note = [row.note, `${k}: ${d.bad}`].filter(Boolean).join(' / ');
    }
    out.device.push(row);
    if (devBySn.has(x.sn)) problems.push(`SN ${x.line}행: S/N ${x.sn} 중복 (${devBySn.get(x.sn).device_id}와 같음)`);
    else devBySn.set(x.sn, row);
    const ks = fin('sn', x);
    snPlants.set(x.sn, { ks, status: x.status, line: x.line });
    if (ACTIVE.has(x.status)) for (const k of ks) out.link.push({ device_id: row.device_id, plant_id: ensurePlant(k).plant_id });
  });
  // 원격관리의 S/N 칸도 연결로 쓴다
  for (const r of src.remote) {
    if (!r.keynoFixed || !r.sn) continue;
    for (const s of r.sn.split(/[,\n]/).map(t => t.trim()).filter(Boolean)) {
      const d = devBySn.get(s);
      if (!d) { problems.push(`원격관리 ${r.line}행 S/N ${s}가 SN 시트에 없음`); continue; }
      const sp = snPlants.get(s);
      // 원격관리 S/N 칸과 SN 시트가 다르면 SN 시트(확인표)를 따른다 (2026-11-02 사용자 결정: 0019 는 종배)
      if (sp && !sp.ks.includes(r.keynoFixed)) {
        problems.push(`S/N ${s}: 원격관리 ${r.line}행 keyno ${r.keynoFixed}(${r.name})는 SN 시트(${sp.ks.join(',') || '연결 없음'})와 달라 연결하지 않음`);
        continue;
      }
      out.link.push({ device_id: d.device_id, plant_id: ensurePlant(r.keynoFixed).plant_id });
    }
  }
  const seen = new Set();
  out.link = out.link.filter(l => { const k = l.device_id + '|' + l.plant_id; if (seen.has(k)) return false; seen.add(k); return true; });

  // 라우터 관리 → rtm_router, 라우터 ↔ 발전소 연결 (공용 라우터·발전소 하나에 여러 대 모두)
  src.router.forEach((x, i) => {
    const row = { router_id: id('L', i + 1), modem: x.modem, serial_no: x.serial, imei: x.imei, usim_model: x.usimModel, usim_no: x.usimNo,
      ctn: x.ctn, lte_ip: x.lteIp, status: x.use, installed_at: x.installed.v, legacy_site: x.plant, note: x.note };
    if (x.installed.bad) row.note = [row.note, `설치날짜: ${x.installed.bad}`].filter(Boolean).join(' / ');
    for (const k of fin('router', x)) out.rlink.push({ router_id: row.router_id, plant_id: ensurePlant(k).plant_id });
    out.router.push(row);
  });

  // 세팅 관리 → rtm_setup (발전소마다 한 건), rtm_inverter (첫 건에)
  let sN = 0;
  let iN = 0;
  for (const x of src.setup) {
    const ks = fin('setup', x);
    if (!ks.length) { problems.push(`세팅 관리 ${x.line}행 "${x.name}": 발전소가 없어 넣지 않음`); continue; }
    ks.forEach((k, j) => {
      const setupId = id('S', ++sN);
      out.setup.push({ setup_id: setupId, plant_id: ensurePlant(k).plant_id, req_name: x.name, req_capacity: x.capacity, req_address: x.address,
        req_comm: x.comm, kind: x.kind, due_date: x.due.v, due_time: x.ampm, owner: x.owner, src_file: x.file, src_sheet: x.sheet,
        next_check: ks.length > 1 ? `요청서 한 줄에 ${ks.length}곳 (${x.name})${j ? ' — 인버터 구성은 첫 건에 있음' : ''}` : null });
      if (j > 0) return;
      for (const v of x.invs) {
        out.inverter.push({ inv_id: id('I', ++iN), setup_id: setupId, plant_id: ensurePlant(k).plant_id, kind: '세팅 요청',
          maker: v.maker ? v.maker.toLowerCase() : null, model: v.model, unit_kw: v.kw && Number.isFinite(Number(v.kw)) ? v.kw : null,
          qty: v.qty && Number.isInteger(Number(v.qty)) ? Number(v.qty) : null, note: v.kw && !Number.isFinite(Number(v.kw)) ? `용량: ${v.kw}` : null });
      }
    });
  }

  // 장애현황 → rtm_issue
  src.issue.forEach((x, i) => {
    const ks = fin('issue', x);
    out.issue.push({ issue_id: id('H', i + 1), occurred_at: x.date.v, plant_id: ks.length ? ensurePlant(ks[0]).plant_id : null, plant_text: x.plant,
      inverter: x.inverter, symptom: x.symptom, action_taken: x.action,
      note: [x.note, x.date.bad ? `날짜: ${x.date.bad}` : null, ks.length > 1 ? `관련 keyno: ${ks.join(',')}` : null].filter(Boolean).join(' / ') || null });
  });

  // 하드웨어·SW 버전
  for (const h of src.hw) {
    let last = 0;
    for (const d of out.device) if (d.serial_no.startsWith(h.prefix + '-') && (d.made_date || d.install_date || d.status || d.sw_version || d.ctn || d.note)) {
      last = Math.max(last, Number(d.serial_no.split('-').pop()));
    }
    out.hw.push({ prefix: h.prefix, title: h.title, detail: h.detail, is_current: h.prefix === CURRENT_VERSION ? 1 : 0,
      last_seq: LAST_SEQ_FIX[h.prefix] ?? last });
  }
  out.sw = src.sw.map(s => ({ code: s.code, title: s.title, detail: s.detail }));
  return { out, problems };
}

// ─── 실행 ────────────────────────────────────────────────────────────────
(async () => {
  const [cmd, remoteFile, setupFile, checkFile] = process.argv.slice(2);
  const hintIdx = process.argv.indexOf('--hint');
  if (!['match', 'preview', 'apply'].includes(cmd) || !remoteFile || !setupFile || !checkFile) {
    console.log('사용법: node scripts/import-source.js match|preview|apply <원격관리.xlsx> <세팅관리.xlsm> <확인표.xlsx> [--hint 통합관리.xlsx]');
    process.exit(1);
  }
  const db = await mysql.createConnection({
    host: process.env.MARIADB_HOST, port: Number(process.env.MARIADB_PORT || 3306),
    user: process.env.MARIADB_USER, password: process.env.MARIADB_PASSWORD, database: process.env.MARIADB_DATABASE,
    charset: 'utf8mb4', dateStrings: true,
  });
  try {
    const [dpp] = await db.query("SELECT DPP_KEYNO, DPP_NAME, DPP_STATUS FROM dy_power_plant WHERE DPP_DEL_YN = 'N'");
    const dppKeys = new Set(dpp.map(p => p.DPP_KEYNO));
    const dppName = Object.fromEntries(dpp.map(p => [p.DPP_KEYNO, p.DPP_NAME]));
    const src = readSources(remoteFile, setupFile);
    for (const r of src.remote) {
      const k = Number(r.keyno);
      r.keynoFixed = Number.isInteger(k) && dppKeys.has(k) ? k : null;
      // 원격관리 이름과 DB 이름이 서로 겹치는 데가 없으면 keyno 가 어긋났을 수 있다
      if (r.keynoFixed && r.name) {
        const a = norm(r.name), b = norm(dppName[k]);
        const near = a && b && (a.includes(b) || b.includes(a) || a.slice(0, 2) === b.slice(0, 2));
        if (!near) r.nameWarn = `원격관리 ${r.line}행 keyno ${k} 이름 "${r.name}" ↔ DB "${dppName[k]}" — keyno 확인 필요`;
      }
    }

    if (cmd === 'match') {
      const hints = hintIdx > 0 ? readHints(process.argv[hintIdx + 1]) : null;
      const extra = src.remote.filter(r => r.keynoFixed && r.name).map(r => ({ name: r.name, keyno: r.keynoFixed }));
      const rows = buildCheckRows(src, buildIndex(dpp, extra), hints, dppName);
      const order = { '못 찾음': 0, '후보 여러 개': 1, '통합관리와 다름': 2, '통합관리 연결 사용': 3, '추정': 4, '연결 안 함': 5, '일치': 6 };
      const wb = XLSX.utils.book_new();
      const ws = XLSX.utils.json_to_sheet(rows);
      ws['!cols'] = [8, 7, 18, 22, 14, 10, 40, 12, 12, 40].map(w => ({ wch: w }));
      ws['!autofilter'] = { ref: ws['!ref'] };
      XLSX.utils.book_append_sheet(wb, ws, '확인표');
      const guide = [
        ['확인표 보는 법'],
        ['"확정 keyno" 칸만 고치면 됩니다. 여러 곳이면 쉼표로 (예: 65,66,67,68). 발전소가 아니면 비워 두세요.'],
        ['판정이 "일치"인 줄은 이름이 정확히 맞은 것이라 보통 그대로 두면 됩니다.'],
        ['"못 찾음 / 후보 여러 개 / 통합관리와 다름 / 통합관리 연결 사용 / 추정" 줄을 확인해 주세요. 오른쪽 "DB 발전소" 시트에서 keyno를 찾을 수 있습니다.'],
        ['장비(SN)는 상태가 사용중·전달·빈칸일 때만 발전소에 연결합니다. 회수·폐기 장비는 원문만 "기존 설치처 표기"로 남습니다.'],
        [],
        ['판정', '줄 수'],
        ...Object.keys(order).map(k => [k, rows.filter(r => r['판정'] === k).length]),
        [],
        ['원격관리 시트 알림'],
        ...src.remote.filter(r => !r.keynoFixed).map(r => [`${r.line}행 keyno ${r.keyno} "${r.name || ''}" — 모니터링에 없어 넣지 않음`]),
        ...src.remote.filter(r => r.nameWarn).map(r => [r.nameWarn]),
      ];
      const gs = XLSX.utils.aoa_to_sheet(guide);
      gs['!cols'] = [{ wch: 110 }, { wch: 8 }];
      XLSX.utils.book_append_sheet(wb, gs, '보는 법');
      const ds = XLSX.utils.json_to_sheet(dpp.sort((a, b) => a.DPP_KEYNO - b.DPP_KEYNO).map(p => ({ keyno: p.DPP_KEYNO, '발전소명': p.DPP_NAME, '개통': p.DPP_STATUS })));
      ds['!cols'] = [{ wch: 8 }, { wch: 36 }, { wch: 6 }];
      XLSX.utils.book_append_sheet(wb, ds, 'DB 발전소');
      XLSX.writeFile(wb, checkFile);
      console.log(`확인표 저장: ${checkFile}`);
      for (const k of Object.keys(order)) console.log(`  ${k}: ${rows.filter(r => r['판정'] === k).length}`);
      return;
    }

    const { out, problems } = build(src, dppKeys, readCheck(checkFile));
    problems.unshift(...src.remote.filter(r => r.nameWarn).map(r => r.nameWarn));
    console.log('=== 옮길 행 수 ===');
    for (const [k, t] of [['plant', 'rtm_plant'], ['device', 'rtm_device'], ['link', 'rtm_device_plant'], ['router', 'rtm_router'], ['rlink', 'rtm_router_plant'],
      ['setup', 'rtm_setup'], ['inverter', 'rtm_inverter'], ['issue', 'rtm_issue'], ['hw', 'rtm_hw_version'], ['sw', 'rtm_sw_version']]) {
      console.log(`  ${t}: ${out[k].length}`);
    }
    console.log(`\n=== 확인할 점 (${problems.length}) ===`);
    problems.forEach(p => console.log('  - ' + p));
    if (cmd === 'preview') { console.log('\n미리보기만 했습니다. 실제로 넣으려면 apply 로 실행하세요.'); return; }

    for (const t of ['rtm_plant', 'rtm_device', 'rtm_device_plant', 'rtm_setup', 'rtm_inverter', 'rtm_issue', 'rtm_router', 'rtm_router_plant', 'rtm_sw_version']) {
      const [[c]] = await db.query(`SELECT COUNT(*) AS n FROM ${t}`);
      if (c.n > 0) throw new Error(`${t}에 이미 ${c.n}행이 있습니다. 이관은 빈 테이블에만 합니다.`);
    }
    await db.beginTransaction();
    try {
      const ins = async (t, rows) => { for (const r of rows) await db.query(`INSERT INTO ${t} SET ?`, [r]); };
      await ins('rtm_router', out.router);
      await ins('rtm_plant', out.plant);
      await ins('rtm_device', out.device);
      await ins('rtm_device_plant', out.link.map(l => ({ ...l, note: '원본 장부 이관' })));
      await ins('rtm_router_plant', out.rlink.map(l => ({ ...l, note: '원본 장부 이관' })));
      await ins('rtm_setup', out.setup);
      await ins('rtm_inverter', out.inverter);
      await ins('rtm_issue', out.issue);
      await ins('rtm_sw_version', out.sw);
      for (const h of out.hw) {
        await db.query('INSERT INTO rtm_hw_version SET ? ON DUPLICATE KEY UPDATE title = VALUES(title), detail = VALUES(detail), is_current = VALUES(is_current), last_seq = VALUES(last_seq)', [h]);
      }
      await db.query("INSERT INTO rtm_change_log (table_name, row_key, action, after_json, username) VALUES ('import', ?, 'insert', ?, 'import-source')",
        [`${path.basename(remoteFile)} + ${path.basename(setupFile)}`, JSON.stringify(Object.fromEntries(Object.entries(out).map(([k, v]) => [k, v.length])))]);
      await db.commit();
      console.log('\n입력 완료.');
    } catch (e) {
      await db.rollback();
      throw e;
    }
  } finally {
    await db.end();
  }
})().catch(e => { console.error('실패:', e.message); process.exit(1); });
