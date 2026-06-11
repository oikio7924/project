/**
 * 공급자 여러 명 · 발행 시 사용할 공급자 선택
 */
let userCache = null;
let editingSupplierId = null;
const SUPPLIER_PAGE_SIZE = 20;
let supplierCurrentPage = 1;

function sApi(sid) {
  return sid ? "/api/me/suppliers/" + sid : "/api/me/suppliers";
}

var CONTACT_DEPT_PRESET = ["경영지원부", "사업개발부", "기술부", "기업부설연구소"];

var CONTACT_EXT_RAW = [
  700, 400, 600, 201, 202, 203, 810, 820, 401, 402, 403, 301, 302, 303, 501, 210, 611, 612, 613, 620, 621, 622,
];
var CONTACT_EXT_PRESET = CONTACT_EXT_RAW.slice().sort(function (a, b) {
  return a - b;
});
var CONTACT_EMAIL_DOMAIN_PRESET = ["dycompany.co.kr", "naver.com", "hanmail.net", "gmail.com"];

function initContactExtensionSelect() {
  var sel = document.getElementById("contactExtension");
  if (!sel || sel.getAttribute("data-inited") === "1") return;
  for (var i = 0; i < CONTACT_EXT_PRESET.length; i++) {
    var n = CONTACT_EXT_PRESET[i];
    var o = document.createElement("option");
    o.value = String(n);
    o.textContent = String(n);
    sel.appendChild(o);
  }
  sel.setAttribute("data-inited", "1");
}

function fillContactExtensionSelect(stored) {
  initContactExtensionSelect();
  var sel = document.getElementById("contactExtension");
  var val = String(stored || "").trim();
  var legacy = sel.querySelector("option[data-legacy]");
  if (legacy) legacy.remove();
  var presetStr = CONTACT_EXT_PRESET.map(String);
  if (val && presetStr.indexOf(val) === -1) {
    var o = document.createElement("option");
    o.value = val;
    o.textContent = val + " (기존 저장값)";
    o.setAttribute("data-legacy", "1");
    sel.appendChild(o);
  }
  sel.value = val || "";
}

/** 10자리: 000-000-0000 · 11자리: 000-0000-0000 (숫자만 사용) */
function formatContactPhoneDisplay(value) {
  var digits = String(value || "")
    .replace(/\D/g, "")
    .slice(0, 11);
  if (!digits.length) return "";
  if (digits.length <= 10) {
    if (digits.length <= 3) return digits;
    if (digits.length <= 6) return digits.slice(0, 3) + "-" + digits.slice(3);
    return digits.slice(0, 3) + "-" + digits.slice(3, 6) + "-" + digits.slice(6);
  }
  return digits.slice(0, 3) + "-" + digits.slice(3, 7) + "-" + digits.slice(7);
}

function bindContactPhoneAutoFormat() {
  var el = document.getElementById("contactPhone");
  if (!el || el.getAttribute("data-phone-format") === "1") return;
  el.setAttribute("data-phone-format", "1");
  el.addEventListener("keydown", function (e) {
    if (e.ctrlKey || e.metaKey || e.altKey) return;
    if (!e.key || e.key.length !== 1) return;
    if (/[0-9]/.test(e.key)) return;
    e.preventDefault();
  });
  el.addEventListener("input", function () {
    var formatted = formatContactPhoneDisplay(el.value);
    if (formatted !== el.value) el.value = formatted;
  });
}

function bindSupplierBizNoAutoFormat() {
  var el = document.getElementById("bizNo");
  if (!el || el.getAttribute("data-bizno-format") === "1") return;
  el.setAttribute("data-bizno-format", "1");
  el.addEventListener("keydown", function (e) {
    if (e.ctrlKey || e.metaKey || e.altKey) return;
    if (!e.key || e.key.length !== 1) return;
    if (/[0-9]/.test(e.key)) return;
    e.preventDefault();
  });
  el.addEventListener("input", function () {
    var formatted = formatBizNoDisplay(el.value);
    if (formatted !== el.value) el.value = formatted;
  });
}

