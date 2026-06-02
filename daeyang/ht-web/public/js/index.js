var dashPagerState = {
  month: 0,
  year: 0,
};
var dashPeriodsCache = null;
var dashRecentCache = [];
var dashThisMonthRecords = [];
var dashNoticeTicker = {
  timer: null,
  lines: [],
  idx: 0,
};

function stopDashNoticeTicker() {
  if (dashNoticeTicker.timer) {
    clearInterval(dashNoticeTicker.timer);
    dashNoticeTicker.timer = null;
  }
}

function normalizeNoticeLines(text) {
  return String(text || "")
    .split(/\r?\n/)
    .map(function (x) {
      return String(x || "").trim();
    })
    .filter(function (x) {
      return x.length > 0;
    });
}

function formatKoreanDateTime() {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth() + 1;
  const day = now.getDate();
  const hours = now.getHours();
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();
  const ampm = hours < 12 ? "오전" : "오후";
  const h = hours % 12 || 12;
  return year + "년 " + month + "월 " + day + "일 " + ampm + " " +
    String(h).padStart(2, "0") + ":" +
    String(minutes).padStart(2, "0") + ":" +
    String(seconds).padStart(2, "0");
}

function renderDashNoticeTicker(text) {
  const strip = document.getElementById("dash-notice-strip");
  const lineEl = document.getElementById("dash-notice-line");
  if (!strip || !lineEl) return;

  stopDashNoticeTicker();
  const lines = normalizeNoticeLines(text);
  dashNoticeTicker.lines = lines;
  dashNoticeTicker.idx = 0;

  strip.style.display = "flex";
  if (!lines.length) {
    lineEl.textContent = formatKoreanDateTime();
    dashNoticeTicker.timer = setInterval(function () {
      lineEl.textContent = formatKoreanDateTime();
    }, 1000);
    return;
  }
  lineEl.textContent = lines[0];
  if (lines.length <= 1) return;

  dashNoticeTicker.timer = setInterval(function () {
    if (!dashNoticeTicker.lines.length) return;
    dashNoticeTicker.idx = (dashNoticeTicker.idx + 1) % dashNoticeTicker.lines.length;
    lineEl.textContent = dashNoticeTicker.lines[dashNoticeTicker.idx];
  }, 5000);
}

function periodCardHtml(key, p, opts) {
  opts = opts || {};
  const sub =
    p.yearMonth != null
      ? p.yearMonth
      : p.year != null
        ? p.year + "년"
        : "";
  const pendingLine =
    !opts.omitPending && p.pendingIssueCount != null
      ? "<div><dt>미발행</dt><dd>" + p.pendingIssueCount + "명</dd></div>"
      : "";
  return (
    '<div class="dash-period-card">' +
    '<div class="dash-period-label">' +
    p.label +
    "</div>" +
    '<div class="dash-period-sub">' +
    sub +
    "</div>" +
    '<dl class="dash-stat-list">' +
    "<div><dt>공급가액</dt><dd>" +
    formatMoney(p.supply) +
    "원</dd></div>" +
    "<div><dt>세액</dt><dd>" +
    formatMoney(p.tax) +
    "원</dd></div>" +
    "<div><dt>총 합계</dt><dd>" +
    formatMoney(p.total) +
    "원</dd></div>" +
    "<div><dt>총 발행 건수</dt><dd>" +
    p.issueCount +
    "건</dd></div>" +
    "<div><dt>발행완료</dt><dd>" +
    (p.transmitted != null ? p.transmitted : 0) +
    "건</dd></div>" +
    pendingLine +
    "<div><dt>전송완료</dt><dd>" +
    p.transmitted +
    "건</dd></div>" +
    "<div><dt>발행대기</dt><dd>" +
    (p.pendingTransmit != null ? p.pendingTransmit : 0) +
    "건</dd></div>" +
    "<div><dt>전송실패</dt><dd>" +
    (p.transmitFailed != null ? p.transmitFailed : 0) +
    "건</dd></div>" +
    "</dl></div>"
  );
}

function renderPeriodSwitchBlock(kind, title, items, idx) {
  const total = items.length;
  if (!total) return "";
  const safeIdx = Math.max(0, Math.min(idx, total - 1));
  const card = periodCardHtml(kind + "-" + safeIdx, items[safeIdx], {
    omitPending: kind === "month",
  });
  return (
    '<section class="dash-switch-block">' +
    '<h3 class="dash-switch-title">' +
    '<button type="button" class="btn btn-secondary dash-switch-btn" data-dash-kind="' +
    kind +
    '" data-dash-dir="1"' +
    (safeIdx >= total - 1 ? " disabled" : "") +
    " aria-label=\"이전\">‹</button>" +
    '<span class="dash-switch-label">' + title + "</span>" +
    '<button type="button" class="btn btn-secondary dash-switch-btn" data-dash-kind="' +
    kind +
    '" data-dash-dir="-1"' +
    (safeIdx <= 0 ? " disabled" : "") +
    " aria-label=\"다음\">›</button>" +
    "</h3>" +
    card +
    "</section>"
  );
}

