/* 발전소 등록/수정 폼 로직 */

const FIELD_IDS = [
  'plant_name', 'owner_name', 'contact', 'address', 'capacity', 'install_type', 'memo',
  'power_biz_permit_scheduled', 'power_biz_permit_date', 'power_biz_permit_expire',
  'dev_permit_date', 'dev_permit_expire',
  'ppa_receive_date', 'ppa_receive_capacity',
  'dev_completion_date', 'commercial_operation_date',
];

const DATE_FIELD_IDS = [
  'power_biz_permit_scheduled', 'power_biz_permit_date', 'power_biz_permit_expire',
  'dev_permit_date', 'dev_permit_expire',
  'ppa_receive_date',
  'dev_completion_date', 'commercial_operation_date',
];
const DATE_YEAR_MIN = 1900;
const DATE_YEAR_MAX = 2100;

let currentId        = null;
let plantListAll     = [];
let ddActiveIdx      = 0;      // 발전소 드롭다운에서 키보드(↑↓)로 강조된 항목 인덱스

document.addEventListener('DOMContentLoaded', async () => {
  const ok = await checkLogin();
  if (!ok) return;
  bindLogout();

  initDropdown();
  initDevStatus();
  initDateValidation();
  loadPlantList();
  initFileImport();
  initNasDocs();

  document.getElementById('register-form').addEventListener('submit', onSave);
  document.getElementById('btn-reset').addEventListener('click', resetForm);
  document.getElementById('btn-delete').addEventListener('click', onDelete);

  const params  = new URLSearchParams(window.location.search);
  const idParam = params.get('id');
  if (idParam) {
    currentId = Number(idParam);
    loadPlant(currentId);
  }
});

/* ── 개발행위 구분 라디오 ────────────────────────────────────────────────── */
function initDevStatus() {
  document.querySelectorAll('input[name="dev_permit_status"]').forEach(r => {
    r.addEventListener('change', () => applyDevStatus(r.value));
  });
}

function applyDevStatus(val) {
  const hasStatus = val !== '';
  const fields = document.getElementById('dev-date-fields');
  fields.style.display = hasStatus ? 'none' : '';
  if (hasStatus) {
    document.getElementById('dev_permit_date').value = '';
    document.getElementById('dev_permit_expire').value = '';
  }
}

function setDevStatus(val) {
  const r = document.querySelector(`input[name="dev_permit_status"][value="${val}"]`);
  if (r) { r.checked = true; applyDevStatus(val); }
  else    { document.querySelector('input[name="dev_permit_status"][value=""]').checked = true; applyDevStatus(''); }
}

/* ── 날짜 유효성 검사 ────────────────────────────────────────────────────── */
function initDateValidation() {
  for (const f of DATE_FIELD_IDS) {
    const el = document.getElementById(f);
    if (!el) continue;
    el.addEventListener('input', () => clearDateError(el));
  }
}

function isValidDateValue(v) {
  if (!v) return true;
  const m = /^(\d{4})-(\d{2})-(\d{2})$/.exec(v);
  if (!m) return false;
  const year = Number(m[1]);
  return year >= DATE_YEAR_MIN && year <= DATE_YEAR_MAX;
}

function clearDateError(el) {
  el.classList.remove('input-error');
  const next = el.nextElementSibling;
  if (next && next.classList.contains('field-error-msg')) next.remove();
}

function clearAllDateErrors() {
  for (const f of DATE_FIELD_IDS) {
    const el = document.getElementById(f);
    if (el) clearDateError(el);
  }
}

function showDateError(el) {
  el.classList.add('input-error');
  const msg = document.createElement('div');
  msg.className = 'field-error-msg';
  msg.textContent = '날짜를 다시 확인해주세요';
  el.insertAdjacentElement('afterend', msg);
}

/* 유효하지 않은 날짜가 있으면 표시하고 첫 번째 오류 필드를 반환 (모두 유효하면 null) */
function validateDateFields() {
  clearAllDateErrors();
  let firstInvalid = null;
  for (const f of DATE_FIELD_IDS) {
    const el = document.getElementById(f);
    if (!el) continue;
    if (!isValidDateValue(el.value)) {
      showDateError(el);
      if (!firstInvalid) firstInvalid = el;
    }
  }
  return firstInvalid;
}