function fillContactDeptSelect(stored) {
  var sel = document.getElementById("contactDept");
  var val = String(stored || "").trim();
  var legacy = sel.querySelector("option[data-legacy]");
  if (legacy) legacy.remove();
  if (val && CONTACT_DEPT_PRESET.indexOf(val) === -1) {
    var o = document.createElement("option");
    o.value = val;
    o.textContent = val + " (기존 저장값)";
    o.setAttribute("data-legacy", "1");
    sel.appendChild(o);
  }
  sel.value = val || "";
}

function parseEmailParts(email) {
  var raw = String(email || "").trim();
  var at = raw.indexOf("@");
  if (at < 0) return { local: raw, domain: "" };
  return {
    local: raw.slice(0, at),
    domain: raw.slice(at + 1),
  };
}

function syncContactEmailDomainUi() {
  var sel = document.getElementById("contactEmailDomainSelect");
  var custom = document.getElementById("contactEmailDomainCustom");
  if (!sel || !custom) return;
  custom.style.display = sel.value === "custom" ? "block" : "none";
}

function fillContactEmailFields(storedEmail) {
  var localEl = document.getElementById("contactEmailLocal");
  var domainSel = document.getElementById("contactEmailDomainSelect");
  var customEl = document.getElementById("contactEmailDomainCustom");
  if (!localEl || !domainSel || !customEl) return;
  var parts = parseEmailParts(storedEmail);
  localEl.value = parts.local || "";
  customEl.value = "";
  if (!parts.domain) {
    domainSel.value = "";
  } else if (CONTACT_EMAIL_DOMAIN_PRESET.indexOf(parts.domain) >= 0) {
    domainSel.value = parts.domain;
  } else {
    domainSel.value = "custom";
    customEl.value = parts.domain;
  }
  syncContactEmailDomainUi();
}

function buildContactEmailValue() {
  var local = String(document.getElementById("contactEmailLocal").value || "").trim();
  var domainMode = String(document.getElementById("contactEmailDomainSelect").value || "").trim();
  var customDomain = String(document.getElementById("contactEmailDomainCustom").value || "").trim();
  var domain = domainMode === "custom" ? customDomain : domainMode;
  if (!local && !domain) return "";
  if (!local || !domain) return local;
  return local + "@" + domain;
}

function renderSupplierCertControls(s) {
  const area = document.getElementById("supplier-cert-area");
  if (!area) return;

  const hasFile = !!(s && s.bizCertUrl);
  const filename = s && s.bizCertName ? s.bizCertName : (hasFile ? "사업자등록증" : null);

  if (!s) {
    area.innerHTML = `<span class="biz-cert-msg">공급자를 먼저 선택하세요.</span>`;
    return;
  }

  if (hasFile) {
    area.innerHTML = `
      <div class="biz-cert-file">
        <svg class="biz-cert-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" fill="#ff4444" opacity="0.15" stroke="#ff4444" stroke-width="1.5"/>
          <polyline points="14 2 14 8 20 8" stroke="#ff4444" stroke-width="1.5" fill="none"/>
          <text x="12" y="17" text-anchor="middle" font-size="5.5" font-weight="700" font-family="Arial,sans-serif" fill="#ff4444" letter-spacing="0.3">PDF</text>
        </svg>
        <span class="biz-cert-name" title="${escapeHtml(filename)}">${escapeHtml(filename)}</span>
        <button type="button" class="btn btn-sm btn-secondary" id="btn-supplier-cert-view">보기</button>
        <button type="button" class="btn btn-sm btn-danger-soft" id="btn-supplier-cert-delete">삭제</button>
      </div>`;
    document.getElementById("btn-supplier-cert-view").addEventListener("click", function () {
      if (s.bizCertUrl) window.open(s.bizCertUrl, "_blank", "noopener,noreferrer");
    });
    document.getElementById("btn-supplier-cert-delete").addEventListener("click", onSupplierCertDelete);
  } else {
    area.innerHTML = `<button type="button" class="btn btn-sm btn-secondary" id="btn-supplier-cert-upload">등록</button>`;
    document.getElementById("btn-supplier-cert-upload").addEventListener("click", function () {
      var fi = document.getElementById("supplier-cert-file");
      fi.value = ""; fi.click();
    });
  }
}

