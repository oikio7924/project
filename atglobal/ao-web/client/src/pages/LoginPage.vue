<script setup>
import { reactive, ref } from 'vue';
import { useRouter } from 'vue-router';
import { api, request } from '../api';
import { useAuthStore } from '../stores/auth';

const router = useRouter();
const auth = useAuthStore();
const mode = ref('login');
const message = ref('');
const error = ref('');

const loginForm = reactive({ username: '', password: '' });
const registerForm = reactive({
  name: '',
  username: '',
  password: '',
  passwordConfirm: '',
  phone: '',
  company_name: '',
  role: 'dealer'
});

function goByRole(user) {
  router.push(user.role === 'admin' ? '/admin' : user.role === 'distributor' ? '/distributor' : '/dealer');
}

async function login() {
  error.value = '';
  try {
    const user = await auth.login(loginForm);
    goByRole(user);
  } catch (err) {
    error.value = err.message;
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
</script>

<template>
  <main class="auth-page">
    <section class="auth-card">
      <div class="auth-brand">
        <strong>AT GLOBAL</strong>
        <span>Powerbank Distribution Management</span>
      </div>

      <form v-if="mode === 'login'" @submit.prevent="login">
        <label>아이디<input v-model="loginForm.username" autocomplete="username" /></label>
        <label>비밀번호<input v-model="loginForm.password" type="password" autocomplete="current-password" /></label>
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
          <label>비밀번호<input v-model="registerForm.password" type="password" /></label>
          <label>비밀번호 확인<input v-model="registerForm.passwordConfirm" type="password" /></label>
        </div>
        <label>연락처<input v-model="registerForm.phone" /></label>
        <label>회사명<input v-model="registerForm.company_name" /></label>
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
