let currentMatrixYear = new Date().getFullYear();
let matrixRowsCache = [];
let matrixRowsRecipientCache = [];
let userSupplierCache = {};
let recipientsById = {};
let matrixViewMode = "recipient";

function kindLabel(kind, sub) {
  if (kind === "individual") return "개인";
  if (kind === "foreign") return "외국인";
  if (kind === "business") {
    if (sub === "sole") return "개인사업자";
    if (sub === "corp") return "법인사업자";
    if (sub === "nonprofit") return "비영리법인";
    return "사업자";
  }
  return kind || "-";
}

function openRecipientModal(row, noteTd) {
  const rec = recipientsById[row.recipientId] || {};
  const items = Array.isArray(rec.items) ? rec.items : [];

  function infoRow(label, value) {
    if (!value) return "";
    return '<tr><th>' + escapeHtml(label) + '</th><td>' + escapeHtml(String(value)) + '</td></tr>';
  }

  let plantsHtml = "";
  if (items.length) {
    plantsHtml = '<tr><th>발전소</th><td>' +
      items.map(function (it) { return escapeHtml(it.plantName || "-"); }).join("<br>") +
      '</td></tr>';
  }

  const overlay = document.createElement("div");
  overlay.className = "modal-overlay";
  overlay.innerHTML =
    '<div class="modal-box rec-info-modal">' +
    '<h3 class="modal-title">' + escapeHtml(rec.displayName || row.recipientName || "공급받는자") + '</h3>' +
    '<table class="rec-info-table">' +
    infoRow("구분", kindLabel(rec.kind, rec.bizSubtype)) +
    infoRow("등록번호", rec.bizNo) +
    infoRow("대표자", rec.ceoName) +
    infoRow("연락처", rec.contactPhone) +
    infoRow("이메일", rec.email) +
    infoRow("주소", rec.address) +
    plantsHtml +
    '</table>' +
    '<div class="rec-info-memo-wrap">' +
    '<label class="rec-info-memo-label">메모</label>' +
    '<textarea class="note-modal-textarea" placeholder="메모를 입력하세요"></textarea>' +
    '</div>' +
    '<div class="modal-actions">' +
    '<a href="' + BASE + '/recipients.html?edit=' + (rec.id || row.recipientId) + '" class="btn btn-secondary rec-info-edit-link">공급받는자 수정</a>' +
    '<button type="button" class="btn btn-secondary modal-btn-cancel">닫기</button>' +
    '<button type="button" class="btn btn-primary modal-btn-ok">메모 저장</button>' +
    '</div></div>';

  const textarea = overlay.querySelector(".note-modal-textarea");
  textarea.value = String(row.note || (noteTd && noteTd.dataset.note) || "");

  function close() {
    document.removeEventListener("keydown", onKey);
    if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
  }
  function onKey(e) { if (e.key === "Escape") close(); }

  overlay.addEventListener("click", function (e) { if (e.target === overlay) close(); });
  overlay.querySelector(".modal-btn-cancel").addEventListener("click", close);
  overlay.querySelector(".modal-btn-ok").addEventListener("click", async function () {
    const val = textarea.value.trim();
    try {
      await saveMatrixNote(row.noteRecipientId || row.recipientId, val);
      row.note = val;
      for (let z = 0; z < matrixRowsCache.length; z++) {
        const one = matrixRowsCache[z];
        if ((one.noteRecipientId || one.recipientId) === (row.noteRecipientId || row.recipientId)) {
          one.note = val;
        }
      }
      if (noteTd) { noteTd.textContent = val; noteTd.dataset.note = val; }
      close();
    } catch (e) {
      await alertModal(e.message || "메모 저장 실패");
    }
  });

  document.addEventListener("keydown", onKey);
  document.body.appendChild(overlay);
}

function matrixSymbol(ts) {
  if (ts === "issued") return "●";
  if (ts === "transmitted_practice") return "○";
  if (ts === "issue_failed") return "✕";
  if (ts === "transmit_failed") return "✕";
  if (ts === "not_sent") return "△";
  return "-";
}

function matrixStatusLabel(ts) {
  if (ts === "issued") return "발급완료";
  if (ts === "transmitted_practice") return "전송완료";
  if (ts === "issue_failed") return "발급실패";
  if (ts === "transmit_failed") return "전송실패";
  if (ts === "not_sent") return "발행대기";
  return "미발행";
}

