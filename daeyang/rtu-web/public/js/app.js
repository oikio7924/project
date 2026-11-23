// RTU 통합관리 화면
const $ = id => document.getElementById(id);
// q: 검색 칸 글자, seekPick: 검색 칸 목록에서 고른 것 { type: 'plant', plant, label } 또는 { type: 'row', id, label }
const S = { meta: null, lookups: null, rows: {}, counts: {}, active: 'plant', me: null, plantFilter: 'Y', onlyRtu: false, logFilter: '', q: '', seekPick: null };
const pickedPlant = () => (S.seekPick && S.seekPick.type === 'plant' ? S.seekPick.plant : null);
const STATUS = { Y: '개통', N: '미개통', E: '예외' };

function esc(v) {
  return String(v ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
}

let toastTimer;
function toast(msg, err) {
  const t = $('toast');
  t.textContent = msg;
  t.className = 'toast show' + (err ? ' err' : '');
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => { t.className = 'toast' + (err ? ' err' : ''); }, err ? 5000 : 2500);
}

async function api(method, url, body) {
  const res = await fetch(url, {
    method, headers: body ? { 'Content-Type': 'application/json' } : {}, body: body ? JSON.stringify(body) : undefined,
  });
  if (res.status === 401) { location.href = 'login.html'; throw new Error('로그인이 필요합니다.'); }
  const data = await res.json().catch(() => ({}));
  if (!res.ok) throw new Error(data.error || `요청 실패 (${res.status})`);
  return data;
}

const sheet = key => S.meta.sheets.find(s => s.key === key);

function plantLabel(p) { return `${p.keyno} · ${p.name || ''}`; }
function plantByValue(v) {
  if (!v) return null;
  return S.lookups.plants.find(p => p.plant_id === v || p.value === v) || null;
}

// ─── 초기화 ──────────────────────────────────────────────────────────────
async function init() {
  S.me = await api('GET', 'api/me');
  $('who').textContent = `${S.me.name} (${S.me.username})`;
  S.meta = await api('GET', 'api/meta');
  await Promise.all([reloadLookups(), reloadCounts()]);
  try { S.active = localStorage.getItem('rtuweb.tab') || 'plant'; } catch { /* 저장소 없음 */ }
  if (S.active !== 'logs' && (!sheet(S.active) || sheet(S.active).hideNav)) S.active = 'plant';
  await show(S.active);
}

async function reloadLookups() { S.lookups = await api('GET', 'api/lookups'); }
// 왼쪽 메뉴 옆 숫자 (시트를 열지 않아도 보이게 따로 받아 온다)
async function reloadCounts() { S.counts = await api('GET', 'api/counts'); }

async function loadRows(key, force) {
  if (!S.rows[key] || force) S.rows[key] = (await api('GET', `api/sheets/${key}`)).rows;
  S.counts[key] = S.rows[key].length;
  return S.rows[key];
}

async function show(key) {
  S.active = key;
  try { localStorage.setItem('rtuweb.tab', key); } catch { /* 저장소 없음 */ }
  if (key === 'logs') await renderLogs();
  else { await loadRows(key); renderSheet(); }
  renderNav();
}

function renderNav() {
  $('nav').innerHTML = S.meta.sheets.filter(s => !s.hideNav).map(s =>
    `<button data-tab="${s.key}" class="${s.key === S.active ? 'active' : ''}"><span>${esc(s.name)}</span><em>${S.counts[s.key] ?? ''}</em></button>`
  ).join('');
  $('logsNav').classList.toggle('active', S.active === 'logs');
  $('crumb').textContent = S.active === 'logs' ? '변경 이력' : sheet(S.active).name;
}

document.addEventListener('click', e => {
  const tab = e.target.closest('[data-tab]');
  if (tab) {
    S.q = ''; S.seekPick = null; // 메뉴를 옮기면 검색은 처음부터
    if (tab.dataset.tab === 'logs') { logKey = ''; S.logPlant = null; S.logMonth = thisMonth(); } // 메뉴로 들어오면 이번 달 전체
    show(tab.dataset.tab).catch(err => toast(err.message, true));
  }
  if (e.target.closest('[data-close]')) e.target.closest('.modalbg').classList.remove('show');
});

// ─── 검색 칸 (페이지 제목 아래 한 줄 전체) ───────────────────────────────────
// 글자를 치면 표가 바로 걸러지고, 아래에 그 메뉴에 맞는 목록이 뜬다 (SEEK 설정). ↑↓로 고르고 Enter면 고른 것만 보기.
// 목록이 없을 때 Enter는 글자 검색 그대로. Esc는 목록 닫기, ×는 검색 지우기. (2026-11-13 사용자 요청: 메뉴마다 맞는 검색)
const plantPick = p => ({ type: 'plant', plant: p, label: plantLabel(p) });
const statusTag = p => (p.status !== 'Y' ? `<span class="tag ${esc(p.status)}">${esc(STATUS[p.status] || p.status)}</span>` : '');
const linkedText = r => (r.linked_plants || []).map(v => { const p = plantByValue(v); const l = (r.link_labels || {})[v]; return (p ? p.name : v) + (l ? ` (${l})` : ''); }).join(', ');
// 그 메뉴의 행이 있는 발전소만, 건수와 함께 (세팅출고·작업장애)
function plantsWithRows(rows, unit) {
  return S.lookups.plants.map(p => ({ p, n: rows.filter(r => rowInPlant(r, p)).length })).filter(x => x.n)
    .map(({ p, n }) => ({ label: plantLabel(p), sub: `${unit} ${n}건`, tag: statusTag(p), pick: plantPick(p) }));
}
const SEEK = {
  plant: {
    placeholder: '발전소 이름이나 번호를 입력해주세요', picked: '발전소 선택됨', empty: '맞는 발전소가 없습니다.',
    items: () => S.lookups.plants.map(p => ({ label: plantLabel(p), tag: statusTag(p), pick: plantPick(p) })),
  },
  setup: {
    placeholder: '발전소 이름이나 번호로 세팅 기록을 찾아주세요', picked: '발전소 선택됨', empty: '세팅 기록이 있는 발전소 중 맞는 곳이 없습니다.',
    items: rows => plantsWithRows(rows, '세팅'),
  },
  issue: {
    placeholder: '발전소 이름이나 증상으로 장애 기록을 찾아주세요', picked: '발전소 선택됨', empty: '장애 기록이 있는 발전소 중 맞는 곳이 없습니다.',
    items: rows => plantsWithRows(rows, '장애'),
  },
  device: {
    placeholder: 'S/N, 발전소 이름, CTN으로 장비를 찾아주세요', picked: '장비 선택됨', empty: '맞는 장비가 없습니다.',
    // S/N만 미리 적어 둔 빈 행은 목록에서 뺌
    items: rows => rows.filter(r => (r.linked_plants || []).length || r.status || r.made_date || r.install_date || r.ctn || r.note)
      .map(r => {
        const label = `${r.serial_no || 'S/N 없음'} · ${linkedText(r) || '연결 발전소 없음'}`;
        return { label, sub: [r.status, r.ctn].filter(Boolean).join(' · '), find: [r.device_id, r.legacy_site].join(' '), pick: { type: 'row', id: r.device_id, label } };
      }),
  },
  router: {
    placeholder: 'CTN, 일련번호, 발전소 이름으로 라우터를 찾아주세요', picked: '라우터 선택됨', empty: '맞는 라우터가 없습니다.',
    items: rows => rows.map(r => {
      const label = `${r.ctn || r.router_id} · ${linkedText(r) || '설치처 없음'}`;
      return { label, sub: [r.modem, r.serial_no, r.status].filter(Boolean).join(' · '), find: [r.router_id, r.imei, r.usim_no, r.lte_ip, r.legacy_site].join(' '), pick: { type: 'row', id: r.router_id, label } };
    }),
  },
  swver: {
    placeholder: 'SW 버전 번호나 내용으로 찾아주세요', picked: '버전 선택됨', empty: '맞는 SW 버전이 없습니다.',
    items: rows => [...rows].reverse().map(r => {
      const label = `${r.code} · ${r.title || ''}`;
      return { label, sub: r.detail || '', pick: { type: 'row', id: r.code, label } };
    }),
  },
  hwver: {
    placeholder: 'S/N 앞부분(예: DR-26-010)이나 내용으로 찾아주세요', picked: '버전 선택됨', empty: '맞는 하드웨어 버전이 없습니다.',
    items: rows => [...rows].sort((a, b) => (b.is_current - a.is_current) || String(b.prefix).localeCompare(a.prefix)).map(r => {
      const label = `${r.prefix} · ${r.title || ''}`;
      return { label, tag: Number(r.is_current) ? '<span class="tag Y">현재</span>' : '',
        sub: [r.detail, r.next_serial ? `다음 번호 ${r.next_serial}` : ''].filter(Boolean).join(' · '), pick: { type: 'row', id: r.prefix, label } };
    }),
  },
  logs: {
    placeholder: '발전소 이름이나 번호로 이력을 찾아주세요', picked: '발전소 선택됨', empty: '맞는 발전소가 없습니다.',
    items: () => S.lookups.plants.map(p => ({ label: plantLabel(p), tag: statusTag(p), pick: plantPick(p) })),
  },
};
const seekConf = key => SEEK[key] || SEEK.plant;

