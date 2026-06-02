/* 캘린더 메인 로직 */

const state = {
  view: 'monthly',
  year: new Date().getFullYear(),
  month: new Date().getMonth(), // 0-based
  events: [],
  byDate: {},
  yearlyEventDates: new Set(),
};

let alertsData = { overdue: [], upcoming: [] };
let activeAlertTab = 'overdue';

const MONTH_KO = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
const DOW_KO   = ['일','월','화','수','목','금','토'];

/* ── 초기화 ─────────────────────────────────────────────────────────────── */
document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('btn-first').addEventListener('click', () => { navigate(-12); });
  document.getElementById('btn-prev').addEventListener('click',  () => { navigate(-1);  });
  document.getElementById('btn-today').addEventListener('click', goToday);
  document.getElementById('btn-next').addEventListener('click',  () => { navigate(1);   });
  document.getElementById('btn-last').addEventListener('click',  () => { navigate(12);  });

  document.getElementById('btn-monthly').addEventListener('click', () => setView('monthly'));
  document.getElementById('btn-yearly').addEventListener('click',  () => setView('yearly'));

  document.getElementById('day-modal-close').addEventListener('click', closeModal);
  document.getElementById('day-modal').addEventListener('click', e => {
    if (e.target === document.getElementById('day-modal')) closeModal();
  });
  document.addEventListener('keydown', e => { if (e.key === 'Escape') closeModal(); });

  document.querySelectorAll('.alerts-tab').forEach(btn => {
    btn.addEventListener('click', () => setAlertTab(btn.dataset.tab));
  });

  loadAlerts();
  refresh();
});

/* ── 네비게이션 ──────────────────────────────────────────────────────────── */
function navigate(monthDelta) {
  if (state.view === 'monthly') {
    const d = new Date(state.year, state.month + monthDelta, 1);
    state.year  = d.getFullYear();
    state.month = d.getMonth();
  } else {
    state.year += (monthDelta > 0 ? 1 : -1);
  }
  refresh();
}

function goToday() {
  const now = new Date();
  state.year  = now.getFullYear();
  state.month = now.getMonth();
  setView('monthly');
}

function setView(v) {
  state.view = v;
  document.getElementById('btn-monthly').classList.toggle('active', v === 'monthly');
  document.getElementById('btn-yearly').classList.toggle('active',  v === 'yearly');
  document.getElementById('view-monthly').style.display = v === 'monthly' ? '' : 'none';
  document.getElementById('view-yearly').style.display  = v === 'yearly'  ? '' : 'none';
  refresh();
}

/* ── 데이터 로딩 ─────────────────────────────────────────────────────────── */
async function refresh() {
  updateTitle();
  try {
    await loadEvents();
    if (state.view === 'monthly') renderMonthly();
    else renderYearly();
  } catch (e) {
    console.error(e);
  }
}

async function loadEvents() {
  let url;
  if (state.view === 'monthly') {
    url = `api/events?year=${state.year}&month=${state.month + 1}`;
  } else {
    url = `api/events?year=${state.year}`;
  }
  const events = await apiGet(url);
  state.events = events;
  state.byDate = {};
  state.yearlyEventDates = new Set();
  for (const ev of events) {
    if (!state.byDate[ev.date]) state.byDate[ev.date] = [];
    state.byDate[ev.date].push(ev);
    state.yearlyEventDates.add(ev.date);
  }
}

async function loadAlerts() {
  const list = document.getElementById('alerts-list');
  try {
    const data = await apiGet('api/alerts');
    alertsData = data;

    const oCnt = data.overdue.length;
    const uCnt = data.upcoming.length;

    document.getElementById('tab-count-overdue').textContent = oCnt;
    document.getElementById('tab-count-upcoming').textContent = uCnt;

    if (oCnt === 0 && uCnt > 0) activeAlertTab = 'upcoming';
    else if (oCnt > 0) activeAlertTab = 'overdue';
    setAlertTab(activeAlertTab, false);

    renderAlertItems();
  } catch (e) {
    list.innerHTML = '<div class="alerts-empty">알림을 불러오지 못했습니다.</div>';
  }
}

function setAlertTab(tab, rerender = true) {
  activeAlertTab = tab;
  document.querySelectorAll('.alerts-tab').forEach(btn => {
    btn.classList.toggle('active', btn.dataset.tab === tab);
  });
  if (rerender) renderAlertItems();
}

