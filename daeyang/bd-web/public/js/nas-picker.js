/* NAS 폴더 선택 창 + 공용 도우미 (register.html · nas-link.html 에서 같이 씀)
   먼저 nasUi.root 에 NAS 최상위 폴더(api/nas/status 의 root), nasUi.plantRoot 에 발전소 폴더(plantRoot)를 넣어 두고 사용 */
const nasUi = { root: '', plantRoot: '' };

function formatFileSize(bytes) {
  if (!bytes && bytes !== 0) return '';
  if (bytes < 1024) return `${bytes}B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)}KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)}MB`;
}

// 화면 표시용: NAS_ROOT 이후 경로만
function nasRelPath(p) {
  if (!p) return '';
  const root = nasUi.root || '';
  return p.startsWith(root) ? (p.slice(root.length).replace(/^\//, '') || '(최상위)') : p;
}

// 경로를 탐색기처럼 한 단계씩 들여 써서 표시
//   📁 2025년
//     └ 📁 2. 공사완료(…)
//         └ 📂 0. 공통서류   ← 마지막(연결 폴더)은 굵게
function nasPathTreeHtml(p) {
  const parts = nasRelPath(p).split('/').filter(Boolean);
  const rows = parts.map((name, i) => {
    const last = i === parts.length - 1;
    return `<div class="nas-tree-row${last ? ' nas-tree-row--current' : ''}" style="padding-left:${i * 14}px">`
      + `${i ? '<span class="nas-tree-branch">└</span>' : ''}${last ? '📂' : '📁'} `
      + `<span class="nas-tree-name">${escHtml(name)}</span></div>`;
  });
  return `<div class="nas-tree" title="${escHtml(p)}">${rows.join('')}</div>`;
}

function closeNasModal() {
  const el = document.getElementById('nas-docs-modal');
  if (el) el.remove();
  document.removeEventListener('keydown', nasEscFn);
}
function nasEscFn(e) { if (e.key === 'Escape') closeNasModal(); }

function nasModalShell(title, bodyHtml, maxWidth = 640) {
  closeNasModal();
  const overlay = document.createElement('div');
  overlay.id = 'nas-docs-modal';
  overlay.className = 'plant-modal-overlay';
  overlay.innerHTML = `
    <div class="plant-modal-box" style="max-width:${maxWidth}px">
      <div class="plant-modal-header">
        <h3 class="plant-modal-title">${escHtml(title)}</h3>
        <button type="button" class="plant-modal-close" data-nas-close>✕</button>
      </div>
      <div class="plant-modal-body">${bodyHtml}</div>
    </div>`;
  document.body.appendChild(overlay);
  overlay.addEventListener('click', e => { if (e.target === overlay) closeNasModal(); });
  overlay.querySelector('[data-nas-close]').addEventListener('click', closeNasModal);
  document.addEventListener('keydown', nasEscFn);
  return overlay;
}

/* 폴더 선택 창 — Windows 파일 "열기" 창 형태 (NAS_ROOT 아래만)
   왼쪽: 폴더 트리 / 오른쪽: 현재 폴더 안 폴더·파일 / 위: ← → ↑ 주소줄·검색
   폴더 두 번 클릭 = 들어가기, 파일 두 번 클릭 = 새 탭에서 보기, [이 폴더 연결] = 고르기
   opts
     startPath : 처음 열 폴더 (없으면 발전소 폴더 = nasUi.plantRoot)
     plantId   : 추천 폴더를 보여 줄 발전소 id (없으면 추천 안 함)
     subtitle  : 제목 아래 한 줄 (예: 발전소 이름)
     canUnlink : [연결 해제] 버튼 표시
     onPick(path) / onUnlink() / onCancel() : 버튼 눌렀을 때 (창 닫기는 각 함수가 알아서) */
async function openNasFolderDialog(opts = {}) {
  const root = nasUi.root;
  const rootName = (root || '').split('/').pop();
  const plantRoot = nasUi.plantRoot && nasUi.plantRoot.startsWith(root) ? nasUi.plantRoot : root;
  const plantRootName = plantRoot.split('/').pop();

  const overlay = nasModalShell('서류 폴더 연결', `
    <div class="nfd">
      ${opts.subtitle ? `<div class="nfd-subtitle">${escHtml(opts.subtitle)}</div>` : ''}
      <div class="nfd-bar">
        <button type="button" class="nfd-nav" data-back title="뒤로">←</button>
        <button type="button" class="nfd-nav" data-fwd title="앞으로">→</button>
        <button type="button" class="nfd-nav" data-up title="상위 폴더">↑</button>
        <div class="nfd-addr" id="_nfd_addr"></div>
        <input type="text" class="nfd-search" id="_nfd_q" placeholder="🔍 검색" />
      </div>
      <div id="_nfd_sug"></div>
      <div class="nfd-main">
        <div class="nfd-tree" id="_nfd_tree"></div>
        <div class="nfd-list" id="_nfd_list" tabindex="0"></div>
      </div>
      <div class="nfd-status" id="_nfd_status"></div>
      <div class="nfd-foot">
        <label class="nfd-foot-label">연결할 폴더</label>
        <div class="nfd-target" id="_nfd_target"></div>
      </div>
      <div class="nfd-foot nfd-foot--btns">
        ${opts.canUnlink ? '<button type="button" class="btn btn-sm btn-danger-soft" data-nas-unlink>연결 해제</button>' : '<span></span>'}
        <span class="nfd-btns">
          <button type="button" class="btn btn-sm btn-primary" data-nas-pick>이 폴더 연결</button>
          <button type="button" class="btn btn-sm btn-outline" data-nas-cancel>취소</button>
        </span>
      </div>
    </div>`, 980);

  const $ = s => overlay.querySelector(s);
  const addrEl = $('#_nfd_addr'), qEl = $('#_nfd_q'), treeEl = $('#_nfd_tree'), listEl = $('#_nfd_list');
  const statusEl = $('#_nfd_status'), targetEl = $('#_nfd_target'), pickBtn = $('[data-nas-pick]');

  const nameOf   = p => (p === root ? rootName : p.slice(p.lastIndexOf('/') + 1));
  const parentOf = p => (p === root ? root : p.slice(0, p.lastIndexOf('/')));
  const alive    = () => document.body.contains(overlay);

  // ── 상태 ──
  const entries  = new Map();   // 폴더 → [{name,path,isdir,size,mtime}] (오른쪽 목록용, 한 번 읽은 것)
  const kids     = new Map();   // 폴더 → 하위 폴더만 (왼쪽 트리용)
  const loading  = new Set();
  const failed   = new Map();
  const expanded = new Set([root]);
  let cur = root, sel = null;   // sel = 오른쪽 목록에서 고른 항목 경로
  const back = [], fwd = [];

  async function fetchEntries(p) {
    if (entries.has(p) || loading.has(p)) return;
    loading.add(p); failed.delete(p);
    try {
      const list = (await apiGet(`api/nas/list?path=${encodeURIComponent(p)}`)).entries;
      // 폴더 먼저, 그다음 파일 (각각 이름순)
      list.sort((a, b) => (a.isdir === b.isdir ? a.name.localeCompare(b.name, 'ko') : a.isdir ? -1 : 1));
      entries.set(p, list);
      kids.set(p, list.filter(e => e.isdir));
    } catch (e) {
      failed.set(p, e.message || '폴더를 읽지 못했습니다.');
    }
    loading.delete(p);
  }

  // ── 폴더 이동 ──
  async function go(p, { push = true } = {}) {
    if (push && p !== cur) { back.push(cur); fwd.length = 0; }
    stopDeep();
    cur = p; sel = null; qEl.value = '';
    qEl.placeholder = `🔍 ${nameOf(cur)} 검색`;
    // 트리에서 현재 폴더까지 펼침
    for (let q = cur; ; q = parentOf(q)) { expanded.add(q); if (q === root) break; }
    renderAll();
    if (!entries.has(cur)) { await fetchEntries(cur); if (alive()) renderAll(); }
    // 트리에 위쪽 폴더 목록이 없으면 채움 (처음 열 때 깊은 폴더로 바로 들어간 경우)
    const chain = [];
    for (let q = parentOf(cur); ; q = parentOf(q)) { if (!kids.has(q)) chain.push(q); if (q === root) break; }
    await Promise.all(chain.map(fetchEntries));
    if (alive()) renderTree();
  }

  // ── 그리기 ──
  function renderAll() { renderAddr(); renderTree(); renderList(); renderTarget(); }

  function renderAddr() {
    const parts = [root];
    if (cur !== root) {
      const rel = cur.slice(root.length + 1).split('/');
      rel.forEach((_, i) => parts.push(`${root}/${rel.slice(0, i + 1).join('/')}`));
    }
    addrEl.innerHTML = parts.map(p => `<span class="nfd-crumb" data-go="${escHtml(p)}">${escHtml(nameOf(p))}</span>`)
      .join('<span class="nfd-crumb-sep">›</span>')
      + '<span class="nfd-addr-fill" title="클릭하면 경로를 직접 입력·복사할 수 있습니다"></span>';
    addrEl.scrollLeft = addrEl.scrollWidth;
    $('[data-back]').disabled = !back.length;
    $('[data-fwd]').disabled  = !fwd.length;
    $('[data-up]').disabled   = cur === root;
  }

  function treeRow(p, depth) {
    const list = kids.get(p);
    const open = expanded.has(p);
    const tog = list && !list.length ? '' : (open ? '▾' : '▸');
    let html = `<div class="nfd-tn${p === cur ? ' nfd-tn--cur' : ''}" data-tp="${escHtml(p)}" style="padding-left:${4 + depth * 14}px" title="${escHtml(nameOf(p))}">`
      + `<span class="nfd-tog" data-tog>${tog}</span><span>${open ? '📂' : '📁'}</span>`
      + `<span class="nfd-tn-name">${escHtml(nameOf(p))}</span></div>`;
    if (open && list) for (const c of list) html += treeRow(c.path, depth + 1);
    return html;
  }
  function renderTree() {
    const top = treeEl.scrollTop;
    treeEl.innerHTML = treeRow(root, 0);
    treeEl.scrollTop = top;
    const c = treeEl.querySelector('.nfd-tn--cur');
    if (c) {
      const r = c.getBoundingClientRect(), b = treeEl.getBoundingClientRect();
      if (r.top < b.top || r.bottom > b.bottom) c.scrollIntoView({ block: 'nearest' });
    }
  }

  const FILE_ICON = { pdf: '📕', jpg: '🖼️', jpeg: '🖼️', png: '🖼️', gif: '🖼️', bmp: '🖼️',
    xls: '📊', xlsx: '📊', csv: '📊', doc: '📝', docx: '📝', hwp: '📝', hwpx: '📝', zip: '🗜️', dwg: '📐' };
  const extOf = n => (n.includes('.') ? n.split('.').pop().toLowerCase() : '');
  const iconOf = e => (e.isdir ? '📁' : (FILE_ICON[extOf(e.name)] || '📄'));
  const typeOf = e => (e.isdir ? '파일 폴더' : (extOf(e.name) ? `${extOf(e.name).toUpperCase()} 파일` : '파일'));
  const fmtTime = t => {
    if (!t) return '';
    const d = new Date(t * 1000), z = n => String(n).padStart(2, '0');
    return `${d.getFullYear()}-${z(d.getMonth() + 1)}-${z(d.getDate())} ${z(d.getHours())}:${z(d.getMinutes())}`;
  };

  function itemRow(e, extraCol) {
    return `<div class="nfd-row${e.path === sel ? ' nfd-row--sel' : ''}" data-ip="${escHtml(e.path)}" data-dir="${e.isdir ? 1 : 0}" title="${escHtml(e.name)}">
      <span class="nfd-c-name"><span class="nfd-ico">${iconOf(e)}</span><span class="nfd-name">${escHtml(e.name)}</span></span>
      ${extraCol !== undefined
        ? `<span class="nfd-c-loc">${escHtml(extraCol)}</span>`
        : `<span class="nfd-c-date">${fmtTime(e.mtime)}</span><span class="nfd-c-type">${typeOf(e)}</span>
           <span class="nfd-c-size">${e.isdir ? '' : formatFileSize(e.size)}</span>`}
    </div>`;
  }

  function renderList() {
    if (qEl.value.trim()) return renderSearch();
    const head = `<div class="nfd-head"><span class="nfd-c-name">이름</span><span class="nfd-c-date">수정한 날짜</span>
      <span class="nfd-c-type">유형</span><span class="nfd-c-size">크기</span></div>`;
    const list = entries.get(cur);
    let body;
    if (failed.has(cur)) body = `<div class="nfd-msg nas-error">${escHtml(failed.get(cur))}</div>`;
    else if (!list) body = '<div class="nfd-msg">NAS에서 불러오는 중...</div>';
    else if (!list.length) body = '<div class="nfd-msg">이 폴더는 비어 있습니다.</div>';
    else body = list.map(e => itemRow(e)).join('');
    listEl.innerHTML = head + body;
    if (list) {
      const d = list.filter(e => e.isdir).length;
      statusEl.textContent = `항목 ${list.length}개 (폴더 ${d}개, 파일 ${list.length - d}개)`;
    } else statusEl.textContent = '';
  }

  // 연결 대상: 오른쪽에서 폴더를 골랐으면 그 폴더, 검색 결과에서 파일을 골랐으면 그 파일이 든 폴더,
  //   아무것도 안 골랐으면 지금 보고 있는 폴더
  const target = () => {
    const e = sel && ((entries.get(cur) || []).find(x => x.path === sel) || searchHits.get(sel));
    if (!e) return cur;
    return e.isdir ? e.path : (searchHits.has(sel) ? parentOf(e.path) : cur);
  };
  function renderTarget() {
    const t = target();
    targetEl.innerHTML = t === root
      ? '<span class="nfd-target-empty">발전소 폴더 안으로 들어가거나 폴더를 골라 주세요</span>'
      : nasPathTreeHtml(t);
    pickBtn.disabled = t === root;
  }

  // ── 검색 (현재 폴더 아래) ──
  //   1) 바로: 서버가 미리 읽어 둔 연도·진행단계·현장 폴더 목록 + 지금까지 열어 본 폴더
  //   2) 잠시 뒤: NAS 하위 폴더 전체 검색 (폴더·파일 모두, 찾는 대로 추가)
  //   띄어쓰기는 무시, 검색어가 이름에 들어 있기만 하면 찾음
  let index = null, indexErr = '';
  let searchHits = new Map();
  let deep = null;          // { key, taskid, files: Map, running, capped, err }
  let deepTimer = null;
  const squash = s => String(s || '').normalize('NFC').replace(/\s+/g, '').toLowerCase();

  function stopDeep() {
    clearTimeout(deepTimer);
    if (deep && deep.running && deep.taskid) apiSend(`api/nas/search/${deep.taskid}`, 'DELETE').catch(() => {});
    deep = null;
  }
  function scheduleDeep() {
    clearTimeout(deepTimer);
    const q = qEl.value.trim();
    const key = `${cur}\n${q}`;
    if (deep && deep.key === key) return;
    stopDeep();
    if (!q) return;
    deepTimer = setTimeout(() => runDeep(key, q, cur), 700);
  }
  async function runDeep(key, q, path) {
    const d = deep = { key, taskid: null, files: new Map(), running: true, capped: false, err: '' };
    const live = () => alive() && deep === d;
    try {
      d.taskid = (await apiSend('api/nas/search', 'POST', { path, q })).taskid;
      if (!alive()) { stopDeep(); return; }
      if (live()) renderSearch();
      while (live()) {
        await new Promise(r => setTimeout(r, 1200));
        if (!alive()) { apiSend(`api/nas/search/${d.taskid}`, 'DELETE').catch(() => {}); return; }
        if (deep !== d) return;
        const r = await apiGet(`api/nas/search/${d.taskid}`);
        if (deep !== d) return;
        for (const f of r.files) d.files.set(f.path, f);
        if (r.finished) { d.running = false; d.capped = r.capped; }
        renderSearch();
        if (!d.running) return;
      }
    } catch (e) {
      if (deep !== d) return;
      d.running = false; d.err = e.message || '검색하지 못했습니다.';
      if (alive()) renderSearch();
    }
  }
  const loadIndex = async (refresh) => {
    index = null; indexErr = '';
    if (qEl.value.trim()) renderSearch();
    try {
      const d = await apiGet(`api/nas/folder-index${refresh ? '?refresh=1' : ''}`);
      index = d.folders;
    } catch (e) { indexErr = e.message; }
    if (alive() && qEl.value.trim()) renderSearch();
  };
  const matches = (name, terms) => { const n = squash(name); return terms.every(t => n.includes(t)); };

  function renderSearch() {
    const terms = qEl.value.trim().split(/\s+/).map(squash).filter(Boolean);
    const prefix = cur + '/';
    const pool = new Map();
    for (const f of index || []) pool.set(f.path, { ...f, isdir: true });
    for (const list of entries.values()) for (const e of list) pool.set(e.path, e);
    const deepNow = deep && deep.key === `${cur}\n${qEl.value.trim()}` ? deep : null;
    if (deepNow) for (const f of deepNow.files.values()) pool.set(f.path, f);
    const hits = [...pool.values()].filter(e => e.path.startsWith(prefix) && matches(e.name, terms))
      .sort((a, b) => (a.isdir === b.isdir ? a.path.localeCompare(b.path, 'ko') : a.isdir ? -1 : 1));
    searchHits = new Map(hits.map(e => [e.path, e]));

    const LIMIT = 500;
    let html = '<div class="nfd-head"><span class="nfd-c-name">이름</span><span class="nfd-c-loc">위치</span></div>';
    for (const e of hits.slice(0, LIMIT)) {
      const loc = parentOf(e.path) === cur ? '(이 폴더)' : parentOf(e.path).slice(prefix.length).split('/').join(' › ');
      html += itemRow(e, loc);
    }
    if (!hits.length) {
      const msg = deepNow && deepNow.running ? '하위 폴더 전체에서 찾는 중...'
        : (index || indexErr || deepNow) ? '검색 결과가 없습니다.' : '폴더 목록을 불러오는 중... (몇 초 걸립니다)';
      html += `<div class="nfd-msg">${msg}</div>`;
    }
    const top = listEl.scrollTop;
    listEl.innerHTML = html;
    listEl.scrollTop = top;

    const count = `검색 결과 ${hits.length > LIMIT ? `${hits.length}개 중 ${LIMIT}개 표시` : `${hits.length}개`}`;
    let note;
    if (!deepNow) note = '잠시 후 하위 폴더 전체 검색을 시작합니다';
    else if (deepNow.err) note = `하위 폴더 전체 검색 실패: ${deepNow.err}`;
    else if (deepNow.running) note = '⏳ 하위 폴더 전체 검색 중 — 찾는 대로 추가됩니다 (넓은 폴더는 몇 분 걸릴 수 있어요, 폴더 안으로 들어가서 찾으면 빨라요)';
    else if (deepNow.capped) note = '결과가 너무 많아 일부만 보여 줍니다 — 검색어를 더 자세히 입력해 주세요';
    else note = '✔ 하위 폴더 전체 검색 완료';
    statusEl.innerHTML = escHtml(`${count} · ${note}`)
      + (deepNow && deepNow.running ? ' · <a href="#" data-stop-search>검색 중지</a>' : '')
      + (indexErr ? escHtml(` · 폴더 목록을 불러오지 못함: ${indexErr}`) : '');
    renderTarget();
  }

  // ── 이벤트 ──
  // 주소줄: 이름 클릭 = 그 단계로 이동, 빈 곳 클릭 = 경로 직접 입력(복사·붙여넣기)
  addrEl.addEventListener('click', e => {
    if (addrEl.querySelector('input')) return;
    const c = e.target.closest('[data-go]');
    if (c) { go(c.dataset.go); return; }
    editAddr();
  });

  // 붙여넣은 경로를 NAS 경로로 바꿈
  //   "/대양기업_공유폴더/8. 발전소/2025년", "\\NAS\대양기업_공유폴더\8. 발전소\2025년",
  //   "Z:\8. 발전소\2025년", "8. 발전소 › 2025년" 은 공유폴더 기준,
  //   "2025년/1. 견적진행" 처럼 앞부분이 없으면 발전소 폴더(8. 발전소) 기준
  function parseAddr(text) {
    let s = text.trim().replace(/^"+|"+$/g, '').replace(/\\/g, '/').replace(/\s*›\s*/g, '/');
    const segs = s.split('/').map(x => x.trim()).filter(Boolean);
    const i = segs.indexOf(rootName);
    const j = plantRoot !== root ? segs.indexOf(plantRootName) : -1;
    let base = root, rel;
    if (i >= 0) rel = segs.slice(i + 1);
    else if (j >= 0) { base = plantRoot; rel = segs.slice(j + 1); }
    else {
      const drive = segs.length && /^[A-Za-z]:$/.test(segs[0]);
      rel = segs.filter(x => !/^[A-Za-z]:$/.test(x));
      if (!drive) base = plantRoot;
    }
    if (rel.some(x => x === '..' || x === '.')) return null;
    return rel.length ? `${base}/${rel.join('/')}` : base;
  }

  function editAddr() {
    const input = document.createElement('input');
    input.type = 'text';
    input.className = 'nfd-addr-input';
    input.value = cur;
    addrEl.innerHTML = '';
    addrEl.classList.add('nfd-addr--edit');
    addrEl.appendChild(input);
    input.focus();
    input.select();
    let done = false;
    const finish = (p) => {
      if (done) return;
      done = true;
      addrEl.classList.remove('nfd-addr--edit');
      if (p && p !== cur) go(p); else renderAddr();
    };
    input.addEventListener('keydown', e => {
      if (e.key === 'Enter') {
        e.preventDefault();
        const p = parseAddr(input.value);
        if (!p) { toast('경로를 알아볼 수 없습니다.', 'error'); return; }
        finish(p);
      } else if (e.key === 'Escape') { e.preventDefault(); e.stopPropagation(); finish(null); }
    });
    input.addEventListener('blur', () => finish(null));
  }

  $('[data-back]').addEventListener('click', () => { if (back.length) { fwd.push(cur); go(back.pop(), { push: false }); } });
  $('[data-fwd]').addEventListener('click',  () => { if (fwd.length)  { back.push(cur); go(fwd.pop(), { push: false }); } });
  $('[data-up]').addEventListener('click',   () => { if (cur !== root) go(parentOf(cur)); });

  treeEl.addEventListener('click', async e => {
    const row = e.target.closest('[data-tp]');
    if (!row) return;
    const p = row.dataset.tp;
    if (e.target.closest('[data-tog]')) {
      if (expanded.has(p)) expanded.delete(p);
      else { expanded.add(p); if (!kids.has(p)) { renderTree(); await fetchEntries(p); } }
      if (alive()) renderTree();
    } else go(p);
  });

  const openItem = (p, isDir) => {
    if (isDir) go(p);
    else window.open(`api/nas/file?path=${encodeURIComponent(p)}`, '_blank');
  };
  listEl.addEventListener('click', e => {
    if (e.target.closest('[data-reindex]')) { e.preventDefault(); loadIndex(true); return; }
    const row = e.target.closest('[data-ip]');
    sel = row ? row.dataset.ip : null;
    listEl.querySelectorAll('.nfd-row--sel').forEach(r => r.classList.remove('nfd-row--sel'));
    if (row) row.classList.add('nfd-row--sel');
    renderTarget();
  });
  statusEl.addEventListener('click', e => {
    if (e.target.closest('[data-reindex]')) { e.preventDefault(); loadIndex(true); }
    if (e.target.closest('[data-stop-search]') && deep) {
      // 검색 중지: 지금까지 찾은 결과는 그대로 둠
      e.preventDefault();
      if (deep.taskid) apiSend(`api/nas/search/${deep.taskid}`, 'DELETE').catch(() => {});
      deep.running = false;
      deep.err = '중지함 (지금까지 찾은 것만 표시)';
      renderSearch();
    }
  });
  listEl.addEventListener('dblclick', e => {
    const row = e.target.closest('[data-ip]');
    if (row) openItem(row.dataset.ip, row.dataset.dir === '1');
  });
  // 키보드: ↑↓ 고르기, Enter 열기, Backspace 상위 폴더
  listEl.addEventListener('keydown', e => {
    const rows = [...listEl.querySelectorAll('[data-ip]')];
    const i = rows.findIndex(r => r.dataset.ip === sel);
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault();
      const n = rows[e.key === 'ArrowDown' ? Math.min(i + 1, rows.length - 1) : Math.max(i - 1, 0)];
      if (n) { n.click(); n.scrollIntoView({ block: 'nearest' }); }
    } else if (e.key === 'Enter' && i >= 0) { e.preventDefault(); openItem(sel, rows[i].dataset.dir === '1'); }
    else if (e.key === 'Backspace' && cur !== root) { e.preventDefault(); go(parentOf(cur)); }
  });
  qEl.addEventListener('input', () => {
    sel = null;
    scheduleDeep();
    if (qEl.value.trim()) renderSearch(); else { renderList(); renderTarget(); }
  });
  qEl.addEventListener('keydown', e => {
    if (e.key === 'Enter') { e.preventDefault(); clearTimeout(deepTimer); if (!deep && qEl.value.trim()) runDeep(`${cur}\n${qEl.value.trim()}`, qEl.value.trim(), cur); }
  });

  pickBtn.addEventListener('click', () => {
    const t = target();
    if (t === root) { toast('발전소 폴더 안으로 들어가서 연결해 주세요.', 'error'); return; }
    if (opts.onPick) opts.onPick(t); else closeNasModal();
  });
  $('[data-nas-cancel]').addEventListener('click', () => (opts.onCancel ? opts.onCancel() : closeNasModal()));
  const unlink = $('[data-nas-unlink]');
  if (unlink) unlink.addEventListener('click', () => (opts.onUnlink ? opts.onUnlink() : closeNasModal()));

  // 처음 열 때: 연결된 폴더가 있으면 그 폴더, 없으면 발전소 폴더(8. 발전소)를 열어 둠
  const start = (opts.startPath && opts.startPath.startsWith(root + '/')) ? opts.startPath : plantRoot;
  go(start, { push: false });
  listEl.focus();
  loadIndex(false);

  // 발전소명·주소·사업자명으로 찾은 추천 폴더 (누르면 그 폴더로 이동)
  if (opts.plantId) apiGet(`api/plants/${opts.plantId}/nas-suggest`).then(d => {
    if (!alive() || !d.cands || !d.cands.length) return;
    const sugEl = $('#_nfd_sug');
    sugEl.className = 'nfd-suggest';
    sugEl.innerHTML = `<div class="nfd-suggest-title">💡 추천 경로</div>`
      + d.cands.map(c => `<div class="nfd-suggest-item" data-sug="${escHtml(c.path)}" title="${escHtml(c.why.join('·'))} 일치">
          <span class="al-cand-parent">${escHtml(nasRelPath(parentOf(c.path)).split('/').join(' › '))} ›</span>
          <span>📁 ${escHtml(c.name)}</span></div>`).join('');
    sugEl.addEventListener('click', async e => {
      const it = e.target.closest('[data-sug]');
      if (!it) return;
      const p = it.dataset.sug;
      // 발전소 폴더 안의 "0. 공통서류"(호기별 폴더가 있으면 그 폴더)를 찾아 그 위치를 열고 골라 둠
      let f = p;
      try {
        const r = (await apiSend('api/nas/resolve', 'POST', { items: [{ id: opts.plantId, path: p }] })).results[0];
        if (r && r.folder) f = r.folder;
      } catch (_) { /* 못 찾으면 발전소 폴더를 엶 */ }
      if (f === p) { await go(p); return; }
      await go(parentOf(f));
      sel = f; renderList(); renderTarget();
    });
  }).catch(() => {});
}