function seekBox(box, { conf, rows = [], onChange }) {
  const sel = S.seekPick;
  // 앞의 돋보기: 여기가 검색 칸이라는 표시 (2026-11-13 사용자 요청)
  box.innerHTML = `<div class="seek-in">
      <svg class="seek-icon" viewBox="0 0 24 24" width="18" height="18" aria-hidden="true"><circle cx="11" cy="11" r="7" fill="none" stroke="currentColor" stroke-width="2.2"/><line x1="16.2" y1="16.2" x2="21" y2="21" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/></svg>
      <input autocomplete="off" title="글자를 치면 표가 바로 걸러집니다 · ↑↓ 고르기 · Enter 선택 · Esc 닫기" placeholder="${esc(conf.placeholder)}" value="${esc(sel ? sel.label : S.q)}">
      ${sel ? `<span class="seek-tag">${esc(conf.picked)}</span>` : ''}
      <button type="button" class="seek-x" title="검색 지우기" ${sel || S.q ? '' : 'hidden'}>×</button>
    </div><div class="combo-list" hidden></div>`;
  const input = box.querySelector('input');
  const list = box.querySelector('.combo-list');
  const clear = box.querySelector('.seek-x');
  const squash = v => String(v || '').toLowerCase().replace(/\s/g, '');
  const all = conf.items(rows);
  let items = [];
  let active = -1;
  const draw = () => {
    const q = squash(S.seekPick ? '' : input.value);
    items = all.filter(it => !q || squash(`${it.label} ${it.sub || ''} ${it.find || ''}`).includes(q)).slice(0, 200);
    active = items.length ? Math.max(0, Math.min(active, items.length - 1)) : -1;
    list.innerHTML = items.length
      ? items.map((it, i) => `<div class="combo-item ${i === active ? 'on' : ''}" data-i="${i}">${esc(it.label)}${it.tag ? ' ' + it.tag : ''}${it.sub ? `<small>${esc(it.sub)}</small>` : ''}</div>`).join('')
      : `<div class="combo-empty">${esc(conf.empty)} Enter는 글자 그대로 검색합니다.</div>`;
    list.hidden = false;
    const on = list.querySelector('.combo-item.on');
    if (on) on.scrollIntoView({ block: 'nearest' });
  };
  const close = () => { list.hidden = true; };
  const pick = i => {
    const it = items[i];
    if (!it) return;
    S.seekPick = it.pick; S.q = '';
    close();
    onChange(true);
  };
  input.onfocus = () => { if (S.seekPick) input.select(); };
  input.onclick = () => { if (list.hidden) { active = 0; draw(); } };
  input.oninput = () => {
    if (S.seekPick) { S.seekPick = null; box.querySelector('.seek-tag')?.remove(); }
    S.q = input.value;
    clear.hidden = !S.q;
    active = 0;
    draw();
    onChange(false);
  };
  input.onkeydown = e => {
    if (e.key === 'ArrowDown') { e.preventDefault(); if (list.hidden) { active = 0; draw(); } else { active = Math.min(active + 1, items.length - 1); draw(); } }
    else if (e.key === 'ArrowUp') { e.preventDefault(); if (!list.hidden) { active = Math.max(active - 1, 0); draw(); } }
    else if (e.key === 'Enter') { e.preventDefault(); if (!list.hidden && active >= 0 && items.length) pick(active); else close(); }
    else if (e.key === 'Escape') { close(); }
  };
  input.onblur = () => setTimeout(close, 150);
  list.onmousedown = e => { const it = e.target.closest('.combo-item'); if (it) { e.preventDefault(); pick(Number(it.dataset.i)); } };
  clear.onclick = () => { S.q = ''; S.seekPick = null; onChange(true); };
  return input;
}

// 고른 발전소에 속한 행인지 (발전소 keyno, 세팅·인버터·장애의 발전소 ID, 장비·라우터의 연결 발전소)
function rowInPlant(r, p) {
  if (r.keyno != null && String(r.keyno) === String(p.keyno)) return true;
  if (p.plant_id && r.plant_id === p.plant_id) return true;
  if (Array.isArray(r.linked_plants)) return r.linked_plants.some(v => v === p.value || (p.plant_id && v === p.plant_id));
  return false;
}

// ─── 시트 표 ─────────────────────────────────────────────────────────────
function cellText(col, row) {
  let v = row[col.f];
  // 연결 발전소: 이름 뒤에 연결 구분 (예: "민정, 영자, 재두 태양광 발전소 (민정)")
  if (Array.isArray(v)) v = v.map(p => { const pl = plantByValue(p); const l = (row.link_labels || {})[p]; return (pl ? pl.name : p) + (l ? ` (${l})` : ''); }).join(', ');
  else if (col.map) v = col.map[v] ?? v;
  else if (col.type === 'plant') { const pl = plantByValue(v); v = pl ? pl.keyno : v; }
  return v ?? '';
}

const isUnused = r => r.use_yn === '미사용';
// 주복건설(외부 회사 JB 서버)에도 데이터를 보내는 현장: 주복 발전소 번호(jubok_keyno)가 있는 발전소
const isJubok = r => r.jubok_keyno != null && String(r.jubok_keyno).trim() !== '';

function filteredRows() {
  const s = sheet(S.active);
  const q = S.seekPick ? '' : S.q.trim().toLowerCase();
  let rows = S.rows[S.active] || [];
  const pk = S.seekPick;
  if (pk && pk.type === 'plant') rows = rows.filter(r => rowInPlant(r, pk.plant));
  if (pk && pk.type === 'row') rows = rows.filter(r => String(r[s.idField]) === String(pk.id));
  if (S.active === 'plant' && !pk) { // 발전소를 골랐으면 개통·미사용 버튼과 상관없이 그 발전소를 보여 준다
    // 미사용(당사 RTU 이용 종료)은 "미사용" 버튼에서만 보이고, 나머지 버튼은 사용 중인 발전소만
    if (S.plantFilter === 'unused') rows = rows.filter(isUnused);
    else if (S.plantFilter === 'jubok') rows = rows.filter(isJubok);
    else {
      rows = rows.filter(r => !isUnused(r));
      if (S.plantFilter !== 'all') rows = rows.filter(r => r.DPP_STATUS === S.plantFilter);
    }
    if (S.onlyRtu) rows = rows.filter(r => r.plant_id);
  }
  if (q) rows = rows.filter(r => s.columns.some(c => String(cellText(c, r)).toLowerCase().includes(q)));
  return rows;
}

function renderSheet() {
  const s = sheet(S.active);
  // onlyFilter: 그 필터를 골랐을 때만 보이는 칸 (예: 주복 keyno 는 "주복건설" 필터에서만)
  const cols = s.columns.filter(c => !c.hidden && (!c.onlyFilter || c.onlyFilter === S.plantFilter));
  const all = S.rows[S.active] || [];
  let filters = '';
  if (S.active === 'plant') {
    const used = all.filter(r => !isUnused(r));
    const cnt = st => used.filter(r => st === 'all' || r.DPP_STATUS === st).length;
    filters = `<div class="filters">${[['Y', '개통'], ['N', '미개통'], ['E', '예외'], ['all', '전체']].map(([k, l]) =>
      `<button class="chip ${S.plantFilter === k ? 'on' : ''}" data-pf="${k}">${l} ${cnt(k)}</button>`).join('')}
      <span class="chipsep"></span>
      <button class="chip ${S.plantFilter === 'unused' ? 'on' : ''}" data-pf="unused" title="당사 RTU를 더 이상 쓰지 않는 발전소">미사용 ${all.filter(isUnused).length}</button>
      <button class="chip ${S.plantFilter === 'jubok' ? 'on' : ''}" data-pf="jubok" title="주복 발전소 번호가 있는 발전소 (주복건설 서버에도 전송)">주복건설 ${all.filter(isJubok).length}</button>
      <label class="check" style="margin-left:8px;font-weight:normal"><input type="checkbox" id="onlyRtu" ${S.onlyRtu ? 'checked' : ''}> RTU 관리 정보가 있는 곳만</label></div>`;
  }
  const addBtn = S.active === 'plant'
    ? '<button class="btn primary" id="bundleBtn">＋ 발전소 묶음 등록</button>'
    : (S.active === 'setup' ? '<button class="btn" id="formBtn">＋ 세팅 요청서 올리기</button>' : '') + '<button class="btn primary" id="addBtn">＋ 새 행</button>';
  // 페이지 설명 줄 자리는 검색 칸 (설명은 제목에 마우스를 올리면 보임)
  $('view').innerHTML = `
    <div class="title"><div><h1 title="${esc(s.note)}">${esc(s.name)}</h1><p id="rowCount"></p></div>
      <div class="actions">${addBtn}</div></div>
    <div class="seek combo" id="seek"></div>
    ${filters}
    <div class="panel"><div class="tablewrap"><table>
      <thead><tr>${cols.map(c => `<th>${esc(c.label)}</th>`).join('')}</tr></thead>
      <tbody id="sheetBody"></tbody>
    </table></div></div>`;
  $('view').querySelectorAll('[data-pf]').forEach(b => b.onclick = () => { S.plantFilter = b.dataset.pf; renderSheet(); });
  if ($('onlyRtu')) $('onlyRtu').onchange = e => { S.onlyRtu = e.target.checked; renderSheet(); };
  // 검색 칸에서 발전소를 골라 둔 채 새 행을 만들면 그 발전소를 미리 채운다
  if ($('addBtn')) $('addBtn').onclick = () => {
    const p = pickedPlant();
    const preset = !p ? {} : s.columns.some(c => c.type === 'plants') ? { linked_plants: [p.value] } : s.columns.some(c => c.f === 'plant_id') ? { plant_id: p.value } : {};
    openRow(S.active, null, { preset });
  };
  if ($('bundleBtn')) $('bundleBtn').onclick = openBundle;
  if ($('formBtn')) $('formBtn').onclick = openSetupForm;
  const input = seekBox($('seek'), {
    conf: seekConf(S.active),
    rows: all,
    // 발전소를 고르거나 지우면 화면을 새로 그리고(버튼 숫자·선택 표시 갱신), 글자를 칠 때는 표만 다시 그린다 (입력 칸 유지)
    onChange: full => { if (full) { renderSheet(); $('seek').querySelector('input').focus(); } else renderSheetBody(cols); },
  });
  renderSheetBody(cols);
  return input;
}

function renderSheetBody(cols) {
  const s = sheet(S.active);
  const rows = filteredRows();
  const all = S.rows[S.active] || [];
  const who = S.seekPick ? `${S.seekPick.label} · ` : '';
  $('rowCount').textContent = `${who}검색 결과 ${rows.length} / 전체 ${all.length}행 · 행을 누르면 수정합니다`;
  $('sheetBody').innerHTML = rows.length ? rows.map((r, i) => rowHtml(s, cols, r, i)).join('') : `<tr><td class="empty" colspan="${cols.length}">표시할 행이 없습니다.</td></tr>`;
  $('sheetBody').querySelectorAll('tr[data-i]').forEach(tr => tr.onclick = () => {
    const row = rows[Number(tr.dataset.i)];
    if (S.active === 'plant') openPlant(row); else openRow(S.active, row);
  });
}

function rowHtml(s, cols, r, i) {
  const off = s.key === 'plant' && r.use_yn === '미사용';
  return `<tr data-i="${i}" class="${off ? 'off' : ''}">${cols.map(c => {
    const t = cellText(c, r);
    if (c.f === 'DPP_STATUS') return `<td><span class="tag ${esc(r.DPP_STATUS)}">${esc(t)}</span></td>`;
    return `<td class="${c.f === 'DPP_NAME' ? 'name' : ''}" title="${esc(t)}">${esc(t)}</td>`;
  }).join('')}</tr>`;
}

