/* 서류 폴더 자동 연결 — 폴더가 연결되지 않은 발전소에 NAS 폴더를 추천하고 한꺼번에 연결 */

const LEVELS = {
  sure:   { label: '확실',          cls: 'al-badge--sure',   desc: '발전소명·주소 등 두 가지 이상 일치' },
  likely: { label: '유력',          cls: 'al-badge--likely', desc: '한 가지만 일치 — 확인 필요' },
  multi:  { label: '후보 여러 개',  cls: 'al-badge--multi',  desc: '같은 현장 폴더가 여러 개 — 골라 주세요' },
  none:   { label: '못 찾음',       cls: 'al-badge--none',   desc: '[폴더 변경]으로 직접 골라 주세요' },
};

const al = {
  root: '',          // 발전소 폴더(plantRoot) — 경로 표시 기준
  plants: [],          // [{ id, plant_name, owner_name, address, level, cands }]
  linked: 0,
  pick: new Map(),     // 발전소 id → 고른 폴더 경로
  checked: new Set(),  // 체크한 발전소 id
  tab: 'all',
  q: '',
  done: new Map(),     // 방금 연결한 결과 id → { ok, folder | error }
  resolved: new Map(), // `${id}|${발전소 폴더}` → 실제로 연결될 폴더 (0. 공통서류 / 호기별 폴더)
  manualPath: new Map(), // 발전소 id → [폴더 변경]으로 직접 고른 폴더 (그대로 연결)
  useManual: new Set(),  // 직접 고른 폴더를 쓰기로 한 발전소 id
};
const MANUAL = '__manual__';

document.addEventListener('DOMContentLoaded', async () => {
  const ok = await checkLogin();
  if (!ok) return;
  bindLogout();

  document.getElementById('al-search').addEventListener('input', e => { al.q = e.target.value.trim(); render(); });
  document.getElementById('al-check-all').addEventListener('change', e => {
    for (const p of visiblePlants()) {
      if (!al.pick.get(p.id) || al.done.has(p.id)) continue;
      if (e.target.checked) al.checked.add(p.id); else al.checked.delete(p.id);
    }
    render();
  });
  document.getElementById('al-apply').addEventListener('click', apply);

  try {
    const st = await apiGet('api/nas/status');
    if (!st.enabled) throw new Error('NAS 연결이 설정되지 않았습니다.');
    al.root = st.plantRoot || st.root;
    nasUi.root = st.root;
    nasUi.plantRoot = st.plantRoot || st.root;
    await load();
  } catch (e) {
    document.getElementById('al-list').innerHTML = `<div class="al-empty nas-error">${escHtml(e.message)}</div>`;
  }
});

async function load() {
  const d = await apiGet('api/nas/auto-match');
  al.plants = d.plants;
  al.linked = d.linked;
  al.pick.clear(); al.checked.clear(); al.done.clear(); al.manualPath.clear(); al.useManual.clear();
  for (const p of al.plants) {
    // 확실·유력은 1순위 폴더를 미리 골라 둠, 체크는 확실만
    if ((p.level === 'sure' || p.level === 'likely') && p.cands.length) al.pick.set(p.id, p.cands[0].path);
    if (p.level === 'sure') al.checked.add(p.id);
  }
  render();
  resolvePicks();
}

// 고른 발전소 폴더마다 "실제로 연결될 폴더"를 NAS에서 확인 (50곳씩)
const rkey = (id, path) => `${id}|${path}`;
let resolving = false;
async function resolvePicks() {
  if (resolving) return;
  resolving = true;
  try {
    for (;;) {
      const todo = [...al.pick].filter(([id, path]) => !al.useManual.has(id) && !al.resolved.has(rkey(id, path)) && !al.done.has(id))
        .slice(0, 50).map(([id, path]) => ({ id, path }));
      if (!todo.length) break;
      let d;
      try { d = await apiSend('api/nas/resolve', 'POST', { items: todo }); }
      catch (e) { for (const t of todo) al.resolved.set(rkey(t.id, t.path), { error: e.message }); render(); break; }
      for (const r of d.results) al.resolved.set(rkey(r.id, r.path), r.error ? { error: r.error } : { folder: r.folder });
      render();
    }
  } finally { resolving = false; }
}

function visiblePlants() {
  const q = al.q.toLowerCase();
  return al.plants.filter(p =>
    (al.tab === 'all' || (al.tab === 'broken' ? !!p.broken : p.level === al.tab)) &&
    (!q || `${p.plant_name} ${p.owner_name || ''} ${p.address || ''}`.toLowerCase().includes(q)));
}

// NAS 경로 → "2025년 › 2. 공사완료(…)" (발전소 폴더 위쪽만)
function parentLabel(path) {
  const rel = path.startsWith(al.root + '/') ? path.slice(al.root.length + 1) : path;
  return rel.split('/').slice(0, -1).join(' › ');
}

