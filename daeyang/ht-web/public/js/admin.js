loadSiteConfig();

let currentUserId = null;
let allUsers = [];
let selectedUser = null;

document.getElementById("logout-btn").addEventListener("click", async function (e) {
  e.preventDefault();
  await apiSend("/api/logout", "POST");
  window.location.href = BASE + "/login.html";
});

// ── 탭 전환 ───────────────────────────────────────────────────────────────────

document.querySelectorAll(".admin-tab").forEach(function (btn) {
  btn.addEventListener("click", function () {
    document.querySelectorAll(".admin-tab").forEach(function (b) { b.classList.remove("active"); });
    this.classList.add("active");
    const tab = this.dataset.tab;
    document.getElementById("tab-list").style.display = tab === "list" ? "" : "none";
    document.getElementById("tab-add").style.display  = tab === "add"  ? "" : "none";
    if (tab === "add") document.getElementById("add-name").focus();
  });
});

// ── 사용자 추가 폼 ────────────────────────────────────────────────────────────

document.getElementById("admin-add-form").addEventListener("submit", async function (e) {
  e.preventDefault();
  const errEl = document.getElementById("add-error");
  errEl.style.display = "none";

  const name     = document.getElementById("add-name").value.trim();
  const username = document.getElementById("add-username").value.trim();
  const password = document.getElementById("add-password").value;
  const confirm  = document.getElementById("add-confirm").value;
  const role     = document.getElementById("add-role").value;

  try {
    await apiSend("/api/admin/users", "POST", { name, username, password, confirm, role });
    await loadUsers();
    this.reset();
    // 목록 탭으로 이동
    document.querySelectorAll(".admin-tab").forEach(function (b) { b.classList.remove("active"); });
    document.querySelector(".admin-tab[data-tab='list']").classList.add("active");
    document.getElementById("tab-list").style.display = "";
    document.getElementById("tab-add").style.display  = "none";
    showToast("사용자가 추가되었습니다.");
  } catch (ex) {
    errEl.textContent = ex.message;
    errEl.style.display = "block";
  }
});

async function init() {
  let me;
  try {
    const data = await apiGet("/api/me");
    me = data.user;
  } catch (e) {
    window.location.href = BASE + "/login.html";
    return;
  }
  if (me.role !== "admin") {
    await alertModal("관리자 권한이 필요합니다.", "접근 불가");
    window.location.href = BASE + "/index.html";
    return;
  }
  currentUserId = me.id;
  await loadUsers();
}

async function loadUsers() {
  try {
    const data = await apiGet("/api/admin/users");
    allUsers = data.users || [];
    renderTable(allUsers);
  } catch (e) {
    await alertModal("사용자 목록을 불러오지 못했습니다: " + e.message, "오류");
  }
}

function renderTable(users) {
  const tbody = document.getElementById("admin-user-tbody");
  document.getElementById("admin-user-count").textContent = "총 " + users.length + "명";

  if (!users.length) {
    tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; color: var(--text-muted);">사용자가 없습니다.</td></tr>';
    return;
  }

  tbody.innerHTML = users.map(function (u) {
    const isSelf = u.id === currentUserId;
    const roleLabel = u.role === "admin"
      ? '<span class="admin-badge">ADMIN</span>'
      : u.role === "pending"
        ? '<span class="pending-badge">대기</span>'
        : '<span class="user-badge">USER</span>';
    const lockLabel = u.isLocked ? ' <span class="locked-badge">잠금</span>' : "";
    const selfMark = isSelf ? ' <span style="font-size:0.75rem;color:var(--text-muted);">(나)</span>' : "";

    return (
      '<tr class="admin-user-row' + (u.isLocked ? " locked-row" : "") + '" data-id="' + u.id + '" style="cursor:pointer;">' +
      "<td>" + escapeHtml(u.username) + selfMark + lockLabel + "</td>" +
      "<td>" + escapeHtml(u.name || "—") + "</td>" +
      "<td style='text-align:center;'>" + roleLabel + "</td>" +
      "<td>" + formatDateTime(u.createdAt) + "</td>" +
      "<td>" + formatDateTime(u.updatedAt) + "</td>" +
      "</tr>"
    );
  }).join("");

  tbody.querySelectorAll(".admin-user-row").forEach(function (tr) {
    tr.addEventListener("click", function () {
      const uid = Number(this.dataset.id);
      const u = allUsers.find(function (x) { return x.id === uid; });
      if (u) openUserModal(u);
    });
  });
}

