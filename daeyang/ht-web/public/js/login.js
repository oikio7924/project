loadSiteConfig();

const REMEMBER_USERNAME_KEY = "rememberedUsername";
const usernameEl = document.getElementById("username");
const rememberEl = document.getElementById("remember-username");

try {
  const remembered = localStorage.getItem(REMEMBER_USERNAME_KEY) || "";
  if (remembered) {
    usernameEl.value = remembered;
    rememberEl.checked = true;
  }
} catch (e) {
  /* 저장소 접근 불가 환경은 무시 */
}

document.getElementById("login-form").addEventListener("submit", async function (e) {
  e.preventDefault();
  const err = document.getElementById("login-error");
  err.style.display = "none";
  const username = usernameEl.value.trim();
  const password = document.getElementById("password").value;
  try {
    await apiSend("/api/login", "POST", { username, password });
    try {
      if (rememberEl.checked && username) {
        localStorage.setItem(REMEMBER_USERNAME_KEY, username);
      } else {
        localStorage.removeItem(REMEMBER_USERNAME_KEY);
      }
    } catch (e) {
      /* 저장소 접근 불가 환경은 무시 */
    }
    window.location.href = BASE + "/index.html";
  } catch (ex) {
    if (ex.message === "pending") {
      window.location.href = BASE + "/pending.html";
    } else {
      err.textContent = ex.message;
      err.style.display = "block";
    }
  }
});