/* ── 커스텀 드롭다운 ─────────────────────────────────────────────────────── */
function initDropdown() {
  const trigger  = document.getElementById('plant-select-trigger');
  const search   = document.getElementById('plant-select-search');
  const wrap     = document.getElementById('plant-select-wrap');

  trigger.addEventListener('click', toggleDropdown);
  trigger.addEventListener('keydown', e => {
    if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggleDropdown(); }
    if (e.key === 'Escape') closeDropdown();
  });
  search.addEventListener('input', () => renderDropdownItems(search.value.trim()));
  search.addEventListener('keydown', e => {
    if (e.key === 'Escape') closeDropdown();
    else if (e.key === 'ArrowDown') { e.preventDefault(); moveDropdownActive(1); }
    else if (e.key === 'ArrowUp')   { e.preventDefault(); moveDropdownActive(-1); }
    else if (e.key === 'Enter') {
      e.preventDefault();
      const items = document.querySelectorAll('#plant-select-list .custom-select-item');
      if (items[ddActiveIdx]) items[ddActiveIdx].click();
    }
  });
  document.addEventListener('click', e => {
    if (!wrap.contains(e.target)) closeDropdown();
  });
}

function toggleDropdown() {
  const dd = document.getElementById('plant-select-dropdown');
  if (dd.classList.contains('open')) {
    closeDropdown();
  } else {
    dd.classList.add('open');
    document.getElementById('plant-select-wrap').classList.add('is-open');
    document.getElementById('plant-select-search').value = '';
    renderDropdownItems('');
    document.getElementById('plant-select-search').focus();
  }
}

function closeDropdown() {
  document.getElementById('plant-select-dropdown').classList.remove('open');
  document.getElementById('plant-select-wrap').classList.remove('is-open');
}

function renderDropdownItems(q) {
  const list     = document.getElementById('plant-select-list');
  const filtered = q ? plantListAll.filter(p => p.plant_name.includes(q)) : plantListAll;
  list.innerHTML = '';

  const newItem = document.createElement('div');
  newItem.className = 'custom-select-item' + (currentId === null ? ' selected' : '');
  newItem.textContent = '신규 등록';
  newItem.addEventListener('click', () => { selectPlant(null); closeDropdown(); });
  list.appendChild(newItem);

  for (const p of filtered) {
    const item = document.createElement('div');
    item.className = 'custom-select-item' + (p.id === currentId ? ' selected' : '');
    item.textContent = p.plant_name;
    item.addEventListener('click', () => { selectPlant(p.id, p.plant_name); closeDropdown(); });
    list.appendChild(item);
  }

  if (filtered.length === 0) {
    const empty = document.createElement('div');
    empty.className = 'custom-select-empty';
    empty.textContent = '검색 결과가 없습니다.';
    list.appendChild(empty);
  }

  // 키보드 강조 시작 위치: 검색 중이면 첫 번째 결과, 아니면 현재 선택된 항목
  const items = [...list.querySelectorAll('.custom-select-item')];
  items.forEach((item, idx) => item.addEventListener('mouseenter', () => setDropdownActive(idx, false)));
  const selectedIdx = items.findIndex(item => item.classList.contains('selected'));
  const startIdx = (q && filtered.length > 0) ? 1 : Math.max(selectedIdx, 0);
  setDropdownActive(startIdx, true);
}

function setDropdownActive(idx, scroll) {
  const items = document.querySelectorAll('#plant-select-list .custom-select-item');
  if (!items.length) return;
  ddActiveIdx = Math.min(Math.max(idx, 0), items.length - 1);
  items.forEach((item, i) => item.classList.toggle('active', i === ddActiveIdx));
  if (scroll) items[ddActiveIdx].scrollIntoView({ block: 'nearest' });
}

function moveDropdownActive(step) {
  setDropdownActive(ddActiveIdx + step, true);
}

function selectPlant(id, label) {
  if (!id) {
    currentId = null;
    setDropdownLabel('신규 등록');
    resetForm();
  } else {
    currentId = Number(id);
    setDropdownLabel(label || '발전소 선택');
    history.replaceState({}, '', `register.html?id=${id}`);
    loadPlant(currentId);
  }
}

function setDropdownLabel(label) {
  document.getElementById('plant-select-value').textContent = label;
}

/* ── 발전소 목록 로드 ────────────────────────────────────────────────────── */
async function loadPlantList() {
  try {
    plantListAll = await apiGet('api/plants-list');
    if (currentId) {
      const p = plantListAll.find(p => p.id === currentId);
      if (p) setDropdownLabel(p.plant_name);
    }
  } catch (e) {
    console.error(e);
  }
}