function formatDateTime(iso) {
  if (!iso) return "—";
  try {
    const d = new Date(iso);
    const pad = function (n) { return String(n).padStart(2, "0"); };
    return d.getFullYear() + "-" + pad(d.getMonth() + 1) + "-" + pad(d.getDate()) +
           " " + pad(d.getHours()) + ":" + pad(d.getMinutes());
  } catch (e) {
    return iso || "—";
  }
}

// ── 사용자 상세/편집 모달 ─────────────────────────────────────────────────────

function openUserModal(u) {
  selectedUser = u;
  const isSelf = u.id === currentUserId;

  document.getElementById("um-id").textContent = u.id;
  document.getElementById("um-username").textContent = u.username;
  document.getElementById("um-name-input").value = u.name || "";
  document.getElementById("um-role-select").value = u.role || "user";
  document.getElementById("um-lock-select").value = u.isLocked ? "locked" : "normal";
  document.getElementById("um-created").textContent = formatDateTime(u.createdAt);
  document.getElementById("um-updated").textContent = formatDateTime(u.updatedAt);
  document.getElementById("um-pw-input").value = "";
  document.getElementById("um-pw-input2").value = "";
  document.getElementById("um-save-error").style.display = "none";

  const delBtn     = document.getElementById("um-del-btn");
  const selfNoteEl = document.getElementById("um-self-note");
  const roleSelect = document.getElementById("um-role-select");
  const lockSelect = document.getElementById("um-lock-select");

  if (isSelf) {
    delBtn.style.display = "none";
    selfNoteEl.style.display = "block";
    roleSelect.disabled = true;
    lockSelect.disabled = true;
  } else {
    delBtn.style.display = "";
    selfNoteEl.style.display = "none";
    roleSelect.disabled = false;
    lockSelect.disabled = false;
  }

  document.getElementById("user-modal").style.display = "flex";
  document.getElementById("um-name-input").focus();
}

function closeUserModal() {
  document.getElementById("user-modal").style.display = "none";
  selectedUser = null;
}

document.getElementById("user-modal-close").addEventListener("click", closeUserModal);
document.getElementById("user-modal").addEventListener("click", function (e) {
  if (e.target === this) closeUserModal();
});

// 저장 버튼
document.getElementById("um-save-btn").addEventListener("click", async function () {
  if (!selectedUser) return;
  const errEl = document.getElementById("um-save-error");
  errEl.style.display = "none";

  const name     = document.getElementById("um-name-input").value.trim();
  const newPw    = document.getElementById("um-pw-input").value;
  const confirmPw = document.getElementById("um-pw-input2").value;

  if (newPw) {
    if (newPw.length < 4) {
      errEl.textContent = "비밀번호는 4자 이상이어야 합니다.";
      errEl.style.display = "block";
      return;
    }
    if (newPw !== confirmPw) {
      errEl.textContent = "비밀번호가 일치하지 않습니다.";
      errEl.style.display = "block";
      return;
    }
  }

  const isSelf = selectedUser.id === currentUserId;
  const body = { name };
  if (newPw) body.newPassword = newPw;
  if (!isSelf) {
    body.role = document.getElementById("um-role-select").value;
    body.isLocked = document.getElementById("um-lock-select").value === "locked";
  }

  try {
    await apiSend("/api/admin/users/" + selectedUser.id, "PUT", body);
    closeUserModal();
    await loadUsers();
    showToast("저장되었습니다.");
  } catch (e) {
    errEl.textContent = e.message;
    errEl.style.display = "block";
  }
});

// 삭제 버튼
document.getElementById("um-del-btn").addEventListener("click", async function () {
  if (!selectedUser) return;
  const u = selectedUser;
  closeUserModal();
  const ok = await confirmModal(
    "'" + u.username + "' 사용자를 삭제하시겠습니까?\n삭제하면 해당 사용자의 모든 데이터가 함께 삭제됩니다.",
    "사용자 삭제",
    "삭제"
  );
  if (!ok) return;
  try {
    await apiSend("/api/admin/users/" + u.id, "DELETE");
    await loadUsers();
  } catch (e) {
    await alertModal("삭제 실패: " + e.message, "오류");
  }
});

