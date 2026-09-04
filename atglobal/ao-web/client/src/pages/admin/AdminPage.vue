<script setup>
import { computed, nextTick, onMounted, onUnmounted, reactive, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { api, request } from '../../api';
import { useAuthStore } from '../../stores/auth';
import AppShell from '../../components/AppShell.vue';
import KpiCard from '../../components/KpiCard.vue';
import MiniCalendar from '../../components/MiniCalendar.vue';
import PasswordInput from '../../components/PasswordInput.vue';
import OrderReceiptModal from '../../components/OrderReceiptModal.vue';
import TransactionStatementModal from '../../components/TransactionStatementModal.vue';
import PriceInput from '../../components/PriceInput.vue';
import FilterSearchInput from '../../components/FilterSearchInput.vue';
import DeleteMemberModal from '../../components/DeleteMemberModal.vue';
import { confirmAction, notify } from '../../services/notification';
import { numberToKoreanMoney } from '../../utils/koreanMoney';

const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
const view = computed(() => route.params.view || 'dashboard');
const highlightOrderNum = computed(() => route.query.highlight || null);

function goToShipments(order) {
  router.push(`/admin/shipments?highlight=${order.order_number}`);
}

watch([view, highlightOrderNum], async ([v, h]) => {
  if (v === 'shipments' && h) {
    await nextTick();
    document.querySelector('.row-highlighted')?.scrollIntoView({ behavior: 'smooth', block: 'center' });
  }
}, { immediate: true });

watch(view, (v) => {
  if (v === 'members' && !(auth.user?.is_owner || auth.user?.is_member_manager)) {
    router.push('/admin');
  }
}, { immediate: true });

const viewTitles = {
  dashboard: '대시보드', orders: '수주현황', inventory: '재고현황',
  sales: '판매현황', shipments: '출고현황', dealers: '대리점', members: '회원관리', settings: '설정'
};

const menu = computed(() => {
  const items = [
    { label: '대시보드', to: '/admin' },
    { label: '수주현황', to: '/admin/orders' },
    { label: '재고현황', to: '/admin/inventory' },
    { label: '판매현황', to: '/admin/sales' },
    { label: '출고현황', to: '/admin/shipments' },
    { label: '대리점',   to: '/admin/dealers' }
  ];
  if (auth.user?.is_owner || auth.user?.is_member_manager) {
    items.push({ label: '회원관리', to: '/admin/members' });
  }
  items.push({ label: '설정', to: '/admin/settings' });
  return items;
});

const data = reactive({
  dashboard: null, orders: [], inventory: [], products: [],
  pending: [], users: [], distributors: [], shipments: [], sales: [], monthlySales: [], dealers: []
});

const dealersDistributorId = ref('all'); // 'all' | 총판 id
const dealersLoaded = ref(false);
async function loadDealersFor(distributorId) {
  dealersDistributorId.value = distributorId;
  try {
    const query = distributorId === 'all' ? '' : `?distributor_id=${distributorId}`;
    const { dealers } = await request(api.get(`/users/dealers${query}`));
    data.dealers = dealers;
    dealersLoaded.value = true;
  } catch (err) { error.value = err.message; }
}
watch(view, (v) => {
  if (v === 'dealers' && !dealersLoaded.value) loadDealersFor(dealersDistributorId.value);
}, { immediate: true });

const dealerFilterCategories = [
  { key: 'company',  label: '회사명' },
  { key: 'ceo',       label: '대표자' },
  { key: 'address',   label: '주소' },
  { key: 'manager',   label: '담당자' },
  { key: 'contact',   label: '연락처' },
];
const dealerFilterCategory = ref('company');
const dealerActiveFilters = ref([]);

const dealerFilterOptions = computed(() => {
  const unique = (mapper) => [...new Set(data.dealers.map(mapper).filter(v => v !== null && v !== undefined && v !== ''))];
  return {
    companies:  unique(d => d.company_name).sort(),
    ceos:       unique(d => d.ceo_name).sort(),
    addresses:  unique(d => d.address).sort(),
    managers:   unique(d => d.manager_name).sort(),
    contacts:   unique(d => d.manager_phone || d.phone).sort()
  };
});

const dealerFilterValueOptions = computed(() => {
  const opts = dealerFilterOptions.value;
  switch (dealerFilterCategory.value) {
    case 'company':  return opts.companies.map(v => ({ value: v, display: v }));
    case 'ceo':      return opts.ceos.map(v => ({ value: v, display: v }));
    case 'address':  return opts.addresses.map(v => ({ value: v, display: v }));
    case 'manager':  return opts.managers.map(v => ({ value: v, display: v }));
    case 'contact':  return opts.contacts.map(v => ({ value: v, display: v }));
    default:         return [];
  }
});

function addDealerFilter(value) {
  if (!value) return;
  const cat = dealerFilterCategories.find(c => c.key === dealerFilterCategory.value);
  const opt = dealerFilterValueOptions.value.find(o => o.value === value);
  const mode = opt ? 'exact' : 'text';
  if (dealerActiveFilters.value.some(f => f.key === dealerFilterCategory.value && f.mode === mode && f.value === value)) return;
  dealerActiveFilters.value.push({ key: dealerFilterCategory.value, categoryLabel: cat.label, value, displayValue: opt?.display || value, mode });
}
function removeDealerFilter(index) {
  dealerActiveFilters.value.splice(index, 1);
}
function resetDealerFilters() {
  dealerActiveFilters.value = [];
}

const filteredDealers = computed(() => {
  if (!dealerActiveFilters.value.length) return data.dealers;
  const groups = {};
  for (const f of dealerActiveFilters.value) {
    (groups[f.key] = groups[f.key] || []).push({ value: f.value, mode: f.mode });
  }
  return data.dealers.filter(d => {
    for (const [key, entries] of Object.entries(groups)) {
      if (key === 'company') { if (!matchFilterGroup(entries, d.company_name)) return false; }
      else if (key === 'ceo') { if (!matchFilterGroup(entries, d.ceo_name)) return false; }
      else if (key === 'address') { if (!matchFilterGroup(entries, d.address)) return false; }
      else if (key === 'manager') { if (!matchFilterGroup(entries, d.manager_name)) return false; }
      else if (key === 'contact') { if (!matchFilterGroup(entries, d.manager_phone || d.phone)) return false; }
    }
    return true;
  });
});

const productForm = reactive({ name: '', model_name: '', spec: '', base_price: 0 });
const productModalOpen = ref(false);
const productSubmitting = ref(false);
const editingProductId = ref(null);
const dashboardRefreshing = ref(false);
const lastRefreshedAt = ref(null);
const memberTab    = ref('all'); // 'all' | 'manufacturer' | 'distributor' | 'dealer'
const memberStatusTab = ref('active'); // 'all' 탭 하위: 'pending' | 'active' | 'inactive' | 'rejected'
const shipmentTab = ref('ready'); // 'ready' | 'history'
const orderTab = ref('waiting'); // 'waiting' | 'confirmed'
const inventoryTab = ref('stock'); // 'stock' | 'barcode'
const editingTracking = ref(null);

const CARRIERS = [
  { code: 'CJ',     name: 'CJ대한통운', url: n => `https://www.cjlogistics.com/ko/tool/parcel/tracking?gnbInvcNo=${n}` },
  { code: 'HANJIN', name: '한진택배',   url: n => `https://www.hanjin.com/kor/CMS/DeliveryMgr/WaybillResult.do?mCode=MN038&schLang=KR&wblnumText2=${n}` },
  { code: 'LOTTE',  name: '롯데택배',   url: n => `https://www.lotteglogis.com/home/reservation/tracking/linkView?InvNo=${n}` },
  { code: 'EPOST',  name: '우체국택배', url: n => `https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=${n}` },
  { code: 'LOGEN',  name: '로젠택배',   url: n => `https://www.ilogen.com/web/personal/trace/${n}` },
  { code: 'KYUNG',  name: '경동택배',   url: n => `https://kdexp.com/newDeliverySearch.nx?barcode=${n}` },
  { code: 'DAESIN', name: '대신택배',   url: n => `https://www.ds3211.co.kr/freight/internalFreightSearch.ht?billno=${n}` },
];

async function copyTracking(trackingNumber) {
  await navigator.clipboard.writeText(trackingNumber);
  notify('운송장번호가 복사되었습니다.');
}

async function saveTracking(shipment) {
  try {
    await request(
      api.patch(`/shipments/${shipment.id}`, { tracking_number: editingTracking.value.value || null }),
      { successMessage: '운송장번호가 저장되었습니다.' }
    );
    editingTracking.value = null;
    await loadAll();
  } catch (err) {
    notify(err.message, 'error');
  }
}

function trackingUrl(_, trackingNumber) {
  const n = (trackingNumber || '').trim();
  if (!n) return null;
  // CJ대한통운: 숫자 10자리 or CJ로 시작
  if (/^CJ/i.test(n) || /^\d{10}$/.test(n))
    return `https://www.cjlogistics.com/ko/tool/parcel/tracking?gnbInvcNo=${n}`;
  // 한진택배: 숫자 12자리
  if (/^\d{12}$/.test(n))
    return `https://www.hanjin.com/kor/CMS/DeliveryMgr/WaybillResult.do?mCode=MN038&schLang=KR&wblnumText2=${n}`;
  // 롯데택배: 숫자 13자리
  if (/^\d{13}$/.test(n))
    return `https://www.lotteglogis.com/home/reservation/tracking/linkView?InvNo=${n}`;
  // 우체국: EF·RR·CP·RA 등 영문 시작
  if (/^(EF|RR|CP|RA|RD)/i.test(n))
    return `https://service.epost.go.kr/trace.RetrieveDomRigiTraceList.comm?sid1=${n}`;
  // 로젠: 숫자 11자리
  if (/^\d{11}$/.test(n))
    return `https://www.ilogen.com/web/personal/trace/${n}`;
  // 그 외: 네이버 배송조회 위젯 직접 URL
  return `https://search.naver.com/search.naver?where=nexearch&query=${encodeURIComponent(n)}`;
}
function carrierName(code) {
  return CARRIERS.find(c => c.code === code)?.name ?? code ?? '-';
}
const editingOrder = ref(null);
const error = ref('');
const settingsTab = ref('profile');
const myForm = reactive({
  company_name: '', business_number: '', ceo_name: '', company_phone: '', fax: '', address: '', addressDetail: '', password: '', passwordConfirm: '',
  manager_name: '', manager_department: '', manager_position: '', manager_phone: '', manager_email: '', manager_memo: ''
});
function matchFilterGroup(entries, actual) {
  return entries.some((e) => e.mode === 'text'
    ? String(actual ?? '').toLowerCase().includes(String(e.value).toLowerCase())
    : actual === e.value);
}
const filterCategories = [
  { key: 'month',       label: '월' },
  { key: 'model',       label: '모델' },
  { key: 'distributor', label: '총판' },
  { key: 'dealer',      label: '대리점' },
  { key: 'unitPrice',   label: '단가' },
  { key: 'amount',      label: '금액' },
  { key: 'status',      label: '상태' },
];
const filterCategory = ref('month');
const activeFilters = ref([]);
// ── 회원 선택 & 편집 ────────────────────────────────
const selectedUser = ref(null);
const editForm = reactive({
  name: '', phone: '', company_name: '', address: '', role: 'dealer',
  status: 'active', distributor_id: null, password: '', passwordConfirm: '',
  manager_name: '', manager_department: '', manager_position: '',
  manager_phone: '', manager_email: '', manager_memo: ''
});

function selectUser(user) {
  selectedUser.value = user;
  Object.assign(editForm, {
    name: user.name, phone: user.phone || '', company_name: user.company_name || '',
    address: user.address || '', role: user.role, status: user.status,
    distributor_id: user.distributor_id || null, password: '', passwordConfirm: '',
    manager_name: user.manager_name || '',
    manager_department: user.manager_department || '',
    manager_position: user.manager_position || '',
    manager_phone: user.manager_phone || '',
    manager_email: user.manager_email || '',
    manager_memo: user.manager_memo || ''
  });
}

function syncMyForm() {
  Object.assign(myForm, {
    company_name: auth.user?.company_name || '',
    business_number: auth.user?.business_number || '',
    ceo_name: auth.user?.ceo_name || '',
    company_phone: auth.user?.company_phone || '',
    fax: auth.user?.fax || '',
    address: auth.user?.address || '',
    addressDetail: auth.user?.address_detail || '',
    password: '',
    passwordConfirm: '',
    manager_name: auth.user?.manager_name || '',
    manager_department: auth.user?.manager_department || '',
    manager_position: auth.user?.manager_position || '',
    manager_phone: auth.user?.manager_phone || '',
    manager_email: auth.user?.manager_email || '',
    manager_memo: auth.user?.manager_memo || ''
  });
}

// ── 컬럼 필터 ────────────────────────────────────────
const activeFilter = ref(null);
const colFilters = reactive({});

const baseNonAdmins = computed(() => data.users.filter(u => u.role !== 'admin' && u.status !== 'deleted'));
// 제조사 탭: 본인(로그인한 관리자)을 제외한 다른 제조사 직원 계정만
const manufacturerStaff = computed(() =>
  data.users.filter(u => u.role === 'admin' && u.status !== 'pending' && u.id !== auth.user?.id)
);

const tabUsers = computed(() => {
  if (memberTab.value === 'all') {
    if (memberStatusTab.value === 'pending') return data.pending;
    return baseNonAdmins.value.filter(u => u.status === memberStatusTab.value);
  }
  if (memberTab.value === 'manufacturer') return manufacturerStaff.value;
  if (memberTab.value === 'distributor' || memberTab.value === 'dealer') {
    return baseNonAdmins.value.filter(u => u.status !== 'pending' && u.role === memberTab.value);
  }
  return baseNonAdmins.value.filter(u => u.status === memberTab.value);
});

const tabCounts = computed(() => ({
  pending:      data.pending.length,
  all:          baseNonAdmins.value.length,
  active:       baseNonAdmins.value.filter(u => u.status === 'active').length,
  inactive:     baseNonAdmins.value.filter(u => u.status === 'inactive').length,
  rejected:     baseNonAdmins.value.filter(u => u.status === 'rejected').length,
  distributor:  baseNonAdmins.value.filter(u => u.status !== 'pending' && u.role === 'distributor').length,
  dealer:       baseNonAdmins.value.filter(u => u.status !== 'pending' && u.role === 'dealer').length,
  manufacturer: manufacturerStaff.value.length
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

// ── 회원관리 검색 필터 (판매현황 필터와 동일한 UI 패턴) ──
const memberFilterCategories = [
  { key: 'name',     label: '이름' },
  { key: 'username', label: '아이디' },
  { key: 'company',  label: '회사명' },
];
const memberFilterCategory = ref('name');
const memberActiveFilters = ref([]);

const memberFilterOptions = computed(() => {
  const unique = (mapper) => [...new Set(tabUsers.value.map(mapper).filter(v => v !== null && v !== undefined && v !== ''))];
  return {
    names: unique(u => u.name).sort(),
    usernames: unique(u => u.username).sort(),
    companies: unique(u => u.company_name).sort()
  };
});

const memberFilterValueOptions = computed(() => {
  const opts = memberFilterOptions.value;
  switch (memberFilterCategory.value) {
    case 'name':     return opts.names.map(v => ({ value: v, display: v }));
    case 'username': return opts.usernames.map(v => ({ value: v, display: v }));
    case 'company':  return opts.companies.map(v => ({ value: v, display: v }));
    default:         return [];
  }
});

function addMemberFilter(value) {
  if (!value) return;
  const cat = memberFilterCategories.find(c => c.key === memberFilterCategory.value);
  const opt = memberFilterValueOptions.value.find(o => o.value === value);
  const mode = opt ? 'exact' : 'text';
  if (memberActiveFilters.value.some(f => f.key === memberFilterCategory.value && f.mode === mode && f.value === value)) return;
  memberActiveFilters.value.push({ key: memberFilterCategory.value, categoryLabel: cat.label, value, displayValue: opt?.display || value, mode });
}

function removeMemberFilter(index) {
  memberActiveFilters.value.splice(index, 1);
}

function resetMemberFilters() {
  memberActiveFilters.value = [];
}

const filteredTabUsers = computed(() => {
  const base = applyColFilters(tabUsers.value);
  if (!memberActiveFilters.value.length) return base;
  const groups = {};
  for (const f of memberActiveFilters.value) {
    (groups[f.key] = groups[f.key] || []).push({ value: f.value, mode: f.mode });
  }
  return base.filter(u => {
    for (const [key, entries] of Object.entries(groups)) {
      if (key === 'name') { if (!matchFilterGroup(entries, u.name)) return false; }
      else if (key === 'username') { if (!matchFilterGroup(entries, u.username)) return false; }
      else if (key === 'company') { if (!matchFilterGroup(entries, u.company_name)) return false; }
    }
    return true;
  });
});

const editPwStatus = computed(() => {
  if (!editForm.password || !editForm.passwordConfirm) return null;
  return editForm.password === editForm.passwordConfirm ? 'match' : 'mismatch';
});
const myPwStatus = computed(() => {
  if (!myForm.password || !myForm.passwordConfirm) return null;
  return myForm.password === myForm.passwordConfirm ? 'match' : 'mismatch';
});

const orderSummary = computed(() => ({
  waiting: data.orders.filter(o => o.status === 'CONVERTED').length,
  confirmed: data.orders.filter(o => ['CONFIRMED', 'PARTIALLY_SHIPPED', 'CANCELLED'].includes(o.status)).length
}));
const alertFilter  = ref('all');

// LINE UP 제품 현황과 등록 판매대리점 패널이 각자 독립적으로 일별/월별/연도별을 고를 수 있도록
// 기간 상태를 패널별로 분리하고, 공통 로직은 makePeriodNav로 묶어서 재사용한다.
function makePeriodNav(initialDate) {
  const period = ref('daily');
  const date = ref(initialDate);

  const dateLabel = computed(() => {
    const d = date.value;
    const y = d.getFullYear();
    const m = d.getMonth() + 1;
    const day = d.getDate();
    if (period.value === 'all') return '전체';
    if (period.value === 'daily') return `${y}년 ${m}월 ${day}일`;
    if (period.value === 'monthly') return `${y}년 ${m}월`;
    return `${y}년`;
  });

  const dateParam = computed(() => {
    const d = date.value;
    const p = n => String(n).padStart(2, '0');
    const y = d.getFullYear();
    const m = p(d.getMonth() + 1);
    if (period.value === 'daily') return `${y}-${m}-${p(d.getDate())}`;
    if (period.value === 'monthly') return `${y}-${m}`;
    return `${y}`;
  });

  function prev() {
    if (period.value === 'all') return;
    const d = new Date(date.value);
    if (period.value === 'daily') d.setDate(d.getDate() - 1);
    else if (period.value === 'monthly') d.setMonth(d.getMonth() - 1);
    else d.setFullYear(d.getFullYear() - 1);
    date.value = d;
  }

  function next() {
    if (period.value === 'all') return;
    const d = new Date(date.value);
    if (period.value === 'daily') d.setDate(d.getDate() + 1);
    else if (period.value === 'monthly') d.setMonth(d.getMonth() + 1);
    else d.setFullYear(d.getFullYear() + 1);
    date.value = d;
  }

  return { period, date, dateLabel, dateParam, prev, next };
}

const lineupNav = makePeriodNav(new Date());
const dealerNav = makePeriodNav(new Date());
const { period: lineupPeriod, date: lineupDate, dateLabel: lineupDateLabel, dateParam: lineupDateParam, prev: prevPeriod, next: nextPeriod } = lineupNav;
const { period: dealerPeriod, date: dealerDate, dateLabel: dealerDateLabel, dateParam: dealerDateParam, prev: prevDealerPeriod, next: nextDealerPeriod } = dealerNav;

const lineupSelectedDate = computed(() => {
  const d = lineupDate.value;
  const p = n => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth()+1)}-${p(d.getDate())}`;
});

function onCalendarSelect(dateStr) {
  if (!dateStr) return;
  lineupDate.value = new Date(dateStr);
  dealerDate.value = new Date(dateStr);
}
const orderWaitingRows  = computed(() => data.orders.filter(o => o.status === 'CONVERTED'));
const orderConfirmedRows = computed(() => data.orders.filter(o => ['CONFIRMED', 'PARTIALLY_SHIPPED', 'CANCELLED'].includes(o.status)));
const readyToShipOrders  = computed(() => data.orders.filter(o =>
  ['CONFIRMED', 'PARTIALLY_SHIPPED'].includes(o.status)
  && o.items.some(i => Number(i.quantity) - Number(i.shipped_quantity || 0) > 0)
));
const alertTotalCount    = computed(() => orderWaitingRows.value.length + readyToShipOrders.value.length);
const filteredAlertRows  = computed(() => {
  let rows;
  if (alertFilter.value === 'order') rows = orderWaitingRows.value.map(o => ({ ...o, _type: 'order' }));
  else if (alertFilter.value === 'ship') rows = readyToShipOrders.value.map(o => ({ ...o, _type: 'ship' }));
  else rows = [
    ...orderWaitingRows.value.map(o => ({ ...o, _type: 'order' })),
    ...readyToShipOrders.value.map(o => ({ ...o, _type: 'ship' }))
  ];
  return rows.sort((a, b) => new Date(a.ordered_at) - new Date(b.ordered_at));
});
// ── 출고 처리 내역 검색 필터 (판매현황 필터와 동일한 UI 패턴) ──
const shipmentFilterCategories = [
  { key: 'month',       label: '월' },
  { key: 'model',       label: '모델' },
  { key: 'distributor', label: '총판' },
  { key: 'dealer',      label: '대리점' },
  { key: 'status',      label: '입고상태' },
];
const shipmentFilterCategory = ref('month');
const shipmentActiveFilters = ref([]);

const shipmentFilterOptions = computed(() => {
  const unique = (mapper) => [...new Set(data.shipments.flatMap(mapper).filter(v => v !== null && v !== undefined && v !== ''))];
  return {
    months: unique(s => [s.shipped_at?.slice(0, 7)]).sort().reverse(),
    models: unique(s => s.items.map(i => i.model_name)).sort(),
    distributors: unique(s => [s.distributor_company]).sort(),
    dealers: unique(s => [s.dealer_company]).sort(),
    statuses: ['입고 대기', '입고 완료']
  };
});

const shipmentFilterValueOptions = computed(() => {
  const opts = shipmentFilterOptions.value;
  switch (shipmentFilterCategory.value) {
    case 'month':       return opts.months.map(v => ({ value: v, display: v }));
    case 'model':       return opts.models.map(v => ({ value: v, display: v }));
    case 'distributor': return opts.distributors.map(v => ({ value: v, display: v }));
    case 'dealer':      return opts.dealers.map(v => ({ value: v, display: v }));
    case 'status':      return opts.statuses.map(v => ({ value: v, display: v }));
    default:            return [];
  }
});

function addShipmentFilter(value) {
  if (!value) return;
  const cat = shipmentFilterCategories.find(c => c.key === shipmentFilterCategory.value);
  const opt = shipmentFilterValueOptions.value.find(o => o.value === value);
  const mode = opt ? 'exact' : 'text';
  if (shipmentActiveFilters.value.some(f => f.key === shipmentFilterCategory.value && f.mode === mode && f.value === value)) return;
  shipmentActiveFilters.value.push({ key: shipmentFilterCategory.value, categoryLabel: cat.label, value, displayValue: opt?.display || value, mode });
}

function removeShipmentFilter(index) {
  shipmentActiveFilters.value.splice(index, 1);
}

function resetShipmentFilters() {
  shipmentActiveFilters.value = [];
}

const filteredShipments = computed(() => {
  if (!shipmentActiveFilters.value.length) return data.shipments;
  const groups = {};
  for (const f of shipmentActiveFilters.value) {
    (groups[f.key] = groups[f.key] || []).push({ value: f.value, mode: f.mode });
  }
  return data.shipments.filter(s => {
    for (const [key, entries] of Object.entries(groups)) {
      if (key === 'month') { if (!matchFilterGroup(entries, s.shipped_at?.slice(0, 7))) return false; }
      else if (key === 'model') { if (!s.items.some(i => matchFilterGroup(entries, i.model_name))) return false; }
      else if (key === 'distributor') { if (!matchFilterGroup(entries, s.distributor_company)) return false; }
      else if (key === 'dealer') { if (!matchFilterGroup(entries, s.dealer_company)) return false; }
      else if (key === 'status') { if (!matchFilterGroup(entries, s.received_at ? '입고 완료' : '입고 대기')) return false; }
    }
    return true;
  });
});

const salesFilterOptions = computed(() => {
  const unique = (mapper) => [...new Set(data.sales.map(mapper).filter(v => v !== null && v !== undefined && v !== ''))];
  return {
    months: unique(row => row.date?.slice(0, 7)).sort().reverse(),
    models: unique(row => row.model_name).sort(),
    distributors: unique(row => row.distributor_company).sort(),
    dealers: unique(row => row.dealer_company).sort(),
    unitPrices: unique(row => String(Number(row.unit_price || 0))).sort((a, b) => Number(a) - Number(b)),
    amounts: unique(row => String(Number(row.amount || 0))).sort((a, b) => Number(a) - Number(b))
  };
});

const filterValueOptions = computed(() => {
  const opts = salesFilterOptions.value;
  const money = (v) => Number(v || 0).toLocaleString('ko-KR', { maximumFractionDigits: 0 });
  switch (filterCategory.value) {
    case 'month':       return opts.months.map(v => ({ value: v, display: v }));
    case 'model':       return opts.models.map(v => ({ value: v, display: v }));
    case 'distributor': return opts.distributors.map(v => ({ value: v, display: v }));
    case 'dealer':      return opts.dealers.map(v => ({ value: v, display: v }));
    case 'unitPrice':   return opts.unitPrices.map(v => ({ value: v, display: money(v) + '원' }));
    case 'amount':      return opts.amounts.map(v => ({ value: v, display: money(v) + '원' }));
    case 'status':      return ['출고 전', '출고 완료'].map(v => ({ value: v, display: v }));
    default:            return [];
  }
});

function addFilter(value) {
  if (!value) return;
  const cat = filterCategories.find(c => c.key === filterCategory.value);
  const opt = filterValueOptions.value.find(o => o.value === value);
  const mode = opt ? 'exact' : 'text';
  if (activeFilters.value.some(f => f.key === filterCategory.value && f.mode === mode && f.value === value)) return;
  activeFilters.value.push({ key: filterCategory.value, categoryLabel: cat.label, value, displayValue: opt?.display || value, mode });
}

function removeFilter(index) {
  activeFilters.value.splice(index, 1);
}

const filteredSales = computed(() => {
  if (!activeFilters.value.length) return data.sales;
  const groups = {};
  for (const f of activeFilters.value) {
    (groups[f.key] = groups[f.key] || []).push({ value: f.value, mode: f.mode });
  }
  return data.sales.filter(row => {
    for (const [key, entries] of Object.entries(groups)) {
      let v;
      if (key === 'month')       v = row.date?.slice(0, 7);
      else if (key === 'model')       v = row.model_name;
      else if (key === 'distributor') v = row.distributor_company;
      else if (key === 'dealer')      v = row.dealer_company;
      else if (key === 'unitPrice')   v = String(Number(row.unit_price || 0));
      else if (key === 'amount')      v = String(Number(row.amount || 0));
      else if (key === 'status')      v = shipmentStatusLabel(row.status);
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

function resetSalesFilters() {
  activeFilters.value = [];
}

// 판매 상세 내역: 모델별로 다 풀어서 보여주는 대신 발주서 단위로 묶고, 펼치면 그 발주서의
// 모델별 품목이 아래에 나온다. 필터에 걸리는 모델이 하나라도 있으면 그 발주서 전체를 보여준다
// (펼쳤을 때 필터에 안 맞는 다른 모델도 함께 보임 — 발주서 원본 그대로 확인하기 위함).
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
        distributor_company: row.distributor_company,
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

// ── 수주현황 확정 목록 검색 필터 (판매현황 필터와 동일한 UI 패턴) ──
const confirmedFilterCategories = [
  { key: 'month',       label: '확정월' },
  { key: 'model',       label: '모델' },
  { key: 'distributor', label: '총판' },
  { key: 'dealer',      label: '대리점' },
  { key: 'amount',      label: '금액' },
];
const confirmedFilterCategory = ref('month');
const confirmedActiveFilters = ref([]);

const confirmedFilterOptions = computed(() => {
  const unique = (mapper) => [...new Set(orderConfirmedRows.value.flatMap(mapper).filter(v => v !== null && v !== undefined && v !== ''))];
  return {
    months: unique(o => [o.confirmed_at?.slice(0, 7)]).sort().reverse(),
    models: unique(o => o.items.map(i => i.model_name)).sort(),
    distributors: unique(o => [o.distributor_company]).sort(),
    dealers: unique(o => [o.dealer_company]).sort(),
    amounts: unique(o => [String(Number(o.total_amount || 0))]).sort((a, b) => Number(a) - Number(b))
  };
});

const confirmedFilterValueOptions = computed(() => {
  const opts = confirmedFilterOptions.value;
  switch (confirmedFilterCategory.value) {
    case 'month':       return opts.months.map(v => ({ value: v, display: v }));
    case 'model':       return opts.models.map(v => ({ value: v, display: v }));
    case 'distributor': return opts.distributors.map(v => ({ value: v, display: v }));
    case 'dealer':      return opts.dealers.map(v => ({ value: v, display: v }));
    case 'amount':      return opts.amounts.map(v => ({ value: v, display: money(v) + '원' }));
    default:            return [];
  }
});

function addConfirmedFilter(value) {
  if (!value) return;
  const cat = confirmedFilterCategories.find(c => c.key === confirmedFilterCategory.value);
  const opt = confirmedFilterValueOptions.value.find(o => o.value === value);
  const mode = opt ? 'exact' : 'text';
  if (confirmedActiveFilters.value.some(f => f.key === confirmedFilterCategory.value && f.mode === mode && f.value === value)) return;
  confirmedActiveFilters.value.push({ key: confirmedFilterCategory.value, categoryLabel: cat.label, value, displayValue: opt?.display || value, mode });
}

function removeConfirmedFilter(index) {
  confirmedActiveFilters.value.splice(index, 1);
}

function resetConfirmedFilters() {
  confirmedActiveFilters.value = [];
}

const filteredConfirmedOrders = computed(() => {
  if (!confirmedActiveFilters.value.length) return orderConfirmedRows.value;
  const groups = {};
  for (const f of confirmedActiveFilters.value) {
    (groups[f.key] = groups[f.key] || []).push({ value: f.value, mode: f.mode });
  }
  return orderConfirmedRows.value.filter(order => {
    for (const [key, entries] of Object.entries(groups)) {
      if (key === 'month') { if (!matchFilterGroup(entries, order.confirmed_at?.slice(0, 7))) return false; }
      else if (key === 'model') { if (!order.items.some(i => matchFilterGroup(entries, i.model_name))) return false; }
      else if (key === 'distributor') { if (!matchFilterGroup(entries, order.distributor_company)) return false; }
      else if (key === 'dealer') { if (!matchFilterGroup(entries, order.dealer_company)) return false; }
      else if (key === 'amount') { if (!matchFilterGroup(entries, String(Number(order.total_amount || 0)))) return false; }
    }
    return true;
  });
});

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

watch(() => auth.user, syncMyForm, { immediate: true });

const money = (v) => Number(v || 0).toLocaleString('ko-KR', { maximumFractionDigits: 0 });
function formatDT(dt) {
  if (!dt) return '-';
  const d = new Date(dt);
  const p = n => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${p(d.getMonth()+1)}-${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}`;
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
function openAddressSearch() {
  new window.daum.Postcode({
    oncomplete(data) {
      myForm.address = data.roadAddress || data.jibunAddress;
      myForm.addressDetail = '';
    }
  }).open();
}
function fmtDatetime(iso) {
  if (!iso) return '';
  const d = new Date(iso);
  return `${d.getFullYear()}년 ${d.getMonth()+1}월 ${d.getDate()}일 ${String(d.getHours()).padStart(2,'0')}:${String(d.getMinutes()).padStart(2,'0')}`;
}
function fmtDateTimeShort(iso) {
  if (!iso) return '';
  const d = new Date(iso);
  const pad = (n) => String(n).padStart(2, '0');
  return `${String(d.getFullYear()).slice(2)}-${pad(d.getMonth()+1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
}

function openProductModal() {
  error.value = '';
  editingProductId.value = null;
  Object.assign(productForm, { name: '', model_name: '', spec: '', base_price: 0 });
  productModalOpen.value = true;
}

function editProduct(item) {
  error.value = '';
  editingProductId.value = item.product_id;
  Object.assign(productForm, {
    name: item.name || '',
    model_name: item.model_name || '',
    spec: item.spec || '',
    base_price: Number(item.base_price || 0)
  });
  productModalOpen.value = true;
}

function closeProductModal() {
  if (productSubmitting.value) return;
  productModalOpen.value = false;
  editingProductId.value = null;
  Object.assign(productForm, { name: '', model_name: '', spec: '', base_price: 0 });
}

function openOrderById(orderId) {
  const order = data.orders.find(o => o.id === orderId);
  if (order) openOrder(order);
}

function openOrder(order) {
  editingOrder.value = {
    ...order,
    items: order.items.map((item) => ({
      ...item,
      quantity: Number(item.quantity),
      unit_price: Number(item.unit_price)
    }))
  };
}

async function saveOrderEdit() {
  try {
    await request(api.patch(`/orders/${editingOrder.value.id}`, editingOrder.value), { successMessage: '수주 내용이 수정되었습니다.' });
    editingOrder.value = null;
    await loadAll();
  } catch (err) {
    error.value = err.message;
  }
}

const canManageMembers = computed(() => !!(auth.user?.is_owner || auth.user?.is_member_manager));

// ── API ──────────────────────────────────────────────
async function loadAll() {
  error.value = '';
  try {
    const [dashboard, orders, inventory, products, pending, users, distributors, shipments, salesData] = await Promise.all([
      request(api.get('/dashboard/admin')), request(api.get('/orders/admin')),
      request(api.get('/inventory')), request(api.get('/products')),
      canManageMembers.value ? request(api.get('/users/pending')) : Promise.resolve({ users: [] }),
      canManageMembers.value ? request(api.get('/users')) : Promise.resolve({ users: [] }),
      request(api.get('/users/distributors')),
      request(api.get('/shipments')),
      request(api.get('/sales'))
    ]);
    data.dashboard = dashboard; data.orders = orders.orders;
    data.inventory = inventory.inventory; data.products = products.products;
    // 주기적 자동 새로고침 중에도 이미 골라둔 역할/총판 선택이 초기화되지 않도록 이전 선택값을 유지한다.
    const prevPendingSelections = new Map(data.pending.map(p => [p.id, { approveRole: p.approveRole, approveDistributorId: p.approveDistributorId }]));
    data.pending = pending.users.map(u => ({ approveRole: 'dealer', approveDistributorId: null, ...prevPendingSelections.get(u.id), ...u }));
    data.users = users.users;
    data.distributors = distributors.users; data.shipments = shipments.shipments;
    data.sales = salesData.sales; data.monthlySales = salesData.monthly;
    lastRefreshedAt.value = new Date();
  } catch (err) { error.value = err.message; }
}

async function reloadLineup() {
  try {
    const [lineupDashboard, dealerDashboard] = await Promise.all([
      request(api.get(`/dashboard/admin?period=${lineupPeriod.value}&date=${lineupDateParam.value}`)),
      request(api.get(`/dashboard/admin?period=${dealerPeriod.value}&date=${dealerDateParam.value}`))
    ]);
    data.dashboard = { ...lineupDashboard, dealers: dealerDashboard.dealers };
  } catch (err) { error.value = err.message; }
}

watch([lineupPeriod, lineupDate, dealerPeriod, dealerDate], reloadLineup);

async function refreshDashboard() {
  dashboardRefreshing.value = true;
  try {
    await loadAll();
    await reloadLineup();
  } finally {
    dashboardRefreshing.value = false;
  }
}

async function saveMyProfile() {
  try {
    if (myForm.password && myForm.password !== myForm.passwordConfirm) {
      notify('비밀번호 확인이 일치하지 않습니다.', 'error'); return;
    }
    const payload = {
      company_name: myForm.company_name, business_number: myForm.business_number, ceo_name: myForm.ceo_name, company_phone: myForm.company_phone,
      fax: myForm.fax, address: myForm.address, address_detail: myForm.addressDetail,
      manager_name: myForm.manager_name, manager_department: myForm.manager_department, manager_position: myForm.manager_position,
      manager_phone: myForm.manager_phone, manager_email: myForm.manager_email, manager_memo: myForm.manager_memo
    };
    if (myForm.password) payload.password = myForm.password;
    await request(api.patch('/users/me', payload), { successMessage: '계정 정보가 수정되었습니다.' });
    await auth.loadMe();
    myForm.password = '';
    myForm.passwordConfirm = '';
  } catch (err) { error.value = err.message; }
}

async function saveProduct() {
  productSubmitting.value = true;
  try {
    if (editingProductId.value) {
      await request(api.patch(`/products/${editingProductId.value}`, productForm), { successMessage: '제품 정보가 수정되었습니다.' });
    } else {
      await request(api.post('/products', productForm), { successMessage: '제품이 등록되었습니다.' });
    }
    editingProductId.value = null;
    Object.assign(productForm, { name: '', model_name: '', spec: '', base_price: 0 });
    productModalOpen.value = false;
    await loadAll();
  } catch (err) {
    error.value = err.message;
  } finally {
    productSubmitting.value = false;
  }
}

async function deleteProduct(product) {
  const confirmed = await confirmAction({
    title: '제품 삭제',
    message: `${product.name} ${product.model_name} 제품을 삭제하시겠습니까?\n기존 발주 이력은 유지되고, 신규 발주 목록에서 제외됩니다.`,
    confirmText: '제품 삭제',
    danger: true
  });
  if (!confirmed) return;
  try {
    await request(api.delete(`/products/${product.id}`), { successMessage: '제품이 삭제되었습니다.' });
    await loadAll();
  } catch (err) { error.value = err.message; }
}
// ── 입고 등록: 추가재고 입력 + 바코드 스캔(클라이언트 파싱, 저장 전까지는 로컬 상태) ──
const pendingAdd = reactive({});
const highlightedProductId = ref(null);
const scanBarcodeInput = ref('');
const scanBarcodeEl = ref(null);
const scanError = ref('');
let highlightTimer = null;

function resetPendingAdd() {
  for (const item of data.inventory) pendingAdd[item.product_id] = 0;
}
watch(() => data.inventory.length, resetPendingAdd, { immediate: true });

function parseBarcodeModel(raw) {
  const parts = raw.trim().split('|');
  if (parts.length < 2 || parts[0] !== 'ATG') return null;
  return parts[1] || null;
}

async function onScanBarcode() {
  scanError.value = '';
  const raw = scanBarcodeInput.value.trim();
  if (!raw) return;
  const modelName = parseBarcodeModel(raw);
  const product = modelName && data.products.find((p) => p.model_name === modelName);
  scanBarcodeInput.value = '';
  if (!product) {
    scanError.value = `등록되지 않은 바코드입니다: ${raw}`;
    scanBarcodeEl.value?.focus();
    return;
  }
  pendingAdd[product.id] = (pendingAdd[product.id] || 0) + 1;
  highlightedProductId.value = product.id;
  await nextTick();
  document.querySelector('.receive-row-highlighted')?.scrollIntoView({ behavior: 'smooth', block: 'center' });
  clearTimeout(highlightTimer);
  highlightTimer = setTimeout(() => { highlightedProductId.value = null; }, 1500);
  scanBarcodeEl.value?.focus();
}

async function saveReceiveBatch() {
  const items = Object.entries(pendingAdd)
    .map(([productId, quantity]) => ({ product_id: Number(productId), quantity: Number(quantity) }))
    .filter((i) => i.quantity > 0);
  if (!items.length) {
    notify('추가재고를 1개 이상 입력해주세요.', 'error');
    return;
  }
  try {
    await request(api.post('/inventory/receive-batch', { items }), { successMessage: '입고 등록이 완료되어 재고가 반영되었습니다.' });
    await loadAll();
    resetPendingAdd();
  } catch (err) { error.value = err.message; }
}

// ── 재고현황: 현재재고 직접 보정(오차/파손 등 즉시 반영) ──
const stockEdit = reactive({});
function isStockEdited(item) {
  return stockEdit[item.id] !== undefined && stockEdit[item.id] !== '' && Number(stockEdit[item.id]) !== item.quantity;
}
async function saveStockQuantity(item) {
  const quantity = Number(stockEdit[item.id]);
  if (!Number.isInteger(quantity) || quantity < 0) {
    notify('올바른 재고 수량을 입력해주세요.', 'error');
    return;
  }
  try {
    await request(api.patch(`/inventory/${item.id}`, { quantity }), { successMessage: '현재재고가 수정되었습니다.' });
    delete stockEdit[item.id];
    await loadAll();
  } catch (err) { error.value = err.message; }
}

async function approve(user) {
  try {
    await request(api.post(`/users/${user.id}/approve`, {
      role: user.approveRole || 'dealer',
      distributor_id: (user.approveRole || 'dealer') === 'dealer' ? (user.approveDistributorId || null) : null
    }));
    await loadAll();
  } catch (err) { error.value = err.message; }
}
async function reject(user) {
  const confirmed = await confirmAction({
    title: '가입 신청 거절',
    message: `${user.name} 회원의 가입 신청을 거절하시겠습니까?`,
    confirmText: '거절',
    danger: true
  });
  if (!confirmed) return;
  try { await request(api.post(`/users/${user.id}/reject`), { successMessage: '가입 신청을 거절했습니다.' }); await loadAll(); }
  catch (err) { error.value = err.message; }
}
async function unreject(user) {
  const confirmed = await confirmAction({
    title: '거부 해제',
    message: `${user.company_name || user.name}의 거부를 해제하고 대기 상태로 되돌리시겠습니까?`,
    confirmText: '거부 해제'
  });
  if (!confirmed) return;
  try { await request(api.post(`/users/${user.id}/unreject`), { successMessage: '거부 해제 후 대기 상태로 변경되었습니다.' }); await loadAll(); }
  catch (err) { error.value = err.message; }
}
async function updateStatus(order, status) {
  const confirmed = await confirmAction(status === 'CANCELLED'
    ? {
        title: '수주 취소',
        message: `발주서 ${order.order_number}을 취소하시겠습니까?\n취소 후에는 현재 화면에서 되돌릴 수 없습니다.`,
        confirmText: '수주 취소',
        danger: true
      }
    : {
        title: '수주 확정',
        message: `발주서 ${order.order_number}을 수주 확정하시겠습니까?`,
        confirmText: '수주 확정'
      });
  if (!confirmed) return false;
  try {
    const successMessage = status === 'CONFIRMED' ? '수주 확정이 완료되었습니다.' : '수주가 취소되었습니다.';
    await request(api.patch(`/orders/${order.id}/status`, { status }), { successMessage });
    await loadAll();
    return true;
  }
  catch (err) { error.value = err.message; return false; }
}
// ── 발주서 모달에서 상태 처리(수주 확정/취소, 출고 등록) ──────────────
// 판매현황에서 발주서를 확인할 때는 조회 목적이라 처리 버튼을 띄우지 않는다.
const editingOrderCanConfirm = computed(() => view.value !== 'sales' && editingOrder.value?.status === 'CONVERTED');
const editingOrderCanCancel = computed(() => {
  const o = editingOrder.value;
  if (!o || view.value === 'sales') return false;
  return o.status === 'CONVERTED' || (o.status === 'CONFIRMED' && !o.shipped_at);
});
const editingOrderCanShip = computed(() => {
  const o = editingOrder.value;
  if (!o || view.value === 'sales') return false;
  return ['CONFIRMED', 'PARTIALLY_SHIPPED'].includes(o.status)
    && o.items.some(i => Number(i.quantity) - Number(i.shipped_quantity || 0) > 0);
});
async function confirmFromModal() {
  const ok = await updateStatus(editingOrder.value, 'CONFIRMED');
  if (ok) editingOrder.value = null;
}
async function cancelFromModal() {
  const ok = await updateStatus(editingOrder.value, 'CANCELLED');
  if (ok) editingOrder.value = null;
}
function shipFromModal() {
  const order = editingOrder.value;
  editingOrder.value = null;
  openShipModal(order);
}

// ── 출고 등록 모달 (품목별 부분 출고 지원) ──────────────────────────
const shipModalOrder = ref(null);
const shipModalRows = ref([]);
const shipModalMeta = reactive({ delivery_address: '', tracking_number: '', carrier_code: '' });
const shipSubmitting = ref(false);
const statementPreview = ref(null);

function openShipModal(order) {
  shipModalOrder.value = order;
  shipModalRows.value = order.items.map((item) => {
    const remaining = Number(item.quantity) - Number(item.shipped_quantity || 0);
    return { ...item, remaining, ship_qty: remaining };
  });
  Object.assign(shipModalMeta, {
    delivery_address: order.distributor_address || order.delivery_address || '',
    tracking_number: '',
    carrier_code: ''
  });
}

function closeShipModal() {
  if (shipSubmitting.value) return;
  shipModalOrder.value = null;
  shipModalRows.value = [];
}

// 발주 하나가 부분출고로 여러 번 나갔을 수 있어, 실제 출고(shipment) 건별로 한 페이지씩 만든다.
// 제조사→총판 거래명세서이므로 총판 판매가(unit_price)가 아니라 발주 전환 시점에 스냅샷된
// 제조사 판매가(manufacturer_unit_price)를 쓴다. 전환 기능 이전에 만들어진 주문은 값이 없을 수 있어 unit_price로 대체.
function myCompanyInfoMissing() {
  const u = auth.user;
  return !u?.business_number || !u?.ceo_name || !u?.address || !u?.company_phone || !u?.fax;
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
      editingOrder.value = null;
      router.push('/admin/settings');
      settingsTab.value = 'profile';
    }
    return;
  }
  const shipmentsForOrder = data.shipments
    .filter((s) => s.order_id === order.id && s.items?.length)
    .slice()
    .sort((a, b) => new Date(a.shipped_at) - new Date(b.shipped_at));

  // 아직 실제 출고가 없어도 수주 확정(CONFIRMED) 이후라면 발주 품목 전체를 한 페이지로 미리 보여준다.
  if (!shipmentsForOrder.length) {
    if (!['CONFIRMED', 'PARTIALLY_SHIPPED', 'SHIPPED', 'DELIVERED'].includes(order.status)) {
      notify('아직 발주가 확정되지 않아 거래명세서를 만들 수 없습니다.', 'error');
      return;
    }
    statementPreview.value = {
      order,
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
  statementPreview.value = { order, pages };
}

function previewStatement() {
  const items = shipModalRows.value
    .filter((row) => Number(row.ship_qty) > 0)
    .map((row) => ({
      product_name: row.product_name,
      model_name: row.model_name,
      quantity: Number(row.ship_qty),
      unit_price: Number(row.unit_price)
    }));
  if (!items.length) {
    notify('출고할 수량을 1개 이상 입력해주세요.', 'error');
    return;
  }
  statementPreview.value = {
    order: shipModalOrder.value,
    pages: [{ items, meta: { ...shipModalMeta } }]
  };
}

async function submitShip() {
  const order = shipModalOrder.value;
  const items = shipModalRows.value
    .filter((row) => Number(row.ship_qty) > 0)
    .map((row) => ({ order_item_id: row.id, quantity: Number(row.ship_qty) }));
  if (!items.length) {
    notify('출고할 수량을 1개 이상 입력해주세요.', 'error');
    return;
  }
  const confirmed = await confirmAction({
    title: '출고 등록',
    message: `발주서 ${order.order_number}을 출고 처리하시겠습니까?\n출고 시 제조사 재고가 즉시 차감됩니다.`,
    confirmText: '출고 등록'
  });
  if (!confirmed) return;
  shipSubmitting.value = true;
  try {
    await request(
      api.post('/shipments', {
        order_id: order.id,
        delivery_address: shipModalMeta.delivery_address,
        tracking_number: shipModalMeta.tracking_number || null,
        carrier_code: shipModalMeta.carrier_code || null,
        items
      }),
      { successMessage: '출고 등록이 완료되어 제조사 재고가 차감되었습니다.' }
    );
    shipSubmitting.value = false;
    closeShipModal();
    await loadAll();
  } catch (err) {
    error.value = err.message;
    shipSubmitting.value = false;
  }
}
async function saveMember() {
  try {
    if (editForm.password && editForm.password !== editForm.passwordConfirm) {
      notify('비밀번호 확인이 일치하지 않습니다.', 'error'); return;
    }
    const payload = {
      name: editForm.name,
      phone: editForm.phone,
      company_name: editForm.company_name,
      address: editForm.address,
      role: editForm.role,
      status: editForm.status,
      distributor_id: editForm.role === 'dealer' ? editForm.distributor_id : null,
      manager_name: editForm.manager_name,
      manager_department: editForm.manager_department,
      manager_position: editForm.manager_position,
      manager_phone: editForm.manager_phone,
      manager_email: editForm.manager_email,
      manager_memo: editForm.manager_memo
    };
    if (editForm.password) payload.password = editForm.password;
    await request(api.patch(`/users/${selectedUser.value.id}`, payload));
    selectedUser.value = null; await loadAll();
  } catch (err) { error.value = err.message; }
}
const deleteModalOpen = ref(false);
async function onMemberDeleted() {
  deleteModalOpen.value = false;
  selectedUser.value = null;
  await loadAll();
}

async function toggleMemberManager(user, checked) {
  const confirmed = await confirmAction({
    title: checked ? '담당자 지정' : '담당자 해제',
    message: checked
      ? `${user.name}(${user.username})님을 담당자로 지정하시겠습니까?\n회원관리 화면에 접근할 수 있게 됩니다.`
      : `${user.name}(${user.username})님의 담당자 권한을 해제하시겠습니까?`,
    confirmText: checked ? '지정' : '해제',
    danger: !checked
  });
  if (!confirmed) return;
  try {
    const { user: updated } = await request(
      api.patch(`/users/${user.id}/member-manager`, { is_member_manager: checked }),
      { successMessage: checked ? '담당자로 지정되었습니다.' : '담당자 권한이 해제되었습니다.' }
    );
    if (selectedUser.value?.id === updated.id) selectedUser.value = updated;
    await loadAll();
  } catch (err) { error.value = err.message; }
}

// ── 설정 > 담당자 설정: 위쪽엔 지정된 담당자, 아래쪽엔 지정 가능한 직원 목록 표시 ──
const adminManagerList = computed(() => data.users.filter((u) => u.role === 'admin' && u.is_member_manager));
const adminStaffList = computed(() =>
  data.users.filter((u) => u.role === 'admin' && !u.is_owner && !u.is_member_manager && u.status === 'active')
);

let autoRefreshTimer = null;

onMounted(() => {
  // loadAll()의 /dashboard/admin 호출은 기간 파라미터가 없어 서버 기본값(월별)로 응답하는데,
  // lineupPeriod/dealerPeriod의 초기값(일별)과 어긋나 버튼은 "일별"인데 실제 데이터는 월별로 보이는 문제가 있었음.
  // reloadLineup()으로 각 패널의 실제 선택된 기간에 맞춰 한 번 더 맞춰준다.
  loadAll().then(reloadLineup);
  if (!window.daum?.Postcode) {
    const script = document.createElement('script');
    script.src = 'https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js';
    document.head.appendChild(script);
  }
  autoRefreshTimer = setInterval(refreshDashboard, 60000);
});

onUnmounted(() => {
  if (autoRefreshTimer) clearInterval(autoRefreshTimer);
});
</script>

<template>
  <AppShell :title="viewTitles[view] || '대시보드'" :menu="menu" :refreshing="dashboardRefreshing"
    :last-refreshed="lastRefreshedAt" @refresh="refreshDashboard">
    <p v-if="error" class="error">{{ error }}</p>

    <!-- 대시보드 -->
    <template v-if="view === 'dashboard'">
      <div class="dashboard-grid">

        <!-- 상단 3열: 달력 | KPI 2×2 | 신규 수주 -->
        <div class="dashboard-row1">

          <!-- 달력 -->
          <MiniCalendar
            :marked-dates="data.orders.filter(o => o.status !== 'CANCELLED').map(o => o.ordered_at)"
            :selected-date="lineupSelectedDate"
            allow-any-date
            @select="onCalendarSelect"
          />

          <!-- KPI 카드 2×2 -->
          <section v-if="data.dashboard" class="dash-kpi">
            <KpiCard label="이번 달 수주" :value="data.dashboard.summary.monthly_orders" hint="건" />
            <KpiCard label="현재 재고" :value="data.dashboard.summary.current_inventory" hint="개" />
            <KpiCard label="이번 달 판매액" :value="`${money(data.dashboard.summary.monthly_sales)}원`" note="발주 기준" />
            <KpiCard label="이번 달 출고" :value="data.dashboard.summary.monthly_shipments" hint="건" />
          </section>
          <div v-else class="dash-kpi" />

          <!-- 알림 패널 -->
          <div class="panel" :class="{ 'panel-alert': orderWaitingRows.length || readyToShipOrders.length }">
            <div class="panel-head-row">
              <h2 style="margin:0">
                <span v-if="alertTotalCount" class="alert-exclaim">!</span>
                알림
                <span v-if="alertTotalCount" class="badge" style="margin-left:4px;font-size:11px">{{ alertTotalCount }}</span>
              </h2>
              <div class="alert-type-btns">
                <button class="badge s-CONVERTED alert-filter-badge" :class="{ active: alertFilter === 'order' }"
                        @click="alertFilter = alertFilter === 'order' ? 'all' : 'order'">
                  수주 {{ orderWaitingRows.length }}
                </button>
                <button class="badge s-CONFIRMED alert-filter-badge" :class="{ active: alertFilter === 'ship' }"
                        @click="alertFilter = alertFilter === 'ship' ? 'all' : 'ship'">
                  출고 {{ readyToShipOrders.length }}
                </button>
              </div>
            </div>
            <div class="panel-table-wrap">
              <table>
                <thead>
                  <tr><th style="width:70px">구분</th><th>대리점</th><th style="width:100px;text-align:right">합계</th><th style="width:140px">발주일시</th></tr>
                </thead>
                <tbody>
                  <tr v-for="row in filteredAlertRows" :key="row._type+'-'+row.id"
                      class="dash-new-order-row"
                      @click="router.push(row._type === 'order' ? '/admin/orders' : '/admin/shipments')">
                    <td><span class="badge" :class="row._type === 'order' ? 's-CONVERTED' : 's-CONFIRMED'">{{ row._type === 'order' ? '수주' : '출고' }}</span></td>
                    <td>{{ row.dealer_company }}</td>
                    <td style="text-align:right;font-weight:700">{{ money(row.total_amount) }}</td>
                    <td>{{ formatDT(row.ordered_at) }}</td>
                  </tr>
                  <tr v-if="!filteredAlertRows.length">
                    <td colspan="4" class="empty-row">알림이 없습니다.</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

        </div>

        <!-- 하단 2열: LINE UP | 대리점 -->
        <div class="dashboard-row2">
          <div class="panel">
            <div class="panel-head-row">
              <h2>LINE UP 제품 현황</h2>
              <div class="lineup-nav">
                <button class="lineup-nav-arrow" @click="prevPeriod">‹</button>
                <span class="lineup-nav-label">{{ lineupDateLabel }}</span>
                <button class="lineup-nav-arrow" @click="nextPeriod">›</button>
              </div>
              <div class="period-filter">
                <button :class="{ active: lineupPeriod === 'daily' }" @click="lineupPeriod = 'daily'">일별</button>
                <button :class="{ active: lineupPeriod === 'monthly' }" @click="lineupPeriod = 'monthly'">월별</button>
                <button :class="{ active: lineupPeriod === 'yearly' }" @click="lineupPeriod = 'yearly'">연도별</button>
                <button :class="{ active: lineupPeriod === 'all' }" @click="lineupPeriod = 'all'">전체</button>
              </div>
            </div>
            <div class="panel-table-wrap">
              <Transition name="fade-swap" mode="out-in">
                <table :key="lineupDateLabel"><thead><tr><th style="width:188px">제품</th><th style="width:188px">모델</th><th style="width:90px">판매개수</th><th style="width:90px">재고</th><th style="width:100px">판매액</th></tr></thead>
                  <tbody>
                    <tr v-for="row in data.dashboard?.lineup || []" :key="row.id">
                      <td>{{ row.name }}</td><td>{{ row.model_name }}</td><td>{{ row.monthly_order_qty }}</td>
                      <td>{{ row.inventory_qty }}</td><td>{{ money(row.sales_amount) }}</td>
                    </tr>
                  </tbody>
                </table>
              </Transition>
            </div>
          </div>
          <div class="panel">
            <div class="panel-head-row">
              <h2>등록 판매대리점</h2>
              <div class="lineup-nav">
                <button class="lineup-nav-arrow" @click="prevDealerPeriod">‹</button>
                <span class="lineup-nav-label">{{ dealerDateLabel }}</span>
                <button class="lineup-nav-arrow" @click="nextDealerPeriod">›</button>
              </div>
              <div class="period-filter">
                <button :class="{ active: dealerPeriod === 'daily' }" @click="dealerPeriod = 'daily'">일별</button>
                <button :class="{ active: dealerPeriod === 'monthly' }" @click="dealerPeriod = 'monthly'">월별</button>
                <button :class="{ active: dealerPeriod === 'yearly' }" @click="dealerPeriod = 'yearly'">연도별</button>
                <button :class="{ active: dealerPeriod === 'all' }" @click="dealerPeriod = 'all'">전체</button>
              </div>
            </div>
            <div class="panel-table-wrap">
              <Transition name="fade-swap" mode="out-in">
                <table :key="dealerDateLabel"><thead><tr><th style="width:245px">대리점</th><th style="width:130px">소속 총판</th><th style="width:70px">발주</th><th style="width:100px">총 금액</th><th style="width:110px">최근 발주</th></tr></thead>
                <tbody>
                  <tr v-for="row in data.dashboard?.dealers || []" :key="row.dealer_company">
                    <td>{{ row.dealer_company }}</td><td>{{ row.distributor_company || '-' }}</td>
                    <td>{{ row.order_count }}</td><td>{{ money(row.total_amount) }}</td>
                    <td>{{ row.last_ordered_at ? row.last_ordered_at.slice(0, 10) : '-' }}</td>
                  </tr>
                  <tr v-if="!data.dashboard?.dealers?.length">
                    <td colspan="5" class="empty-row">해당 기간에 발주한 대리점이 없습니다.</td>
                  </tr>
                </tbody>
              </table>
              </Transition>
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
            대기 목록 <span class="badge-count" :class="{ 'badge-red': orderSummary.waiting > 0 }">{{ orderSummary.waiting }}</span>
          </button>
          <button :class="{ active: orderTab === 'confirmed' }" @click="orderTab = 'confirmed'">
            수주 내역 <span class="badge-count">{{ orderSummary.confirmed }}</span>
          </button>
        </div>

        <!-- 대기 목록 -->
        <section v-if="orderTab === 'waiting'" class="panel">
          <div class="panel-table-wrap">
            <table>
              <thead><tr><th style="width:44px">No.</th><th style="width:190px">발주번호</th><th style="width:140px">총판</th><th style="width:190px">대리점</th><th>품목</th><th style="width:100px;text-align:right">합계</th><th style="width:100px">발주일</th><th style="width:160px">수주 처리</th></tr></thead>
              <tbody>
                <tr v-for="(order, index) in orderWaitingRows" :key="order.id" class="clickable-row" @click="openOrder(order)">
                  <td>{{ orderWaitingRows.length - index }}</td>
                  <td class="order-num">{{ order.order_number }}</td>
                  <td>{{ order.distributor_company }}</td><td>{{ order.dealer_company }}</td>
                  <td><span class="items-line" :title="order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ')">{{ order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ') }}</span></td>
                  <td style="text-align:right;font-weight:700">{{ money(order.total_amount) }}</td>
                  <td>{{ order.ordered_at?.slice(0, 10) }}</td>
                  <td>
                    <div class="actions" @click.stop>
                      <button @click="updateStatus(order, 'CONFIRMED')">수주 확정</button>
                      <button class="btn-danger" @click="updateStatus(order, 'CANCELLED')">취소</button>
                    </div>
                  </td>
                </tr>
                <tr v-if="!orderWaitingRows.length"><td colspan="8" class="empty-row">수주 확정 대기 내역이 없습니다.</td></tr>
              </tbody>
            </table>
          </div>
        </section>

        <!-- 수주 내역 -->
        <section v-else-if="orderTab === 'confirmed'" class="panel">
          <div class="page-section-head">
            <div>
              <p class="text-muted">총 {{ filteredConfirmedOrders.length }}건이 검색되었습니다.</p>
            </div>
          </div>
          <div class="smart-filter-bar">
            <div class="filter-selectors">
              <select v-model="confirmedFilterCategory" class="filter-cat-select">
                <option v-for="cat in confirmedFilterCategories" :key="cat.key" :value="cat.key">{{ cat.label }}</option>
              </select>
              <FilterSearchInput :options="confirmedFilterValueOptions" @add="addConfirmedFilter" />
            </div>
            <div class="filter-chips">
              <span v-for="(f, i) in confirmedActiveFilters" :key="i" class="filter-chip">
                <span class="chip-text">{{ f.categoryLabel }}: {{ f.displayValue }}</span>
                <button class="chip-remove" type="button" @click="removeConfirmedFilter(i)">×</button>
              </span>
              <button v-if="confirmedActiveFilters.length" class="secondary chip-reset" type="button" @click="resetConfirmedFilters">전체 해제</button>
            </div>
          </div>
          <div class="panel-table-wrap">
            <table>
              <thead><tr><th style="width:44px">No.</th><th style="width:190px">발주번호</th><th style="width:140px">총판</th><th style="width:190px">대리점</th><th>품목</th><th style="width:100px;text-align:right">합계</th><th style="width:90px">상태</th><th style="width:100px">확정일</th><th style="width:160px">출고 처리</th></tr></thead>
              <tbody>
                <tr v-for="(order, index) in filteredConfirmedOrders" :key="order.id" class="clickable-row" @click="openOrder(order)">
                  <td>{{ filteredConfirmedOrders.length - index }}</td>
                  <td class="order-num">{{ order.order_number }}</td>
                  <td>{{ order.distributor_company }}</td><td>{{ order.dealer_company }}</td>
                  <td><span class="items-line" :title="order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ')">{{ order.items.map((i) => `${i.model_name} ×${i.quantity}`).join(', ') }}</span></td>
                  <td style="text-align:right;font-weight:700">{{ money(order.total_amount) }}</td>
                  <td><span class="badge" :class="order.status === 'CANCELLED' ? 's-CANCELLED' : 's-CONFIRMED'">{{ order.status === 'CANCELLED' ? '수주 취소' : '수주 확정' }}</span></td>
                  <td>{{ order.confirmed_at?.slice(0, 10) }}</td>
                  <td @click.stop>
                    <div v-if="order.status === 'CANCELLED'">-</div>
                    <div v-else-if="order.shipped_at" class="ship-done-info">
                      <span class="badge s-SHIPPED">출고 등록 완료</span>
                      <span class="ship-done-date">{{ fmtDatetime(order.shipped_at) }}</span>
                    </div>
                    <div v-else class="actions actions-neutral">
                      <button class="goto-ship-btn" @click="goToShipments(order)">출고 등록</button>
                      <button class="btn-danger" @click="updateStatus(order, 'CANCELLED')">취소</button>
                    </div>
                  </td>
                </tr>
                <tr v-if="!filteredConfirmedOrders.length"><td colspan="9" class="empty-row">검색 조건에 맞는 수주 내역이 없습니다.</td></tr>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </template>

    <!-- 재고현황 -->
    <template v-else-if="view === 'inventory'">
      <div class="orders-split-layout">
        <div class="tab-bar">
          <button :class="{ active: inventoryTab === 'stock' }" @click="inventoryTab = 'stock'">
            재고현황 <span class="badge-count">{{ data.inventory.length }}</span>
          </button>
          <button :class="{ active: inventoryTab === 'barcode' }" @click="inventoryTab = 'barcode'">
            입고 등록
          </button>
        </div>

        <section v-if="inventoryTab === 'stock'" class="panel">
          <div class="panel-table-wrap">
          <table><thead><tr><th style="width:44px">No.</th><th style="width:456px">제품명</th><th style="width:278px">모델</th><th style="width:218px">규격</th><th style="width:180px;text-align:center">현재 재고</th><th style="width:140px;text-align:right">단가</th></tr></thead>
            <tbody>
              <tr v-for="(item, index) in data.inventory" :key="item.id">
                <td>{{ index + 1 }}</td>
                <td>{{ item.name }}</td><td>{{ item.model_name }}</td><td>{{ item.spec }}</td>
                <td style="text-align:center">
                  <div style="display:flex;justify-content:center;align-items:center;gap:6px">
                    <input
                      :value="stockEdit[item.id] ?? item.quantity"
                      @input="stockEdit[item.id] = $event.target.value"
                      type="number"
                      min="0"
                      style="width:90px;text-align:right;font-weight:700"
                    />
                    <button v-if="isStockEdited(item)" class="primary" @click="saveStockQuantity(item)">저장</button>
                  </div>
                </td>
                <td style="text-align:right">{{ money(item.base_price) }}</td>
              </tr>
            </tbody>
          </table>
          </div>
        </section>

        <div v-else-if="inventoryTab === 'barcode'" class="inventory-receive-stack">
          <div class="barcode-section">
            <div class="barcode-header">
              <h3>바코드로 추가재고 등록</h3>
              <span class="barcode-format-hint">스캔할 때마다 해당 품목의 추가재고가 1개씩 올라갑니다.</span>
            </div>
            <div class="barcode-input-row">
              <div class="barcode-input-wrap">
                <span class="barcode-icon">▣</span>
                <input
                  ref="scanBarcodeEl"
                  v-model="scanBarcodeInput"
                  class="barcode-input"
                  placeholder="바코드를 스캐너로 읽거나 직접 입력하세요"
                  autocomplete="off"
                  @keyup.enter="onScanBarcode"
                />
              </div>
              <button class="primary" @click="onScanBarcode">입력</button>
            </div>
            <div class="barcode-example">
              <span class="example-label">예시</span>
              <code>ATG|PB-10000|SN2024000001|20240601</code>
              <span class="example-desc">→ 모델명 PB-10000의 추가재고 +1</span>
            </div>
            <p v-if="scanError" class="error">{{ scanError }}</p>
          </div>

          <section class="panel">
            <div class="page-section-head">
              <div>
                <p class="text-muted">추가재고를 입력하고 저장을 누르면 현재재고에 반영됩니다.</p>
              </div>
              <button class="primary" @click="saveReceiveBatch">저장</button>
            </div>
            <div class="panel-table-wrap">
            <table><thead><tr><th style="width:44px">No.</th><th>제품명</th><th style="width:110px">모델</th><th style="width:140px">규격</th><th style="width:100px;text-align:right">현재재고</th><th style="width:130px;text-align:center">추가재고</th></tr></thead>
              <tbody>
                <tr v-for="(item, index) in data.inventory" :key="item.id" :class="{ 'receive-row-highlighted': highlightedProductId === item.product_id, 'receive-row-pending': Number(pendingAdd[item.product_id]) > 0 }">
                  <td>{{ index + 1 }}</td>
                  <td>{{ item.name }}</td><td>{{ item.model_name }}</td><td>{{ item.spec }}</td>
                  <td style="text-align:right">{{ item.quantity }}</td>
                  <td style="text-align:center">
                    <input
                      :value="pendingAdd[item.product_id] ?? 0"
                      @input="pendingAdd[item.product_id] = Number($event.target.value)"
                      type="number"
                      min="0"
                      style="width:80px;text-align:right"
                    />
                  </td>
                </tr>
              </tbody>
            </table>
            </div>
          </section>
        </div>
      </div>
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
              <thead><tr><th style="width:54px">No.</th><th style="width:170px">일시</th><th style="width:140px">총판</th><th style="width:140px">대리점</th><th style="width:150px">모델</th><th style="width:80px;text-align:right">수량</th><th style="width:100px;text-align:right">단가</th><th style="width:100px;text-align:right">금액</th><th style="width:90px;text-align:center">상태</th></tr></thead>
              <tbody>
                <template v-for="(group, i) in groupedSales" :key="group.order_id">
                  <tr class="clickable-row" @click="group.items.length === 1 ? openOrderById(group.order_id) : toggleSalesOrder(group.order_id)">
                    <td>{{ groupedSales.length - i }}</td>
                    <td>{{ group.date }}</td><td>{{ group.distributor_company }}</td><td>{{ group.dealer_company }}</td>
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
                      <td></td>
                      <td class="sales-item-model">{{ item.model_name }}</td>
                      <td style="text-align:right">{{ item.quantity }}</td>
                      <td style="text-align:right">{{ money(item.unit_price) }}</td>
                      <td style="text-align:right">{{ money(item.amount) }}</td>
                      <td></td>
                    </tr>
                  </template>
                </template>
                <tr v-if="!groupedSales.length"><td colspan="9" class="empty-row">검색 조건에 맞는 판매 내역이 없습니다.</td></tr>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </template>

    <!-- 출고현황 -->
    <template v-else-if="view === 'shipments'">
      <div class="shipments-layout">
        <!-- 탭 -->
        <div class="tab-bar">
          <button :class="{ active: shipmentTab === 'ready' }" @click="shipmentTab = 'ready'">
            출고 대기 <span class="badge-count" :class="{ 'badge-red': readyToShipOrders.length > 0 }">{{ readyToShipOrders.length }}</span>
          </button>
          <button :class="{ active: shipmentTab === 'history' }" @click="shipmentTab = 'history'">
            출고 처리 내역 <span class="badge-count">{{ data.shipments.length }}</span>
          </button>
        </div>

        <!-- 출고 대기 -->
        <section v-if="shipmentTab === 'ready'" class="panel">
          <div class="page-section-head">
            <div>
              <h2>출고 대기</h2>
              <p class="text-muted">운송장번호 입력 후 출고 등록하면 제조사 재고가 차감됩니다.</p>
            </div>
          </div>
          <div class="panel-table-wrap">
            <table>
              <thead><tr><th style="width:44px">No.</th><th style="width:140px">발주번호</th><th style="width:140px">총판</th><th style="width:140px">대리점</th><th style="width:200px">품목</th><th style="width:130px;text-align:right">합계</th><th style="width:220px">배송지</th><th style="width:110px">출고 처리</th></tr></thead>
              <tbody>
                <tr v-for="(order, index) in readyToShipOrders" :key="order.id" class="clickable-row" :class="{ 'row-highlighted': order.order_number === highlightOrderNum }" @click="openOrder(order)">
                  <td>{{ readyToShipOrders.length - index }}</td>
                  <td class="order-num">{{ order.order_number }}</td>
                  <td>{{ order.distributor_company }}</td>
                  <td>{{ order.dealer_company }}</td>
                  <td>{{ order.items.map((i) => `${i.model_name} ×${i.quantity - (i.shipped_quantity||0)}`).join(', ') }}</td>
                  <td style="text-align:right;font-weight:700">{{ money(order.total_amount) }}</td>
                  <td>{{ order.distributor_address || order.delivery_address || '-' }}</td>
                  <td @click.stop><button @click="openShipModal(order)">출고 등록</button></td>
                </tr>
                <tr v-if="!readyToShipOrders.length"><td colspan="8" class="empty-row">출고 대기 중인 수주가 없습니다.</td></tr>
              </tbody>
            </table>
          </div>
        </section>

        <!-- 출고 처리 내역 -->
        <section v-else-if="shipmentTab === 'history'" class="panel">
          <div class="page-section-head">
            <div>
              <h2 style="display:flex;align-items:center;gap:8px;margin-bottom:4px">
                출고 처리 내역
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
              <select v-model="shipmentFilterCategory" class="filter-cat-select">
                <option v-for="cat in shipmentFilterCategories" :key="cat.key" :value="cat.key">{{ cat.label }}</option>
              </select>
              <FilterSearchInput :options="shipmentFilterValueOptions" @add="addShipmentFilter" />
            </div>
            <div class="filter-chips">
              <span v-for="(f, i) in shipmentActiveFilters" :key="i" class="filter-chip">
                <span class="chip-text">{{ f.categoryLabel }}: {{ f.displayValue }}</span>
                <button class="chip-remove" type="button" @click="removeShipmentFilter(i)">×</button>
              </span>
              <button v-if="shipmentActiveFilters.length" class="secondary chip-reset" type="button" @click="resetShipmentFilters">전체 해제</button>
            </div>
          </div>
          <div class="panel-table-wrap">
            <table class="shipment-history-table">
              <thead><tr><th style="width:44px">No.</th><th style="width:128px">출고번호</th><th style="width:128px">발주번호</th><th style="width:140px">총판</th><th style="width:140px">대리점</th><th style="width:200px">품목</th><th style="width:200px">배송지</th><th style="width:140px">운송장번호</th><th style="width:100px">출고일</th><th style="width:140px;text-align:center">입고상태</th></tr></thead>
              <tbody>
                <tr v-for="(s, index) in filteredShipments" :key="s.id" class="clickable-row" :class="{ 'row-highlighted': s.order_number === highlightOrderNum }" @click="openOrderById(s.order_id)">
                  <td>{{ filteredShipments.length - index }}</td>
                  <td>{{ s.shipment_number }}</td><td class="order-num">{{ s.order_number }}</td>
                  <td>{{ s.distributor_company }}</td><td>{{ s.dealer_company }}</td>
                  <td>{{ s.items.map(i => `${i.model_name} ×${i.quantity}`).join(', ') }}</td>
                  <td>{{ s.delivery_address }}</td>
                  <td @click.stop>
                    <div v-if="editingTracking !== null && editingTracking.__id === s.id" class="tracking-edit">
                      <input v-model="editingTracking.value" type="text" placeholder="운송장번호 입력" style="width:130px" @keyup.enter="saveTracking(s)" @keyup.esc="editingTracking = null" />
                      <button class="primary" @click="saveTracking(s)">저장</button>
                      <button @click="editingTracking = null">취소</button>
                    </div>
                    <div v-else class="tracking-cell">
                      <span v-if="s.tracking_number">{{ s.tracking_number }}</span>
                      <span v-else class="text-muted">-</span>
                      <button class="copy-btn" v-if="s.tracking_number" type="button" title="복사" @click="copyTracking(s.tracking_number)">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                          <rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
                        </svg>
                      </button>
                      <button class="edit-tracking-btn" title="운송장번호 수정" @click="editingTracking = { __id: s.id, value: s.tracking_number || '' }">✎</button>
                    </div>
                  </td>
                  <td>{{ s.shipped_at?.slice(0, 10) }}</td>
                  <td style="text-align:center">
                    <div v-if="s.received_at" class="ship-done-info">
                      <span>입고 완료</span>
                      <span class="ship-done-date">{{ fmtDateTimeShort(s.received_at) }}</span>
                    </div>
                    <span v-else>입고 대기</span>
                  </td>
                </tr>
                <tr v-if="!filteredShipments.length"><td colspan="10" class="empty-row">검색 조건에 맞는 출고 내역이 없습니다.</td></tr>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </template>

    <!-- 설정 -->
    <template v-else-if="view === 'settings'">
      <section class="panel">
        <h2>설정</h2>
        <div class="settings-layout">
          <aside class="settings-subnav">
            <button :class="{ active: settingsTab === 'profile' }" @click="settingsTab = 'profile'">
              <strong>계정 정보</strong>
              <span>제조사 기본 정보 수정</span>
            </button>
            <button v-if="auth.user?.is_owner" :class="{ active: settingsTab === 'managers' }" @click="settingsTab = 'managers'">
              <strong>담당자 설정</strong>
              <span>회원관리 담당자 지정</span>
            </button>
            <button :class="{ active: settingsTab === 'products' }" @click="settingsTab = 'products'">
              <strong>제품관리</strong>
              <span>제품 등록·수정·삭제</span>
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
                <label>등록번호<input :value="myForm.business_number" @input="myForm.business_number = formatBizNum($event.target.value)" placeholder="숫자만 입력" maxlength="12" /></label>
                <label>대표자명<input v-model="myForm.ceo_name" placeholder="예: 홍길동" /></label>
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
                    <h3 style="margin:0">회원 정보</h3>
                    <p class="text-muted">현재 로그인한 계정 본인의 연락처를 입력합니다.</p>
                  </div>
                </div>
                <label>이름<input v-model="myForm.manager_name" placeholder="예: 홍길동" /></label>
                <label>부서<input v-model="myForm.manager_department" placeholder="예: 영업관리팀" /></label>
                <label>직책<input v-model="myForm.manager_position" placeholder="예: 과장" /></label>
                <label>연락처<input :value="myForm.manager_phone" @input="myForm.manager_phone = formatPhone($event.target.value)" placeholder="숫자만 입력" maxlength="14" /></label>
                <label>이메일<input v-model="myForm.manager_email" type="email" placeholder="예: manager@example.com" /></label>
                <label>메모<textarea v-model="myForm.manager_memo" placeholder="담당 업무나 참고사항을 입력하세요"></textarea></label>
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
                    <tr v-for="u in adminManagerList" :key="u.id">
                      <td>{{ u.name }}</td>
                      <td>{{ u.username }}</td>
                      <td>{{ u.manager_department || '-' }}</td>
                      <td>{{ u.manager_phone || u.phone || '-' }}</td>
                      <td><button class="btn-danger" @click="toggleMemberManager(u, false)">해제</button></td>
                    </tr>
                    <tr v-if="!adminManagerList.length"><td colspan="5" class="empty-row">지정된 담당자가 없습니다.</td></tr>
                  </tbody>
                </table>
              </div>

              <div class="settings-manager-group">
                <h4>직원 목록</h4>
                <table class="member-table">
                  <thead><tr><th style="width:90px">이름</th><th style="width:120px">아이디</th><th>부서</th><th style="width:130px">연락처</th><th style="width:80px">처리</th></tr></thead>
                  <tbody>
                    <tr v-for="u in adminStaffList" :key="u.id">
                      <td>{{ u.name }}</td>
                      <td>{{ u.username }}</td>
                      <td>{{ u.manager_department || '-' }}</td>
                      <td>{{ u.manager_phone || u.phone || '-' }}</td>
                      <td><button @click="toggleMemberManager(u, true)">지정</button></td>
                    </tr>
                    <tr v-if="!adminStaffList.length"><td colspan="5" class="empty-row">직원이 없습니다.</td></tr>
                  </tbody>
                </table>
              </div>
            </div>

            <div v-else-if="settingsTab === 'products'" class="settings-products">
              <div class="settings-section-head">
                <div>
                  <h3>제품관리</h3>
                  <p class="text-muted">제품 라인을 클릭하면 정보를 수정할 수 있습니다.</p>
                </div>
                <button class="primary" @click="openProductModal">+ 신규 제품 등록</button>
              </div>
              <div class="panel-table-wrap">
                <table>
                  <thead><tr><th style="width:44px">No.</th><th>제품명</th><th style="width:140px">모델</th><th style="width:170px">규격</th><th style="width:120px;text-align:right">기본 단가</th><th style="width:90px">관리</th></tr></thead>
                  <tbody>
                    <tr v-for="(product, index) in data.products" :key="product.id" class="clickable-row" @click="editProduct({ product_id: product.id, ...product })">
                      <td>{{ index + 1 }}</td>
                      <td>{{ product.name }}</td>
                      <td>{{ product.model_name }}</td>
                      <td>{{ product.spec || '-' }}</td>
                      <td style="text-align:right;font-weight:700">{{ money(product.base_price) }}원</td>
                      <td @click.stop><button class="btn-danger" @click="deleteProduct(product)">삭제</button></td>
                    </tr>
                    <tr v-if="!data.products.length"><td colspan="6" class="empty-row">등록된 제품이 없습니다.</td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </section>

    </template>

    <!-- 대리점 -->
    <template v-else-if="view === 'dealers'">
      <section class="panel">
        <div class="page-section-head">
          <div>
            <h2>대리점 조회</h2>
            <p class="text-muted">총 {{ filteredDealers.length }}개 대리점이 검색되었습니다.</p>
          </div>
        </div>
        <div class="filter-selectors" style="margin-bottom:16px">
          <span class="filter-inline-label">총판</span>
          <select :value="dealersDistributorId" @change="loadDealersFor($event.target.value === 'all' ? 'all' : Number($event.target.value))">
            <option value="all">전체</option>
            <option v-for="dist in data.distributors" :key="dist.id" :value="dist.id">{{ dist.company_name }}</option>
          </select>
        </div>

        <div class="smart-filter-bar">
          <div class="filter-selectors">
            <select v-model="dealerFilterCategory" class="filter-cat-select">
              <option v-for="cat in dealerFilterCategories" :key="cat.key" :value="cat.key">{{ cat.label }}</option>
            </select>
            <FilterSearchInput :options="dealerFilterValueOptions" @add="addDealerFilter" />
          </div>
          <div class="filter-chips">
            <span v-for="(f, i) in dealerActiveFilters" :key="i" class="filter-chip">
              <span class="chip-text">{{ f.categoryLabel }}: {{ f.displayValue }}</span>
              <button class="chip-remove" type="button" @click="removeDealerFilter(i)">×</button>
            </span>
            <button v-if="dealerActiveFilters.length" class="secondary chip-reset" type="button" @click="resetDealerFilters">전체 해제</button>
          </div>
        </div>

        <div class="panel-table-wrap">
          <table>
            <thead>
              <tr>
                <th style="width:190px">회사명</th><th style="width:140px">총판</th><th style="width:100px">대표자</th><th style="width:120px">사업자번호</th><th>주소</th>
                <th style="width:110px">담당자</th><th style="width:130px">연락처</th><th style="width:100px">가입일</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="d in filteredDealers" :key="d.id">
                <td>{{ d.company_name }}</td>
                <td>{{ d.distributor_company || '-' }}</td>
                <td>{{ d.ceo_name || '-' }}</td>
                <td>{{ d.business_number || '-' }}</td>
                <td>{{ d.address || '-' }}</td>
                <td>{{ d.manager_name || '-' }}</td>
                <td>{{ d.manager_phone || d.phone || '-' }}</td>
                <td>{{ d.created_at?.slice(0, 10) }}</td>
              </tr>
              <tr v-if="!filteredDealers.length"><td colspan="8" class="empty-row">등록된 대리점이 없습니다.</td></tr>
            </tbody>
          </table>
        </div>
      </section>
    </template>

    <!-- 회원관리 -->
    <template v-else-if="view === 'members'">
      <div :class="['member-layout', selectedUser ? 'split' : '']">

        <!-- ── 카드 1: 회원 목록 ── -->
        <section class="panel" style="margin-bottom:0">
          <div class="tab-bar-row">
            <div class="tab-bar">
              <button :class="{ active: memberTab === 'all' }" @click="memberTab = 'all'">
                전체 회원 <span class="badge-count">{{ tabCounts.all }}</span>
              </button>
              <button :class="{ active: memberTab === 'manufacturer' }" @click="memberTab = 'manufacturer'">
                제조사 <span class="badge-count">{{ tabCounts.manufacturer }}</span>
              </button>
              <button :class="{ active: memberTab === 'distributor' }" @click="memberTab = 'distributor'">
                총판 <span class="badge-count">{{ tabCounts.distributor }}</span>
              </button>
              <button :class="{ active: memberTab === 'dealer' }" @click="memberTab = 'dealer'">
                대리점 <span class="badge-count">{{ tabCounts.dealer }}</span>
              </button>
            </div>
          </div>

          <div class="smart-filter-bar">
            <div class="filter-selectors">
              <select v-model="memberFilterCategory" class="filter-cat-select">
                <option v-for="cat in memberFilterCategories" :key="cat.key" :value="cat.key">{{ cat.label }}</option>
              </select>
              <FilterSearchInput :options="memberFilterValueOptions" @add="addMemberFilter" />
            </div>
            <div class="filter-chips">
              <span v-for="(f, i) in memberActiveFilters" :key="i" class="filter-chip">
                <span class="chip-text">{{ f.categoryLabel }}: {{ f.displayValue }}</span>
                <button class="chip-remove" type="button" @click="removeMemberFilter(i)">×</button>
              </span>
              <button v-if="memberActiveFilters.length" class="secondary chip-reset" type="button" @click="resetMemberFilters">전체 해제</button>
            </div>
          </div>

          <div v-if="memberTab === 'all'" class="status-subtabs">
            <button :class="{ active: memberStatusTab === 'pending' }" @click="memberStatusTab = 'pending'">
              승인 대기 <span class="badge-count" :class="{ 'badge-red': tabCounts.pending > 0 }">{{ tabCounts.pending }}</span>
            </button>
            <button :class="{ active: memberStatusTab === 'active' }" @click="memberStatusTab = 'active'">
              활성 회원 <span class="badge-count">{{ tabCounts.active }}</span>
            </button>
            <button :class="{ active: memberStatusTab === 'inactive' }" @click="memberStatusTab = 'inactive'">
              비활성 <span class="badge-count">{{ tabCounts.inactive }}</span>
            </button>
            <button :class="{ active: memberStatusTab === 'rejected' }" @click="memberStatusTab = 'rejected'">
              거부 <span class="badge-count">{{ tabCounts.rejected }}</span>
            </button>
          </div>

          <div class="member-list-wrap">

            <!-- ── 승인 대기 테이블 ── -->
            <template v-if="memberTab === 'all' && memberStatusTab === 'pending'">
              <table class="member-table member-table-equal">
                <thead>
                  <tr>
                    <th style="width:44px">No.</th><th>이름</th><th>아이디</th><th>회사</th><th>신청일</th>
                    <th>가입 유형</th><th>소속 총판</th><th>처리</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="(user, index) in data.pending" :key="user.id"
                    :class="{ 'row-selected': selectedUser?.id === user.id, 'row-pending-in-all': true }"
                    @click="selectUser(user)">
                    <td>{{ data.pending.length - index }}</td>
                    <td>{{ user.name }}</td>
                    <td>{{ user.username }}</td>
                    <td>{{ user.company_name }}</td>
                    <td>{{ user.created_at?.slice(0, 10) }}</td>
                    <td @click.stop>
                      <span v-if="user.role === 'admin'" class="badge s-CONVERTED">제조사 직원</span>
                      <span v-else-if="user.role === 'distributor' && user.distributor_id" class="badge s-CONVERTED">총판 직원</span>
                      <select v-else v-model="user.approveRole" style="font-size:12px;padding:4px 6px;min-height:unset">
                        <option value="dealer">대리점</option>
                        <option value="distributor">총판</option>
                      </select>
                    </td>
                    <td @click.stop>
                      <span v-if="user.role === 'admin' || (user.role === 'distributor' && user.distributor_id)" class="text-muted">해당없음</span>
                      <select v-else-if="(user.approveRole ?? 'dealer') === 'dealer'" v-model.number="user.approveDistributorId" style="font-size:12px;padding:4px 6px;min-height:unset">
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
                  <tr v-if="!data.pending.length"><td colspan="8" class="empty-row">승인 대기 중인 회원이 없습니다.</td></tr>
                </tbody>
              </table>
            </template>

            <!-- ── 회원 테이블 ── -->
            <table v-if="!(memberTab === 'all' && memberStatusTab === 'pending')" class="member-table member-table-equal">
              <thead>
                <tr>
                  <th style="width:44px">No.</th><th>이름</th><th>아이디</th>
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
                  <th v-if="memberTab === 'all' && memberStatusTab === 'rejected'"></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(user, index) in filteredTabUsers" :key="user.id"
                  :class="{ 'row-selected': selectedUser?.id === user.id }"
                  @click="selectUser(user)">
                  <td>{{ filteredTabUsers.length - index }}</td>
                  <td>{{ user.name }}</td>
                  <td>{{ user.username }}</td>
                  <td>
                    {{ ROLE_LABEL[user.role] || user.role }}
                    <span v-if="user.is_owner" class="badge s-SHIPPED" style="margin-left:4px">관리자</span>
                    <span v-else-if="user.is_member_manager" class="badge s-CONVERTED" style="margin-left:4px">담당자</span>
                  </td>
                  <td>{{ user.distributor_name || '-' }}</td>
                  <td>{{ user.company_name }}</td>
                  <td>{{ user.created_at?.slice(0, 10) }}</td>
                  <td v-if="memberTab === 'all' && memberStatusTab === 'rejected'" @click.stop>
                    <div class="actions">
                      <button @click="unreject(user)">거부 해제</button>
                    </div>
                  </td>
                </tr>
                <tr v-if="!filteredTabUsers.length">
                  <td :colspan="(memberTab === 'all' && memberStatusTab === 'rejected') ? 8 : 7" class="empty-row">해당 회원이 없습니다.</td>
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
              <label>비밀번호
                <PasswordInput v-model="editForm.password" placeholder="변경 시 입력" autocomplete="new-password"
                  :invalid="editPwStatus === 'mismatch'" :valid="editPwStatus === 'match'" />
              </label>
              <label v-if="editForm.password">비밀번호 확인
                <PasswordInput v-model="editForm.passwordConfirm" placeholder="비밀번호를 다시 입력해주세요" autocomplete="new-password"
                  :invalid="editPwStatus === 'mismatch'" :valid="editPwStatus === 'match'" />
                <span v-if="editPwStatus === 'match'" class="pw-feedback match">비밀번호가 일치합니다.</span>
                <span v-else-if="editPwStatus === 'mismatch'" class="pw-feedback mismatch">비밀번호가 일치하지 않습니다.</span>
              </label>
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
                <label>담당자명<input v-model="editForm.manager_name" placeholder="담당자명" /></label>
                <label>담당자 부서<input v-model="editForm.manager_department" placeholder="부서" /></label>
                <label>담당자 직책<input v-model="editForm.manager_position" placeholder="직책" /></label>
                <label>담당자 연락처<input :value="editForm.manager_phone" @input="editForm.manager_phone = formatPhone($event.target.value)" placeholder="숫자만 입력" maxlength="14" /></label>
                <label>담당자 이메일<input v-model="editForm.manager_email" type="email" placeholder="이메일" /></label>
                <label class="full-row">담당자 메모<textarea v-model="editForm.manager_memo" placeholder="담당 업무나 참고사항"></textarea></label>
              </template>
              <template v-else>
                <div class="admin-badge-info">{{ selectedUser.is_owner ? '관리자 계정 — 역할·상태 변경 불가' : '제조사 직원 계정 — 역할·상태 변경 불가' }}</div>
              </template>
              <div class="member-edit-actions">
                <button class="primary" type="submit">저장</button>
                <button v-if="!(selectedUser.role === 'admin' && selectedUser.is_owner)" class="btn-danger" type="button" @click="deleteModalOpen = true">삭제</button>
              </div>
            </form>
          </section>
        </transition>

      </div><!-- /member-layout -->
    </template>

    <OrderReceiptModal
      v-if="editingOrder"
      :order="editingOrder"
      :products="data.products"
      :editable="view !== 'sales' && ['CONVERTED', 'CONFIRMED'].includes(editingOrder.status)"
      :can-confirm="editingOrderCanConfirm"
      :can-cancel="editingOrderCanCancel"
      :can-ship="editingOrderCanShip"
      show-statement-button
      owner-label="AT GLOBAL 제조사"
      @close="editingOrder = null"
      @save="saveOrderEdit"
      @preview-statement="previewStatementForOrder(editingOrder)"
      @confirm="confirmFromModal"
      @cancel="cancelFromModal"
      @ship="shipFromModal"
    />

    <DeleteMemberModal
      :show="deleteModalOpen"
      :user="selectedUser"
      :available-distributors="data.distributors.filter((d) => d.id !== selectedUser?.id)"
      @close="deleteModalOpen = false"
      @deleted="onMemberDeleted"
    />

    <section v-if="productModalOpen" class="modal-backdrop" @click.self="closeProductModal">
      <form class="modal" style="width:min(520px, 100%)" @submit.prevent="saveProduct">
        <h2>{{ editingProductId ? '제품 수정' : '제품 등록' }}</h2>
        <label>제품명<input v-model.trim="productForm.name" required placeholder="제품명을 입력하세요" /></label>
        <label>모델명<input v-model.trim="productForm.model_name" required placeholder="모델명을 입력하세요" /></label>
        <label>규격<input v-model.trim="productForm.spec" placeholder="규격을 입력하세요" /></label>
        <label>기본 단가
          <div style="display:flex;align-items:center;gap:8px">
            <PriceInput v-model="productForm.base_price" />
            <small v-if="productForm.base_price" style="color:var(--muted);white-space:nowrap">{{ numberToKoreanMoney(productForm.base_price) }}</small>
          </div>
        </label>
        <div class="actions end">
          <button class="secondary" type="button" :disabled="productSubmitting" @click="closeProductModal">취소</button>
          <button class="primary" type="submit" :disabled="productSubmitting">
            {{ productSubmitting ? '저장 중...' : editingProductId ? '수정 저장' : '등록' }}
          </button>
        </div>
      </form>
    </section>

    <section v-if="shipModalOrder" class="modal-backdrop" @click.self="closeShipModal">
      <div class="modal" style="width:min(720px, 100%)">
        <h2>출고 등록 — {{ shipModalOrder.order_number }}</h2>
        <p class="text-muted">품목별로 이번에 출고할 수량을 입력하세요. 남은 수량만큼만 입력하면 나머지는 다음 출고에서 처리할 수 있습니다.</p>
        <table>
          <thead><tr><th>품목</th><th style="width:90px;text-align:right">발주수량</th><th style="width:90px;text-align:right">기출고</th><th style="width:140px;text-align:right">이번 출고수량</th></tr></thead>
          <tbody>
            <tr v-for="row in shipModalRows" :key="row.id">
              <td>{{ row.product_name }} {{ row.model_name }}</td>
              <td style="text-align:right">{{ row.quantity }}</td>
              <td style="text-align:right">{{ row.shipped_quantity || 0 }}</td>
              <td style="text-align:right">
                <input
                  v-model.number="row.ship_qty"
                  type="number"
                  min="0"
                  :max="row.remaining"
                  style="width:90px;text-align:right"
                />
              </td>
            </tr>
          </tbody>
        </table>
        <label>배송지<input v-model="shipModalMeta.delivery_address" placeholder="배송지 주소" /></label>
        <div class="grid-2">
          <label>운송장번호<input v-model="shipModalMeta.tracking_number" placeholder="운송장번호" /></label>
          <label>택배사
            <select v-model="shipModalMeta.carrier_code">
              <option value="">선택 안 함</option>
              <option v-for="c in CARRIERS" :key="c.code" :value="c.code">{{ c.name }}</option>
            </select>
          </label>
        </div>
        <div class="actions end">
          <button class="secondary" type="button" :disabled="shipSubmitting" @click="closeShipModal">취소</button>
          <button class="secondary" type="button" :disabled="shipSubmitting" @click="previewStatement">명세서 미리보기/인쇄</button>
          <button class="primary" type="button" :disabled="shipSubmitting" @click="submitShip">
            {{ shipSubmitting ? '등록 중...' : '출고 등록' }}
          </button>
        </div>
      </div>
    </section>

    <TransactionStatementModal
      v-if="statementPreview"
      :order="statementPreview.order"
      :pages="statementPreview.pages"
      @close="statementPreview = null"
    />
  </AppShell>
</template>
