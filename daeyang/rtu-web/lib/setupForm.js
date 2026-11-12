// 다르고스 세팅 요청서(엑셀) 읽기 — 시트 하나 = 발전소 하나
// 양식(바탕화면 RTU\1. 다르고스 세팅 양식.xlsx):
//   1. 발전소 정보: 이름·용량·주소·신규/교체   2. 인터넷 상태: 유/무선
//   3. 인버터 정보: 인버터·모델(명)·용량·개수 (여러 줄)   4. 일정: 날짜·오전/오후
// 칸 위치가 아니라 "이름", "모델" 같은 글자를 찾아 그 오른쪽/아래 칸을 읽는다.
// 파일 이름 "YYMMDD_담당자_발전소.xlsx" 에서 담당자를 읽는다.
const XLSX = require('xlsx');

function text(v) {
  if (v === null || v === undefined) return '';
  return String(typeof v === 'number' && Number.isInteger(v) ? v : v).replace(/\r\n?/g, '\n').trim();
}

// "1,374.495kW" → "1374.495", "50kW" → "50"
function number(v) {
  const s = text(v).replace(/,/g, '').replace(/\s*k\s*w\s*$/i, '');
  return /^\d+(\.\d+)?$/.test(s) ? s : (s || '');
}

// 2026.05.12 / 26.05.22 / 2026-05-12 / 엑셀 날짜 → YYYY-MM-DD
function date(v) {
  if (typeof v === 'number' && v > 20000 && v < 80000) {
    const d = XLSX.SSF.parse_date_code(v);
    return `${d.y}-${String(d.m).padStart(2, '0')}-${String(d.d).padStart(2, '0')}`;
  }
  const s = text(v);
  let m = /^(\d{4})[.\-/ ]+(\d{1,2})[.\-/ ]+(\d{1,2})/.exec(s);
  if (m) return `${m[1]}-${m[2].padStart(2, '0')}-${m[3].padStart(2, '0')}`;
  m = /^(\d{2})[.\-/ ]+(\d{1,2})[.\-/ ]+(\d{1,2})/.exec(s);
  if (m) return `20${m[1]}-${m[2].padStart(2, '0')}-${m[3].padStart(2, '0')}`;
  return '';
}

function parseSheet(ws) {
  const ref = XLSX.utils.decode_range(ws['!ref'] || 'A1:A1');
  const g = XLSX.utils.sheet_to_json(ws, { header: 1, defval: null, raw: true, range: { s: { r: 0, c: 0 }, e: ref.e } });
  const cells = [];
  g.forEach((row, r) => (row || []).forEach((v, c) => { if (text(v)) cells.push({ r, c, t: text(v).replace(/\s/g, ''), v }); }));
  const find = (re, after = -1) => cells.find(x => x.r > after && re.test(x.t));
  // 라벨 오른쪽에서 처음 나오는 값
  const right = label => {
    if (!label) return null;
    const v = cells.find(x => x.r === label.r && x.c > label.c);
    return v ? v.v : null;
  };
  const warn = [];

  const nameL = find(/^이름$/);
  const capL = find(/^용량$/);
  const addrL = find(/^주소$/);
  const kindL = find(/^신규\/?교체$/);
  const commL = find(/^유\/?무선$/);
  const dateL = find(/^날짜$/);
  const ampmL = find(/^오전\/?오후$/);
  if (!nameL) warn.push('"이름" 칸을 찾지 못했습니다 — 세팅 양식이 맞는지 확인하세요.');

  // 인버터 표: "모델" 머리글이 있는 줄
  const modelH = find(/^모델(명)?$/);
  const inverters = [];
  if (modelH) {
    const head = cells.filter(x => x.r === modelH.r);
    const col = re => { const h = head.find(x => re.test(x.t)); return h ? h.c : null; };
    // 제조사 칸: 모델 칸 왼쪽에서 가장 가까운 "인버터/제조사" 머리글 (맨 왼쪽 "인버터"는 구역 제목)
    const makerH = head.filter(x => x.c < modelH.c && /^(인버터|제조사)$/.test(x.t)).sort((a, b) => b.c - a.c)[0];
    const makerC = makerH ? makerH.c : modelH.c - 1;
    const kwC = col(/^용량$/);
    const qtyC = col(/^(개수|수량|대수)$/);
    const end = find(/일정|세팅기한/, modelH.r);
    for (let r = modelH.r + 1; r < (end ? end.r : g.length); r++) {
      const row = g[r] || [];
      const it = { maker: text(row[makerC]).toLowerCase(), model: text(row[modelH.c]), unit_kw: kwC !== null ? number(row[kwC]) : '', qty: qtyC !== null ? text(row[qtyC]) : '' };
      if (!it.maker && !it.model && !it.unit_kw && !it.qty) continue;
      if (it.qty && !/^\d+$/.test(it.qty)) warn.push(`인버터 개수 "${it.qty}"가 숫자가 아닙니다.`);
      inverters.push(it);
    }
  } else warn.push('인버터 표("모델" 머리글)를 찾지 못했습니다.');

  const kind = text(right(kindL));
  const comm = text(right(commL));
  const due = right(dateL);
  const out = {
    name: text(right(nameL)),
    capacity: number(right(capL)),
    address: text(right(addrL)),
    kind: /교체/.test(kind) ? '교체' : /신규/.test(kind) ? '신규' : kind,
    comm: /무선/.test(comm) ? '무선' : /유선/.test(comm) ? '유선' : comm,
    due_date: date(due),
    due_time: text(right(ampmL)),
    inverters,
    warnings: warn,
  };
  if (due && !out.due_date) warn.push(`세팅 기한 "${text(due)}"를 날짜로 읽지 못했습니다.`);
  if (!out.kind) warn.push('신규/교체가 비어 있습니다.');
  return out;
}

// buffer: 엑셀 파일 내용, fileName: 원본 파일 이름
function parseSetupForm(buffer, fileName) {
  const wb = XLSX.read(buffer, { type: 'buffer' });
  const m = /^(\d{6})_([^_]+)_/.exec(String(fileName || ''));
  const owner = m ? m[2] : '';
  const sheets = [];
  for (const name of wb.SheetNames) {
    const ws = wb.Sheets[name];
    if (!ws['!ref']) continue;
    const s = parseSheet(ws);
    if (!s.name && !s.inverters.length) continue; // 빈 시트
    sheets.push({ src_file: fileName, src_sheet: name, owner, ...s });
  }
  return { fileName, owner, received: m ? `20${m[1].slice(0, 2)}-${m[1].slice(2, 4)}-${m[1].slice(4, 6)}` : '', sheets };
}

module.exports = { parseSetupForm };
