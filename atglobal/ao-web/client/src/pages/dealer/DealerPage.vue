<script setup>
import { computed, onMounted, reactive, ref, watch } from 'vue';
import { api, request } from '../../api';
import { useAuthStore } from '../../stores/auth';
import StatusBadge from '../../components/StatusBadge.vue';
import MiniCalendar from '../../components/MiniCalendar.vue';
import PasswordInput from '../../components/PasswordInput.vue';
import { confirmAction, notify } from '../../services/notification';
import { numberToKoreanMoney } from '../../utils/koreanMoney';

const auth = useAuthStore();
const products = ref([]);
const orders = ref([]);
const distributor = ref(null);
const selectedDate = ref(null);
const error = ref('');
const message = ref('');

const myFullAddress = computed(() => auth.user?.address
  ? auth.user.address + (auth.user?.address_detail ? ' ' + auth.user.address_detail : '')
  : '');
const form = reactive({ delivery_address: myFullAddress.value, payment_terms: '', note: '', items: [] });
const money = (v) => Number(v || 0).toLocaleString('ko-KR', { maximumFractionDigits: 0 });
function formatBizNum(val) {
  const d = val.replace(/\D/g, '').slice(0, 10);
  if (d.length <= 3) return d;
  if (d.length <= 5) return `${d.slice(0,3)}-${d.slice(3)}`;
  return `${d.slice(0,3)}-${d.slice(3,5)}-${d.slice(5)}`;
}
function formatPhone(val) {
  const d = val.replace(/\D/g, '').slice(0, 12);
  if (d.length <= 3) return d;
  if (d.length <= 6) return `${d.slice(0,3)}-${d.slice(3)}`;
  if (d.length <= 10) return `${d.slice(0,3)}-${d.slice(3,6)}-${d.slice(6)}`;
  if (d.length === 11) return `${d.slice(0,3)}-${d.slice(3,7)}-${d.slice(7)}`;
  return `${d.slice(0,4)}-${d.slice(4,8)}-${d.slice(8)}`;
}
const ROLE_KO = { distributor: '총판', dealer: '대리점', admin: '관리자' };
function fmtDatetime(iso) {
  if (!iso) return '';
  const d = new Date(iso);
  return `${d.getFullYear()}년 ${d.getMonth()+1}월 ${d.getDate()}일 ${String(d.getHours()).padStart(2,'0')}:${String(d.getMinutes()).padStart(2,'0')}`;
}

// ── 요약 지표 ──────────────────────────────────
const now = new Date();
const thisMonthOrders = computed(() => orders.value.filter((o) => {
  const od = new Date(o.ordered_at);
  return od.getFullYear() === now.getFullYear() && od.getMonth() === now.getMonth();
}));
const thisMonthCount = computed(() => thisMonthOrders.value.length);
const thisMonthAmount = computed(() => thisMonthOrders.value.reduce((s, o) => s + Number(o.total_amount || 0), 0));
const shippedCount = computed(() => orders.value.filter((o) => o.status === 'SHIPPED').length);
const activeCount = computed(() => orders.value.filter((o) => !['SHIPPED', 'CANCELLED'].includes(o.status)).length);

const filteredOrders = computed(() => {
  if (!selectedDate.value) return orders.value;
  return orders.value.filter((o) => o.ordered_at?.slice(0, 10) === selectedDate.value);
});

const supplyAmount = computed(() => form.items.reduce((s, i) => s + Number(i.quantity || 0) * Number(i.unit_price || 0), 0));
const vatAmount = computed(() => Math.floor(supplyAmount.value * 0.1));
const grandTotal = computed(() => supplyAmount.value + vatAmount.value);
const today = new Date().toLocaleDateString('ko-KR');

function productById(id) {
  return products.value.find(p => p.id === Number(id));
}
function addItem() {
  const p = products.value[0];
  if (p) form.items.push({ product_id: p.id, quantity: 1, unit_price: Number(p.base_price) });
}
function removeItem(i) {
  form.items.splice(i, 1);
}
function syncProduct(item) {
  const p = productById(item.product_id);
  if (p) item.unit_price = Number(p.base_price);
}

