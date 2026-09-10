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
let pendingPlantFiles = [];    // 신규 등록 시 미리 선택한 첨부파일들

document.addEventListener('DOMContentLoaded', async () => {
  const ok = await checkLogin();
  if (!ok) return;
  bindLogout();

  initDropdown();
  initDevStatus();
  initDateValidation();
  loadPlantList();
  initFileImport();
  initPlantFiles();

  document.getElementById('register-form').addEventListener('submit', onSave);
  document.getElementById('btn-reset').addEventListener('click', resetForm);
  document.getElementById('btn-delete').addEventListener('click', onDelete);

  const params  = new URLSearchParams(window.location.search);
  const idParam = params.get('id');
  if (idParam) {
    currentId = Number(idParam);
    loadPlant(currentId);
  } else {
    updateFilesCountBadge();
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
  search.addEventListener('keydown', e => { if (e.key === 'Escape') closeDropdown(); });
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
  loadPlantFiles(currentId);
}

/* ── 폼 초기화 ────────────────────────────────────────────────────────────── */
function resetForm() {
  for (const f of FIELD_IDS) {
    const el = document.getElementById(f);
    if (el) el.value = '';
  }
  currentId = null;
  pendingPlantFiles = [];
  document.getElementById('plant-files-input').value = '';
  setDevStatus('');
  clearAllDateErrors();
  plantFilesSelected = new Set();
  updateFilesCountBadge();
  if (filesModalEl) filesModalEl.remove();
  filesModalEl = null;
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
      toast('등록되었습니다.', 'success');
      document.getElementById('btn-delete').style.display = '';
      btn.textContent = '수정';
      if (pendingPlantFiles.length) {
        const files = pendingPlantFiles;
        pendingPlantFiles = [];
        document.getElementById('plant-files-input').value = '';
        await uploadPlantFiles(files);
      } else {
        await loadPlantFiles(currentId);
      }
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
let plantFilesCache    = [];        // 서버에서 불러온 현재 발전소의 첨부파일 목록
let plantFilesSelected = new Set(); // 모달에서 체크된 파일 id들
let filesModalEl       = null;      // 열려있는 모달 DOM (없으면 null)

function initPlantFiles() {
  document.getElementById('btn-files-manage').addEventListener('click', openFilesModal);

  document.getElementById('plant-files-input').addEventListener('change', async () => {
    const input = document.getElementById('plant-files-input');
    const files = Array.from(input.files || []);
    input.value = '';
    if (!files.length) return;

    if (!currentId) {
      // 신규 등록 중 — 목록에 담아두고 저장 시 함께 업로드
      pendingPlantFiles = pendingPlantFiles.concat(files);
      updateFilesCountBadge();
      if (filesModalEl) renderFilesModalList();
      return;
    }

    await uploadPlantFiles(files);
  });
}

function updateFilesCountBadge() {
  const total = currentId ? plantFilesCache.length : pendingPlantFiles.length;
  document.getElementById('plant-files-count').textContent = `(${total}개)`;
}

async function loadPlantFiles(plantId) {
  if (!plantId) { plantFilesCache = []; updateFilesCountBadge(); return; }
  try {
    plantFilesCache = await apiGet(`api/plants/${plantId}/files`);
  } catch (e) {
    plantFilesCache = [];
  }
  updateFilesCountBadge();
  if (filesModalEl) renderFilesModalList();
}

function formatFileSize(bytes) {
  if (!bytes && bytes !== 0) return '';
  if (bytes < 1024) return `${bytes}B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)}KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)}MB`;
}

/* 업로드 중 표시 — 모달이 열려있으면 모달 안에, 아니면 화면 우하단 배너로 */
function showUploadProgress(count) {
  hideUploadProgress();
  const text = `파일 업로드 중... (${count}개)`;
  if (filesModalEl) {
    const bar = filesModalEl.querySelector('#_fm_progress');
    if (bar) { bar.textContent = text; bar.style.display = 'flex'; }
  } else {
    const el = document.createElement('div');
    el.id = 'global-upload-progress';
    el.className = 'upload-progress-banner';
    el.innerHTML = `<span class="upload-spinner"></span><span>${escHtml(text)}</span>`;
    document.body.appendChild(el);
  }
}
function hideUploadProgress() {
  const modalBar = document.getElementById('_fm_progress');
  if (modalBar) modalBar.style.display = 'none';
  const banner = document.getElementById('global-upload-progress');
  if (banner) banner.remove();
}

async function uploadPlantFiles(files) {
  showUploadProgress(files.length);
  const fd = new FormData();
  for (const f of files) fd.append('files', f);
  try {
    const r = await fetch(`api/plants/${currentId}/files`, { method: 'POST', body: fd });
    const data = await r.json();
    if (!r.ok) throw new Error(data.error || '업로드 실패');
    if (data.rejected && data.rejected.length) {
      toast(`${data.rejected.length}개 파일은 허용되지 않는 형식이라 제외됐습니다.`, 'error');
    } else {
      toast(`${data.uploaded.length}개 파일이 첨부되었습니다.`, 'success');
    }
    await loadPlantFiles(currentId);
  } catch (e) {
    toast(e.message || '업로드에 실패했습니다.', 'error');
  } finally {
    hideUploadProgress();
  }
}

/* ── 첨부파일 관리 모달 ─────────────────────────────────────────────────── */
function openFilesModal() {
  const existing = document.getElementById('plant-files-modal');
  if (existing) existing.remove();
  plantFilesSelected = new Set();

  const overlay = document.createElement('div');
  overlay.id = 'plant-files-modal';
  overlay.className = 'plant-modal-overlay';
  overlay.innerHTML = `
    <div class="plant-modal-box" style="max-width:520px">
      <div class="plant-modal-header">
        <h3 class="plant-modal-title">첨부파일 관리</h3>
        <button type="button" class="plant-modal-close" id="_fm_x">✕</button>
      </div>
      <div class="plant-modal-body">
        <div class="files-modal-toolbar">
          <label class="files-select-all">
            <input type="checkbox" id="_fm_select_all" />
            <span>전체 선택</span>
          </label>
          <div class="files-modal-toolbar-actions">
            <button type="button" class="btn btn-sm btn-outline btn-icon" id="_fm_download_selected" title="선택 다운로드">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" y1="15" x2="12" y2="3"/></svg>
            </button>
            <button type="button" class="btn btn-sm btn-danger-soft" id="_fm_del_selected">선택 삭제</button>
            <button type="button" class="btn btn-sm btn-primary" id="_fm_add">파일 추가</button>
          </div>
        </div>
        <div class="upload-progress-banner upload-progress-banner--inline" id="_fm_progress" style="display:none">
          <span class="upload-spinner"></span><span></span>
        </div>
        <div class="plant-files-list" id="_fm_list"></div>
      </div>
    </div>`;
  document.body.appendChild(overlay);
  filesModalEl = overlay;

  const close = () => {
    overlay.remove();
    filesModalEl = null;
    document.removeEventListener('keydown', escFn);
  };
  const escFn = e => { if (e.key === 'Escape') close(); };
  document.addEventListener('keydown', escFn);
  overlay.addEventListener('click', e => { if (e.target === overlay) close(); });
  overlay.querySelector('#_fm_x').addEventListener('click', close);

  overlay.querySelector('#_fm_add').addEventListener('click', () => {
    document.getElementById('plant-files-input').click();
  });
  overlay.querySelector('#_fm_select_all').addEventListener('change', (e) => {
    plantFilesSelected = e.target.checked
      ? new Set(currentId ? plantFilesCache.map(f => f.id) : pendingPlantFiles.map((_, i) => i))
      : new Set();
    renderFilesModalList();
  });
  overlay.querySelector('#_fm_del_selected').addEventListener('click', onDeleteSelectedFiles);
  overlay.querySelector('#_fm_download_selected').addEventListener('click', onDownloadSelectedFiles);

  renderFilesModalList();
}

function renderFilesModalList() {
  if (!filesModalEl) return;
  const listEl = filesModalEl.querySelector('#_fm_list');
  const selectAllEl = filesModalEl.querySelector('#_fm_select_all');

  const items = currentId ? plantFilesCache : [];
  const showPending = !currentId;

  if (!items.length && !(showPending && pendingPlantFiles.length)) {
    listEl.innerHTML = `<div class="plant-files-empty">첨부된 파일이 없습니다.</div>`;
    selectAllEl.checked = false;
    selectAllEl.disabled = true;
    return;
  }
  selectAllEl.disabled = false;

  let html = '';
  for (const f of items) {
    const checked = plantFilesSelected.has(f.id) ? 'checked' : '';
    html += `
      <div class="plant-file-row">
        <input type="checkbox" class="plant-file-check" data-id="${f.id}" ${checked} />
        <svg class="plant-file-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
        </svg>
        <span class="plant-file-name" title="${escHtml(f.original_filename)}">${escHtml(f.original_filename)}</span>
        <span class="plant-file-size">${formatFileSize(f.file_size)}</span>
        <button type="button" class="btn btn-sm btn-outline" data-view="${f.id}">보기</button>
      </div>`;
  }
  if (showPending) {
    for (let i = 0; i < pendingPlantFiles.length; i++) {
      const f = pendingPlantFiles[i];
      const checked = plantFilesSelected.has(i) ? 'checked' : '';
      html += `
        <div class="plant-file-row">
          <input type="checkbox" class="plant-file-check" data-pending-id="${i}" ${checked} />
          <svg class="plant-file-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
          </svg>
          <span class="plant-file-name" title="${escHtml(f.name)}">${escHtml(f.name)}</span>
          <span class="plant-file-size">${formatFileSize(f.size)}</span>
          <span class="biz-cert-pending">저장 시 등록</span>
        </div>`;
    }
  }
  listEl.innerHTML = html;

  const totalCount = items.length + (showPending ? pendingPlantFiles.length : 0);
  selectAllEl.checked = totalCount > 0 && plantFilesSelected.size === totalCount;

  listEl.querySelectorAll('[data-view]').forEach(btn => {
    btn.addEventListener('click', () => window.open(`api/plants/${currentId}/files/${btn.dataset.view}`, '_blank'));
  });
  listEl.querySelectorAll('.plant-file-check').forEach(cb => {
    cb.addEventListener('change', () => {
      const key = cb.dataset.id !== undefined ? Number(cb.dataset.id) : Number(cb.dataset.pendingId);
      if (cb.checked) plantFilesSelected.add(key); else plantFilesSelected.delete(key);
      selectAllEl.checked = totalCount > 0 && plantFilesSelected.size === totalCount;
    });
  });
}

function downloadUrl(url, filename) {
  const a = document.createElement('a');
  a.href = url;
  a.download = filename || '';
  document.body.appendChild(a);
  a.click();
  // 크롬이 다운로드를 실제로 시작하기 전에 요소를 지우면 실패하는 경우가 있어 약간 지연 후 제거
  setTimeout(() => a.remove(), 1000);
}

async function onDownloadSelectedFiles() {
  if (!plantFilesSelected.size) { toast('선택된 파일이 없습니다.', 'error'); return; }

  if (!currentId) {
    // 신규 등록 중(대기 목록) — 아직 서버에 없으니 로컬 파일 그대로 다운로드
    for (const i of plantFilesSelected) {
      const f = pendingPlantFiles[i];
      if (!f) continue;
      const blobUrl = URL.createObjectURL(f);
      downloadUrl(blobUrl, f.name);
      setTimeout(() => URL.revokeObjectURL(blobUrl), 10000);
      await new Promise(r => setTimeout(r, 250));
    }
    return;
  }

  for (const f of plantFilesCache) {
    if (!plantFilesSelected.has(f.id)) continue;
    downloadUrl(`api/plants/${currentId}/files/${f.id}?download=1`, f.original_filename);
    await new Promise(r => setTimeout(r, 250));
  }
}

async function onDeleteSelectedFiles() {
  if (!plantFilesSelected.size) { toast('선택된 파일이 없습니다.', 'error'); return; }

  if (!currentId) {
    // 신규 등록 중(대기 목록) — 선택된 인덱스 제거
    const idxToRemove = new Set(plantFilesSelected);
    pendingPlantFiles = pendingPlantFiles.filter((_, i) => !idxToRemove.has(i));
    plantFilesSelected = new Set();
    updateFilesCountBadge();
    renderFilesModalList();
    return;
  }

  const ok = await confirmDialog(`선택한 ${plantFilesSelected.size}개 파일을 삭제하시겠습니까?`, '파일 삭제');
  if (!ok) return;
  try {
    await apiSend(`api/plants/${currentId}/files/bulk-delete`, 'POST', { ids: Array.from(plantFilesSelected) });
    toast('삭제되었습니다.', 'success');
    plantFilesSelected = new Set();
    await loadPlantFiles(currentId);
  } catch (e) {
    toast(e.message || '삭제에 실패했습니다.', 'error');
  }
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
