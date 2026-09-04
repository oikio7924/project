loadSiteConfig();

document.getElementById("register-form").addEventListener("submit", async function (e) {
  e.preventDefault();
  const errEl = document.getElementById("register-error");
  errEl.style.display = "none";

  const name     = document.getElementById("name").value.trim();
  const username = document.getElementById("username").value.trim();
  const password = document.getElementById("password").value;
  const confirm  = document.getElementById("confirm").value;

  try {
    await apiSend("/api/register", "POST", { name, username, password, confirm });
    window.location.href = BASE + "/pending.html";
  } catch (ex) {
    errEl.textContent = ex.message;
    errEl.style.display = "block";
  }
});
