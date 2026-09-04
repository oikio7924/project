<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue';
import { useRouter } from 'vue-router';
import { api, request } from '../api';
import { useAuthStore } from '../stores/auth';
import PasswordInput from '../components/PasswordInput.vue';
import AlertModal from '../components/AlertModal.vue';
import loginLogo from '../assets/login_logo.png';

const router = useRouter();
const auth = useAuthStore();
const mode = ref('login');
const error = ref('');
const autoLogging = ref(false);
const modal = reactive({ show: false, title: '', message: '' });

function showModal(title, message) {
  modal.title = title;
  modal.message = message;
  modal.show = true;
}

const rememberId = ref(false);
const autoLogin = ref(false);

const PHONE_PREFIXES = [
  '010', '011', '016', '017', '018', '019',
  '02',
  '031', '032', '033',
  '041', '042', '043', '044',
  '051', '052', '053', '054', '055',
  '061', '062', '063', '064',
  '070',
];

const loginForm = reactive({ username: '', password: '' });
const registerForm = reactive({
  password: '', passwordConfirm: '',
  company_name: '',
  companyPhonePrefix: '010', companyPhoneSuffix: '',
  fax: '',
  business_number: '', business_type: '', business_item: '',
  address: '', addressDetail: '',
  name: '',
  phonePrefix: '010', phoneSuffix: ''
});

const fe = reactive({
  password: '', passwordConfirm: '',
  company_name: '', name: '', phoneSuffix: '',
  business_type: '', business_item: '', address: '', companyPhoneSuffix: '', business_number: ''
});

const bizCheck = reactive({ loading: false, status: '', message: '' });
const verified = computed(() => bizCheck.status === 'valid');

// ── 직원 가입 (제조사/총판 소속 선택, 사업자등록번호 진위확인 없이 간소화된 정보만 받음) ──
const registerType = ref('business'); // 'business'(지점 가입) | 'staff'(직원 가입)
const staffCompanies = ref([]); // [{ type:'admin'|'distributor', id, label }]
const staffForm = reactive({
  affiliationKey: '',
  username: '', password: '', passwordConfirm: '',
  name: '', phonePrefix: '010', phoneSuffix: '',
  manager_department: '', manager_position: ''
});
const staffFe = reactive({ affiliation: '', username: '', password: '', passwordConfirm: '', name: '', phoneSuffix: '' });

function clearStaffFe(field) { staffFe[field] = ''; }

// 회원가입 화면에 진입할 때마다 이전에 입력했던 값이 남아있지 않도록 전부 초기화
function enterRegister() {
  Object.assign(registerForm, {
    password: '', passwordConfirm: '',
    company_name: '',
    companyPhonePrefix: '010', companyPhoneSuffix: '',
    fax: '',
    business_number: '', business_type: '', business_item: '',
    address: '', addressDetail: '',
    name: '',
    phonePrefix: '010', phoneSuffix: ''
  });
  Object.assign(fe, {
    password: '', passwordConfirm: '',
    company_name: '', name: '', phoneSuffix: '',
    business_type: '', business_item: '', address: '', companyPhoneSuffix: '', business_number: ''
  });
  Object.assign(bizCheck, { loading: false, status: '', message: '' });
  registerType.value = 'business';
  Object.assign(staffForm, {
    affiliationKey: '',
    username: '', password: '', passwordConfirm: '',
    name: '', phonePrefix: '010', phoneSuffix: '',
    manager_department: '', manager_position: ''
  });
  Object.assign(staffFe, { affiliation: '', username: '', password: '', passwordConfirm: '', name: '', phoneSuffix: '' });
  removeRegisterLogo();
  mode.value = 'register';
}

async function loadStaffCompanies() {
  try {
    const { companies } = await request(api.get('/auth/staff-companies'));
    staffCompanies.value = companies;
  } catch {
    staffCompanies.value = [];
  }
}

function onStaffSuffixInput(event) {
  staffForm.phoneSuffix = formatSuffix(event.target.value);
  staffFe.phoneSuffix = '';
}

