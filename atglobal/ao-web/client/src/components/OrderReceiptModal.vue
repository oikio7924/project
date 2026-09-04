<script setup>
import { computed, onMounted, onUnmounted, ref } from 'vue';
import StatusBadge from './StatusBadge.vue';
import PriceInput from './PriceInput.vue';
import loginLogo from '../assets/login_logo.png';

const props = defineProps({
  order: { type: Object, required: true },
  products: { type: Array, default: () => [] },
  editable: { type: Boolean, default: false },
  showStatementButton: { type: Boolean, default: false },
  statementButtonLabel: { type: String, default: '거래명세서' },
  // 총판 화면에서만 쓰는 제조사→총판 거래명세서(자신이 매입자로서 받는 문서) 버튼
  showPurchaseStatementButton: { type: Boolean, default: false },
  // 총판/대리점이 자기 화면에서 볼 때는 자사 로고를 쓴다(등록 안 했으면 공란). 제조사 화면은 기본 로고 고정.
  useOwnLogo: { type: Boolean, default: false },
  logoUrl: { type: String, default: null },
  // 발주서 목록에서 하던 상태 처리(수주 확정/취소, 출고 등록, 발주 전환)를 모달에서도 그대로 할 수 있게 하는 버튼들
  canConfirm: { type: Boolean, default: false },
  canCancel: { type: Boolean, default: false },
  canShip: { type: Boolean, default: false },
  canConvert: { type: Boolean, default: false }
});

const emit = defineEmits(['close', 'save', 'preview-statement', 'preview-purchase-statement', 'confirm', 'cancel', 'ship', 'convert']);
const money = (value) => Number(value || 0).toLocaleString('ko-KR', { maximumFractionDigits: 0 });

const isEditing = ref(false);
const editCopy = ref(null);

function onKeydown(e) {
  if (e.key === 'Escape' && !isEditing.value) emit('close');
}
onMounted(() => document.addEventListener('keydown', onKeydown));
onUnmounted(() => document.removeEventListener('keydown', onKeydown));

function startEdit() {
  editCopy.value = {
    ...props.order,
    delivery_address: props.order.delivery_address || '',
    payment_terms: props.order.payment_terms || '',
    note: props.order.note || '',
    items: props.order.items.map(i => ({ ...i }))
  };
  isEditing.value = true;
}

function cancelEdit() {
  editCopy.value = null;
  isEditing.value = false;
}

function handleSave() {
  // editCopy 내용을 부모의 reactive 객체에 반영
  props.order.delivery_address = editCopy.value.delivery_address;
  props.order.payment_terms = editCopy.value.payment_terms;
  props.order.note = editCopy.value.note;
  props.order.items.splice(0, props.order.items.length, ...editCopy.value.items);
  isEditing.value = false;
  editCopy.value = null;
  emit('save');
}

const supplyAmount = computed(() => {
  const items = isEditing.value ? (editCopy.value?.items ?? []) : props.order.items;
  return items.reduce((s, i) => s + Number(i.quantity || 0) * Number(i.unit_price || 0), 0);
});
const vatAmount = computed(() => Math.floor(supplyAmount.value * 0.1));
const grandTotal = computed(() => supplyAmount.value + vatAmount.value);

function getProduct(id) {
  return props.products.find(p => p.id === Number(id));
}

function syncItem(item) {
  const p = getProduct(item.product_id);
  if (p) {
    item.product_name = p.name;
    item.model_name = p.model_name || '';
    item.unit_price = Number(p.base_price);
  }
}

function addItem() {
  const p = props.products[0];
  if (!p || !editCopy.value) return;
  editCopy.value.items.push({
    product_id: p.id,
    product_name: p.name,
    model_name: p.model_name || '',
    quantity: 1,
    unit_price: Number(p.base_price)
  });
}

function removeItem(i) {
  editCopy.value?.items.splice(i, 1);
}
</script>

