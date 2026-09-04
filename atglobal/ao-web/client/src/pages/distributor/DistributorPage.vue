<script setup>
import { computed, nextTick, onMounted, onUnmounted, reactive, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { api, request } from '../../api';
import { useAuthStore } from '../../stores/auth';
import AppShell from '../../components/AppShell.vue';
import PasswordInput from '../../components/PasswordInput.vue';
import KpiCard from '../../components/KpiCard.vue';
import StatusBadge from '../../components/StatusBadge.vue';
import OrderReceiptModal from '../../components/OrderReceiptModal.vue';
import TransactionStatementModal from '../../components/TransactionStatementModal.vue';
import MiniCalendar from '../../components/MiniCalendar.vue';
import PriceInput from '../../components/PriceInput.vue';
import FilterSearchInput from '../../components/FilterSearchInput.vue';
import DeleteMemberModal from '../../components/DeleteMemberModal.vue';
import { confirmAction, notify } from '../../services/notification';
import { numberToKoreanMoney } from '../../utils/koreanMoney';

const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
const myFullAddress = computed(() => auth.user?.address
  ? auth.user.address + (auth.user?.address_detail ? ' ' + auth.user.address_detail : '')
  : '');
const view = computed(() => route.params.view || 'dashboard');
const highlightOrderNum = computed(() => route.query.highlight || null);

function goToShipments(order) {
  router.push(`/distributor/shipments?highlight=${order.order_number}`);
}

watch([view, highlightOrderNum], async ([v, h]) => {
  if (v === 'shipments' && h) {
    await nextTick();
    document.querySelector('.row-highlighted')?.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }
}, { immediate: true });

watch(view, (v) => {
  if (v === 'members' && !(auth.user?.is_owner || auth.user?.is_member_manager)) {
    router.push('/distributor');
  }
}, { immediate: true });

const viewTitles = {
  dashboard: '총판 대시보드',
  order: '발주서',
  orders: '수주현황',
  inventory: '재고현황',
  sales: '판매현황',
  shipments: '출고현황',
  dealers: '대리점',
  members: '회원관리',
  settings: '설정'
};

const menu = computed(() => {
  const items = [
    { label: '대시보드', to: '/distributor' },
    { label: '발주',    to: '/distributor/order' },
    { label: '수주현황', to: '/distributor/orders' },
    { label: '재고현황', to: '/distributor/inventory' },
    { label: '판매현황', to: '/distributor/sales' },
    { label: '출고현황', to: '/distributor/shipments' },
    { label: '대리점',   to: '/distributor/dealers' }
  ];
  if (auth.user?.is_owner || auth.user?.is_member_manager) {
    items.push({ label: '회원관리', to: '/distributor/members' });
  }
  items.push({ label: '설정', to: '/distributor/settings' });
  return items;
});

const data = reactive({
  dashboard: null,
  orders: [],
  products: [],
  prices: [],
  inventory: [],
  shipments: [],
  sales: [],
  monthlySales: [],
  staff: [],
  pendingStaff: [],
  dealers: []
});

const editing = ref(null);
const statementPreview = ref(null);
const orderTab = ref('waiting'); // 'waiting' | 'completed'
const error = ref('');
const dashboardRefreshing = ref(false);
const lastRefreshedAt = ref(null);
const money = (v) => Number(v || 0).toLocaleString('ko-KR', { maximumFractionDigits: 0 });
function formatDT(dt) {
  if (!dt) return '-';
  const d = new Date(dt);
  const p = n => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth()+1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
}

const lineupPeriod = ref('daily');
const lineupDate   = ref(new Date());

const lineupDateLabel = computed(() => {
  const d = lineupDate.value;
  const y = d.getFullYear(), m = d.getMonth() + 1, day = d.getDate();
  if (lineupPeriod.value === 'all')    return '전체';
  if (lineupPeriod.value === 'daily')  return `${y}년 ${m}월 ${day}일`;
  if (lineupPeriod.value === 'monthly') return `${y}년 ${m}월`;
  return `${y}년`;
});

const lineupDateParam = computed(() => {
  const d = lineupDate.value;
  const p = n => String(n).padStart(2, '0');
  const y = d.getFullYear(), m = p(d.getMonth() + 1);
  if (lineupPeriod.value === 'daily')   return `${y}-${m}-${p(d.getDate())}`;
  if (lineupPeriod.value === 'monthly') return `${y}-${m}`;
  return `${y}`;
});

const lineupSelectedDate = computed(() => {
  const d = lineupDate.value;
  const p = n => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth()+1)}-${p(d.getDate())}`;
});

function prevPeriod() {
  if (lineupPeriod.value === 'all') return;
  const d = new Date(lineupDate.value);
  if (lineupPeriod.value === 'daily')   d.setDate(d.getDate() - 1);
  else if (lineupPeriod.value === 'monthly') d.setMonth(d.getMonth() - 1);
  else d.setFullYear(d.getFullYear() - 1);
  lineupDate.value = d;
}
function nextPeriod() {
  if (lineupPeriod.value === 'all') return;
  const d = new Date(lineupDate.value);
  if (lineupPeriod.value === 'daily')   d.setDate(d.getDate() + 1);
  else if (lineupPeriod.value === 'monthly') d.setMonth(d.getMonth() + 1);
  else d.setFullYear(d.getFullYear() + 1);
  lineupDate.value = d;
}
function onCalendarSelect(dateStr) {
  if (dateStr) lineupDate.value = new Date(dateStr);
}

async function reloadDealers() {
  try {
    const dashboard = await request(api.get(`/dashboard/distributor?period=${lineupPeriod.value}&date=${lineupDateParam.value}`));
    data.dashboard = dashboard;
  } catch (err) { error.value = err.message; }
}
watch([lineupPeriod, lineupDate], reloadDealers);

async function refreshDashboard() {
  dashboardRefreshing.value = true;
  try {
    await loadAll();
    await reloadDealers();
  } finally {
    dashboardRefreshing.value = false;
  }
}
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

// ── 총판 자체 발주서 ──────────────────────────────────
const selfForm = reactive({ delivery_address: '', payment_terms: '', note: '', items: [] });
const selfToday = new Date().toLocaleDateString('ko-KR');
const selfSupplyAmount = computed(() => selfForm.items.reduce((s, i) => s + Number(i.quantity || 0) * Number(i.unit_price || 0), 0));
const selfVatAmount    = computed(() => Math.floor(selfSupplyAmount.value * 0.1));
const selfGrandTotal   = computed(() => selfSupplyAmount.value + selfVatAmount.value);

function selfProductById(id) { return data.products.find(p => p.id === Number(id)); }
function selfAddItem() {
  const p = data.products[0];
  if (p) selfForm.items.push({ product_id: p.id, quantity: 1, unit_price: Number(p.base_price) });
}
function selfRemoveItem(i) { selfForm.items.splice(i, 1); }
function selfSyncProduct(item) {
  const p = selfProductById(item.product_id);
  if (p) item.unit_price = Number(p.base_price);
}

async function submitSelfOrder() {
  const confirmed = await confirmAction({
    title: '발주서 전송',
    message: `총 ${money(selfGrandTotal.value)}원의 발주서를 제조사에 전송하시겠습니까?`,
    confirmText: '발주 전송'
  });
  if (!confirmed) return;
  try {
    await request(api.post('/orders/self', selfForm), { successMessage: '발주서가 제조사로 전송되었습니다.' });
    Object.assign(selfForm, { delivery_address: '', payment_terms: '', note: '', items: [] });
    if (data.products.length) {
      selfForm.items.push({ product_id: data.products[0].id, quantity: 1, unit_price: Number(data.products[0].base_price) });
    }
    await loadAll();
  } catch (err) {
    error.value = err.message;
  }
}

// 총판이 제조사에 보낸 자체 발주만 골라냄 (dealer_id === distributor_id === 본인)
const selfOrders = computed(() => data.orders.filter(o => o.dealer_id === o.distributor_id));
const selfSelectedDate = ref(null);
const filteredSelfOrders = computed(() => {
  if (!selfSelectedDate.value) return selfOrders.value;
  return selfOrders.value.filter(o => o.ordered_at?.slice(0, 10) === selfSelectedDate.value);
});

// ── 수주현황 분류 ─────────────────────────────────────
const orderWaiting   = computed(() => data.orders.filter(o => ['PENDING', 'RECEIVED'].includes(o.status)));
const orderConverted = computed(() => data.orders.filter(o => ['CONVERTED', 'CONFIRMED', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED'].includes(o.status)));
const orderCancelled = computed(() => data.orders.filter(o => o.status === 'CANCELLED'));
const orderCompletedRows = computed(() => data.orders.filter(o => !['PENDING', 'RECEIVED'].includes(o.status)));
const shipmentsWaiting  = computed(() => data.shipments.filter(s => !s.received_at));
const shipmentsReceived = computed(() => data.shipments.filter(s => !!s.received_at));
const shipmentTab = ref('waiting'); // 'waiting' | 'received'

function matchFilterGroup(entries, actual) {
  return entries.some((e) => e.mode === 'text'
    ? String(actual ?? '').toLowerCase().includes(String(e.value).toLowerCase())
    : actual === e.value);
}

// ── 입고 완료 내역 검색 필터 (판매현황 필터와 동일한 UI 패턴) ──
const receivedFilterCategories = [
  { key: 'month',  label: '월' },
  { key: 'model',  label: '모델' },
  { key: 'dealer', label: '대리점' },
];
const receivedFilterCategory = ref('month');
const receivedActiveFilters = ref([]);

const receivedFilterOptions = computed(() => {
  const unique = (mapper) => [...new Set(shipmentsReceived.value.flatMap(mapper).filter(v => v !== null && v !== undefined && v !== ''))];
  return {
    months: unique(s => [s.shipped_at?.slice(0, 7)]).sort().reverse(),
    models: unique(s => s.items.map(i => i.model_name)).sort(),
    dealers: unique(s => [s.dealer_company]).sort()
  };
});

const receivedFilterValueOptions = computed(() => {
  const opts = receivedFilterOptions.value;
  switch (receivedFilterCategory.value) {
    case 'month':  return opts.months.map(v => ({ value: v, display: v }));
    case 'model':  return opts.models.map(v => ({ value: v, display: v }));
    case 'dealer': return opts.dealers.map(v => ({ value: v, display: v }));
    default:       return [];
  }
});

function addReceivedFilter(value) {
  if (!value) return;
  const cat = receivedFilterCategories.find(c => c.key === receivedFilterCategory.value);
  const opt = receivedFilterValueOptions.value.find(o => o.value === value);
  const mode = opt ? 'exact' : 'text';
  if (receivedActiveFilters.value.some(f => f.key === receivedFilterCategory.value && f.mode === mode && f.value === value)) return;
  receivedActiveFilters.value.push({ key: receivedFilterCategory.value, categoryLabel: cat.label, value, displayValue: opt?.display || value, mode });
}

function removeReceivedFilter(index) {
  receivedActiveFilters.value.splice(index, 1);
}

function resetReceivedFilters() {
  receivedActiveFilters.value = [];
}

const filteredShipmentsReceived = computed(() => {
  if (!receivedActiveFilters.value.length) return shipmentsReceived.value;
  const groups = {};
  for (const f of receivedActiveFilters.value) {
    (groups[f.key] = groups[f.key] || []).push({ value: f.value, mode: f.mode });
  }
  return shipmentsReceived.value.filter(s => {
    for (const [key, entries] of Object.entries(groups)) {
      if (key === 'month') { if (!matchFilterGroup(entries, s.shipped_at?.slice(0, 7))) return false; }
      else if (key === 'model') { if (!s.items.some(i => matchFilterGroup(entries, i.model_name))) return false; }
      else if (key === 'dealer') { if (!matchFilterGroup(entries, s.dealer_company)) return false; }
    }
    return true;
  });
});

async function copyTracking(trackingNumber) {
  await navigator.clipboard.writeText(trackingNumber);
  notify('운송장번호가 복사되었습니다.');
}

// ── 수주현황 전환 완료 목록 검색 필터 (판매현황 필터와 동일한 UI 패턴) ──
const completedFilterCategories = [
  { key: 'month',  label: '전환월' },
  { key: 'model',  label: '모델' },
  { key: 'dealer', label: '대리점' },
  { key: 'amount', label: '금액' },
];
const completedFilterCategory = ref('month');
const completedActiveFilters = ref([]);

const completedFilterOptions = computed(() => {
  const unique = (mapper) => [...new Set(orderCompletedRows.value.flatMap(mapper).filter(v => v !== null && v !== undefined && v !== ''))];
  return {
    months: unique(o => [o.converted_at?.slice(0, 7)]).sort().reverse(),
    models: unique(o => o.items.map(i => i.model_name)).sort(),
    dealers: unique(o => [o.dealer_company]).sort(),
    amounts: unique(o => [String(Number(o.total_amount || 0))]).sort((a, b) => Number(a) - Number(b))
  };
});

const completedFilterValueOptions = computed(() => {
  const opts = completedFilterOptions.value;
  switch (completedFilterCategory.value) {
    case 'month':  return opts.months.map(v => ({ value: v, display: v }));
    case 'model':  return opts.models.map(v => ({ value: v, display: v }));
    case 'dealer': return opts.dealers.map(v => ({ value: v, display: v }));
    case 'amount': return opts.amounts.map(v => ({ value: v, display: money(v) + '원' }));
    default:       return [];
  }
});

function addCompletedFilter(value) {
  if (!value) return;
  const cat = completedFilterCategories.find(c => c.key === completedFilterCategory.value);
  const opt = completedFilterValueOptions.value.find(o => o.value === value);
  const mode = opt ? 'exact' : 'text';
  if (completedActiveFilters.value.some(f => f.key === completedFilterCategory.value && f.mode === mode && f.value === value)) return;
  completedActiveFilters.value.push({ key: completedFilterCategory.value, categoryLabel: cat.label, value, displayValue: opt?.display || value, mode });
}

function removeCompletedFilter(index) {
  completedActiveFilters.value.splice(index, 1);
}

function resetCompletedFilters() {
  completedActiveFilters.value = [];
}

const filteredCompletedOrders = computed(() => {
  if (!completedActiveFilters.value.length) return orderCompletedRows.value;
  const groups = {};
  for (const f of completedActiveFilters.value) {
    (groups[f.key] = groups[f.key] || []).push({ value: f.value, mode: f.mode });
  }
  return orderCompletedRows.value.filter(order => {
    for (const [key, entries] of Object.entries(groups)) {
      if (key === 'month') { if (!matchFilterGroup(entries, order.converted_at?.slice(0, 7))) return false; }
      else if (key === 'model') { if (!order.items.some(i => matchFilterGroup(entries, i.model_name))) return false; }
      else if (key === 'dealer') { if (!matchFilterGroup(entries, order.dealer_company)) return false; }
      else if (key === 'amount') { if (!matchFilterGroup(entries, String(Number(order.total_amount || 0)))) return false; }
    }
    return true;
  });
});

// ── 판매현황 필터 ─────────────────────────────────────
const filterCategories = [
  { key: 'month',     label: '월' },
  { key: 'model',     label: '모델' },
  { key: 'dealer',    label: '매장' },
  { key: 'unitPrice', label: '단가' },
  { key: 'amount',    label: '금액' },
  { key: 'status',    label: '상태' },
];
const filterCategory = ref('month');
const activeFilters = ref([]);

const salesFilterOptions = computed(() => {
  const unique = (mapper) => [...new Set(data.sales.map(mapper).filter(v => v !== null && v !== undefined && v !== ''))];
  return {
    months:     unique(r => r.date?.slice(0, 7)).sort().reverse(),
    models:     unique(r => r.model_name).sort(),
    dealers:    unique(r => r.dealer_company).sort(),
    unitPrices: unique(r => String(Number(r.unit_price || 0))).sort((a, b) => Number(a) - Number(b)),
    amounts:    unique(r => String(Number(r.amount || 0))).sort((a, b) => Number(a) - Number(b)),
  };
});

const filterValueOptions = computed(() => {
  const opts = salesFilterOptions.value;
  switch (filterCategory.value) {
    case 'month':     return opts.months.map(v => ({ value: v, display: v }));
    case 'model':     return opts.models.map(v => ({ value: v, display: v }));
    case 'dealer':    return opts.dealers.map(v => ({ value: v, display: v }));
    case 'unitPrice': return opts.unitPrices.map(v => ({ value: v, display: money(v) + '원' }));
    case 'amount':    return opts.amounts.map(v => ({ value: v, display: money(v) + '원' }));
    case 'status':    return ['출고 전', '출고 완료'].map(v => ({ value: v, display: v }));
    default: return [];
  }
});

const filteredSales = computed(() => {
  if (!activeFilters.value.length) return data.sales;
  const groups = {};
  for (const f of activeFilters.value) (groups[f.key] = groups[f.key] || []).push({ value: f.value, mode: f.mode });
  return data.sales.filter(row => {
    for (const [key, entries] of Object.entries(groups)) {
      let v;
      if (key === 'month')     v = row.date?.slice(0, 7);
      else if (key === 'model')     v = row.model_name;
      else if (key === 'dealer')    v = row.dealer_company;
      else if (key === 'unitPrice') v = String(Number(row.unit_price || 0));
      else if (key === 'amount')    v = String(Number(row.amount || 0));
      else if (key === 'status')    v = shipmentStatusLabel(row.status);
      if (!matchFilterGroup(entries, v)) return false;
    }
    return true;
  });
});

const filteredMonthlySales = computed(() => {
  const year = new Date().getFullYear();
  const byMonth = new Map();
  for (let m = 1; m <= 12; m++) {
    const key = `${year}-${String(m).padStart(2, '0')}`;
    byMonth.set(key, { month: key, quantity: 0, amount: 0 });
  }
  for (const row of filteredSales.value) {
    const month = row.date?.slice(0, 7);
    if (!month || !byMonth.has(month)) continue;
    const cur = byMonth.get(month);
    cur.quantity += Number(row.quantity || 0);
    cur.amount += Number(row.amount || 0);
  }
  return [...byMonth.values()];
});

// 판매 상세 내역: 모델별로 다 풀어서 보여주는 대신 발주서 단위로 묶고, 펼치면 그 발주서의
// 모델별 품목이 아래에 나온다. 필터에 걸리는 모델이 하나라도 있으면 그 발주서 전체를 보여준다.
const expandedSalesOrders = ref(new Set());
function toggleSalesOrder(orderId) {
  const next = new Set(expandedSalesOrders.value);
  if (next.has(orderId)) next.delete(orderId);
  else next.add(orderId);
  expandedSalesOrders.value = next;
}
const groupedSales = computed(() => {
  const matchingOrderIds = new Set(filteredSales.value.map(r => r.order_id));
  const map = new Map();
  for (const row of data.sales) {
    if (!matchingOrderIds.has(row.order_id)) continue;
    if (!map.has(row.order_id)) {
      map.set(row.order_id, {
        order_id: row.order_id,
        date: row.date,
        status: row.status,
        dealer_company: row.dealer_company,
        items: [],
        totalAmount: 0,
        totalQuantity: 0,
        totalUnitPrice: 0
      });
    }
    const group = map.get(row.order_id);
    group.items.push(row);
    group.totalAmount += Number(row.amount || 0);
    group.totalQuantity += Number(row.quantity || 0);
    group.totalUnitPrice += Number(row.unit_price || 0);
  }
  return [...map.values()];
});

// 판매현황에서는 "출고 완료"/"출고 전" 두 가지로만 단순하게 보여준다(세부 상태는 수주현황에서 확인).
function shipmentStatusLabel(status) {
  return ['SHIPPED', 'DELIVERED'].includes(status) ? '출고 완료' : '출고 전';
}
function shipmentStatusClass(status) {
  return ['SHIPPED', 'DELIVERED'].includes(status) ? 's-SHIPPED' : 's-CONFIRMED';
}

function addFilter(value) {
  if (!value) return;
  const cat = filterCategories.find(c => c.key === filterCategory.value);
  const opt = filterValueOptions.value.find(o => o.value === value);
  const mode = opt ? 'exact' : 'text';
  if (activeFilters.value.some(f => f.key === filterCategory.value && f.mode === mode && f.value === value)) return;
  activeFilters.value.push({ key: filterCategory.value, categoryLabel: cat.label, value, displayValue: opt?.display || value, mode });
}
function removeFilter(index) { activeFilters.value.splice(index, 1); }
function resetSalesFilters() { activeFilters.value = []; }

// 수주(대리점 발주) 명세 수정 모달에서는 원가가 아니라 총판이 설정한 판매가를 단가로 써야 한다.
const sellProducts = computed(() => data.prices
  .filter((p) => p.price != null)
  .map((p) => ({ id: p.id, name: p.name, model_name: p.model_name, spec: p.spec, base_price: Number(p.price) }))
);

// 재고현황 금액 계산용: 제품별 총판 판매가 (미설정 제품은 없음)
const distributorPriceByProductId = computed(() => Object.fromEntries(
  data.prices.filter((p) => p.price != null).map((p) => [p.id, Number(p.price)])
));

function openOrderById(orderId) {
  const order = data.orders.find(o => o.id === orderId);
  if (order) openOrder(order);
}

// ── 설정 ──────────────────────────────────────────────
const settingsTab = ref('profile');
const myForm = reactive({
  company_name: '', business_number: '', business_type: '', business_item: '', company_phone: '', fax: '', address: '', addressDetail: '', password: '', passwordConfirm: '',
  manager_name: '', manager_department: '', manager_phone: '', manager_email: ''
});

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
    passwordConfirm: '',
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
      company_phone: myForm.company_phone,
      fax: myForm.fax, address: myForm.address, address_detail: myForm.addressDetail,
      manager_name: myForm.manager_name, manager_department: myForm.manager_department,
      manager_phone: myForm.manager_phone, manager_email: myForm.manager_email
    };
    if (myForm.password) payload.password = myForm.password;
    await request(api.patch('/users/me', payload), { successMessage: '계정 정보가 수정되었습니다.' });
    await auth.loadMe();
    myForm.password = '';
    myForm.passwordConfirm = '';
  } catch (err) { error.value = err.message; }
}

// ── 회사 로고: 헤더/발주서/거래명세서 등에 쓸 자사 로고를 직접 등록. 등록 안 하면 공란으로 표시 ──
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

watch(view, (v) => {
  activeFilters.value = [];
  if (v === 'order' && !selfForm.items.length && data.products.length) {
    selfForm.items.push({ product_id: data.products[0].id, quantity: 1, unit_price: Number(data.products[0].base_price) });
  }
});

const closeDropdown = () => {};
let autoRefreshTimer = null;
onUnmounted(() => {
  if (autoRefreshTimer) clearInterval(autoRefreshTimer);
});

const canManageMembers = computed(() => !!(auth.user?.is_owner || auth.user?.is_member_manager));

async function loadAll() {
  error.value = '';
  try {
    const [dashboard, orders, products, prices, inventory, shipments, salesData, staff, pendingStaff, dealers] = await Promise.all([
      request(api.get('/dashboard/distributor')),
      request(api.get('/orders/distributor')),
      request(api.get('/products')),
      request(api.get('/distributor-prices')),
      request(api.get('/inventory/distributor')),
      request(api.get('/shipments')),
      request(api.get('/sales')),
      canManageMembers.value ? request(api.get('/users')) : Promise.resolve({ users: [] }),
      canManageMembers.value ? request(api.get('/users/pending')) : Promise.resolve({ users: [] }),
      request(api.get('/users/my-dealers'))
    ]);
    data.dashboard = dashboard;
    data.orders = orders.orders;
    data.products = products.products;
    data.prices = prices.prices.map((p) => ({ ...p, _price: p._price ?? p.price ?? null }));
    data.inventory = inventory.inventory;
    data.shipments = shipments.shipments;
    data.sales = salesData.sales;
    data.monthlySales = salesData.monthly;
    data.staff = staff.users;
    data.pendingStaff = pendingStaff.users;
    data.dealers = dealers.dealers;
    lastRefreshedAt.value = new Date();
  } catch (err) {
    error.value = err.message;
  }
}

async function savePrice(row) {
  const price = Math.trunc(Number(row._price));
  if (!Number.isInteger(price) || price <= 0) {
    notify('판매가는 0보다 큰 정수로 입력해주세요.', 'error');
    return;
  }
  try {
    await request(api.put(`/distributor-prices/${row.id}`, { price }), { successMessage: '판매가가 저장되었습니다.' });
    await loadAll();
  } catch (err) {
    error.value = err.message;
  }
}

// ── 회원관리 (총판 소속 직원) ──
const memberStatusFilter = ref('active'); // 'active' | 'inactive' | 'rejected'
const filteredStaff = computed(() => data.staff.filter((u) => u.status === memberStatusFilter.value));
const staffCounts = computed(() => ({
  active: data.staff.filter((u) => u.status === 'active').length,
  inactive: data.staff.filter((u) => u.status === 'inactive').length,
  rejected: data.staff.filter((u) => u.status === 'rejected').length
}));

const selectedStaff = ref(null);
const staffEditForm = reactive({
  name: '', phone: '', address: '', status: 'active', password: '', passwordConfirm: '',
  manager_name: '', manager_department: '', manager_position: '', manager_phone: '', manager_email: '', manager_memo: ''
});

function selectStaff(user) {
  selectedStaff.value = user;
  Object.assign(staffEditForm, {
    name: user.name, phone: user.phone || '', address: user.address || '', status: user.status,
    password: '', passwordConfirm: '',
    manager_name: user.manager_name || '', manager_department: user.manager_department || '',
    manager_position: user.manager_position || '', manager_phone: user.manager_phone || '',
    manager_email: user.manager_email || '', manager_memo: user.manager_memo || ''
  });
}

async function approveStaff(user) {
  try {
    await request(api.post(`/users/${user.id}/approve`), { successMessage: '승인되었습니다.' });
    await loadAll();
  } catch (err) { error.value = err.message; }
}

async function rejectStaff(user) {
  const confirmed = await confirmAction({
    title: '가입 거부', message: `${user.name}(${user.username}) 가입을 거부하시겠습니까?`,
    confirmText: '거부', danger: true
  });
  if (!confirmed) return;
  try {
    await request(api.post(`/users/${user.id}/reject`), { successMessage: '거부 처리되었습니다.' });
    await loadAll();
  } catch (err) { error.value = err.message; }
}

async function unrejectStaff(user) {
  try {
    await request(api.post(`/users/${user.id}/unreject`), { successMessage: '거부가 해제되었습니다.' });
    await loadAll();
  } catch (err) { error.value = err.message; }
}

async function saveStaff() {
  if (!selectedStaff.value) return;
  if (staffEditForm.password && staffEditForm.password !== staffEditForm.passwordConfirm) {
    notify('비밀번호가 일치하지 않습니다.', 'error');
    return;
  }
  const payload = {
    name: staffEditForm.name, phone: staffEditForm.phone, address: staffEditForm.address, status: staffEditForm.status,
    manager_name: staffEditForm.manager_name, manager_department: staffEditForm.manager_department,
    manager_position: staffEditForm.manager_position, manager_phone: staffEditForm.manager_phone,
    manager_email: staffEditForm.manager_email, manager_memo: staffEditForm.manager_memo
  };
  if (staffEditForm.password) payload.password = staffEditForm.password;
  try {
    const { user } = await request(api.patch(`/users/${selectedStaff.value.id}`, payload), { successMessage: '저장되었습니다.' });
    selectedStaff.value = user;
    await loadAll();
  } catch (err) { error.value = err.message; }
}

const deleteModalOpen = ref(false);
async function onStaffDeleted() {
  deleteModalOpen.value = false;
  selectedStaff.value = null;
  await loadAll();
}

async function toggleStaffManager(user, checked) {
  const confirmed = await confirmAction({
    title: checked ? '담당자 지정' : '담당자 해제',
    message: checked
      ? `${user.name}(${user.username})님을 담당자로 지정하시겠습니까?\n회원관리 화면에 접근할 수 있게 됩니다.`
      : `${user.name}(${user.username})님의 담당자 권한을 해제하시겠습니까?`,
    confirmText: checked ? '지정' : '해제', danger: !checked
  });
  if (!confirmed) return;
  try {
    const { user: updated } = await request(
      api.patch(`/users/${user.id}/member-manager`, { is_member_manager: checked }),
      { successMessage: checked ? '담당자로 지정되었습니다.' : '담당자 권한이 해제되었습니다.' }
    );
    if (selectedStaff.value?.id === updated.id) selectedStaff.value = updated;
    await loadAll();
  } catch (err) { error.value = err.message; }
}

// ── 설정 > 담당자 설정: 드롭다운으로 검색/선택해서 담당자 지정, 아래에 지정된 담당자 목록 표시 ──
const staffManagerList = computed(() => data.staff.filter((u) => u.is_member_manager));
const staffCandidateList = computed(() => data.staff.filter((u) => !u.is_owner && !u.is_member_manager && u.status === 'active'));

function openOrder(order) {
  editing.value = {
    ...order,
    items: order.items.map((item) => ({
      ...item,
      product_id: item.product_id,
      quantity: Number(item.quantity),
      unit_price: Number(item.unit_price)
    }))
  };
}

async function saveEdit() {
  try {
    const orderId = editing.value.id;
    await request(api.patch(`/orders/${orderId}`, editing.value), { successMessage: '수주 내용이 수정되었습니다.' });
    await loadAll();
    // 모달 닫지 않고 갱신된 데이터로 유지
    const updated = data.orders.find(o => o.id === orderId);
    if (updated) {
      editing.value = {
        ...updated,
        items: updated.items.map(item => ({
          ...item,
          product_id: item.product_id,
          quantity: Number(item.quantity),
          unit_price: Number(item.unit_price)
        }))
      };
    } else {
      editing.value = null;
    }
  } catch (err) {
    error.value = err.message;
  }
}

// 총판→대리점 거래명세서. unit_price(대리점에게 받는 총판 판매가)를 그대로 쓴다 — 전환 시 스냅샷되는
// manufacturer_unit_price(제조사→총판 가격)와는 다른 값이라 여기서는 건드리지 않는다.
function myCompanyInfoMissing() {
  const u = auth.user;
  return !u?.business_number || !u?.ceo_name || !u?.address || !u?.phone || !u?.fax;
}
async function previewStatementForOrder(order) {
  if (myCompanyInfoMissing()) {
    const goToSettings = await confirmAction({
      title: '거래명세서 정보 미입력',
      message: '거래명세서에 표시할 등록번호·대표자·주소·전화·팩스 정보가 설정에 입력되어 있지 않습니다.\n설정 > 계정정보에서 입력해주세요.',
      confirmText: '정보 등록 바로가기',
      cancelText: '확인'
    });
    if (goToSettings) {
      editing.value = null;
      router.push('/distributor/settings');
      settingsTab.value = 'profile';
    }
    return;
  }
  const shipmentsForOrder = data.shipments
    .filter((s) => s.order_id === order.id && s.items?.length)
    .slice()
    .sort((a, b) => new Date(a.shipped_at) - new Date(b.shipped_at));

  if (!shipmentsForOrder.length) {
    if (!['CONFIRMED', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED'].includes(order.status)) {
      notify('아직 발주가 확정되지 않아 거래명세서를 만들 수 없습니다.', 'error');
      return;
    }
    statementPreview.value = {
      order,
      perspective: 'distributor',
      pages: [{
        items: order.items.map((oi) => ({
          product_name: oi.product_name,
          model_name: oi.model_name,
          quantity: oi.quantity,
          unit_price: Number(oi.unit_price)
        })),
        meta: {
          delivery_address: order.delivery_address || order.dealer_address || ''
        }
      }]
    };
    return;
  }

  const pages = shipmentsForOrder.map((shipment) => ({
    items: shipment.items.map((si) => {
      const orderItem = order.items.find((oi) => oi.id === si.order_item_id);
      return {
        product_name: si.product_name,
        model_name: si.model_name,
        quantity: si.quantity,
        unit_price: orderItem ? Number(orderItem.unit_price) : 0
      };
    }),
    meta: {
      delivery_address: shipment.delivery_address || order.dealer_address || '',
      tracking_number: shipment.tracking_number || '',
      carrier_code: shipment.carrier_code || '',
      shipment_number: shipment.shipment_number,
      shipped_at: shipment.shipped_at
    }
  }));
  statementPreview.value = { order, perspective: 'distributor', pages };
}

// 제조사→총판 거래명세서. 총판은 이 거래의 매입자이므로 자신이 받는 거래명세서도 볼 수 있어야 한다.
// manufacturer_unit_price(발주 전환 시점의 제조사 판매가 스냅샷)를 쓴다 — AdminPage.vue의 로직과 동일.
function previewPurchaseStatementForOrder(order) {
  const shipmentsForOrder = data.shipments
    .filter((s) => s.order_id === order.id && s.items?.length)
    .slice()
    .sort((a, b) => new Date(a.shipped_at) - new Date(b.shipped_at));

  if (!shipmentsForOrder.length) {
    if (!['CONFIRMED', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED'].includes(order.status)) {
      notify('아직 발주가 확정되지 않아 거래명세서를 만들 수 없습니다.', 'error');
      return;
    }
    statementPreview.value = {
      order,
      perspective: 'manufacturer',
      pages: [{
        items: order.items.map((oi) => ({
          product_name: oi.product_name,
          model_name: oi.model_name,
          quantity: oi.quantity,
          unit_price: Number(oi.manufacturer_unit_price ?? oi.unit_price)
        })),
        meta: {
          delivery_address: order.delivery_address || order.distributor_address || ''
        }
      }]
    };
    return;
  }

  const pages = shipmentsForOrder.map((shipment) => ({
    items: shipment.items.map((si) => {
      const orderItem = order.items.find((oi) => oi.id === si.order_item_id);
      return {
        product_name: si.product_name,
        model_name: si.model_name,
        quantity: si.quantity,
        unit_price: orderItem ? Number(orderItem.manufacturer_unit_price ?? orderItem.unit_price) : 0
      };
    }),
    meta: {
      delivery_address: shipment.delivery_address || order.distributor_address || '',
      tracking_number: shipment.tracking_number || '',
      carrier_code: shipment.carrier_code || '',
      shipment_number: shipment.shipment_number,
      shipped_at: shipment.shipped_at
    }
  }));
  statementPreview.value = { order, perspective: 'manufacturer', pages };
}

async function convert(order) {
  const confirmed = await confirmAction({
    title: '발주 전환',
    message: `발주서 ${order.order_number}을 관리자에게 전환하시겠습니까?\n전환 후에는 내용을 수정할 수 없습니다.`,
    confirmText: '발주 전환'
  });
  if (!confirmed) return false;
  try {
    await request(api.post(`/orders/${order.id}/convert`), { successMessage: '발주서가 관리자에게 전환되었습니다.' });
    await loadAll();
    return true;
  } catch (err) {
    error.value = err.message;
    return false;
  }
}
const editingCanConvert = computed(() => ['PENDING', 'RECEIVED'].includes(editing.value?.status));
async function convertFromModal() {
  const ok = await convert(editing.value);
  if (ok) editing.value = null;
}

// 총판은 자체 재고를 갖지 않고 제조사(본사) 재고를 그대로 조회만 함 (재고현황 = 읽기 전용)

async function receiveShipment(shipment) {
  const confirmed = await confirmAction({
    title: '입고 확인',
    message: `출고번호 ${shipment.shipment_number}의 상품을 입고 확인하시겠습니까?\n확인 후에는 다시 처리할 수 없습니다.`,
    confirmText: '입고 확인'
  });
  if (!confirmed) return;
  try {
    await request(api.post(`/shipments/${shipment.id}/receive`), { successMessage: '입고 확인이 완료되었습니다.' });
    await loadAll();
  } catch (err) {
    error.value = err.message;
  }
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
  // loadAll()의 /dashboard/distributor 호출은 기간 파라미터가 없어 서버 기본값(월별)로 응답하는데,
  // lineupPeriod의 초기값(일별)과 어긋나 버튼은 "일별"인데 실제 데이터는 월별로 보이는 문제가 있었음.
  // reloadDealers()로 실제 선택된 기간에 맞춰 한 번 더 맞춰준다.
  loadAll().then(reloadDealers);
  if (!window.daum?.Postcode) {
    const script = document.createElement('script');
    script.src = 'https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js';
    document.head.appendChild(script);
  }
  autoRefreshTimer = setInterval(refreshDashboard, 60000);
});
</script>

<template>
  <AppShell :title="viewTitles[view] || '총판 대시보드'" :menu="menu" :refreshing="dashboardRefreshing"
    :last-refreshed="lastRefreshedAt" @refresh="refreshDashboard">
    <p v-if="error" class="error">{{ error }}</p>

    <!-- 설정 -->
    <template v-if="view === 'settings'">
      <section class="panel">
        <h2>설정</h2>
        <div class="settings-layout">
          <aside class="settings-subnav">
            <button :class="{ active: settingsTab === 'profile' }" @click="settingsTab = 'profile'">
              <strong>계정 정보</strong>
              <span>회사 기본 정보 수정</span>
            </button>
            <button v-if="auth.user?.is_owner" :class="{ active: settingsTab === 'managers' }" @click="settingsTab = 'managers'">
              <strong>담당자 설정</strong>
              <span>회원관리 담당자 지정</span>
            </button>
            <button :class="{ active: settingsTab === 'prices' }" @click="settingsTab = 'prices'">
              <strong>제품관리</strong>
              <span>대리점 발주 판매가 설정</span>
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
                    <p class="text-muted">헤더, 발주서, 거래명세서 등 로고가 쓰이는 화면에 표시됩니다. 등록하지 않으면 빈 칸으로 보여집니다.</p>
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
                <div class="settings-section-head" style="margin-top:8px">
                  <div>
                    <h3 style="margin:0">회원 정보</h3>
                    <p class="text-muted">현재 로그인한 계정 본인의 연락처를 입력합니다.</p>
                  </div>
                </div>
                <label>이름<input v-model="myForm.manager_name" placeholder="이름" /></label>
                <label>부서<input v-model="myForm.manager_department" placeholder="소속 부서" /></label>
                <label>연락처<input :value="myForm.manager_phone" @input="myForm.manager_phone = formatPhone($event.target.value)" placeholder="숫자만 입력" maxlength="14" /></label>
                <label>이메일<input v-model="myForm.manager_email" type="email" placeholder="example@company.com" /></label>
              </div>
              <div class="member-edit-actions">
                <button class="primary" type="submit">계정 정보 저장</button>
              </div>
            </form>
            <div v-else-if="settingsTab === 'managers'" class="settings-contacts">
              <div class="settings-section-head">
                <div>
                  <h3>담당자 설정</h3>
                  <p class="text-muted">회원관리 화면에 접근할 수 있는 담당자를 지정합니다.</p>
                </div>
              </div>

              <div class="settings-manager-group">
                <h4>담당자</h4>
                <table class="member-table">
                  <thead><tr><th style="width:90px">이름</th><th style="width:120px">아이디</th><th>부서</th><th style="width:130px">연락처</th><th style="width:80px">처리</th></tr></thead>
                  <tbody>
                    <tr v-for="u in staffManagerList" :key="u.id">
                      <td>{{ u.name }}</td>
                      <td>{{ u.username }}</td>
                      <td>{{ u.manager_department || '-' }}</td>
                      <td>{{ u.manager_phone || u.phone || '-' }}</td>
                      <td><button class="btn-danger" @click="toggleStaffManager(u, false)">해제</button></td>
                    </tr>
                    <tr v-if="!staffManagerList.length"><td colspan="5" class="empty-row">지정된 담당자가 없습니다.</td></tr>
                  </tbody>
                </table>
              </div>

              <div class="settings-manager-group">
                <h4>직원 목록</h4>
                <table class="member-table">
                  <thead><tr><th style="width:90px">이름</th><th style="width:120px">아이디</th><th>부서</th><th style="width:130px">연락처</th><th style="width:80px">처리</th></tr></thead>
                  <tbody>
                    <tr v-for="u in staffCandidateList" :key="u.id">
                      <td>{{ u.name }}</td>
                      <td>{{ u.username }}</td>
                      <td>{{ u.manager_department || '-' }}</td>
                      <td>{{ u.manager_phone || u.phone || '-' }}</td>
                      <td><button @click="toggleStaffManager(u, true)">지정</button></td>
                    </tr>
                    <tr v-if="!staffCandidateList.length"><td colspan="5" class="empty-row">직원이 없습니다.</td></tr>
                  </tbody>
                </table>
              </div>
            </div>
            <div v-else-if="settingsTab === 'prices'" class="settings-products">
              <div class="settings-section-head">
                <div>
                  <h3>제품관리</h3>
                  <p class="text-muted">대리점에게 발주받을 판매가를 설정합니다. 판매가를 설정하지 않은 제품은 대리점이 발주할 수 없습니다.</p>
                </div>
              </div>
              <div class="panel-table-wrap">
                <table>
                  <thead><tr><th style="width:44px">No.</th><th style="width:160px">제품명</th><th style="width:110px">모델</th><th style="width:140px">규격</th><th style="width:100px;text-align:right">원가</th><th style="text-align:right;width:200px">판매가</th><th style="width:90px;text-align:right">마진</th><th style="width:70px"></th></tr></thead>
                  <tbody>
                    <tr v-for="(row, index) in data.prices" :key="row.id" :class="{ 'row-warn': !row.price }">
                      <td>{{ index + 1 }}</td>
                      <td>{{ row.name }}</td>
                      <td>{{ row.model_name }}</td>
                      <td>{{ row.spec || '-' }}</td>
                      <td style="text-align:right">{{ money(row.base_price) }}</td>
                      <td style="text-align:right">
                        <PriceInput v-model="row._price" placeholder="미설정" style="width:110px;text-align:right" />
                      </td>
                      <td style="text-align:right">
                        {{ row.price ? money(Number(row.price) - Number(row.base_price)) : '-' }}
                      </td>
                      <td><button @click="savePrice(row)">저장</button></td>
                    </tr>
                    <tr v-if="!data.prices.length"><td colspan="8" class="empty-row">등록된 제품이 없습니다.</td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </section>
    </template>

    <!-- 발주서 -->
    <template v-else-if="view === 'order'">
      <div class="dealer-layout">

        <!-- 1열: 달력 -->
        <aside class="dealer-col-left">
          <MiniCalendar
            :marked-dates="selfOrders.map(o => o.ordered_at)"
            :selected-date="selfSelectedDate"
            @select="selfSelectedDate = $event"
          />
        </aside>

        <!-- 2열: 발주서 -->
        <form class="order-doc" @submit.prevent="submitSelfOrder">

        <!-- 헤더 -->
        <div class="odoc-header">
          <div>
            <h2 class="odoc-title">발 주 서</h2>
            <div class="odoc-meta">
              <span>발주일자</span><em>{{ selfToday }}</em>
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
              <tr><td>상호</td><td>AT GLOBAL</td></tr>
              <tr><td>담당자</td><td>제조사 담당자</td></tr>
            </table>
          </div>
          <div class="odoc-party">
            <div class="odoc-party-title">발 주 처</div>
            <table class="odoc-info-table">
              <tr><td>상호</td><td>{{ auth.user?.company_name }}</td></tr>
              <tr><td>소재지</td><td>{{ myFullAddress || '-' }}</td></tr>
              <tr><td>담당자</td><td>{{ auth.user?.manager_name || auth.user?.name }}</td></tr>
              <tr><td>연락처</td><td>{{ auth.user?.manager_phone || auth.user?.phone }}</td></tr>
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
            <tr v-for="(item, i) in selfForm.items" :key="i">
              <td class="odoc-no">{{ i + 1 }}</td>
              <td>
                <select class="odoc-select" v-model.number="item.product_id" @change="selfSyncProduct(item)">
                  <option v-for="p in data.products" :key="p.id" :value="p.id">{{ p.name }} {{ p.model_name }}</option>
                </select>
              </td>
              <td class="odoc-center">{{ selfProductById(item.product_id)?.spec || selfProductById(item.product_id)?.model_name || '-' }}</td>
              <td class="odoc-center">
                <input class="odoc-qty" v-model.number="item.quantity" type="number" min="1" />
              </td>
              <td class="odoc-right">{{ money(item.unit_price) }}</td>
              <td class="odoc-right">{{ money(item.quantity * item.unit_price) }}</td>
              <td class="odoc-right">{{ money(Math.floor(item.quantity * item.unit_price * 0.1)) }}</td>
              <td><button class="odoc-del-btn" type="button" @click="selfRemoveItem(i)">×</button></td>
            </tr>
            <tr v-if="!selfForm.items.length">
              <td colspan="8" class="odoc-empty">품목을 추가해주세요.</td>
            </tr>
          </tbody>
        </table>
        <button class="odoc-add-btn" type="button" @click="selfAddItem">+ 품목 추가</button>

        <!-- 합계 -->
        <div class="odoc-summary">
          <div class="odoc-sum-cell">
            <span>공급가액</span>
            <strong>₩ {{ money(selfSupplyAmount) }}</strong>
          </div>
          <div class="odoc-sum-cell">
            <span>세&nbsp;&nbsp;&nbsp;&nbsp;액</span>
            <strong>₩ {{ money(selfVatAmount) }}</strong>
          </div>
          <div class="odoc-sum-cell odoc-sum-total">
            <span>합&nbsp;&nbsp;&nbsp;&nbsp;계</span>
            <div class="odoc-sum-value">
              <strong>₩ {{ money(selfGrandTotal) }}</strong>
              <small class="odoc-sum-korean">{{ numberToKoreanMoney(selfGrandTotal) }}</small>
            </div>
          </div>
        </div>

        <!-- 발주조건 -->
        <div class="odoc-conditions">
          <div class="odoc-conditions-title">발주조건</div>
          <div class="odoc-conditions-body">
            <label class="odoc-cond-row">
              <span>배 송 지</span>
              <input v-model="selfForm.delivery_address" required placeholder="배송받으실 주소를 입력해주세요" />
            </label>
            <label class="odoc-cond-row">
              <span>결제조건</span>
              <input v-model="selfForm.payment_terms" placeholder="예) 현금결제" />
            </label>
            <label class="odoc-cond-row">
              <span>비&nbsp;&nbsp;&nbsp;&nbsp;고</span>
              <textarea v-model="selfForm.note" placeholder="특이사항이 있으면 입력해주세요" rows="2"></textarea>
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
            <div style="display:flex;align-items:baseline;gap:8px;margin-bottom:14px">
              <h2 style="margin:0">발주 현황</h2>
              <span v-if="selfSelectedDate" style="font-size:12px;color:var(--blue)">{{ selfSelectedDate }} 필터 중</span>
            </div>
            <div class="order-card-list">
              <div v-for="order in filteredSelfOrders" :key="order.id" class="order-card">
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
                  <button class="deliver-btn" type="button" @click="router.push('/distributor/shipments')">출고현황에서 입고 확인</button>
                </div>
                <div v-else-if="order.status === 'DELIVERED'" class="order-card-delivered">
                  <span class="delivered-check">✓ 입고 확인 완료</span>
                  <span class="delivered-who">{{ order.received_by_company }} ({{ ROLE_KO[order.received_by_role] || order.received_by_role }})</span>
                  <span class="delivered-when">{{ fmtDatetime(order.received_at) }}</span>
                </div>
              </div>
              <div v-if="!filteredSelfOrders.length" class="empty-row" style="text-align:center;padding:24px 0">
                {{ selfSelectedDate ? '해당 날짜의 발주 내역이 없습니다.' : '발주 내역이 없습니다.' }}
              </div>
            </div>
          </div>
        </aside>

      </div>
    </template>

    <!-- 대시보드 -->
    <template v-else-if="view === 'dashboard'">
      <div class="dashboard-grid">

        <!-- 상단 3열: 달력 | KPI 2×2 | 알림 -->
        <div class="dashboard-row1">

          <MiniCalendar
            :marked-dates="data.orders.filter(o => o.status !== 'CANCELLED').map(o => o.ordered_at)"
            :selected-date="lineupSelectedDate"
            allow-any-date
            @select="onCalendarSelect"
          />

          <section v-if="data.dashboard" class="dash-kpi">
            <KpiCard label="이번 달 수주" :value="data.dashboard.summary.monthly_orders" hint="건" />
            <KpiCard label="총판 재고"    :value="data.dashboard.summary.current_inventory" hint="개" />
            <KpiCard label="이번 달 판매액" :value="`${money(data.dashboard.summary.monthly_sales)}원`" note="발주 기준" />
            <KpiCard label="이번 달 출고" :value="data.dashboard.summary.monthly_shipments" hint="건" />
          </section>
          <div v-else class="dash-kpi" />

          <!-- 알림 패널 -->
          <div class="panel" :class="{ 'panel-alert': orderWaiting.length }">
            <div class="panel-head-row">
              <h2 style="margin:0">
                <span v-if="orderWaiting.length" class="alert-exclaim">!</span>
                알림
                <span v-if="orderWaiting.length" class="badge" style="margin-left:4px;font-size:11px">{{ orderWaiting.length }}</span>
              </h2>
              <div class="alert-type-btns">
                <button class="badge s-CONVERTED alert-filter-badge" @click="router.push('/distributor/orders')">
                  수주 {{ orderWaiting.length }}
                </button>
              </div>
            </div>
            <div class="panel-table-wrap">
              <table>
                <thead>
                  <tr><th style="width:70px">구분</th><th>대리점</th><th style="width:100px;text-align:right">합계</th><th style="width:140px">발주일시</th></tr>
                </thead>
                <tbody>
                  <tr v-for="order in orderWaiting" :key="order.id"
                      class="dash-new-order-row" @click="router.push('/distributor/orders')">
                    <td><span class="badge s-CONVERTED">수주</span></td>
                    <td>{{ order.dealer_company }}</td>
                    <td style="text-align:right;font-weight:700">{{ money(order.total_amount) }}</td>
                    <td>{{ formatDT(order.ordered_at) }}</td>
                  </tr>
                  <tr v-if="!orderWaiting.length">
                    <td colspan="4" class="empty-row">알림이 없습니다.</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

        </div>

        <!-- 하단 2열 -->
        <div class="dashboard-row2">
          <div class="panel">
            <div class="panel-head-row">
              <h2>소속 대리점 현황</h2>
              <div class="lineup-nav">
                <button class="lineup-nav-arrow" @click="prevPeriod">‹</button>
                <span class="lineup-nav-label">{{ lineupDateLabel }}</span>
                <button class="lineup-nav-arrow" @click="nextPeriod">›</button>
              </div>
              <div class="period-filter">
                <button :class="{ active: lineupPeriod === 'daily' }"   @click="lineupPeriod = 'daily'">일별</button>
                <button :class="{ active: lineupPeriod === 'monthly' }" @click="lineupPeriod = 'monthly'">월별</button>
                <button :class="{ active: lineupPeriod === 'yearly' }"  @click="lineupPeriod = 'yearly'">연도별</button>
                <button :class="{ active: lineupPeriod === 'all' }"     @click="lineupPeriod = 'all'">전체</button>
              </div>
            </div>
            <div class="panel-table-wrap">
              <table>
                <thead><tr><th style="width:305px">대리점</th><th style="width:120px">최근 발주</th><th style="width:90px">발주 건수</th><th style="width:140px">총 금액</th></tr></thead>
                <tbody>
                  <tr v-for="row in data.dashboard?.dealers || []" :key="row.dealer_company">
                    <td>{{ row.dealer_company }}</td>
                    <td>{{ row.last_ordered_at ? row.last_ordered_at.slice(0, 10) : '-' }}</td>
                    <td>{{ row.order_count }}</td>
                    <td>{{ money(row.total_amount) }}</td>
                  </tr>
                  <tr v-if="!data.dashboard?.dealers?.length">
                    <td colspan="4" class="empty-row">해당 기간에 발주한 대리점이 없습니다.</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div class="panel">
            <h2>최근 수주</h2>
            <div class="panel-table-wrap">
              <table>
                <thead><tr><th style="width:165px">발주번호</th><th style="width:300px">대리점</th><th style="width:100px">합계</th><th style="width:90px">상태</th></tr></thead>
                <tbody>
                  <tr v-for="order in data.orders.slice(0, 20)" :key="order.id">
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
          </div>
        </div>

      </div>
    </template>

    <!-- 수주현황 -->
    <template v-else-if="view === 'orders'">
      <div class="orders-split-layout">
        <div class="tab-bar">
          <button :class="{ active: orderTab === 'waiting' }" @click="orderTab = 'waiting'">
            전환 대기 목록 <span class="badge-count" :class="{ 'badge-red': orderWaiting.length > 0 }">{{ orderWaiting.length }}</span>
          </button>
          <button :class="{ active: orderTab === 'completed' }" @click="orderTab = 'completed'">
            전환 완료 목록 <span class="badge-count">{{ orderCompletedRows.length }}</span>
          </button>
        </div>

        <!-- 전환 대기 목록 -->
        <section v-if="orderTab === 'waiting'" class="panel">
          <div class="panel-table-wrap">
            <table>
              <thead>
                <tr><th style="width:44px">No.</th><th style="width:190px">발주번호</th><th style="width:150px">대리점</th><th>품목</th><th style="width:100px;text-align:right">합계</th><th style="width:100px">발주일</th><th style="width:100px">액션</th></tr>
              </thead>
              <tbody>
                <tr v-for="(order, index) in orderWaiting" :key="order.id" class="clickable-row" @click="openOrder(order)">
                  <td>{{ orderWaiting.length - index }}</td>
                  <td class="order-num">{{ order.order_number }}</td>
                  <td>{{ order.dealer_company }}</td>
                  <td><span class="items-line" :title="order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ')">{{ order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ') }}</span></td>
                  <td style="text-align:right;font-weight:700">{{ money(order.total_amount) }}</td>
                  <td>{{ order.ordered_at?.slice(0, 10) }}</td>
                  <td>
                    <div class="actions" @click.stop>
                      <button @click="convert(order)">발주 전환 ▶</button>
                    </div>
                  </td>
                </tr>
                <tr v-if="!orderWaiting.length">
                  <td colspan="7" class="empty-row">전환 대기 중인 발주서가 없습니다.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <!-- 전환 완료 목록 -->
        <section v-else-if="orderTab === 'completed'" class="panel">
          <div class="page-section-head">
            <div>
              <p class="text-muted">총 {{ filteredCompletedOrders.length }}건이 검색되었습니다.</p>
            </div>
          </div>
          <div class="smart-filter-bar">
            <div class="filter-selectors">
              <select v-model="completedFilterCategory" class="filter-cat-select">
                <option v-for="cat in completedFilterCategories" :key="cat.key" :value="cat.key">{{ cat.label }}</option>
              </select>
              <FilterSearchInput :options="completedFilterValueOptions" @add="addCompletedFilter" />
            </div>
            <div class="filter-chips">
              <span v-for="(f, i) in completedActiveFilters" :key="i" class="filter-chip">
                <span class="chip-text">{{ f.categoryLabel }}: {{ f.displayValue }}</span>
                <button class="chip-remove" type="button" @click="removeCompletedFilter(i)">×</button>
              </span>
              <button v-if="completedActiveFilters.length" class="secondary chip-reset" type="button" @click="resetCompletedFilters">전체 해제</button>
            </div>
          </div>
          <div class="panel-table-wrap">
            <table>
              <thead>
                <tr><th style="width:44px">No.</th><th style="width:170px">발주번호</th><th style="width:130px">대리점</th><th>품목</th><th style="width:100px;text-align:right">합계</th><th style="width:90px;text-align:center">상태</th><th style="width:100px">전환일</th><th style="width:160px;text-align:center"></th></tr>
              </thead>
              <tbody>
                <tr v-for="(order, index) in filteredCompletedOrders" :key="order.id" class="clickable-row" @click="openOrder(order)">
                  <td>{{ filteredCompletedOrders.length - index }}</td>
                  <td class="order-num">{{ order.order_number }}</td>
                  <td>{{ order.dealer_company }}</td>
                  <td><span class="items-line" :title="order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ')">{{ order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ') }}</span></td>
                  <td style="text-align:right;font-weight:700">{{ money(order.total_amount) }}</td>
                  <td style="text-align:center"><StatusBadge :status="order.status" /></td>
                  <td>{{ order.converted_at?.slice(0, 10) }}</td>
                  <td @click.stop style="text-align:center">
                    <div v-if="['SHIPPED', 'DELIVERED'].includes(order.status)" class="ship-done-info">
                      <span class="badge s-SHIPPED">출고 등록 완료</span>
                      <span class="ship-done-date">{{ fmtDatetime(order.shipped_at) }}</span>
                    </div>
                    <button v-else-if="['CONFIRMED', 'PARTIALLY_SHIPPED'].includes(order.status)" class="goto-ship-btn" @click="goToShipments(order)">출고 확인</button>
                  </td>
                </tr>
                <tr v-if="!filteredCompletedOrders.length">
                  <td colspan="8" class="empty-row">검색 조건에 맞는 전환 완료 내역이 없습니다.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </template>

    <!-- 재고현황 -->
    <template v-else-if="view === 'inventory'">
      <section class="panel">
        <div class="page-section-head">
          <div>
            <h2>재고현황 <span class="badge-count">{{ data.inventory.length }}</span></h2>
            <p class="text-muted">제조사(본사) 재고를 그대로 조회합니다. 총판은 별도 재고를 갖지 않습니다.</p>
          </div>
        </div>
        <div class="panel-table-wrap">
          <table>
            <thead><tr><th style="width:44px">No.</th><th style="width:456px">제품명</th><th style="width:278px">모델</th><th style="width:218px">규격</th><th style="width:180px;text-align:center">현재 재고</th><th style="width:140px;text-align:right">단가</th></tr></thead>
            <tbody>
              <tr v-for="(item, index) in data.inventory" :key="item.id">
                <td>{{ index + 1 }}</td>
                <td>{{ item.name }}</td>
                <td>{{ item.model_name }}</td>
                <td>{{ item.spec || '-' }}</td>
                <td style="text-align:center;font-weight:700">{{ item.quantity }}</td>
                <td style="text-align:right">{{ distributorPriceByProductId[item.product_id] != null ? money(distributorPriceByProductId[item.product_id]) : '-' }}</td>
              </tr>
              <tr v-if="!data.inventory.length"><td colspan="6" class="empty-row">등록된 재고가 없습니다.</td></tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>

    <!-- 판매현황 -->
    <template v-else-if="view === 'sales'">
      <div class="sales-layout">
        <!-- 1열: 월별 요약 -->
        <section class="panel sales-summary-panel">
          <h2>월별 요약</h2>
          <div class="summary-table-wrap">
            <table class="summary-table">
              <thead><tr><th style="width:66px">연월</th><th style="width:52px;text-align:right">수량</th><th style="text-align:right">판매액</th></tr></thead>
              <tbody>
                <tr v-for="row in filteredMonthlySales" :key="row.month">
                  <td>{{ row.month }}</td>
                  <td style="text-align:right">{{ row.quantity || '-' }}</td>
                  <td style="text-align:right;font-weight:700">{{ row.amount ? money(row.amount) : '-' }}</td>
                </tr>
              </tbody>
              <tfoot>
                <tr>
                  <td><strong>합계</strong></td>
                  <td style="text-align:right"><strong>{{ filteredMonthlySales.reduce((s,r)=>s+r.quantity,0) }}</strong></td>
                  <td style="text-align:right"><strong>{{ money(filteredMonthlySales.reduce((s,r)=>s+r.amount,0)) }}</strong></td>
                </tr>
              </tfoot>
            </table>
          </div>
        </section>

        <!-- 2열: 판매 상세 -->
        <section class="panel sales-detail-panel">
          <div class="page-section-head">
            <div>
              <h2>판매 상세 내역</h2>
              <p class="text-muted">총 {{ groupedSales.length }}건이 검색되었습니다.</p>
            </div>
          </div>
          <div class="smart-filter-bar">
            <div class="filter-selectors">
              <select v-model="filterCategory" class="filter-cat-select">
                <option v-for="cat in filterCategories" :key="cat.key" :value="cat.key">{{ cat.label }}</option>
              </select>
              <FilterSearchInput :options="filterValueOptions" @add="addFilter" />
            </div>
            <div class="filter-chips">
              <span v-for="(f, i) in activeFilters" :key="i" class="filter-chip">
                <span class="chip-text">{{ f.categoryLabel }}: {{ f.displayValue }}</span>
                <button class="chip-remove" type="button" @click="removeFilter(i)">×</button>
              </span>
              <button v-if="activeFilters.length" class="secondary chip-reset" type="button" @click="resetSalesFilters">전체 해제</button>
            </div>
          </div>
          <div class="detail-table-wrap">
            <table>
              <thead>
                <tr><th style="width:54px">No.</th><th style="width:170px">일시</th><th style="width:110px">대리점</th><th>모델</th><th style="width:80px;text-align:right">수량</th><th style="width:100px;text-align:right">단가</th><th style="width:100px;text-align:right">금액</th><th style="width:90px;text-align:center">상태</th></tr>
              </thead>
              <tbody>
                <template v-for="(group, i) in groupedSales" :key="group.order_id">
                  <tr class="clickable-row" @click="group.items.length === 1 ? openOrderById(group.order_id) : toggleSalesOrder(group.order_id)">
                    <td>{{ groupedSales.length - i }}</td>
                    <td>{{ group.date }}</td>
                    <td>{{ group.dealer_company }}</td>
                    <td>
                      <div class="sales-order-summary">
                        <span v-if="group.items.length > 1" class="sales-expand-arrow">{{ expandedSalesOrders.has(group.order_id) ? '▼' : '▶' }}</span>
                        <span class="items-line" :title="group.items.map(it => it.model_name).join(', ')">{{ group.items.map(it => it.model_name).join(', ') }}</span>
                      </div>
                    </td>
                    <td style="text-align:right">{{ group.totalQuantity }}</td>
                    <td style="text-align:right">{{ money(group.totalUnitPrice) }}</td>
                    <td style="text-align:right;font-weight:700">{{ money(group.totalAmount) }}</td>
                    <td style="text-align:center"><span class="badge" :class="shipmentStatusClass(group.status)">{{ shipmentStatusLabel(group.status) }}</span></td>
                  </tr>
                  <template v-if="group.items.length > 1 && expandedSalesOrders.has(group.order_id)">
                    <tr
                      v-for="(item, j) in group.items"
                      :key="group.order_id + '-' + j"
                      class="sales-item-row clickable-row"
                      @click="openOrderById(group.order_id)"
                    >
                      <td></td>
                      <td></td>
                      <td></td>
                      <td class="sales-item-model">{{ item.model_name }}</td>
                      <td style="text-align:right">{{ item.quantity }}</td>
                      <td style="text-align:right">{{ money(item.unit_price) }}</td>
                      <td style="text-align:right">{{ money(item.amount) }}</td>
                      <td></td>
                    </tr>
                  </template>
                </template>
                <tr v-if="!groupedSales.length">
                  <td colspan="8" class="empty-row">검색 조건에 맞는 판매 내역이 없습니다.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </template>

    <!-- 출고현황 -->
    <template v-else-if="view === 'shipments'">
      <div class="shipments-layout">
        <div class="tab-bar">
          <button :class="{ active: shipmentTab === 'waiting' }" @click="shipmentTab = 'waiting'">
            입고 대기 <span class="badge-count" :class="{ 'badge-red': shipmentsWaiting.length > 0 }">{{ shipmentsWaiting.length }}</span>
          </button>
          <button :class="{ active: shipmentTab === 'received' }" @click="shipmentTab = 'received'">
            입고 완료 내역 <span class="badge-count">{{ shipmentsReceived.length }}</span>
          </button>
        </div>

        <!-- 입고 대기 -->
        <section v-if="shipmentTab === 'waiting'" class="panel">
          <div class="page-section-head">
            <div>
              <h2 style="display:flex;align-items:center;gap:8px;margin-bottom:4px">
                입고 대기
                <a href="https://search.naver.com/search.naver?where=nexearch&query=배송조회"
                   target="_blank" rel="noopener" class="secondary" style="font-size:12px;padding:3px 8px;min-height:unset;text-decoration:none;display:inline-flex;align-items:center;gap:4px;font-weight:500">
                  🔍 배송조회
                </a>
              </h2>
              <p class="text-muted">제조사에서 출고된 상품을 확인 후 입고 처리해주세요.</p>
            </div>
          </div>
          <div class="panel-table-wrap">
            <table>
              <thead>
                <tr><th style="width:44px">No.</th><th style="width:170px">출고번호</th><th style="width:170px">발주번호</th><th style="width:140px">대리점</th><th style="width:200px">품목</th><th>배송지</th><th style="width:160px">운송장번호</th><th style="width:100px">출고일</th><th style="width:100px">입고 처리</th></tr>
              </thead>
              <tbody>
                <tr v-for="(s, index) in shipmentsWaiting" :key="s.id"
                    :class="{ 'row-highlighted': s.order_number === highlightOrderNum }">
                  <td>{{ shipmentsWaiting.length - index }}</td>
                  <td>{{ s.shipment_number }}</td>
                  <td class="order-num">{{ s.order_number }}</td>
                  <td>{{ s.dealer_company }}</td>
                  <td>{{ s.items.map(i => `${i.model_name} ×${i.quantity}`).join(', ') }}</td>
                  <td>{{ s.delivery_address }}</td>
                  <td>
                    <div class="tracking-cell">
                      <span v-if="s.tracking_number">{{ s.tracking_number }}</span>
                      <span v-else class="text-muted">-</span>
                      <button v-if="s.tracking_number" class="copy-btn" type="button" title="복사" @click="copyTracking(s.tracking_number)">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
                        </svg>
                      </button>
                    </div>
                  </td>
                  <td>{{ s.shipped_at?.slice(0, 10) }}</td>
                  <td><button class="primary" @click="receiveShipment(s)">입고 확인</button></td>
                </tr>
                <tr v-if="!shipmentsWaiting.length">
                  <td colspan="9" class="empty-row">입고 대기 중인 출고가 없습니다.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <!-- 입고 완료 내역 -->
        <section v-else-if="shipmentTab === 'received'" class="panel">
          <div class="page-section-head">
            <div>
              <h2 style="display:flex;align-items:center;gap:8px;margin-bottom:4px">
                입고 완료 내역
                <a href="https://search.naver.com/search.naver?where=nexearch&query=배송조회"
                   target="_blank" rel="noopener" class="secondary" style="font-size:12px;padding:3px 8px;min-height:unset;text-decoration:none;display:inline-flex;align-items:center;gap:4px;font-weight:500">
                  🔍 배송조회
                </a>
              </h2>
              <p class="text-muted">복사 아이콘으로 운송장번호를 복사하고, 배송조회 버튼으로 택배사 조회 페이지를 열 수 있습니다.</p>
            </div>
          </div>
          <div class="smart-filter-bar">
            <div class="filter-selectors">
              <select v-model="receivedFilterCategory" class="filter-cat-select">
                <option v-for="cat in receivedFilterCategories" :key="cat.key" :value="cat.key">{{ cat.label }}</option>
              </select>
              <FilterSearchInput :options="receivedFilterValueOptions" @add="addReceivedFilter" />
            </div>
            <div class="filter-chips">
              <span v-for="(f, i) in receivedActiveFilters" :key="i" class="filter-chip">
                <span class="chip-text">{{ f.categoryLabel }}: {{ f.displayValue }}</span>
                <button class="chip-remove" type="button" @click="removeReceivedFilter(i)">×</button>
              </span>
              <button v-if="receivedActiveFilters.length" class="secondary chip-reset" type="button" @click="resetReceivedFilters">전체 해제</button>
            </div>
          </div>
          <div class="panel-table-wrap">
            <table>
              <thead>
                <tr><th style="width:44px">No.</th><th style="width:170px">출고번호</th><th style="width:170px">발주번호</th><th style="width:140px">대리점</th><th>품목</th><th style="width:160px">운송장번호</th><th style="width:100px">출고일</th><th style="width:100px">입고일</th></tr>
              </thead>
              <tbody>
                <tr v-for="(s, index) in filteredShipmentsReceived" :key="s.id">
                  <td>{{ filteredShipmentsReceived.length - index }}</td>
                  <td>{{ s.shipment_number }}</td>
                  <td class="order-num">{{ s.order_number }}</td>
                  <td>{{ s.dealer_company }}</td>
                  <td>{{ s.items.map(i => `${i.model_name} ×${i.quantity}`).join(', ') }}</td>
                  <td>
                    <div class="tracking-cell">
                      <span v-if="s.tracking_number">{{ s.tracking_number }}</span>
                      <span v-else class="text-muted">-</span>
                      <button v-if="s.tracking_number" class="copy-btn" type="button" title="복사" @click="copyTracking(s.tracking_number)">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
                        </svg>
                      </button>
                    </div>
                  </td>
                  <td>{{ s.shipped_at?.slice(0, 10) }}</td>
                  <td>{{ s.received_at?.slice(0, 10) }}</td>
                </tr>
                <tr v-if="!filteredShipmentsReceived.length">
                  <td colspan="8" class="empty-row">검색 조건에 맞는 입고 완료 내역이 없습니다.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </template>

    <!-- 대리점 -->
    <template v-else-if="view === 'dealers'">
      <section class="panel">
        <div class="page-section-head">
          <div>
            <h2>소속 대리점</h2>
            <p class="text-muted">총 {{ data.dealers.length }}개 대리점이 등록되어 있습니다.</p>
          </div>
        </div>
        <div class="panel-table-wrap">
          <table>
            <thead>
              <tr>
                <th style="width:190px">회사명</th><th style="width:100px">대표자</th><th style="width:120px">사업자번호</th><th>주소</th>
                <th style="width:110px">담당자</th><th style="width:130px">연락처</th><th style="width:100px">가입일</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="d in data.dealers" :key="d.id">
                <td>{{ d.company_name }}</td>
                <td>{{ d.ceo_name || '-' }}</td>
                <td>{{ d.business_number || '-' }}</td>
                <td>{{ d.address || '-' }}</td>
                <td>{{ d.manager_name || '-' }}</td>
                <td>{{ d.manager_phone || d.phone || '-' }}</td>
                <td>{{ d.created_at?.slice(0, 10) }}</td>
              </tr>
              <tr v-if="!data.dealers.length"><td colspan="7" class="empty-row">등록된 대리점이 없습니다.</td></tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>

    <!-- 회원관리 -->
    <template v-else-if="view === 'members'">
      <div :class="['member-layout', selectedStaff ? 'split' : '']">

        <!-- ── 카드 1: 직원 목록 ── -->
        <section class="panel" style="margin-bottom:0">
          <div class="tab-bar-row">
            <div class="tab-bar">
              <button :class="{ active: memberStatusFilter === 'active' }" @click="memberStatusFilter = 'active'">
                직원 <span class="badge-count">{{ staffCounts.active }}</span>
              </button>
              <button :class="{ active: memberStatusFilter === 'inactive' }" @click="memberStatusFilter = 'inactive'">
                비활성 <span class="badge-count">{{ staffCounts.inactive }}</span>
              </button>
              <button :class="{ active: memberStatusFilter === 'rejected' }" @click="memberStatusFilter = 'rejected'">
                거부 <span class="badge-count">{{ staffCounts.rejected }}</span>
              </button>
            </div>
          </div>

          <!-- ── 승인 대기 (직원 탭에서만 표시) ── -->
          <template v-if="memberStatusFilter === 'active' && data.pendingStaff.length">
            <div class="member-sub-header sub-pending">
              승인 대기
              <span class="badge-count badge-red">{{ data.pendingStaff.length }}</span>
            </div>
            <div class="member-list-wrap">
              <table class="member-table">
                <thead><tr><th style="width:90px">이름</th><th style="width:120px">아이디</th><th style="width:130px">연락처</th><th style="width:100px">가입일</th><th style="width:80px">처리</th></tr></thead>
                <tbody>
                  <tr v-for="user in data.pendingStaff" :key="user.id">
                    <td>{{ user.name }}</td>
                    <td>{{ user.username }}</td>
                    <td>{{ user.phone }}</td>
                    <td>{{ user.created_at?.slice(0, 10) }}</td>
                    <td>
                      <div class="actions">
                        <button @click="approveStaff(user)">승인</button>
                        <button class="btn-danger" @click="rejectStaff(user)">거부</button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </template>

          <div class="member-sub-header sub-active">
            직원 목록
            <span class="badge-count badge-green">{{ filteredStaff.length }}</span>
          </div>
          <div class="member-list-wrap">
            <table class="member-table">
              <thead>
                <tr>
                  <th style="width:90px">이름</th><th style="width:120px">아이디</th><th style="width:90px">구분</th><th style="width:100px">가입일</th>
                  <th v-if="memberStatusFilter === 'rejected'" style="width:90px"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="user in filteredStaff" :key="user.id"
                  :class="{ 'row-selected': selectedStaff?.id === user.id }"
                  @click="selectStaff(user)">
                  <td>{{ user.name }}</td>
                  <td>{{ user.username }}</td>
                  <td>
                    <span v-if="user.is_owner" class="badge s-SHIPPED">관리자</span>
                    <span v-else-if="user.is_member_manager" class="badge s-CONVERTED">담당자</span>
                    <span v-else class="text-muted">직원</span>
                  </td>
                  <td>{{ user.created_at?.slice(0, 10) }}</td>
                  <td v-if="memberStatusFilter === 'rejected'" @click.stop>
                    <div class="actions">
                      <button @click="unrejectStaff(user)">거부 해제</button>
                    </div>
                  </td>
                </tr>
                <tr v-if="!filteredStaff.length">
                  <td :colspan="memberStatusFilter === 'rejected' ? 5 : 4" class="empty-row">해당 직원이 없습니다.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <!-- ── 카드 2: 편집 폼 ── -->
        <transition name="member-form">
          <section v-if="selectedStaff" class="panel member-edit-card" style="margin-bottom:0">
            <div class="member-edit-header">
              <div class="member-edit-who">
                <strong>{{ selectedStaff.name }}</strong>
                <span class="text-muted">{{ selectedStaff.username }}</span>
                <span class="badge" :class="selectedStaff.status === 'active' ? 's-SHIPPED' : 's-PENDING'">
                  {{ selectedStaff.status === 'active' ? '활성' : selectedStaff.status === 'inactive' ? '비활성' : '거부' }}
                </span>
              </div>
              <button class="member-edit-close" type="button" @click="selectedStaff = null">✕</button>
            </div>
            <form class="member-edit-form" @submit.prevent="saveStaff">
              <label>이름<input v-model="staffEditForm.name" required /></label>
              <label>아이디<input :value="selectedStaff.username" readonly style="background:#f7f8fa;color:#999" /></label>
              <label>비밀번호
                <PasswordInput v-model="staffEditForm.password" placeholder="변경 시 입력" autocomplete="new-password" />
              </label>
              <label v-if="staffEditForm.password">비밀번호 확인
                <PasswordInput v-model="staffEditForm.passwordConfirm" placeholder="비밀번호를 다시 입력해주세요" autocomplete="new-password" />
              </label>
              <label>연락처<input v-model="staffEditForm.phone" /></label>
              <label>주소<input v-model="staffEditForm.address" /></label>
              <label>상태
                <select v-model="staffEditForm.status">
                  <option value="active">활성</option>
                  <option value="inactive">비활성</option>
                  <option value="rejected">거부</option>
                </select>
              </label>
              <label>담당자명<input v-model="staffEditForm.manager_name" placeholder="담당자명" /></label>
              <label>담당자 부서<input v-model="staffEditForm.manager_department" placeholder="부서" /></label>
              <label>담당자 직책<input v-model="staffEditForm.manager_position" placeholder="직책" /></label>
              <label>담당자 연락처<input v-model="staffEditForm.manager_phone" placeholder="숫자만 입력" maxlength="14" /></label>
              <label>담당자 이메일<input v-model="staffEditForm.manager_email" type="email" placeholder="이메일" /></label>
              <label class="full-row">담당자 메모<textarea v-model="staffEditForm.manager_memo" placeholder="담당 업무나 참고사항"></textarea></label>

              <div class="member-edit-actions">
                <button class="primary" type="submit">저장</button>
                <button v-if="!selectedStaff.is_owner" class="btn-danger" type="button" @click="deleteModalOpen = true">삭제</button>
              </div>
            </form>
          </section>
        </transition>

      </div><!-- /member-layout -->
    </template>

    <DeleteMemberModal
      :show="deleteModalOpen"
      :user="selectedStaff"
      @close="deleteModalOpen = false"
      @deleted="onStaffDeleted"
    />

    <OrderReceiptModal
      v-if="editing"
      :order="editing"
      :products="sellProducts"
      :editable="['PENDING', 'RECEIVED'].includes(editing.status)"
      :can-convert="editingCanConvert"
      show-statement-button
      statement-button-label="대리점 거래명세서"
      show-purchase-statement-button
      use-own-logo
      :logo-url="auth.user?.logo_url"
      owner-label="총판 수주 명세"
      @close="editing = null"
      @save="saveEdit"
      @preview-statement="previewStatementForOrder(editing)"
      @preview-purchase-statement="previewPurchaseStatementForOrder(editing)"
      @convert="convertFromModal"
    />

    <TransactionStatementModal
      v-if="statementPreview"
      :order="statementPreview.order"
      :pages="statementPreview.pages"
      :perspective="statementPreview.perspective"
      :logo-url="auth.user?.logo_url"
      @close="statementPreview = null"
    />
  </AppShell>
</template>