async function onSupplierCertDelete() {
  var sure = await confirmModal("등록된 사업자등록증을 삭제할까요?", "사업자등록증 삭제", "삭제");
  if (!sure) return;
  try {
    var data = await apiSend(sApi(editingSupplierId) + "/biz-cert", "DELETE");
    userCache = data.user;
    var row = userCache.suppliers.find(function (x) { return x.id === editingSupplierId; });
    if (row) { row.bizCertUrl = null; row.bizCertName = null; }
    renderSupplierCertControls(row || null);
  } catch (e) { await alertModal(e.message || "삭제 실패"); }
}

function fillForm(s) {
  document.getElementById("bizNo").value = formatBizNoDisplay(s.bizNo || "");
  document.getElementById("corpName").value = s.corpName || "";
  document.getElementById("ceoName").value = s.ceoName || "";
  document.getElementById("phone").value = formatContactPhoneDisplay(s.phone || "");
  document.getElementById("address").value = s.address || "";
  document.getElementById("bizType").value = s.bizType || "";
  document.getElementById("bizItem").value = s.bizItem || "";
  document.getElementById("email").value = s.email || "";
  fillContactDeptSelect(s.contactDept);
  document.getElementById("contactName").value = s.contactName || "";
  document.getElementById("contactPhone").value = formatContactPhoneDisplay(s.contactPhone || "");
  fillContactExtensionSelect(s.contactExtension);
  fillContactEmailFields(s.contactEmail || "");
  renderSupplierCertControls(s);
}

function getFormBody() {
  return {
    bizNo: formatBizNoDisplay(document.getElementById("bizNo").value),
    corpName: document.getElementById("corpName").value,
    ceoName: document.getElementById("ceoName").value,
    phone: document.getElementById("phone").value,
    address: document.getElementById("address").value,
    bizType: document.getElementById("bizType").value,
    bizItem: document.getElementById("bizItem").value,
    email: document.getElementById("email").value,
    contactDept: document.getElementById("contactDept").value,
    contactName: document.getElementById("contactName").value,
    contactPhone: document.getElementById("contactPhone").value,
    contactExtension: document.getElementById("contactExtension").value,
    contactEmail: buildContactEmailValue(),
  };
}

function clampSupplierPage(totalRows) {
  const totalPages = Math.max(1, Math.ceil(totalRows / SUPPLIER_PAGE_SIZE));
  if (supplierCurrentPage > totalPages) supplierCurrentPage = totalPages;
  if (supplierCurrentPage < 1) supplierCurrentPage = 1;
  return totalPages;
}

function renderSupplierPager(totalRows, totalPages) {
  const pager = document.getElementById("supplier-list-pagination");
  const info = document.getElementById("supplier-page-info");
  const prev = document.getElementById("supplier-page-prev");
  const next = document.getElementById("supplier-page-next");
  if (!pager || !info || !prev || !next) return;
  if (totalRows <= SUPPLIER_PAGE_SIZE) {
    pager.style.display = "none";
    return;
  }
  pager.style.display = "flex";
  info.textContent = supplierCurrentPage + " / " + totalPages + " 페이지";
  prev.disabled = supplierCurrentPage <= 1;
  next.disabled = supplierCurrentPage >= totalPages;
}

