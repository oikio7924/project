<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { api, request } from '../../api';
import AppShell from '../../components/AppShell.vue';
import KpiCard from '../../components/KpiCard.vue';
import StatusBadge from '../../components/StatusBadge.vue';

const menu = [
  { label: '대시보드', to: '/admin' },
  { label: '수주현황', to: '/admin/orders' },
  { label: '재고현황', to: '/admin/inventory' },
  { label: '출고현황', to: '/admin/shipments' },
  { label: '회원관리', to: '/admin/members' }
];

const data = reactive({
  dashboard: null,
  orders: [],
  inventory: [],
  products: [],
  pending: [],
  users: [],
  distributors: [],
  shipments: []
});
const productForm = reactive({ name: '', model_name: '', spec: '', base_price: 0 });
const error = ref('');

const money = (value) => Number(value || 0).toLocaleString('ko-KR');
const convertedOrders = computed(() => data.orders.filter((order) => ['CONVERTED', 'CONFIRMED'].includes(order.status)));

async function loadAll() {
  error.value = '';
  try {
    const [dashboard, orders, inventory, products, pending, users, distributors, shipments] = await Promise.all([
      request(api.get('/dashboard/admin')),
      request(api.get('/orders/admin')),
      request(api.get('/inventory')),
      request(api.get('/products')),
      request(api.get('/users/pending')),
      request(api.get('/users')),
      request(api.get('/users/distributors')),
      request(api.get('/shipments'))
    ]);
    data.dashboard = dashboard;
    data.orders = orders.orders;
    data.inventory = inventory.inventory;
    data.products = products.products;
    data.pending = pending.users;
    data.users = users.users;
    data.distributors = distributors.users;
    data.shipments = shipments.shipments;
  } catch (err) {
    error.value = err.message;
  }
}

async function addProduct() {
  await request(api.post('/products', productForm));
  Object.assign(productForm, { name: '', model_name: '', spec: '', base_price: 0 });
  await loadAll();
}

async function saveInventory(item) {
  await request(api.patch(`/inventory/${item.id}`, item));
  await loadAll();
}

async function approve(user) {
  await request(api.post(`/users/${user.id}/approve`, { distributor_id: user.distributor_id || null }));
  await loadAll();
}

async function reject(user) {
  await request(api.post(`/users/${user.id}/reject`));
  await loadAll();
}

async function updateStatus(order, status) {
  await request(api.patch(`/orders/${order.id}/status`, { status }));
  await loadAll();
}

async function ship(order) {
  await request(api.post('/shipments', { order_id: order.id, delivery_address: order.delivery_address }));
  await loadAll();
}

onMounted(loadAll);
</script>

<template>
  <AppShell title="관리자 대시보드" :menu="menu">
    <p v-if="error" class="error">{{ error }}</p>
    <section v-if="data.dashboard" class="kpi-grid">
      <KpiCard label="이번 달 수주" :value="data.dashboard.summary.monthly_orders" hint="건" />
      <KpiCard label="현재 재고" :value="data.dashboard.summary.current_inventory" hint="개" />
      <KpiCard label="이번 달 판매액" :value="`${money(data.dashboard.summary.monthly_sales)}원`" hint="발주 기준" />
      <KpiCard label="이번 달 출고" :value="data.dashboard.summary.monthly_shipments" hint="건" />
    </section>

    <section class="grid-2">
      <div class="panel">
        <h2>LINE UP 제품 현황</h2>
        <table>
          <thead><tr><th>제품</th><th>모델</th><th>수주량</th><th>재고</th><th>판매액</th></tr></thead>
          <tbody>
            <tr v-for="row in data.dashboard?.lineup || []" :key="row.id">
              <td>{{ row.name }}</td><td>{{ row.model_name }}</td><td>{{ row.monthly_order_qty }}</td>
              <td>{{ row.inventory_qty }}</td><td>{{ money(row.sales_amount) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="panel">
        <h2>등록 판매대리점</h2>
        <table>
          <thead><tr><th>대리점</th><th>총판</th><th>발주</th><th>총 금액</th></tr></thead>
          <tbody>
            <tr v-for="row in data.dashboard?.dealers || []" :key="row.dealer_company">
              <td>{{ row.dealer_company }}</td><td>{{ row.distributor_company || '-' }}</td>
              <td>{{ row.order_count }}</td><td>{{ money(row.total_amount) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <section class="panel">
      <h2>수주현황</h2>
      <table>
        <thead><tr><th>발주번호</th><th>대리점</th><th>총판</th><th>품목</th><th>합계</th><th>상태</th><th>액션</th></tr></thead>
        <tbody>
          <tr v-for="order in data.orders" :key="order.id">
            <td>{{ order.order_number }}</td>
            <td>{{ order.dealer_company }}</td>
            <td>{{ order.distributor_company }}</td>
            <td>{{ order.items.map((item) => `${item.model_name} ${item.quantity}개`).join(', ') }}</td>
            <td>{{ money(order.total_amount) }}</td>
            <td><StatusBadge :status="order.status" /></td>
            <td class="actions">
              <button v-if="order.status === 'CONVERTED'" @click="updateStatus(order, 'CONFIRMED')">수주 확인</button>
              <button v-if="convertedOrders.includes(order)" @click="ship(order)">출고 등록</button>
              <button v-if="order.status !== 'SHIPPED'" @click="updateStatus(order, 'CANCELLED')">취소</button>
            </td>
          </tr>
        </tbody>
      </table>
    </section>

    <section class="grid-2">
      <div class="panel">
        <h2>제품 등록</h2>
        <form class="compact-form" @submit.prevent="addProduct">
          <input v-model="productForm.name" placeholder="제품명" />
          <input v-model="productForm.model_name" placeholder="모델명" />
          <input v-model="productForm.spec" placeholder="규격" />
          <input v-model.number="productForm.base_price" type="number" placeholder="기본 단가" />
          <button class="primary" type="submit">등록</button>
        </form>
      </div>
      <div class="panel">
        <h2>재고현황</h2>
        <table>
          <thead><tr><th>모델</th><th>재고</th><th>최소</th><th></th></tr></thead>
          <tbody>
            <tr v-for="item in data.inventory" :key="item.id" :class="{ low: item.quantity <= item.min_quantity }">
              <td>{{ item.model_name }}</td>
              <td><input v-model.number="item.quantity" type="number" /></td>
              <td><input v-model.number="item.min_quantity" type="number" /></td>
              <td><button @click="saveInventory(item)">저장</button></td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <section class="panel">
      <h2>회원관리</h2>
      <table>
        <thead><tr><th>이름</th><th>아이디</th><th>회사</th><th>역할</th><th>소속 총판</th><th>액션</th></tr></thead>
        <tbody>
          <tr v-for="user in data.pending" :key="user.id">
            <td>{{ user.name }}</td><td>{{ user.username }}</td><td>{{ user.company_name }}</td><td>{{ user.role }}</td>
            <td>
              <select v-if="user.role === 'dealer'" v-model.number="user.distributor_id">
                <option :value="null">선택</option>
                <option v-for="dist in data.distributors" :key="dist.id" :value="dist.id">{{ dist.company_name }}</option>
              </select>
            </td>
            <td class="actions"><button @click="approve(user)">승인</button><button @click="reject(user)">거부</button></td>
          </tr>
        </tbody>
      </table>
    </section>
  </AppShell>
</template>