/* ── 발전소 데이터 로드 ──────────────────────────────────────────────────── */
async function loadPlant(id) {
  try {
    const data = await apiGet(`api/plants/${id}`);
    fillForm(data);
    setDropdownLabel(data.plant_name);
    document.getElementById('btn-delete').style.display = '';
    document.getElementById('btn-save').textContent = '수정';
  } catch (e) {
    toast('발전소 정보를 불러오지 못했습니다.', 'error');
  }
}

/* ── 폼 채우기 ────────────────────────────────────────────────────────────── */
function fillForm(data) {
  for (const f of FIELD_IDS) {
    const el = document.getElementById(f);
    if (!el) continue;
    let v = data[f] || '';
    if (el.type === 'date' && v) v = String(v).slice(0, 10);
    el.value = v;
  }
  setDevStatus(data.dev_permit_status || '');
  clearAllDateErrors();
  setNasFolder(data.nas_folder || null);
}

/* ── 폼 초기화 ────────────────────────────────────────────────────────────── */
function resetForm() {
  for (const f of FIELD_IDS) {
    const el = document.getElementById(f);
    if (el) el.value = '';
  }
  currentId = null;
  setDevStatus('');
  clearAllDateErrors();
  setNasFolder(null);
  document.getElementById('btn-delete').style.display = 'none';
  document.getElementById('btn-save').textContent = '저장';
  setDropdownLabel('신규 등록');
  history.replaceState({}, '', 'register.html');
}

/* ── 저장 ────────────────────────────────────────────────────────────────── */
async function onSave(e) {
  e.preventDefault();
  const btn = document.getElementById('btn-save');

  const plantName = document.getElementById('plant_name').value.trim();
  if (!plantName) {
    toast('발전소 명은 필수입니다.', 'error');
    document.getElementById('plant_name').focus();
    return;
  }

  const invalidDateEl = validateDateFields();
  if (invalidDateEl) {
    toast('날짜를 다시 확인해주세요.', 'error');
    invalidDateEl.focus();
    return;
  }

  const body = {};
  for (const f of FIELD_IDS) {
    const el = document.getElementById(f);
    body[f] = el ? el.value.trim() || null : null;
  }
  body.dev_permit_status = document.querySelector('input[name="dev_permit_status"]:checked')?.value ?? '';

  btn.disabled = true;
  btn.textContent = '저장 중...';

  try {
    if (currentId) {
      await apiSend(`api/plants/${currentId}`, 'PUT', body);
      toast('수정되었습니다.', 'success');
      await loadPlantList();
    } else {
      const res = await apiSend('api/plants', 'POST', body);
      currentId = res.id;
      history.replaceState({}, '', `register.html?id=${res.id}`);
      setNasFolder(null);   // 저장됐으니 NAS 폴더 연결 버튼 활성화
      toast('등록되었습니다.', 'success');
      document.getElementById('btn-delete').style.display = '';
      btn.textContent = '수정';
      await loadPlantList();
      setDropdownLabel(plantName);
    }
  } catch (err) {
    toast(err.message || '저장에 실패했습니다.', 'error');
    btn.textContent = currentId ? '수정' : '저장';
  } finally {
    btn.disabled = false;
    if (btn.textContent === '저장 중...') btn.textContent = currentId ? '수정' : '저장';
  }
}

/* ── 삭제 ────────────────────────────────────────────────────────────────── */
async function onDelete() {
  if (!currentId) return;
  const plantName = document.getElementById('plant_name').value || '이 발전소';
  const ok = await confirmDialog(
    `"${plantName}" 발전소를 삭제하시겠습니까?\n\n삭제된 데이터는 복구되지 않습니다.`,
    '발전소 삭제'
  );
  if (!ok) return;
  try {
    await apiSend(`api/plants/${currentId}`, 'DELETE');
    toast('삭제되었습니다.', 'success');
    resetForm();
    await loadPlantList();
  } catch (e) {
    toast(e.message || '삭제에 실패했습니다.', 'error');
  }
}