document.addEventListener("keydown", function (e) {
  if (e.key === "Escape" && document.getElementById("user-modal").style.display !== "none") {
    closeUserModal();
  }
});

// ── 검색 ─────────────────────────────────────────────────────────────────────

document.getElementById("user-search").addEventListener("input", function () {
  const q = this.value.toLowerCase().replace(/\s/g, "");
  renderTable(q ? allUsers.filter(function (u) {
    return u.username.toLowerCase().includes(q) || (u.name || "").toLowerCase().includes(q);
  }) : allUsers);
});

// ── 데이터 관리 버튼 ──────────────────────────────────────────────────────────

document.getElementById("um-data-btn").addEventListener("click", function () {
  if (!selectedUser) return;
  const u = selectedUser;
  closeUserModal();
  openDataModal(u);
});

// ── 데이터 관리 모달 ──────────────────────────────────────────────────────────

let dataModalUserId = null;
const _adminStore = {};

document.getElementById("data-modal-close").addEventListener("click", function () {
  document.getElementById("data-modal").style.display = "none";
});
document.getElementById("data-modal").addEventListener("click", function (e) {
  if (e.target === this) document.getElementById("data-modal").style.display = "none";
});

document.querySelectorAll("[data-dtab]").forEach(function (btn) {
  btn.addEventListener("click", function () {
    document.querySelectorAll("[data-dtab]").forEach(function (b) { b.classList.remove("active"); });
    this.classList.add("active");
    const tab = this.dataset.dtab;
    document.getElementById("dtab-suppliers").style.display = tab === "suppliers" ? "" : "none";
    document.getElementById("dtab-recipients").style.display = tab === "recipients" ? "" : "none";
  });
});

function openDataModal(u) {
  dataModalUserId = u.id;
  document.getElementById("data-modal-title").textContent =
    escapeHtml(u.username) + (u.name ? " (" + escapeHtml(u.name) + ")" : "") + " — 데이터 관리";

  document.querySelectorAll("[data-dtab]").forEach(function (b) { b.classList.remove("active"); });
  document.querySelector("[data-dtab='suppliers']").classList.add("active");
  document.getElementById("dtab-suppliers").style.display = "";
  document.getElementById("dtab-recipients").style.display = "none";
  document.getElementById("dtab-suppliers").innerHTML = '<p style="text-align:center;color:var(--text-muted);padding:20px;">불러오는 중…</p>';
  document.getElementById("dtab-recipients").innerHTML = '<p style="text-align:center;color:var(--text-muted);padding:20px;">불러오는 중…</p>';

  document.getElementById("data-modal").style.display = "flex";
  loadAdminSuppliers();
  loadAdminRecipients();
}

// ── 공급자 ────────────────────────────────────────────────────────────────────

async function loadAdminSuppliers() {
  try {
    const data = await apiGet("/api/admin/users/" + dataModalUserId + "/suppliers");
    renderAdminSuppliers(data.suppliers || []);
  } catch (e) {
    document.getElementById("dtab-suppliers").innerHTML = '<p class="error-msg" style="padding:12px;">불러오기 실패: ' + escapeHtml(e.message) + '</p>';
  }
}