function renderAlertItems() {
  const list = document.getElementById('alerts-list');
  list.innerHTML = '';

  const items = activeAlertTab === 'overdue'
    ? alertsData.overdue.map(a => ({ ...a, isOver: true }))
    : alertsData.upcoming.map(a => ({ ...a, isOver: false }));

  if (!items.length) {
    const bothEmpty = !alertsData.overdue.length && !alertsData.upcoming.length;
    if (bothEmpty) {
      list.innerHTML = `<div class="alerts-empty"><span class="alerts-empty-icon">✅</span>이상 없음</div>`;
    } else {
      const msg = activeAlertTab === 'overdue'
        ? '만료 초과 항목이 없습니다.'
        : '만료예정 항목이 없습니다.';
      list.innerHTML = `<div class="alerts-empty">${msg}</div>`;
    }
    return;
  }

  for (const a of items) {
    const isPower   = a.type === 'power-expire';
    const typeMod   = isPower ? 'power' : 'dev';
    const typeLabel = isPower ? '발전' : '개발';
    const badgeMod  = a.isOver
      ? `alert-badge--overdue-${typeMod}`
      : `alert-badge--upcoming-${typeMod}`;
    const badgeText = a.isOver
      ? `D+${a.daysAgo}`
      : (a.daysLeft === 0 ? 'D-day' : `D-${a.daysLeft}`);

    const item = document.createElement('div');
    item.className = `alert-item alert-item--${typeMod}`;
    item.innerHTML = `
      <span class="alert-type-tag alert-type-tag--${typeMod}">${typeLabel}</span>
      <span class="alert-item-name">${escHtml(a.plantName)}</span>
      <span class="alert-item-date">${escHtml(a.date)}</span>
      <span class="alert-badge ${badgeMod}">${escHtml(badgeText)}</span>
    `;
    item.addEventListener('click', () => openPlantModal(a.plantId));
    list.appendChild(item);
  }
}

/* ── 제목 업데이트 ────────────────────────────────────────────────────────── */
function updateTitle() {
  const el = document.getElementById('cal-title');
  if (state.view === 'monthly') {
    el.textContent = `${state.year}년 ${MONTH_KO[state.month]}`;
  } else {
    el.textContent = `${state.year}년`;
  }
}

/* ── 월간 뷰 렌더링 ──────────────────────────────────────────────────────── */
function renderMonthly() {
  const grid  = document.getElementById('cal-grid');
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  const firstDay  = new Date(state.year, state.month, 1);
  const lastDay   = new Date(state.year, state.month + 1, 0);
  const startDow  = firstDay.getDay();
  const prevLast  = new Date(state.year, state.month, 0).getDate();

  const cells = [];

  // 이전 달 빈칸
  for (let i = 0; i < startDow; i++) {
    cells.push({ day: prevLast - startDow + i + 1, cur: false, dow: i });
  }

  // 현재 달
  for (let d = 1; d <= lastDay.getDate(); d++) {
    const dow = new Date(state.year, state.month, d).getDay();
    cells.push({ day: d, cur: true, dow });
  }

  // 다음 달 빈칸
  const remain = (7 - (cells.length % 7)) % 7;
  for (let i = 1; i <= remain; i++) {
    cells.push({ day: i, cur: false, dow: (cells.length % 7) });
  }

  grid.innerHTML = '';

  let curDay = 0;
  for (const c of cells) {
    const cell = document.createElement('div');
    cell.className = 'cal-day';
    if (!c.cur) cell.classList.add('cal-day--other');

    let dateStr = '';
    if (c.cur) {
      curDay = c.day;
      const y = state.year;
      const m = String(state.month + 1).padStart(2, '0');
      const d = String(c.day).padStart(2, '0');
      dateStr = `${y}-${m}-${d}`;
      const cellDate = new Date(dateStr + 'T00:00:00');
      const isToday = cellDate.getTime() === today.getTime();
      if (isToday) cell.classList.add('cal-day--today');
    }

    if (c.dow === 0) cell.classList.add('cal-day--sun');
    if (c.dow === 6) cell.classList.add('cal-day--sat');

    // 날짜 숫자
    const numEl = document.createElement('span');
    numEl.className = 'cal-day-num';
    numEl.textContent = c.day;
    cell.appendChild(numEl);

    // 이벤트
    if (c.cur && dateStr) {
      const dayEvents = state.byDate[dateStr] || [];
      const maxShow   = 3;

      dayEvents.slice(0, maxShow).forEach(ev => {
        const pill = document.createElement('div');
        pill.className = `cal-event cal-event--${ev.type}${ev.isPast ? ' is-past' : ''}`;
        pill.textContent = `${ev.plantName} ${ev.label}`;
        pill.title       = `${ev.plantName}: ${ev.label} (${ev.date})`;
        pill.addEventListener('click', e => { e.stopPropagation(); openEventDetail(ev); });
        cell.appendChild(pill);
      });

      if (dayEvents.length > maxShow) {
        const more = document.createElement('div');
        more.className   = 'cal-event-more';
        more.textContent = `+${dayEvents.length - maxShow}개 더`;
        more.addEventListener('click', e => { e.stopPropagation(); openDayModal(dateStr, dayEvents); });
        cell.appendChild(more);
      }

      cell.addEventListener('click', () => {
        if (dayEvents.length) openDayModal(dateStr, dayEvents);
      });
    }

    grid.appendChild(cell);
  }
}