function renderDashPeriodBlocks(periods) {
  const grid = document.getElementById("dash-period-cards");
  if (!grid || !periods) return;
  const monthItems = [periods.thisMonth, periods.lastMonth].filter(Boolean);
  const yearItems = [periods.thisYear, periods.lastYear].filter(Boolean);
  if (dashPagerState.month >= monthItems.length) dashPagerState.month = 0;
  if (dashPagerState.year >= yearItems.length) dashPagerState.year = 0;
  grid.innerHTML =
    renderPeriodSwitchBlock("month", "월별", monthItems, dashPagerState.month) +
    renderPeriodSwitchBlock("year", "연도별", yearItems, dashPagerState.year);
}

function bindDashPeriodPager() {
  const grid = document.getElementById("dash-period-cards");
  if (!grid || grid.getAttribute("data-pager-bound") === "1") return;
  grid.setAttribute("data-pager-bound", "1");
  grid.addEventListener("click", function (e) {
    const btn = e.target.closest("button[data-dash-kind]");
    if (!btn) return;
    const kind = btn.getAttribute("data-dash-kind");
    const dir = Number(btn.getAttribute("data-dash-dir") || 0);
    if (!kind || !dir || !dashPeriodsCache) return;
    dashPagerState[kind] = Math.max(0, (dashPagerState[kind] || 0) + dir);
    renderDashPeriodBlocks(dashPeriodsCache);
  });
}

function dashTransmitStatusLabel(ts) {
  if (ts === "issued") return "발급완료";
  if (ts === "transmitted_practice") return "전송완료";
  if (ts === "issue_failed") return "발급실패";
  if (ts === "transmit_failed") return "전송실패";
  return "발행대기";
}

function renderDashboard(data) {
  if (data.periods) {
    dashPeriodsCache = data.periods;
    renderDashPeriodBlocks(data.periods);
    bindDashPeriodPager();
  }

  if (data.thisMonthRecords) dashThisMonthRecords = data.thisMonthRecords;

  const strip = document.getElementById("dash-summary-strip");
  if (strip && data.periods) {
    const tm = data.periods.thisMonth || {};
    const transmitted = data.transmittedThisMonth || {};
    const cr = "cursor:pointer";
    strip.innerHTML =
      '<div class="dash-summary-row" style="' + cr + '" data-summary-cat="all"><span class="dash-summary-name">총 건수</span><span class="dash-summary-value">' +
      (Number(tm.issueCount) || 0) +
      "건</span></div>" +
      '<div class="dash-summary-row" style="' + cr + '" data-summary-cat="transmitted"><span class="dash-summary-name">전송완료</span><span class="dash-summary-value">' +
      (Number(tm.transmitted) || 0) +
      "건</span></div>" +
      '<div class="dash-summary-row" style="' + cr + '" data-summary-cat="pending"><span class="dash-summary-name">발행대기</span><span class="dash-summary-value">' +
      (Number(tm.pendingTransmit) || 0) +
      "건</span></div>" +
      '<div class="dash-summary-row" style="' + cr + '" data-summary-cat="failed"><span class="dash-summary-name">전송실패</span><span class="dash-summary-value">' +
      (Number(tm.transmitFailed) || 0) +
      "건</span></div>" +
      '<div class="dash-summary-row dash-summary-divider"></div>' +
      '<div class="dash-summary-row" style="' + cr + '" data-summary-cat="amount-summary"><span class="dash-summary-name">공급가액</span><span class="dash-summary-value">' +
      formatMoney(Number(transmitted.supply) || 0) +
      "원</span></div>" +
      '<div class="dash-summary-row" style="' + cr + '" data-summary-cat="amount-summary"><span class="dash-summary-name">세액</span><span class="dash-summary-value">' +
      formatMoney(Number(transmitted.tax) || 0) +
      "원</span></div>" +
      '<div class="dash-summary-row" style="' + cr + '" data-summary-cat="amount-summary"><span class="dash-summary-name">합계</span><span class="dash-summary-value">' +
      formatMoney(Number(transmitted.total) || 0) +
      "원</span></div>";

    strip.addEventListener("click", function (e) {
      const row = e.target.closest("[data-summary-cat]");
      if (!row) return;
      const cat = row.getAttribute("data-summary-cat");
      if (cat === "amount-summary") {
        openAmountModal("all");
      } else {
        openSummaryModal(cat, row.querySelector(".dash-summary-name").textContent);
      }
    });
  }

  const tbody = document.getElementById("dash-recent-body");
  const empty = document.getElementById("dash-recent-empty");
  if (tbody) {
    tbody.innerHTML = "";
    const list = data.recent || [];
    dashRecentCache = list;
    if (list.length === 0) {
      if (empty) empty.style.display = "block";
    } else {
      if (empty) empty.style.display = "none";
      for (let i = 0; i < list.length; i++) {
        const r = list[i];
        const tr = document.createElement("tr");
        const dt = new Date(r.createdAt);
        const ds = isNaN(dt.getTime())
          ? r.createdAt
          : dt.toLocaleString("ko-KR", { timeZone: "Asia/Seoul" });
        const total = (Number(r.totalSupply) || 0) + (Number(r.totalTax) || 0);

        const td0 = document.createElement("td");
        td0.textContent = ds;
        const td1 = document.createElement("td");
        td1.textContent = r.yearMonth || "";
        const td2 = document.createElement("td");
        td2.textContent = r.recipientName || "";
        const td3 = document.createElement("td");
        td3.textContent = formatMoney(r.totalSupply) + "원";
        const td4 = document.createElement("td");
        td4.textContent = formatMoney(r.totalTax) + "원";
        const td5 = document.createElement("td");
        td5.textContent = formatMoney(total) + "원";
        const td6 = document.createElement("td");
        td6.textContent = dashTransmitStatusLabel(r.transmitStatus);
        tr.appendChild(td0);
        tr.appendChild(td1);
        tr.appendChild(td2);
        tr.appendChild(td3);
        tr.appendChild(td4);
        tr.appendChild(td5);
        tr.appendChild(td6);
        tbody.appendChild(tr);
      }
    }
  }
}

