<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { api, request } from '../../api';
import { useAuthStore } from '../../stores/auth';
import StatusBadge from '../../components/StatusBadge.vue';
import OrderItemsEditor from '../../components/OrderItemsEditor.vue';

const auth = useAuthStore();
const products = ref([]);
const orders = ref([]);
const error = ref('');
const message = ref('');
const form = reactive({
  delivery_address: '',
  note: '',
  items: []
});
const money = (value) => Number(value || 0).toLocaleString('ko-KR');
const total = computed(() => form.items.reduce((sum, item) => sum + Number(item.quantity || 0) * Number(item.unit_price || 0), 0));

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
    if (products.value.length) form.items.push({ product_id: products.value[0].id, quantity: 1, unit_price: Number(products.value[0].base_price) });
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
      <button class="ghost" @click="logout">로그아웃</button>
    </header>

    <p v-if="error" class="error">{{ error }}</p>
    <p v-if="message" class="message">{{ message }}</p>

    <section class="dealer-calendar">
      <div>
        <strong>{{ new Date().getFullYear() }}년 {{ new Date().getMonth() + 1 }}월</strong>
        <span>이번 달 발주 {{ orders.length }}건</span>
      </div>
      <div class="calendar-strip">
        <span v-for="day in 31" :key="day" :class="{ marked: orders.some((order) => new Date(order.ordered_at).getDate() === day) }">{{ day }}</span>
      </div>
    </section>

    <form class="order-paper" @submit.prevent="submitOrder">
      <div class="paper-title">
        <h2>발 주 서</h2>
        <strong>AT GLOBAL</strong>
      </div>
      <div class="paper-grid">
        <label>발주일<input :value="new Date().toISOString().slice(0, 10)" readonly /></label>
        <label>대리점명<input :value="auth.user?.company_name" readonly /></label>
        <label>담당자<input :value="auth.user?.name" readonly /></label>
        <label>연락처<input :value="auth.user?.phone" readonly /></label>
      </div>
      <OrderItemsEditor v-model="form.items" :products="products" />
      <label>배송지<input v-model="form.delivery_address" required /></label>
      <label>비고<textarea v-model="form.note"></textarea></label>
      <div class="paper-total">
        <span>총 합계</span>
        <strong>{{ money(total) }}원</strong>
      </div>
      <button class="primary" type="submit">전송</button>
    </form>

    <section class="panel">
      <h2>발주 현황</h2>
      <table>
        <thead><tr><th>발주번호</th><th>발주일</th><th>제품</th><th>합계</th><th>상태</th></tr></thead>
        <tbody>
          <tr v-for="order in orders" :key="order.id">
            <td>{{ order.order_number }}</td>
            <td>{{ order.ordered_at.slice(0, 10) }}</td>
            <td>{{ order.items.map((item) => `${item.model_name} ${item.quantity}개`).join(', ') }}</td>
            <td>{{ money(order.total_amount) }}</td>
            <td><StatusBadge :status="order.status" /></td>
          </tr>
        </tbody>
      </table>
    </section>
  </main>
</template>