// ─── 입력 칸 ─────────────────────────────────────────────────────────────
function options(list, value, blank = true) {
  const has = list.some(o => String(o.v) === String(value ?? ''));
  return (blank ? '<option value="">선택 안 함</option>' : '') +
    (!has && value ? `<option value="${esc(value)}" selected>${esc(value)}</option>` : '') +
    list.map(o => `<option value="${esc(o.v)}" ${String(o.v) === String(value ?? '') ? 'selected' : ''}>${esc(o.l)}</option>`).join('');
}
const plantOptions = v => options(S.lookups.plants.map(p => ({ v: p.value, l: plantLabel(p) + (p.status !== 'Y' ? ` (${STATUS[p.status] || p.status})` : '') })), v);
const deviceOptions = v => options(S.lookups.devices.map(d => ({ v: d.device_id, l: `${d.device_id} · ${d.serial_no || 'S/N 없음'}${d.status ? ' · ' + d.status : ''}` })), v);
function versionsSorted() {
  return [...(S.lookups.hwVersions || [])].sort((a, b) => (b.is_current - a.is_current) || b.prefix.localeCompare(a.prefix));
}
const routerOptions = v => options(S.lookups.routers.map(r => ({ v: r.router_id, l: `${r.router_id} · ${r.ctn || ''}${r.status ? ' · ' + r.status : ''}` })), v);

// S/N 세 칸: DR-[연도]-[버전]-[번호]. 기본값은 지금 만드는 버전의 다음 번호, 각 칸은 직접 고칠 수 있다.
function serialPartsHtml(name, hidden) {
  const v = versionsSorted()[0];
  const [, yy, hw, no] = /^DR-(\d{2})-(\d{3})-(\d{4})$/.exec(v ? v.next_serial : 'DR-26-001-0001') || [];
  return `<div class="serialparts" data-serial ${hidden ? 'style="display:none"' : ''}>
      <span>DR -</span><input data-p="yy" value="${yy}" maxlength="2" inputmode="numeric" title="연도 2자리">
      <span>-</span><input data-p="hw" value="${hw}" maxlength="3" inputmode="numeric" title="하드웨어 변경 차수 3자리">
      <span>-</span><input data-p="no" value="${no}" maxlength="4" inputmode="numeric" title="그 버전의 몇 번째 장비 4자리">
      <input type="hidden" name="${name}" value="DR-${yy}-${hw}-${no}">
      <div class="help" data-serial-help></div></div>`;
}
// 장비이력 새 행: S/N 세 칸 + "S/N 없음" (전임자가 설치해 S/N이 없는 기존 장비를 등록할 때. 다음 번호를 쓰지 않는다)
function serialFieldHtml() {
  return `<div class="field w2"><label>S/N</label>${serialPartsHtml('serial_no')}
    <label class="check" style="margin-top:6px;font-weight:normal"><input type="checkbox" data-no-serial> S/N 없음 (전임자 설치 기존 장비 등)</label>
    <div class="help">체크하면 S/N 없이 저장하고 다음 번호를 쓰지 않습니다.</div></div>`;
}
function bindNoSerial(form) {
  const cb = form.querySelector('[data-no-serial]');
  if (!cb) return;
  const box = form.querySelector('[data-serial]');
  const out = box.querySelector('input[type=hidden]');
  const p = k => box.querySelector(`[data-p="${k}"]`);
  cb.onchange = () => {
    box.style.display = cb.checked ? 'none' : '';
    out.value = cb.checked ? '' : `DR-${p('yy').value}-${p('hw').value}-${p('no').value}`;
  };
}
function bindSerialParts(root) {
  for (const box of root.querySelectorAll('[data-serial]')) {
    const p = k => box.querySelector(`[data-p="${k}"]`);
    const out = box.querySelector('input[type=hidden]');
    const help = box.querySelector('[data-serial-help]');
    let noTouched = false;
    const pad = (el, n) => { if (el.value) el.value = el.value.replace(/\D/g, '').slice(-n).padStart(n, '0'); };
    const update = () => {
      const serial = `DR-${p('yy').value}-${p('hw').value}-${p('no').value}`;
      out.value = serial;
      const ver = (S.lookups.hwVersions || []).find(x => x.prefix === serial.slice(0, 9));
      const dev = S.lookups.devices.filter(d => d.serial_no === serial);
      let msg;
      if (!/^DR-\d{2}-\d{3}-\d{4}$/.test(serial)) msg = '⚠ 연도 2자리, 버전 3자리, 번호 4자리로 입력하세요.';
      else if (!ver) msg = `⚠ ${serial.slice(0, 9)}은(는) 하드웨어 버전 표에 없습니다. "하드웨어 버전" 메뉴에서 먼저 추가하세요.`;
      else if (dev.some(d => Number(d.used))) msg = `⚠ ${serial}은(는) 이미 쓰고 있는 번호입니다.`;
      else if (dev.length) msg = `${ver.title || ver.prefix} · 미리 적어 둔 빈 행(${dev[0].device_id})에 저장됩니다.`;
      else msg = `${ver.title || ver.prefix} · 새 장비로 만듭니다. (이 버전 다음 번호: ${ver.next_serial.slice(-4)})`;
      help.textContent = msg;
      help.style.color = msg.startsWith('⚠') ? 'var(--red)' : '';
    };
    const versionChanged = () => {
      const ver = (S.lookups.hwVersions || []).find(x => x.prefix === `DR-${p('yy').value}-${p('hw').value}`);
      if (!noTouched) p('no').value = ver ? ver.next_serial.slice(-4) : '0001';
      update();
    };
    p('yy').oninput = () => { if (p('yy').value.length === 2) versionChanged(); else update(); };
    p('hw').oninput = () => { if (p('hw').value.length === 3) versionChanged(); else update(); };
    p('no').oninput = () => { noTouched = true; update(); };
    p('yy').onblur = () => { pad(p('yy'), 2); versionChanged(); };
    p('hw').onblur = () => { pad(p('hw'), 3); versionChanged(); };
    p('no').onblur = () => { pad(p('no'), 4); update(); };
    update();
  }
}

function fieldHtml(col, value, isNew) {
  const req = col.required ? ' <b>*</b>' : '';
  const name = `name="${col.f}"`;
  let input;
  if (col.readonly || col.join || (col.createOnly && !isNew)) input = `<input ${col.createOnly ? name : ''} value="${esc(value)}" readonly>`;
  else if (col.type === 'select') input = `<select ${name}>${options(col.opts.filter(Boolean).map(o => ({ v: o, l: (col.map && col.map[o]) || o })), value, col.opts.includes(''))}</select>`;
  else if (col.type === 'plant') input = `<select ${name}>${plantOptions(value)}</select>`;
  else if (col.type === 'device') {
    const news = col.allowNew ? '<option value="__new">＋ 새 RTU 만들기 (S/N 입력)</option>' : '';
    input = `<select ${name} ${col.allowNew ? 'data-device-new' : ''}>${deviceOptions(value).replace('</option>', '</option>' + news)}</select>`
      + (col.allowNew ? serialPartsHtml('new_serial', true) : '');
  }
  else if (col.type === 'serial' && isNew) return serialFieldHtml();
  else if (col.type === 'router') input = `<select ${name}>${routerOptions(value)}</select>`;
  // 목록은 bindSetupPick 이 세팅출고를 불러와 고른 발전소 기준으로 채움
  else if (col.type === 'setup') input = `<select ${name} data-setup-pick data-cur="${esc(value)}"><option value="${esc(value)}">${esc(value || '(없음)')}</option></select>`;
  else if (col.type === 'textarea') input = `<textarea ${name}>${esc(value)}</textarea>`;
  else if (col.type === 'plants') return plantsFieldHtml(col, value || []);
  else input = `<input ${name} value="${esc(value)}" ${col.type === 'date' ? 'type="date"' : ''} ${col.type === 'number' ? 'inputmode="decimal"' : ''} ${col.placeholder ? `placeholder="${esc(col.placeholder)}"` : ''}>`;
  const wide = col.type === 'textarea' || col.type === 'plant' || col.allowNew ? 'w2' : '';
  return `<div class="field ${wide}"><label>${esc(col.label)}${req}</label>${input}${col.help ? `<div class="help">${esc(col.help)}</div>` : ''}</div>`;
}

// 지금 여는 수정 창의 연결 구분 { 발전소 값: 구분 } (openRow 에서 채움)
let formLinkLabels = {};
function plantsFieldHtml(col, values) {
  return `<div class="field full" data-plants><label>${esc(col.label)}</label>
    <div class="inline"><select data-plant-pick>${plantOptions('')}</select><button type="button" class="btn" data-plant-add>추가</button></div>
    <div class="chips" data-plant-chips>${values.map(v => chipHtml(v, formLinkLabels[v])).join('')}</div>
    <div class="help">여러 발전소가 같이 쓰면 모두 추가합니다. 빼면 연결 해제일이 기록됩니다.
      <b>구분</b>은 한 발전소 번호에 장비가 여러 대일 때 이 장비가 어느 발전소 몫인지 적습니다 (예: 145번 → 민정·영자·재두).</div></div>`;
}
function chipHtml(v, label = '') {
  const p = plantByValue(v);
  return `<span data-v="${esc(v)}">${esc(p ? plantLabel(p) : v)}<input class="chip-label" data-label placeholder="구분 (선택)" value="${esc(label || '')}" maxlength="100"><button type="button" title="빼기">×</button></span>`;
}
function bindPlantsField(form) {
  const box = form.querySelector('[data-plants]');
  if (!box) return;
  box.querySelector('[data-plant-add]').onclick = () => {
    const v = box.querySelector('[data-plant-pick]').value;
    if (!v || box.querySelector(`[data-v="${CSS.escape(v)}"]`)) return;
    box.querySelector('[data-plant-chips]').insertAdjacentHTML('beforeend', chipHtml(v));
  };
  box.querySelector('[data-plant-chips]').onclick = e => { if (e.target.tagName === 'BUTTON') e.target.parentElement.remove(); };
}
// 세팅 작업 칸: 같은 창에서 고른 발전소의 세팅출고 기록만 보여 줌 (발전소를 바꾸면 목록도 바뀜)
async function bindSetupPick(form) {
  const sel = form.querySelector('[data-setup-pick]');
  if (!sel) return;
  const cur = sel.dataset.cur || '';
  let setups;
  try { setups = await loadRows('setup'); } catch { return; } // 못 불러오면 지금 값만 둔 채로
  const plantSel = form.elements.plant_id;
  const fill = keep => {
    const p = plantSel ? plantByValue(plantSel.value) : null;
    const mine = p ? setups.filter(x => x.plant_id === p.plant_id) : [];
    const opt = x => `${x.setup_id} · ${[x.kind, x.status, x.shipped_at ? '출고 ' + x.shipped_at : ''].filter(Boolean).join(' · ')}`;
    let html = `<option value="">(없음)</option>` + mine.map(x => `<option value="${esc(x.setup_id)}">${esc(opt(x))}</option>`).join('');
    if (keep && !mine.some(x => x.setup_id === keep)) html += `<option value="${esc(keep)}">${esc(keep)} (다른 발전소 작업)</option>`;
    sel.innerHTML = html;
    sel.value = keep;
  };
  fill(sel.value || cur);
  if (plantSel) plantSel.addEventListener('change', () => fill(''));
}