function getFilterDateStr() {
  const el = document.getElementById("filter-date");
  const v = el ? el.value.trim() : "";
  return /^\d{4}-\d{2}-\d{2}$/.test(v) ? v : "";
}

function formatDateMask(raw) {
  const digits = raw.replace(/\D/g, "").slice(0, 8);
  if (digits.length <= 4) return digits;
  if (digits.length <= 6) return digits.slice(0, 4) + "-" + digits.slice(4);
  return digits.slice(0, 4) + "-" + digits.slice(4, 6) + "-" + digits.slice(6);
}

function getFilterValues() {
  function val(id) { return String((document.getElementById(id) || {}).value || ""); }
  return {
    name: val("matrix-recipient-search").trim().toLowerCase().replace(/\s/g, ""),
    kind: val("matrix-kind-filter").trim(),
    date: getFilterDateStr(),
  };
}

function isoToLocalDateStr(isoStr) {
  if (!isoStr) return "";
  const d = new Date(isoStr);
  if (isNaN(d.getTime())) return "";
  return d.getFullYear() + "-" +
    String(d.getMonth() + 1).padStart(2, "0") + "-" +
    String(d.getDate()).padStart(2, "0");
}

function historySearchColActive() {
  const active = document.querySelector("#history-search-col-chips .search-col-chip.active");
  return active ? active.getAttribute("data-col") : "all";
}

function updateHistorySearchPlaceholder() {
  const input = document.getElementById("matrix-recipient-search");
  if (!input) return;
  const active = document.querySelector("#history-search-col-chips .search-col-chip.active");
  input.placeholder = active ? active.textContent.trim() + " 검색" : "전체 검색";
}


function matchesAllFilters(row) {
  const f = getFilterValues();
  const rec = recipientsById[row.recipientId] || {};
  const col = historySearchColActive();

  if (f.name) {
    if (col === "bizno") {
      const bizno = String(rec.bizNo || "").replace(/[^0-9]/g, "");
      const q = f.name.replace(/[^0-9]/g, "");
      if (!q || bizno.indexOf(q) === -1) return false;
    } else if (col === "phone") {
      const phone = String(rec.contactPhone || "").replace(/\D/g, "");
      const q = f.name.replace(/\D/g, "");
      if (!q || phone.indexOf(q) === -1) return false;
    } else if (col === "owner") {
      const ceo = String(rec.ceoName || "").toLowerCase().replace(/\s/g, "");
      if (ceo.indexOf(f.name) === -1) return false;
    } else if (col === "name") {
      const name = String(row.recipientName || "").toLowerCase().replace(/\s/g, "");
      if (name.indexOf(f.name) === -1) return false;
    } else if (col === "plant") {
      const plantMatch = (function () {
        if (row.plantName && row.plantName.toLowerCase().replace(/\s/g, "").indexOf(f.name) !== -1) return true;
        const items = Array.isArray(rec.items) ? rec.items : [];
        for (let pi = 0; pi < items.length; pi++) {
          if (String(items[pi].plantName || "").toLowerCase().replace(/\s/g, "").indexOf(f.name) !== -1) return true;
        }
        return false;
      }());
      if (!plantMatch) return false;
    } else {
      // 전체: 이름·발전소·대표자·사업자번호·연락처·총금액 모두 검색
      const name = String(row.recipientName || "").toLowerCase().replace(/\s/g, "");
      const ceo  = String(rec.ceoName || "").toLowerCase().replace(/\s/g, "");
      const bizno = String(rec.bizNo || "").replace(/[^0-9]/g, "");
      const phone = String(rec.contactPhone || "").replace(/\D/g, "");
      const qDigits = f.name.replace(/[^0-9]/g, "");
      const nameMatch   = name.indexOf(f.name) !== -1;
      const ceoMatch    = ceo.indexOf(f.name) !== -1;
      const biznoMatch  = qDigits.length > 0 && bizno.indexOf(qDigits) !== -1;
      const phoneMatch  = qDigits.length > 0 && phone.indexOf(qDigits) !== -1;
      const amountMatch = qDigits.length > 0 && (
        String(row.total).indexOf(qDigits) !== -1 ||
        formatMoney(row.total).replace(/,/g, "").indexOf(qDigits) !== -1
      );
      const plantMatch = (function () {
        if (row.plantName && row.plantName.toLowerCase().replace(/\s/g, "").indexOf(f.name) !== -1) return true;
        const items = Array.isArray(rec.items) ? rec.items : [];
        for (let pi = 0; pi < items.length; pi++) {
          const pn = String(items[pi].plantName || "").toLowerCase().replace(/\s/g, "");
          if (pn.indexOf(f.name) !== -1) return true;
        }
        return false;
      }());
      if (!nameMatch && !ceoMatch && !biznoMatch && !phoneMatch && !amountMatch && !plantMatch) return false;
    }
  }

  if (f.kind) {
    const kind = rec.kind || "";
    const biz = rec.bizSubtype || "";
    if (f.kind === "individual" && kind !== "individual") return false;
    if (f.kind === "foreign" && kind !== "foreign") return false;
    if (f.kind === "business:sole" && !(kind === "business" && biz === "sole")) return false;
    if (f.kind === "business:corp" && !(kind === "business" && biz === "corp")) return false;
    if (f.kind === "business:nonprofit" && !(kind === "business" && biz === "nonprofit")) return false;
  }

  if (f.date) {
    const records = Array.isArray(row.monthRecords) ? row.monthRecords : [];
    const hasMatch = records.some(function (r) {
      return r && isoToLocalDateStr(r.createdAt) === f.date;
    });
    if (!hasMatch) return false;
  }

  return true;
}