// ── API ───────────────────────────────────────
async function loadAll() {
  try {
    const [productData, orderData, distData] = await Promise.all([
      request(api.get('/products')),
      request(api.get('/orders/dealer')),
      request(api.get('/users/my-distributor'))
    ]);
    products.value = productData.products;
    orders.value = orderData.orders;
    distributor.value = distData.distributor;
    if (!form.items.length && products.value.length) {
      form.items.push({ product_id: products.value[0].id, quantity: 1, unit_price: Number(products.value[0].base_price) });
    }
  } catch (err) {
    error.value = err.message;
  }
}

async function submitOrder() {
  error.value = '';
  message.value = '';
  const confirmed = await confirmAction({
    title: '발주서 전송',
    message: `총 ${money(grandTotal.value)}원의 발주서를 총판에 전송하시겠습니까?`,
    confirmText: '발주 전송'
  });
  if (!confirmed) return;
  try {
    await request(api.post('/orders', form), { successMessage: '발주서가 총판으로 전송되었습니다.' });
    Object.assign(form, { delivery_address: '', note: '', items: [] });
    if (products.value.length) {
      form.items.push({ product_id: products.value[0].id, quantity: 1, unit_price: Number(products.value[0].base_price) });
    }
    message.value = '발주서가 총판으로 전송되었습니다.';
    await loadAll();
  } catch (err) {
    error.value = err.message;
  }
}

async function confirmDelivery(order) {
  const confirmed = await confirmAction({
    title: '입고 확인',
    message: `${order.order_number} 발주건의 물품이 입고되었습니까?`,
    confirmText: '입고 확인'
  });
  if (!confirmed) return;
  try {
    await request(api.post(`/orders/${order.id}/deliver`), { successMessage: '입고 확인되었습니다.' });
    await loadAll();
  } catch (err) {
    error.value = err.message;
  }
}

async function logout() {
  await auth.logout();
  location.href = '/login';
}

// ── 설정 ──────────────────────────────────────────────
const showSettings = ref(false);
function goHome() { showSettings.value = false; }
const settingsTab  = ref('profile');
const myForm = reactive({ company_name: '', business_number: '', business_type: '', business_item: '', company_phone: '', fax: '', address: '', addressDetail: '', password: '', passwordConfirm: '' });
const managerForm = reactive({ manager_name: '', manager_department: '', manager_phone: '', manager_email: '' });

function syncMyForm() {
  Object.assign(myForm, {
    company_name: auth.user?.company_name || '',
    business_number: auth.user?.business_number || '',
    business_type: auth.user?.business_type || '',
    business_item: auth.user?.business_item || '',
    company_phone: auth.user?.company_phone || '',
    fax: auth.user?.fax || '',
    address: auth.user?.address || '',
    addressDetail: auth.user?.address_detail || '',
    password: '',
    passwordConfirm: ''
  });
  Object.assign(managerForm, {
    manager_name: auth.user?.manager_name || '',
    manager_department: auth.user?.manager_department || '',
    manager_phone: auth.user?.manager_phone || '',
    manager_email: auth.user?.manager_email || ''
  });
}
watch(() => auth.user, syncMyForm, { immediate: true });

const myPwStatus = computed(() => {
  if (!myForm.password || !myForm.passwordConfirm) return null;
  return myForm.password === myForm.passwordConfirm ? 'match' : 'mismatch';
});

async function saveMyProfile() {
  try {
    if (myForm.password && myForm.password !== myForm.passwordConfirm) {
      notify('비밀번호 확인이 일치하지 않습니다.', 'error'); return;
    }
    const payload = {
      company_name: myForm.company_name, business_number: myForm.business_number,
      business_type: myForm.business_type, business_item: myForm.business_item,
      company_phone: myForm.company_phone, fax: myForm.fax,
      address: myForm.address, address_detail: myForm.addressDetail
    };
    if (myForm.password) payload.password = myForm.password;
    await request(api.patch('/users/me', payload), { successMessage: '계정 정보가 수정되었습니다.' });
    await auth.loadMe();
    myForm.password = '';
    myForm.passwordConfirm = '';
  } catch (err) { error.value = err.message; }
}
async function saveMyManager() {
  try {
    await request(api.patch('/users/me', managerForm), { successMessage: '회원 정보가 저장되었습니다.' });
    await auth.loadMe();
  } catch (err) { error.value = err.message; }
}