/* ── 발전소 첨부파일(다중, 모달) ────────────────────────────────────────── */
/* ── 다운로드 도우미 (NAS 서류 목록에서 사용) ── */
function downloadUrl(url, filename) {
  const a = document.createElement('a');
  a.href = url;
  a.download = filename || '';
  document.body.appendChild(a);
  a.click();
  // 크롬이 다운로드를 실제로 시작하기 전에 요소를 지우면 실패하는 경우가 있어 약간 지연 후 제거
  setTimeout(() => a.remove(), 1000);
}

/* ── NAS 서류 (읽기 전용) ─────────────────────────────────────────────────
   발전소마다 NAS 폴더 하나를 연결 → 그 안을 탐색기처럼 돌아다니며 서류 보기·다운로드만 함.
   연결 폴더에서 열리고 NAS 발전소 폴더(8. 발전소)까지 올라갈 수 있음, '.'으로 시작하는 숨김 폴더(.이전서류 등)는 회색 폴더로 흐리게 표시 */
let nasStatus      = { enabled: false, root: null };
let nasFolder      = null;        // 현재 발전소에 연결된 NAS 폴더 전체 경로
let nasCur         = null;        // 서류 창에서 지금 보고 있는 폴더
const nasListCache = new Map();   // 폴더 경로 → [{name,path,isdir,size,mtime}]

async function initNasDocs() {
  try { nasStatus = await apiGet('api/nas/status'); } catch (e) { nasStatus = { enabled: false }; }
  nasUi.root = nasStatus.root || '';
  document.getElementById('btn-nas-docs').addEventListener('click', openNasModal);
  setNasFolder(nasFolder);
}

function setNasFolder(folder) {
  nasFolder = folder || null;
  nasCur = null;
  nasListCache.clear();
  const group = document.getElementById('nas-docs-group');
  if (!group) return;
  group.style.display = nasStatus.enabled ? '' : 'none';

  const btn   = document.getElementById('btn-nas-docs');
  const state = document.getElementById('nas-docs-state');
  const hint  = document.getElementById('nas-docs-hint');
  if (!currentId) {
    btn.disabled = true;
    state.textContent = '';
    hint.innerHTML = '<p class="plant-files-hint">발전소를 저장한 뒤 NAS 서류 폴더를 연결할 수 있습니다.</p>';
    return;
  }
  btn.disabled = false;
  state.textContent = nasFolder ? '' : '(폴더 연결 필요)';
  hint.innerHTML = nasFolder
    ? nasPathTreeHtml(nasFolder)
    : '<p class="plant-files-hint">NAS의 발전소 서류 폴더를 연결하면 여기서 바로 보고 내려받을 수 있습니다. 서류 추가·수정은 NAS에서 해 주세요.</p>';
}

/* 서류 창: 연결 폴더 안을 폴더 구조 그대로 보여 줌 (폴더 누르면 들어가고, 위 경로·↑로 돌아옴) */
async function openNasModal() {
  if (!currentId) return;
  if (!nasFolder) { openNasFolderPicker(); return; }
  const top = nasUi.root;
  if (!nasCur || !(nasCur === top || nasCur.startsWith(top + '/'))) nasCur = nasFolder;

  const plantName = document.getElementById('plant_name').value.trim();
  const overlay = nasModalShell(plantName ? `발전소 서류 — ${plantName}` : '발전소 서류', `
    <div class="nas-link-line">
      <span class="nas-link-label">🔗 연결된 폴더</span>
      <span class="nas-link-name" title="${escHtml(nasRelPath(nasFolder))}">${escHtml(nasFolder.split('/').slice(-2).join(' › '))}</span>
      <button type="button" class="btn btn-sm btn-outline" data-nas-change>폴더 변경</button>
    </div>
    <div class="nas-browse-bar">
      <button type="button" class="nfd-nav" data-nas-up title="상위 폴더">↑</button>
      <div class="nas-crumbs" id="_nas_crumbs"></div>
      <button type="button" class="btn btn-sm btn-outline" data-nas-home title="연결된 폴더로 돌아가기">🔗 연결 폴더로</button>
      <button type="button" class="btn btn-sm btn-outline" data-nas-refresh>새로고침</button>
    </div>
    <div class="nas-bl" id="_nas_list"><div class="nas-bl-msg">NAS에서 불러오는 중...</div></div>
    <div class="nas-bl-status" id="_nas_status"></div>`, 900);

  overlay.querySelector('[data-nas-change]').addEventListener('click', () => openNasFolderPicker(nasCur || nasFolder));
  overlay.querySelector('[data-nas-refresh]').addEventListener('click', () => { nasListCache.delete(nasCur); nasGo(nasCur); });
  overlay.querySelector('[data-nas-up]').addEventListener('click', () => {
    if (nasCur !== top) nasGo(nasCur.slice(0, nasCur.lastIndexOf('/')));
  });
  overlay.querySelector('[data-nas-home]').addEventListener('click', () => nasGo(nasFolder));
  overlay.querySelector('#_nas_crumbs').addEventListener('click', e => {
    const c = e.target.closest('[data-nas-go]');
    if (c) nasGo(c.dataset.nasGo);
  });
  overlay.querySelector('#_nas_list').addEventListener('click', e => {
    const view = e.target.closest('[data-nas-view]');
    if (view) { e.preventDefault(); window.open(`api/nas/file?path=${encodeURIComponent(view.dataset.nasView)}`, '_blank'); return; }
    const down = e.target.closest('[data-nas-down]');
    if (down) { downloadUrl(`api/nas/file?path=${encodeURIComponent(down.dataset.nasDown)}&download=1`, down.dataset.name); return; }
    const dir = e.target.closest('[data-nas-dir]');
    if (dir) nasGo(dir.dataset.nasDir);
  });
  nasGo(nasCur);
}