function viewModeValue() {
  const el = document.getElementById("matrix-view-mode");
  const v = String((el && el.value) || "recipient");
  return v === "plant" ? "plant" : "recipient";
}

function cloneMonthRecords(src) {
  const out = [];
  for (let i = 0; i < 12; i++) {
    out.push(src && src[i] ? Object.assign({}, src[i]) : null);
  }
  return out;
}

function buildPlantRows(recipientRows) {
  const rows = [];
  for (let i = 0; i < recipientRows.length; i++) {
    const row = recipientRows[i];
    const rec = recipientsById[row.recipientId] || {};
    const items = Array.isArray(rec.items) ? rec.items : [];
    if (!items.length) {
      rows.push({
        recipientId: row.recipientId,
        noteRecipientId: row.recipientId,
        recipientName: (row.recipientName || "-") + " / 발전소 없음",
        plantName: "",
        supply: 0,
        total: 0,
        note: row.note || "",
        months: (row.months || []).slice(),
        monthRecords: cloneMonthRecords(row.monthRecords),
      });
      continue;
    }
    for (let j = 0; j < items.length; j++) {
      const it = items[j];
      const plantName = String(it.plantName || "").trim() || "발전소명 미입력";
      const supply = Number(it.monthlySupply) || 0;
      const tax = Number(it.monthlyTax) || 0;
      rows.push({
        recipientId: row.recipientId,
        noteRecipientId: row.recipientId,
        recipientName: (row.recipientName || "-") + " / " + plantName,
        plantName: plantName,
        supply: supply,
        total: supply + tax,
        note: row.note || "",
        months: (row.months || []).slice(),
        monthRecords: cloneMonthRecords(row.monthRecords),
      });
    }
  }
  return rows;
}

function syncMatrixRowsByView() {
  matrixViewMode = viewModeValue();
  if (matrixViewMode === "plant") {
    matrixRowsCache = buildPlantRows(matrixRowsRecipientCache || []);
  } else {
    matrixRowsCache = (matrixRowsRecipientCache || []).slice();
  }
}

async function saveMatrixNote(recipientId, note) {
  await apiSend("/api/issue-records/year-matrix/note", "PUT", {
    year: currentMatrixYear,
    recipientId,
    note,
  });
}

function yearMonthPrefix(ym) {
  const s = String(ym || "").trim();
  if (!s || s.length < 7) return "";
  const parts = s.split("-");
  const y = parts[0];
  const mo = Number(parts[1]);
  if (!y || !Number.isFinite(mo) || mo < 1 || mo > 12) return "";
  const yy = String(Number(y) % 100).padStart(2, "0");
  const mm = String(mo).padStart(2, "0");
  return yy + "." + mm + "월분 ";
}

function invoicePartyProfileHist(p, isRecipient) {
  const src = p || {};
  const isBusiness = src.kind === "business" || !isRecipient;
  const name = String(src.displayName || src.corpName || "-").trim() || "-";
  const owner = String(src.ceoName || (isBusiness ? "-" : name)).trim() || "-";
  return {
    bizNo: String(src.bizNo || "-").trim() || "-",
    name: name,
    owner: owner,
    address: String(src.address || "-").trim() || "-",
    bizType: String(src.bizType || "-").trim() || "-",
    bizItem: String(src.bizItem || "-").trim() || "-",
    email: String(src.email || "-").trim() || "-",
  };
}

