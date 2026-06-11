<script setup>
import { computed, onMounted, onUnmounted, reactive, ref, watch } from 'vue';
import { useRoute } from 'vue-router';
import { api, request } from '../../api';
import AppShell from '../../components/AppShell.vue';
import KpiCard from '../../components/KpiCard.vue';
import StatusBadge from '../../components/StatusBadge.vue';
import MiniCalendar from '../../components/MiniCalendar.vue';
import BarcodeScanner from '../../components/BarcodeScanner.vue';
import PasswordInput from '../../components/PasswordInput.vue';

const route = useRoute();
const view = computed(() => route.params.view || 'dashboard');

const viewTitles = {
  dashboard: '대시보드', orders: '수주현황', inventory: '재고현황',
  sales: '판매현황', shipments: '출고현황', members: '회원관리'
};

const menu = [
  { label: '대시보드', to: '/admin' },
  { label: '수주현황', to: '/admin/orders' },
  { label: '재고현황', to: '/admin/inventory' },
  { label: '판매현황', to: '/admin/sales' },
  { label: '출고현황', to: '/admin/shipments' },
  { label: '회원관리', to: '/admin/members' }
];

const data = reactive({
  dashboard: null, orders: [], inventory: [], products: [],
  pending: [], users: [], distributors: [], shipments: [], sales: [], monthlySales: []
});

const productForm = reactive({ name: '', model_name: '', spec: '', base_price: 0 });
const memberTab = ref('all'); // 'all' | 'inactive' | 'rejected'
const trackingNumbers = reactive({});
const error = ref('');

// ── 회원 선택 & 편집 ────────────────────────────────
const selectedUser = ref(null);
const editForm = reactive({
  name: '', phone: '', company_name: '', address: '', role: 'dealer',
  status: 'active', distributor_id: null, password: ''
});

function selectUser(user) {
  selectedUser.value = user;
  Object.assign(editForm, {
    name: user.name, phone: user.phone || '', company_name: user.company_name || '',
    address: user.address || '', role: user.role, status: user.status,
    distributor_id: user.distributor_id || null, password: ''
  });
}

// ── 컬럼 필터 ────────────────────────────────────────
const activeFilter = ref(null);
const colFilters = reactive({});

const baseNonAdmins = computed(() => data.users.filter(u => u.role !== 'admin'));

const tabUsers = computed(() => {
  if (memberTab.value === 'pending') return data.pending;
  if (memberTab.value === 'all') {
    const pending = baseNonAdmins.value.filter(u => u.status === 'pending');
    const others  = baseNonAdmins.value.filter(u => u.status !== 'pending');
    return [...pending, ...others];
  }
  return baseNonAdmins.value.filter(u => u.status === memberTab.value);
});

const tabCounts = computed(() => ({
  pending:  data.pending.length,
  all:      baseNonAdmins.value.length,
  active:   baseNonAdmins.value.filter(u => u.status === 'active').length,
  inactive: baseNonAdmins.value.filter(u => u.status === 'inactive').length,
  rejected: baseNonAdmins.value.filter(u => u.status === 'rejected').length
}));

const currentBase = computed(() => tabUsers.value);

function uniqueVals(key) {
  return [...new Set(currentBase.value.map(u => String(u[key] ?? '')))];
}
function isFiltered(key) {
  return !!colFilters[key] && colFilters[key].length < uniqueVals(key).length;
}
function openFilter(key) {
  if (activeFilter.value === key) { activeFilter.value = null; return; }
  if (!colFilters[key]) colFilters[key] = uniqueVals(key);
  activeFilter.value = key;
}
function toggleVal(key, val) {
  if (!colFilters[key]) return;
  const idx = colFilters[key].indexOf(val);
  if (idx === -1) colFilters[key].push(val); else colFilters[key].splice(idx, 1);
}
function selectAll(key) { colFilters[key] = uniqueVals(key); }
function clearAll(key) { colFilters[key] = []; }