function filterSummaryRecords(category) {
  return dashThisMonthRecords.filter(function (r) {
    if (category === "transmitted") return r.transmitStatus === "transmitted_practice";
    if (category === "pending") return r.transmitStatus !== "transmitted_practice" && r.transmitStatus !== "transmit_failed";
    if (category === "failed") return r.transmitStatus === "transmit_failed";
    return true;
  });
}

function renderSummaryTab(category) {
  const thead = document.getElementById("dash-summary-thead");
  const tbody = document.getElementById("dash-summary-body");
  if (!thead || !tbody) return;

  const isAll = category === "all";
  thead.innerHTML = "<tr><th>공급받는자</th><th>발전소명</th><th>사업주</th>" + (isAll ? "<th>전송상태</th>" : "") + "</tr>";

  const list = filterSummaryRecords(category);
  tbody.innerHTML = "";
  if (!list.length) {
    tbody.innerHTML = "<tr><td colspan='" + (isAll ? 4 : 3) + "' style='color:var(--text-muted)'>해당 항목이 없습니다.</td></tr>";
    return;
  }
  list.forEach(function (r) {
    var tr = document.createElement("tr");
    var cols = [r.recipientName || "", (r.plantNames || []).join(", ") || "-", r.ceoName || "-"];
    if (isAll) cols.push(dashTransmitStatusLabel(r.transmitStatus));
    cols.forEach(function (val) {
      var td = document.createElement("td");
      td.textContent = val;
      tr.appendChild(td);
    });
    tbody.appendChild(tr);
  });
}

function computeAmountTotals(category) {
  var records = dashThisMonthRecords;
  if (category === "transmitted") {
    records = records.filter(function (r) { return r.transmitStatus === "transmitted_practice"; });
  } else if (category === "failed") {
    records = records.filter(function (r) { return r.transmitStatus === "transmit_failed"; });
  }
  var supply = 0, tax = 0;
  records.forEach(function (r) {
    supply += Number(r.totalSupply) || 0;
    tax += Number(r.totalTax) || 0;
  });
  return { supply: supply, tax: tax, total: supply + tax, count: records.length };
}

function renderAmountTab(category) {
  var body = document.getElementById("dash-amount-body");
  if (!body) return;
  var t = computeAmountTotals(category);
  body.innerHTML =
    '<dl class="dash-amount-dl">' +
    '<div><dt>건수</dt><dd>' + t.count + '건</dd></div>' +
    '<div><dt>공급가액</dt><dd>' + formatMoney(t.supply) + '원</dd></div>' +
    '<div><dt>세액</dt><dd>' + formatMoney(t.tax) + '원</dd></div>' +
    '<div class="dash-amount-total"><dt>합계</dt><dd>' + formatMoney(t.total) + '원</dd></div>' +
    '</dl>';
}