async function nasGo(p) {
  nasCur = p;
  const listEl = document.getElementById('_nas_list');
  if (!listEl) return;
  renderNasCrumbs();
  if (!nasListCache.has(p)) {
    listEl.innerHTML = '<div class="nas-bl-msg">NAS에서 불러오는 중...</div>';
    document.getElementById('_nas_status').textContent = '';
    try {
      const list = (await apiGet(`api/nas/list?path=${encodeURIComponent(p)}`)).entries;
      // 폴더 먼저(이름이 '.'으로 시작하는 숨김 폴더 — .이전서류 등 — 는 폴더 중 맨 뒤), 그다음 파일 (각각 이름순)
      const rank = e => (e.isdir ? (e.name.startsWith('.') ? 1 : 0) : 2);
      list.sort((a, b) => rank(a) - rank(b) || a.name.localeCompare(b.name, 'ko'));
      nasListCache.set(p, list);
    } catch (e) {
      if (nasCur !== p) return;
      listEl.innerHTML = `<div class="nas-bl-msg nas-error">${escHtml(e.message || 'NAS 서류를 불러오지 못했습니다.')}
        <br>폴더가 옮겨졌거나 이름이 바뀌었다면 [폴더 변경]으로 다시 연결해 주세요.</div>`;
      return;
    }
  }
  if (nasCur === p) renderNasList();
}

function renderNasCrumbs() {
  const el = document.getElementById('_nas_crumbs');
  if (!el) return;
  // 맨 위 = NAS 발전소 폴더(8. 발전소), 연결된 폴더는 🔗 표시
  const top = nasUi.root;
  const parts = [top];
  if (nasCur !== top) {
    const rel = nasCur.slice(top.length + 1).split('/');
    rel.forEach((_, i) => parts.push(`${top}/${rel.slice(0, i + 1).join('/')}`));
  }
  el.innerHTML = parts.map((p, i) => {
    const cls = (i === parts.length - 1 ? ' nas-crumb--cur' : '') + (p === nasFolder ? ' nas-crumb--linked' : '');
    const ico = p === nasFolder ? '🔗 ' : '';
    return `<span class="nfd-crumb${cls}" data-nas-go="${escHtml(p)}"${p === nasFolder ? ' title="연결된 폴더"' : ''}>${ico}${escHtml(p.slice(p.lastIndexOf('/') + 1))}</span>`;
  }).join('<span class="nfd-crumb-sep">›</span>');
  el.scrollLeft = el.scrollWidth;
  const up = document.querySelector('[data-nas-up]');
  if (up) up.disabled = nasCur === top;
  const home = document.querySelector('[data-nas-home]');
  if (home) home.style.display = nasCur === nasFolder ? 'none' : '';
}