function buildHistoryPartyTable(sideLabel, sideClass, profile) {
  return (
    '<table class="invoice-party-table">' +
    "<tbody>" +
    "<tr>" +
    '<th class="invoice-party-side ' + sideClass + '" rowspan="5">' + sideLabel + "</th>" +
    '<th class="invoice-party-key">등록번호</th>' +
    '<td class="invoice-party-value">' + escapeHtml(profile.bizNo) + "</td>" +
    '<th class="invoice-party-key">종사업장번호</th>' +
    '<td class="invoice-party-value">&nbsp;</td>' +
    "</tr>" +
    "<tr>" +
    '<th class="invoice-party-key">상호</th>' +
    '<td class="invoice-party-value">' + escapeHtml(profile.name) + "</td>" +
    '<th class="invoice-party-key">성명</th>' +
    '<td class="invoice-party-value">' + escapeHtml(profile.owner) + "</td>" +
    "</tr>" +
    "<tr>" +
    '<th class="invoice-party-key">사업장</th>' +
    '<td class="invoice-party-value" colspan="3">' + escapeHtml(profile.address) + "</td>" +
    "</tr>" +
    "<tr>" +
    '<th class="invoice-party-key">업태</th>' +
    '<td class="invoice-party-value">' + escapeHtml(profile.bizType) + "</td>" +
    '<th class="invoice-party-key">종목</th>' +
    '<td class="invoice-party-value">' + escapeHtml(profile.bizItem) + "</td>" +
    "</tr>" +
    "<tr>" +
    '<th class="invoice-party-key">이메일</th>' +
    '<td class="invoice-party-value" colspan="3">' + escapeHtml(profile.email) + "</td>" +
    "</tr>" +
    "</tbody>" +
    "</table>"
  );
}

function partyBox(title, lines) {
  let rows = "";
  for (let i = 0; i < lines.length; i++) {
    rows +=
      '<div class="party-row"><span class="k">' +
      escapeHtml(lines[i].k) +
      "</span><span class='v'>" +
      escapeHtml(lines[i].v) +
      "</span></div>";
  }
  return (
    '<div class="party-box"><div class="party-head">' +
    escapeHtml(title) +
    '</div><div class="party-body">' +
    rows +
    "</div></div>"
  );
}

