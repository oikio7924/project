/* 공통 유틸리티 */

async function apiGet(url) {
  const r = await fetch(url, { credentials: 'same-origin' });
  const data = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(data.error || '요청 실패');
  return data;
}

async function apiSend(url, method, body) {
  const opt = {
    method,
    credentials: 'same-origin',
    headers: { 'Content-Type': 'application/json' },
  };
  if (body !== undefined) opt.body = JSON.stringify(body);
  const r = await fetch(url, opt);
  const data = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(data.error || '요청 실패');
  return data;
}

/* 날짜 포맷 */
function fmtDate(v) {
  if (!v) return '-';
  const s = String(v).slice(0, 10);
  if (s === '0000-00-00' || s === 'Invalid d') return '-';
  return s;
}

function dateStatus(v) {
  if (!v || v === '0000-00-00') return 'none';
  const d = new Date(String(v).slice(0, 10) + 'T00:00:00');
  if (isNaN(d)) return 'none';
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const diff = Math.floor((d - today) / 86400000);
  if (diff < 0) return 'past';
  if (diff <= 30) return 'soon';
  return 'ok';
}

/* 이벤트 타입 색상
 * 발전사업 → 파란색 계열 / 개발행위 → 주황·빨강 계열 */
const EVENT_COLORS = {
  'power-scheduled': '#60a5fa',  /* 발전사업 허가예정 — 하늘파랑  */
  'power-permit':    '#2563eb',  /* 발전사업 허가일   — 파랑      */
  'power-expire':    '#1e3a8a',  /* 발전사업 만료일   — 진파랑    */
  'dev-permit':      '#f97316',  /* 개발행위 허가일   — 주황      */
  'dev-expire':      '#dc2626',  /* 개발행위 만료일   — 빨강      */
  'ppa':             '#7c3aed',  /* PPA 접수일        — 보라      */
  'completion':      '#d97706',  /* 준공일            — 황토      */
  'operation':       '#059669',  /* 운전개시일        — 에메랄드  */
};

/* 토스트 알림 */
function toast(message, type = '') {
  let container = document.getElementById('toast-container');
  if (!container) {
    container = document.createElement('div');
    container.id = 'toast-container';
    container.className = 'toast-container';
    document.body.appendChild(container);
  }
  const el = document.createElement('div');
  el.className = 'toast' + (type ? ' toast--' + type : '');
  el.textContent = message;
  container.appendChild(el);
  setTimeout(() => {
    el.style.opacity = '0';
    el.style.transition = 'opacity .3s';
    setTimeout(() => el.remove(), 300);
  }, 3000);
}

/* 확인 모달 */
function confirmDialog(message, title) {
  return new Promise(resolve => {
    const overlay = document.createElement('div');
    overlay.className = 'modal-overlay';
    overlay.innerHTML = `
      <div class="modal-box" style="max-width:380px">
        <div class="modal-header">
          <h3 class="modal-title">${escHtml(title || '확인')}</h3>
        </div>
        <div class="modal-body">
          <p style="font-size:14px;line-height:1.6;white-space:pre-line">${escHtml(message)}</p>
          <div style="display:flex;gap:10px;justify-content:flex-end;margin-top:18px">
            <button class="btn btn-outline" id="_conf_cancel">취소</button>
            <button class="btn btn-primary" id="_conf_ok">확인</button>
          </div>
        </div>
      </div>`;
    document.body.appendChild(overlay);
    const close = v => { overlay.remove(); resolve(v); };
    overlay.querySelector('#_conf_ok').onclick = () => close(true);
    overlay.querySelector('#_conf_cancel').onclick = () => close(false);
    overlay.addEventListener('click', e => { if (e.target === overlay) close(false); });
  });
}