function applyColFilters(rows) {
  return rows.filter(u => {
    for (const [key, selected] of Object.entries(colFilters)) {
      if (!selected || selected.length === 0) return false;
      if (!selected.includes(String(u[key] ?? ''))) return false;
    }
    return true;
  });
}

const filteredTabUsers = computed(() => applyColFilters(tabUsers.value));

const ROLE_LABEL = { admin: '관리자', dealer: '대리점', distributor: '총판' };
const STATUS_LABEL = { active: '활성', inactive: '비활성', pending: '대기', rejected: '거부' };
function filterLabel(key, val) {
  if (key === 'role') return ROLE_LABEL[val] || val;
  if (key === 'status') return STATUS_LABEL[val] || val;
  return val || '(없음)';
}

function closeFilter() { activeFilter.value = null; }
onMounted(() => document.addEventListener('click', closeFilter));
onUnmounted(() => document.removeEventListener('click', closeFilter));

watch([memberTab, view], () => {
  selectedUser.value = null;
  activeFilter.value = null;
  Object.keys(colFilters).forEach(k => delete colFilters[k]);
});

const money = (v) => Number(v || 0).toLocaleString('ko-KR');

// ── API ──────────────────────────────────────────────
async function loadAll() {
  error.value = '';
  try {
    const [dashboard, orders, inventory, products, pending, users, distributors, shipments, salesData] = await Promise.all([
      request(api.get('/dashboard/admin')), request(api.get('/orders/admin')),
      request(api.get('/inventory')), request(api.get('/products')),
      request(api.get('/users/pending')), request(api.get('/users')),
      request(api.get('/users/distributors')), request(api.get('/shipments')),
      request(api.get('/sales'))
    ]);
    data.dashboard = dashboard; data.orders = orders.orders;
    data.inventory = inventory.inventory; data.products = products.products;
    data.pending = pending.users; data.users = users.users;
    data.distributors = distributors.users; data.shipments = shipments.shipments;
    data.sales = salesData.sales; data.monthlySales = salesData.monthly;
  } catch (err) { error.value = err.message; }
}

async function addProduct() {
  try {
    await request(api.post('/products', productForm));
    Object.assign(productForm, { name: '', model_name: '', spec: '', base_price: 0 });
    await loadAll();
  } catch (err) { error.value = err.message; }
}
async function saveInventory(item) {
  try {
    await request(api.patch(`/inventory/${item.id}`, { quantity: item.quantity, min_quantity: item.min_quantity }));
    await loadAll();
  } catch (err) { error.value = err.message; }
}
async function approve(user) {
  try {
    await request(api.post(`/users/${user.id}/approve`, { distributor_id: user.distributor_id || null }));
    await loadAll();
  } catch (err) { error.value = err.message; }
}
async function reject(user) {
  try { await request(api.post(`/users/${user.id}/reject`)); await loadAll(); }
  catch (err) { error.value = err.message; }
}
async function updateStatus(order, status) {
  try { await request(api.patch(`/orders/${order.id}/status`, { status })); await loadAll(); }
  catch (err) { error.value = err.message; }
}
async function ship(order) {
  try {
    await request(api.post('/shipments', { order_id: order.id, delivery_address: order.delivery_address, tracking_number: trackingNumbers[order.id] || null }));
    delete trackingNumbers[order.id]; await loadAll();
  } catch (err) { error.value = err.message; }
}
async function saveMember() {
  try {
    const payload = { name: editForm.name, phone: editForm.phone, company_name: editForm.company_name, address: editForm.address, role: editForm.role, status: editForm.status, distributor_id: editForm.role === 'dealer' ? editForm.distributor_id : null };
    if (editForm.password) payload.password = editForm.password;
    await request(api.patch(`/users/${selectedUser.value.id}`, payload));
    selectedUser.value = null; await loadAll();
  } catch (err) { error.value = err.message; }
}
async function deleteMember() {
  if (!confirm(`${selectedUser.value.name}(${selectedUser.value.username}) 회원을 삭제하시겠습니까?`)) return;
  try {
    const result = await request(api.delete(`/users/${selectedUser.value.id}`));
    if (result.softDeleted) alert(result.message);
    selectedUser.value = null; await loadAll();
  } catch (err) { error.value = err.message; }
}