// 파일 종류별 아이콘 (직접 그린 SVG: 종이 + 색 띠 + 확장자)
//   확장자 → [띠 글자, 띠 색, 종류 이름(마우스 올렸을 때)]
const NAS_FILE_KIND = {
  pdf: ['PDF', '#e5322d', 'PDF 문서'],
  hwp: ['HWP', '#1f6fd6', '한글 문서'], hwpx: ['HWP', '#1f6fd6', '한글 문서'],
  doc: ['DOC', '#2b579a', 'Word 문서'], docx: ['DOC', '#2b579a', 'Word 문서'],
  xls: ['XLS', '#1d8a4e', 'Excel 문서'], xlsx: ['XLS', '#1d8a4e', 'Excel 문서'], csv: ['CSV', '#1d8a4e', 'CSV 파일'],
  jpg: ['JPG', '#8b5cf6', '사진'], jpeg: ['JPG', '#8b5cf6', '사진'], png: ['PNG', '#8b5cf6', '사진'],
  gif: ['GIF', '#8b5cf6', '사진'], bmp: ['BMP', '#8b5cf6', '사진'], webp: ['IMG', '#8b5cf6', '사진'],
  zip: ['ZIP', '#a16207', '압축 파일'], dwg: ['DWG', '#0f766e', '도면'],
};

function nasFileIconSvg(ext) {
  const [label, color, kindName] = NAS_FILE_KIND[ext] || [(ext || '').slice(0, 4).toUpperCase(), '#94a3b8', ext ? `${ext.toUpperCase()} 파일` : '파일'];
  const fs = label.length >= 4 ? 5.2 : 6.4;
  return `<svg class="nas-ficon" viewBox="0 0 24 28" role="img" aria-label="${escHtml(kindName)}"><title>${escHtml(kindName)}</title>
    <path d="M4 1.5h11.2L21 7.3V25a1.5 1.5 0 0 1-1.5 1.5h-14A1.5 1.5 0 0 1 4 25z" fill="#fff" stroke="#c3cbd6"/>
    <path d="M15.2 1.5v4.3a1.5 1.5 0 0 0 1.5 1.5H21" fill="#eef1f5" stroke="#c3cbd6" stroke-linejoin="round"/>
    ${label ? `<rect x="1" y="13.2" width="19" height="8.6" rx="1.6" fill="${color}"/>
    <text x="10.5" y="19.75" text-anchor="middle" font-family="Arial, Helvetica, sans-serif" font-size="${fs}" font-weight="700" fill="#fff">${escHtml(label)}</text>` : ''}
  </svg>`;
}

function nasFolderIconSvg(old) {
  const back = old ? '#c4ccd6' : '#f4b73f', front = old ? '#dde3ea' : '#fcd36a';
  return `<svg class="nas-ficon" viewBox="0 0 24 28" aria-hidden="true">
    <path d="M1.5 6.8A1.6 1.6 0 0 1 3.1 5.2h6.1l2.2 2.4h9.5a1.6 1.6 0 0 1 1.6 1.6v12.4a1.6 1.6 0 0 1-1.6 1.6H3.1a1.6 1.6 0 0 1-1.6-1.6z" fill="${back}"/>
    <path d="M1.5 10.4h21v11.2a1.6 1.6 0 0 1-1.6 1.6H3.1a1.6 1.6 0 0 1-1.6-1.6z" fill="${front}"/>
  </svg>`;
}