function openMonthInvoiceModal(row, monthIdx, detail) {
  if (!detail) {
    alertModal(String(monthIdx + 1) + "월 발행 기록이 없습니다.");
    return;
  }
  const supplier = userSupplierCache || {};
  const rec = recipientsById[row.recipientId] || {};
  const sumSupply = Number(detail.totalSupply) || 0;
  const sumTax = Number(detail.totalTax) || 0;
  const ymValue = String(detail.yearMonth || "");
  const issueDateRaw = String(detail.issueDate || (ymValue.length >= 7 ? ymValue + "-01" : ""));

  // 공급연월일: 귀속월 말일, 오늘보다 미래면 오늘로 제한 — hometaxSubmit.js와 동일 규칙
  const _tn = new Date();
  const _todayKst = _tn.getFullYear() + String(_tn.getMonth() + 1).padStart(2, "0") + String(_tn.getDate()).padStart(2, "0");
  let issueMonth = "";
  let issueDay = "";
  if (ymValue) {
    const _yp = String(ymValue).split("-");
    const _y = Number(_yp[0]);
    const _m = Number(_yp[1]);
    if (_y && _m) {
      const _last = new Date(_y, _m, 0).getDate();
      const _raw = String(_y) + String(_m).padStart(2, "0") + String(_last).padStart(2, "0");
      const _s = _raw <= _todayKst ? _raw : _todayKst;
      issueMonth = _s.slice(4, 6);
      issueDay   = _s.slice(6, 8);
    }
  }
  if (!issueMonth) {
    const _p = issueDateRaw.split("-");
    issueMonth = _p.length >= 2 ? String(Number(_p[1]) || "").padStart(2, "0") : "";
    issueDay   = _p.length >= 3 ? String(Number(_p[2]) || "").padStart(2, "0") : "";
  }
  const isTransmitted = detail.transmitStatus !== "not_sent" && detail.id != null;
  const approvalNo = isTransmitted
    ? issueDateRaw.replace(/\D/g, "") + "-" + String(detail.recipientId || row.recipientId || 0).padStart(4, "0") + String(detail.id).padStart(6, "0")
    : "";

  const plantSummary =
    row.plantName && row.plantName !== "발전소명 미입력"
      ? row.plantName
      : Array.isArray(rec.items) && rec.items.length
        ? rec.items.map(function (x) { return String(x.plantName || "").trim(); }).filter(Boolean).join(", ")
        : "";
  const prefix = yearMonthPrefix(ymValue);
  const itemLabel = prefix + (plantSummary ? "태양광 전기공급(" + plantSummary + ")" : "태양광 전기공급");

  const s = invoicePartyProfileHist(supplier, false);
  const r = invoicePartyProfileHist(rec, true);

  let bodyRows =
    "<tr><td>" + issueMonth + "</td><td>" + issueDay +
    "</td><td class='left'>" + escapeHtml(itemLabel) +
    "</td><td></td><td></td><td></td><td class='num'>" + formatMoney(sumSupply) +
    "</td><td class='num'>" + formatMoney(sumTax) +
    "</td><td class='left'>" + escapeHtml(row.note || "") + "</td></tr>";
  let rowCount = 1;
  while (rowCount < 4) {
    bodyRows += "<tr><td>&nbsp;</td><td></td><td class='left'></td><td></td><td></td><td></td><td class='num'></td><td class='num'></td><td class='left'></td></tr>";
    rowCount++;
  }

  const statusLine =
    '<div style="margin-top:8px;text-align:right;font-size:0.8rem;color:#64748b;">' +
    "기록번호 " + escapeHtml(String(detail.id || "-")) +
    " · 상태 " + escapeHtml(matrixStatusLabel(detail.transmitStatus)) +
    "</div>";

  const html =
    '<div class="invoice-shell invoice-shell-tax">' +
    '<div class="invoice-title-bar">전자세금계산서_일반</div>' +
    '<div class="invoice-table-wrap invoice-approval-wrap">' +
    '<table class="invoice-table invoice-approval-table"><tbody><tr><th>승인번호</th><td>' +
    escapeHtml(approvalNo) + "</td></tr></tbody></table></div>" +
    '<div class="invoice-tax-parties">' +
    buildHistoryPartyTable("공급자", "supplier", s) +
    buildHistoryPartyTable("공급받는자", "buyer", r) +
    "</div>" +
    '<div class="invoice-table-wrap">' +
    '<table class="invoice-table invoice-summary-table">' +
    "<thead><tr><th>작성일자</th><th>공급가액</th><th>세액</th><th>수정사유</th><th>비고</th></tr></thead>" +
    "<tbody><tr><td>" + escapeHtml(issueDateRaw) +
    "</td><td class='num'>" + formatMoney(sumSupply) +
    "</td><td class='num'>" + formatMoney(sumTax) +
    "</td><td class='left'>해당없음</td><td class='left'></td></tr></tbody></table></div>" +
    '<div class="invoice-table-wrap">' +
    '<table class="invoice-table invoice-item-table">' +
    "<thead><tr><th>월</th><th>일</th><th>품목</th><th>규격</th><th>수량</th><th>단가</th><th>공급가액</th><th>세액</th><th>비고</th></tr></thead>" +
    "<tbody>" + bodyRows + "</tbody></table></div>" +
    '<div class="invoice-table-wrap">' +
    '<table class="invoice-table invoice-payment-table">' +
    "<thead><tr><th>합계금액</th><th>현금</th><th>수표</th><th>어음</th><th>외상미수금</th></tr></thead>" +
    "<tbody><tr><td class='num'>" + formatMoney(sumSupply + sumTax) +
    "</td><td></td><td></td><td></td><td></td></tr></tbody></table>" +
    '<div class="invoice-claim-line">이 금액을 ( 청구 ) 함</div>' +
    "</div>" +
    '<div class="invoice-totals"><span>공급가액 합계: ' + formatMoney(sumSupply) +
    "원</span><span>세액 합계: " + formatMoney(sumTax) +
    "원</span><span>합계: " + formatMoney(sumSupply + sumTax) + "원</span></div>" +
    "</div>" +
    statusLine;

  const overlay = document.createElement("div");
  overlay.className = "modal-overlay";
  overlay.setAttribute("role", "dialog");
  overlay.setAttribute("aria-modal", "true");
  overlay.innerHTML =
    '<div class="modal-box" style="max-width: 900px;">' +
    '<div style="display:flex;justify-content:space-between;align-items:center;gap:10px;margin-bottom:10px;">' +
    "<h3 class='modal-title' style='margin:0;'>월별 전자세금계산서</h3>" +
    "<button type='button' class='btn btn-secondary history-invoice-close'>닫기</button>" +
    "</div>" +
    html +
    "</div>";
  function close() {
    document.removeEventListener("keydown", onKey);
    if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
  }
  function onKey(ev) {
    if (ev.key === "Escape") close();
  }
  overlay.addEventListener("click", function (e) {
    if (e.target === overlay) close();
  });
  overlay.querySelector(".history-invoice-close").addEventListener("click", close);
  document.addEventListener("keydown", onKey);
  document.body.appendChild(overlay);
}

