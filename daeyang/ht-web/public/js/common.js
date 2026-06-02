/**
 * 공통: API 호출, 로그인 확인
 * fetch는 브라우저 기본 기능입니다.
 */
var BASE = '/htweb';

async function apiGet(url) {
  const fullUrl = url.startsWith('/') ? BASE + url : url;
  const r = await fetch(fullUrl, { credentials: "same-origin" });
  const data = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(data.error || "요청 실패");
  return data;
}

async function apiSend(url, method, body) {
  const fullUrl = url.startsWith('/') ? BASE + url : url;
  const opt = {
    method,
    credentials: "same-origin",
    headers: { "Content-Type": "application/json" },
  };
  if (body !== undefined) opt.body = JSON.stringify(body);
  const r = await fetch(fullUrl, opt);
  const data = await r.json().catch(() => ({}));
  if (!r.ok) throw new Error(data.error || "요청 실패");
  return data;
}

async function loadSiteConfig() {
  try {
    const c = await apiGet("/api/config");
    const el = document.getElementById("site-domain-text");
    if (el && c.siteDomain) el.textContent = c.siteDomain;
  } catch (e) {
    /* 무시 */
  }
}

async function checkLogin() {
  try {
    const data = await apiGet("/api/me");
    if (data.user && data.user.role === "pending") {
      window.location.href = BASE + "/pending.html";
      return false;
    }
    injectAdminNav(data.user);
    return true;
  } catch (e) {
    window.location.href = BASE + "/login.html";
    return false;
  }
}

function injectAdminNav(user) {
  if (!user || user.role !== "admin") return;
  const nav = document.getElementById("main-nav");
  if (!nav) return;
  if (nav.querySelector('a[href="' + BASE + '/admin.html"]')) return;
  const logoutBtn = nav.querySelector("#logout-btn");
  const adminLink = document.createElement("a");
  adminLink.href = BASE + "/admin.html";
  adminLink.className = "sidebar-link";
  if (window.location.pathname.endsWith("/admin.html")) adminLink.classList.add("active");
  adminLink.title = "사용자관리";
  adminLink.innerHTML =
    '<span class="sidebar-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg></span>' +
    '<span class="sidebar-label">사용자관리</span>';
  nav.insertBefore(adminLink, logoutBtn);
}

/**
 * @param {string} message
 * @param {string} [title]
 * @param {string} [confirmLabel]
 * @returns {Promise<boolean>}
 */
