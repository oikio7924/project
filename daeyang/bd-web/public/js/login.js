const LS_KEY_USERNAME    = 'bdweb_savedUsername';
const LS_KEY_PASSWORD    = 'bdweb_savedPassword';
const LS_KEY_REMEMBER_ID = 'bdweb_rememberId';
const LS_KEY_REMEMBER_PW = 'bdweb_rememberPw';
const LS_KEY_AUTO_LOGIN  = 'bdweb_autoLogin';

const usernameEl   = document.getElementById('username');
const passwordEl   = document.getElementById('password');
const rememberIdEl = document.getElementById('remember-id');
const rememberPwEl = document.getElementById('remember-pw');
const autoLoginEl  = document.getElementById('auto-login');
const errEl        = document.getElementById('login-error');

function loadSaved() {
  try {
    const savedUsername = localStorage.getItem(LS_KEY_USERNAME) || '';
    const savedPassword  = localStorage.getItem(LS_KEY_PASSWORD)  || '';
    const rememberId     = localStorage.getItem(LS_KEY_REMEMBER_ID) === '1';
    const rememberPw     = localStorage.getItem(LS_KEY_REMEMBER_PW) === '1';
    const autoLogin       = localStorage.getItem(LS_KEY_AUTO_LOGIN)  === '1';

    if (rememberId && savedUsername) {
      usernameEl.value = savedUsername;
      rememberIdEl.checked = true;
    }
    if (rememberPw && savedPassword) {
      passwordEl.value = savedPassword;
      rememberPwEl.checked = true;
    }
    if (autoLogin) autoLoginEl.checked = true;

    return { savedUsername, savedPassword, rememberId, rememberPw, autoLogin };
  } catch (e) {
    return { savedUsername: '', savedPassword: '', rememberId: false, rememberPw: false, autoLogin: false };
  }
}

// 자동 로그인 체크 시 아이디/비밀번호 저장도 같이 켜짐 (둘 다 있어야 자동 로그인 가능하므로)
autoLoginEl.addEventListener('change', () => {
  if (autoLoginEl.checked) {
    rememberIdEl.checked = true;
    rememberPwEl.checked = true;
  }
});

async function doLogin(username, password) {
  await apiSend('api/login', 'POST', { username, password });

  try {
    if (rememberIdEl.checked && username) {
      localStorage.setItem(LS_KEY_USERNAME, username);
      localStorage.setItem(LS_KEY_REMEMBER_ID, '1');
    } else {
      localStorage.removeItem(LS_KEY_USERNAME);
      localStorage.removeItem(LS_KEY_REMEMBER_ID);
    }
    if (rememberPwEl.checked && password) {
      localStorage.setItem(LS_KEY_PASSWORD, password);
      localStorage.setItem(LS_KEY_REMEMBER_PW, '1');
    } else {
      localStorage.removeItem(LS_KEY_PASSWORD);
      localStorage.removeItem(LS_KEY_REMEMBER_PW);
    }
    if (autoLoginEl.checked) {
      localStorage.setItem(LS_KEY_AUTO_LOGIN, '1');
    } else {
      localStorage.removeItem(LS_KEY_AUTO_LOGIN);
    }
  } catch (e) { /* 저장소 접근 불가 환경은 무시 */ }

  window.location.href = 'index.html';
}

document.getElementById('login-form').addEventListener('submit', async (e) => {
  e.preventDefault();
  errEl.style.display = 'none';
  try {
    await doLogin(usernameEl.value.trim(), passwordEl.value);
  } catch (ex) {
    errEl.textContent = ex.message || '로그인에 실패했습니다.';
    errEl.style.display = 'block';
  }
});

(async function initAutoLogin() {
  const { savedUsername, savedPassword, autoLogin } = loadSaved();
  if (autoLogin && savedUsername && savedPassword) {
    try {
      await doLogin(savedUsername, savedPassword);
    } catch (ex) {
      // 자동 로그인 실패 시(비밀번호 변경, 계정 잠금 등) 자동 로그인만 끄고
      // 저장된 아이디/비밀번호는 남겨서 사용자가 수동으로 다시 시도할 수 있게 함
      try { localStorage.removeItem(LS_KEY_AUTO_LOGIN); } catch (e) {}
      autoLoginEl.checked = false;
      errEl.textContent = ex.message || '자동 로그인에 실패했습니다. 다시 로그인해주세요.';
      errEl.style.display = 'block';
    }
  }
})();