<template>
  <section class="modal-backdrop receipt-backdrop" @click.self="isEditing ? null : emit('close')">
    <div class="receipt-doc-wrap">
      <button v-if="!isEditing" class="odoc-close-btn" type="button" aria-label="닫기" @click="emit('close')">✕</button>

      <!-- 헤더 -->
      <div class="odoc-header">
        <div>
          <h2 class="odoc-title">발 주 서</h2>
          <div class="odoc-meta">
            <span>발주번호</span><em>{{ order.order_number }}</em>
            <span style="margin-left:14px">발주일자</span><em>{{ order.ordered_at?.slice(0, 10) }}</em>
          </div>
        </div>
        <div style="display:flex;flex-direction:column;align-items:flex-end;gap:8px">
          <div class="odoc-logo">
            <img v-if="!useOwnLogo" :src="loginLogo" alt="AT GLOBAL" class="odoc-logo-img" />
            <img v-else-if="logoUrl" :src="logoUrl" alt="로고" class="odoc-logo-img" />
            <small v-if="!useOwnLogo">www.atglobal.kr</small>
          </div>
          <StatusBadge :status="order.status" />
        </div>
      </div>

      <!-- 수신처 / 발주처 -->
      <div class="odoc-parties">
        <div class="odoc-party">
          <div class="odoc-party-title">수 신 처</div>
          <table class="odoc-info-table">
            <tr><td>상호</td><td>{{ order.distributor_company || '-' }}</td></tr>
            <tr><td>담당자</td><td>{{ order.distributor_manager_name || order.distributor_name || '-' }}</td></tr>
            <tr><td>연락처</td><td>{{ order.distributor_manager_phone || order.distributor_phone || '-' }}</td></tr>
          </table>
        </div>
        <div class="odoc-party">
          <div class="odoc-party-title">발 주 처</div>
          <table class="odoc-info-table">
            <tr><td>상호</td><td>{{ order.dealer_company || '-' }}</td></tr>
            <tr><td>소재지</td><td>{{ order.dealer_address || '-' }}</td></tr>
            <tr><td>담당자</td><td>{{ order.dealer_name || '-' }}</td></tr>
            <tr><td>연락처</td><td>{{ order.dealer_phone || '-' }}</td></tr>
          </table>
        </div>
      </div>

      <p class="odoc-greeting">아래와 같이 발주합니다.</p>

      <!-- 품목 테이블 — 수정 모드 -->
      <template v-if="isEditing">
        <table class="odoc-items">
          <thead>
            <tr>
              <th>No.</th><th>품&nbsp;&nbsp;&nbsp;명</th><th>규&nbsp;&nbsp;&nbsp;격</th>
              <th>수량</th><th>단가</th><th>공급가액</th><th>세액</th><th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, i) in editCopy.items" :key="item.id || i">
              <td class="odoc-no">{{ i + 1 }}</td>
              <td>
                <select v-model.number="item.product_id" class="odoc-select" @change="syncItem(item)">
                  <option v-for="p in products" :key="p.id" :value="p.id">{{ p.name }} {{ p.model_name }}</option>
                </select>
              </td>
              <td class="odoc-center">{{ getProduct(item.product_id)?.model_name || item.model_name || '-' }}</td>
              <td><input v-model.number="item.quantity" type="number" min="1" class="odoc-qty" /></td>
              <td><PriceInput v-model="item.unit_price" class="odoc-qty" style="width:80px" /></td>
              <td class="odoc-right">{{ money(Number(item.quantity || 0) * Number(item.unit_price || 0)) }}</td>
              <td class="odoc-right">{{ money(Math.floor(Number(item.quantity || 0) * Number(item.unit_price || 0) * 0.1)) }}</td>
              <td><button class="odoc-del-btn" type="button" @click="removeItem(i)">×</button></td>
            </tr>
            <tr v-if="!editCopy.items.length">
              <td colspan="8" class="odoc-empty">품목을 추가하세요.</td>
            </tr>
          </tbody>
        </table>
        <button class="odoc-add-btn" type="button" @click="addItem">+ 품목 추가</button>
      </template>

      <!-- 품목 테이블 — 보기 모드 -->
      <template v-else>
        <table class="odoc-items">
          <thead>
            <tr>
              <th>No.</th><th>품&nbsp;&nbsp;&nbsp;명</th><th>규&nbsp;&nbsp;&nbsp;격</th>
              <th>수량</th><th>단가</th><th>공급가액</th><th>세액</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, i) in order.items" :key="item.id || i">
              <td class="odoc-no">{{ i + 1 }}</td>
              <td>{{ item.product_name }}</td>
              <td class="odoc-center">{{ item.model_name || '-' }}</td>
              <td class="odoc-center">{{ item.quantity }}</td>
              <td class="odoc-right">{{ money(item.unit_price) }}</td>
              <td class="odoc-right">{{ money(item.quantity * item.unit_price) }}</td>
              <td class="odoc-right">{{ money(Math.floor(item.quantity * item.unit_price * 0.1)) }}</td>
            </tr>
          </tbody>
        </table>
      </template>

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
          <strong>₩ {{ money(grandTotal) }}</strong>
        </div>
      </div>

      <!-- 발주조건 -->
      <div class="odoc-conditions">
        <div class="odoc-conditions-title">발주조건</div>
        <div class="odoc-conditions-body">
          <div class="odoc-cond-row">
            <span>배 송 지</span>
            <input v-if="isEditing" v-model="editCopy.delivery_address" placeholder="배송지 주소" />
            <div v-else class="receipt-ro-val">{{ order.delivery_address || '-' }}</div>
          </div>
          <div class="odoc-cond-row">
            <span>결제조건</span>
            <input v-if="isEditing" v-model="editCopy.payment_terms" placeholder="결제 조건" />
            <div v-else class="receipt-ro-val">{{ order.payment_terms || '-' }}</div>
          </div>
          <div class="odoc-cond-row">
            <span>비&nbsp;&nbsp;&nbsp;&nbsp;고</span>
            <textarea v-if="isEditing" v-model="editCopy.note" placeholder="비고" style="resize:vertical;min-height:56px" />
            <div v-else class="receipt-ro-val">{{ order.note || '-' }}</div>
          </div>
        </div>
      </div>

      <!-- 버튼 -->
      <div class="actions" style="margin-top:16px;justify-content:space-between">
        <template v-if="isEditing">
          <div class="actions"></div>
          <div class="actions end">
            <button class="secondary" type="button" @click="cancelEdit">취소</button>
            <button class="primary" type="button" @click="handleSave">저장</button>
          </div>
        </template>
        <template v-else>
          <div class="actions">
            <button v-if="showPurchaseStatementButton" class="secondary" type="button" @click="emit('preview-purchase-statement')">제조사 거래명세서</button>
            <button v-if="showStatementButton" class="secondary" type="button" @click="emit('preview-statement')">{{ statementButtonLabel }}</button>
            <button v-if="editable" class="primary" type="button" @click="startEdit">수정</button>
          </div>
          <div class="actions end">
            <button v-if="canConvert" class="primary" type="button" @click="emit('convert')">발주 전환 ▶</button>
            <button v-if="canConfirm" class="primary" type="button" @click="emit('confirm')">수주 확정</button>
            <button v-if="canShip" class="goto-ship-btn" type="button" @click="emit('ship')">출고 등록</button>
            <button v-if="canCancel" class="btn-danger" type="button" @click="emit('cancel')">취소</button>
          </div>
        </template>
      </div>

    </div>
  </section>
</template>
