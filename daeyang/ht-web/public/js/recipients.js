/**
 * 공급받는자: 좌측 폼·품목, 우측 테이블
 */
let recipientsCache = [];
let editingRecipientId = null;
let monitoringOptionsCache = [];
let pendingRecipientCert = null;

function rApi(path) {
  return "/api/recipients" + (path || "");
}

async function loadMonitoringOptions() {
  try {
    const data = await apiGet("/api/monitoring-options");
    monitoringOptionsCache = data.options || [];
  } catch (e) {
    monitoringOptionsCache = [];
  }
  renderMonitoringSelect();
}

function renderMonitoringSelect() {
  const sel = document.getElementById("monitoring-type-select");
  const delBtn = document.getElementById("btn-del-monitoring-option");
  if (!sel) return;
  const prev = sel.value;
  sel.innerHTML = "";
  var blank = document.createElement("option");
  blank.value = "";
  blank.textContent = "-- 선택 --";
  sel.appendChild(blank);
  for (var i = 0; i < monitoringOptionsCache.length; i++) {
    var opt = document.createElement("option");
    opt.value = monitoringOptionsCache[i].name;
    opt.textContent = monitoringOptionsCache[i].name;
    opt.setAttribute("data-id", monitoringOptionsCache[i].id || "");
    opt.setAttribute("data-builtin", monitoringOptionsCache[i].builtin ? "1" : "0");
    sel.appendChild(opt);
  }
  if (prev) sel.value = prev;
  syncMonitoringDelBtn();
}

function syncMonitoringDelBtn() {
  const sel = document.getElementById("monitoring-type-select");
  const delBtn = document.getElementById("btn-del-monitoring-option");
  if (!sel || !delBtn) return;
  var selected = sel.options[sel.selectedIndex];
  var isCustom = selected && selected.getAttribute("data-builtin") === "0" && selected.value !== "";
  delBtn.style.display = isCustom ? "" : "none";
}

function syncMonitoringTypeWrap() {
  var cb = document.getElementById("svc-monitoring");
  var wrap = document.getElementById("monitoring-type-wrap");
  if (!wrap) return;
  wrap.style.display = (cb && cb.checked) ? "" : "none";
}

function bindRecipientBizNoAutoFormat() {
  const el = document.getElementById("new-bizNo");
  const kindEl = document.getElementById("new-kind");
  if (!el || !kindEl || el.getAttribute("data-bizno-format") === "1") return;
  el.setAttribute("data-bizno-format", "1");
  el.addEventListener("keydown", function (e) {
    const kind = kindEl.value;
    if (kind !== "business" && kind !== "individual") return;
    if (e.ctrlKey || e.metaKey || e.altKey) return;
    if (!e.key || e.key.length !== 1) return;
    if (/[0-9]/.test(e.key)) return;
    e.preventDefault();
  });
  el.addEventListener("input", function () {
    const kind = kindEl.value;
    if (kind !== "business" && kind !== "individual") return;
    const formatted = formatRecipientRegNoByKind(kind, el.value);
    if (formatted !== el.value) el.value = formatted;
  });
}

function recipientPlantSummary(r) {
  const items = Array.isArray((r || {}).items) ? r.items : [];
  if (!items.length) return "-";
  const names = [];
  for (let i = 0; i < items.length; i++) {
    const name = String(items[i].plantName || "").trim();
    if (name && names.indexOf(name) === -1) names.push(name);
  }
  if (!names.length) return "이름 미입력";
  if (names.length <= 2) return names.join(", ");
  return names.slice(0, 2).join(", ") + " 외 " + (names.length - 2) + "개소";
}

function toggleBizSubtype() {
  const kind = document.getElementById("new-kind").value;
  const wrap = document.getElementById("wrap-biz-subtype");
  const meta = document.getElementById("wrap-rec-biz-meta");
  const showBiz = kind === "business";
  wrap.style.display = showBiz ? "block" : "none";
  if (meta) meta.style.display = showBiz ? "" : "none";
}

async function loadRecipients() {
  const data = await apiGet("/api/recipients");
  recipientsCache = data.recipients || [];
  renderTable();
  if (editingRecipientId) {
    const r = recipientsCache.find(function (x) {
      return x.id === editingRecipientId;
    });
    if (r) {
      fillRecipientForm(r);
      renderItemsEditor(r);
    } else {
      startNewRecipient();
    }
  }
}

function findRecipientById(id) {
  const rid = Number(id);
  return recipientsCache.find(function (x) {
    return x.id === rid;
  });
}

