/* 발전소 등록/수정 폼 로직 */

const FIELD_IDS = [
  'plant_name', 'owner_name', 'contact', 'address', 'capacity', 'install_type', 'memo',
  'power_biz_permit_scheduled', 'power_biz_permit_date', 'power_biz_permit_expire',
  'dev_permit_date', 'dev_permit_expire',
  'ppa_receive_date', 'ppa_receive_capacity',
  'dev_completion_date', 'commercial_operation_date',
];

let currentId        = null;
let plantListAll     = [];
let pendingBizCert   = null;   // 신규 등록 시 미리 선택한 파일

document.addEventListener('DOMContentLoaded', () => {
  initDropdown();
  initDevStatus();
  loadPlantList();
  initFileImport();
  initBizCert();

  document.getElementById('register-form').addEventListener('submit', onSave);
  document.getElementById('btn-reset').addEventListener('click', resetForm);
  document.getElementById('btn-delete').addEventListener('click', onDelete);

  const params  = new URLSearchParams(window.location.search);
  const idParam = params.get('id');
  if (idParam) {
    currentId = Number(idParam);
    loadPlant(currentId);
  } else {
    renderBizCert(null);
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
    history.replaceState({}, '', `/register.html?id=${id}`);
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
  renderBizCert(data.biz_cert_filename || null);
}

/* ── 폼 초기화 ────────────────────────────────────────────────────────────── */
function resetForm() {
  for (const f of FIELD_IDS) {
    const el = document.getElementById(f);
    if (el) el.value = '';
  }
  currentId = null;
  pendingBizCert = null;
  document.getElementById('biz-cert-input').value = '';
  setDevStatus('');
  renderBizCert(null);
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
      if (pendingBizCert) {
        const file = pendingBizCert;
        pendingBizCert = null;
        document.getElementById('biz-cert-input').value = '';
        await uploadBizCertFile(file);
      } else {
        renderBizCert(null);
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

/* ── 사업자등록증 ────────────────────────────────────────────────────────── */
function initBizCert() {
  document.getElementById('biz-cert-input').addEventListener('change', async () => {
    const f = document.getElementById('biz-cert-input').files[0];
    if (!f) return;

    if (!currentId) {
      // 신규 등록 중 — 파일만 저장해두고 저장 시 함께 업로드
      pendingBizCert = f;
      renderBizCert(null);
      return;
    }

    // 기존 발전소 — 즉시 업로드
    await uploadBizCertFile(f);
    document.getElementById('biz-cert-input').value = '';
  });
}

async function uploadBizCertFile(file) {
  const fd = new FormData();
  fd.append('file', file);
  try {
    const r = await fetch(`api/plants/${currentId}/biz-cert`, { method: 'POST', body: fd });
    const data = await r.json();
    if (!r.ok) throw new Error(data.error || '업로드 실패');
    toast('사업자등록증이 등록되었습니다.', 'success');
    renderBizCert(data.filename);
  } catch (e) {
    toast(e.message || '업로드에 실패했습니다.', 'error');
  }
}

function renderBizCert(filename) {
  const area = document.getElementById('biz-cert-area');

  // 파일이 선택된 상태 (신규 or 기존 모두)
  const displayName = filename || (pendingBizCert ? pendingBizCert.name : null);
  const isPending   = !filename && !!pendingBizCert;

  if (displayName) {
    area.innerHTML = `
      <div class="biz-cert-file">
        <svg class="biz-cert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
        </svg>
        <span class="biz-cert-name" title="${escHtml(displayName)}">${escHtml(displayName)}</span>
        ${isPending
          ? `<span class="biz-cert-pending">저장 시 등록</span>
             <button type="button" class="btn btn-sm btn-danger-soft" id="btn-biz-cancel">취소</button>`
          : `<button type="button" class="btn btn-sm btn-outline" id="btn-biz-view">보기</button>
             <button type="button" class="btn btn-sm btn-danger-soft" id="btn-biz-delete">삭제</button>`
        }
      </div>`;

    if (isPending) {
      document.getElementById('btn-biz-cancel').addEventListener('click', () => {
        pendingBizCert = null;
        document.getElementById('biz-cert-input').value = '';
        renderBizCert(null);
      });
    } else {
      document.getElementById('btn-biz-view').addEventListener('click', () => {
        window.open(`api/plants/${currentId}/biz-cert`, '_blank');
      });
      document.getElementById('btn-biz-delete').addEventListener('click', onBizCertDelete);
    }
  } else {
    area.innerHTML = `<button type="button" class="btn btn-sm btn-outline" id="btn-biz-upload">등록</button>`;
    document.getElementById('btn-biz-upload').addEventListener('click', () => {
      document.getElementById('biz-cert-input').click();
    });
  }
}

async function onBizCertDelete() {
  const ok = await confirmDialog('사업자등록증 파일을 삭제하시겠습니까?', '파일 삭제');
  if (!ok) return;
  try {
    await apiSend(`api/plants/${currentId}/biz-cert`, 'DELETE');
    toast('삭제되었습니다.', 'success');
    renderBizCert(null);
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