// ── 회사 로고: 헤더/발주서 등에 쓸 자사 로고를 직접 등록. 등록 안 하면 공란으로 표시 ──
const logoFileInput = ref(null);
async function onLogoFileChange(e) {
  const file = e.target.files[0];
  e.target.value = '';
  if (!file) return;
  const formData = new FormData();
  formData.append('logo', file);
  try {
    await request(api.post('/users/me/logo', formData), { successMessage: '로고가 등록되었습니다.' });
    await auth.loadMe();
  } catch (err) { error.value = err.message; }
}
async function removeLogo() {
  const confirmed = await confirmAction({ title: '로고 삭제', message: '등록된 로고를 삭제하시겠습니까?', confirmText: '삭제', danger: true });
  if (!confirmed) return;
  try {
    await request(api.delete('/users/me/logo'), { successMessage: '로고가 삭제되었습니다.' });
    await auth.loadMe();
  } catch (err) { error.value = err.message; }
}

function openAddressSearch() {
  new window.daum.Postcode({
    oncomplete(data) {
      myForm.address = data.roadAddress || data.jibunAddress;
      myForm.addressDetail = '';
    }
  }).open();
}

onMounted(() => {
  loadAll();
  if (!window.daum?.Postcode) {
    const script = document.createElement('script');
    script.src = 'https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js';
    document.head.appendChild(script);
  }
});
</script>