function renderRecipientCertControls(rec) {
  const area = document.getElementById("recipient-cert-area");
  if (!area) return;

  const hasFile    = !!(rec && rec.bizCertUrl);
  const filename   = rec && rec.bizCertName ? rec.bizCertName : (hasFile ? "사업자등록증" : null);
  const isPending  = !rec && !!pendingRecipientCert;
  const displayName = filename || (isPending ? pendingRecipientCert.name : null);

  if (displayName) {
    area.innerHTML = `
      <div class="biz-cert-file">
        <svg class="biz-cert-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
        </svg>
        <span class="biz-cert-name" title="${escapeHtml(displayName)}">${escapeHtml(displayName)}</span>
        ${isPending
          ? `<span class="biz-cert-pending">저장 시 등록</span>
             <button type="button" class="btn btn-sm btn-danger-soft" id="btn-rec-cert-cancel">취소</button>`
          : `<button type="button" class="btn btn-sm btn-secondary" id="btn-rec-cert-view">보기</button>
             <button type="button" class="btn btn-sm btn-danger-soft" id="btn-rec-cert-delete">삭제</button>`
        }
      </div>`;

    if (isPending) {
      document.getElementById("btn-rec-cert-cancel").addEventListener("click", function () {
        pendingRecipientCert = null;
        document.getElementById("recipient-cert-file").value = "";
        renderRecipientCertControls(null);
      });
    } else {
      document.getElementById("btn-rec-cert-view").addEventListener("click", function () {
        if (rec.bizCertUrl) window.open(rec.bizCertUrl, "_blank", "noopener,noreferrer");
      });
      document.getElementById("btn-rec-cert-delete").addEventListener("click", async function () {
        const sure = await confirmModal("등록된 사업자등록증을 삭제할까요?", "사업자등록증 삭제", "삭제");
        if (!sure) return;
        try {
          await apiSend(rApi("/" + editingRecipientId + "/biz-cert"), "DELETE");
          await loadRecipients();
          const next = findRecipientById(editingRecipientId);
          renderRecipientCertControls(next || null);
        } catch (e) { await alertModal(e.message || "삭제 실패"); }
      });
    }
  } else {
    area.innerHTML = `<button type="button" class="btn btn-sm btn-secondary" id="btn-rec-cert-upload">등록</button>`;
    document.getElementById("btn-rec-cert-upload").addEventListener("click", function () {
      var fi = document.getElementById("recipient-cert-file");
      fi.value = ""; fi.click();
    });
  }
}

function rowMatchesRecipientKindFilter(tr, filterVal) {
  if (!filterVal) return true;
  const hasMeta = tr.hasAttribute("data-rec-kind");
  if (!hasMeta) return false;
  const kind = tr.getAttribute("data-rec-kind") || "";
  const biz = tr.getAttribute("data-rec-biz") || "";
  if (filterVal === "individual") return kind === "individual";
  if (filterVal === "foreign") return kind === "foreign";
  if (filterVal.indexOf("business:") === 0) {
    const sub = filterVal.slice("business:".length);
    return kind === "business" && biz === sub;
  }
  return true;
}

function recipientSearchColActive() {
  const active = document.querySelector("#recipient-search-col-chips .search-col-chip.active");
  return active ? active.getAttribute("data-col") : "all";
}

function applyRecipientAdminFilter() {
  const q = document.getElementById("recipient-admin-search");
  const raw = q ? q.value.trim().toLowerCase().replace(/\s/g, "") : "";
  const col = recipientSearchColActive();
  const kindSel = document.getElementById("recipient-admin-kind-filter");
  const filterVal = kindSel ? String(kindSel.value || "").trim() : "";
  const rows = document.querySelectorAll("#recipient-table-body tr");
  let visible = 0;
  for (let i = 0; i < rows.length; i++) {
    const tr = rows[i];
    if (tr.classList.contains("recipient-table-empty-msg")) continue;
    let matchSearch = true;
    if (raw) {
      if (col === "bizno") {
        const bizno = (tr.getAttribute("data-rec-bizno") || "").replace(/\s/g, "");
        matchSearch = bizno.indexOf(raw) !== -1;
      } else if (col === "phone") {
        const phone = (tr.getAttribute("data-rec-phone") || "").replace(/\D/g, "");
        const rawDigits = raw.replace(/\D/g, "");
        matchSearch = rawDigits ? phone.indexOf(rawDigits) !== -1 : phone.indexOf(raw) !== -1;
      } else if (col === "name") {
        const name = tr.getAttribute("data-rec-name") || "";
        matchSearch = name.indexOf(raw) !== -1;
      } else if (col === "owner") {
        const ceo = tr.getAttribute("data-rec-ceo") || "";
        matchSearch = ceo.indexOf(raw) !== -1;
      } else if (col === "plant") {
        const plant = tr.getAttribute("data-rec-plant") || "";
        matchSearch = plant.indexOf(raw) !== -1;
      } else {
        const hay = tr.getAttribute("data-rec-search") || "";
        matchSearch = hay.indexOf(raw) !== -1;
      }
    }
    const matchKind = rowMatchesRecipientKindFilter(tr, filterVal);
    const match = matchSearch && matchKind;
    tr.classList.toggle("rec-row-hidden", !match);
    if (match) visible++;
  }
  const hint = document.getElementById("recipient-admin-filter-count");
  if (hint) {
    hint.textContent =
      recipientsCache.length === 0 ? "" : "표시 " + visible + "명 / 전체 " + recipientsCache.length + "명";
  }
}

function recipientAdminSearchHaystack(r) {
  const parts = [recipientSearchHaystack(r)];
  if (r && r.svcSafety) parts.push("안전관리");
  if (r && r.svcTax) parts.push("세무");
  if (r && r.svcBilling) parts.push("청구");
  if (r && r.svcMonitoring) {
    parts.push("모니터링");
    // 자주 들어오는 오타 검색도 매칭되도록 보완
    parts.push("모니티링");
  }
  if (r && r.monitoringType) parts.push(String(r.monitoringType));
  return parts
    .filter(Boolean)
    .join(" ")
    .toLowerCase()
    .replace(/\s/g, "");
}

