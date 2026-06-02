function activeSupplierName(user) {
  const list = Array.isArray(user.suppliers) ? user.suppliers : [];
  const active = list.find(function (s) {
    return s.id === user.activeSupplierId;
  });
  if (!active) return "";
  return active.corpName || active.bizNo || "번호 " + active.id;
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

  const me = await apiGet("/api/me");
  const user = me.user || {};
  document.getElementById("profile-username").value = user.username || "";
  document.getElementById("profile-active-supplier").value = activeSupplierName(user);
  document.getElementById("profile-notice-text").value = user.noticeText || "";

  document.getElementById("password-form").addEventListener("submit", async function (e) {
    e.preventDefault();
    const msg = document.getElementById("pw-msg");
    msg.textContent = "";
    const currentPassword = String(document.getElementById("pw-current").value || "");
    const newPassword = String(document.getElementById("pw-new").value || "");
    const confirmPassword = String(document.getElementById("pw-new-confirm").value || "");
    if (!currentPassword || !newPassword || !confirmPassword) {
      msg.textContent = "모든 칸을 입력하세요.";
      return;
    }
    if (newPassword !== confirmPassword) {
      msg.textContent = "새 비밀번호 확인이 일치하지 않습니다.";
      return;
    }
    const okChange = await confirmModal("비밀번호를 변경할까요?", "비밀번호 변경", "저장");
    if (!okChange) return;
    try {
      await apiSend("/api/me/password", "PUT", {
        currentPassword,
        newPassword,
      });
      document.getElementById("pw-current").value = "";
      document.getElementById("pw-new").value = "";
      document.getElementById("pw-new-confirm").value = "";
      msg.textContent = "";
      showToast("비밀번호를 변경했습니다.");
    } catch (err) {
      msg.textContent = err.message || "변경 실패";
    }
  });

  document.getElementById("profile-save-notice").addEventListener("click", async function () {
    const msg = document.getElementById("profile-notice-msg");
    const v = String(document.getElementById("profile-notice-text").value || "").slice(0, 1000);
    msg.textContent = "";
    try {
      await apiSend("/api/me/notice", "PUT", { noticeText: v });
      msg.textContent = "";
      showToast("공지 내용을 저장했습니다.");
    } catch (err) {
      msg.textContent = err.message || "저장 실패";
    }
  });
})();