function validateStaffRegister() {
  let ok = true;

  if (!staffForm.affiliationKey) {
    staffFe.affiliation = '소속을 선택해주세요.'; ok = false;
  } else staffFe.affiliation = '';

  if (!staffForm.username.trim() || staffForm.username.trim().length < 3) {
    staffFe.username = '아이디를 3자 이상 입력해주세요.'; ok = false;
  } else staffFe.username = '';

  const pw = staffForm.password;
  if (!pw || pw.length < 6 || pw.length > 20 || !/[a-zA-Z]/.test(pw) || !/[0-9]/.test(pw)) {
    staffFe.password = '영문과 숫자를 포함하여 6~20자리로 입력해주세요.'; ok = false;
  } else staffFe.password = '';

  if (!staffFe.password && staffForm.password !== staffForm.passwordConfirm) {
    staffFe.passwordConfirm = '비밀번호가 일치하지 않습니다.'; ok = false;
  } else if (!staffForm.passwordConfirm) {
    staffFe.passwordConfirm = '비밀번호 확인을 입력해주세요.'; ok = false;
  } else staffFe.passwordConfirm = '';

  if (!staffForm.name.trim()) {
    staffFe.name = '이름을 입력해주세요.'; ok = false;
  } else staffFe.name = '';

  if (!staffForm.phoneSuffix) {
    staffFe.phoneSuffix = '연락처를 입력해주세요.'; ok = false;
  } else staffFe.phoneSuffix = '';

  return ok;
}

async function registerStaff() {
  error.value = '';
  if (!validateStaffRegister()) return;
  const [affiliationType, affiliationId] = staffForm.affiliationKey.startsWith('distributor:')
    ? ['distributor', staffForm.affiliationKey.slice('distributor:'.length)]
    : ['admin', null];
  const payload = {
    affiliation_type: affiliationType,
    affiliation_id: affiliationId,
    username: staffForm.username.trim(),
    password: staffForm.password,
    name: staffForm.name,
    phone: `${staffForm.phonePrefix}-${staffForm.phoneSuffix}`,
    manager_department: staffForm.manager_department,
    manager_position: staffForm.manager_position
  };
  try {
    await request(api.post('/auth/register-staff', payload));
    Object.assign(staffForm, {
      affiliationKey: '',
      username: '', password: '', passwordConfirm: '',
      name: '', phonePrefix: '010', phoneSuffix: '',
      manager_department: '', manager_position: ''
    });
    Object.assign(staffFe, { affiliation: '', username: '', password: '', passwordConfirm: '', name: '', phoneSuffix: '' });
    registerType.value = 'business';
    mode.value = 'login';
    showModal('가입 신청 완료', '가입 신청이 접수되었습니다.\n관리자 승인 후 로그인하실 수 있습니다.');
  } catch (err) {
    error.value = err.message;
  }
}

function clearFe(field) { fe[field] = ''; }

function validateRegister() {
  let ok = true;

  if (registerForm.business_number.replace(/\D/g, '').length !== 10) {
    fe.business_number = '사업자등록번호를 입력해주세요.'; ok = false;
  } else fe.business_number = '';

  const pw = registerForm.password;
  if (!pw || pw.length < 6 || pw.length > 20 || !/[a-zA-Z]/.test(pw) || !/[0-9]/.test(pw)) {
    fe.password = '영문과 숫자를 포함하여 6~20자리로 입력해주세요.'; ok = false;
  } else fe.password = '';

  if (!fe.password && registerForm.password !== registerForm.passwordConfirm) {
    fe.passwordConfirm = '비밀번호가 일치하지 않습니다.'; ok = false;
  } else if (!registerForm.passwordConfirm) {
    fe.passwordConfirm = '비밀번호 확인을 입력해주세요.'; ok = false;
  } else fe.passwordConfirm = '';

  if (!registerForm.company_name.trim()) {
    fe.company_name = '회사명을 입력해주세요.'; ok = false;
  } else fe.company_name = '';

  if (!registerForm.business_type.trim()) {
    fe.business_type = '업태를 입력해주세요.'; ok = false;
  } else fe.business_type = '';

  if (!registerForm.business_item.trim()) {
    fe.business_item = '업종을 입력해주세요.'; ok = false;
  } else fe.business_item = '';

  if (!registerForm.companyPhoneSuffix) {
    fe.companyPhoneSuffix = '연락처를 입력해주세요.'; ok = false;
  } else fe.companyPhoneSuffix = '';

  if (!registerForm.address.trim()) {
    fe.address = '주소를 입력해주세요.'; ok = false;
  } else fe.address = '';

  if (bizCheck.status !== 'valid') {
    ok = false;
    if (!bizCheck.message) bizCheck.message = '사업자등록번호 조회를 먼저 완료해주세요.';
    bizCheck.status = bizCheck.status || 'error';
  }

  if (!registerForm.name.trim()) {
    fe.name = '이름을 입력해주세요.'; ok = false;
  } else fe.name = '';

  if (!registerForm.phoneSuffix) {
    fe.phoneSuffix = '연락처를 입력해주세요.'; ok = false;
  } else fe.phoneSuffix = '';

  return ok;
}