onMounted(loadAll);
</script>

<template>
  <AppShell :title="viewTitles[view] || '대시보드'" :menu="menu">
    <p v-if="error" class="error">{{ error }}</p>

    <!-- 대시보드 -->
    <template v-if="view === 'dashboard'">
      <div class="dashboard-top">
        <MiniCalendar :marked-dates="data.orders.map(o => o.ordered_at)" />
        <section v-if="data.dashboard" class="kpi-grid kpi-grid-col">
          <KpiCard label="이번 달 수주" :value="data.dashboard.summary.monthly_orders" hint="건" />
          <KpiCard label="현재 재고" :value="data.dashboard.summary.current_inventory" hint="개" />
          <KpiCard label="이번 달 판매액" :value="`${money(data.dashboard.summary.monthly_sales)}원`" hint="발주 기준" />
          <KpiCard label="이번 달 출고" :value="data.dashboard.summary.monthly_shipments" hint="건" />
        </section>
      </div>
      <section class="grid-2">
        <div class="panel">
          <h2>LINE UP 제품 현황</h2>
          <table><thead><tr><th>제품</th><th>모델</th><th>이번달 수주</th><th>재고</th><th>판매액</th></tr></thead>
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
          <table><thead><tr><th>대리점</th><th>소속 총판</th><th>발주</th><th>총 금액</th><th>최근 발주</th></tr></thead>
            <tbody>
              <tr v-for="row in data.dashboard?.dealers || []" :key="row.dealer_company">
                <td>{{ row.dealer_company }}</td><td>{{ row.distributor_company || '-' }}</td>
                <td>{{ row.order_count }}</td><td>{{ money(row.total_amount) }}</td>
                <td>{{ row.last_ordered_at ? row.last_ordered_at.slice(0, 10) : '-' }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>

    <!-- 수주현황 -->
    <template v-else-if="view === 'orders'">
      <section class="panel">
        <h2>전체 수주현황</h2>
        <table>
          <thead><tr><th>발주번호</th><th>대리점</th><th>총판</th><th>품목</th><th style="text-align:right">합계</th><th>발주일</th><th>상태</th><th>액션</th></tr></thead>
          <tbody>
            <tr v-for="order in data.orders" :key="order.id">
              <td class="order-num">{{ order.order_number }}</td>
              <td>{{ order.dealer_company }}</td><td>{{ order.distributor_company }}</td>
              <td>{{ order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ') }}</td>
              <td style="text-align:right;font-weight:700">{{ money(order.total_amount) }}</td>
              <td>{{ order.ordered_at?.slice(0, 10) }}</td>
              <td><StatusBadge :status="order.status" /></td>
              <td><div class="actions">
                <button v-if="order.status === 'CONVERTED'" @click="updateStatus(order, 'CONFIRMED')">수주 확인</button>
                <template v-if="order.status === 'CONFIRMED'">
                  <input v-model="trackingNumbers[order.id]" placeholder="운송장번호" style="width:110px;padding:5px 8px;font-size:12px" />
                  <button @click="ship(order)">출고 등록</button>
                </template>
                <button v-if="!['SHIPPED','CANCELLED'].includes(order.status)" class="btn-danger" @click="updateStatus(order, 'CANCELLED')">취소</button>
              </div></td>
            </tr>
            <tr v-if="!data.orders.length"><td colspan="8" class="empty-row">수주 내역이 없습니다.</td></tr>
          </tbody>
        </table>
      </section>
    </template>

    <!-- 재고현황 -->
    <template v-else-if="view === 'inventory'">
      <BarcodeScanner @scanned="loadAll" />
      <section class="grid-2">
        <div class="panel">
          <h2>제품 등록</h2>
          <form class="compact-form" @submit.prevent="addProduct">
            <input v-model="productForm.name" placeholder="제품명" required />
            <input v-model="productForm.model_name" placeholder="모델명" required />
            <input v-model="productForm.spec" placeholder="규격" />
            <input v-model.number="productForm.base_price" type="number" placeholder="기본 단가" min="0" />
            <button class="primary" type="submit">등록</button>
          </form>
        </div>
        <div class="panel">
          <h2>관리자 재고현황</h2>
          <table><thead><tr><th>모델</th><th>규격</th><th>재고</th><th>최소</th><th></th></tr></thead>
            <tbody>
              <tr v-for="item in data.inventory" :key="item.id" :class="{ low: item.quantity <= item.min_quantity }">
                <td>{{ item.model_name }}</td><td>{{ item.spec }}</td>
                <td><input v-model.number="item.quantity" type="number" min="0" style="width:80px" /></td>
                <td><input v-model.number="item.min_quantity" type="number" min="0" style="width:70px" /></td>
                <td><button @click="saveInventory(item)">저장</button></td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>

    <!-- 판매현황 -->
    <template v-else-if="view === 'sales'">
      <section class="panel">
        <h2>월별 판매 요약</h2>
        <table><thead><tr><th>연월</th><th style="text-align:right">수량</th><th style="text-align:right">판매액</th></tr></thead>
          <tbody>
            <tr v-for="row in data.monthlySales" :key="row.month">
              <td>{{ row.month }}</td><td style="text-align:right">{{ row.quantity }}개</td>
              <td style="text-align:right;font-weight:700">{{ money(row.amount) }}원</td>
            </tr>
            <tr v-if="!data.monthlySales.length"><td colspan="3" class="empty-row">판매 내역이 없습니다.</td></tr>
          </tbody>
        </table>
      </section>
      <section class="panel">
        <h2>판매 상세 내역</h2>
        <table>
          <thead><tr><th>날짜</th><th>대리점</th><th>총판</th><th>모델</th><th style="text-align:right">수량</th><th style="text-align:right">단가</th><th style="text-align:right">금액</th></tr></thead>
          <tbody>
            <tr v-for="(row, i) in data.sales" :key="i">
              <td>{{ row.date }}</td><td>{{ row.dealer_company }}</td><td>{{ row.distributor_company }}</td>
              <td>{{ row.model_name }}</td><td style="text-align:right">{{ row.quantity }}</td>
              <td style="text-align:right">{{ money(row.unit_price) }}</td>
              <td style="text-align:right;font-weight:700">{{ money(row.amount) }}</td>
            </tr>
            <tr v-if="!data.sales.length"><td colspan="7" class="empty-row">판매 내역이 없습니다.</td></tr>
          </tbody>
        </table>
      </section>
    </template>

    <!-- 출고현황 -->
    <template v-else-if="view === 'shipments'">
      <section class="panel">
        <h2>출고현황</h2>
        <table>
          <thead><tr><th>출고번호</th><th>발주번호</th><th>대리점</th><th>총판</th><th>배송지</th><th>운송장번호</th><th>출고일</th></tr></thead>
          <tbody>
            <tr v-for="s in data.shipments" :key="s.id">
              <td>{{ s.shipment_number }}</td><td class="order-num">{{ s.order_number }}</td>
              <td>{{ s.dealer_company }}</td><td>{{ s.distributor_company }}</td>
              <td>{{ s.delivery_address }}</td><td>{{ s.tracking_number || '-' }}</td>
              <td>{{ s.shipped_at?.slice(0, 10) }}</td>
            </tr>
            <tr v-if="!data.shipments.length"><td colspan="7" class="empty-row">출고 내역이 없습니다.</td></tr>
          </tbody>
        </table>
      </section>
    </template>

    <!-- 회원관리 -->
    <template v-else-if="view === 'members'">
      <div :class="['member-layout', selectedUser ? 'split' : '']">

        <!-- ── 카드 1: 회원 목록 ── -->
        <section class="panel" style="margin-bottom:0">
          <h2>회원관리</h2>
          <div class="tab-bar">
            <button :class="{ active: memberTab === 'all' }" @click="memberTab = 'all'">
              전체 회원 <span class="badge-count">{{ tabCounts.all }}</span>
            </button>
            <button :class="{ active: memberTab === 'inactive' }" @click="memberTab = 'inactive'">
              비활성 <span class="badge-count">{{ tabCounts.inactive }}</span>
            </button>
            <button :class="{ active: memberTab === 'rejected' }" @click="memberTab = 'rejected'">
              거부 <span class="badge-count">{{ tabCounts.rejected }}</span>
            </button>
          </div>

          <div class="member-list-wrap">

            <!-- ── 승인 대기 테이블 (대기자 있을 때만) ── -->
            <template v-if="memberTab === 'all' && tabCounts.pending > 0">
              <div class="member-sub-header sub-pending">
                승인 대기
                <span class="badge-count badge-amber">{{ tabCounts.pending }}</span>
              </div>
              <table class="member-table" style="margin-bottom:20px">
                <thead>
                  <tr>
                    <th>이름</th><th>아이디</th>
                    <th><div class="th-wrap" @click.stop>역할
                      <button class="col-filter-btn" :class="{ on: isFiltered('role') }" @click.stop="openFilter('role')">▾</button>
                      <div v-if="activeFilter === 'role'" class="col-filter-drop" @click.stop>
                        <label class="col-filter-all"><input type="checkbox" :checked="(colFilters.role?.length ?? 0) === uniqueVals('role').length" @change="(colFilters.role?.length ?? 0) === uniqueVals('role').length ? clearAll('role') : selectAll('role')" />(전체)</label>
                        <label v-for="val in uniqueVals('role')" :key="val"><input type="checkbox" :checked="colFilters.role?.includes(val) ?? true" @change="toggleVal('role', val)" />{{ filterLabel('role', val) }}</label>
                      </div>
                    </div></th>
                    <th>회사</th><th>신청일</th><th>소속 총판</th><th>처리</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="user in baseNonAdmins.filter(u => u.status === 'pending')" :key="user.id"
                    :class="{ 'row-selected': selectedUser?.id === user.id, 'row-pending-in-all': true }"
                    @click="selectUser(user)">
                    <td>{{ user.name }}</td>
                    <td>{{ user.username }}</td>
                    <td>{{ ROLE_LABEL[user.role] || user.role }}</td>
                    <td>{{ user.company_name }}</td>
                    <td>{{ user.created_at?.slice(0, 10) }}</td>
                    <td @click.stop>
                      <select v-if="user.role === 'dealer'" v-model.number="user.distributor_id" style="font-size:12px;padding:4px 6px;min-height:unset">
                        <option :value="null">총판 선택</option>
                        <option v-for="dist in data.distributors" :key="dist.id" :value="dist.id">{{ dist.company_name }}</option>
                      </select>
                      <span v-else class="text-muted">해당없음</span>
                    </td>
                    <td @click.stop>
                      <div class="actions">
                        <button @click="approve(user)">승인</button>
                        <button class="btn-danger" @click="reject(user)">거부</button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </template>

            <!-- ── 회원 테이블 ── -->
            <div class="member-sub-header sub-active" v-if="memberTab === 'all'">
              활성 회원
              <span class="badge-count badge-green">{{ tabCounts.active }}</span>
            </div>
            <table class="member-table">
              <thead>
                <tr>
                  <th>이름</th><th>아이디</th>
                  <th><div class="th-wrap" @click.stop>역할
                    <button class="col-filter-btn" :class="{ on: isFiltered('role') }" @click.stop="openFilter('role')">▾</button>
                    <div v-if="activeFilter === 'role'" class="col-filter-drop" @click.stop>
                      <label class="col-filter-all"><input type="checkbox" :checked="(colFilters.role?.length ?? 0) === uniqueVals('role').length" @change="(colFilters.role?.length ?? 0) === uniqueVals('role').length ? clearAll('role') : selectAll('role')" />(전체)</label>
                      <label v-for="val in uniqueVals('role')" :key="val"><input type="checkbox" :checked="colFilters.role?.includes(val) ?? true" @change="toggleVal('role', val)" />{{ filterLabel('role', val) }}</label>
                    </div>
                  </div></th>
                  <th><div class="th-wrap" @click.stop>소속 총판
                    <button class="col-filter-btn" :class="{ on: isFiltered('distributor_name') }" @click.stop="openFilter('distributor_name')">▾</button>
                    <div v-if="activeFilter === 'distributor_name'" class="col-filter-drop" @click.stop>
                      <label class="col-filter-all"><input type="checkbox" :checked="(colFilters.distributor_name?.length ?? 0) === uniqueVals('distributor_name').length" @change="(colFilters.distributor_name?.length ?? 0) === uniqueVals('distributor_name').length ? clearAll('distributor_name') : selectAll('distributor_name')" />(전체)</label>
                      <label v-for="val in uniqueVals('distributor_name')" :key="val"><input type="checkbox" :checked="colFilters.distributor_name?.includes(val) ?? true" @change="toggleVal('distributor_name', val)" />{{ val || '(없음)' }}</label>
                    </div>
                  </div></th>
                  <th>회사</th><th>가입일</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in filteredTabUsers" :key="user.id"
                  :class="{ 'row-selected': selectedUser?.id === user.id }"
                  @click="selectUser(user)">
                  <td>{{ user.name }}</td>
                  <td>{{ user.username }}</td>
                  <td>{{ ROLE_LABEL[user.role] || user.role }}</td>
                  <td>{{ user.distributor_name || '-' }}</td>
                  <td>{{ user.company_name }}</td>
                  <td>{{ user.created_at?.slice(0, 10) }}</td>
                </tr>
                <tr v-if="!filteredTabUsers.length">
                  <td colspan="6" class="empty-row">해당 회원이 없습니다.</td>
                </tr>
              </tbody>
            </table>

          </div>
        </section>

        <!-- ── 카드 2: 편집 폼 ── -->
        <transition name="member-form">
          <section v-if="selectedUser" class="panel member-edit-card" style="margin-bottom:0">
            <div class="member-edit-header">
              <div class="member-edit-who">
                <strong>{{ selectedUser.name }}</strong>
                <span class="text-muted">{{ selectedUser.username }}</span>
                <span class="badge" :class="selectedUser.status === 'active' ? 's-SHIPPED' : 's-PENDING'">
                  {{ STATUS_LABEL[selectedUser.status] || selectedUser.status }}
                </span>
              </div>
              <button class="member-edit-close" type="button" @click="selectedUser = null">✕</button>
            </div>
            <form class="member-edit-form" @submit.prevent="saveMember">
              <label>이름<input v-model="editForm.name" required /></label>
              <label>아이디<input :value="selectedUser.username" readonly style="background:#f7f8fa;color:#999" /></label>
              <label>비밀번호<PasswordInput v-model="editForm.password" placeholder="변경 시 입력" autocomplete="new-password" /></label>
              <label>연락처<input v-model="editForm.phone" /></label>
              <label>주소<input v-model="editForm.address" /></label>
              <template v-if="selectedUser.role !== 'admin'">
                <label>회사명<input v-model="editForm.company_name" /></label>
                <label>역할
                  <select v-model="editForm.role">
                    <option value="distributor">총판</option>
                    <option value="dealer">대리점</option>
                  </select>
                </label>
                <label v-if="editForm.role === 'dealer'">소속 총판
                  <select v-model.number="editForm.distributor_id">
                    <option :value="null">선택</option>
                    <option v-for="dist in data.distributors" :key="dist.id" :value="dist.id">{{ dist.company_name }}</option>
                  </select>
                </label>
                <label>상태
                  <select v-model="editForm.status">
                    <option value="active">활성</option>
                    <option value="inactive">비활성</option>
                    <option value="pending">대기</option>
                    <option value="rejected">거부</option>
                  </select>
                </label>
              </template>
              <template v-else>
                <div class="admin-badge-info">관리자 계정 — 역할·상태 변경 불가</div>
              </template>
              <div class="member-edit-actions">
                <button class="primary" type="submit">저장</button>
                <button class="btn-danger" type="button" @click="deleteMember">삭제</button>
              </div>
            </form>
          </section>
        </transition>

      </div><!-- /member-layout -->
    </template>
  </AppShell>
</template>
