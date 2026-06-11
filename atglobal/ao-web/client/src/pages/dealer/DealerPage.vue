<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { api, request } from '../../api';
import { useAuthStore } from '../../stores/auth';
import StatusBadge from '../../components/StatusBadge.vue';
import OrderItemsEditor from '../../components/OrderItemsEditor.vue';
import MiniCalendar from '../../components/MiniCalendar.vue';

const auth = useAuthStore();
const products = ref([]);
const orders = ref([]);
const error = ref('');
const message = ref('');

const form = reactive({ delivery_address: auth.user?.address || '', note: '', items: [] });
const money = (v) => Number(v || 0).toLocaleString('ko-KR');
const total = computed(() => form.items.reduce((s, i) => s + Number(i.quantity || 0) * Number(i.unit_price || 0), 0));

// ── 요약 지표 ──────────────────────────────────
const now = new Date();
const thisMonthCount = computed(() => orders.value.filter((o) => {
  const od = new Date(o.ordered_at);
  return od.getFullYear() === now.getFullYear() && od.getMonth() === now.getMonth();
}).length);
const shippedCount = computed(() => orders.value.filter((o) => o.status === 'SHIPPED').length);
const activeCount = computed(() => orders.value.filter((o) => !['SHIPPED', 'CANCELLED'].includes(o.status)).length);

// ── API ───────────────────────────────────────
async function loadAll() {
  try {
    const [productData, orderData] = await Promise.all([
      request(api.get('/products')),
      request(api.get('/orders/dealer'))
    ]);
    products.value = productData.products;
    orders.value = orderData.orders;
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
  try {
    await request(api.post('/orders', form));
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

async function logout() {
  await auth.logout();
  location.href = '/login';
}

onMounted(loadAll);
</script>

<template>
  <main class="dealer-page">
    <header class="dealer-head">
      <div>
        <p class="eyebrow">{{ auth.user?.company_name }}</p>
        <h1>대리점 발주 페이지</h1>
      </div>
      <div style="display:flex;align-items:center;gap:12px">
        <span class="eyebrow">{{ auth.user?.name }}</span>
        <button class="ghost" @click="logout">로그아웃</button>
      </div>
    </header>

    <p v-if="error" class="error">{{ error }}</p>
    <p v-if="message" class="message">{{ message }}</p>

    <!-- 상단: 달력 + 요약 -->
    <div class="dealer-top">
      <!-- 달력 -->
      <MiniCalendar :marked-dates="orders.map(o => o.ordered_at)" />

      <!-- 요약 + 최근 발주 -->
      <div class="dealer-summary">
        <div class="summary-cards">
          <div class="sum-card">
            <div class="sum-lbl">이번달 발주</div>
            <div class="sum-val">{{ thisMonthCount }}건</div>
          </div>
          <div class="sum-card">
            <div class="sum-lbl">출고 완료</div>
            <div class="sum-val green">{{ shippedCount }}건</div>
          </div>
          <div class="sum-card">
            <div class="sum-lbl">처리 중</div>
            <div class="sum-val orange">{{ activeCount }}건</div>
          </div>
        </div>
        <div class="panel" style="margin-bottom:0;flex:1">
          <h2>최근 발주 현황</h2>
          <table>
            <thead><tr><th>발주번호</th><th>발주일</th><th>제품</th><th>상태</th></tr></thead>
            <tbody>
              <tr v-for="order in orders.slice(0, 4)" :key="order.id">
                <td class="order-num">{{ order.order_number }}</td>
                <td>{{ order.ordered_at?.slice(0, 10) }}</td>
                <td>{{ order.items[0]?.model_name }}</td>
                <td><StatusBadge :status="order.status" /></td>
              </tr>
              <tr v-if="!orders.length">
                <td colspan="4" class="empty-row">발주 내역이 없습니다.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- 발주서 양식 -->
    <form class="order-paper" @submit.prevent="submitOrder">
      <div class="paper-title">
        <h2>발 주 서</h2>
        <div style="text-align:right">
          <strong style="font-size:15px;letter-spacing:.12em;color:var(--navy)">AT GLOBAL</strong>
          <div style="font-size:11px;color:#999">www.atglobal.kr</div>
        </div>
      </div>
      <div class="paper-grid">
        <label>발주일<input :value="new Date().toLocaleDateString('ko-KR')" readonly /></label>
        <label>대리점명<input :value="auth.user?.company_name" readonly /></label>
        <label>담당자<input :value="auth.user?.name" readonly /></label>
        <label>연락처<input :value="auth.user?.phone" readonly /></label>
      </div>
      <OrderItemsEditor v-model="form.items" :products="products" />
      <label>배송지<input v-model="form.delivery_address" required placeholder="배송받으실 주소를 입력해주세요" /></label>
      <label>비고<textarea v-model="form.note" placeholder="특이사항이 있으면 입력해주세요"></textarea></label>
      <div class="paper-total">
        <span>총 합계</span>
        <strong>{{ money(total) }}원</strong>
      </div>
      <button class="primary" type="submit">전  송</button>
    </form>

    <!-- 발주 현황 전체 목록 -->
    <section class="panel">
      <h2>발주 현황</h2>
      <table>
        <thead>
          <tr><th>발주번호</th><th>발주일</th><th>제품</th><th style="text-align:right">합계</th><th>상태</th></tr>
        </thead>
        <tbody>
          <tr v-for="order in orders" :key="order.id">
            <td class="order-num">{{ order.order_number }}</td>
            <td>{{ order.ordered_at?.slice(0, 10) }}</td>
            <td>{{ order.items.map((i) => `${i.model_name} ${i.quantity}개`).join(', ') }}</td>
            <td style="text-align:right;font-weight:700">{{ money(order.total_amount) }}</td>
            <td><StatusBadge :status="order.status" /></td>
          </tr>
          <tr v-if="!orders.length">
            <td colspan="5" class="empty-row">발주 내역이 없습니다.</td>
          </tr>
        </tbody>
      </table>
    </section>
  </main>
</template>