function formatSuffix(val) {
  const d = val.replace(/\D/g, '').slice(0, 8);
  if (d.length <= 3) return d;
  if (d.length <= 7) return `${d.slice(0, 3)}-${d.slice(3)}`;
  return `${d.slice(0, 4)}-${d.slice(4)}`;
}
function onSuffixInput(field, event) {
  registerForm[field] = formatSuffix(event.target.value);
  if (field === 'phoneSuffix') fe.phoneSuffix = '';
  if (field === 'companyPhoneSuffix') fe.companyPhoneSuffix = '';
}

function formatFax(val) {
  const d = val.replace(/\D/g, '').slice(0, 12);
  if (d.length <= 3) return d;
  if (d.length <= 6) return `${d.slice(0, 3)}-${d.slice(3)}`;
  if (d.length <= 10) return `${d.slice(0, 3)}-${d.slice(3, 6)}-${d.slice(6)}`;
  if (d.length === 11) return `${d.slice(0, 3)}-${d.slice(3, 7)}-${d.slice(7)}`;
  return `${d.slice(0, 4)}-${d.slice(4, 8)}-${d.slice(8)}`;
}
function onFaxInput(event) {
  registerForm.fax = formatFax(event.target.value);
}

function resetBizCheck() {
  bizCheck.status = '';
  bizCheck.message = '';
}

// ── 회사 로고 (선택) — 가입 신청과 함께 바로 등록해서 승인 즉시 적용되게 ──
const registerLogoInput = ref(null);
const registerLogoFile = ref(null);
const registerLogoPreview = ref(null);
const LOGO_ACCEPT_TYPES = ['image/png', 'image/jpeg', 'image/webp', 'image/svg+xml'];

function onRegisterLogoChange(event) {
  const file = event.target.files[0];
  event.target.value = '';
  if (!file) return;
  if (!LOGO_ACCEPT_TYPES.includes(file.type)) {
    error.value = 'PNG, JPG, WEBP, SVG 형식의 이미지만 등록할 수 있습니다.';
    return;
  }
  if (file.size > 2 * 1024 * 1024) {
    error.value = '로고 이미지는 최대 2MB까지 등록할 수 있습니다.';
    return;
  }
  error.value = '';
  registerLogoFile.value = file;
  registerLogoPreview.value = URL.createObjectURL(file);
}

function removeRegisterLogo() {
  registerLogoFile.value = null;
  registerLogoPreview.value = null;
}

function onBusinessNumberInput(event) {
  const d = event.target.value.replace(/\D/g, '').slice(0, 10);
  if (d.length <= 3) registerForm.business_number = d;
  else if (d.length <= 5) registerForm.business_number = `${d.slice(0, 3)}-${d.slice(3)}`;
  else registerForm.business_number = `${d.slice(0, 3)}-${d.slice(3, 5)}-${d.slice(5)}`;
  fe.business_number = '';
  resetBizCheck();
}

