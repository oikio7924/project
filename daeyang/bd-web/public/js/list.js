/* 인허가 현황 목록 로직 */

const listState = {
  q:         '',
  from:      '',
  to:        '',
  devStatus: '',
};

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.quick-btn[data-range]').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.quick-btn[data-range]').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      applyQuickRange(btn.dataset.range);
    });
  });

  document.getElementById('btn-search-filter').addEventListener('click', () => {
    listState.from = document.getElementById('filter-from').value;
    listState.to   = document.getElementById('filter-to').value;
    loadAll();
  });

  document.getElementById('filter-dev-status').addEventListener('change', e => {
    listState.devStatus = e.target.value;
    loadAll();
  });

  document.getElementById('btn-search').addEventListener('click', doSearch);
  document.getElementById('search-input').addEventListener('keydown', e => {
    if (e.key === 'Enter') doSearch();
  });

  document.getElementById('btn-export').addEventListener('click', () => {
    window.location.href = 'api/plants/export';
  });

  document.getElementById('check-all').addEventListener('change', e => {
    document.querySelectorAll('.row-check').forEach(cb => { cb.checked = e.target.checked; });
  });

  document.getElementById('btn-bulk-delete').addEventListener('click', onBulkDelete);

  loadAll();
});

/* ── 전체 로드 ────────────────────────────────────────────────────────────── */
async function loadAll() {
  const body = document.getElementById('table-body');
  body.innerHTML = `<tr><td colspan="5" style="text-align:center;padding:40px;color:#94a3b8">로딩 중...</td></tr>`;
  document.getElementById('table-info').textContent = '';
  document.getElementById('check-all').checked = false;
  document.getElementById('check-all').indeterminate = false;

  const params = new URLSearchParams({
    limit: 9999,
    q:     listState.q,
    from:  listState.from,
    to:    listState.to,
  });

  try {
    const data = await apiGet(`api/plants?${params}`);
    let plants = data.plants;
    if (listState.devStatus !== '') {
      const target = listState.devStatus === '해당' ? '' : listState.devStatus;
      plants = plants.filter(p => p.dev_permit_status === target);
    }
    renderRows(plants);
    document.getElementById('table-info').textContent = `총 ${plants.length.toLocaleString()}건`;
  } catch (e) {
    body.innerHTML = `<tr><td colspan="5" style="text-align:center;padding:40px;color:#dc2626">불러오기 실패: ${escHtml(e.message)}</td></tr>`;
  }
}

/* ── 행 렌더링 ────────────────────────────────────────────────────────────── */
function renderRows(plants) {
  const body = document.getElementById('table-body');
  document.getElementById('check-all').checked = false;
  document.getElementById('check-all').indeterminate = false;

  if (!plants.length) {
    body.innerHTML = `<tr><td colspan="5" style="text-align:center;padding:40px;color:#94a3b8">조건에 맞는 발전소가 없습니다.</td></tr>`;
    return;
  }

  body.innerHTML = '';
  for (const p of plants) {
    const tr = document.createElement('tr');

    const tdCheck = document.createElement('td');
    tdCheck.style.textAlign = 'center';
    const cb = document.createElement('input');
    cb.type       = 'checkbox';
    cb.className  = 'row-check';
    cb.dataset.id = p.id;
    cb.addEventListener('change', syncCheckAll);
    tdCheck.appendChild(cb);

    const tdName = document.createElement('td');
    tdName.innerHTML = `<span class="plant-link">${escHtml(p.plant_name)}</span>`;
    tdName.querySelector('.plant-link').addEventListener('click', () => openPlantModal(p.id));

    const tdAddr = document.createElement('td');
    tdAddr.textContent    = p.address || '-';
    tdAddr.style.fontSize = '12px';
    tdAddr.style.color    = '#64748b';

    const tdPower = document.createElement('td');
    tdPower.className = 'date-cell';
    setDateCell(tdPower, p.power_biz_permit_expire);

    const tdDev = document.createElement('td');
    tdDev.className = 'date-cell';
    if (p.dev_permit_status) {
      tdDev.innerHTML = `<span class="dev-status-badge">${escHtml(p.dev_permit_status)}</span>`;
    } else {
      setDateCell(tdDev, p.dev_permit_expire);
    }

    tr.style.cursor = 'pointer';
    tr.addEventListener('click', e => {
      if (e.target === cb || e.target.closest('input[type="checkbox"]')) return;
      openPlantModal(p.id);
    });

    tr.append(tdCheck, tdName, tdAddr, tdPower, tdDev);
    body.appendChild(tr);
  }
}

/* 전체 선택 체크박스 상태 동기화 */
function syncCheckAll() {
  const all     = document.querySelectorAll('.row-check');
  const checked = document.querySelectorAll('.row-check:checked');
  const ca = document.getElementById('check-all');
  ca.checked       = checked.length > 0 && checked.length === all.length;
  ca.indeterminate = checked.length > 0 && checked.length < all.length;
}

function setDateCell(td, val) {
  if (!val || val === '0000-00-00') {
    td.textContent = '-';
    td.classList.add('date-cell--none');
    return;
  }
  const s = String(val).slice(0, 10);
  const status = dateStatus(s);
  td.textContent = s;
  if (status === 'past')      td.classList.add('date-cell--past');
  else if (status === 'soon') td.classList.add('date-cell--soon');
  else                        td.classList.add('date-cell--ok');
}

/* ── 검색 / 필터 ─────────────────────────────────────────────────────────── */
function doSearch() {
  listState.q = document.getElementById('search-input').value.trim();
  loadAll();
}

function applyQuickRange(range) {
  const today = new Date();
  const from  = document.getElementById('filter-from');
  const to    = document.getElementById('filter-to');

  if (range === 'all') {
    from.value = '';
    to.value   = '';
  } else {
    const months = range === '3m' ? 3 : range === '6m' ? 6 : 12;
    const end = new Date(today);
    end.setMonth(end.getMonth() + months);
    from.value = toDateStr(today);
    to.value   = toDateStr(end);
  }
  listState.from = from.value;
  listState.to   = to.value;
  loadAll();
}

function toDateStr(d) {
  return `${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`;
}

/* ── 일괄 삭제 ────────────────────────────────────────────────────────────── */
async function onBulkDelete() {
  const ids = Array.from(document.querySelectorAll('.row-check:checked')).map(cb => Number(cb.dataset.id));
  if (!ids.length) { toast('삭제할 항목을 선택해 주세요.', 'error'); return; }

  const ok = await confirmDialog(
    `선택한 ${ids.length}개 발전소를 삭제하시겠습니까?\n삭제된 데이터는 복구되지 않습니다.`,
    '일괄 삭제'
  );
  if (!ok) return;

  try {
    const res = await apiSend('api/plants/bulk-delete', 'POST', { ids });
    toast(`${res.deleted}건 삭제되었습니다.`, 'success');
    loadAll();
  } catch (e) {
    toast(e.message || '삭제에 실패했습니다.', 'error');
  }
}