function readForm(form, cols) {
  const out = {};
  for (const c of cols) {
    if (c.join || c.readonly || (c.createOnly && form.elements[c.f] && form.elements[c.f].readOnly)) continue;
    if (c.type === 'plants') {
      const chips = [...form.querySelectorAll('[data-plant-chips] [data-v]')];
      out[c.f] = chips.map(x => x.dataset.v);
      out.link_labels = Object.fromEntries(chips.map(x => [x.dataset.v, x.querySelector('[data-label]').value.trim()]));
      continue;
    }
    const el = form.elements[c.f];
    if (el) out[c.f] = el.value;
    if (c.allowNew && out[c.f] === '__new') out[c.f] = '__new:' + form.elements.new_serial.value;
  }
  return out;
}

// ─── 일반 시트 행 추가·수정 ─────────────────────────────────────────────────
// opts.preset: 새 행 기본값, opts.onDone: 저장·삭제 뒤 할 일 (예: 발전소 창의 인버터 탭 다시 그리기)
function openRow(key, row, opts = {}) {
  const s = sheet(key);
  const form = $('rowForm');
  const isNew = !row;
  // formHidden: 목록에만 있고 수정 창에는 없는 칸 (예: 드롭다운과 겹치는 발전소명)
  const cols = s.columns.filter(c => !c.formHidden && !(isNew && (c.join || c.readonly)));
  const initial = c => (row ? row[c.f] : opts.preset && c.f in opts.preset ? opts.preset[c.f] : (c.f === 'is_current' ? '0' : ''));
  formLinkLabels = (row && row.link_labels) || {};
  form.innerHTML = `
    <h2>${esc(s.name)} ${isNew ? '새 행' : esc(row[s.idField])}</h2>
    <p class="sub">${esc(s.note)}</p>
    <div class="formgrid">${cols.map(c => fieldHtml(c, initial(c), isNew)).join('')}</div>
    ${key === 'setup' && row ? '<div class="group" style="margin-top:12px"><h3>이 세팅 요청의 인버터 구성</h3><div id="setupInv" class="sub">불러오는 중…</div></div>' : ''}
    <div class="modalfoot">
      ${isNew ? '' : '<button type="button" class="btn danger" id="delRow">삭제</button><button type="button" class="btn" id="rowLog">변경 이력</button>'}
      <div class="r"><button type="button" class="btn" data-close>취소</button><button class="btn primary">저장</button></div>
    </div>`;
  bindPlantsField(form);
  bindSerialParts(form);
  bindNoSerial(form);
  bindSetupPick(form);
  const newSel = form.querySelector('[data-device-new]');
  if (newSel) newSel.onchange = () => { form.querySelector('[data-serial]').style.display = newSel.value === '__new' ? '' : 'none'; };
  form.onsubmit = async e => {
    e.preventDefault();
    try {
      const body = readForm(form, s.columns);
      if (isNew) {
        const r = await api('POST', `api/sheets/${key}`, body);
        toast(`${r.id} 추가했습니다.${r.serial_no ? ' S/N ' + r.serial_no : ''}`);
      } else {
        const r = await api('PUT', `api/sheets/${key}/${encodeURIComponent(row[s.idField])}`, body);
        toast(`${row[s.idField]} 저장했습니다.${String(body.device_id || '').startsWith('__new:') ? ' 새 RTU를 만들어 연결했습니다.' : ''}`);
      }
      $('rowBg').classList.remove('show');
      await refreshAfterSave();
      if (opts.onDone) await opts.onDone();
    } catch (err) { toast(err.message, true); }
  };
  if (!isNew) {
    $('delRow').onclick = async () => {
      if (!confirm(`${row[s.idField]} 행을 삭제할까요? 삭제 내용은 변경 이력에 남습니다.`)) return;
      try {
        await api('DELETE', `api/sheets/${key}/${encodeURIComponent(row[s.idField])}`);
        $('rowBg').classList.remove('show');
        toast(`${row[s.idField]} 삭제했습니다.`);
        await refreshAfterSave();
        if (opts.onDone) await opts.onDone();
      } catch (err) { toast(err.message, true); }
    };
    $('rowLog').onclick = () => { $('rowBg').classList.remove('show'); $('plantBg').classList.remove('show'); openLogsFor(s.table, row[s.idField]); };
  }
  if (key === 'setup' && row) {
    loadRows('inverter').then(inv => {
      const mine = inv.filter(x => x.setup_id === row.setup_id);
      $('setupInv').innerHTML = mine.length ? invTableHtml(mine, false) : '이 세팅 요청에 연결된 인버터 구성이 없습니다.';
    }).catch(err => toast(err.message, true));
  }
  $('rowBg').classList.add('show');
}

// 저장 뒤: 선택 목록·메뉴 숫자를 다시 받고, 지금 보고 있는 시트를 다시 읽는다
// (발전소 선택으로 rtm_plant 가 새로 생기는 등 다른 시트도 바뀔 수 있어 캐시를 비운다)
async function refreshAfterSave() {
  await Promise.all([reloadLookups(), reloadCounts()]);
  S.rows = {};
  if (S.active !== 'logs') {
    await loadRows(S.active, true);
    renderSheet();
  }
  renderNav();
}

// 인버터 구성 표 (발전소 창 인버터 탭, 세팅출고 창에서 같이 씀)
function invTableHtml(rows, clickable) {
  const kw = v => (v == null || v === '' ? '' : String(Number(v)));
  // 한 줄 = 인버터 한 대. RTU·단자·slave 순으로 (slave 없는 줄은 뒤, 같으면 등록 순)
  const num = v => (v === null || v === undefined || v === '' || !Number.isFinite(Number(v)) ? Infinity : Number(v));
  rows = [...rows].sort((a, b) => String(a.device_id || '').localeCompare(String(b.device_id || ''))
    || num(a.port) - num(b.port) || num(a.slave_id) - num(b.slave_id) || String(a.inv_id).localeCompare(String(b.inv_id)));
  return `<div class="panel"><div class="tablewrap" style="max-height:none"><table>
    <thead><tr><th>인버터명</th><th>제조사</th><th>모델</th><th>인버터 S/N</th><th>용량 (kW)</th><th>세팅 작업</th><th>RTU</th><th>단자</th><th>slave_id</th><th>비고</th></tr></thead>
    <tbody>${rows.map(x => `<tr ${clickable ? `data-inv="${esc(x.inv_id)}"` : 'style="cursor:default"'}>
      <td>${esc(x.inv_name)}</td><td>${esc(x.maker)}</td><td>${esc(x.model)}</td><td title="${esc(x.inv_sn)}">${esc(x.inv_sn)}</td><td>${esc(kw(x.unit_kw))}</td>
      <td>${esc(x.setup_id)}</td><td>${esc(x.device_id)}</td><td>${esc(x.port)}</td><td>${esc(x.slave_id)}</td><td title="${esc(x.note)}">${esc(x.note)}</td></tr>`).join('')}</tbody>
  </table></div></div>`;
}

// ─── 발전소 수정 (RTU 관리 정보 / 모니터링 발전소) ───────────────────────────
function openPlant(row, tab = 'rtm') {
  const m = $('plantModal');
  m.innerHTML = `
    <h2>${esc(row.keyno)} · ${esc(row.DPP_NAME)} <span class="tag ${esc(row.DPP_STATUS)}">${esc(STATUS[row.DPP_STATUS] || row.DPP_STATUS)}</span></h2>
    <p class="sub">발전소 ID ${esc(row.plant_id || '(아직 없음 — 처음 저장할 때 만들어집니다)')}</p>
    <div class="tabs"><button data-pt="rtm">RTU 관리 정보</button><button data-pt="inv">인버터 구성</button><button data-pt="dpp">모니터링 발전소 정보</button><button data-pt="log">변경 이력</button></div>
    <div id="ptBody"></div>`;
  const tabs = m.querySelectorAll('[data-pt]');
  const go = name => {
    tabs.forEach(x => x.classList.toggle('on', x.dataset.pt === name));
    ({ rtm: plantRtmTab, inv: plantInvTab, dpp: plantDppTab, log: plantLogTab })[name](row);
  };
  tabs.forEach(b => b.onclick = () => go(b.dataset.pt));
  go(tab);
  $('plantBg').classList.add('show');
}

// 인버터 구성 탭: 홈페이지 값(참고) + 이 발전소의 인버터 모델 줄 (추가·수정·삭제)
async function plantInvTab(row) {
  $('ptBody').innerHTML = '<p class="sub">불러오는 중…</p>';
  try {
    const [{ row: d }, inv] = await Promise.all([api('GET', `api/power/${row.keyno}`), loadRows('inverter', true)]);
    const mine = row.plant_id ? inv.filter(x => x.plant_id === row.plant_id) : [];
    const reopen = async () => {
      const plants = S.rows.plant || await loadRows('plant', true);
      openPlant(plants.find(p => p.keyno === row.keyno) || row, 'inv');
    };
    $('ptBody').innerHTML = `
      <div class="intro">홈페이지 등록값 (참고): 인버터 <b>${esc(d.DPP_INVER || '-')}</b> · 대수 <b>${esc(d.DPP_INVER_COUNT ?? '-')}</b>
        · 인버터별 용량 <b>${esc(d.DPP_OTHER_VOLUM || '-')}</b></div>
      <p class="sub">인버터 한 대에 한 줄씩 적습니다 (slave·S/N·인버터명을 대마다). 줄을 누르면 수정·삭제합니다. 모르는 칸은 비워 두고 알게 될 때 채우면 됩니다.</p>
      ${mine.length ? invTableHtml(mine, true) : '<div class="empty">아직 인버터 구성이 없습니다.</div>'}
      <div class="modalfoot"><button type="button" class="btn primary" id="invAdd">＋ 인버터 추가</button>
        <div class="r"><button type="button" class="btn" data-close>닫기</button></div></div>`;
    $('invAdd').onclick = () => openRow('inverter', null, { preset: { plant_id: row.plant_id || 'K' + row.keyno }, onDone: reopen });
    $('ptBody').querySelectorAll('tr[data-inv]').forEach(tr => tr.onclick = () =>
      openRow('inverter', mine.find(x => x.inv_id === tr.dataset.inv), { onDone: reopen }));
  } catch (err) { toast(err.message, true); }
}