function render() {
  // 탭
  const cnt = { all: al.plants.length, sure: 0, likely: 0, multi: 0, none: 0 };
  for (const p of al.plants) cnt[p.level]++;
  const brokenCnt = al.plants.filter(p => p.broken).length;
  document.getElementById('al-tabs').innerHTML =
    [['all', '전체'], ...Object.entries(LEVELS).map(([k, v]) => [k, v.label])]
      .map(([k, label]) => `<button type="button" class="al-tab${al.tab === k ? ' active' : ''}" data-tab="${k}">
        ${k !== 'all' ? `<span class="al-dot ${LEVELS[k].cls}"></span>` : ''}${label} <b>${cnt[k]}</b></button>`).join('')
    + (brokenCnt ? `<button type="button" class="al-tab al-tab--broken${al.tab === 'broken' ? ' active' : ''}" data-tab="broken">⚠ 연결 끊김 <b>${brokenCnt}</b></button>` : '')
    + `<span class="al-linked">이미 연결됨 ${al.linked}곳</span>`;
  document.querySelectorAll('.al-tab').forEach(b => b.addEventListener('click', () => { al.tab = b.dataset.tab; render(); }));

  // 목록
  const list = visiblePlants();
  const el = document.getElementById('al-list');
  if (!al.plants.length) {
    el.innerHTML = '<div class="al-empty">모든 발전소에 서류 폴더가 연결되어 있습니다. 👍</div>';
  } else if (!list.length) {
    el.innerHTML = '<div class="al-empty">조건에 맞는 발전소가 없습니다.</div>';
  } else {
    el.innerHTML = list.map(rowHtml).join('');
    bindRows(el);
  }
  updateFoot();
}

function rowHtml(p) {
  const lv = LEVELS[p.level];
  const done = al.done.get(p.id);
  const picked = al.pick.get(p.id);
  const chk = al.checked.has(p.id);

  const manual = al.manualPath.get(p.id);
  const useM = al.useManual.has(p.id);
  let right;
  if (done && done.ok) {
    right = `<div class="al-done">✅ 연결됨 <span class="al-path">${escHtml(parentLabel(done.folder + '/x'))}</span></div>`;
  } else {
    right = p.cands.length ? '' : '<div class="al-none">추천할 폴더를 찾지 못했습니다. [폴더 변경]으로 직접 골라 주세요.</div>';
    right += p.cands.map(c => {
      const on = !useM && picked === c.path;
      return `
      <label class="al-cand${on ? ' al-cand--on' : ''}">
        <input type="radio" name="al-r-${p.id}" value="${escHtml(c.path)}" ${on ? 'checked' : ''} />
        <span class="al-cand-body">
          <span class="al-cand-parent">${escHtml(parentLabel(c.path))}</span>
          <span class="al-cand-name">📁 ${escHtml(c.name)}</span>
          <span class="al-why">${c.why.map(w => `<span class="al-chip">${escHtml(w)} 일치</span>`).join('')}</span>
          ${on ? targetHtml(p.id, c.path) : ''}
        </span>
      </label>`;
    }).join('');
    if (manual) right += `
      <label class="al-cand al-cand--manual${useM ? ' al-cand--on' : ''}">
        <input type="radio" name="al-r-${p.id}" value="${MANUAL}" ${useM ? 'checked' : ''} />
        <span class="al-cand-body">
          <span class="al-cand-parent">✋ 직접 고른 폴더 — ${escHtml(parentLabel(manual))}</span>
          <span class="al-cand-name">📂 ${escHtml(manual.slice(manual.lastIndexOf('/') + 1))}</span>
          ${useM ? '<span class="al-target">→ 이 폴더 그대로 연결</span>' : ''}
        </span>
      </label>`;
    if (p.cands.length || manual) right += `<label class="al-cand al-cand--skip${!picked ? ' al-cand--on' : ''}">
          <input type="radio" name="al-r-${p.id}" value="" ${!picked ? 'checked' : ''} /> <span>연결 안 함</span></label>`;
    right += `<div class="al-change"><button type="button" class="btn btn-sm btn-outline" data-change>📂 폴더 변경</button></div>`;
    if (done && !done.ok) right += `<div class="nas-error al-err">⚠ ${escHtml(done.error)}</div>`;
  }

  return `
    <div class="al-row${chk ? ' al-row--on' : ''}${done && done.ok ? ' al-row--done' : ''}" data-id="${p.id}">
      <div class="al-check">${done && done.ok ? '' :
        `<input type="checkbox" data-chk ${chk ? 'checked' : ''} ${picked ? '' : 'disabled'} title="${picked ? '연결할 발전소로 선택' : '먼저 오른쪽에서 폴더를 골라 주세요'}" />`}</div>
      <div class="al-plant">
        <div class="al-plant-name">${escHtml(p.plant_name)}</div>
        <div class="al-plant-sub">${escHtml([p.owner_name, p.address].filter(Boolean).join(' · ') || '-')}</div>
        ${p.broken && !(done && done.ok) ? `<div class="al-broken" title="${escHtml(p.broken)}">⚠ 연결했던 폴더를 NAS에서 찾을 수 없습니다 (이름이 바뀌었거나 옮겨졌을 수 있음)<br><span>${escHtml(parentLabel(p.broken + '/x'))}</span></div>` : ''}
        <span class="al-badge ${lv.cls}" title="${escHtml(lv.desc)}">${lv.label}</span>
      </div>
      <div class="al-cands">${right}</div>
    </div>`;
}