function renderAdminSuppliers(suppliers) {
  const el = document.getElementById("dtab-suppliers");
  if (!suppliers.length) {
    el.innerHTML = '<p style="text-align:center;color:var(--text-muted);padding:24px;">등록된 공급자가 없습니다.</p>';
    return;
  }
  suppliers.forEach(function (s) { _adminStore["sup-" + s.id] = s; });

  let html = '<div class="table-scroll"><table class="data-table"><thead><tr>' +
    '<th>법인명</th><th>사업자번호</th><th>대표자</th><th>이메일</th><th>전화</th>' +
    '<th style="width:120px;text-align:center;">조작</th></tr></thead><tbody>';
  suppliers.forEach(function (s) {
    html += '<tr>' +
      '<td>' + escapeHtml(s.corp_name || "—") + '</td>' +
      '<td>' + escapeHtml(s.biz_no || "—") + '</td>' +
      '<td>' + escapeHtml(s.ceo_name || "—") + '</td>' +
      '<td>' + escapeHtml(s.email || "—") + '</td>' +
      '<td>' + escapeHtml(s.phone || "—") + '</td>' +
      '<td style="text-align:center;">' +
      '<button class="btn btn-sm btn-secondary" onclick="openEditSupplier(' + s.id + ')">수정</button> ' +
      '<button class="btn btn-sm btn-danger" onclick="deleteAdminSupplier(' + s.id + ')">삭제</button>' +
      '</td></tr>';
  });
  html += '</tbody></table></div>';
  el.innerHTML = html;
}

async function deleteAdminSupplier(supId) {
  const s = _adminStore["sup-" + supId];
  const name = s ? (s.corp_name || "이 공급자") : "이 공급자";
  const ok = await confirmModal("'" + escapeHtml(name) + "' 공급자를 삭제하시겠습니까?", "공급자 삭제", "삭제");
  if (!ok) return;
  try {
    await apiSend("/api/admin/users/" + dataModalUserId + "/suppliers/" + supId, "DELETE");
    loadAdminSuppliers();
  } catch (e) {
    await alertModal("삭제 실패: " + e.message, "오류");
  }
}

// ── 공급받는자 ────────────────────────────────────────────────────────────────

async function loadAdminRecipients() {
  try {
    const data = await apiGet("/api/admin/users/" + dataModalUserId + "/recipients");
    renderAdminRecipients(data.recipients || []);
  } catch (e) {
    document.getElementById("dtab-recipients").innerHTML = '<p class="error-msg" style="padding:12px;">불러오기 실패: ' + escapeHtml(e.message) + '</p>';
  }
}

function renderAdminRecipients(recipients) {
  const el = document.getElementById("dtab-recipients");
  if (!recipients.length) {
    el.innerHTML = '<p style="text-align:center;color:var(--text-muted);padding:24px;">등록된 공급받는자가 없습니다.</p>';
    return;
  }
  recipients.forEach(function (r) { _adminStore["rec-" + r.id] = r; });

  let html = '<div class="table-scroll"><table class="data-table"><thead><tr>' +
    '<th>이름</th><th>구분</th><th>사업자번호</th><th>연락처</th>' +
    '<th style="width:160px;text-align:center;">조작</th></tr></thead><tbody>';
  recipients.forEach(function (r) {
    const kindLabel = r.kind === "business" ? "법인" : "개인";
    html += '<tr>' +
      '<td>' + escapeHtml(r.display_name || "—") + '</td>' +
      '<td>' + kindLabel + '</td>' +
      '<td>' + escapeHtml(r.biz_no || "—") + '</td>' +
      '<td>' + escapeHtml(r.contact_phone || "—") + '</td>' +
      '<td style="text-align:center;">' +
      '<button class="btn btn-sm btn-secondary" onclick="openEditRecipient(' + r.id + ')">수정</button> ' +
      '<button class="btn btn-sm" style="background:var(--primary,#2563eb);color:#fff;" onclick="toggleItems(' + r.id + ')">품목</button> ' +
      '<button class="btn btn-sm btn-danger" onclick="deleteAdminRecipient(' + r.id + ')">삭제</button>' +
      '</td></tr>' +
      '<tr id="items-row-' + r.id + '" style="display:none;"><td colspan="5" style="padding:0;">' +
      renderItemsTable(r) + '</td></tr>';
  });
  html += '</tbody></table></div>';
  el.innerHTML = html;
}