function plantRtmTab(row) {
  const s = sheet('plant');
  const cols = s.columns.filter(c => !c.join);
  $('ptBody').innerHTML = `<form id="rtmForm" novalidate>
    <p class="sub">이 발전소의 RTU 관련 정보입니다. 원격 접속 방식은 확인된 것만 적고, 모르면 비워 둡니다.</p>
    <div class="formgrid">
      <div class="field"><label>RTU S/N (장비이력에서 연결)</label><input value="${esc(row.device_sns)}" readonly></div>
      <div class="field"><label>라우터 CTN (라우터관리에서 연결)</label><input value="${esc(row.router_ctn)}" readonly></div>
      ${cols.map(c => fieldHtml(c, row[c.f] || (c.f === 'use_yn' ? '사용' : ''))).join('')}
    </div>
    <h3 class="linkhead">연결된 장비·라우터 <small>장비이력·라우터관리에 적힌 비고를 여기서 같이 봅니다. 줄을 누르면 그 장비를 고칩니다.</small></h3>
    <div id="rtmLinks"><p class="sub">불러오는 중…</p></div>
    <div class="modalfoot"><div class="r"><button type="button" class="btn" data-close>닫기</button><button class="btn primary">저장</button></div></div></form>`;
  plantLinksFill(row);
  $('rtmForm').onsubmit = async e => {
    e.preventDefault();
    try {
      const r = await api('PUT', `api/plants/${row.keyno}`, readForm(e.target, cols));
      toast(`${row.DPP_NAME} RTU 정보를 저장했습니다. (${r.plant_id})`);
      $('plantBg').classList.remove('show');
      await refreshAfterSave('plant');
    } catch (err) { toast(err.message, true); }
  };
}

// RTU 관리 정보 탭 아래: 이 발전소에 연결된 장비·라우터와 그 비고 (비고는 장비·라우터 한 곳에만 적고 여기서 같이 봄)
async function plantLinksFill(row) {
  const box = $('rtmLinks');
  if (!row.plant_id) { box.innerHTML = '<div class="empty">연결된 장비·라우터가 없습니다.</div>'; return; }
  try {
    const [dev, rt] = await Promise.all([loadRows('device', true), loadRows('router', true)]);
    const mine = r => (r.linked_plants || []).includes(row.plant_id);
    const label = r => (r.link_labels || {})[row.plant_id] || '';
    const items = [
      ...dev.filter(mine).map(r => ({ key: 'device', r, kind: r.device_type || 'RTU', id: r.device_id, no: r.serial_no || 'S/N 없음', date: r.install_date })),
      ...rt.filter(mine).map(r => ({ key: 'router', r, kind: '라우터', id: r.router_id, no: r.ctn || r.serial_no || '', date: r.installed_at })),
    ];
    if (!items.length) { box.innerHTML = '<div class="empty">연결된 장비·라우터가 없습니다.</div>'; return; }
    box.innerHTML = `<div class="panel"><div class="tablewrap" style="max-height:none"><table class="links">
      <thead><tr><th>구분</th><th>ID</th><th>S/N · CTN</th><th>연결 구분</th><th>상태</th><th>설치일</th><th>비고</th></tr></thead>
      <tbody>${items.map((x, i) => `<tr data-link="${i}">
        <td>${esc(x.kind)}</td><td>${esc(x.id)}</td><td>${esc(x.no)}</td><td>${esc(label(x.r))}</td>
        <td>${esc(x.r.status)}</td><td>${esc(x.date)}</td><td class="note">${esc(x.r.note)}</td></tr>`).join('')}</tbody>
    </table></div></div>`;
    const reopen = async () => {
      const plants = await loadRows('plant', true);
      openPlant(plants.find(p => p.keyno === row.keyno) || row, 'rtm');
    };
    box.querySelectorAll('tr[data-link]').forEach(tr => tr.onclick = () => {
      const x = items[Number(tr.dataset.link)];
      openRow(x.key, x.r, { onDone: reopen });
    });
  } catch (err) { box.innerHTML = `<div class="empty">${esc(err.message)}</div>`; }
}

const DPP_FORM = [
  { f: 'DPP_NAME', label: '발전소명', req: true, rtu: true },
  { f: 'DPP_STATUS', label: '개통 상태', type: 'status', req: true },
  { f: 'DPP_USER', label: '회원', type: 'member', req: true },
  { f: 'DPP_VOLUM', label: '설치 용량 (kW)', rtu: true },
  { f: 'DPP_AREA', label: '지역', help: '예: 나주, 광주' },
  { f: 'DPP_LOCATION', label: '주소', type: 'address', wide: 'full' },
  { f: 'DPP_X_LOCATION', label: 'X좌표 (위도)' },
  { f: 'DPP_Y_LOCATION', label: 'Y좌표 (경도)' },
  { f: 'DPP_INVER', label: '인버터 (제조사)' },
  { f: 'DPP_INVER_COUNT', label: '인버터 대수', rtu: true },
  { f: 'DPP_OTHER_VOLUM', label: '인버터별 용량 (쉼표)', wide: 'w2' },
  { f: 'DPP_SN', label: '인버터 S/N (쉼표, 없으면 00)', wide: 'full' },
];

function dppFieldHtml(c, v) {
  let input;
  if (c.type === 'status') input = `<select name="${c.f}">${options(Object.entries(STATUS).map(([k, l]) => ({ v: k, l: `${l} (${k})` })), v, false)}</select>`;
  else if (c.type === 'member') input = `<select name="${c.f}">${options(S.lookups.members.map(m => ({ v: m.keyno, l: `${m.id}${m.name ? ' · ' + m.name : ''}` })), v)}</select>`;
  else if (c.type === 'address') input = `<div class="inline"><input name="${c.f}" value="${esc(v)}" placeholder="우편번호//주소"><button type="button" class="btn" data-postcode>주소 검색</button><button type="button" class="btn" data-geo>좌표 찾기</button></div><div id="map"></div>`;
  else input = `<input name="${c.f}" value="${esc(v)}">`;
  return `<div class="field ${c.wide || ''} ${c.rtu ? 'rtuwarn' : ''}"><label>${esc(c.label)}${c.req ? ' <b>*</b>' : ''}${c.rtu ? ' ⚠' : ''}</label>${input}${c.help ? `<div class="help">${esc(c.help)}</div>` : ''}</div>`;
}

async function plantDppTab(row) {
  $('ptBody').innerHTML = '<p class="sub">불러오는 중…</p>';
  let data;
  try { data = await api('GET', `api/power/${row.keyno}`); } catch (err) { toast(err.message, true); return; }
  const d = data.row;
  $('ptBody').innerHTML = `<form id="dppForm" novalidate>
    <div class="warnbox">이 정보는 모니터링 홈페이지·앱의 발전소 정보(dy_power_plant)입니다. 저장하면 홈페이지에 바로 반영됩니다.<br>
      ⚠ 표시 칸(발전소명·설치 용량·인버터 대수)은 현장 RTU 수집 프로그램이 읽는 값이라, 바꾸면 수집에도 영향이 있습니다.</div>
    <div class="formgrid">${DPP_FORM.map(c => dppFieldHtml(c, d[c.f])).join('')}</div>
    <div class="modalfoot"><div class="r"><button type="button" class="btn" data-close>닫기</button><button class="btn primary">모니터링에 저장</button></div></div></form>`;
  const form = $('dppForm');
  bindAddress(form);
  form.onsubmit = async e => {
    e.preventDefault();
    const body = {};
    for (const c of DPP_FORM) {
      const v = form.elements[c.f].value.trim();
      if (v !== String(d[c.f] ?? '')) body[c.f] = v;
    }
    if (!Object.keys(body).length) { toast('바뀐 값이 없습니다.'); return; }
    const rtuChanged = Object.keys(body).filter(f => data.rtuReadFields.includes(f));
    const names = Object.keys(body).map(f => DPP_FORM.find(c => c.f === f).label).join(', ');
    if (!confirm(`모니터링 발전소 정보를 바꿉니다.\n바뀌는 칸: ${names}` +
      (rtuChanged.length ? `\n\n⚠ RTU 수집에 쓰이는 값이 바뀝니다. 현장 수집 결과를 꼭 확인하세요.` : ''))) return;
    try {
      await api('PUT', `api/power/${row.keyno}`, body);
      toast('모니터링 발전소 정보를 저장했습니다.');
      $('plantBg').classList.remove('show');
      await refreshAfterSave('plant');
    } catch (err) { toast(err.message, true); }
  };
}

async function plantLogTab(row) {
  $('ptBody').innerHTML = '<p class="sub">불러오는 중…</p>';
  try {
    // 발전소 정보 변경 + 이 발전소의 세팅·인버터·장애·장비/라우터 연결 이력
    const { rows } = await api('GET', `api/logs?keyno=${row.keyno}${row.plant_id ? '&plant=' + row.plant_id : ''}`);
    $('ptBody').innerHTML = '<p class="sub">이 발전소의 정보 변경과, 이 발전소에 붙은 세팅출고·인버터구성·작업장애·장비/라우터 연결 변경을 모두 보여줍니다.</p>'
      + logTable(rows) + '<div class="modalfoot"><div class="r"><button type="button" class="btn" data-close>닫기</button></div></div>';
  } catch (err) { toast(err.message, true); }
}

