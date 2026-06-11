<script setup>
import { computed, onMounted, reactive, ref } from 'vue';
import { useRoute } from 'vue-router';
import { api, request } from '../../api';
import AppShell from '../../components/AppShell.vue';
import KpiCard from '../../components/KpiCard.vue';
import StatusBadge from '../../components/StatusBadge.vue';
import OrderItemsEditor from '../../components/OrderItemsEditor.vue';
import MiniCalendar from '../../components/MiniCalendar.vue';

const route = useRoute();
const view = computed(() => route.params.view || 'dashboard');

const viewTitles = {
  dashboard: '총판 대시보드',
  orders: '수주현황',
  inventory: '재고현황',
  sales: '판매현황',
  shipments: '출고현황'
};

const menu = [
  { label: '대시보드', to: '/distributor' },
  { label: '수주현황', to: '/distributor/orders' },
  { label: '재고현황', to: '/distributor/inventory' },
  { label: '판매현황', to: '/distributor/sales' },
  { label: '출고현황', to: '/distributor/shipments' }
];

const data = reactive({
  dashboard: null,
  orders: [],
  products: [],
  inventory: [],
  shipments: [],
  sales: [],
  monthlySales: []
});

const editing = ref(null);
const error = ref('');
const money = (v) => Number(v || 0).toLocaleString('ko-KR');

