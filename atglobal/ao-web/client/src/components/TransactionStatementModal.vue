<script setup>
import { ref, computed, watch } from 'vue';
import loginLogo from '../assets/login_logo.png';

// pages: 출고 건별로 한 페이지씩 — [{ items, meta }, ...]. 부분출고로 한 발주가 여러 번 나갔으면
// 페이지가 여러 개가 되어 이전/다음으로 넘겨가며 출고 건별 거래명세서를 확인·인쇄할 수 있다.
// perspective: 'manufacturer'(제조사→총판, 기본값) | 'distributor'(총판→대리점) — 공급자/공급받는자 표시만 다르다.
// logoUrl: perspective가 'distributor'일 때만 쓰는 총판 자사 로고(설정에서 등록 안 했으면 공란).
const props = defineProps({
  order: { type: Object, required: true },
  pages: { type: Array, default: () => [] },
  perspective: { type: String, default: 'manufacturer' },
  logoUrl: { type: String, default: null }
});

const emit = defineEmits(['close']);
const money = (value) => Number(value || 0).toLocaleString('ko-KR', { maximumFractionDigits: 0 });

const currentPage = ref(0);
watch(() => props.pages, () => { currentPage.value = 0; });

const items = computed(() => props.pages[currentPage.value]?.items || []);
const meta = computed(() => props.pages[currentPage.value]?.meta || {});

function goPrev() { if (currentPage.value > 0) currentPage.value--; }
function goNext() { if (currentPage.value < props.pages.length - 1) currentPage.value++; }

const today = computed(() => {
  const d = new Date();
  const p = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}.${p(d.getMonth() + 1)}.${p(d.getDate())}`;
});

const supplyAmount = computed(() =>
  items.value.reduce((s, i) => s + Number(i.quantity || 0) * Number(i.unit_price || 0), 0)
);
const vatAmount = computed(() => Math.floor(supplyAmount.value * 0.1));
const grandTotal = computed(() => supplyAmount.value + vatAmount.value);

function printStatement() {
  window.print();
}
</script>

<template>
  <section class="modal-backdrop receipt-backdrop" @click.self="emit('close')">
    <div class="receipt-doc-wrap print-area">

      <!-- 헤더 -->
      <div class="odoc-header">
        <div>
          <h2 class="odoc-title">거 래 명 세 서</h2>
          <div class="odoc-meta">
            <span>발주번호</span><em>{{ order.order_number }}</em>
            <span style="margin-left:14px">발행일자</span><em>{{ today }}</em>
            <template v-if="meta.shipment_number">
              <span style="margin-left:14px">출고번호</span><em>{{ meta.shipment_number }}</em>
              <span style="margin-left:14px">출고일</span><em>{{ meta.shipped_at?.slice(0, 10) || '-' }}</em>
            </template>
          </div>
        </div>
        <div class="odoc-logo">
          <img v-if="perspective !== 'distributor'" :src="loginLogo" alt="AT GLOBAL" class="odoc-logo-img" />
          <img v-else-if="logoUrl" :src="logoUrl" alt="로고" class="odoc-logo-img" />
          <small v-if="perspective !== 'distributor'">www.atglobal.kr</small>
        </div>
      </div>

      <!-- 공급자 / 공급받는자 -->
      <div class="odoc-parties">
        <div class="odoc-party">
          <div class="odoc-party-title">공 급 자</div>
          <table class="odoc-info-table">
            <template v-if="perspective === 'distributor'">
              <tr><td>상호</td><td>{{ order.distributor_company || '-' }}</td></tr>
              <tr><td>등록번호</td><td>{{ order.distributor_business_number || '-' }}</td></tr>
              <tr><td>대표자</td><td>{{ order.distributor_ceo_name || '-' }}</td></tr>
              <tr><td>주소</td><td>{{ order.distributor_address || '-' }}</td></tr>
              <tr><td>전화</td><td>{{ order.distributor_phone || '-' }}</td></tr>
              <tr><td>팩스</td><td>{{ order.distributor_fax || '-' }}</td></tr>
            </template>
            <template v-else>
              <tr><td>상호</td><td>{{ order.manufacturer_company_name || 'AT GLOBAL' }}</td></tr>
              <tr><td>등록번호</td><td>{{ order.manufacturer_business_number || '-' }}</td></tr>
              <tr><td>대표자</td><td>{{ order.manufacturer_ceo_name || '-' }}</td></tr>
              <tr><td>주소</td><td>{{ order.manufacturer_address || '-' }}</td></tr>
              <tr><td>전화</td><td>{{ order.manufacturer_phone || '-' }}</td></tr>
              <tr><td>팩스</td><td>{{ order.manufacturer_fax || '-' }}</td></tr>
            </template>
          </table>
        </div>
        <div class="odoc-party">
          <div class="odoc-party-title">공급받는자</div>
          <table class="odoc-info-table">
            <template v-if="perspective === 'distributor'">
              <tr><td>상호</td><td>{{ order.dealer_company || '-' }}</td></tr>
              <tr><td>담당자</td><td>{{ order.dealer_name || '-' }}</td></tr>
              <tr><td>배송지</td><td>{{ meta.delivery_address || order.dealer_address || '-' }}</td></tr>
            </template>
            <template v-else>
              <tr><td>상호</td><td>{{ order.distributor_company || '-' }}</td></tr>
              <tr><td>담당자</td><td>{{ order.distributor_manager_name || order.distributor_name || '-' }}</td></tr>
              <tr><td>배송지</td><td>{{ meta.delivery_address || order.distributor_address || '-' }}</td></tr>
            </template>
          </table>
        </div>
      </div>

      <p class="odoc-greeting">아래와 같이 거래(출고)합니다.</p>

      <!-- 품목 테이블 -->
      <table class="odoc-items">
        <thead>
          <tr>
            <th>No.</th><th>품&nbsp;&nbsp;&nbsp;명</th><th>규&nbsp;&nbsp;&nbsp;격</th>
            <th>수량</th><th>단가</th><th>공급가액</th><th>세액</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(item, i) in items" :key="i">
            <td class="odoc-no">{{ i + 1 }}</td>
            <td>{{ item.product_name }}</td>
            <td class="odoc-center">{{ item.model_name || '-' }}</td>
            <td class="odoc-center">{{ item.quantity }}</td>
            <td class="odoc-right">{{ money(item.unit_price) }}</td>
            <td class="odoc-right">{{ money(item.quantity * item.unit_price) }}</td>
            <td class="odoc-right">{{ money(Math.floor(item.quantity * item.unit_price * 0.1)) }}</td>
          </tr>
          <tr v-if="!items.length">
            <td colspan="7" class="odoc-empty">출고할 품목이 없습니다.</td>
          </tr>
        </tbody>
      </table>

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

      <!-- 버튼 -->
      <div class="actions end no-print" style="margin-top:16px">
        <div v-if="pages.length > 1" class="odoc-pagination">
          <button class="secondary" type="button" :disabled="currentPage === 0" @click="goPrev">◀ 이전</button>
          <span>출고 {{ currentPage + 1 }} / {{ pages.length }}</span>
          <button class="secondary" type="button" :disabled="currentPage === pages.length - 1" @click="goNext">다음 ▶</button>
        </div>
        <button class="secondary" type="button" @click="emit('close')">닫기</button>
        <button class="primary" type="button" @click="printStatement">인쇄</button>
      </div>

    </div>
  </section>
</template>