// ─── 주소 검색·좌표 (다음 우편번호 / 카카오 지도) ───────────────────────────
let kakaoReady = null;
function loadKakao() {
  if (!S.me.kakaoKey) return Promise.reject(new Error('카카오 지도 키(KAKAO_JS_KEY)가 설정되지 않았습니다. 좌표는 직접 입력하세요.'));
  if (!kakaoReady) {
    kakaoReady = new Promise((resolve, reject) => {
      const sc = document.createElement('script');
      sc.src = `https://dapi.kakao.com/v2/maps/sdk.js?appkey=${encodeURIComponent(S.me.kakaoKey)}&libraries=services&autoload=false`;
      sc.onload = () => window.kakao.maps.load(resolve);
      sc.onerror = () => { kakaoReady = null; reject(new Error('카카오 지도를 불러오지 못했습니다. 허용 도메인을 확인하세요.')); };
      document.head.appendChild(sc);
    });
  }
  return kakaoReady;
}

function bindAddress(form) {
  const loc = form.elements.DPP_LOCATION;
  form.querySelector('[data-postcode]').onclick = () => {
    if (!window.daum || !window.daum.Postcode) { toast('우편번호 검색을 불러오지 못했습니다.', true); return; }
    new window.daum.Postcode({
      oncomplete: data => {
        loc.value = `${data.zonecode}//${data.roadAddress || data.jibunAddress}`;
        geocode(form);
      },
    }).open();
  };
  form.querySelector('[data-geo]').onclick = () => geocode(form);
}

async function geocode(form) {
  const addr = (form.elements.DPP_LOCATION.value.split('//')[1] || form.elements.DPP_LOCATION.value).trim();
  if (!addr) { toast('주소를 먼저 입력하세요.', true); return; }
  try {
    await loadKakao();
    const k = window.kakao.maps;
    new k.services.Geocoder().addressSearch(addr, (result, status) => {
      if (status !== k.services.Status.OK) { toast('주소로 위치를 찾지 못했습니다. 좌표를 직접 입력하세요.', true); return; }
      const box = form.querySelector('#map');
      box.style.display = 'block';
      const pos = new k.LatLng(result[0].y, result[0].x);
      const map = new k.Map(box, { center: pos, level: 3 });
      const marker = new k.Marker({ position: pos, map });
      const set = ll => { form.elements.DPP_X_LOCATION.value = ll.getLat(); form.elements.DPP_Y_LOCATION.value = ll.getLng(); };
      set(pos);
      k.event.addListener(map, 'click', ev => { marker.setPosition(ev.latLng); set(ev.latLng); });
      toast('좌표를 채웠습니다. 위치가 다르면 지도를 눌러 옮기세요.');
    });
  } catch (err) { toast(err.message, true); }
}

// ─── 발전소 묶음 등록 ────────────────────────────────────────────────────────
function modelRow() {
  return `<div class="modelrow"><input name="maker" placeholder="제조사 (예: sofar)"><input name="model" placeholder="모델명">
    <input name="unit_kw" placeholder="대당 용량 (kW)" inputmode="decimal"><input name="qty" placeholder="수량" inputmode="numeric">
    <button type="button" class="btn" data-rm title="줄 삭제">×</button></div>`;
}

function openBundle() {
  const f = $('bundleForm');
  const plantCols = sheet('plant').columns.filter(c => !c.join && !c.hidden && c.f !== 'use_yn');
  f.innerHTML = `
    <h2>발전소 묶음 등록</h2>
    <p class="sub">한 번 저장하면 ① 모니터링 홈페이지·앱에 발전소가 등록되고(새 발전소 번호 발급) ② RTU 관리 정보 ③ 세팅 작업 ④ 인버터 구성이 함께 만들어집니다. 중간에 하나라도 실패하면 아무것도 저장되지 않습니다.</p>
    <div class="formgrid">
      <div class="group"><h3>① 모니터링 발전소 정보</h3><p>홈페이지 "발전소 등록"과 같은 내용입니다. 새 발전소는 보통 "미개통"으로 등록하고, 수집이 확인되면 "개통"으로 바꿉니다.</p></div>
      ${DPP_FORM.filter(c => !['DPP_INVER', 'DPP_INVER_COUNT', 'DPP_OTHER_VOLUM', 'DPP_SN'].includes(c.f))
        .map(c => dppFieldHtml({ ...c, rtu: false }, c.f === 'DPP_STATUS' ? 'N' : '')).join('')}
      <div class="group"><h3>② 인버터 구성 <b style="color:var(--red)">*</b></h3>
        <p>모델별로 한 줄씩 적고 수량을 넣으면, 저장할 때 인버터 한 대에 한 줄씩 나눠서 들어갑니다. 홈페이지의 인버터 종류·대수·인버터별 용량은 여기서 자동으로 채워집니다.</p>
        <div id="modelRows">${modelRow()}</div><button type="button" class="btn" id="addModel">＋ 인버터 모델 추가</button></div>
      <div class="field full"><label>인버터 S/N (선택, 쉼표나 줄바꿈으로 구분 — 없으면 대수만큼 00)</label><textarea name="sn"></textarea></div>
      <div class="group"><h3>③ RTU 관리 정보</h3><p>확인된 정보만 적고 모르면 비워 둡니다.</p></div>
      ${plantCols.map(c => fieldHtml(c, '')).join('')}
      <div class="field w2"><label>LTE 라우터 연결</label><select name="routerId">${routerOptions('')}</select>
        <div class="help">무선이면 설치할 라우터를 고릅니다. 라우터가 여러 대면 등록 후 라우터관리에서 추가로 연결하세요.</div></div>
      <div class="field w2"><label class="check" style="font-weight:normal"><input type="checkbox" name="makeDevice"> 새 RTU 만들기</label>
        ${serialPartsHtml('newDeviceSerial', true)}
        <div class="help">고르면 다음 S/N으로 장비가 만들어지고 이 발전소·세팅 작업에 연결됩니다.</div></div>
      <div class="group"><label class="check"><input type="checkbox" name="makeSetup" checked> ④ 세팅 작업도 함께 등록</label>
        <p>체크하면 세팅출고에 작업이 생기고, 위 인버터 구성이 그 작업과 연결됩니다.</p></div>
      ${['kind', 'due_date', 'due_time', 'owner'].map(fname => fieldHtml(sheet('setup').columns.find(c => c.f === fname), fname === 'kind' ? '신규' : '')).join('')}
    </div>
    <div class="modalfoot"><div class="r"><button type="button" class="btn" data-close>취소</button><button class="btn primary">한 번에 등록</button></div></div>`;
  bindAddress(f);
  bindSerialParts(f);
  f.elements.makeDevice.onchange = e => { f.querySelector('[data-serial]').style.display = e.target.checked ? '' : 'none'; };
  $('addModel').onclick = () => $('modelRows').insertAdjacentHTML('beforeend', modelRow());
  $('modelRows').onclick = e => { if (e.target.dataset.rm !== undefined && $('modelRows').children.length > 1) e.target.closest('.modelrow').remove(); };
  f.onsubmit = async e => {
    e.preventDefault();
    const el = f.elements;
    const power = {};
    for (const c of DPP_FORM) if (el[c.f]) power[c.f] = el[c.f].value;
    const inverters = [...$('modelRows').querySelectorAll('.modelrow')].map(r => ({
      maker: r.querySelector('[name=maker]').value, model: r.querySelector('[name=model]').value,
      unit_kw: r.querySelector('[name=unit_kw]').value, qty: r.querySelector('[name=qty]').value,
    }));
    const rtm = readForm(f, plantCols);
    const makeSetup = el.makeSetup.checked;
    const setup = { kind: el.kind.value, due_date: el.due_date.value, due_time: el.due_time.value, owner: el.owner.value };
    if (!confirm(`"${power.DPP_NAME || ''}" 발전소를 모니터링에 새로 등록합니다. 계속할까요?`)) return;
    try {
      const r = await api('POST', 'api/bundle', { power, inverters, sn: el.sn.value, rtm, makeSetup, setup, newDeviceSerial: el.makeDevice.checked ? el.newDeviceSerial.value : '', routerId: el.routerId.value });
      $('bundleBg').classList.remove('show');
      toast(`등록 완료: 발전소 번호 ${r.keyno} · ${r.plant_id}${r.setup_id ? ' · ' + r.setup_id : ''}${r.serial_no ? ' · RTU ' + r.serial_no : ''} · 인버터 ${r.inv_ids.length}줄`);
      S.plantFilter = 'all';
      await refreshAfterSave('plant');
    } catch (err) { toast(err.message, true); }
  };
  $('bundleBg').classList.add('show');
}

// ─── 세팅 요청서 올리기 ──────────────────────────────────────────────────────
// 요청서 엑셀(시트 하나 = 발전소 하나)을 읽어 확인 화면에 보여주고, 고친 뒤 한 번에 등록한다.
function openSetupForm() {
  const m = $('formModal');
  m.innerHTML = `
    <h2>세팅 요청서 올리기</h2>
    <p class="sub">"다르고스 세팅 양식"으로 받은 엑셀을 고르면 시트마다 발전소·인버터·기한을 읽어 옵니다. 읽은 값은 모두 고칠 수 있습니다.<br>
      교체이거나 홈페이지에 이미 등록된 신규 발전소면 그 발전소를 고르고, 아직 없는 신규 발전소면 "모니터링에 새 발전소로 등록"을 고르세요.</p>
    <div class="inline"><input type="file" id="formFile" accept=".xlsx,.xlsm,.xls"></div>
    <div id="formCards"></div>
    <div class="modalfoot"><div class="r"><button type="button" class="btn" data-close>닫기</button>
      <button type="button" class="btn primary" id="formSave" disabled>선택한 요청서 등록</button></div></div>`;
  $('formFile').onchange = async e => {
    const file = e.target.files[0];
    if (!file) return;
    try {
      const data = await new Promise((ok, fail) => {
        const r = new FileReader();
        r.onload = () => ok(String(r.result).split(',')[1]);
        r.onerror = () => fail(new Error('파일을 읽지 못했습니다.'));
        r.readAsDataURL(file);
      });
      const parsed = await api('POST', 'api/setup-form/parse', { fileName: file.name, data });
      renderFormCards(parsed);
    } catch (err) { toast(err.message, true); }
  };
  $('formSave').onclick = saveSetupForms;
  $('formBg').classList.add('show');
}

function plantKeynoOptions(sheet) {
  const top = (sheet.match.keynos || []).map((k, i) => `<option value="${k}">✓ ${esc(sheet.match.verdict)}: ${k} · ${esc(sheet.match.names[i] || '')}</option>`).join('');
  const all = S.lookups.plants.map(p => `<option value="${p.keyno}">${esc(plantLabel(p))}${p.status !== 'Y' ? ' (' + esc(STATUS[p.status] || p.status) + ')' : ''}</option>`).join('');
  return `<option value="">발전소 선택</option>${top}<option value="new">＋ 모니터링에 새 발전소로 등록</option><optgroup label="전체 발전소">${all}</optgroup>`;
}