async function checkBusinessNumber() {
  const bNo = registerForm.business_number.replace(/\D/g, '');
  if (bNo.length !== 10) {
    bizCheck.status = 'error';
    bizCheck.message = '사업자등록번호 10자리를 정확히 입력해주세요.';
    return;
  }
  bizCheck.loading = true;
  bizCheck.status = '';
  bizCheck.message = '';
  try {
    const result = await request(api.post('/business/status', {
      business_number: bNo
    }), { silent: true });
    if (result.found) {
      bizCheck.status = 'valid';
      bizCheck.message = '정상 등록된 사업자입니다.';
    } else {
      bizCheck.status = 'invalid';
      bizCheck.message = result.message || '등록된 정보를 찾을 수 없습니다.';
    }
  } catch (err) {
    bizCheck.status = 'error';
    bizCheck.message = err.message;
  } finally {
    bizCheck.loading = false;
  }
}

function openAddressSearch() {
  if (!window.daum?.Postcode) {
    alert('주소 검색 서비스를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
    return;
  }
  new window.daum.Postcode({
    oncomplete(data) {
      registerForm.address = data.roadAddress || data.jibunAddress;
      clearFe('address');
    }
  }).open();
}

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
    autoLogging.value = false;
    if (err.message === '관리자 승인 후 로그인할 수 있습니다.') {
      showModal('승인 대기 중', '관리자 승인 후 로그인하실 수 있습니다.\n승인 여부는 담당자에게 문의해주세요.');
    } else {
      error.value = err.message;
    }
  }
}

async function register() {
  error.value = '';
  if (!validateRegister()) return;
  const fields = {
    password: registerForm.password,
    company_name: registerForm.company_name,
    company_phone: registerForm.companyPhoneSuffix
      ? `${registerForm.companyPhonePrefix}-${registerForm.companyPhoneSuffix}` : '',
    fax: registerForm.fax,
    business_number: registerForm.business_number,
    business_type: registerForm.business_type,
    business_item: registerForm.business_item,
    address: registerForm.address,
    address_detail: registerForm.addressDetail,
    name: registerForm.name,
    phone: registerForm.phoneSuffix
      ? `${registerForm.phonePrefix}-${registerForm.phoneSuffix}` : '',
  };
  const payload = new FormData();
  for (const [key, value] of Object.entries(fields)) payload.append(key, value);
  if (registerLogoFile.value) payload.append('logo', registerLogoFile.value);
  try {
    await request(api.post('/auth/register', payload));
    Object.assign(registerForm, {
      password: '', passwordConfirm: '',
      company_name: '', companyPhonePrefix: '010', companyPhoneSuffix: '', fax: '',
      business_number: '', business_type: '', business_item: '',
      address: '', addressDetail: '',
      name: '', phonePrefix: '010', phoneSuffix: ''
    });
    Object.assign(fe, {
      password: '', passwordConfirm: '', company_name: '', name: '', phoneSuffix: '',
      business_type: '', business_item: '', address: '', companyPhoneSuffix: '', business_number: ''
    });
    resetBizCheck();
    removeRegisterLogo();
    mode.value = 'login';
    showModal('가입 신청 완료', '가입 신청이 접수되었습니다.\n관리자 승인 후 로그인하실 수 있습니다.');
  } catch (err) {
    error.value = err.message;
  }
}