function renderMatrixRows() {
  const tbody = document.getElementById("matrix-body");
  const countEl = document.getElementById("matrix-count");
  const totalAmountEl = document.getElementById("matrix-total-amount");
  const isPlantView = matrixViewMode === "plant";
  if (!tbody) return;
  const filtered = matrixRowsCache.filter(matchesAllFilters);
  tbody.innerHTML = "";
  if (filtered.length === 0) {
    tbody.innerHTML = "<tr><td colspan='16' style='color: var(--text-muted)'>표시할 공급받는자가 없습니다.</td></tr>";
    if (countEl) countEl.textContent = "0명";
    if (totalAmountEl) totalAmountEl.textContent = "0원";
    return;
  }
  const sumTotal = filtered.reduce(function (s, r) { return s + (Number(r.total) || 0); }, 0);
  if (totalAmountEl) totalAmountEl.textContent = formatMoney(sumTotal) + "원";
  for (let i = 0; i < filtered.length; i++) {
    const r = filtered[i];
    const tr = document.createElement("tr");
    const tdName = document.createElement("td");
    tdName.textContent = r.recipientName || "";
    tdName.style.cursor = "pointer";
    const tdNote = document.createElement("td");
    const rec = recipientsById[r.recipientId] || {};
    const noteText = String(r.note || rec.internalMemo || "").trim();
    tdNote.className = "history-note-cell";
    tdNote.textContent = noteText;
    tdNote.dataset.note = noteText;

    function openModal(e) {
      e.stopPropagation();
      openRecipientModal(r, tdNote);
    }
    tdName.addEventListener("click", openModal);
    tdNote.addEventListener("click", openModal);
    const tdTotal = document.createElement("td");
    tdTotal.textContent = formatMoney(r.total) + "원";
    const tdSupply = document.createElement("td");
    tdSupply.textContent = formatMoney(r.supply) + "원";
    tr.appendChild(tdName);
    tr.appendChild(tdNote);
    tr.appendChild(tdTotal);
    tr.appendChild(tdSupply);
    const months = Array.isArray(r.months) ? r.months : [];
    const monthRecords = Array.isArray(r.monthRecords) ? r.monthRecords : [];
    for (let m = 0; m < 12; m++) {
      const td = document.createElement("td");
      td.style.textAlign = "center";
      const key = months[m] || "none";
      td.textContent = matrixSymbol(key);
      td.style.cursor = "pointer";
      td.title = String(m + 1) + "월 전자세금계산서 보기";
      td.addEventListener("click", function () {
        openMonthInvoiceModal(r, m, monthRecords[m] || null);
      });
      tr.appendChild(td);
    }
    tbody.appendChild(tr);
  }
  if (countEl) {
    countEl.textContent =
      String(filtered.length) + (isPlantView ? "개소" : "명");
  }
}