function fillRecipientForm(r) {
  document.getElementById("edit-recipient-id").value = String(r.id);
  document.getElementById("new-kind").value = r.kind || "individual";
  document.getElementById("new-bizSubtype").value = r.bizSubtype || "sole";
  document.getElementById("new-displayName").value = r.displayName || "";
  var rcEl = document.getElementById("new-receptionCapacity");
  if (rcEl) rcEl.value = r.receptionCapacity || "";
  var gcEl = document.getElementById("new-generationCapacity");
  if (gcEl) gcEl.value = r.generationCapacity || "";
  document.getElementById("new-bizNo").value = formatRecipientRegNoByKind(r.kind, r.bizNo || "");
  document.getElementById("new-ceoName").value = r.ceoName || "";
  document.getElementById("new-address").value = r.address || "";
  document.getElementById("new-email").value = r.email || "";
  var cpEl = document.getElementById("new-contactPhone");
  if (cpEl) cpEl.value = r.contactPhone || "";
  document.getElementById("new-bizType").value = r.bizType || "";
  document.getElementById("new-bizItem").value = r.bizItem || "";
  const memoEl = document.getElementById("new-internalMemo");
  if (memoEl) memoEl.value = r.internalMemo || "";
  var svcSafetyEl = document.getElementById("svc-safety");
  var svcTaxEl = document.getElementById("svc-tax");
  var svcBillingEl = document.getElementById("svc-billing");
  var svcMonitoringEl = document.getElementById("svc-monitoring");
  if (svcSafetyEl)     svcSafetyEl.checked     = !!r.svcSafety;
  if (svcTaxEl)        svcTaxEl.checked        = !!r.svcTax;
  if (svcBillingEl)    svcBillingEl.checked    = !!r.svcBilling;
  if (svcMonitoringEl) svcMonitoringEl.checked = !!r.svcMonitoring;
  var monTypeEl = document.getElementById("monitoring-type-select");
  if (monTypeEl) monTypeEl.value = r.monitoringType || "";
  var payEl = document.getElementById("new-paymentMethod");
  if (payEl) payEl.value = r.paymentMethod || "";
  syncMonitoringTypeWrap();
  syncMonitoringDelBtn();
  renderRecipientCertControls(r);
  toggleBizSubtype();
}

function clearRecipientForm() {
  pendingRecipientCert = null;
  document.getElementById("recipient-cert-file").value = "";
  document.getElementById("edit-recipient-id").value = "";
  document.getElementById("recipient-form").reset();
  document.getElementById("new-kind").value = "individual";
  renderRecipientCertControls(null);
  toggleBizSubtype();
  syncMonitoringTypeWrap();
  syncMonitoringDelBtn();
}

function startNewRecipient() {
  editingRecipientId = null;
  clearRecipientForm();
  document.getElementById("recipient-form-title").textContent = "공급받는자 추가";
  document.getElementById("btn-delete-recipient").style.display = "none";
  document.getElementById("btn-copy-recipient").style.display = "none";
  document.getElementById("items-editor-wrap").style.display = "none";
  document.getElementById("items-tbody").innerHTML = "";
  renderTable();
}

function startEditRecipient(id) {
  editingRecipientId = id;
  const r = recipientsCache.find(function (x) {
    return x.id === id;
  });
  if (!r) return;
  document.getElementById("recipient-form-title").textContent = "공급받는자 수정 (번호 " + id + ")";
  document.getElementById("btn-delete-recipient").style.display = "inline-block";
  document.getElementById("btn-copy-recipient").style.display = "inline-block";
  fillRecipientForm(r);
  document.getElementById("items-editor-wrap").style.display = "block";
  renderItemsEditor(r);
  renderTable();
}

async function uploadRecipientCert(file) {
  const rid = Number(editingRecipientId);
  if (!rid) throw new Error("공급받는자를 먼저 저장하세요.");
  const fd = new FormData();
  fd.append("file", file);
  const r = await fetch(rApi("/" + rid + "/biz-cert"), {
    method: "POST",
    body: fd,
    credentials: "same-origin",
  });
  const data = await r.json().catch(function () {
    return {};
  });
  if (!r.ok) throw new Error(data.error || "사업자등록증 업로드 실패");
}

