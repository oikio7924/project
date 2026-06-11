<script setup>
import { onMounted, reactive, ref, watch } from 'vue';
import { useRouter } from 'vue-router';
import { api, request } from '../api';
import { useAuthStore } from '../stores/auth';
import PasswordInput from '../components/PasswordInput.vue';

const router = useRouter();
const auth = useAuthStore();
const mode = ref('login');
const message = ref('');
const error = ref('');
const autoLogging = ref(false);

const rememberId = ref(false);
const autoLogin = ref(false);

const loginForm = reactive({ username: '', password: '' });
const registerForm = reactive({
  name: '', username: '', password: '', passwordConfirm: '',
  phone: '', company_name: '', address: '', role: 'dealer'
});

// 자동로그인 체크 시 아이디 저장도 자동 on
watch(autoLogin, (val) => { if (val) rememberId.value = true; });

function goByRole(user) {
  router.push(user.role === 'admin' ? '/admin' : user.role === 'distributor' ? '/distributor' : '/dealer');
}

async function login() {
  error.value = '';
  try {
    const user = await auth.login(loginForm);

    if (rememberId.value) {
      localStorage.setItem('atg_saved_id', loginForm.username);
    } else {
      localStorage.removeItem('atg_saved_id');
    }

    if (autoLogin.value) {
      localStorage.setItem('atg_auto_login', JSON.stringify({
        username: loginForm.username,
        password: loginForm.password
      }));
    } else {
      localStorage.removeItem('atg_auto_login');
    }

    goByRole(user);
  } catch (err) {
    error.value = err.message;
    autoLogging.value = false;
  }
}

async function register() {
  error.value = '';
  message.value = '';
  if (registerForm.password !== registerForm.passwordConfirm) {
    error.value = '비밀번호 확인이 일치하지 않습니다.';
    return;
  }
  try {
    await request(api.post('/auth/register', registerForm));
    message.value = '가입 신청이 접수되었습니다. 관리자 승인 후 로그인할 수 있습니다.';
    mode.value = 'login';
  } catch (err) {
    error.value = err.message;
  }
}

onMounted(async () => {
  // 아이디 저장 복원
  const savedId = localStorage.getItem('atg_saved_id');
  if (savedId) {
    loginForm.username = savedId;
    rememberId.value = true;
  }

  // 자동로그인
  const saved = localStorage.getItem('atg_auto_login');
  if (saved) {
    try {
      const creds = JSON.parse(saved);
      loginForm.username = creds.username;
      loginForm.password = creds.password;
      rememberId.value = true;
      autoLogin.value = true;
      autoLogging.value = true;
      await login();
    } catch {
      localStorage.removeItem('atg_auto_login');
      autoLogging.value = false;
    }
  }
});
</script>

<template>
  <main class="auth-page">
    <section class="auth-card">
      <div class="auth-brand">
        <strong>AT GLOBAL</strong>
        <span>Powerbank Distribution Management</span>
      </div>

      <!-- 자동로그인 처리 중 -->
      <div v-if="autoLogging" class="auto-login-msg">
        <div class="auto-login-spinner"></div>
        자동 로그인 중...
      </div>

      <form v-else-if="mode === 'login'" @submit.prevent="login">
        <label>아이디<input v-model="loginForm.username" autocomplete="username" /></label>
        <label>비밀번호<PasswordInput v-model="loginForm.password" autocomplete="current-password" /></label>

        <div class="login-options">
          <label class="check-label">
            <input type="checkbox" v-model="rememberId" :disabled="autoLogin" />
            아이디 저장
          </label>
          <label class="check-label">
            <input type="checkbox" v-model="autoLogin" />
            자동로그인
          </label>
        </div>

        <button class="primary" type="submit">로그인</button>
        <div class="auth-links">
          <button type="button" @click="message = '아이디/비밀번호는 관리자에게 문의해주세요.'">아이디 찾기</button>
          <button type="button" @click="message = '아이디/비밀번호는 관리자에게 문의해주세요.'">비밀번호 찾기</button>
        </div>
        <button class="secondary full" type="button" @click="mode = 'register'">회원가입 신청</button>
      </form>

      <form v-else @submit.prevent="register">
        <div class="two-col">
          <label>이름<input v-model="registerForm.name" /></label>
          <label>아이디<input v-model="registerForm.username" /></label>
        </div>
        <div class="two-col">
          <label>비밀번호<PasswordInput v-model="registerForm.password" autocomplete="new-password" /></label>
          <label>비밀번호 확인<PasswordInput v-model="registerForm.passwordConfirm" autocomplete="new-password" /></label>
        </div>
        <label>연락처<input v-model="registerForm.phone" /></label>
        <label>회사명<input v-model="registerForm.company_name" /></label>
        <label>주소<input v-model="registerForm.address" placeholder="사업장 주소" /></label>
        <div class="segmented">
          <button type="button" :class="{ active: registerForm.role === 'distributor' }" @click="registerForm.role = 'distributor'">총판</button>
          <button type="button" :class="{ active: registerForm.role === 'dealer' }" @click="registerForm.role = 'dealer'">대리점</button>
        </div>
        <button class="primary" type="submit">가입 신청</button>
        <button class="secondary full" type="button" @click="mode = 'login'">로그인으로 돌아가기</button>
      </form>

      <p v-if="message" class="message">{{ message }}</p>
      <p v-if="error" class="error">{{ error }}</p>
    </section>
  </main>
</template>