async function loadYearMatrix() {
  const tbody = document.getElementById("matrix-body");
  const yearLabel = document.getElementById("matrix-year-label");
  if (!tbody || !yearLabel) return;
  yearLabel.textContent = String(currentMatrixYear) + "년";
  tbody.innerHTML = "<tr><td colspan='16' style='color: var(--text-muted)'>조회 중...</td></tr>";
  try {
    const data = await apiGet("/api/issue-records/year-matrix?year=" + currentMatrixYear);
    let rows = data.rows || [];
    if (!rows.length) {
      const recData = await apiGet("/api/recipients");
      const recs = recData.recipients || [];
      rows = recs.map(function (r) {
        let supply = 0;
        let tax = 0;
        const items = r.items || [];
        for (let i = 0; i < items.length; i++) {
          supply += Number(items[i].monthlySupply) || 0;
          tax += Number(items[i].monthlyTax) || 0;
        }
        return {
          recipientId: r.id,
          recipientName: r.displayName || "",
          supply,
          total: supply + tax,
          months: Array(12).fill("none"),
          monthRecords: Array(12).fill(null),
          note: "",
        };
      });
    }
    for (let i = 0; i < rows.length; i++) {
      if (!Array.isArray(rows[i].monthRecords)) rows[i].monthRecords = Array(12).fill(null);
      if (!Array.isArray(rows[i].months)) rows[i].months = Array(12).fill("none");
      if (typeof rows[i].note !== "string") rows[i].note = "";
    }
    matrixRowsRecipientCache = rows;
    syncMatrixRowsByView();
    renderMatrixRows();
  } catch (e) {
    tbody.innerHTML =
      "<tr><td colspan='16' style='color: var(--danger)'>불러오기 실패: " + (e.message || "오류") + "</td></tr>";
  }
}

(async function () {
  await loadSiteConfig();
  const ok = await checkLogin();
  if (!ok) return;

  document.getElementById("logout-btn").addEventListener("click", async function (e) {
    e.preventDefault();
    const sure = await confirmModal("정말 로그아웃 하시겠습니까?", "로그아웃", "로그아웃");
    if (!sure) return;
    await apiSend("/api/logout", "POST");
    window.location.href = BASE + "/login.html";
  });

  try {
    const me = await apiGet("/api/me");
    userSupplierCache = (me.user || {}).supplier || {};
  } catch (e) {
    userSupplierCache = {};
  }
  try {
    const recData = await apiGet("/api/recipients");
    const recs = recData.recipients || [];
    recipientsById = {};
    for (let i = 0; i < recs.length; i++) {
      recipientsById[recs[i].id] = recs[i];
    }
  } catch (e) {
    recipientsById = {};
  }

  ["matrix-recipient-search"].forEach(function (id) {
    const el = document.getElementById(id);
    if (el) el.addEventListener("input", renderMatrixRows);
  });

  const historyColChips = document.getElementById("history-search-col-chips");
  if (historyColChips) {
    updateHistorySearchPlaceholder();
    historyColChips.addEventListener("click", function (e) {
      const chip = e.target.closest(".search-col-chip");
      if (!chip) return;
      historyColChips.querySelectorAll(".search-col-chip").forEach(function (c) { c.classList.remove("active"); });
      chip.classList.add("active");
      updateHistorySearchPlaceholder();
      renderMatrixRows();
    });
  }

  (function initDateParts() {
    const el = document.getElementById("filter-date");
    if (!el) return;

    el.addEventListener("input", function () {
      const pos = el.selectionStart;
      const oldLen = el.value.length;
      const formatted = formatDateMask(el.value);
      el.value = formatted;
      // 커서가 하이픈 뒤로 자연스럽게 이동
      const diff = formatted.length - oldLen;
      el.setSelectionRange(pos + diff, pos + diff);
      renderMatrixRows();
    });

    const pickerBtn = document.getElementById("btn-date-picker");
    const pickerEl = document.getElementById("filter-date-picker");
    if (pickerBtn && pickerEl) {
      pickerBtn.addEventListener("click", function () {
        if (/^\d{4}-\d{2}-\d{2}$/.test(el.value)) pickerEl.value = el.value;
        try { pickerEl.showPicker(); } catch (_) { pickerEl.click(); }
      });
      pickerEl.addEventListener("change", function () {
        if (!this.value) return;
        el.value = this.value;
        renderMatrixRows();
      });
    }
  }());
  const matrixKindFilterEl = document.getElementById("matrix-kind-filter");
  if (matrixKindFilterEl) {
    matrixKindFilterEl.addEventListener("change", function () {
      updateHistorySearchPlaceholder();
      renderMatrixRows();
    });
  }
  document.getElementById("btn-year-prev").addEventListener("click", function () {
    currentMatrixYear -= 1;
    loadYearMatrix();
  });
  document.getElementById("btn-year-next").addEventListener("click", function () {
    currentMatrixYear += 1;
    loadYearMatrix();
  });

  await loadYearMatrix();
})();