function renderTable() {
  const tbody = document.getElementById("recipient-table-body");
  tbody.innerHTML = "";
  if (recipientsCache.length === 0) {
    tbody.innerHTML =
      "<tr class='recipient-table-empty-msg'><td colspan='6'>등록된 공급받는자가 없습니다.</td></tr>";
    applyRecipientAdminFilter();
    return;
  }
  for (let i = 0; i < recipientsCache.length; i++) {
    const r = recipientsCache[i];
    const rid = r.id;
    const tr = document.createElement("tr");
    tr.className = "recipient-list-row";
    tr.setAttribute("data-rec-id", String(rid));
    tr.setAttribute("data-rec-search", recipientAdminSearchHaystack(r));
    tr.setAttribute("data-rec-kind", r.kind || "individual");
    tr.setAttribute("data-rec-biz", r.kind === "business" ? String(r.bizSubtype || "sole") : "");
    tr.setAttribute("data-rec-bizno", String(r.bizNo || "").toLowerCase());
    tr.setAttribute("data-rec-phone", String(r.contactPhone || ""));
    tr.setAttribute("data-rec-name", String(r.displayName || "").toLowerCase().replace(/\s/g, ""));
    tr.setAttribute("data-rec-ceo", String(r.ceoName || "").toLowerCase().replace(/\s/g, ""));
    tr.setAttribute("data-rec-plant", (r.items || []).map(function (it) { return String(it.plantName || "").toLowerCase().replace(/\s/g, ""); }).join(" "));
    if (editingRecipientId === rid) tr.classList.add("recipient-row-selected");
    const n = (r.items || []).length;

    const td0 = document.createElement("td");
    td0.className = "recipient-col-check";
    const cb = document.createElement("input");
    cb.type = "checkbox";
    cb.className = "recipient-row-check";
    cb.setAttribute("data-rid", String(rid));
    cb.setAttribute("aria-label", "선택");
    cb.addEventListener("click", function (e) {
      e.stopPropagation();
    });
    td0.appendChild(cb);

    const tdPlant = document.createElement("td");
    tdPlant.textContent = recipientPlantSummary(r);
    tdPlant.title = tdPlant.textContent;
    const tdOwner = document.createElement("td");
    tdOwner.textContent = r.ceoName || "";
    tdOwner.style.overflow = "hidden";
    tdOwner.style.textOverflow = "ellipsis";
    tdOwner.style.whiteSpace = "nowrap";
    const td2 = document.createElement("td");
    td2.textContent = kindLabel(r.kind, r.bizSubtype);
    const td3 = document.createElement("td");
    td3.textContent = String(n);
    const tdSvc = document.createElement("td");
    var svcLabels = [];
    if (r.svcSafety)     svcLabels.push("안전관리");
    if (r.svcTax)        svcLabels.push("세무");
    if (r.svcBilling)    svcLabels.push("청구");
    if (r.svcMonitoring) svcLabels.push("모니터링");
    if (svcLabels.length) {
      for (var si = 0; si < svcLabels.length; si++) {
        var badge = document.createElement("span");
        badge.className = "svc-badge";
        badge.textContent = svcLabels[si];
        tdSvc.appendChild(badge);
      }
    } else {
      tdSvc.textContent = "—";
      tdSvc.style.color = "var(--text-muted)";
    }

    const tdPay = document.createElement("td");
    if (r.paymentMethod) {
      var payBadge = document.createElement("span");
      payBadge.className = "svc-badge";
      payBadge.style.background = r.paymentMethod === "자동이체(CMS)" ? "#fef3c7" : "#f0fdf4";
      payBadge.style.color = r.paymentMethod === "자동이체(CMS)" ? "#92400e" : "#166534";
      payBadge.textContent = r.paymentMethod;
      tdPay.appendChild(payBadge);
    } else {
      tdPay.textContent = "—";
      tdPay.style.color = "var(--text-muted)";
    }

    const tdMemo = document.createElement("td");
    tdMemo.style.textAlign = "center";
    const memoText = String(r.internalMemo || "").trim();
    if (memoText) {
      tdMemo.textContent = "✓";
      tdMemo.title = memoText;
      tdMemo.style.color = "var(--navy)";
      tdMemo.style.fontWeight = "600";
    }

    tr.addEventListener("click", function (ev) {
      if (ev.target.closest(".recipient-col-check")) return;
      startEditRecipient(rid);
    });

    tr.appendChild(td0);
    tr.appendChild(tdPlant);
    tr.appendChild(tdOwner);
    tr.appendChild(td2);
    tr.appendChild(td3);
    tr.appendChild(tdSvc);
    tr.appendChild(tdPay);
    tr.appendChild(tdMemo);
    tbody.appendChild(tr);
  }
  applyRecipientAdminFilter();
}

function _fmtComma(v, allowDecimal) {
  let s = String(v).replace(/[^0-9.]/g, "");
  if (!allowDecimal) s = s.replace(/\./g, "");
  if (!s) return "";
  const parts = s.split(".");
  const n = parseInt(parts[0] || "0", 10) || 0;
  const intStr = n.toLocaleString("ko-KR");
  return (allowDecimal && parts.length > 1) ? intStr + "." + parts[1] : intStr;
}
function _bindComma(inp, allowDecimal) {
  inp.type = "text";
  inp.inputMode = "numeric";
  inp.removeAttribute("min");
  inp.removeAttribute("step");
  inp.addEventListener("input", function () {
    const pos = this.selectionStart;
    const oldLen = this.value.length;
    const nv = _fmtComma(this.value, allowDecimal);
    this.value = nv;
    try { const np = Math.max(0, pos + nv.length - oldLen); this.setSelectionRange(np, np); } catch (e) {}
  });
  inp.value = _fmtComma(String(inp.value).replace(/,/g, "") || "0", allowDecimal);
}
function _readComma(inp, allowDecimal) {
  const s = String(inp.value).replace(/,/g, "");
  return allowDecimal ? (parseFloat(s) || 0) : (parseInt(s, 10) || 0);
}