function renderItemsTable(r) {
  if (!r.items || !r.items.length) {
    return '<p style="text-align:center;color:var(--text-muted);padding:10px;">품목이 없습니다.</p>';
  }
  r.items.forEach(function (it) { _adminStore["item-" + it.id] = { ...it, recId: r.id }; });
  let html = '<table class="data-table" style="margin:0;background:var(--bg-muted,#f5f7fa);"><thead><tr>' +
    '<th>사업장명</th><th>품목명</th><th style="text-align:right;">공급가액</th><th style="text-align:right;">세액</th><th>비고</th>' +
    '<th style="width:120px;text-align:center;">조작</th></tr></thead><tbody>';
  r.items.forEach(function (it) {
    html += '<tr>' +
      '<td>' + escapeHtml(it.plant_name || "—") + '</td>' +
      '<td>' + escapeHtml(it.fixed_item_name || "—") + '</td>' +
      '<td style="text-align:right;">' + Number(it.monthly_supply).toLocaleString() + '</td>' +
      '<td style="text-align:right;">' + Number(it.monthly_tax).toLocaleString() + '</td>' +
      '<td>' + escapeHtml(it.note || "—") + '</td>' +
      '<td style="text-align:center;">' +
      '<button class="btn btn-sm btn-secondary" onclick="openEditItem(' + it.id + ')">수정</button> ' +
      '<button class="btn btn-sm btn-danger" onclick="deleteAdminItem(' + it.id + ')">삭제</button>' +
      '</td></tr>';
  });
  html += '</tbody></table>';
  return html;
}

function toggleItems(recId) {
  const row = document.getElementById("items-row-" + recId);
  if (row) row.style.display = row.style.display === "none" ? "" : "none";
}

async function deleteAdminRecipient(recId) {
  const r = _adminStore["rec-" + recId];
  const name = r ? (r.display_name || "이 공급받는자") : "이 공급받는자";
  const ok = await confirmModal("'" + escapeHtml(name) + "' 공급받는자를 삭제하시겠습니까?\n품목도 함께 삭제됩니다.", "공급받는자 삭제", "삭제");
  if (!ok) return;
  try {
    await apiSend("/api/admin/users/" + dataModalUserId + "/recipients/" + recId, "DELETE");
    loadAdminRecipients();
  } catch (e) {
    await alertModal("삭제 실패: " + e.message, "오류");
  }
}

async function deleteAdminItem(itemId) {
  const it = _adminStore["item-" + itemId];
  if (!it) return;
  const name = it.fixed_item_name || "이 품목";
  const ok = await confirmModal("'" + escapeHtml(name) + "' 품목을 삭제하시겠습니까?", "품목 삭제", "삭제");
  if (!ok) return;
  try {
    await apiSend("/api/admin/users/" + dataModalUserId + "/recipients/" + it.recId + "/items/" + itemId, "DELETE");
    loadAdminRecipients();
  } catch (e) {
    await alertModal("삭제 실패: " + e.message, "오류");
  }
}

// ── 수정 모달 (공용) ──────────────────────────────────────────────────────────

let _editSaveCallback = null;

document.getElementById("edit-modal-cancel").addEventListener("click", function () {
  document.getElementById("edit-modal").style.display = "none";
});
document.getElementById("edit-modal").addEventListener("click", function (e) {
  if (e.target === this) document.getElementById("edit-modal").style.display = "none";
});
document.getElementById("edit-modal-save").addEventListener("click", async function () {
  if (!_editSaveCallback) return;
  document.getElementById("edit-modal-error").style.display = "none";
  try {
    await _editSaveCallback();
    document.getElementById("edit-modal").style.display = "none";
  } catch (e) {
    const el = document.getElementById("edit-modal-error");
    el.textContent = e.message;
    el.style.display = "block";
  }
});

function showEditModal(title, fields, saveCallback) {
  _editSaveCallback = saveCallback;
  document.getElementById("edit-modal-title").textContent = title;
  document.getElementById("edit-modal-error").style.display = "none";
  let html = "";
  fields.forEach(function (f) {
    html += '<div class="field" style="margin-bottom:10px;">' +
      '<label>' + escapeHtml(f.label) + '</label>' +
      '<input id="ef-' + f.key + '" type="' + (f.type || "text") + '" value="' + escapeHtml(String(f.value != null ? f.value : "")) + '" placeholder="' + escapeHtml(f.placeholder || "") + '" />' +
      '</div>';
  });
  document.getElementById("edit-modal-fields").innerHTML = html;
  document.getElementById("edit-modal").style.display = "flex";
  const first = document.querySelector("#edit-modal-fields input");
  if (first) first.focus();
}

function ef(key) {
  const el = document.getElementById("ef-" + key);
  return el ? el.value : "";
}