/* 발전소 정보 모달 */
function openPlantModal(plantId) {
  const existing = document.getElementById('plant-detail-modal');
  if (existing) existing.remove();

  const overlay = document.createElement('div');
  overlay.id = 'plant-detail-modal';
  overlay.className = 'plant-modal-overlay';
  overlay.innerHTML = `
    <div class="plant-modal-box">
      <div class="plant-modal-header">
        <h3 class="plant-modal-title" id="_pm_title">불러오는 중...</h3>
        <button type="button" class="plant-modal-close" id="_pm_x">✕</button>
      </div>
      <div class="plant-modal-body" id="_pm_body">
        <div style="text-align:center;padding:40px;color:#94a3b8">로딩 중...</div>
      </div>
      <div class="plant-modal-footer" id="_pm_footer"></div>
    </div>`;
  document.body.appendChild(overlay);

  const titleEl  = overlay.querySelector('#_pm_title');
  const bodyEl   = overlay.querySelector('#_pm_body');
  const footerEl = overlay.querySelector('#_pm_footer');

  const close = () => { overlay.remove(); document.removeEventListener('keydown', escFn); };
  const escFn = e => { if (e.key === 'Escape') close(); };
  overlay.querySelector('#_pm_x').addEventListener('click', close);
  overlay.addEventListener('click', e => { if (e.target === overlay) close(); });
  document.addEventListener('keydown', escFn);

  /* ── 뷰 모드 ── */
  function renderView(p) {
    titleEl.textContent = p.plant_name || '발전소 정보';

    const txt = (v) => {
      const s = v != null && String(v).trim() !== '' ? String(v) : '';
      return s ? `<span class="pm-text">${escHtml(s)}</span>` : `<span class="pm-text pm-text--empty">-</span>`;
    };
    const dtxt = (v) => {
      const s = fmtDate(v);
      if (s === '-') return `<span class="pm-text pm-text--empty">-</span>`;
      const st = dateStatus(v);
      const cls = st === 'past' ? 'pm-text--past' : st === 'soon' ? 'pm-text--soon' : '';
      return `<span class="pm-text ${cls}">${escHtml(s)}</span>`;
    };
    const row   = (label, content) => `<div class="date-row"><label class="form-label">${escHtml(label)}</label><div class="pm-text-wrap">${content}</div></div>`;
    const group = (label, content) => `<div class="form-group"><label class="form-label">${escHtml(label)}</label>${content}</div>`;

    const devStatus = p.dev_permit_status || '';
    const devBadge  = devStatus ? `<span class="dev-status-badge">${escHtml(devStatus)}</span>` : `<span class="pm-text">해당</span>`;
    const devDates  = !devStatus
      ? `${row('개발행위허가일', dtxt(p.dev_permit_date))}${row('개발행위만료일', dtxt(p.dev_permit_expire))}`
      : '';
    const certHtml  = p.biz_cert_filename
      ? `<button type="button" class="btn btn-outline btn-sm" id="_pm_cert_btn">📄 ${escHtml(p.biz_cert_filename)} 보기</button>`
      : `<span class="pm-text pm-text--empty">없음</span>`;

    bodyEl.innerHTML = `
      <div class="register-layout">
        <div class="form-left">
          <div class="section-title">기본 정보</div>
          ${group('발전소 명', txt(p.plant_name))}
          ${group('사업자 명', txt(p.owner_name))}
          ${group('연락처',   txt(p.contact))}
          ${group('주소',     txt(p.address))}
          ${group('용량',     txt(p.capacity))}
          ${group('설치형태', txt(p.install_type))}
          ${group('메모', p.memo ? `<div class="pm-text pm-text--memo">${escHtml(p.memo)}</div>` : `<span class="pm-text pm-text--empty">-</span>`)}
          ${group('사업자등록증', certHtml)}
        </div>
        <div class="form-right">
          <div class="section-title">인허가 날짜</div>
          <div class="date-sections">
            <div class="date-section date-section--power">
              <div class="date-section-head">발전사업</div>
              <div class="date-section-body">
                ${row('발전사업허가예정일', dtxt(p.power_biz_permit_scheduled))}
                ${row('발전사업허가일',     dtxt(p.power_biz_permit_date))}
                ${row('발전사업만료일',     dtxt(p.power_biz_permit_expire))}
              </div>
            </div>
            <div class="date-section date-section--dev">
              <div class="date-section-head">개발행위</div>
              <div class="date-section-body">
                ${row('구분', devBadge)}
                ${devDates}
              </div>
            </div>
            <div class="date-section date-section--ppa">
              <div class="date-section-head">PPA</div>
              <div class="date-section-body">
                ${row('PPA접수일',   dtxt(p.ppa_receive_date))}
                ${row('PPA접수용량', txt(p.ppa_receive_capacity))}
              </div>
            </div>
            <div class="date-section date-section--build">
              <div class="date-section-head">준공 및 운전</div>
              <div class="date-section-body">
                ${row('개발행위준공일', dtxt(p.dev_completion_date))}
                ${row('상업운전개시일', dtxt(p.commercial_operation_date))}
              </div>
            </div>
          </div>
        </div>
      </div>`;

    const certBtn = bodyEl.querySelector('#_pm_cert_btn');
    if (certBtn) certBtn.addEventListener('click', () => window.open(`api/plants/${plantId}/biz-cert`, '_blank'));

    footerEl.innerHTML = '';
    const btnClose = document.createElement('button');
    btnClose.type = 'button'; btnClose.className = 'btn btn-outline'; btnClose.textContent = '닫기';
    btnClose.addEventListener('click', close);
    const btnEdit = document.createElement('button');
    btnEdit.type = 'button'; btnEdit.className = 'btn btn-primary'; btnEdit.textContent = '수정';
    btnEdit.addEventListener('click', () => renderEdit(p));
    footerEl.append(btnClose, btnEdit);
  }

  /* ── 편집 모드 ── */
  function renderEdit(p) {
    titleEl.textContent = (p.plant_name || '발전소') + ' — 수정';

    const d  = (v) => fmtDate(v) === '-' ? '' : fmtDate(v);
    const ds = p.dev_permit_status || '';

    bodyEl.innerHTML = `
      <div class="register-layout">
        <div class="form-left">
          <div class="section-title">기본 정보</div>
          <div class="form-group"><label class="form-label">발전소 명 <span style="color:#dc2626">*</span></label><input class="form-input" id="_e_plant_name" value="${escHtml(p.plant_name||'')}" /></div>
          <div class="form-group"><label class="form-label">사업자 명</label><input class="form-input" id="_e_owner_name" value="${escHtml(p.owner_name||'')}" /></div>
          <div class="form-group"><label class="form-label">연락처</label><input class="form-input" id="_e_contact" value="${escHtml(p.contact||'')}" /></div>
          <div class="form-group"><label class="form-label">주소</label><input class="form-input" id="_e_address" value="${escHtml(p.address||'')}" /></div>
          <div class="form-group"><label class="form-label">용량</label><input class="form-input" id="_e_capacity" value="${escHtml(p.capacity||'')}" /></div>
          <div class="form-group"><label class="form-label">설치형태</label><input class="form-input" id="_e_install_type" value="${escHtml(p.install_type||'')}" /></div>
          <div class="form-group"><label class="form-label">메모</label><textarea class="form-textarea" id="_e_memo" rows="3">${escHtml(p.memo||'')}</textarea></div>
          <div class="form-group">
            <label class="form-label">사업자등록증</label>
            <div class="biz-cert-area" id="_e_cert_area"></div>
            <input type="file" id="_e_cert_file" accept=".pdf,.jpg,.jpeg,.png,.gif,.webp" style="display:none" />
          </div>
        </div>
        <div class="form-right">
          <div class="section-title">인허가 날짜</div>
          <div class="date-sections">
            <div class="date-section date-section--power">
              <div class="date-section-head">발전사업</div>
              <div class="date-section-body">
                <div class="date-row"><label class="form-label">발전사업허가예정일</label><input type="date" class="form-input" id="_e_power_scheduled" value="${d(p.power_biz_permit_scheduled)}" /></div>
                <div class="date-row"><label class="form-label">발전사업허가일</label><input type="date" class="form-input" id="_e_power_date" value="${d(p.power_biz_permit_date)}" /></div>
                <div class="date-row"><label class="form-label">발전사업만료일</label><input type="date" class="form-input" id="_e_power_expire" value="${d(p.power_biz_permit_expire)}" /></div>
              </div>
            </div>
            <div class="date-section date-section--dev">
              <div class="date-section-head">개발행위</div>
              <div class="date-section-body">
                <div class="date-row">
                  <label class="form-label">구분</label>
                  <div class="dev-status-group">
                    <label class="dev-status-opt"><input type="radio" name="_e_dev_status" value="" ${ds===''?'checked':''} /> 해당</label>
                    <label class="dev-status-opt"><input type="radio" name="_e_dev_status" value="미대상" ${ds==='미대상'?'checked':''} /> 미대상</label>
                    <label class="dev-status-opt"><input type="radio" name="_e_dev_status" value="면제대상" ${ds==='면제대상'?'checked':''} /> 면제대상</label>
                  </div>
                </div>
                <div id="_e_dev_date_fields">
                  <div class="date-row"><label class="form-label">개발행위허가일</label><input type="date" class="form-input" id="_e_dev_date" value="${d(p.dev_permit_date)}" /></div>
                  <div class="date-row"><label class="form-label">개발행위만료일</label><input type="date" class="form-input" id="_e_dev_expire" value="${d(p.dev_permit_expire)}" /></div>
                </div>
              </div>
            </div>
            <div class="date-section date-section--ppa">
              <div class="date-section-head">PPA</div>
              <div class="date-section-body">
                <div class="date-row"><label class="form-label">PPA접수일</label><input type="date" class="form-input" id="_e_ppa_date" value="${d(p.ppa_receive_date)}" /></div>
                <div class="date-row"><label class="form-label">PPA접수용량</label><input class="form-input" id="_e_ppa_cap" value="${escHtml(p.ppa_receive_capacity||'')}" /></div>
              </div>
            </div>
            <div class="date-section date-section--build">
              <div class="date-section-head">준공 및 운전</div>
              <div class="date-section-body">
                <div class="date-row"><label class="form-label">개발행위준공일</label><input type="date" class="form-input" id="_e_completion" value="${d(p.dev_completion_date)}" /></div>
                <div class="date-row"><label class="form-label">상업운전개시일</label><input type="date" class="form-input" id="_e_operation" value="${d(p.commercial_operation_date)}" /></div>
              </div>
            </div>
          </div>
        </div>
      </div>`;

    /* 개발행위 구분 토글 */
    const devFields = bodyEl.querySelector('#_e_dev_date_fields');
    bodyEl.querySelectorAll('input[name="_e_dev_status"]').forEach(r => {
      r.addEventListener('change', () => {
        devFields.style.display = r.value === '' ? '' : 'none';
      });
    });
    if (ds !== '') devFields.style.display = 'none';

    /* 사업자등록증 */
    renderModalCert(p.biz_cert_filename || null, plantId);

    footerEl.innerHTML = '';
    const btnCancel = document.createElement('button');
    btnCancel.type = 'button'; btnCancel.className = 'btn btn-outline'; btnCancel.textContent = '취소';
    btnCancel.addEventListener('click', () => renderView(p));
    const btnSave = document.createElement('button');
    btnSave.type = 'button'; btnSave.className = 'btn btn-primary'; btnSave.textContent = '저장';
    btnSave.addEventListener('click', () => saveEdit(p));
    footerEl.append(btnCancel, btnSave);
  }

  /* ── 사업자등록증 영역 렌더 (편집 모드) ── */
  function renderModalCert(filename) {
    const area = bodyEl.querySelector('#_e_cert_area');
    if (!area) return;
    if (filename) {
      area.innerHTML = `
        <div class="biz-cert-file">
          <svg class="biz-cert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
          <span class="biz-cert-name">${escHtml(filename)}</span>
          <button type="button" class="btn btn-sm btn-outline" id="_e_cert_view">보기</button>
          <button type="button" class="btn btn-sm btn-danger-soft" id="_e_cert_del">삭제</button>
        </div>`;
      area.querySelector('#_e_cert_view').addEventListener('click', () => window.open(`api/plants/${plantId}/biz-cert`, '_blank'));
      area.querySelector('#_e_cert_del').addEventListener('click', async () => {
        const ok = await confirmDialog('사업자등록증을 삭제할까요?', '삭제');
        if (!ok) return;
        try {
          await apiSend(`api/plants/${plantId}/biz-cert`, 'DELETE');
          renderModalCert(null);
        } catch (e) { toast(e.message || '삭제 실패', 'error'); }
      });
    } else {
      area.innerHTML = `<button type="button" class="btn btn-sm btn-outline" id="_e_cert_upload">등록</button>`;
      area.querySelector('#_e_cert_upload').addEventListener('click', () => {
        bodyEl.querySelector('#_e_cert_file').click();
      });
    }
    const fileInput = bodyEl.querySelector('#_e_cert_file');
    if (fileInput) {
      fileInput.onchange = null;
      fileInput.addEventListener('change', async function () {
        const file = this.files[0];
        if (!file) return;
        try {
          const fd = new FormData();
          fd.append('file', file);
          const r = await fetch(`api/plants/${plantId}/biz-cert`, { method: 'POST', body: fd });
          const data = await r.json().catch(() => ({}));
          if (!r.ok) throw new Error(data.error || '업로드 실패');
          renderModalCert(data.filename || file.name);
        } catch (e) { toast(e.message || '업로드 실패', 'error'); }
        this.value = '';
      });
    }
  }

  /* ── 저장 ── */
  async function saveEdit(origPlant) {
    const g = id => bodyEl.querySelector(id);
    const plant_name = g('#_e_plant_name').value.trim();
    if (!plant_name) { toast('발전소 명은 필수입니다.', 'error'); return; }

    const body = {
      plant_name,
      owner_name:   g('#_e_owner_name').value.trim(),
      contact:      g('#_e_contact').value.trim(),
      address:      g('#_e_address').value.trim(),
      capacity:     g('#_e_capacity').value.trim(),
      install_type: g('#_e_install_type').value.trim(),
      memo:         g('#_e_memo').value.trim(),
      dev_permit_status: g('input[name="_e_dev_status"]:checked')?.value ?? '',
      power_biz_permit_scheduled: g('#_e_power_scheduled').value || null,
      power_biz_permit_date:      g('#_e_power_date').value || null,
      power_biz_permit_expire:    g('#_e_power_expire').value || null,
      dev_permit_date:            g('#_e_dev_date')?.value || null,
      dev_permit_expire:          g('#_e_dev_expire')?.value || null,
      ppa_receive_date:           g('#_e_ppa_date').value || null,
      ppa_receive_capacity:       g('#_e_ppa_cap').value.trim(),
      dev_completion_date:        g('#_e_completion').value || null,
      commercial_operation_date:  g('#_e_operation').value || null,
    };
    if (body.dev_permit_status !== '') {
      body.dev_permit_date = null;
      body.dev_permit_expire = null;
    }

    try {
      await apiSend(`api/plants/${plantId}`, 'PUT', body);
      const updated = await apiGet(`api/plants/${plantId}`);
      toast('저장되었습니다.', 'success');
      renderView(updated);
    } catch (e) { toast(e.message || '저장 실패', 'error'); }
  }

  apiGet(`api/plants/${plantId}`)
    .then(p => renderView(p))
    .catch(err => {
      bodyEl.innerHTML = `<div style="text-align:center;padding:40px;color:#dc2626">불러오기 실패: ${escHtml(err.message)}</div>`;
    });
}

function escHtml(s) {
  return String(s)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

/* 현재 페이지에 해당하는 nav 항목 active 처리 */
(function () {
  const pageName = window.location.pathname.split('/').pop() || 'index.html';
  document.querySelectorAll('.nav-item').forEach(a => {
    const href = a.getAttribute('href') || '';
    const hName = href.split('/').pop().split('?')[0] || 'index.html';
    a.classList.toggle('active', pageName === hName);
  });
})();
