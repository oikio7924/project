/**
 * 상단 발행옵션 + 좌측 통합 목록(검색/선택/상태) + 우측 단일 미리보기
 */
let supplierData = null;
let allRecipients = [];

let selectedRecipientIds = new Set();
let _issueListTotal = 0;

let invoicePages = [];
let invoicePageIndex = 0;
let issueRecordMap = {}; // { recipientId: record[] }

function todayStr() {
  const d = new Date();
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const day = String(d.getDate()).padStart(2, "0");
  return y + "-" + m + "-" + day;
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

function baseItemName(it, commonText) {
  const fixed = String(it.fixedItemName || "").trim();
  if (fixed) return fixed;
  const common = String(commonText || "").trim();
  if (common) return common;
  const p = String(it.plantName || "").trim();
  if (p) return "태양광 전기공급(" + p + ")";
  return "태양광 전기공급";
}

function invoicePartyProfile(p, isRecipient) {
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

function buildInvoicePartyTable(sideLabel, sideClass, profile) {
  return (
    '<table class="invoice-party-table">' +
    "<tbody>" +
    "<tr>" +
    '<th class="invoice-party-side ' +
    sideClass +
    '" rowspan="5">' +
    sideLabel +
    "</th>" +
    '<th class="invoice-party-key">등록번호</th>' +
    '<td class="invoice-party-value">' +
    escapeHtml(profile.bizNo) +
    "</td>" +
    '<th class="invoice-party-key">종사업장번호</th>' +
    '<td class="invoice-party-value">&nbsp;</td>' +
    "</tr>" +
    "<tr>" +
    '<th class="invoice-party-key">상호</th>' +
    '<td class="invoice-party-value">' +
    escapeHtml(profile.name) +
    "</td>" +
    '<th class="invoice-party-key">성명</th>' +
    '<td class="invoice-party-value">' +
    escapeHtml(profile.owner) +
    "</td>" +
    "</tr>" +
    "<tr>" +
    '<th class="invoice-party-key">사업장</th>' +
    '<td class="invoice-party-value" colspan="3">' +
    escapeHtml(profile.address) +
    "</td>" +
    "</tr>" +
    "<tr>" +
    '<th class="invoice-party-key">업태</th>' +
    '<td class="invoice-party-value">' +
    escapeHtml(profile.bizType) +
    "</td>" +
    '<th class="invoice-party-key">종목</th>' +
    '<td class="invoice-party-value">' +
    escapeHtml(profile.bizItem) +
    "</td>" +
    "</tr>" +
    "<tr>" +
    '<th class="invoice-party-key">이메일</th>' +
    '<td class="invoice-party-value" colspan="3">' +
    escapeHtml(profile.email) +
    "</td>" +
    "</tr>" +
    "</tbody>" +
    "</table>"
  );
}

function buildOneInvoice(supplier, recipient, items, issueDate, defaultItemName, ymValue, recordId, transmitStatus) {
  const s = invoicePartyProfile(supplier, false);
  const r = invoicePartyProfile(recipient, true);
  const prefix = yearMonthPrefix(ymValue);
  let sumSupply = 0;
  let sumTax = 0;
  const issueDateRaw = String(issueDate || "").trim();
  const issueParts = issueDateRaw.split("-");

  // 공급연월일: 귀속월 말일, 오늘(KST)보다 미래면 오늘로 제한 — hometaxSubmit.js와 동일 규칙
  const _tn = new Date();
  const _todayKst = _tn.getFullYear() + String(_tn.getMonth() + 1).padStart(2, "0") + String(_tn.getDate()).padStart(2, "0");
  let supplyMonth = "";
  let supplyDay = "";
  if (ymValue) {
    const _yp = String(ymValue).split("-");
    const _y = Number(_yp[0]);
    const _m = Number(_yp[1]);
    if (_y && _m) {
      const _last = new Date(_y, _m, 0).getDate();
      const _raw = String(_y) + String(_m).padStart(2, "0") + String(_last).padStart(2, "0");
      const _s = _raw <= _todayKst ? _raw : _todayKst;
      supplyMonth = _s.slice(4, 6);
      supplyDay   = _s.slice(6, 8);
    }
  }
  if (!supplyMonth) {
    supplyMonth = issueParts.length >= 2 ? String(Number(issueParts[1]) || "").padStart(2, "0") : "";
    supplyDay   = issueParts.length >= 3 ? String(Number(issueParts[2]) || "").padStart(2, "0") : "";
  }

  const isTransmitted = recordId != null && transmitStatus !== "not_sent";
  const approvalNo = isTransmitted
    ? issueDateRaw.replace(/\D/g, "") + "-" + String((recipient && recipient.id) || 0).padStart(4, "0") + (recordId != null ? String(recordId).padStart(6, "0") : "")
    : "";
  let bodyRows = "";
  let rowCount = 0;
  for (let i = 0; i < items.length; i++) {
    const it = items[i];
    sumSupply += Number(it.monthlySupply) || 0;
    sumTax += Number(it.monthlyTax) || 0;
    const itemName = prefix + baseItemName(it, defaultItemName);
    const note = it.note || "";
    rowCount++;
    bodyRows +=
      "<tr><td>" +
      supplyMonth +
      "</td><td>" +
      supplyDay +
      "</td><td class='left'>" +
      escapeHtml(itemName) +
      "</td><td></td><td></td><td></td><td class='num'>" +
      formatMoney(it.monthlySupply) +
      "</td><td class='num'>" +
      formatMoney(it.monthlyTax) +
      "</td><td class='left'>" +
      escapeHtml(note) +
      "</td></tr>";
  }
  if (!bodyRows) {
    rowCount = 1;
    bodyRows =
      "<tr><td>" +
      supplyMonth +
      "</td><td>" +
      supplyDay +
      "</td><td class='left'></td><td></td><td></td><td></td><td class='num'>0</td><td class='num'>0</td><td class='left'></td></tr>";
  }
  while (rowCount < 4) {
    bodyRows += "<tr><td>&nbsp;</td><td></td><td class='left'></td><td></td><td></td><td></td><td class='num'></td><td class='num'></td><td class='left'></td></tr>";
    rowCount++;
  }

  return (
    '<div class="invoice-shell invoice-shell-tax">' +
    '<div class="invoice-title-bar">전자세금계산서_일반</div>' +
    '<div class="invoice-table-wrap invoice-approval-wrap">' +
    '<table class="invoice-table invoice-approval-table"><tbody><tr><th>승인번호</th><td>' +
    escapeHtml(approvalNo) +
    "</td></tr></tbody></table>" +
    "</div>" +
    '<div class="invoice-tax-parties">' +
    buildInvoicePartyTable("공급자", "supplier", s) +
    buildInvoicePartyTable("공급받는자", "buyer", r) +
    "</div>" +
    '<div class="invoice-table-wrap">' +
    '<table class="invoice-table invoice-summary-table">' +
    "<thead><tr><th>작성일자</th><th>공급가액</th><th>세액</th><th>수정사유</th><th>비고</th></tr></thead>" +
    "<tbody><tr><td>" +
    escapeHtml(issueDateRaw) +
    "</td><td class='num'>" +
    formatMoney(sumSupply) +
    "</td><td class='num'>" +
    formatMoney(sumTax) +
    "</td><td class='left'>해당없음</td><td class='left'></td></tr></tbody>" +
    "</table>" +
    "</div>" +
    '<div class="invoice-table-wrap">' +
    '<table class="invoice-table invoice-item-table">' +
    "<thead><tr><th>월</th><th>일</th><th>품목</th><th>규격</th><th>수량</th><th>단가</th><th>공급가액</th><th>세액</th><th>비고</th></tr></thead>" +
    "<tbody>" +
    bodyRows +
    "</tbody></table>" +
    "</div>" +
    '<div class="invoice-table-wrap">' +
    '<table class="invoice-table invoice-payment-table">' +
    "<thead><tr><th>합계금액</th><th>현금</th><th>수표</th><th>어음</th><th>외상미수금</th></tr></thead>" +
    "<tbody><tr><td class='num'>" +
    formatMoney(sumSupply + sumTax) +
    "</td><td></td><td></td><td></td><td></td></tr></tbody></table>" +
    '<div class="invoice-claim-line">이 금액을 ( 청구 ) 함</div>' +
    "</div>" +
    "</div>"
  );
}

function sessionSearchRaw() {
  const q = document.getElementById("issue-session-search");
  return q ? q.value.trim().toLowerCase().replace(/\s/g, "") : "";
}

function issueKindFilterValue() {
  const el = document.getElementById("issue-kind-filter");
  return el ? String(el.value || "").trim() : "";
}

function issueTransmitFilterValue() {
  const el = document.getElementById("issue-transmit-filter");
  return el ? String(el.value || "").trim() : "";
}

function recipientTypeKey(rec) {
  if (!rec) return "";
  if (rec.kind === "individual") return "individual";
  if (rec.kind === "foreign") return "foreign";
  if (rec.kind === "business") {
    if (rec.bizSubtype === "corp") return "corp";
    if (rec.bizSubtype === "nonprofit") return "nonprofit";
    return "sole";
  }
  return "";
}

function recipientTransmitKey(rec, page) {
  if (!recipientHasItems(rec)) return "not_sent";
  if (!page) return "not_sent";
  if (page.transmitStatus === "transmitted_practice") return "transmitted";
  if (page.transmitStatus === "transmit_failed") return "failed";
  if (page.recordId != null) return "pending";
  return "not_sent";
}

function issueSearchColActive() {
  const active = document.querySelector("#issue-search-col-chips .search-col-chip.active");
  return active ? active.getAttribute("data-col") : "all";
}

function issueSearchMatches(rec, page, raw) {
  if (!raw) return true;
  const col = issueSearchColActive();
  if (col === "bizno") {
    const bizno = String(rec.bizNo || "").replace(/[^0-9]/g, "");
    const q = raw.replace(/[^0-9]/g, "");
    return !!q && bizno.indexOf(q) !== -1;
  }
  if (col === "phone") {
    const phone = String(rec.contactPhone || "").replace(/\D/g, "");
    const q = raw.replace(/\D/g, "");
    return !!q && phone.indexOf(q) !== -1;
  }
  if (col === "name") {
    const name = String(rec.displayName || "").toLowerCase().replace(/\s/g, "");
    return name.indexOf(raw) !== -1;
  }
  if (col === "owner") {
    const ceo = String(rec.ceoName || "").toLowerCase().replace(/\s/g, "");
    return ceo.indexOf(raw) !== -1;
  }
  if (col === "plant") {
    const items = Array.isArray(rec.items) ? rec.items : [];
    return items.some(function (it) {
      return String(it.plantName || "").toLowerCase().replace(/\s/g, "").indexOf(raw) !== -1;
    });
  }
  // 전체: 일반 haystack 검색 + 숫자 입력 시 사업자번호·연락처 digit 검색 병행
  if (issueSearchHaystack(rec, page).indexOf(raw) !== -1) return true;
  const qDigits = raw.replace(/[^0-9]/g, "");
  if (qDigits) {
    const bizno = String(rec.bizNo || "").replace(/[^0-9]/g, "");
    if (bizno.indexOf(qDigits) !== -1) return true;
    const phone = String(rec.contactPhone || "").replace(/\D/g, "");
    if (phone.indexOf(qDigits) !== -1) return true;
  }
  return false;
}

function rowMatchesIssueFilters(rec, page) {
  const kf = issueKindFilterValue();
  if (kf && recipientTypeKey(rec) !== kf) return false;
  const tf = issueTransmitFilterValue();
  if (tf && recipientTransmitKey(rec, page) !== tf) return false;
  return true;
}

function updateIssueSearchPlaceholder() {
  const input = document.getElementById("issue-session-search");
  if (!input) return;
  const active = document.querySelector("#issue-search-col-chips .search-col-chip.active");
  input.placeholder = active ? active.textContent.trim() + " 검색" : "전체 검색";
}

function hasMeaningfulItem(it) {
  return !!(
    String(it.plantName || "").trim() ||
    String(it.fixedItemName || "").trim() ||
    String(it.note || "").trim() ||
    Number(it.monthlySupply || 0) > 0
  );
}

function openRecipientEditModal(rec) {
  const r = rec || {};
  return new Promise(function (resolve) {
    const overlay = document.createElement("div");
    overlay.className = "modal-overlay";
    overlay.setAttribute("role", "dialog");
    overlay.setAttribute("aria-modal", "true");
    overlay.setAttribute("aria-labelledby", "issue-rec-edit-title");
    overlay.innerHTML =
      '<div class="modal-box issue-rec-edit-modal">' +
      '<h3 id="issue-rec-edit-title" class="modal-title">공급받는자 수정</h3>' +
      '<div class="issue-rec-edit-grid">' +
      '<div class="field"><label for="issue-rec-kind">구분</label><select id="issue-rec-kind"><option value="individual">개인</option><option value="business">사업자</option><option value="foreign">외국인</option></select></div>' +
      '<div class="field" id="issue-rec-biz-wrap"><label for="issue-rec-biz-subtype">사업자 세부</label><select id="issue-rec-biz-subtype"><option value="sole">개인사업자</option><option value="corp">법인</option><option value="nonprofit">비영리</option></select></div>' +
      '<div class="field"><label for="issue-rec-name">상호</label><input id="issue-rec-name" /></div>' +
      '<div class="field"><label for="issue-rec-bizno">등록번호</label><input id="issue-rec-bizno" placeholder="사업자번호 또는 주민번호 일부" /></div>' +
      '<div class="field"><label for="issue-rec-ceo">대표자명</label><input id="issue-rec-ceo" /></div>' +
      '<div class="field"><label for="issue-rec-email">이메일</label><input id="issue-rec-email" type="email" /></div>' +
      '<div class="field full"><label for="issue-rec-address">주소</label><input id="issue-rec-address" /></div>' +
      '<div class="field" id="issue-rec-biztype-wrap"><label for="issue-rec-biztype">업태</label><input id="issue-rec-biztype" /></div>' +
      '<div class="field" id="issue-rec-bizitem-wrap"><label for="issue-rec-bizitem">종목</label><input id="issue-rec-bizitem" /></div>' +
      '<div class="field full"><label for="issue-rec-memo">메모 (관리용)</label><textarea id="issue-rec-memo" rows="2" maxlength="500" placeholder="세금계산서에 표시되지 않습니다."></textarea></div>' +
      "</div>" +
      '<div class="issue-rec-item-editor">' +
      '<div class="issue-rec-item-head"><strong>품목</strong><button type="button" class="btn btn-secondary issue-item-add">품목 추가</button></div>' +
      '<div class="issue-rec-item-wrap"><table class="data-table issue-rec-item-table">' +
      "<colgroup><col span='10'/><col style='width:56px'/></colgroup>" +
      "<tbody class='issue-rec-items-body'></tbody>" +
      "</table></div>" +
      "</div>" +
      '<p class="hint issue-rec-edit-help">저장하면 발행 목록과 현재 미리보기가 즉시 갱신됩니다.</p>' +
      '<div class="modal-actions">' +
      '<button type="button" class="btn btn-secondary issue-rec-cancel">취소</button>' +
      '<button type="button" class="btn btn-primary issue-rec-save">저장</button>' +
      "</div></div>";

    const kindEl = overlay.querySelector("#issue-rec-kind");
    const bizWrap = overlay.querySelector("#issue-rec-biz-wrap");
    const bizSubtypeEl = overlay.querySelector("#issue-rec-biz-subtype");
    const nameEl = overlay.querySelector("#issue-rec-name");
    const bizNoEl = overlay.querySelector("#issue-rec-bizno");
    const ceoEl = overlay.querySelector("#issue-rec-ceo");
    const emailEl = overlay.querySelector("#issue-rec-email");
    const addrEl = overlay.querySelector("#issue-rec-address");
    const bizTypeWrap = overlay.querySelector("#issue-rec-biztype-wrap");
    const bizItemWrap = overlay.querySelector("#issue-rec-bizitem-wrap");
    const bizTypeEl = overlay.querySelector("#issue-rec-biztype");
    const bizItemEl = overlay.querySelector("#issue-rec-bizitem");
    const memoEl = overlay.querySelector("#issue-rec-memo");
    const itemsBody = overlay.querySelector(".issue-rec-items-body");

    kindEl.value = r.kind || "individual";
    bizSubtypeEl.value = r.bizSubtype || "sole";
    nameEl.value = r.displayName || "";
    bizNoEl.value = formatRecipientRegNoByKind(kindEl.value, r.bizNo || "");
    ceoEl.value = r.ceoName || "";
    emailEl.value = r.email || "";
    addrEl.value = r.address || "";
    bizTypeEl.value = r.bizType || "";
    bizItemEl.value = r.bizItem || "";
    memoEl.value = r.internalMemo || "";

    function syncBizSubtypeVisible() {
      const isBiz = kindEl.value === "business";
      bizWrap.style.display = isBiz ? "block" : "none";
      bizTypeWrap.style.display = isBiz ? "block" : "none";
      bizItemWrap.style.display = isBiz ? "block" : "none";
      if (kindEl.value === "business" || kindEl.value === "individual") {
        bizNoEl.value = formatRecipientRegNoByKind(kindEl.value, bizNoEl.value);
      }
    }
    syncBizSubtypeVisible();
    kindEl.addEventListener("change", syncBizSubtypeVisible);
    bizNoEl.addEventListener("keydown", function (e) {
      if (kindEl.value !== "business" && kindEl.value !== "individual") return;
      if (e.ctrlKey || e.metaKey || e.altKey) return;
      if (!e.key || e.key.length !== 1) return;
      if (/[0-9]/.test(e.key)) return;
      e.preventDefault();
    });
    bizNoEl.addEventListener("input", function () {
      if (kindEl.value !== "business" && kindEl.value !== "individual") return;
      const formatted = formatRecipientRegNoByKind(kindEl.value, bizNoEl.value);
      if (formatted !== bizNoEl.value) bizNoEl.value = formatted;
    });

    function makeItemRow(item) {
      const frag = document.createDocumentFragment();
      const tr1 = document.createElement("tr");
      const tr2 = document.createElement("tr");
      tr1.setAttribute("data-item-primary", "1");
      if (item && item.id != null) tr1.setAttribute("data-item-id", String(item.id));

      function labeledTd(label, inp, span) {
        const td = document.createElement("td");
        if (span) td.colSpan = span;
        const lbl = document.createElement("div");
        lbl.className = "item-col-label";
        lbl.textContent = label;
        td.appendChild(lbl);
        td.appendChild(inp);
        return td;
      }
      function makeInp(cls, val) {
        const inp = document.createElement("input"); inp.className = cls; inp.style.width = "100%";
        inp.value = val || ""; return inp;
      }
      function commaInp(cls, val, allowDecimal) {
        const inp = document.createElement("input"); inp.className = cls; inp.style.width = "100%";
        inp.type = "text"; inp.inputMode = "numeric";
        function fmt(v) {
          let s = String(v).replace(/[^0-9.]/g, "");
          if (!allowDecimal) s = s.replace(/\./g, "");
          if (!s) return "";
          const parts = s.split(".");
          const n = parseInt(parts[0] || "0", 10) || 0;
          const i = n.toLocaleString("ko-KR");
          return (allowDecimal && parts.length > 1) ? i + "." + parts[1] : i;
        }
        inp.addEventListener("input", function () {
          const pos = this.selectionStart; const oldLen = this.value.length;
          const nv = fmt(this.value); this.value = nv;
          try { const np = Math.max(0, pos + nv.length - oldLen); this.setSelectionRange(np, np); } catch (e) {}
        });
        inp.value = fmt(String(Number(val) || 0));
        return inp;
      }
      function readComma(inp, allowDecimal) {
        const s = String(inp.value).replace(/,/g, "");
        return allowDecimal ? (parseFloat(s) || 0) : (parseInt(s, 10) || 0);
      }

      const plantInp = makeInp("issue-it-plant", (item && item.plantName) || "");
      const fixedInp = makeInp("issue-it-fixed", (item && item.fixedItemName) || "");

      // 행1: 라벨+입력란(5칸) / 라벨+입력란(5칸) / 삭제(rowspan=2)
      tr1.appendChild(labeledTd("발전소", plantInp, 5));
      tr1.appendChild(labeledTd("품목명", fixedInp, 5));
      const tdDel = document.createElement("td");
      tdDel.rowSpan = 2;
      tdDel.style.cssText = "text-align:center;vertical-align:middle";
      const delBtn = document.createElement("button"); delBtn.type = "button"; delBtn.className = "btn btn-danger issue-it-del"; delBtn.textContent = "-";
      tdDel.appendChild(delBtn); tr1.appendChild(tdDel);
      delBtn.addEventListener("click", function () {
        if (tr1.parentNode) tr1.parentNode.removeChild(tr1);
        if (tr2.parentNode) tr2.parentNode.removeChild(tr2);
      });

      // 행2: 라벨+입력란(2칸씩) × 5 = 동일 너비
      const qtyInp  = commaInp("issue-it-qty",      (item && item.quantity)      || 0, true);
      const upInp   = commaInp("issue-it-unitprice", (item && item.unitPrice)     || 0, false);
      const supInp  = commaInp("issue-it-supply",    (item && item.monthlySupply) || 0, false);
      const taxInp  = document.createElement("input"); taxInp.className = "issue-it-tax"; taxInp.readOnly = true; taxInp.tabIndex = -1;
      taxInp.style.cssText = "width:100%;background:#f8fafc;cursor:not-allowed";
      const noteInp = makeInp("issue-it-note", (item && item.note) || "");

      tr2.appendChild(labeledTd("수량", qtyInp, 2));
      tr2.appendChild(labeledTd("단가", upInp, 2));
      tr2.appendChild(labeledTd("공급가액", supInp, 2));
      tr2.appendChild(labeledTd("세액", taxInp, 2));
      tr2.appendChild(labeledTd("비고", noteInp, 2));

      function syncTax() {
        const s = readComma(supInp, false);
        taxInp.value = Math.floor(s * 0.1).toLocaleString("ko-KR");
      }
      supInp.addEventListener("input", syncTax);
      syncTax();

      frag.appendChild(tr1);
      frag.appendChild(tr2);
      return frag;
    }

    const baseItems = Array.isArray(r.items) ? r.items : [];
    for (let i = 0; i < baseItems.length; i++) {
      itemsBody.appendChild(makeItemRow(baseItems[i]));
    }
    overlay.querySelector(".issue-item-add").addEventListener("click", function () {
      itemsBody.appendChild(makeItemRow({}));
    });

    function close(v) {
      document.removeEventListener("keydown", onKey);
      if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
      resolve(v);
    }
    function onKey(ev) {
      if (ev.key === "Escape") close(null);
    }

    overlay.addEventListener("click", function (ev) {
      if (ev.target === overlay) close(null);
    });
    overlay.querySelector(".issue-rec-cancel").addEventListener("click", function () {
      close(null);
    });
    overlay.querySelector(".issue-rec-save").addEventListener("click", async function () {
      const displayName = String(nameEl.value || "").trim();
      if (!displayName) {
        await alertModal("이름/상호를 입력하세요.");
        nameEl.focus();
        return;
      }
      const primaryRows = itemsBody.querySelectorAll("tr[data-item-primary]");
      const items = [];
      for (let i = 0; i < primaryRows.length; i++) {
        const tr1 = primaryRows[i];
        const tr2 = tr1.nextElementSibling;
        if (!tr2) continue;
        const one = {
          id: tr1.hasAttribute("data-item-id") ? Number(tr1.getAttribute("data-item-id")) : null,
          plantName: String(tr1.querySelector(".issue-it-plant").value || "").trim(),
          fixedItemName: String(tr1.querySelector(".issue-it-fixed").value || "").trim(),
          quantity: parseFloat(String(tr2.querySelector(".issue-it-qty").value).replace(/,/g, "")) || 0,
          unitPrice: parseInt(String(tr2.querySelector(".issue-it-unitprice").value).replace(/,/g, ""), 10) || 0,
          monthlySupply: parseInt(String(tr2.querySelector(".issue-it-supply").value).replace(/,/g, ""), 10) || 0,
          note: String(tr2.querySelector(".issue-it-note").value || "").trim(),
        };
        one.monthlyTax = Math.floor(one.monthlySupply * 0.1);
        if (one.id != null || hasMeaningfulItem(one)) items.push(one);
      }
      close({
        recipientBody: {
          kind: kindEl.value,
          bizSubtype: kindEl.value === "business" ? bizSubtypeEl.value : null,
          displayName,
          bizNo: formatRecipientRegNoByKind(kindEl.value, String(bizNoEl.value || "").trim()),
          ceoName: String(ceoEl.value || "").trim(),
          address: String(addrEl.value || "").trim(),
          email: String(emailEl.value || "").trim(),
          bizType: kindEl.value === "business" ? String(bizTypeEl.value || "").trim() : "",
          bizItem: kindEl.value === "business" ? String(bizItemEl.value || "").trim() : "",
          internalMemo: String(memoEl.value || "").trim(),
        },
        items,
      });
    });

    document.addEventListener("keydown", onKey);
    document.body.appendChild(overlay);
    nameEl.focus();
  });
}

async function editRecipientFromIssue(rec) {
  const statusMsg = document.getElementById("issue-status-msg");
  const payload = await openRecipientEditModal(rec);
  if (!payload) return;
  try {
    const recBase = "/api/recipients/" + rec.id;
    const itemBase = "/api/recipients/" + rec.id + "/items";

    await apiSend(recBase, "PUT", payload.recipientBody);

    const beforeItems = Array.isArray(rec.items) ? rec.items : [];
    const oldIds = {};
    for (let i = 0; i < beforeItems.length; i++) {
      oldIds[beforeItems[i].id] = true;
    }

    const keepOldIds = {};
    const modalItems = Array.isArray(payload.items) ? payload.items : [];
    for (let i = 0; i < modalItems.length; i++) {
      const it = modalItems[i];
      const body = {
        plantName: it.plantName,
        fixedItemName: it.fixedItemName,
        monthlySupply: it.monthlySupply,
        note: it.note,
      };
      if (it.id != null) {
        keepOldIds[it.id] = true;
        await apiSend(itemBase + "/" + it.id, "PUT", body);
      } else if (hasMeaningfulItem(it)) {
        await apiSend(itemBase, "POST", body);
      }
    }

    const oldIdKeys = Object.keys(oldIds);
    for (let i = 0; i < oldIdKeys.length; i++) {
      const id = Number(oldIdKeys[i]);
      if (!keepOldIds[id]) {
        await apiSend(itemBase + "/" + id, "DELETE");
      }
    }

    const d = await apiGet("/api/recipients");
    allRecipients = d.recipients || [];
    refreshPreviewFromSelection(rec.id);
    if (statusMsg) {
      statusMsg.textContent =
        "공급받는자/품목 정보를 수정했습니다: " + (payload.recipientBody.displayName || "");
    }
  } catch (e) {
    if (statusMsg) statusMsg.textContent = "공급받는자 수정 실패: " + (e.message || "오류");
    await alertModal(e.message || "수정 실패", "오류");
  }
}

function recipientHasItems(rec) {
  return !!(rec && rec.items && rec.items.length);
}

function recipientTotals(rec) {
  const items = rec.items || [];
  let supply = 0;
  let tax = 0;
  for (let i = 0; i < items.length; i++) {
    supply += Number(items[i].monthlySupply) || 0;
    tax += Number(items[i].monthlyTax) || 0;
  }
  return { supply, tax };
}

function issueRowTotalAmount(rec, page) {
  const totals = page || recipientTotals(rec);
  return (
    (Number(totals.totalSupply != null ? totals.totalSupply : totals.supply) || 0) +
    (Number(totals.totalTax != null ? totals.totalTax : totals.tax) || 0)
  );
}

function issueSearchHaystack(rec, page) {
  const total = issueRowTotalAmount(rec, page);
  const parts = [
    recipientSearchHaystack(rec),
    String(total),
    formatMoney(total),
    String(total) + "원",
    formatMoney(total) + "원",
  ];
  return parts.join(" ").toLowerCase().replace(/\s/g, "");
}

function recipientPlantSummary(rec) {
  const items = Array.isArray((rec || {}).items) ? rec.items : [];
  if (!items.length) return "발전소 없음";
  const names = [];
  for (let i = 0; i < items.length; i++) {
    const nm = String(items[i].plantName || "").trim();
    if (nm && names.indexOf(nm) === -1) names.push(nm);
  }
  if (!names.length) return "발전소명 미입력";
  if (names.length <= 2) return names.join(", ");
  return names.slice(0, 2).join(", ") + " 외 " + (names.length - 2) + "개소";
}

function pageByRecipientId() {
  const map = {};
  for (let i = 0; i < invoicePages.length; i++) {
    map[invoicePages[i].recipientId] = invoicePages[i];
  }
  return map;
}

function knownPageByRecipientId(recipientId, pageMap) {
  const id = Number(recipientId);
  if (!id) return null;
  if (pageMap && pageMap[id]) return pageMap[id];
  const arr = issueRecordMap[id];
  if (!arr || !arr.length) return null;
  return arr[0];
}

function getDefaultItemName() {
  const el = document.getElementById("default-item-name");
  return el ? String(el.value || "").trim() : "";
}

/** 선택 변경 시 API 없이 미리보기만 갱신. 기존 페이지의 recordId·transmitStatus는 recipientId 기준으로 유지 */
function refreshPreviewFromSelection(preferredRecipientId) {
  const issueEl = document.getElementById("issue-date");
  const issueDate = issueEl ? issueEl.value || todayStr() : todayStr();
  const defaultItemName = getDefaultItemName();
  const ymEl = document.getElementById("issue-year-month");
  const ymValue = ymEl ? ymEl.value : "";
  const selectedPageMap = pageByRecipientId();
  const pickedSet = selectedRecipientIds;
  const orderedIds = [];
  for (let i = 0; i < allRecipients.length; i++) {
    const id = allRecipients[i].id;
    if (pickedSet.has(id)) orderedIds.push(id);
  }

  const pages = [];
  for (let i = 0; i < orderedIds.length; i++) {
    const id = Number(orderedIds[i]);
    const rec = allRecipients.find(function (x) {
      return x.id === id;
    });
    if (!rec || !recipientHasItems(rec)) continue;
    const items = rec.items || [];
    let supply = 0;
    let tax = 0;
    for (let j = 0; j < items.length; j++) {
      supply += Number(items[j].monthlySupply) || 0;
      tax += Number(items[j].monthlyTax) || 0;
    }
    const prev = knownPageByRecipientId(id, selectedPageMap);
    const html = buildOneInvoice(supplierData, rec, items, issueDate, defaultItemName, ymValue, prev ? prev.recordId : null, prev ? prev.transmitStatus : "not_sent");
    pages.push({
      html,
      recordId: prev ? prev.recordId : null,
      recipientId: id,
      recipientName: rec.displayName || "",
      totalSupply: supply,
      totalTax: tax,
      transmitStatus: prev && prev.transmitStatus ? prev.transmitStatus : "not_sent",
    });
  }

  invoicePages = pages;
  if (invoicePages.length === 0) {
    invoicePageIndex = 0;
  } else {
    let idx = 0;
    if (preferredRecipientId != null) {
      const want = Number(preferredRecipientId);
      let found = -1;
      for (let k = 0; k < invoicePages.length; k++) {
        if (invoicePages[k].recipientId === want) {
          found = k;
          break;
        }
      }
      idx = found >= 0 ? found : 0;
    }
    invoicePageIndex = idx;
  }
  renderSessionTable();
  renderSingleInvoice();
}

/** 목록 전송상태: 미전송 | 발행대기 | 전송완료 | 전송실패 */
function selectionHasIssuableRecipients() {
  const ids = Array.from(selectedRecipientIds);
  for (let i = 0; i < ids.length; i++) {
    const id = ids[i];
    const rec = allRecipients.find(function (x) {
      return x.id === id;
    });
    if (rec && recipientHasItems(rec)) return true;
  }
  return false;
}

function issuableRecipientCounts() {
  let total = 0;
  let selected = 0;
  for (let i = 0; i < allRecipients.length; i++) {
    const rec = allRecipients[i];
    if (!recipientHasItems(rec)) continue;
    total += 1;
    if (selectedRecipientIds.has(rec.id)) selected += 1;
  }
  return { total, selected };
}

function syncTransmitButtonState() {
  const btnTx = document.getElementById("btn-hometax");
  const btnSave = document.getElementById("btn-save-pending");
  const canRun = selectionHasIssuableRecipients();
  if (btnTx) btnTx.disabled = !canRun;
  if (btnSave) btnSave.disabled = !canRun;
}

function transmitStatusDisplay(rec, page) {
  if (!recipientHasItems(rec)) return "미전송";
  const savedArr = issueRecordMap[rec.id];
  if (savedArr && savedArr.length > 0) {
    // 실패 이력은 제외하고 활성 레코드만 기준으로 상태 판단
    const active = savedArr.filter(function (r) {
      return r.transmitStatus !== "transmit_failed" && r.transmitStatus !== "issue_failed";
    });
    const allFailed = active.length === 0;
    if (allFailed) return "전송실패";
    const ss = active.map(function (r) { return r.transmitStatus; });
    if (ss.every(function (s) { return s === "issued" || s === "transmitted_practice"; })) return "전송완료";
    if (ss.some(function (s) { return s === "issued" || s === "transmitted_practice"; })) return "일부전송";
    if (ss.every(function (s) { return s === "not_sent"; })) return active.length > 1 ? "발행대기(" + active.length + "건)" : "발행대기";
    return "미전송";
  }
  if (!page) return "미전송";
  const ts = page.transmitStatus;
  if (ts === "issued") return "발급완료";
  if (ts === "transmitted_practice") return "전송완료";
  if (ts === "issue_failed") return "발급실패";
  if (ts === "transmit_failed") return "전송실패";
  if (page.recordId != null) return "발행대기";
  return "미전송";
}

function transmitStatusDisplayForRecord(record) {
  const ts = record.transmitStatus;
  if (ts === "issued") return "발급완료";
  if (ts === "transmitted_practice") return "전송완료";
  if (ts === "issue_failed") return "발급실패";
  if (ts === "transmit_failed") return "전송실패";
  if (record.recordId != null) return "발행대기";
  return "미전송";
}

function recipientTypeForIssue(rec) {
  if (!rec) return "-";
  return kindLabel(rec.kind, rec.bizSubtype);
}

function setRecipientSelection(recId, checked) {
  if (checked) selectedRecipientIds.add(recId);
  else selectedRecipientIds.delete(recId);
  updateIssueTotals(_issueListTotal);
  refreshPreviewFromSelection(checked ? recId : null);
}

function previewRecipientOnRight(rec, page, totals) {
  if (!rec || !recipientHasItems(rec)) return;
  if (page && invoicePages.length) {
    for (let i = 0; i < invoicePages.length; i++) {
      if (invoicePages[i].recipientId === rec.id) {
        invoicePageIndex = i;
        renderSessionTable();
        renderSingleInvoice();
        return;
      }
    }
  }
  const issueDate = (document.getElementById("issue-date") || {}).value || todayStr();
  const defaultItemName = getDefaultItemName();
  const ymValue = (document.getElementById("issue-year-month") || {}).value || "";
  const html = buildOneInvoice(supplierData, rec, rec.items || [], issueDate, defaultItemName, ymValue, page ? page.recordId : null, page ? page.transmitStatus : "not_sent");
  const supply = totals && totals.totalSupply != null ? totals.totalSupply : totals.supply;
  const tax = totals && totals.totalTax != null ? totals.totalTax : totals.tax;
  invoicePages = [
    {
      html,
      recordId: page ? page.recordId : null,
      recipientId: rec.id,
      recipientName: rec.displayName || "",
      totalSupply: Number(supply) || 0,
      totalTax: Number(tax) || 0,
      transmitStatus: page && page.transmitStatus ? page.transmitStatus : "not_sent",
    },
  ];
  invoicePageIndex = 0;
  renderSessionTable();
  renderSingleInvoice();
}

function calcRecipientTotal(rec, page) {
  const savedArr = issueRecordMap[rec.id];
  if (savedArr && savedArr.length > 0) {
    // 실패 이력 레코드 제외 — transmitStatusDisplay와 동일한 기준
    const active = savedArr.filter(function (r) {
      return r.transmitStatus !== "transmit_failed" && r.transmitStatus !== "issue_failed";
    });
    if (active.length > 0) {
      let total = 0;
      for (let i = 0; i < active.length; i++) {
        total += (Number(active[i].totalSupply) || 0) + (Number(active[i].totalTax) || 0);
      }
      return total;
    }
    // 전부 실패 이력 → 현재 품목 합계로 표시
  }
  const totals = page || recipientTotals(rec);
  return (Number(totals.totalSupply != null ? totals.totalSupply : totals.supply) || 0) +
         (Number(totals.totalTax != null ? totals.totalTax : totals.tax) || 0);
}

function updateIssueTotals(visibleTotal) {
  const listEl = document.getElementById("issue-list-total");
  const selEl  = document.getElementById("issue-selected-total");
  if (listEl) listEl.textContent = "목록합계 " + formatMoney(visibleTotal) + "원";
  if (selEl) {
    const pages = pageByRecipientId();
    let selTotal = 0;
    selectedRecipientIds.forEach(function (id) {
      const rec = allRecipients.find(function (r) { return r.id === id; });
      if (rec) selTotal += calcRecipientTotal(rec, knownPageByRecipientId(id, pages));
    });
    selEl.textContent = "선택합계 " + formatMoney(selTotal) + "원";
  }
}

function renderSessionTable() {
  const tbody = document.getElementById("issue-session-body");
  const countEl = document.getElementById("issue-session-filter-count");
  const totalEl = document.getElementById("issue-session-filter-total");
  const raw = sessionSearchRaw();
  const pages = pageByRecipientId();
  tbody.innerHTML = "";

  let visibleCount = 0;
  let rowCount = 0;
  let visibleTotalAmount = 0;
  for (let i = 0; i < allRecipients.length; i++) {
    const rec = allRecipients[i];
    const page = knownPageByRecipientId(rec.id, pages);
    if (!issueSearchMatches(rec, page, raw)) continue;
    if (!rowMatchesIssueFilters(rec, page)) continue;
    visibleCount++;
    rowCount++;

    const totals = page || recipientTotals(rec);
    const statusText = transmitStatusDisplay(rec, page);
    const typeText = recipientTypeForIssue(rec);
    const totalAmount = calcRecipientTotal(rec, page);
    visibleTotalAmount += totalAmount;
    const hasItems = recipientHasItems(rec);
    const checked = selectedRecipientIds.has(rec.id);

    const tr = document.createElement("tr");
    if (page && invoicePages[invoicePageIndex] && invoicePages[invoicePageIndex].recipientId === rec.id) {
      tr.classList.add("recipient-row-selected");
    }
    tr.style.cursor = "default";

    const td0 = document.createElement("td");
    const cb = document.createElement("input");
    cb.type = "checkbox";
    cb.checked = checked;
    cb.disabled = !hasItems;
    cb.addEventListener("click", function (e) {
      e.stopPropagation();
      if (countEl) countEl.textContent = "";
      setRecipientSelection(rec.id, this.checked);
    });
    td0.style.cursor = hasItems ? "pointer" : "default";
    td0.addEventListener("click", function (e) {
      e.stopPropagation();
      if (!hasItems) return;
      cb.checked = !cb.checked;
      if (countEl) countEl.textContent = "";
      setRecipientSelection(rec.id, cb.checked);
    });
    td0.appendChild(cb);

    const td1 = document.createElement("td");
    const nameView = document.createElement("button");
    nameView.type = "button";
    nameView.className = "issue-recipient-name-btn";
    nameView.innerHTML = "<strong>" + escapeHtml(rec.displayName || "") + "</strong>";
    nameView.addEventListener("click", async function (e) {
      e.stopPropagation();
      if (!hasItems) return;
      await editRecipientFromIssue(rec);
    });
    td1.style.cursor = hasItems ? "pointer" : "default";
    td1.addEventListener("click", function (e) {
      e.stopPropagation();
      if (!hasItems) return;
      previewRecipientOnRight(rec, page, totals);
    });
    td1.appendChild(nameView);
    const td2 = document.createElement("td");
    td2.className = "issue-session-plant-col";
    td2.textContent = recipientPlantSummary(rec);
    const td3 = document.createElement("td");
    td3.textContent = rec.ceoName || "";
    const td4 = document.createElement("td");
    td4.textContent = formatMoney(totalAmount) + "원";
    const td5 = document.createElement("td");
    td5.textContent = statusText;

    tr.appendChild(td0);
    tr.appendChild(td1);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(td4);
    tr.appendChild(td5);

    [td2, td3, td4, td5].forEach(function (td) {
      td.style.cursor = hasItems ? "pointer" : "default";
      td.addEventListener("click", function (e) {
        e.stopPropagation();
        previewRecipientOnRight(rec, page, totals);
      });
    });

    tbody.appendChild(tr);
  }

  if (rowCount === 0) {
    const tr = document.createElement("tr");
    tr.innerHTML = "<td colspan='6' style='color:var(--text-muted)'>검색 결과가 없습니다.</td>";
    tbody.appendChild(tr);
  }

  if (countEl) {
    countEl.textContent = "표시 " + visibleCount + " / 전체 " + allRecipients.length + " · 선택 " + selectedRecipientIds.size;
  }
  _issueListTotal = visibleTotalAmount;
  updateIssueTotals(visibleTotalAmount);
  syncTransmitButtonState();
}

function selectRecipientsAllVisible() {
  const raw = sessionSearchRaw();
  const pages = pageByRecipientId();
  for (let i = 0; i < allRecipients.length; i++) {
    const rec = allRecipients[i];
    if (!recipientHasItems(rec)) continue;
    const page = knownPageByRecipientId(rec.id, pages);
    if (!issueSearchMatches(rec, page, raw)) continue;
    if (!rowMatchesIssueFilters(rec, page)) continue;
    selectedRecipientIds.add(rec.id);
  }
  refreshPreviewFromSelection(null);
}

function selectRecipientsPendingVisible() {
  const raw = sessionSearchRaw();
  const pages = pageByRecipientId();
  for (let i = 0; i < allRecipients.length; i++) {
    const rec = allRecipients[i];
    if (!recipientHasItems(rec)) continue;
    const page = knownPageByRecipientId(rec.id, pages);
    if (!issueSearchMatches(rec, page, raw)) continue;
    if (!rowMatchesIssueFilters(rec, page)) continue;
    const alreadyIssued = page && (page.transmitStatus === "transmitted_practice" || page.transmitStatus === "issued");
    if (!alreadyIssued) {
      selectedRecipientIds.add(rec.id);
    }
  }
  refreshPreviewFromSelection(null);
}

function selectRecipientsNone() {
  selectedRecipientIds.clear();
  refreshPreviewFromSelection(null);
}

async function resolveYearMonthForIssue() {
  let yearMonth = document.getElementById("issue-year-month").value.trim();
  let usedFallback = false;
  if (!yearMonth) {
    try {
      const st = await apiGet("/api/server-time");
      yearMonth = st.yearMonth || "";
    } catch (e) {
      const d = new Date();
      yearMonth = d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, "0");
    }
    usedFallback = true;
  }
  return { yearMonth, usedFallback };
}

async function loadIssueRecordMapByYearMonth(yearMonth) {
  const ym = String(yearMonth || "").trim();
  if (!ym) {
    issueRecordMap = {};
    return;
  }
  const res = await apiGet("/api/issue-records?yearMonth=" + encodeURIComponent(ym));
  const records = Array.isArray(res.records) ? res.records : [];
  const nextMap = {};
  for (let i = 0; i < records.length; i++) {
    const r = records[i];
    const rid = Number(r.recipientId);
    if (!rid) continue;
    const entry = {
      recordId: r.id != null ? Number(r.id) : null,
      recipientId: rid,
      recipientName: String(r.recipientName || ""),
      issueDate: String(r.issueDate || ""),
      itemJson: String(r.itemJson || ""),
      totalSupply: Number(r.totalSupply) || 0,
      totalTax: Number(r.totalTax) || 0,
      transmitStatus: String(r.transmitStatus || "not_sent"),
    };
    if (!nextMap[rid]) nextMap[rid] = [];
    nextMap[rid].push(entry);
  }
  issueRecordMap = nextMap;
}

function buildSplitSubRow(rec, record, isPending) {
  const tr = document.createElement("tr");
  tr.className = "issue-split-subrow";

  const tdArrow = document.createElement("td");
  tdArrow.style.cssText = "text-align:center;color:var(--text-muted);font-size:0.8rem";
  tdArrow.textContent = "↳";
  tr.appendChild(tdArrow);

  const tdInfo = document.createElement("td");
  tdInfo.colSpan = 2;
  tdInfo.style.cssText = "font-size:0.82rem;color:var(--text-muted)";
  const date = record.issueDate || "";
  let itemLabel = "";
  if (isPending) {
    itemLabel = (record.items || []).map(function (it) { return it.fixedItemName || it.plantName || "품목"; }).join(", ");
  } else if (record.itemJson) {
    try {
      itemLabel = JSON.parse(record.itemJson).map(function (it) { return it.fixedItemName || it.plantName || "품목"; }).join(", ");
    } catch (_) {}
  }
  tdInfo.textContent = (date || "날짜미설정") + (itemLabel ? "  ·  " + itemLabel : "");
  tr.appendChild(tdInfo);

  const tdAmt = document.createElement("td");
  tdAmt.style.cssText = "text-align:right;font-size:0.82rem";
  tdAmt.textContent = formatMoney((Number(record.totalSupply) || 0) + (Number(record.totalTax) || 0)) + "원";
  tr.appendChild(tdAmt);

  const tdStatus = document.createElement("td");
  tdStatus.style.cssText = "font-size:0.82rem;color:var(--text-muted)";
  tdStatus.textContent = isPending ? "미저장" : transmitStatusDisplayForRecord(record);
  tr.appendChild(tdStatus);

  const tdDel = document.createElement("td");
  const delBtn = document.createElement("button");
  delBtn.type = "button";
  delBtn.className = "btn btn-danger";
  delBtn.style.cssText = "padding:1px 7px;font-size:0.78rem";
  delBtn.textContent = "×";
  delBtn.addEventListener("click", async function (e) {
    e.stopPropagation();
    const ok = await confirmModal("이 분리 발행 항목을 삭제할까요?", "삭제", "삭제");
    if (!ok) return;
    if (isPending) {
      pendingSplitEntries = pendingSplitEntries.filter(function (p) { return p.localId !== record.localId; });
      renderSessionTable();
    } else {
      try {
        await apiSend("/api/issue-records/" + record.recordId, "DELETE");
        const ym = (document.getElementById("issue-year-month") || {}).value || "";
        await loadIssueRecordMapByYearMonth(ym);
        renderSessionTable();
      } catch (e2) {
        await alertModal(e2.message || "삭제 실패", "오류");
      }
    }
  });
  tdDel.appendChild(delBtn);
  tr.appendChild(tdDel);

  return tr;
}


function renderSingleInvoice() {
  const el = document.getElementById("preview-single");
  el.innerHTML = "";
  const tb = document.getElementById("invoice-toolbar");
  if (!invoicePages.length) {
    if (tb) tb.classList.remove("is-visible");
    syncTransmitButtonState();
    return;
  }
  if (tb) tb.classList.add("is-visible");
  const page = invoicePages[invoicePageIndex];
  if (!page) return;
  const wrap = document.createElement("div");
  wrap.innerHTML = page.html;
  const node = wrap.firstElementChild;
  if (node) el.appendChild(node);
  else el.appendChild(wrap);

  document.getElementById("invoice-page-label").textContent =
    invoicePageIndex + 1 + " / " + invoicePages.length;
  document.getElementById("btn-inv-prev").disabled = invoicePageIndex <= 0;
  document.getElementById("btn-inv-next").disabled = invoicePageIndex >= invoicePages.length - 1;

  syncTransmitButtonState();
}

/** 전송 API용 본문 + 미리보기용 페이지 배열 (저장은 하지 않음) */
async function buildTransmitPayload() {
  const err = document.getElementById("preview-error");
  const statusMsg = document.getElementById("issue-status-msg");
  err.style.display = "none";
  if (statusMsg) statusMsg.textContent = "";

  const issueDate = document.getElementById("issue-date").value || todayStr();
  const defaultItemName = getDefaultItemName();
  const ymValue = document.getElementById("issue-year-month").value;
  const pickedIds = Array.from(selectedRecipientIds);
  if (pickedIds.length === 0) {
    err.textContent = "공급받는자를 한 명 이상 선택하세요.";
    err.style.display = "block";
    return null;
  }

  const entries = [];
  const pages = [];
  for (let i = 0; i < pickedIds.length; i++) {
    const id = Number(pickedIds[i]);
    const rec = allRecipients.find(function (x) { return x.id === id; });
    if (!rec) continue;
    if (!recipientHasItems(rec)) continue;

    const savedArr = issueRecordMap[id] || [];
    // 전송실패·발급실패 레코드는 이력으로 유지하고, 활성 레코드(not_sent)만 재사용
    const activeArr = savedArr.filter(function (sr) {
      return sr.transmitStatus !== "transmit_failed" && sr.transmitStatus !== "issue_failed";
    });

    if (activeArr.length === 0) {
      // 활성 레코드 없음(신규 or 전부 실패 이력) → 새 레코드 생성
      const items = rec.items || [];
      if (items.length === 0) continue;
      let supply = 0, tax = 0;
      for (let j = 0; j < items.length; j++) {
        supply += Number(items[j].monthlySupply) || 0;
        tax += Number(items[j].monthlyTax) || 0;
      }
      entries.push({ recipientId: id, issueDate: issueDate, items: null, totalSupply: supply, totalTax: tax, transmitStatus: "not_sent" });
      const html = buildOneInvoice(supplierData, rec, items, issueDate, defaultItemName, ymValue, null, "not_sent");
      pages.push({ html, recordId: null, recipientId: id, recipientName: rec.displayName || "", totalSupply: supply, totalTax: tax, transmitStatus: "not_sent" });
    } else {
      // 활성 레코드(발행대기 등)별로 엔트리 생성
      for (let j = 0; j < activeArr.length; j++) {
        const sr = activeArr[j];
        let recItems = null;
        if (sr.itemJson) { try { recItems = JSON.parse(sr.itemJson); } catch (_) {} }
        const displayItems = recItems || rec.items || [];
        const recDate = sr.issueDate || issueDate;
        entries.push({ id: sr.recordId, recipientId: id, issueDate: recDate, items: recItems, totalSupply: sr.totalSupply, totalTax: sr.totalTax, transmitStatus: sr.transmitStatus || "not_sent" });
        const html = buildOneInvoice(supplierData, rec, displayItems, recDate, defaultItemName, ymValue, sr.recordId, sr.transmitStatus || "not_sent");
        pages.push({ html, recordId: sr.recordId, recipientId: id, recipientName: rec.displayName || "", totalSupply: sr.totalSupply, totalTax: sr.totalTax, transmitStatus: sr.transmitStatus || "not_sent" });
      }
    }
  }

  if (entries.length === 0) {
    err.textContent = "선택한 분 중 품목이 있는 공급받는자가 없습니다.";
    err.style.display = "block";
    return null;
  }

  const { yearMonth, usedFallback } = await resolveYearMonthForIssue();
  if (!yearMonth) {
    if (statusMsg) statusMsg.textContent = "귀속 연·월을 확인할 수 없어 전송을 진행할 수 없습니다.";
    return null;
  }

  return { yearMonth, usedFallback, entries, invoicePagesDraft: pages };
}

async function runTransmitToHometax() {
  const statusMsg = document.getElementById("issue-status-msg");
  const err = document.getElementById("preview-error");

  if (!selectionHasIssuableRecipients()) {
    err.textContent = "공급받는자를 한 명 이상 선택하고, 품목이 있는 분만 전송할 수 있습니다.";
    err.style.display = "block";
    return;
  }

  const duplicateNames = [];
  const selectedIds = Array.from(selectedRecipientIds);
  for (let i = 0; i < selectedIds.length; i++) {
    const id = Number(selectedIds[i]);
    const savedArr = issueRecordMap[id] || [];
    const anyIssued = savedArr.some(function (r) {
      return r.transmitStatus === "transmitted_practice" || r.transmitStatus === "issued";
    });
    if (anyIssued) {
      const rec = allRecipients.find(function (x) { return x.id === id; });
      duplicateNames.push((rec && rec.displayName) || String(id));
    }
  }
  if (duplicateNames.length > 0) {
    const choice = await new Promise(function (resolve) {
      const overlay = document.createElement("div");
      overlay.className = "modal-overlay";
      overlay.setAttribute("role", "dialog");
      overlay.setAttribute("aria-modal", "true");
      const msg = "아래 " + duplicateNames.length + "건은 이미 발행된 이력이 있습니다:\n" +
        duplicateNames.join(", ") + "\n\n계속 전송하시겠습니까?";
      overlay.innerHTML =
        '<div class="modal-box">' +
        '<h3 class="modal-title">중복 발행 주의</h3>' +
        '<p class="modal-message">' + escapeHtml(msg).replace(/\n/g, "<br>") + "</p>" +
        '<div class="modal-actions">' +
        '<button type="button" class="btn btn-secondary modal-dup-history">발행내역보기</button>' +
        '<button type="button" class="btn btn-secondary modal-dup-cancel">취소</button>' +
        '<button type="button" class="btn btn-primary modal-dup-transmit">전송</button>' +
        "</div></div>";
      function close(v) {
        document.removeEventListener("keydown", onKey);
        if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
        resolve(v);
      }
      function onKey(ev) { if (ev.key === "Escape") close(null); }
      overlay.addEventListener("click", function (e) { if (e.target === overlay) close(null); });
      overlay.querySelector(".modal-dup-history").addEventListener("click", function () { close("history"); });
      overlay.querySelector(".modal-dup-cancel").addEventListener("click", function () { close(null); });
      overlay.querySelector(".modal-dup-transmit").addEventListener("click", function () { close("transmit"); });
      document.addEventListener("keydown", onKey);
      document.body.appendChild(overlay);
      overlay.querySelector(".modal-dup-transmit").focus();
    });
    if (choice === "history") {
      window.location.href = BASE + "/issue-history.html";
      return;
    }
    if (choice !== "transmit") return;
  }

  const counts = issuableRecipientCounts();
  const ok = await confirmModal(
    "총 " +
      counts.total +
      "건 중 " +
      counts.selected +
      "건 선택\n" +
      "홈택스 전송을 진행하시겠습니까?\n" +
      "전송 이후 취소는 홈택스에서만 가능합니다.",
    "홈택스 전송",
    "전송"
  );
  if (!ok) return;

  const btn = document.getElementById("btn-hometax");
  if (btn) btn.disabled = true;
  try {
    const built = await buildTransmitPayload();
    if (!built) return;

    invoicePages = built.invoicePagesDraft;
    invoicePageIndex = 0;
    renderSessionTable();
    renderSingleInvoice();

    const res = await apiSend("/api/issue-records/issue-and-transmit", "POST", {
      yearMonth: built.yearMonth,
      entries: built.entries,
    });

    for (let i = 0; i < res.results.length; i++) {
      if (i < invoicePages.length) {
        invoicePages[i].recordId = res.results[i].recordId;
        invoicePages[i].transmitStatus = res.results[i].success ? "transmitted_practice" : "transmit_failed";
      }
    }
    await loadIssueRecordMapByYearMonth(built.yearMonth);
    selectedRecipientIds.clear();
    refreshPreviewFromSelection(null);

    const okN = res.results.filter(function (x) {
      return x.success;
    }).length;
    const failN = res.results.length - okN;
    if (statusMsg) {
      const fb = built.usedFallback ? "귀속 " + built.yearMonth + "(자동). " : "";
      statusMsg.textContent =
        fb +
        "홈택스 처리: 성공 " +
        okN +
        "건, 실패 " +
        failN +
        "건." +
        (res.hometaxMode === "mock" ? " (목업·실제 국세청 API 미연동)" : "");
    }

    const failMsgs = res.results
      .filter(function (x) { return !x.success; })
      .map(function (x) {
        const rec = allRecipients.find(function (r) { return r.id === x.recipientId; });
        const name = (rec && rec.displayName) || "수신자";
        return name + ": " + (x.message || "전송 실패");
      });
    await alertModal(
      "처리가 끝났습니다. 성공 " +
        okN +
        "건 / 실패 " +
        failN +
        "건." +
        (failMsgs.length ? "\n\n[실패 사유]\n" + failMsgs.join("\n") : "") +
        (res.hometaxMode === "mock"
          ? "\n\n【목업】실제 홈택스 접수는 lib/hometaxSubmit.js 및 환경 변수로 연동을 완료한 뒤 가능합니다."
          : ""),
      "전송 결과"
    );
  } catch (e) {
    if (statusMsg) statusMsg.textContent = "전송 실패: " + (e.message || "오류");
    console.warn(e);
  } finally {
    syncTransmitButtonState();
  }
}

async function runSavePendingRecords() {
  const statusMsg = document.getElementById("issue-status-msg");
  const err = document.getElementById("preview-error");
  if (err) err.style.display = "none";
  if (statusMsg) statusMsg.textContent = "";

  if (!selectionHasIssuableRecipients()) {
    if (err) {
      err.textContent = "공급받는자를 한 명 이상 선택하고, 품목이 있는 분만 저장할 수 있습니다.";
      err.style.display = "block";
    }
    return;
  }

  const ok = await confirmModal(
    "선택한 건을 발행대기 상태로 저장할까요?",
    "발행대기 저장",
    "저장"
  );
  if (!ok) return;

  const btn = document.getElementById("btn-save-pending");
  if (btn) btn.disabled = true;
  try {
    const built = await buildTransmitPayload();
    if (!built) return;

    const res = await apiSend("/api/issue-records", "POST", {
      yearMonth: built.yearMonth,
      entries: built.entries,
    });

    const ids = Array.isArray(res.recordIds) ? res.recordIds : [];
    for (let i = 0; i < built.invoicePagesDraft.length; i++) {
      built.invoicePagesDraft[i].recordId = ids[i] != null ? Number(ids[i]) : null;
      built.invoicePagesDraft[i].transmitStatus = "not_sent";
    }
    invoicePages = built.invoicePagesDraft;
    invoicePageIndex = 0;
    await loadIssueRecordMapByYearMonth(built.yearMonth);
    refreshPreviewFromSelection(null);

    if (statusMsg) {
      const fb = built.usedFallback ? "귀속 " + built.yearMonth + "(자동). " : "";
      statusMsg.textContent = fb + "발행대기로 " + (res.saved || 0) + "건 저장했습니다.";
    }
  } catch (e) {
    if (statusMsg) statusMsg.textContent = "저장 실패: " + (e.message || "오류");
  } finally {
    syncTransmitButtonState();
  }
}

(async function () {
  await loadSiteConfig();
  const ok = await checkLogin();
  if (!ok) return;

  document.getElementById("issue-date").value = todayStr();
  try {
    const st = await apiGet("/api/server-time");
    if (st.yearMonth) document.getElementById("issue-year-month").value = st.yearMonth;
  } catch (e) {
    const d = new Date();
    document.getElementById("issue-year-month").value =
      d.getFullYear() + "-" + String(d.getMonth() + 1).padStart(2, "0");
  }

  document.getElementById("logout-btn").addEventListener("click", async function (e) {
    e.preventDefault();
    const sure = await confirmModal("정말 로그아웃 하시겠습니까?", "로그아웃", "로그아웃");
    if (!sure) return;
    await apiSend("/api/logout", "POST");
    window.location.href = BASE + "/login.html";
  });

  const me = await apiGet("/api/me");
  supplierData = me.user.supplier;
  const recData = await apiGet("/api/recipients");
  allRecipients = recData.recipients || [];
  const ymInputEl = document.getElementById("issue-year-month");
  await loadIssueRecordMapByYearMonth((ymInputEl && ymInputEl.value) || "");
  refreshPreviewFromSelection(null);

  const searchEl = document.getElementById("issue-session-search");
  if (searchEl) {
    searchEl.addEventListener("input", renderSessionTable);
  }
  const kindFilterEl = document.getElementById("issue-kind-filter");
  if (kindFilterEl) {
    kindFilterEl.addEventListener("change", function () {
      updateIssueSearchPlaceholder();
      renderSessionTable();
    });
  }
  const issueColChips = document.getElementById("issue-search-col-chips");
  if (issueColChips) {
    updateIssueSearchPlaceholder();
    issueColChips.addEventListener("click", function (e) {
      const chip = e.target.closest(".search-col-chip");
      if (!chip) return;
      issueColChips.querySelectorAll(".search-col-chip").forEach(function (c) { c.classList.remove("active"); });
      chip.classList.add("active");
      updateIssueSearchPlaceholder();
      renderSessionTable();
    });
  }
  const txFilterEl = document.getElementById("issue-transmit-filter");
  if (txFilterEl) {
    txFilterEl.addEventListener("change", renderSessionTable);
  }
  if (ymInputEl) {
    ymInputEl.addEventListener("change", async function () {
      try {
        await loadIssueRecordMapByYearMonth(ymInputEl.value);
      } catch (e) {
        console.warn(e);
        issueRecordMap = {};
      }
      refreshPreviewFromSelection(null);
    });
  }
  document.getElementById("btn-select-all").addEventListener("click", function () {
    selectRecipientsAllVisible();
  });
  document.getElementById("btn-select-pending").addEventListener("click", function () {
    selectRecipientsPendingVisible();
  });
  document.getElementById("btn-select-none").addEventListener("click", function () {
    selectRecipientsNone();
  });
  document.getElementById("btn-save-pending").addEventListener("click", function () {
    runSavePendingRecords();
  });

  document.getElementById("btn-print").addEventListener("click", function () {
    window.print();
  });

  document.getElementById("btn-inv-prev").addEventListener("click", function () {
    if (invoicePageIndex > 0) {
      invoicePageIndex--;
      renderSessionTable();
      renderSingleInvoice();
    }
  });
  document.getElementById("btn-inv-next").addEventListener("click", function () {
    if (invoicePageIndex < invoicePages.length - 1) {
      invoicePageIndex++;
      renderSessionTable();
      renderSingleInvoice();
    }
  });
  document.getElementById("btn-hometax").addEventListener("click", function () {
    runTransmitToHometax();
  });

})();