function escapeHtml(s) {
  return String(s)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

function formatBizNoDisplay(value) {
  const digits = String(value || "").replace(/\D/g, "").slice(0, 10);
  if (digits.length <= 3) return digits;
  if (digits.length <= 5) return digits.slice(0, 3) + "-" + digits.slice(3);
  return digits.slice(0, 3) + "-" + digits.slice(3, 5) + "-" + digits.slice(5);
}

function formatResidentNoDisplay(value) {
  const digits = String(value || "").replace(/\D/g, "").slice(0, 13);
  if (digits.length <= 6) return digits;
  return digits.slice(0, 6) + "-" + digits.slice(6);
}

function formatRecipientRegNoByKind(kind, value) {
  if (kind === "business") return formatBizNoDisplay(value);
  if (kind === "individual") return formatResidentNoDisplay(value);
  return String(value || "");
}

function baseModal(message, title, options) {
  const opts = options || {};
  const ttl = title || "확인";
  const okText = opts.confirmLabel || "확인";
  const cancelText = opts.cancelLabel || "취소";
  const showCancel = opts.showCancel !== false;
  const dismissOnOverlay = opts.dismissOnOverlay !== false;
  const dismissOnEscape = opts.dismissOnEscape !== false;
  const actionHtml = showCancel
    ? '<button type="button" class="btn btn-secondary modal-btn-cancel">' +
      escapeHtml(cancelText) +
      "</button>"
    : "";
  return new Promise(function (resolve) {
    const overlay = document.createElement("div");
    overlay.className = "modal-overlay";
    overlay.setAttribute("role", "dialog");
    overlay.setAttribute("aria-modal", "true");
    overlay.setAttribute("aria-labelledby", "modal-confirm-title");
    overlay.innerHTML =
      '<div class="modal-box">' +
      '<h3 id="modal-confirm-title" class="modal-title">' +
      escapeHtml(ttl) +
      "</h3>" +
      '<p class="modal-message">' +
      escapeHtml(message).replace(/\n/g, "<br>") +
      "</p>" +
      '<div class="modal-actions">' +
      actionHtml +
      '<button type="button" class="btn btn-primary modal-btn-ok">' +
      escapeHtml(okText) +
      "</button>" +
      "</div></div>";

    function close(v) {
      document.removeEventListener("keydown", onKey);
      if (overlay.parentNode) overlay.parentNode.removeChild(overlay);
      resolve(v);
    }

    function onKey(ev) {
      if (dismissOnEscape && ev.key === "Escape") close(false);
    }

    overlay.addEventListener("click", function (e) {
      if (dismissOnOverlay && e.target === overlay) close(false);
    });
    const cancelBtn = overlay.querySelector(".modal-btn-cancel");
    if (cancelBtn) {
      cancelBtn.addEventListener("click", function () {
        close(false);
      });
    }
    overlay.querySelector(".modal-btn-ok").addEventListener("click", function () {
      close(true);
    });
    document.addEventListener("keydown", onKey);
    document.body.appendChild(overlay);
    overlay.querySelector(".modal-btn-ok").focus();
  });
}

function confirmModal(message, title, confirmLabel) {
  return baseModal(message, title, {
    confirmLabel: confirmLabel || "확인",
    cancelLabel: "취소",
    showCancel: true,
    dismissOnOverlay: true,
    dismissOnEscape: true,
  });
}

function alertModal(message, title, buttonLabel) {
  return baseModal(message, title || "안내", {
    confirmLabel: buttonLabel || "확인",
    showCancel: false,
    dismissOnOverlay: true,
    dismissOnEscape: true,
  });
}

function showToast(message) {
  var el = document.getElementById("toast-notification");
  if (!el) {
    el = document.createElement("div");
    el.id = "toast-notification";
    el.className = "toast-notification";
    el.innerHTML = '<span class="toast-icon"></span><span class="toast-msg"></span>';
    document.body.appendChild(el);
  }
  el.querySelector(".toast-msg").textContent = message || "저장되었습니다.";
  if (el._hideTimer) clearTimeout(el._hideTimer);
  el.classList.add("toast-show");
  el._hideTimer = setTimeout(function () {
    el.classList.remove("toast-show");
  }, 2500);
}

function formatMoney(n) {
  const x = Number(n) || 0;
  return x.toLocaleString("ko-KR");
}

function kindLabel(kind, bizSubtype) {
  if (kind === "foreign") return "외국인";
  if (kind === "individual") return "개인";
  if (kind === "business") {
    if (bizSubtype === "corp") return "사업자(법인)";
    if (bizSubtype === "nonprofit") return "사업자(비영리)";
    return "사업자(개인)";
  }
  return kind;
}

/* 사이드바 토글 */
(function () {
  function initSidebar() {
    var sidebar = document.getElementById("sidebar");
    var toggle = document.getElementById("sidebar-toggle");
    if (!sidebar || !toggle) return;
    var collapsed = localStorage.getItem("sidebar-collapsed") === "1";
    if (collapsed) {
      sidebar.classList.add("collapsed");
      document.body.classList.add("sidebar-collapsed");
    }
    toggle.addEventListener("click", function () {
      var isCollapsed = sidebar.classList.toggle("collapsed");
      document.body.classList.toggle("sidebar-collapsed", isCollapsed);
      localStorage.setItem("sidebar-collapsed", isCollapsed ? "1" : "0");
    });
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initSidebar);
  } else {
    initSidebar();
  }
}());

/** 검색용: 공백 제거 소문자 한 덩어리 */
function recipientSearchHaystack(r) {
  if (!r) return "";
  const items = Array.isArray(r.items) ? r.items : [];
  const plantParts = [];
  for (let i = 0; i < items.length; i++) {
    plantParts.push(items[i].plantName, items[i].fixedItemName);
  }
  const parts = [
    r.displayName,
    r.bizNo,
    r.ceoName,
    r.address,
    r.email,
    r.contactPhone,
    r.bizType,
    r.bizItem,
    r.internalMemo,
    String(r.id),
    kindLabel(r.kind, r.bizSubtype),
    plantParts.join(" "),
  ];
  return parts
    .filter(Boolean)
    .join(" ")
    .toLowerCase()
    .replace(/\s/g, "");
}

document.addEventListener("DOMContentLoaded", function () {
  var toggle = document.getElementById("btn-quicklinks-toggle");
  if (toggle) {
    toggle.addEventListener("click", function () {
      var group = toggle.closest(".sidebar-menu-group");
      if (group) group.classList.toggle("open");
    });
  }
});