function openAmountModal(category) {
  var modal = document.getElementById("dash-amount-modal");
  if (!modal) return;
  var tabs = modal.querySelectorAll(".dash-sum-tab");
  tabs.forEach(function (btn) {
    btn.classList.toggle("active", btn.getAttribute("data-tab") === category);
  });
  renderAmountTab(category);
  modal.style.display = "flex";
}

function openSummaryModal(category) {
  const modal = document.getElementById("dash-summary-modal");
  if (!modal) return;

  const tabs = document.querySelectorAll(".dash-sum-tab");
  tabs.forEach(function (btn) {
    btn.classList.toggle("active", btn.getAttribute("data-tab") === category);
  });

  renderSummaryTab(category);
  modal.style.display = "flex";
}

function dashStatusLabel(s) {
  if (s === "issued") return "발급완료";
  if (s === "cancelled") return "취소";
  return s || "-";
}

function openDashDetailModal(list) {
  const modal = document.getElementById("dash-detail-modal");
  const tbody = document.getElementById("dash-detail-body");
  if (!modal || !tbody) return;
  tbody.innerHTML = "";
  for (var i = 0; i < list.length; i++) {
    var r = list[i];
    var dt = new Date(r.createdAt);
    var ds = isNaN(dt.getTime()) ? r.createdAt : dt.toLocaleString("ko-KR", { timeZone: "Asia/Seoul" });
    var total = (Number(r.totalSupply) || 0) + (Number(r.totalTax) || 0);
    var tr = document.createElement("tr");
    var cols = [
      String(r.id || ""),
      ds,
      r.yearMonth || "",
      r.recipientName || "",
      formatMoney(r.totalSupply) + "원",
      formatMoney(r.totalTax) + "원",
      formatMoney(total) + "원",
      dashTransmitStatusLabel(r.transmitStatus),
      r.lastHometaxError || "-",
    ];
    cols.forEach(function (val) {
      var td = document.createElement("td");
      td.textContent = val;
      tr.appendChild(td);
    });
    tbody.appendChild(tr);
  }
  modal.style.display = "flex";
}

(async function () {
  await loadSiteConfig();
  const ok = await checkLogin();
  if (!ok) return;

  const detailModal = document.getElementById("dash-detail-modal");
  const detailClose = document.getElementById("dash-detail-close");
  const detailBtn = document.getElementById("btn-dash-detail");
  if (detailClose) detailClose.addEventListener("click", function () { detailModal.style.display = "none"; });
  if (detailModal) detailModal.addEventListener("click", function (e) { if (e.target === detailModal) detailModal.style.display = "none"; });
  if (detailBtn) detailBtn.addEventListener("click", function () { openDashDetailModal(dashRecentCache || []); });

  const summaryModal = document.getElementById("dash-summary-modal");
  const summaryClose = document.getElementById("dash-summary-modal-close");
  if (summaryClose) summaryClose.addEventListener("click", function () { summaryModal.style.display = "none"; });
  if (summaryModal) summaryModal.addEventListener("click", function (e) { if (e.target === summaryModal) summaryModal.style.display = "none"; });
  document.getElementById("dash-summary-tabs").addEventListener("click", function (e) {
    const btn = e.target.closest(".dash-sum-tab");
    if (!btn) return;
    openSummaryModal(btn.getAttribute("data-tab"));
  });

  const amountModal = document.getElementById("dash-amount-modal");
  const amountClose = document.getElementById("dash-amount-modal-close");
  if (amountClose) amountClose.addEventListener("click", function () { amountModal.style.display = "none"; });
  if (amountModal) amountModal.addEventListener("click", function (e) { if (e.target === amountModal) amountModal.style.display = "none"; });
  document.getElementById("dash-amount-tabs").addEventListener("click", function (e) {
    const btn = e.target.closest(".dash-sum-tab");
    if (!btn) return;
    openAmountModal(btn.getAttribute("data-tab"));
  });

  document.getElementById("logout-btn").addEventListener("click", async function (e) {
    e.preventDefault();
    const sure = await confirmModal("정말 로그아웃 하시겠습니까?", "로그아웃", "로그아웃");
    if (!sure) return;
    await apiSend("/api/logout", "POST");
    window.location.href = BASE + "/login.html";
  });

  try {
    const me = await apiGet("/api/me");
    renderDashNoticeTicker((me.user || {}).noticeText || "");
    const data = await apiGet("/api/dashboard/stats");
    renderDashboard(data);
  } catch (e) {
    const grid = document.getElementById("dash-period-cards");
    if (grid) grid.innerHTML = "<p class=\"error-msg\">대시보드를 불러오지 못했습니다.</p>";
  }
})();