function openEditSupplier(supId) {
  const s = _adminStore["sup-" + supId];
  if (!s) return;
  showEditModal("공급자 수정 — " + escapeHtml(s.corp_name || ""), [
    { key: "corpName",          label: "법인명",    value: s.corp_name },
    { key: "bizNo",             label: "사업자번호", value: s.biz_no },
    { key: "ceoName",           label: "대표자",    value: s.ceo_name },
    { key: "address",           label: "주소",      value: s.address },
    { key: "bizType",           label: "업태",      value: s.biz_type },
    { key: "bizItem",           label: "종목",      value: s.biz_item },
    { key: "email",             label: "이메일",    value: s.email },
    { key: "phone",             label: "전화",      value: s.phone },
    { key: "contactDept",       label: "담당부서",  value: s.contact_dept },
    { key: "contactName",       label: "담당자",    value: s.contact_name },
    { key: "contactPhone",      label: "담당자 전화", value: s.contact_phone },
    { key: "contactExtension",  label: "내선",      value: s.contact_extension },
    { key: "contactEmail",      label: "담당자 이메일", value: s.contact_email },
  ], async function () {
    await apiSend("/api/admin/users/" + dataModalUserId + "/suppliers/" + supId, "PUT", {
      corpName: ef("corpName"), bizNo: ef("bizNo"), ceoName: ef("ceoName"),
      address: ef("address"), bizType: ef("bizType"), bizItem: ef("bizItem"),
      email: ef("email"), phone: ef("phone"), contactDept: ef("contactDept"),
      contactName: ef("contactName"), contactPhone: ef("contactPhone"),
      contactExtension: ef("contactExtension"), contactEmail: ef("contactEmail"),
    });
    loadAdminSuppliers();
  });
}

function openEditRecipient(recId) {
  const r = _adminStore["rec-" + recId];
  if (!r) return;
  showEditModal("공급받는자 수정 — " + escapeHtml(r.display_name || ""), [
    { key: "displayName",   label: "이름",      value: r.display_name },
    { key: "bizNo",         label: "사업자번호", value: r.biz_no },
    { key: "ceoName",       label: "대표자",    value: r.ceo_name },
    { key: "address",       label: "주소",      value: r.address },
    { key: "bizType",       label: "업태",      value: r.biz_type },
    { key: "bizItem",       label: "종목",      value: r.biz_item },
    { key: "email",         label: "이메일",    value: r.email },
    { key: "contactName",   label: "담당자",    value: r.contact_name },
    { key: "contactPhone",  label: "연락처",    value: r.contact_phone },
    { key: "contactEmail",  label: "담당자 이메일", value: r.contact_email },
    { key: "internalMemo",  label: "내부 메모",  value: r.internal_memo },
  ], async function () {
    await apiSend("/api/admin/users/" + dataModalUserId + "/recipients/" + recId, "PUT", {
      displayName: ef("displayName"), bizNo: ef("bizNo"), ceoName: ef("ceoName"),
      address: ef("address"), bizType: ef("bizType"), bizItem: ef("bizItem"),
      email: ef("email"), contactName: ef("contactName"), contactPhone: ef("contactPhone"),
      contactEmail: ef("contactEmail"), internalMemo: ef("internalMemo"),
    });
    loadAdminRecipients();
  });
}

function openEditItem(itemId) {
  const it = _adminStore["item-" + itemId];
  if (!it) return;
  showEditModal("품목 수정 — " + escapeHtml(it.fixed_item_name || ""), [
    { key: "plantName",      label: "사업장명", value: it.plant_name },
    { key: "fixedItemName",  label: "품목명",   value: it.fixed_item_name },
    { key: "monthlySupply",  label: "공급가액", value: it.monthly_supply, type: "number" },
    { key: "note",           label: "비고",     value: it.note },
  ], async function () {
    await apiSend("/api/admin/users/" + dataModalUserId + "/recipients/" + it.recId + "/items/" + itemId, "PUT", {
      plantName: ef("plantName"), fixedItemName: ef("fixedItemName"),
      monthlySupply: Number(ef("monthlySupply")) || 0, note: ef("note"),
    });
    loadAdminRecipients();
  });
}

init();