function renderNasList() {
  const listEl = document.getElementById('_nas_list');
  const statusEl = document.getElementById('_nas_status');
  const list = nasListCache.get(nasCur);
  if (!listEl || !list) return;
  const fmtDate = t => {
    if (!t) return '';
    const d = new Date(t * 1000), z = n => String(n).padStart(2, '0');
    return `${d.getFullYear()}-${z(d.getMonth() + 1)}-${z(d.getDate())}`;
  };
  const d = list.filter(e => e.isdir).length;
  statusEl.textContent = list.length ? `폴더 ${d}개 · 파일 ${list.length - d}개  ·  폴더는 눌러서 열고, 파일은 이름을 누르면 새 탭에서 열립니다` : '';
  if (!list.length) { listEl.innerHTML = '<div class="nas-bl-msg">이 폴더는 비어 있습니다.</div>'; return; }

  let html = `<div class="nas-bl-head"><span class="nas-bl-name">이름</span><span class="nas-bl-date">수정한 날짜</span>
    <span class="nas-bl-size">크기</span><span class="nas-bl-act"></span></div>`;
  for (const e of list) {
    const old = e.name.startsWith('.');
    if (e.isdir) {
      html += `
        <div class="nas-bl-row nas-bl-row--dir${old ? ' nas-bl-row--old' : ''}" data-nas-dir="${escHtml(e.path)}" title="${old ? '숨김 폴더 · ' : ''}눌러서 열기">
          <span class="nas-bl-name">${nasFolderIconSvg(old)}<span class="nas-bl-text">${escHtml(e.name)}</span>${old ? '<span class="nas-old-tag">숨김 폴더</span>' : ''}</span>
          <span class="nas-bl-date">${fmtDate(e.mtime)}</span>
          <span class="nas-bl-size">폴더</span>
          <span class="nas-bl-act"><span class="nas-dir-go">열기 ›</span></span>
        </div>`;
    } else {
      const ext = e.name.includes('.') ? e.name.split('.').pop().toLowerCase() : '';
      html += `
        <div class="nas-bl-row">
          <span class="nas-bl-name">
            ${nasFileIconSvg(ext)}
            <a href="#" class="nas-bl-text nas-bl-link" data-nas-view="${escHtml(e.path)}" title="${escHtml(e.name)} — 새 탭에서 보기">${escHtml(e.name)}</a>
          </span>
          <span class="nas-bl-date">${fmtDate(e.mtime)}</span>
          <span class="nas-bl-size">${formatFileSize(e.size)}</span>
          <span class="nas-bl-act">
            <button type="button" class="btn btn-sm btn-outline" data-nas-view="${escHtml(e.path)}">보기</button>
            <button type="button" class="btn btn-sm btn-outline" data-nas-down="${escHtml(e.path)}" data-name="${escHtml(e.name)}">받기</button>
          </span>
        </div>`;
    }
  }
  listEl.innerHTML = html;
  listEl.scrollTop = 0;
}

/* 폴더 선택 창 (js/nas-picker.js) — 고른 폴더를 이 발전소에 바로 저장 */
function openNasFolderPicker(startPath) {
  const save = async (p) => {
    try {
      await apiSend(`api/plants/${currentId}/nas-folder`, 'PUT', { path: p });
      setNasFolder(p);
      toast(p ? 'NAS 폴더를 연결했습니다.' : 'NAS 폴더 연결을 해제했습니다.', 'success');
      if (p) openNasModal(); else closeNasModal();
    } catch (e) {
      toast(e.message || '저장하지 못했습니다.', 'error');
    }
  };
  openNasFolderDialog({
    startPath,
    plantId: currentId,
    canUnlink: !!nasFolder,
    onPick: p => save(p),
    onUnlink: async () => {
      const ok = await confirmDialog('이 발전소의 NAS 폴더 연결을 해제할까요?\nNAS의 파일은 지워지지 않습니다.', '연결 해제');
      if (ok) save(null);
    },
    onCancel: () => (nasFolder ? openNasModal() : closeNasModal()),
  });
}

/* ── 엑셀 가져오기 ───────────────────────────────────────────────────────── */
function initFileImport() {
  const fileInput = document.getElementById('excel-file-input');
  const display   = document.getElementById('file-name-display');
  const btnPick   = document.getElementById('btn-file-pick');
  const btnImport = document.getElementById('btn-excel-import');

  btnPick.addEventListener('click', () => fileInput.click());
  fileInput.addEventListener('change', () => {
    display.value = fileInput.files[0] ? fileInput.files[0].name : '';
  });

  btnImport.addEventListener('click', async () => {
    const f = fileInput.files[0];
    if (!f) { toast('가져올 엑셀 파일을 선택해 주세요.', 'error'); return; }

    const ok = await confirmDialog(
      `"${f.name}" 파일의 데이터를 가져옵니다.\n중복 발전소는 건너뜁니다.\n계속하시겠습니까?`,
      '엑셀 가져오기'
    );
    if (!ok) return;

    btnImport.disabled = true;
    btnImport.textContent = '가져오는 중...';
    const fd = new FormData();
    fd.append('file', f);
    try {
      const r = await fetch('api/plants/import', { method: 'POST', body: fd });
      const data = await r.json();
      if (!r.ok) throw new Error(data.error || '가져오기 실패');
      toast(`신규: ${data.inserted}건, 업데이트: ${data.updated||0}건, 건너뜀: ${data.skipped}건`, 'success');
      fileInput.value = '';
      display.value   = '';
      await loadPlantList();
    } catch (e) {
      toast(e.message || '가져오기에 실패했습니다.', 'error');
    } finally {
      btnImport.disabled = false;
      btnImport.textContent = '엑셀 등록';
    }
  });
}