function renderFormCards(parsed) {
  const box = $('formCards');
  box.innerHTML = parsed.sheets.map((sh, i) => {
    return `<form class="formcard" data-i="${i}" novalidate>
      <div class="formcard-head">
        <label class="check"><input type="checkbox" name="pick" ${sh.existing_setup ? '' : 'checked'}> ${esc(sh.src_sheet)} · ${esc(sh.name || '(이름 없음)')}</label>
        <span class="tag ${sh.kind === '교체' ? 'N' : 'Y'}">${esc(sh.kind || '신규/교체 미기재')}</span>
      </div>
      ${sh.existing_setup ? `<div class="warnbox">이미 ${esc(sh.existing_setup)}(으)로 등록한 요청서입니다. 다시 등록하려면 체크하세요.</div>` : ''}
      ${sh.warnings.length ? `<div class="warnbox">${sh.warnings.map(esc).join('<br>')}</div>` : ''}
      <div class="formgrid">
        <div class="field w2"><label>발전소 <b>*</b></label><select name="target">${plantKeynoOptions(sh)}</select>
          <div class="help">요청서 이름 "${esc(sh.name)}" → ${esc(sh.match.verdict)}${sh.match.why ? ' (' + esc(sh.match.why) + ')' : ''}</div></div>
        <div class="field"><label>신규·교체</label><select name="kind">${options([{ v: '신규', l: '신규' }, { v: '교체', l: '교체' }], sh.kind)}</select></div>
        <div class="field"><label>유/무선</label><select name="comm">${options([{ v: '무선', l: '무선' }, { v: '유선', l: '유선' }], sh.comm)}</select></div>
        <div class="field"><label>용량 (kW)</label><input name="capacity" value="${esc(sh.capacity)}"></div>
        <div class="field w2"><label>주소</label><input name="address" value="${esc(sh.address)}"></div>
        <div class="field"><label>담당자</label><input name="owner" value="${esc(sh.owner)}"></div>
        <div class="field"><label>세팅 기한</label><input type="date" name="due_date" value="${esc(sh.due_date)}"></div>
        <div class="field"><label>오전·오후</label><input name="due_time" value="${esc(sh.due_time)}"></div>
        <div class="field w2"><label class="check" style="font-weight:normal"><input type="checkbox" name="makeDevice"> 새 RTU 만들기</label>${serialPartsHtml('newDeviceSerial', true)}</div>
        <div class="group"><h3>인버터 구성</h3><div data-rows>${(sh.inverters.length ? sh.inverters : [{}]).map(modelRowFilled).join('')}</div>
          <button type="button" class="btn" data-addrow>＋ 인버터 모델 추가</button></div>
        <div class="group" data-newplant style="display:none"><h3>모니터링에 새 발전소로 등록</h3>
          <p>홈페이지 "발전소 등록"과 같은 내용입니다. 저장하면 새 발전소 번호가 발급되고 홈페이지·앱에 나타납니다.</p></div>
        ${DPP_FORM.filter(c => !['DPP_INVER', 'DPP_INVER_COUNT', 'DPP_OTHER_VOLUM', 'DPP_SN'].includes(c.f))
          .map(c => dppFieldHtml({ ...c, rtu: false }, { DPP_NAME: (sh.name || '').slice(0, 30), DPP_STATUS: 'N', DPP_VOLUM: sh.capacity, DPP_LOCATION: sh.address }[c.f] || ''))
          .map(x => x.replace('class="field', 'data-newplant style="display:none" class="field')).join('')}
        <div class="field w2" data-newplant style="display:none"><label>LTE 라우터 연결</label><select name="routerId">${routerOptions('')}</select></div>
      </div>
    </form>`;
  }).join('');
  box.querySelectorAll('.formcard').forEach((f, i) => {
    const sh = parsed.sheets[i];
    f._sheet = sh;
    const one = sh.match.keynos.length === 1 && ['일치', '추정'].includes(sh.match.verdict);
    f.elements.target.value = one ? String(sh.match.keynos[0]) : (sh.kind === '교체' ? '' : 'new');
    const showNew = () => f.querySelectorAll('[data-newplant]').forEach(x => { x.style.display = f.elements.target.value === 'new' ? '' : 'none'; });
    f.elements.target.onchange = showNew;
    showNew();
    bindSerialParts(f);
    f.elements.makeDevice.onchange = e => {
      f.querySelector('[data-serial]').style.display = e.target.checked ? '' : 'none';
      if (e.target.checked) bumpSerial(f);
    };
    f.querySelector('[data-addrow]').onclick = () => f.querySelector('[data-rows]').insertAdjacentHTML('beforeend', modelRowFilled({}));
    f.querySelector('[data-rows]').onclick = e => { if (e.target.dataset.rm !== undefined && f.querySelectorAll('.modelrow').length > 1) e.target.closest('.modelrow').remove(); };
    if (f.querySelector('[data-postcode]')) bindAddress(f);
  });
  $('formSave').disabled = false;
}

// 같은 화면에서 새 RTU 를 여러 개 만들면 번호가 겹치지 않게 하나씩 올린다
function bumpSerial(form) {
  const taken = [...document.querySelectorAll('.formcard')].filter(f => f !== form && f.elements.makeDevice.checked)
    .map(f => f.elements.newDeviceSerial.value);
  const no = form.querySelector('[data-p="no"]');
  while (taken.includes(form.elements.newDeviceSerial.value)) {
    no.value = String(Number(no.value) + 1).padStart(4, '0');
    no.dispatchEvent(new Event('input'));
  }
}

function modelRowFilled(it) {
  return `<div class="modelrow"><input name="maker" placeholder="제조사 (예: sofar)" value="${esc(it.maker)}"><input name="model" placeholder="모델명" value="${esc(it.model)}">
    <input name="unit_kw" placeholder="대당 용량 (kW)" inputmode="decimal" value="${esc(it.unit_kw)}"><input name="qty" placeholder="수량" inputmode="numeric" value="${esc(it.qty)}">
    <button type="button" class="btn" data-rm title="줄 삭제">×</button></div>`;
}

async function saveSetupForms() {
  const items = [];
  for (const f of document.querySelectorAll('.formcard')) {
    if (!f.elements.pick.checked) continue;
    const sh = f._sheet;
    const el = f.elements;
    const target = el.target.value;
    if (!target) { toast(`${sh.src_sheet}: 발전소를 고르세요.`, true); return; }
    const item = {
      mode: target === 'new' ? 'new' : 'existing', keyno: target === 'new' ? null : Number(target),
      allowDuplicate: !!sh.existing_setup,
      form: { name: sh.name, capacity: el.capacity.value, address: el.address.value, kind: el.kind.value, comm: el.comm.value,
        due_date: el.due_date.value, due_time: el.due_time.value, owner: el.owner.value, src_file: sh.src_file, src_sheet: sh.src_sheet },
      inverters: [...f.querySelectorAll('.modelrow')].map(r => ({ maker: r.querySelector('[name=maker]').value, model: r.querySelector('[name=model]').value,
        unit_kw: r.querySelector('[name=unit_kw]').value, qty: r.querySelector('[name=qty]').value })),
      newDeviceSerial: el.makeDevice.checked ? el.newDeviceSerial.value : '',
    };
    if (item.mode === 'new') {
      item.power = {};
      for (const c of DPP_FORM) if (el[c.f]) item.power[c.f] = el[c.f].value;
      item.rtm = { comm_type: el.comm.value };
      item.routerId = el.routerId.value;
    }
    items.push(item);
  }
  if (!items.length) { toast('등록할 요청서를 체크하세요.', true); return; }
  const news = items.filter(x => x.mode === 'new').length;
  if (!confirm(`요청서 ${items.length}건을 등록합니다.${news ? `\n그중 ${news}건은 모니터링 홈페이지에 새 발전소로 등록됩니다.` : ''}\n계속할까요?`)) return;
  try {
    const r = await api('POST', 'api/setup-form/save', { items });
    $('formBg').classList.remove('show');
    toast(r.results.map(x => `${x.setup_id}${x.mode === 'new' ? ' (새 발전소 번호 ' + x.keyno + ')' : ' (발전소 번호 ' + x.keyno + ')'}${x.serial_no ? ' · ' + x.serial_no : ''}`).join(', ') + ' 등록 완료');
    await refreshAfterSave('setup');
  } catch (err) { toast(err.message, true); }
}

// ─── 변경 이력 ────────────────────────────────────────────────────────────
const TABLE_NAMES = {
  dy_power_plant: '모니터링 발전소', rtm_plant: '발전소장비', rtm_setup: '세팅출고', rtm_inverter: '인버터구성',
  rtm_device: '장비이력', rtm_device_plant: '장비 연결', rtm_issue: '작업장애', rtm_router: '라우터관리', rtm_router_plant: '라우터 연결', rtm_hw_version: '하드웨어 버전', rtm_sw_version: 'SW 버전', import: '엑셀 이관',
};
const ACTIONS = { insert: '추가', update: '수정', delete: '삭제' };
const EXTRA_LABELS = { dpp_keyno: '발전소 번호', plants: '연결 발전소', labels: '연결 구분', DPP_SN_NUM: 'S/N 변환값', DPP_DATE: '등록일', DPP_DEL_YN: '삭제 여부' };
// 이력의 컬럼 이름을 화면 이름으로
function fieldLabel(k, table) {
  const d = DPP_FORM.find(c => c.f === k);
  if (d) return d.label;
  if (EXTRA_LABELS[k]) return EXTRA_LABELS[k];
  const own = S.meta.sheets.find(x => x.table === table);
  const oc = own && own.columns.find(x => x.f === k);
  if (oc) return oc.label;
  for (const s of S.meta.sheets) { const c = s.columns.find(x => x.f === k); if (c) return c.label; }
  return k;
}