function renderList() {
  const user = userCache;
  if (!user || !user.suppliers) return;
  const tbody = document.getElementById("supplier-list-body");
  const activeId = user.activeSupplierId;
  tbody.innerHTML = "";
  const rows = user.suppliers.slice().sort(function (a, b) {
    return (Number(a.id) || 0) - (Number(b.id) || 0);
  });
  const totalPages = clampSupplierPage(rows.length);
  const start = (supplierCurrentPage - 1) * SUPPLIER_PAGE_SIZE;
  const end = Math.min(rows.length, start + SUPPLIER_PAGE_SIZE);
  for (let i = start; i < end; i++) {
    const s = rows[i];
    const tr = document.createElement("tr");
    tr.style.cursor = "pointer";
    if (editingSupplierId === s.id) tr.classList.add("recipient-row-selected");
    const useMark = s.id === activeId ? "●" : "—";
    tr.innerHTML =
      "<td>" +
      escapeHtml(useMark) +
      "</td><td>" +
      escapeHtml(String(i + 1)) +
      "</td><td>" +
      escapeHtml(s.corpName || "(무상호)") +
      "</td><td>" +
      escapeHtml(s.bizNo || "") +
      "</td><td></td>";
    const tdAct = tr.querySelector("td:last-child");
    const bUse = document.createElement("button");
    bUse.type = "button";
    bUse.className = "btn btn-primary";
    bUse.style.marginRight = "6px";
    bUse.textContent = "사용";
    bUse.setAttribute("data-sid", String(s.id));
    const bDel = document.createElement("button");
    bDel.type = "button";
    bDel.className = "btn btn-danger";
    bDel.textContent = "삭제";
    bDel.setAttribute("data-sid", String(s.id));
    tdAct.appendChild(bUse);
    tdAct.appendChild(bDel);

    tr.addEventListener("click", function (e) {
      if (e.target.closest("button")) return;
      editingSupplierId = s.id;
      const row = user.suppliers.find(function (x) {
        return x.id === editingSupplierId;
      });
      if (row) fillForm(row);
      document.getElementById("supplier-form-heading").textContent = "공급자 편집 (번호 " + editingSupplierId + ")";
      renderList();
    });
    bUse.addEventListener("click", async function () {
      const sid = Number(this.getAttribute("data-sid"));
      const ok = await confirmModal(
        "이 공급자를 세금계산서 발행 시 공급자란에 사용할까요?",
        "사용확인",
        "저장"
      );
      if (!ok) return;
      try {
        const data = await apiSend("/api/me/supplier/active", "PUT", { id: sid });
        userCache = data.user;
        editingSupplierId = sid;
        const row = userCache.suppliers.find(function (x) {
          return x.id === sid;
        });
        if (row) fillForm(row);
        document.getElementById("supplier-form-heading").textContent = "공급자 편집 (번호 " + sid + ")";
        document.getElementById("save-msg").textContent = "발행에 사용할 공급자로 저장되었습니다.";
        renderList();
        updateActiveLabel();
      } catch (e) {
        await alertModal(e.message || "오류");
      }
    });
    bDel.addEventListener("click", async function () {
      const sid = Number(this.getAttribute("data-sid"));
      const ok = await confirmModal("이 공급자를 삭제할까요?", "삭제", "삭제");
      if (!ok) return;
      try {
        const data = await apiSend(sApi(sid), "DELETE");
        userCache = data.user;
        if (editingSupplierId === sid) {
          editingSupplierId = userCache.activeSupplierId;
          const row = userCache.suppliers.find(function (x) {
            return x.id === editingSupplierId;
          });
          if (row) fillForm(row);
        }
        renderList();
        updateActiveLabel();
      } catch (e) {
        await alertModal(e.message || "오류");
      }
    });
    tbody.appendChild(tr);
  }
  if (!rows.length) {
    tbody.innerHTML = "<tr><td colspan='5'>공급자가 없습니다. 「공급자 추가」를 눌러 주세요.</td></tr>";
  }
  renderSupplierPager(rows.length, totalPages);
  updateActiveLabel();
}

function updateActiveLabel() {
  const el = document.getElementById("supplier-active-label");
  if (!el || !userCache) return;
  const a = userCache.suppliers.find(function (s) {
    return s.id === userCache.activeSupplierId;
  });
  el.textContent = a
    ? "발행 공급자: " + (a.corpName || a.bizNo || "번호 " + a.id)
    : "";
}