onMounted(async () => {
  loadStaffCompanies();

  if (!document.getElementById('kakao-postcode-script')) {
    const script = document.createElement('script');
    script.id = 'kakao-postcode-script';
    script.src = 'https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js';
    document.head.appendChild(script);
  }

  const savedId = localStorage.getItem('atg_saved_id');
  if (savedId) {
    loginForm.username = savedId;
    rememberId.value = true;
  }

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
    <section class="auth-card" :class="{ 'register-wide': mode === 'register' }">
      <div class="auth-brand">
        <img :src="loginLogo" alt="AT GLOBAL" class="auth-logo" />
        <span>Powerbank Distribution Management</span>
        <p v-if="mode === 'register'" class="required-note">* 필수입력</p>
      </div>

      <div v-if="autoLogging" class="auto-login-msg">
        <div class="auto-login-spinner"></div>
        자동 로그인 중...
      </div>

      <form v-else-if="mode === 'login'" @submit.prevent="login">
        <label>아이디<input v-model="loginForm.username" autocomplete="username" placeholder="사업자등록번호" /></label>
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
        <p class="auth-notice">아이디·비밀번호 분실 시 관리자에게 문의 바랍니다.</p>
        <button class="secondary full" type="button" @click="enterRegister">회원가입 신청</button>
        <p v-if="error" class="error">{{ error }}</p>
      </form>

      <form v-else @submit.prevent="registerType === 'staff' ? registerStaff() : register()" class="register-form">
        <div class="register-type-toggle">
          <button type="button" :class="{ active: registerType === 'business' }" @click="registerType = 'business'">지점 가입</button>
          <button type="button" :class="{ active: registerType === 'staff' }" @click="registerType = 'staff'">직원 가입</button>
        </div>

        <div class="register-columns" v-if="registerType === 'business'">
          <div class="register-col register-col-wide">
            <div class="register-col-title">사업자 정보</div>

            <div class="register-subgrid">
              <label><span class="label-text">사업자번호<span class="required-mark">*</span></span>
                <div class="bizno-input-row">
                  <input :value="registerForm.business_number" @input="onBusinessNumberInput($event)"
                    :disabled="verified"
                    :class="{ 'input-invalid': fe.business_number }"
                    placeholder="숫자만 입력 (로그인 아이디로 사용됩니다)" inputmode="numeric" maxlength="12" />
                  <button v-if="verified" type="button" class="btn-bizno-reset" title="다시 입력" @click="resetBizCheck">↺</button>
                </div>
                <span v-if="fe.business_number" class="field-error">{{ fe.business_number }}</span>
              </label>

              <label>
                <div class="address-search-row">
                  <button type="button" class="btn-verify full" :class="{ 'btn-verify-done': verified }"
                    :disabled="bizCheck.loading || verified" @click="checkBusinessNumber">
                    {{ verified ? '조회 완료' : bizCheck.loading ? '조회 중...' : '사업자등록번호 조회' }}
                  </button>
                </div>
                <span v-if="bizCheck.message" class="pw-feedback" :class="bizCheck.status === 'valid' ? 'match' : 'mismatch'">{{ bizCheck.message }}</span>
              </label>

              <label><span class="label-text">업태<span class="required-mark">*</span></span>
                <input v-model="registerForm.business_type" placeholder="예: 도소매업"
                  :disabled="!verified"
                  :class="{ 'input-invalid': fe.business_type }"
                  @input="clearFe('business_type')" />
                <span v-if="fe.business_type" class="field-error">{{ fe.business_type }}</span>
              </label>

              <label><span class="label-text">업종<span class="required-mark">*</span></span>
                <input v-model="registerForm.business_item" placeholder="예: 전자상거래업"
                  :disabled="!verified"
                  :class="{ 'input-invalid': fe.business_item }"
                  @input="clearFe('business_item')" />
                <span v-if="fe.business_item" class="field-error">{{ fe.business_item }}</span>
              </label>

              <label><span class="label-text">상호<span class="required-mark">*</span></span>
                <input v-model="registerForm.company_name"
                  :disabled="!verified"
                  :class="{ 'input-invalid': fe.company_name }"
                  @input="clearFe('company_name')" />
                <span v-if="fe.company_name" class="field-error">{{ fe.company_name }}</span>
              </label>

              <label><span class="label-text">비밀번호<span class="required-mark">*</span></span>
                <PasswordInput v-model="registerForm.password" autocomplete="new-password"
                  placeholder="영문+숫자 포함 6~20자리"
                  :disabled="!verified"
                  :invalid="!!fe.password"
                  @update:modelValue="clearFe('password')" />
                <span v-if="fe.password" class="field-error">{{ fe.password }}</span>
              </label>

              <label><span class="label-text">비밀번호 확인<span class="required-mark">*</span></span>
                <PasswordInput v-model="registerForm.passwordConfirm" autocomplete="new-password"
                  placeholder="비밀번호를 다시 입력해주세요"
                  :disabled="!verified"
                  :invalid="!!fe.passwordConfirm"
                  @update:modelValue="clearFe('passwordConfirm')" />
                <span v-if="fe.passwordConfirm" class="field-error">{{ fe.passwordConfirm }}</span>
              </label>

              <label><span class="label-text">연락처<span class="required-mark">*</span></span>
                <div class="phone-input-row">
                  <select v-model="registerForm.companyPhonePrefix" class="phone-prefix" :disabled="!verified">
                    <option v-for="p in PHONE_PREFIXES" :key="p" :value="p">{{ p }}</option>
                  </select>
                  <span class="phone-sep">-</span>
                  <input
                    :value="registerForm.companyPhoneSuffix"
                    @input="onSuffixInput('companyPhoneSuffix', $event)"
                    placeholder="숫자만 입력"
                    inputmode="numeric"
                    maxlength="9"
                    class="phone-suffix"
                    :disabled="!verified"
                    :class="{ 'input-invalid': fe.companyPhoneSuffix }"
                  />
                </div>
                <span v-if="fe.companyPhoneSuffix" class="field-error">{{ fe.companyPhoneSuffix }}</span>
              </label>

              <label>FAX<input :value="registerForm.fax" @input="onFaxInput" placeholder="숫자만 입력 (선택)" :disabled="!verified" maxlength="14" /></label>
            </div>

            <label><span class="label-text">주소<span class="required-mark">*</span></span>
              <div class="address-search-row">
                <input :value="registerForm.address" readonly placeholder="주소 검색을 이용해주세요" class="address-base" />
                <button type="button" class="btn-address-search" :disabled="!verified" @click="openAddressSearch">주소 검색</button>
              </div>
              <input v-model="registerForm.addressDetail" placeholder="상세 주소 입력" :disabled="!verified"
                :class="{ 'input-invalid': fe.address }" />
              <span v-if="fe.address" class="field-error">{{ fe.address }}</span>
            </label>
          </div>

          <div class="register-col">
            <div class="register-col-title">담당자 정보</div>

            <label><span class="label-text">이름<span class="required-mark">*</span></span>
              <input v-model="registerForm.name"
                :class="{ 'input-invalid': fe.name }"
                @input="clearFe('name')" />
              <span v-if="fe.name" class="field-error">{{ fe.name }}</span>
            </label>

            <label><span class="label-text">연락처<span class="required-mark">*</span></span>
              <div class="phone-input-row">
                <select v-model="registerForm.phonePrefix" class="phone-prefix">
                  <option v-for="p in PHONE_PREFIXES" :key="p" :value="p">{{ p }}</option>
                </select>
                <span class="phone-sep">-</span>
                <input
                  :value="registerForm.phoneSuffix"
                  @input="onSuffixInput('phoneSuffix', $event)"
                  placeholder="숫자만 입력"
                  inputmode="numeric"
                  maxlength="9"
                  class="phone-suffix"
                  :class="{ 'input-invalid': fe.phoneSuffix }"
                />
              </div>
              <span v-if="fe.phoneSuffix" class="field-error">{{ fe.phoneSuffix }}</span>
            </label>

            <div class="register-col-title" style="margin-top:10px">회사 로고 (선택)</div>
            <p class="text-muted" style="font-size:11px;line-height:1.5;margin:0">
              등록하면 헤더·발주서에 표시되고, 미등록시 공란으로 나옵니다.<br>
              권장 300×100px · PNG, JPG, WEBP, SVG · 최대 2MB
            </p>
            <div class="logo-upload-row">
              <div class="logo-preview">
                <img v-if="registerLogoPreview" :src="registerLogoPreview" alt="로고 미리보기" />
                <span v-else class="text-muted">미리보기</span>
              </div>
              <div style="display:flex;flex-direction:column;gap:6px">
                <input ref="registerLogoInput" type="file" accept="image/png,image/jpeg,image/webp,image/svg+xml" style="display:none" @change="onRegisterLogoChange" />
                <button type="button" class="secondary" @click="registerLogoInput.click()">이미지 선택</button>
                <button v-if="registerLogoPreview" type="button" class="btn-danger" @click="removeRegisterLogo">제거</button>
              </div>
            </div>
          </div>
        </div>

        <div class="register-columns register-columns-2" v-else>
          <div class="register-col register-col-wide">
            <div class="register-col-title">직원 정보</div>

            <div class="register-subgrid">
              <label><span class="label-text">소속<span class="required-mark">*</span></span>
                <select v-model="staffForm.affiliationKey"
                  :class="{ 'input-invalid': staffFe.affiliation }"
                  @change="staffFe.affiliation = ''">
                  <option value="" disabled>소속을 선택해주세요</option>
                  <option v-for="c in staffCompanies" :key="c.type + (c.id ?? '')"
                    :value="c.type === 'distributor' ? `distributor:${c.id}` : 'admin'">
                    {{ c.label }}
                  </option>
                </select>
                <span v-if="staffFe.affiliation" class="field-error">{{ staffFe.affiliation }}</span>
              </label>

              <label><span class="label-text">아이디<span class="required-mark">*</span></span>
                <input v-model.trim="staffForm.username"
                  :class="{ 'input-invalid': staffFe.username }"
                  placeholder="로그인에 사용할 아이디"
                  @input="clearStaffFe('username')" />
                <span v-if="staffFe.username" class="field-error">{{ staffFe.username }}</span>
              </label>

              <label><span class="label-text">이름<span class="required-mark">*</span></span>
                <input v-model="staffForm.name"
                  :class="{ 'input-invalid': staffFe.name }"
                  @input="clearStaffFe('name')" />
                <span v-if="staffFe.name" class="field-error">{{ staffFe.name }}</span>
              </label>

              <label><span class="label-text">비밀번호<span class="required-mark">*</span></span>
                <PasswordInput v-model="staffForm.password" autocomplete="new-password"
                  placeholder="영문+숫자 포함 6~20자리"
                  :invalid="!!staffFe.password"
                  @update:modelValue="clearStaffFe('password')" />
                <span v-if="staffFe.password" class="field-error">{{ staffFe.password }}</span>
              </label>

              <label><span class="label-text">비밀번호 확인<span class="required-mark">*</span></span>
                <PasswordInput v-model="staffForm.passwordConfirm" autocomplete="new-password"
                  placeholder="비밀번호를 다시 입력해주세요"
                  :invalid="!!staffFe.passwordConfirm"
                  @update:modelValue="clearStaffFe('passwordConfirm')" />
                <span v-if="staffFe.passwordConfirm" class="field-error">{{ staffFe.passwordConfirm }}</span>
              </label>

              <label><span class="label-text">연락처<span class="required-mark">*</span></span>
                <div class="phone-input-row">
                  <select v-model="staffForm.phonePrefix" class="phone-prefix">
                    <option v-for="p in PHONE_PREFIXES" :key="p" :value="p">{{ p }}</option>
                  </select>
                  <span class="phone-sep">-</span>
                  <input
                    :value="staffForm.phoneSuffix"
                    @input="onStaffSuffixInput($event)"
                    placeholder="숫자만 입력"
                    inputmode="numeric"
                    maxlength="9"
                    class="phone-suffix"
                    :class="{ 'input-invalid': staffFe.phoneSuffix }"
                  />
                </div>
                <span v-if="staffFe.phoneSuffix" class="field-error">{{ staffFe.phoneSuffix }}</span>
              </label>

              <label><span class="label-text">부서</span>
                <input v-model="staffForm.manager_department" placeholder="예: 영업관리팀" />
              </label>

              <label><span class="label-text">직책</span>
                <input v-model="staffForm.manager_position" placeholder="예: 과장" />
              </label>
            </div>
          </div>
        </div>

        <button class="primary" type="submit">가입 신청</button>
        <button class="secondary full" type="button" @click="mode = 'login'">로그인으로 돌아가기</button>
        <p v-if="error" class="error">{{ error }}</p>
      </form>
    </section>
  </main>

  <AlertModal :show="modal.show" :title="modal.title" :message="modal.message" @confirm="modal.show = false" @cancel="modal.show = false" />
</template>