async function loadAll() {
  error.value = '';
  try {
    const [dashboard, orders, products, inventory, shipments, salesData] = await Promise.all([
      request(api.get('/dashboard/distributor')),
      request(api.get('/orders/distributor')),
      request(api.get('/products')),
      request(api.get('/inventory/distributor')),
      request(api.get('/shipments')),
      request(api.get('/sales'))
    ]);
    data.dashboard = dashboard;
    data.orders = orders.orders;
    data.products = products.products;
    data.inventory = inventory.inventory;
    data.shipments = shipments.shipments;
    data.sales = salesData.sales;
    data.monthlySales = salesData.monthly;
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
  try {
    await request(api.patch(`/orders/${editing.value.id}`, editing.value));
    editing.value = null;
    await loadAll();
  } catch (err) {
    error.value = err.message;
  }
}

async function convert(order) {
  if (!confirm(`발주서 ${order.order_number}을(를) 관리자에게 전환하시겠습니까?\n전환 후에는 내용 수정이 불가능합니다.`)) return;
  try {
    await request(api.post(`/orders/${order.id}/convert`));
    await loadAll();
  } catch (err) {
    error.value = err.message;
  }
}

async function saveInventory(product) {
  try {
    await request(api.post('/inventory/distributor', {
      product_id: product.id,
      quantity: product._qty ?? 0,
      min_quantity: product._minQty ?? 0
    }));
    await loadAll();
  } catch (err) {
    error.value = err.message;
  }
}

onMounted(loadAll);
</script>

<template>
  <AppShell :title="viewTitles[view] || '총판 대시보드'" :menu="menu">
    <p v-if="error" class="error">{{ error }}</p>

    <!-- 대시보드 -->
    <template v-if="view === 'dashboard'">
      <div class="dashboard-top">
        <MiniCalendar :marked-dates="data.orders.map(o => o.ordered_at)" />
        <section v-if="data.dashboard" class="kpi-grid kpi-grid-col">
          <KpiCard label="이번 달 수주" :value="data.dashboard.summary.monthly_orders" hint="건" />
          <KpiCard label="총판 재고" :value="data.dashboard.summary.current_inventory" hint="개" />
          <KpiCard label="이번 달 판매액" :value="`${money(data.dashboard.summary.monthly_sales)}원`" hint="발주 기준" />
          <KpiCard label="이번 달 출고" :value="data.dashboard.summary.monthly_shipments" hint="건" />
        </section>
      </div>
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
          <h2>최근 수주</h2>
          <table>
            <thead><tr><th>발주번호</th><th>대리점</th><th>합계</th><th>상태</th></tr></thead>
            <tbody>
              <tr v-for="order in data.orders.slice(0, 5)" :key="order.id">
                <td class="order-num">{{ order.order_number }}</td>
                <td>{{ order.dealer_company }}</td>
                <td>{{ money(order.total_amount) }}</td>
                <td><StatusBadge :status="order.status" /></td>
              </tr>
              <tr v-if="!data.orders.length">
                <td colspan="4" class="empty-row">수주 내역이 없습니다.</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>

    <!-- 수주현황 -->
    <template v-else-if="view === 'orders'">
      <section class="panel">
        <h2>받은 발주서</h2>
        <table>
          <thead>
            <tr>
              <th>발주번호</th><th>대리점</th><th>품목</th>
              <th style="text-align:right">합계</th><th>발주일</th><th>상태</th><th>액션</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in data.orders" :key="order.id">
              <td class="order-num">{{ order.order_number }}</td>
              <td>{{ order.dealer_company }}</td>
              <td>{{ order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ') }}</td>
              <td style="text-align:right;font-weight:700">{{ money(order.total_amount) }}</td>
              <td>{{ order.ordered_at?.slice(0, 10) }}</td>
              <td><StatusBadge :status="order.status" /></td>
              <td>
                <div class="actions">
                  <button v-if="['PENDING', 'RECEIVED'].includes(order.status)" @click="edit(order)">수정</button>
                  <button v-if="['PENDING', 'RECEIVED'].includes(order.status)" @click="convert(order)">발주 전환 ▶</button>
                </div>
              </td>
            </tr>
            <tr v-if="!data.orders.length">
              <td colspan="7" class="empty-row">받은 발주서가 없습니다.</td>
            </tr>
          </tbody>
        </table>
      </section>
    </template>

    <!-- 재고현황 -->
    <template v-else-if="view === 'inventory'">
      <section class="panel">
        <h2>총판 재고 관리</h2>
        <table>
          <thead><tr><th>제품</th><th>모델</th><th>규격</th><th>재고</th><th>최소</th><th></th></tr></thead>
          <tbody>
            <tr v-for="product in data.products" :key="product.id">
              <td>{{ product.name }}</td>
              <td>{{ product.model_name }}</td>
              <td>{{ product.spec }}</td>
              <td>
                <input
                  :value="data.inventory.find((i) => i.product_id === product.id)?.quantity ?? 0"
                  type="number"
                  min="0"
                  style="width:80px"
                  @input="product._qty = Number($event.target.value)"
                />
              </td>
              <td>
                <input
                  :value="data.inventory.find((i) => i.product_id === product.id)?.min_quantity ?? 0"
                  type="number"
                  min="0"
                  style="width:70px"
                  @input="product._minQty = Number($event.target.value)"
                />
              </td>
              <td><button @click="saveInventory(product)">저장</button></td>
            </tr>
          </tbody>
        </table>
      </section>
    </template>

    <!-- 판매현황 -->
    <template v-else-if="view === 'sales'">
      <section class="panel">
        <h2>월별 판매 요약</h2>
        <table>
          <thead><tr><th>연월</th><th style="text-align:right">수량</th><th style="text-align:right">판매액</th></tr></thead>
          <tbody>
            <tr v-for="row in data.monthlySales" :key="row.month">
              <td>{{ row.month }}</td>
              <td style="text-align:right">{{ row.quantity }}개</td>
              <td style="text-align:right;font-weight:700">{{ money(row.amount) }}원</td>
            </tr>
            <tr v-if="!data.monthlySales.length">
              <td colspan="3" class="empty-row">판매 내역이 없습니다.</td>
            </tr>
          </tbody>
        </table>
      </section>
      <section class="panel">
        <h2>판매 상세 내역</h2>
        <table>
          <thead>
            <tr><th>날짜</th><th>대리점</th><th>모델</th>
            <th style="text-align:right">수량</th><th style="text-align:right">단가</th><th style="text-align:right">금액</th></tr>
          </thead>
          <tbody>
            <tr v-for="(row, i) in data.sales" :key="i">
              <td>{{ row.date }}</td>
              <td>{{ row.dealer_company }}</td>
              <td>{{ row.model_name }}</td>
              <td style="text-align:right">{{ row.quantity }}</td>
              <td style="text-align:right">{{ money(row.unit_price) }}</td>
              <td style="text-align:right;font-weight:700">{{ money(row.amount) }}</td>
            </tr>
            <tr v-if="!data.sales.length">
              <td colspan="6" class="empty-row">판매 내역이 없습니다.</td>
            </tr>
          </tbody>
        </table>
      </section>
    </template>

    <!-- 출고현황 -->
    <template v-else-if="view === 'shipments'">
      <section class="panel">
        <h2>출고현황</h2>
        <table>
          <thead>
            <tr><th>출고번호</th><th>발주번호</th><th>대리점</th><th>배송지</th><th>운송장번호</th><th>출고일</th></tr>
          </thead>
          <tbody>
            <tr v-for="s in data.shipments" :key="s.id">
              <td>{{ s.shipment_number }}</td>
              <td class="order-num">{{ s.order_number }}</td>
              <td>{{ s.dealer_company }}</td>
              <td>{{ s.delivery_address }}</td>
              <td>{{ s.tracking_number || '-' }}</td>
              <td>{{ s.shipped_at?.slice(0, 10) }}</td>
            </tr>
            <tr v-if="!data.shipments.length">
              <td colspan="6" class="empty-row">출고 내역이 없습니다.</td>
            </tr>
          </tbody>
        </table>
      </section>
    </template>

    <!-- 발주서 수정 모달 -->
    <section v-if="editing" class="modal-backdrop">
      <form class="modal" @submit.prevent="saveEdit">
        <h2>발주서 수정 — {{ editing.order_number }}</h2>
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