(async function () {
  await loadSiteConfig();
  const ok = await checkLogin();
  if (!ok) return;

  initContactExtensionSelect();
  bindContactPhoneAutoFormat();
  bindSupplierBizNoAutoFormat();

  // 대표 전화번호 자동 포맷
  (function () {
    var el = document.getElementById("phone");
    if (!el) return;
    el.addEventListener("keydown", function (e) {
      if (e.ctrlKey || e.metaKey || e.altKey) return;
      if (!e.key || e.key.length !== 1) return;
      if (/[0-9]/.test(e.key)) return;
      e.preventDefault();
    });
    el.addEventListener("input", function () {
      var f = formatContactPhoneDisplay(el.value);
      if (f !== el.value) el.value = f;
    });
  }());

  document.getElementById("contactEmailDomainSelect").addEventListener("change", syncContactEmailDomainUi);
  syncContactEmailDomainUi();

  // 사업자등록증 파일 선택 후 업로드
  document.getElementById("supplier-cert-file").addEventListener("change", async function () {
    var file = this.files && this.files[0];
    if (!file || !editingSupplierId) return;
    try {
      var fd = new FormData();
      fd.append("file", file);
      var certUrl = BASE + "/api/me/suppliers/" + editingSupplierId + "/biz-cert";
      var r = await fetch(certUrl, { method: "POST", body: fd, credentials: "same-origin" });
      var data = await r.json().catch(function () { return {}; });
      if (!r.ok) throw new Error(data.error || "업로드 실패");
      userCache = data.user;
      var row = userCache.suppliers.find(function (x) { return x.id === editingSupplierId; });
      if (row) renderSupplierCertControls(row);
    } catch (e) { await alertModal(e.message || "업로드 실패"); }
    finally { this.value = ""; }
  });

  document.getElementById("logout-btn").addEventListener("click", async function (e) {
    e.preventDefault();
    const sure = await confirmModal("정말 로그아웃 하시겠습니까?", "로그아웃", "로그아웃");
    if (!sure) return;
    await apiSend("/api/logout", "POST");
    window.location.href = BASE + "/login.html";
  });

  const me = await apiGet("/api/me");
  userCache = me.user;
  if (userCache.suppliers && userCache.suppliers.length) {
    editingSupplierId = userCache.activeSupplierId;
    const row = userCache.suppliers.find(function (x) {
      return x.id === editingSupplierId;
    });
    if (row) fillForm(row);
    document.getElementById("supplier-form-heading").textContent =
      "공급자 편집 (번호 " + editingSupplierId + ")";
  } else {
    renderSupplierCertControls(null);
  }
  renderList();


  document.getElementById("supplier-page-prev").addEventListener("click", function () {
    supplierCurrentPage -= 1;
    renderList();
  });
  document.getElementById("supplier-page-next").addEventListener("click", function () {
    supplierCurrentPage += 1;
    renderList();
  });

  document.getElementById("btn-add-supplier").addEventListener("click", async function () {
    try {
      const data = await apiSend(sApi(null), "POST", {});
      userCache = data.user;
      editingSupplierId = data.supplier.id;
      fillForm(data.supplier);
      document.getElementById("supplier-form-heading").textContent =
        "공급자 편집 (번호 " + editingSupplierId + ")";
      document.getElementById("save-msg").textContent = "새 공급자가 추가되었습니다. 내용을 입력한 뒤 저장하세요.";
      renderList();
    } catch (e) {
      await alertModal(e.message || "오류");
    }
  });

  document.getElementById("supplier-form").addEventListener("submit", async function (e) {
    e.preventDefault();
    const msg = document.getElementById("save-msg");
    msg.textContent = "";
    if (!editingSupplierId) {
      msg.textContent = "목록에서 편집할 공급자를 선택하거나 추가하세요.";
      return;
    }
    try {
      const data = await apiSend(sApi(editingSupplierId), "PUT", getFormBody());
      userCache = data.user;
      msg.textContent = "";
      showToast("저장되었습니다.");
      renderList();
    } catch (ex) {
      msg.textContent = ex.message;
    }
  });
})();