/* ── 연간 뷰 렌더링 ──────────────────────────────────────────────────────── */
function renderYearly() {
  const grid  = document.getElementById('yearly-grid');
  const today = new Date();
  grid.innerHTML = '';

  for (let m = 0; m < 12; m++) {
    const mini = document.createElement('div');
    mini.className = 'mini-cal';
    mini.addEventListener('click', () => {
      state.month = m;
      setView('monthly');
    });

    const title = document.createElement('div');
    title.className   = 'mini-cal-title';
    title.textContent = MONTH_KO[m];
    mini.appendChild(title);

    const miniGrid = document.createElement('div');
    miniGrid.className = 'mini-cal-grid';

    // 요일 헤더
    DOW_KO.forEach(d => {
      const wd = document.createElement('div');
      wd.className   = 'mini-cal-weekday';
      wd.textContent = d;
      miniGrid.appendChild(wd);
    });

    const firstDay = new Date(state.year, m, 1);
    const lastDay  = new Date(state.year, m + 1, 0);
    const startDow = firstDay.getDay();

    // 빈칸
    for (let i = 0; i < startDow; i++) {
      const el = document.createElement('div');
      el.className = 'mini-cal-day mini-cal-day--other';
      miniGrid.appendChild(el);
    }

    for (let d = 1; d <= lastDay.getDate(); d++) {
      const el = document.createElement('div');
      el.className = 'mini-cal-day';
      el.textContent = d;

      const y   = state.year;
      const mStr = String(m + 1).padStart(2, '0');
      const dStr = String(d).padStart(2, '0');
      const dateStr = `${y}-${mStr}-${dStr}`;

      const isToday = today.getFullYear() === y && today.getMonth() === m && today.getDate() === d;
      if (isToday) el.classList.add('mini-cal-day--today');
      if (state.yearlyEventDates.has(dateStr)) el.classList.add('mini-cal-day--has-event');

      miniGrid.appendChild(el);
    }

    mini.appendChild(miniGrid);
    grid.appendChild(mini);
  }
}

/* ── 모달 ────────────────────────────────────────────────────────────────── */
function openDayModal(dateStr, events) {
  const modal   = document.getElementById('day-modal');
  const title   = document.getElementById('day-modal-title');
  const body    = document.getElementById('day-modal-body');

  const d   = new Date(dateStr + 'T00:00:00');
  const dow = DOW_KO[d.getDay()];
  title.textContent = `${dateStr} (${dow})`;

  const list = document.createElement('div');
  list.className = 'modal-event-list';

  for (const ev of events) {
    const item = document.createElement('div');
    item.className = 'modal-event-item';
    item.innerHTML = `
      <div class="modal-event-dot" style="background:${escHtml(EVENT_COLORS[ev.type] || '#888')}"></div>
      <div class="modal-event-info">
        <div class="modal-event-name">${escHtml(ev.plantName)}</div>
        <div class="modal-event-label">${escHtml(ev.label)}${ev.isPast ? ' <span style="color:#dc2626;font-size:10px">(만료)</span>' : ''}</div>
      </div>
      <div class="modal-event-arrow">›</div>
    `;
    item.addEventListener('click', () => openPlantModal(ev.plantId));
    list.appendChild(item);
  }

  body.innerHTML = '';
  body.appendChild(list);
  modal.style.display = 'flex';
}

function openEventDetail(ev) {
  openPlantModal(ev.plantId);
}

function closeModal() {
  document.getElementById('day-modal').style.display = 'none';
}