<template>
  <div class="dealer-shell">

    <!-- 상단 네비바 -->
    <nav class="dealer-nav">
      <div class="dealer-nav-inner">
        <div class="dealer-nav-brand">
          <img v-if="auth.user?.logo_url" :src="auth.user.logo_url" alt="로고" class="dealer-nav-logo" role="button" @click="goHome" />
          <button v-if="!auth.user?.logo_url" class="btn-home" type="button" title="메인으로 이동" @click="goHome">
            <svg class="icon-home" viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 2.1 1 12h3v9h6v-6h4v6h6v-9h3z" /></svg>
            홈
          </button>
          <span class="nav-divider"></span>
          <span class="nav-title">대리점 발주 시스템</span>
        </div>
        <div class="dealer-nav-center">
          <span class="nav-company-badge">{{ auth.user?.company_name }}</span>
        </div>
        <div class="dealer-nav-right">
          <div class="nav-user-info">
            <span class="nav-user-name">{{ auth.user?.company_name }}</span>
            <span class="nav-user-role">대리점</span>
          </div>
          <button class="nav-settings-btn" :class="{ active: showSettings }" @click="showSettings = !showSettings; settingsTab = 'profile'">설정</button>
          <button class="nav-logout-btn" @click="logout">로그아웃</button>
        </div>
      </div>
    </nav>

    <!-- 메인 컨텐츠 -->
    <main class="dealer-body">
      <p v-if="error" class="error">{{ error }}</p>

      <!-- 설정 -->
      <div v-if="showSettings" class="dealer-settings-wrap">
        <section class="panel">
          <h2>설정</h2>
          <div class="settings-layout">
            <aside class="settings-subnav">
              <button :class="{ active: settingsTab === 'profile' }" @click="settingsTab = 'profile'">
                <strong>계정 정보</strong>
                <span>회사 기본 정보 수정</span>
              </button>
              <button :class="{ active: settingsTab === 'contacts' }" @click="settingsTab = 'contacts'">
                <strong>회원 정보</strong>
                <span>계정 담당 연락처 정보</span>
              </button>
            </aside>
            <div class="settings-content">
              <form v-if="settingsTab === 'profile'" class="member-edit-form settings-profile-form" @submit.prevent="saveMyProfile">
                <div class="settings-profile-col">
                  <label>아이디<input :value="auth.user?.username" readonly style="background:#f7f8fa;color:#999" /></label>
                  <label>비밀번호
                    <PasswordInput v-model="myForm.password" placeholder="변경 시 입력" autocomplete="new-password"
                      :invalid="myPwStatus === 'mismatch'" :valid="myPwStatus === 'match'" />
                  </label>
                  <label v-if="myForm.password">비밀번호 확인
                    <PasswordInput v-model="myForm.passwordConfirm" placeholder="비밀번호를 다시 입력해주세요" autocomplete="new-password"
                      :invalid="myPwStatus === 'mismatch'" :valid="myPwStatus === 'match'" />
                    <span v-if="myPwStatus === 'match'" class="pw-feedback match">비밀번호가 일치합니다.</span>
                    <span v-else-if="myPwStatus === 'mismatch'" class="pw-feedback mismatch">비밀번호가 일치하지 않습니다.</span>
                  </label>
                  <label>회사명<input v-model="myForm.company_name" /></label>
                  <label>사업자번호<input :value="myForm.business_number" @input="myForm.business_number = formatBizNum($event.target.value)" placeholder="숫자만 입력" maxlength="12" /></label>
                  <div class="settings-inline-row">
                    <label>업태<input v-model="myForm.business_type" placeholder="예: 도소매업" /></label>
                    <label>업종<input v-model="myForm.business_item" placeholder="예: 전자상거래업" /></label>
                  </div>
                  <label>회사 연락처<input :value="myForm.company_phone" @input="myForm.company_phone = formatPhone($event.target.value)" placeholder="숫자만 입력" maxlength="14" /></label>
                  <label>FAX번호<input :value="myForm.fax" @input="myForm.fax = formatPhone($event.target.value)" placeholder="숫자만 입력" maxlength="14" /></label>
                  <label>주소
                    <div class="address-search-row">
                      <input class="address-base" :value="myForm.address" readonly placeholder="주소 검색을 이용해주세요" />
                      <button type="button" class="btn-address-search" @click="openAddressSearch">주소 검색</button>
                    </div>
                    <input v-model="myForm.addressDetail" placeholder="상세 주소를 입력해주세요" />
                  </label>
                </div>
                <div class="settings-profile-col">
                  <div class="settings-section-head" style="margin-top:8px">
                    <div>
                      <h3 style="margin:0">회사 로고</h3>
                      <p class="text-muted">헤더, 발주서 등 로고가 쓰이는 화면에 표시됩니다. 등록하지 않으면 빈 칸으로 보여집니다.</p>
                      <p class="text-muted">권장 사이즈 300×100px 내외의 가로형 이미지(가로:세로 약 3:1), 배경이 투명한 PNG 또는 SVG 권장 · JPG·WEBP도 가능 · 최대 2MB</p>
                    </div>
                  </div>
                  <div class="logo-upload-row">
                    <div class="logo-preview">
                      <img v-if="auth.user?.logo_url" :src="auth.user.logo_url" alt="회사 로고" />
                      <span v-else class="text-muted">등록된 로고 없음</span>
                    </div>
                    <input ref="logoFileInput" type="file" accept="image/png,image/jpeg,image/webp,image/svg+xml" style="display:none" @change="onLogoFileChange" />
                    <button type="button" class="secondary" @click="logoFileInput.click()">이미지 선택</button>
                    <button v-if="auth.user?.logo_url" type="button" class="btn-danger" @click="removeLogo">제거</button>
                  </div>
                </div>
                <div class="member-edit-actions">
                  <button class="primary" type="submit">계정 정보 저장</button>
                </div>
              </form>
              <div v-else-if="settingsTab === 'contacts'" class="settings-contacts">
                <div class="settings-section-head">
                  <div>
                    <h3>회원 정보</h3>
                    <p class="text-muted">현재 로그인한 계정 본인의 연락처를 입력합니다.</p>
                  </div>
                </div>
                <form class="member-edit-form settings-manager-form" @submit.prevent="saveMyManager">
                  <label>이름<input v-model="managerForm.manager_name" placeholder="이름" /></label>
                  <label>부서<input v-model="managerForm.manager_department" placeholder="소속 부서" /></label>
                  <label>연락처<input :value="managerForm.manager_phone" @input="managerForm.manager_phone = formatPhone($event.target.value)" placeholder="숫자만 입력" maxlength="14" /></label>
                  <label>이메일<input v-model="managerForm.manager_email" type="email" placeholder="example@company.com" /></label>
                  <div class="member-edit-actions">
                    <button class="primary" type="submit">회원 정보 저장</button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </section>
      </div>

      <!-- 3열 레이아웃: 달력 | 발주서 | 발주현황 -->
      <div v-else class="dealer-layout">

        <!-- 1열: 달력 + 요약 -->
        <aside class="dealer-col-left">
          <MiniCalendar
            :marked-dates="orders.filter(o => o.status !== 'CANCELLED').map(o => o.ordered_at)"
            :selected-date="selectedDate"
            @select="selectedDate = $event"
          />
        </aside>

        <!-- 2열: 발주서 -->
        <form class="order-doc" @submit.prevent="submitOrder">

          <!-- 헤더 -->
          <div class="odoc-header">
            <div>
              <h2 class="odoc-title">발 주 서</h2>
              <div class="odoc-meta">
                <span>발주일자</span><em>{{ today }}</em>
              </div>
            </div>
            <div class="odoc-logo">
              <img v-if="auth.user?.logo_url" :src="auth.user.logo_url" alt="로고" class="odoc-logo-img" />
            </div>
          </div>

          <!-- 수신처 / 발주처 -->
          <div class="odoc-parties">
            <div class="odoc-party">
              <div class="odoc-party-title">수 신 처</div>
              <table class="odoc-info-table">
                <tr><td>상호</td><td>{{ distributor?.company_name || '-' }}</td></tr>
                <tr><td>담당자</td><td>{{ distributor?.manager_name || distributor?.name || '-' }}</td></tr>
                <tr><td>연락처</td><td>{{ distributor?.manager_phone || distributor?.phone || '-' }}</td></tr>
              </table>
            </div>
            <div class="odoc-party">
              <div class="odoc-party-title">발 주 처</div>
              <table class="odoc-info-table">
                <tr><td>상호</td><td>{{ auth.user?.company_name }}</td></tr>
                <tr><td>소재지</td><td>{{ myFullAddress || '-' }}</td></tr>
                <tr><td>담당자</td><td>{{ auth.user?.name }}</td></tr>
                <tr><td>연락처</td><td>{{ auth.user?.phone }}</td></tr>
              </table>
            </div>
          </div>

          <p class="odoc-greeting">아래와 같이 발주합니다.</p>

          <!-- 품목 테이블 -->
          <table class="odoc-items">
            <thead>
              <tr>
                <th>No.</th><th>품&nbsp;&nbsp;&nbsp;명</th><th>규&nbsp;&nbsp;&nbsp;격</th>
                <th>수량</th><th>단가</th><th>공급가액</th><th>세액</th><th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(item, i) in form.items" :key="i">
                <td class="odoc-no">{{ i + 1 }}</td>
                <td>
                  <select class="odoc-select" v-model.number="item.product_id" @change="syncProduct(item)">
                    <option v-for="p in products" :key="p.id" :value="p.id">{{ p.name }} {{ p.model_name }}</option>
                  </select>
                </td>
                <td class="odoc-center">{{ productById(item.product_id)?.spec || productById(item.product_id)?.model_name || '-' }}</td>
                <td class="odoc-center">
                  <input class="odoc-qty" v-model.number="item.quantity" type="number" min="1" />
                </td>
                <td class="odoc-right">{{ money(item.unit_price) }}</td>
                <td class="odoc-right">{{ money(item.quantity * item.unit_price) }}</td>
                <td class="odoc-right">{{ money(Math.floor(item.quantity * item.unit_price * 0.1)) }}</td>
                <td><button class="odoc-del-btn" type="button" @click="removeItem(i)">×</button></td>
              </tr>
              <tr v-if="!form.items.length">
                <td colspan="8" class="odoc-empty">품목을 추가해주세요.</td>
              </tr>
            </tbody>
          </table>
          <button class="odoc-add-btn" type="button" @click="addItem">+ 품목 추가</button>

          <!-- 합계 -->
          <div class="odoc-summary">
            <div class="odoc-sum-cell">
              <span>공급가액</span>
              <strong>₩ {{ money(supplyAmount) }}</strong>
            </div>
            <div class="odoc-sum-cell">
              <span>세&nbsp;&nbsp;&nbsp;&nbsp;액</span>
              <strong>₩ {{ money(vatAmount) }}</strong>
            </div>
            <div class="odoc-sum-cell odoc-sum-total">
              <span>합&nbsp;&nbsp;&nbsp;&nbsp;계</span>
              <div class="odoc-sum-value">
                <strong>₩ {{ money(grandTotal) }}</strong>
                <small class="odoc-sum-korean">{{ numberToKoreanMoney(grandTotal) }}</small>
              </div>
            </div>
          </div>

          <!-- 발주조건 -->
          <div class="odoc-conditions">
            <div class="odoc-conditions-title">발주조건</div>
            <div class="odoc-conditions-body">
              <label class="odoc-cond-row">
                <span>배 송 지</span>
                <input v-model="form.delivery_address" required placeholder="배송받으실 주소를 입력해주세요" />
              </label>
              <label class="odoc-cond-row">
                <span>결제조건</span>
                <input v-model="form.payment_terms" placeholder="예) 현금결제" />
              </label>
              <label class="odoc-cond-row">
                <span>비&nbsp;&nbsp;&nbsp;&nbsp;고</span>
                <textarea v-model="form.note" placeholder="특이사항이 있으면 입력해주세요" rows="2"></textarea>
              </label>
            </div>
          </div>

          <div style="text-align:right;margin-top:12px">
            <button class="primary" type="submit" style="min-width:120px;letter-spacing:.1em">전&nbsp;&nbsp;송</button>
          </div>

        </form>

        <!-- 3열: 발주현황 -->
        <aside class="dealer-col-right">
          <div class="panel" style="margin:0">
            <div style="display:flex;align-items:baseline;gap:8px;margin-bottom:14px;flex-shrink:0">
              <h2 style="margin:0">발주 현황</h2>
              <span v-if="selectedDate" style="font-size:12px;color:var(--blue)">{{ selectedDate }} 필터 중</span>
            </div>
            <div class="order-card-list">
              <div v-for="order in filteredOrders" :key="order.id" class="order-card">
                <div class="order-card-head">
                  <span class="order-num">{{ order.order_number }}</span>
                  <StatusBadge :status="order.status" />
                </div>
                <div class="order-card-body">
                  <span class="order-card-items">{{ order.items.map(i => `${i.model_name} ${i.quantity}개`).join(', ') }}</span>
                </div>
                <div class="order-card-foot">
                  <span class="order-card-date">{{ order.ordered_at?.slice(0, 10) }}</span>
                  <span class="order-card-amount">{{ money(order.total_amount) }}원</span>
                </div>
                <div v-if="order.status === 'SHIPPED'" class="order-card-actions">
                  <button class="deliver-btn" type="button" @click="confirmDelivery(order)">입고 확인</button>
                </div>
                <div v-else-if="order.status === 'DELIVERED'" class="order-card-delivered">
                  <span class="delivered-check">✓ 입고 확인 완료</span>
                  <span class="delivered-who">{{ order.received_by_company }} ({{ ROLE_KO[order.received_by_role] || order.received_by_role }})</span>
                  <span class="delivered-when">{{ fmtDatetime(order.received_at) }}</span>
                </div>
              </div>
              <div v-if="!filteredOrders.length" class="empty-row" style="text-align:center;padding:24px 0">
                {{ selectedDate ? '해당 날짜의 발주 내역이 없습니다.' : '발주 내역이 없습니다.' }}
              </div>
            </div>
          </div>
        </aside>

      </div>
    </main>

    <!-- 하단 상태바 -->
    <footer class="dealer-statusbar">
      <div class="dealer-statusbar-inner">
        <div class="dstat-item">
          <span class="dstat-lbl">이번달 발주</span>
          <strong>{{ thisMonthCount }}건</strong>
        </div>
        <div class="dstat-sep"></div>
        <div class="dstat-item">
          <span class="dstat-lbl">처리 중</span>
          <strong style="color:var(--amber)">{{ activeCount }}건</strong>
        </div>
        <div class="dstat-sep"></div>
        <div class="dstat-item">
          <span class="dstat-lbl">출고 완료</span>
          <strong style="color:var(--green)">{{ shippedCount }}건</strong>
        </div>
        <div class="dstat-sep"></div>
        <div class="dstat-item">
          <span class="dstat-lbl">이번달 총액</span>
          <strong style="color:var(--navy)">{{ money(thisMonthAmount) }}원</strong>
        </div>
        <div class="dstat-spacer"></div>
        <template v-if="distributor">
          <div class="dstat-item">
            <span class="dstat-lbl">담당 총판</span>
            <span class="dstat-company">{{ distributor.company_name }}</span>
          </div>
          <div class="dstat-sep"></div>
          <div class="dstat-item">
            <span class="dstat-lbl">연락처</span>
            <span class="dstat-company">{{ distributor.manager_phone || distributor.phone }}</span>
          </div>
        </template>
      </div>
    </footer>

  </div>
</template>