function rowItem(rid, it) {
  const frag = document.createDocumentFragment();
  const tr1 = document.createElement("tr");
  const tr2 = document.createElement("tr");

  function makeInp(cls, type, val) {
    const inp = document.createElement("input");
    inp.className = cls;
    inp.style.width = "100%";
    inp.style.boxSizing = "border-box";
    if (type) inp.type = type;
    inp.value = val != null ? String(val) : "";
    if (type === "number") { inp.min = "0"; inp.step = "1"; }
    return inp;
  }

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

  const plantInp = makeInp("e-plant", null, it.plantName || "");
  const fixedInp = makeInp("e-fixed", null, it.fixedItemName || "");
  const qtyInp   = makeInp("e-qty", null, it.quantity || 0);
  const upInp    = makeInp("e-unitprice", null, it.unitPrice || 0);
  const supInp   = makeInp("e-supply", null, it.monthlySupply || 0);
  const taxInp   = makeInp("e-tax", null, "");
  taxInp.readOnly  = true;
  taxInp.tabIndex  = -1;
  taxInp.style.background = "#f8fafc";
  taxInp.style.cursor = "not-allowed";
  const noteInp  = makeInp("e-note", null, it.note || "");

  _bindComma(qtyInp, true);
  _bindComma(upInp, false);
  _bindComma(supInp, false);

  // 행1: 라벨+입력란(5칸) / 라벨+입력란(5칸) / 삭제(rowspan=2)
  tr1.appendChild(labeledTd("발전소명", plantInp, 5));
  tr1.appendChild(labeledTd("품목명", fixedInp, 5));
  const tdBtn = document.createElement("td");
  tdBtn.rowSpan = 2;
  tdBtn.style.cssText = "text-align:center;vertical-align:middle";
  const delBtn = document.createElement("button");
  delBtn.type = "button"; delBtn.className = "btn btn-danger btn-del-item"; delBtn.textContent = "-"; delBtn.title = "품목 삭제";
  tdBtn.appendChild(delBtn); tr1.appendChild(tdBtn);

  // 행2: 라벨+입력란(2칸씩) × 5 = 동일 너비
  tr2.appendChild(labeledTd("수량", qtyInp, 2));
  tr2.appendChild(labeledTd("단가", upInp, 2));
  tr2.appendChild(labeledTd("공급가액", supInp, 2));
  tr2.appendChild(labeledTd("세액", taxInp, 2));
  tr2.appendChild(labeledTd("비고", noteInp, 2));

  function syncTax() {
    const supply = _readComma(supInp, false);
    taxInp.value = Math.floor(supply * 0.1).toLocaleString("ko-KR");
  }
  syncTax();

  async function saveRow() {
    await apiSend(rApi("/" + rid + "/items/" + it.id), "PUT", {
      plantName: plantInp.value,
      fixedItemName: fixedInp.value,
      quantity: _readComma(qtyInp, true),
      unitPrice: _readComma(upInp, false),
      monthlySupply: _readComma(supInp, false),
      note: noteInp.value,
    });
  }

  supInp.addEventListener("input", syncTax);
  [plantInp, fixedInp, qtyInp, upInp, supInp, noteInp].forEach(function (inp) {
    inp.addEventListener("change", saveRow);
  });

  delBtn.addEventListener("click", async function () {
    const sure = await confirmModal("이 품목을 삭제할까요?", "품목 삭제", "삭제");
    if (!sure) return;
    await apiSend(rApi("/" + rid + "/items/" + it.id), "DELETE");
    await loadRecipients();
  });

  frag.appendChild(tr1);
  frag.appendChild(tr2);
  return frag;
}

function renderItemsEditor(r) {
  const tb = document.getElementById("items-tbody");
  tb.innerHTML = "";
  const items = r.items || [];
  for (let j = 0; j < items.length; j++) {
    tb.appendChild(rowItem(r.id, items[j]));
  }

  const btnAdd = document.getElementById("btn-add-item");
  const newBtn = btnAdd.cloneNode(true);
  btnAdd.parentNode.replaceChild(newBtn, btnAdd);
  newBtn.id = "btn-add-item";
  newBtn.addEventListener("click", async function () {
    await apiSend(rApi("/" + r.id + "/items"), "POST", {
      plantName: "",
      fixedItemName: "",
      monthlySupply: 0,
      monthlyTax: 0,
      note: "",
    });
    await loadRecipients();
  });
}

