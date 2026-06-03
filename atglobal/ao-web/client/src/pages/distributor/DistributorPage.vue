<script setup>
import { onMounted, reactive, ref } from 'vue';
import { api, request } from '../../api';
import AppShell from '../../components/AppShell.vue';
import KpiCard from '../../components/KpiCard.vue';
import StatusBadge from '../../components/StatusBadge.vue';
import OrderItemsEditor from '../../components/OrderItemsEditor.vue';

const menu = [
  { label: '대시보드', to: '/distributor' },
  { label: '수주현황', to: '/distributor/orders' },
  { label: '재고현황', to: '/distributor/inventory' },
  { label: '출고현황', to: '/distributor/shipments' }
];

const data = reactive({
  dashboard: null,
  orders: [],
  products: [],
  inventory: [],
  shipments: []
});
const editing = ref(null);
const error = ref('');
const money = (value) => Number(value || 0).toLocaleString('ko-KR');

async function loadAll() {
  try {
    const [dashboard, orders, products, inventory, shipments] = await Promise.all([
      request(api.get('/dashboard/distributor')),
      request(api.get('/orders/distributor')),
      request(api.get('/products')),
      request(api.get('/inventory/distributor')),
      request(api.get('/shipments'))
    ]);
    data.dashboard = dashboard;
    data.orders = orders.orders;
    data.products = products.products;
    data.inventory = inventory.inventory;
    data.shipments = shipments.shipments;
  } catch (err) {
    error.value = err.message;
  }
}

function edit(order) {
  editing.value = {
    ...order,
    items: order.items.map((item) => ({
      product_id: item.product_id,
      quantity: item.quantity,
      unit_price: Number(item.unit_price)
    }))
  };
}

async function saveEdit() {
  await request(api.patch(`/orders/${editing.value.id}`, editing.value));
  editing.value = null;
  await loadAll();
}

async function convert(order) {
  await request(api.post(`/orders/${order.id}/convert`));
  await loadAll();
}

async function saveInventory(product) {
  await request(api.post('/inventory/distributor', product));
  await loadAll();
}

onMounted(loadAll);
</script>

<template>
  <AppShell title="총판 대시보드" :menu="menu">
    <p v-if="error" class="error">{{ error }}</p>
    <section v-if="data.dashboard" class="kpi-grid">
      <KpiCard label="이번 달 수주" :value="data.dashboard.summary.monthly_orders" hint="건" />
      <KpiCard label="총판 재고" :value="data.dashboard.summary.current_inventory" hint="개" />
      <KpiCard label="이번 달 판매액" :value="`${money(data.dashboard.summary.monthly_sales)}원`" hint="발주 기준" />
      <KpiCard label="이번 달 출고" :value="data.dashboard.summary.monthly_shipments" hint="건" />
    </section>

    <section class="grid-2">
      <div class="panel">
        <h2>소속 대리점 현황</h2>
        <table>
          <thead><tr><th>대리점</th><th>최근 발주</th><th>발주 건수</th><th>총 금액</th></tr></thead>
          <tbody>
            <tr v-for="row in data.dashboard?.dealers || []" :key="row.dealer_company">
              <td>{{ row.dealer_company }}</td>
              <td>{{ row.last_ordered_at ? row.last_ordered_at.slice(0, 10) : '-' }}</td>
              <td>{{ row.order_count }}</td>
              <td>{{ money(row.total_amount) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="panel">
        <h2>총판 재고 등록</h2>
        <table>
          <thead><tr><th>제품</th><th>수량</th><th>최소</th><th></th></tr></thead>
          <tbody>
            <tr v-for="product in data.products" :key="product.id">
              <td>{{ product.model_name }}</td>
              <td><input v-model.number="product.quantity" type="number" /></td>
              <td><input v-model.number="product.min_quantity" type="number" /></td>
              <td><button @click="saveInventory({ product_id: product.id, quantity: product.quantity || 0, min_quantity: product.min_quantity || 0 })">저장</button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <section class="panel">
      <h2>받은 발주서</h2>
      <table>
        <thead><tr><th>발주번호</th><th>대리점</th><th>품목</th><th>합계</th><th>상태</th><th>액션</th></tr></thead>
        <tbody>
          <tr v-for="order in data.orders" :key="order.id">
            <td>{{ order.order_number }}</td>
            <td>{{ order.dealer_company }}</td>
            <td>{{ order.items.map((item) => `${item.model_name} ${item.quantity}개`).join(', ') }}</td>
            <td>{{ money(order.total_amount) }}</td>
            <td><StatusBadge :status="order.status" /></td>
            <td class="actions">
              <button v-if="['PENDING', 'RECEIVED'].includes(order.status)" @click="edit(order)">수정</button>
              <button v-if="['PENDING', 'RECEIVED'].includes(order.status)" @click="convert(order)">발주 전환</button>
            </td>
          </tr>
        </tbody>
      </table>
    </section>

    <section v-if="editing" class="modal-backdrop">
      <form class="modal" @submit.prevent="saveEdit">
        <h2>발주서 수정</h2>
        <OrderItemsEditor v-model="editing.items" :products="data.products" />
        <label>배송지<input v-model="editing.delivery_address" /></label>
        <label>비고<textarea v-model="editing.note"></textarea></label>
        <div class="actions end">
          <button class="secondary" type="button" @click="editing = null">닫기</button>
          <button class="primary" type="submit">저장</button>
        </div>
      </form>
    </section>
  </AppShell>
</template>