// 고른 폴더 아래에 "연결될 폴더" 표시
function targetHtml(id, projectPath) {
  const r = al.resolved.get(rkey(id, projectPath));
  if (!r) return '<span class="al-target al-target--wait">연결될 폴더 확인 중...</span>';
  if (r.error) return `<span class="al-target nas-error">⚠ ${escHtml(r.error)}</span>`;
  const sub = r.folder.slice(projectPath.length + 1);
  return `<span class="al-target">→ 연결될 폴더: <b>${sub ? escHtml(sub.split('/').join(' › ')) : '발전소 폴더 그대로'}</b></span>`;
}

function bindRows(el) {
  el.querySelectorAll('.al-row').forEach(row => {
    const id = +row.dataset.id;
    row.querySelectorAll('input[type=radio]').forEach(r => r.addEventListener('change', () => {
      if (r.value === MANUAL) { al.useManual.add(id); al.pick.set(id, al.manualPath.get(id)); al.checked.add(id); }
      else if (r.value) { al.useManual.delete(id); al.pick.set(id, r.value); al.checked.add(id); }
      else { al.useManual.delete(id); al.pick.delete(id); al.checked.delete(id); }
      render();
      resolvePicks();
    }));
    const ch = row.querySelector('[data-change]');
    if (ch) ch.addEventListener('click', () => changeFolder(id));
    const c = row.querySelector('[data-chk]');
    if (c) c.addEventListener('change', () => { if (c.checked) al.checked.add(id); else al.checked.delete(id); render(); });
  });
}

// [폴더 변경] — 발전소 등록 화면과 같은 폴더 선택 창, 고른 폴더는 그대로 연결 (0. 공통서류로 내려가지 않음)
function changeFolder(id) {
  const p = al.plants.find(x => x.id === id);
  if (!p) return;
  const picked = al.pick.get(id);
  let start = picked;
  if (picked && !al.useManual.has(id)) {
    const r = al.resolved.get(rkey(id, picked));
    if (r && r.folder) start = r.folder;
  }
  openNasFolderDialog({
    startPath: start,
    plantId: id,
    subtitle: `${p.plant_name}${p.address ? ' · ' + p.address : ''}`,
    onPick: path => {
      al.manualPath.set(id, path);
      al.useManual.add(id);
      al.pick.set(id, path);
      al.checked.add(id);
      closeNasModal();
      render();
    },
    onCancel: closeNasModal,
  });
}

function selectedItems() {
  return [...al.checked].filter(id => al.pick.get(id) && !(al.done.get(id) || {}).ok)
    .map(id => {
      const p = al.plants.find(x => x.id === id);
      return { id, path: al.pick.get(id), exact: al.useManual.has(id), replace: (p && p.broken) || undefined };
    });
}

function updateFoot() {
  const n = selectedItems().length;
  document.getElementById('al-count').textContent = `${n}곳 선택`;
  document.getElementById('al-apply').disabled = !n;
  const vis = visiblePlants().filter(p => al.pick.get(p.id) && !(al.done.get(p.id) || {}).ok);
  const all = document.getElementById('al-check-all');
  all.checked = vis.length > 0 && vis.every(p => al.checked.has(p.id));
  all.indeterminate = !all.checked && vis.some(p => al.checked.has(p.id));
}

async function apply() {
  const items = selectedItems();
  if (!items.length) return;
  const ok = await confirmDialog(`선택한 ${items.length}곳에 서류 폴더를 연결할까요?\n(각 발전소의 '연결될 폴더'로 연결됩니다)`, '서류 폴더 연결');
  if (!ok) return;
  const btn = document.getElementById('al-apply');
  btn.disabled = true;
  btn.textContent = `연결하는 중... (${items.length}곳)`;
  try {
    const d = await apiSend('api/nas/auto-link', 'POST', { items });
    for (const r of d.results) al.done.set(r.id, r);
    al.linked += d.linked;
    const fail = d.results.length - d.linked;
    toast(`${d.linked}곳 연결했습니다.${fail ? ` ${fail}곳은 실패 — 목록에서 확인해 주세요.` : ''}`, fail ? 'error' : 'success');
  } catch (e) {
    toast(e.message || '연결하지 못했습니다.', 'error');
  }
  btn.textContent = '선택한 발전소 연결';
  render();
}