(async function () {
  await loadSiteConfig();
  const ok = await checkLogin();
  if (!ok) return;

  // 담당자 전화번호 자동 포맷
  (function () {
    var el = document.getElementById("new-contactPhone");
    if (!el) return;
    el.addEventListener("keydown", function (e) {
      if (e.ctrlKey || e.metaKey || e.altKey) return;
      if (!e.key || e.key.length !== 1) return;
      if (/[0-9]/.test(e.key)) return;
      e.preventDefault();
    });
    el.addEventListener("input", function () {
      var digits = el.value.replace(/\D/g, "").slice(0, 11);
      var f = digits.length <= 3 ? digits
        : digits.length <= 6 ? digits.slice(0,3)+"-"+digits.slice(3)
        : digits.length <= 10 ? digits.slice(0,3)+"-"+digits.slice(3,6)+"-"+digits.slice(6)
        : digits.slice(0,3)+"-"+digits.slice(3,7)+"-"+digits.slice(7);
      if (f !== el.value) el.value = f;
    });
  }());

  document.getElementById("new-kind").addEventListener("change", toggleBizSubtype);
  document.getElementById("new-kind").addEventListener("change", function () {
    const kind = document.getElementById("new-kind").value;
    if (kind === "business" || kind === "individual") {
      const bizEl = document.getElementById("new-bizNo");
      bizEl.value = formatRecipientRegNoByKind(kind, bizEl.value);
    }
  });
  bindRecipientBizNoAutoFormat();
  toggleBizSubtype();

  // 모니터링 체크박스 → 종류 선택 영역 토글
  document.getElementById("svc-monitoring").addEventListener("change", function () {
    syncMonitoringTypeWrap();
  });

  // 모니터링 종류 select 변경 → 삭제 버튼 표시 여부
  document.getElementById("monitoring-type-select").addEventListener("change", syncMonitoringDelBtn);

  // 직접 추가 버튼
  document.getElementById("btn-add-monitoring-option").addEventListener("click", function () {
    var wrap = document.getElementById("monitoring-custom-wrap");
    if (wrap) { wrap.style.display = "flex"; }
    var inp = document.getElementById("monitoring-custom-input");
    if (inp) { inp.value = ""; inp.focus(); }
  });

  // 직접 추가 저장
  document.getElementById("btn-save-monitoring-option").addEventListener("click", async function () {
    var inp = document.getElementById("monitoring-custom-input");
    var name = inp ? inp.value.trim() : "";
    if (!name) { await alertModal("이름을 입력하세요."); return; }
    try {
      await apiSend("/api/monitoring-options", "POST", { name });
      await loadMonitoringOptions();
      var sel = document.getElementById("monitoring-type-select");
      if (sel) sel.value = name;
      syncMonitoringDelBtn();
      var wrap = document.getElementById("monitoring-custom-wrap");
      if (wrap) wrap.style.display = "none";
    } catch (e) {
      await alertModal(e.message || "추가 실패");
    }
  });

  // 직접 추가 취소
  document.getElementById("btn-cancel-monitoring-option").addEventListener("click", function () {
    var wrap = document.getElementById("monitoring-custom-wrap");
    if (wrap) wrap.style.display = "none";
  });

  // 모니터링 종류 삭제
  document.getElementById("btn-del-monitoring-option").addEventListener("click", async function () {
    var sel = document.getElementById("monitoring-type-select");
    var selected = sel && sel.options[sel.selectedIndex];
    if (!selected || !selected.value) return;
    var id = selected.getAttribute("data-id");
    if (!id) return;
    var sure = await confirmModal('"' + selected.value + '" 종류를 삭제할까요?', "모니터링 종류 삭제", "삭제");
    if (!sure) return;
    try {
      await apiSend("/api/monitoring-options/" + id, "DELETE");
      await loadMonitoringOptions();
    } catch (e) {
      await alertModal(e.message || "삭제 실패");
    }
  });

  await loadMonitoringOptions();

  document.getElementById("logout-btn").addEventListener("click", async function (e) {
    e.preventDefault();
    const sure = await confirmModal("정말 로그아웃 하시겠습니까?", "로그아웃", "로그아웃");
    if (!sure) return;
    await apiSend("/api/logout", "POST");
    window.location.href = BASE + "/login.html";
  });

  document.getElementById("btn-excel-file-pick").addEventListener("click", function () {
    document.getElementById("excel-file").click();
  });

  document.getElementById("excel-file").addEventListener("change", function () {
    const nameEl = document.getElementById("excel-file-name");
    if (nameEl) nameEl.textContent = this.files && this.files[0] ? this.files[0].name : "";
  });

  async function doExcelImport(file, recipientChoices) {
    const out = document.getElementById("excel-import-result");
    const mode = document.getElementById("import-mode").value || "merge";
    const fd = new FormData();
    fd.append("file", file);
    fd.append("mode", mode);
    fd.append("recipientChoices", JSON.stringify(recipientChoices || {}));
    try {
      const r = await fetch(BASE + "/api/recipients/import-excel", {
        method: "POST",
        body: fd,
        credentials: "same-origin",
      });
      const data = await r.json().catch(function () { return {}; });
      if (!r.ok) {
        out.textContent = data.error || "가져오기 실패";
        return;
      }
      out.textContent = "반영 완료 (신규 " + data.created + " · 갱신 " + data.updated + ")";
      document.getElementById("excel-file").value = "";
      var nameEl = document.getElementById("excel-file-name");
      if (nameEl) nameEl.textContent = "";
      await loadRecipients();
    } catch (err) {
      out.textContent = err.message || "오류";
    }
  }

  function showExcelConflictModal(multiItem, file) {
    var modal = document.getElementById("excel-conflict-modal");
    var listEl = document.getElementById("excel-conflict-list");
    if (!modal || !listEl) return;

    listEl.innerHTML = multiItem.map(function (r, idx) {
      var itemsHtml = r.items.map(function (it) {
        return "<li style='color:#555'>" + escapeHtml(it.plantName || it.fixedItemName || "-") + "</li>";
      }).join("");
      return "<div style='padding:8px 0;border-bottom:1px solid #eee'>" +
        "<div style='font-weight:600;margin-bottom:3px'>" + escapeHtml(r.displayName || r.bizDisplay) + " <span style='font-weight:400;color:#888'>(" + r.items.length + "개)</span></div>" +
        "<ul style='margin:0 0 6px 16px;font-size:0.82rem'>" + itemsHtml + "</ul>" +
        "<div style='display:flex;gap:20px;font-size:0.85rem'>" +
        "<label style='cursor:pointer'><input type='radio' name='ec-choice-" + idx + "' value='merge' checked> 하나로 합치기</label>" +
        "<label style='cursor:pointer'><input type='radio' name='ec-choice-" + idx + "' value='split'> 각각 개별등록</label>" +
        "</div></div>";
    }).join("");

    modal.style.display = "flex";

    document.getElementById("excel-conflict-confirm").onclick = async function () {
      var choices = {};
      multiItem.forEach(function (r, idx) {
        var selected = listEl.querySelector('input[name="ec-choice-' + idx + '"]:checked');
        choices[r.key] = selected ? selected.value : "merge";
      });
      modal.style.display = "none";
      await doExcelImport(file, choices);
    };
    document.getElementById("excel-conflict-cancel").onclick = function () {
      modal.style.display = "none";
    };
    modal.onclick = function (e) {
      if (e.target === modal) modal.style.display = "none";
    };
  }

  document.getElementById("excel-import-form").addEventListener("submit", async function (e) {
    e.preventDefault();
    const out = document.getElementById("excel-import-result");
    out.textContent = "";
    const fileInput = document.getElementById("excel-file");
    const file = fileInput.files && fileInput.files[0];
    if (!file) {
      out.textContent = "파일을 선택하세요.";
      return;
    }
    const fd1 = new FormData();
    fd1.append("file", file);
    try {
      const r1 = await fetch(BASE + "/api/recipients/import-excel/preview", {
        method: "POST",
        body: fd1,
        credentials: "same-origin",
      });
      const preview = await r1.json().catch(function () { return {}; });
      if (!r1.ok) {
        out.textContent = preview.error || "가져오기 실패";
        return;
      }
      if (preview.multiItem && preview.multiItem.length > 0) {
        showExcelConflictModal(preview.multiItem, file);
      } else {
        await doExcelImport(file, {});
      }
    } catch (err) {
      out.textContent = err.message || "오류";
    }
  });

  document.getElementById("btn-new-recipient").addEventListener("click", function () {
    startNewRecipient();
  });

  document.getElementById("btn-save-recipient").addEventListener("click", function () {
    document.getElementById("recipient-form").requestSubmit();
  });

  document.getElementById("recipient-cert-file").addEventListener("change", async function () {
    const file = this.files && this.files[0];
    if (!file) return;
    if (!editingRecipientId) {
      // 신규 공급받는자: 파일 저장 후 저장 시 업로드
      pendingRecipientCert = file;
      renderRecipientCertControls(null);
      this.value = "";
      return;
    }
    try {
      await uploadRecipientCert(file);
      await loadRecipients();
      const next = findRecipientById(editingRecipientId);
      if (next) renderRecipientCertControls(next);
    } catch (e) {
      await alertModal(e.message || "사업자등록증 등록 실패");
    } finally {
      this.value = "";
    }
  });

  document.getElementById("recipient-form").addEventListener("submit", async function (e) {
    e.preventDefault();
    const kind = document.getElementById("new-kind").value;
    const body = {
      kind,
      displayName: document.getElementById("new-displayName").value.trim(),
      receptionCapacity:  Number((document.getElementById("new-receptionCapacity")  || {}).value) || 0,
      generationCapacity: Number((document.getElementById("new-generationCapacity") || {}).value) || 0,
      bizNo: formatRecipientRegNoByKind(kind, document.getElementById("new-bizNo").value),
      ceoName: document.getElementById("new-ceoName").value,
      address: document.getElementById("new-address").value,
      email: document.getElementById("new-email").value,
      contactPhone: String((document.getElementById("new-contactPhone") || {}).value || "").trim(),
      internalMemo: String((document.getElementById("new-internalMemo") || {}).value || "").trim(),
      svcSafety:     !!(document.getElementById("svc-safety")     || {}).checked,
      svcTax:        !!(document.getElementById("svc-tax")        || {}).checked,
      svcBilling:    !!(document.getElementById("svc-billing")    || {}).checked,
      svcMonitoring:  !!(document.getElementById("svc-monitoring")      || {}).checked,
      monitoringType: String((document.getElementById("monitoring-type-select") || {}).value || ""),
      paymentMethod: String((document.getElementById("new-paymentMethod") || {}).value || ""),
    };
    if (kind === "business") {
      body.bizSubtype = document.getElementById("new-bizSubtype").value;
      body.bizType = document.getElementById("new-bizType").value.trim();
      body.bizItem = document.getElementById("new-bizItem").value.trim();
    } else {
      body.bizType = "";
      body.bizItem = "";
    }
    const rid = document.getElementById("edit-recipient-id").value;
    if (rid) {
      await apiSend(rApi("/" + rid), "PUT", body);
      await loadRecipients();
      showToast("저장되었습니다.");
    } else {
      const res = await apiSend(rApi(""), "POST", body);
      await loadRecipients();
      if (res.recipient && res.recipient.id) {
        editingRecipientId = res.recipient.id;
        if (pendingRecipientCert) {
          const file = pendingRecipientCert;
          pendingRecipientCert = null;
          document.getElementById("recipient-cert-file").value = "";
          try {
            await uploadRecipientCert(file);
            await loadRecipients();
          } catch (e) { console.error("cert upload failed:", e); }
        }
        startEditRecipient(res.recipient.id);
      }
    }
  });

  document.getElementById("btn-recipient-select-all").addEventListener("click", function () {
    const tbody = document.getElementById("recipient-table-body");
    if (!tbody) return;
    const rows = tbody.querySelectorAll("tr[data-rec-id]");
    const visible = [];
    for (let i = 0; i < rows.length; i++) {
      const tr = rows[i];
      if (!tr.classList.contains("rec-row-hidden")) visible.push(tr);
    }
    if (!visible.length) return;
    const allOn = visible.every(function (tr) {
      const inp = tr.querySelector(".recipient-row-check");
      return inp && inp.checked;
    });
    for (let j = 0; j < visible.length; j++) {
      const inp = visible[j].querySelector(".recipient-row-check");
      if (inp) inp.checked = !allOn;
    }
  });

  document.getElementById("btn-recipient-delete-selected").addEventListener("click", async function () {
    const tbody = document.getElementById("recipient-table-body");
    if (!tbody) return;
    const checked = tbody.querySelectorAll("input.recipient-row-check:checked");
    const ids = [];
    for (let i = 0; i < checked.length; i++) {
      ids.push(Number(checked[i].getAttribute("data-rid")));
    }
    if (!ids.length) {
      await alertModal("삭제할 공급받는자를 선택하세요.");
      return;
    }
    const sure = await confirmModal(
      "선택한 " + ids.length + "명의 공급받는자와 품목을 모두 삭제할까요?",
      "일괄 삭제",
      "삭제"
    );
    if (!sure) return;
    for (let j = 0; j < ids.length; j++) {
      await apiSend(rApi("/" + ids[j]), "DELETE");
    }
    if (editingRecipientId != null && ids.indexOf(editingRecipientId) >= 0) {
      startNewRecipient();
    }
    await loadRecipients();
  });

  document.getElementById("btn-delete-recipient").addEventListener("click", async function () {
    const rid = editingRecipientId;
    if (!rid) return;
    const sure = await confirmModal("이 공급받는자와 품목을 모두 삭제할까요?", "삭제", "삭제");
    if (!sure) return;
    await apiSend(rApi("/" + rid), "DELETE");
    startNewRecipient();
    await loadRecipients();
  });

  document.getElementById("btn-copy-recipient").addEventListener("click", async function () {
    const rid = editingRecipientId;
    if (!rid) return;
    const src = recipientsCache.find(function (x) { return x.id === rid; });
    if (!src) return;
    const sure = await confirmModal(
      "'" + escapeHtml(src.displayName || "") + "' 공급받는자를 복사하시겠습니까?\n기본 정보와 품목이 모두 복사됩니다.",
      "복사", "복사"
    );
    if (!sure) return;
    try {
      // 1. 기본 정보 복사로 신규 생성
      const body = {
        kind: src.kind,
        bizSubtype: src.bizSubtype,
        displayName: src.displayName,
        bizNo: src.bizNo,
        ceoName: src.ceoName,
        address: src.address,
        email: src.email,
        receptionCapacity: src.receptionCapacity,
        generationCapacity: src.generationCapacity,
        bizType: src.bizType,
        bizItem: src.bizItem,
        internalMemo: src.internalMemo,
        contactName: src.contactName,
        contactPhone: src.contactPhone,
        contactEmail: src.contactEmail,
        svcSafety: src.svcSafety,
        svcTax: src.svcTax,
        svcBilling: src.svcBilling,
        svcMonitoring: src.svcMonitoring,
        monitoringType: src.monitoringType,
        paymentMethod: src.paymentMethod,
      };
      const res = await apiSend(rApi(""), "POST", body);
      const newId = res.recipient && res.recipient.id;
      if (!newId) throw new Error("복사 실패");

      // 2. 품목 복사
      const items = src.items || [];
      for (let i = 0; i < items.length; i++) {
        const it = items[i];
        await apiSend(rApi("/" + newId + "/items"), "POST", {
          plantName: it.plantName,
          fixedItemName: it.fixedItemName,
          monthlySupply: it.monthlySupply,
          note: it.note,
        });
      }

      await loadRecipients();
      startEditRecipient(newId);
      showToast("복사되었습니다. 필요한 내용을 수정 후 저장하세요.");
    } catch (e) {
      await alertModal("복사 실패: " + e.message, "오류");
    }
  });

  const adminSearch = document.getElementById("recipient-admin-search");
  if (adminSearch) {
    adminSearch.addEventListener("input", applyRecipientAdminFilter);
  }
  const kindFilter = document.getElementById("recipient-admin-kind-filter");
  if (kindFilter) kindFilter.addEventListener("change", applyRecipientAdminFilter);

  const recipientColChips = document.getElementById("recipient-search-col-chips");
  if (recipientColChips) {
    const recipientSearchInput = document.getElementById("recipient-admin-search");
    if (recipientSearchInput) recipientSearchInput.placeholder = "전체 검색";
    recipientColChips.addEventListener("click", function (e) {
      const chip = e.target.closest(".search-col-chip");
      if (!chip) return;
      recipientColChips.querySelectorAll(".search-col-chip").forEach(function (c) { c.classList.remove("active"); });
      chip.classList.add("active");
      if (recipientSearchInput) recipientSearchInput.placeholder = chip.textContent.trim() + " 검색";
      applyRecipientAdminFilter();
    });
  }

  startNewRecipient();
  await loadRecipients();

  const editId = Number(new URLSearchParams(window.location.search).get("edit"));
  if (editId) startEditRecipient(editId);
})();