// 이력 한 줄의 칸 목록: 추가·삭제는 값이 있는 칸, 수정은 바뀐 칸만 (전·후)
function diffItems(r) {
  let b = null;
  let a = null;
  try { b = r.before_json ? JSON.parse(r.before_json) : null; a = r.after_json ? JSON.parse(r.after_json) : null; } catch { /* 깨진 기록 */ }
  const skip = k => ['created_at', 'updated_at'].includes(k);
  const fmt = v => (v == null || v === '' ? '(빈칸)'
    : Array.isArray(v) ? (v.length ? v.join(', ') : '(없음)')
      // 연결 구분 { 발전소 ID: 구분 } → "발전소명: 구분"
      : typeof v === 'object' ? Object.entries(v).map(([k, x]) => { const p = plantByValue(k); return `${p ? p.name : k}: ${x ?? '(빈칸)'}`; }).join(', ') || '(없음)'
        : String(v));
  if (r.action === 'insert' || r.action === 'delete') {
    const o = a || b || {};
    return Object.keys(o).filter(k => o[k] !== null && o[k] !== '' && !skip(k))
      .map(k => ({ label: fieldLabel(k, r.table_name), value: fmt(o[k]) }));
  }
  return [...new Set([...Object.keys(b || {}), ...Object.keys(a || {})])]
    .filter(k => !skip(k) && JSON.stringify((b || {})[k] ?? null) !== JSON.stringify((a || {})[k] ?? null))
    .map(k => ({ label: fieldLabel(k, r.table_name), before: fmt((b || {})[k]), after: fmt((a || {})[k]) }));
}

// 표에 보이는 한 줄 요약
function diffSummary(r) {
  const items = diffItems(r);
  if (!items.length) return r.action === 'update' ? '(바뀐 값 없음)' : '';
  if (r.action === 'update') {
    const f = items[0];
    return `${f.label}: ${f.before} → ${f.after}${items.length > 1 ? ` 외 ${items.length - 1}칸` : ''}`;
  }
  return items.slice(0, 3).map(x => `${x.label}: ${x.value}`).join(' · ') + (items.length > 3 ? ` 외 ${items.length - 3}칸` : '');
}

const LOG_ROWS = new Map(); // log_id → 이력 (상세 창용)

function logTable(rows) {
  if (!rows.length) return '<div class="empty">기록이 없습니다.</div>';
  rows.forEach(r => LOG_ROWS.set(String(r.log_id), r));
  return `<div class="panel"><div class="tablewrap"><table class="log"><thead><tr><th>일시</th><th>사용자</th><th>발전소</th><th>대상</th><th>키</th><th>작업</th><th>내용 (누르면 자세히)</th></tr></thead><tbody>
    ${rows.map(r => {
      const sum = diffSummary(r);
      return `<tr data-log="${esc(r.log_id)}"><td>${esc(r.created_at)}</td><td>${esc(r.username)}</td><td class="pname">${esc(r.plant_names || '')}</td>
      <td>${esc(TABLE_NAMES[r.table_name] || r.table_name)}</td><td>${esc(r.row_key)}</td><td>${esc(ACTIONS[r.action] || r.action)}</td><td class="sum" title="${esc(sum)}">${esc(sum)}</td></tr>`;
    }).join('')}
  </tbody></table></div></div>`;
}

function openLogDetail(r) {
  const items = diffItems(r);
  const body = r.action === 'update'
    ? `<table class="logdetail"><thead><tr><th>칸</th><th>바뀌기 전</th><th>바뀐 후</th></tr></thead><tbody>
        ${items.map(x => `<tr><td>${esc(x.label)}</td><td><s>${esc(x.before)}</s></td><td><ins>${esc(x.after)}</ins></td></tr>`).join('') || '<tr><td colspan="3">(바뀐 값 없음)</td></tr>'}</tbody></table>`
    : `<table class="logdetail"><thead><tr><th>칸</th><th>${r.action === 'delete' ? '삭제된 값' : '값'}</th></tr></thead><tbody>
        ${items.map(x => `<tr><td>${esc(x.label)}</td><td>${esc(x.value)}</td></tr>`).join('')}</tbody></table>`;
  $('logModal').innerHTML = `
    <h2>${esc(TABLE_NAMES[r.table_name] || r.table_name)} ${esc(r.row_key)} · ${esc(ACTIONS[r.action] || r.action)}</h2>
    <p class="sub">${esc(r.created_at)} · ${esc(r.username || '')}${r.plant_names ? ' · ' + esc(r.plant_names) : ''}</p>
    ${body}
    <div class="modalfoot"><div class="r"><button type="button" class="btn" data-close>닫기</button></div></div>`;
  $('logBg').classList.add('show');
}

document.addEventListener('click', e => {
  const tr = e.target.closest('tr[data-log]');
  if (tr && LOG_ROWS.has(tr.dataset.log)) openLogDetail(LOG_ROWS.get(tr.dataset.log));
});

let logKey = '';
function openLogsFor(table, key) { logKey = key || ''; S.logPlant = null; S.logFilter = table || ''; show('logs'); }

// 변경 이력은 한 달씩 본다 (처음엔 이번 달). 한 대상(키)의 이력을 볼 때는 달 구분 없이 전부.
const thisMonth = () => { const d = new Date(); return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`; };
const shiftMonth = (ym, n) => { const [y, m] = ym.split('-').map(Number); const d = new Date(y, m - 1 + n, 1); return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`; };
const monthLabel = ym => `${ym.slice(0, 4)}년 ${Number(ym.slice(5))}월`;

// 보기 방식: 한 달(기본) / 발전소 하나(S.logPlant, 달 구분 없음) / 한 대상 키(logKey, 달 구분 없음)
async function renderLogs() {
  if (!S.logMonth) S.logMonth = thisMonth();
  const qs = new URLSearchParams();
  if (S.logFilter) qs.set('table', S.logFilter);
  if (logKey) qs.set('key', logKey);
  else if (S.logPlant) {
    qs.set('keyno', S.logPlant.keyno);
    if (S.logPlant.plant_id) qs.set('plant', S.logPlant.plant_id);
  } else qs.set('month', S.logMonth);
  const [{ rows }, { months }] = await Promise.all([api('GET', 'api/logs?' + qs), api('GET', 'api/logs/months')]);
  const byMonth = !logKey && !S.logPlant;
  const list = months.some(x => x.month === S.logMonth) ? months : [{ month: S.logMonth, n: 0 }, ...months].sort((a, b) => b.month.localeCompare(a.month));
  // 검색 칸: 발전소를 고르면 그 발전소 이력 전체, 글자는 지금 보이는 이력에서 걸러 보기 (다른 페이지와 같은 칸)
  const lp = S.logPlant ? S.lookups.plants.find(p => String(p.keyno) === String(S.logPlant.keyno)) : null;
  S.seekPick = lp ? plantPick(lp) : null;
  const nav = byMonth
    ? `<div class="monthnav">
        <button class="btn" id="prevMonth">이전 달</button>
        <select id="pickMonth">${list.map(x => `<option value="${x.month}" ${x.month === S.logMonth ? 'selected' : ''}>${monthLabel(x.month)} (${x.n}건)</option>`).join('')}</select>
        <button class="btn" id="nextMonth" ${S.logMonth >= thisMonth() ? 'disabled' : ''}>다음 달</button></div>`
    : `<div class="monthnav"><button class="btn" id="byMonth">달별 보기로</button></div>`;
  const title = logKey ? '' : S.logPlant ? ` · ${esc(S.logPlant.name || '')}` : ` · ${monthLabel(S.logMonth)}`;
  const sub = logKey ? `키 ${esc(logKey)}의 이력 전체 · ` : S.logPlant ? `발전소 번호 ${esc(S.logPlant.keyno)}의 이력 전체 (발전소 정보·세팅·인버터·장애·장비/라우터 연결) · ` : '';
  const empty = logKey || S.logPlant ? '기록이 없습니다.' : monthLabel(S.logMonth) + '에는 아직 변경 이력이 없습니다.';
  $('view').innerHTML = `
    <div class="title"><div><h1>변경 이력${title}</h1><p>${sub}<span id="logCount"></span> · 누가 언제 무엇을 바꿨는지 남습니다</p></div>
      <div class="actions">${nav}</div></div>
    ${logKey ? '' : '<div class="seek combo" id="seek"></div>'}
    <div class="filters">${[['', '전체'], ...Object.entries(TABLE_NAMES)].map(([k, l]) =>
      `<button class="chip ${S.logFilter === k ? 'on' : ''}" data-lf="${k}">${esc(l)}</button>`).join('')}</div>
    <div id="logBody"></div>`;
  const drawLogs = () => {
    const q = S.seekPick ? '' : S.q.trim().toLowerCase();
    const shown = q ? rows.filter(r => JSON.stringify(r).toLowerCase().includes(q)) : rows;
    $('logCount').textContent = q ? `검색 결과 ${shown.length} / ${rows.length}건` : `${rows.length}건`;
    $('logBody').innerHTML = rows.length ? logTable(shown) : `<div class="empty">${empty}</div>`;
  };
  drawLogs();
  $('view').querySelectorAll('[data-lf]').forEach(b => b.onclick = () => { S.logFilter = b.dataset.lf; renderLogs(); });
  if ($('byMonth')) $('byMonth').onclick = () => { logKey = ''; S.logPlant = null; S.seekPick = null; S.q = ''; renderLogs(); };
  if ($('seek')) {
    seekBox($('seek'), {
      conf: SEEK.logs,
      onChange: full => {
        if (!full) { drawLogs(); return; }
        const p = pickedPlant();
        S.logPlant = p ? { keyno: p.keyno, plant_id: p.plant_id, name: p.name } : null;
        logKey = '';
        renderLogs().then(() => $('seek') && $('seek').querySelector('input').focus()).catch(err => toast(err.message, true));
      },
    });
  }
  if ($('prevMonth')) {
    $('prevMonth').onclick = () => { S.logMonth = shiftMonth(S.logMonth, -1); renderLogs(); };
    $('nextMonth').onclick = () => { S.logMonth = shiftMonth(S.logMonth, 1); renderLogs(); };
    $('pickMonth').onchange = e => { S.logMonth = e.target.value; renderLogs(); };
  }
}

// ─── 계정 ────────────────────────────────────────────────────────────────
$('logout').onclick = async () => { await api('POST', 'api/logout'); location.href = 'login.html'; };
$('pwBtn').onclick = () => { $('pwForm').reset(); $('pwBg').classList.add('show'); };
$('pwForm').onsubmit = async e => {
  e.preventDefault();
  const fd = new FormData(e.target);
  try {
    await api('POST', 'api/me/password', { current: fd.get('current'), next: fd.get('next') });
    $('pwBg').classList.remove('show');
    toast('비밀번호를 바꿨습니다.');
  } catch (err) { toast(err.message, true); }
};

init().catch(err => toast(err.message, true));
