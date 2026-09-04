<script setup>
import { reactive, ref } from 'vue';
import { api, request } from '../api';
import { confirmAction } from '../services/notification';

const emit = defineEmits(['scanned']);

const input = ref('');
const scanInput = ref(null);
const result = ref(null);
const error = ref('');
const batches = ref([]);
const showBatches = ref(false);
const loading = ref(false);

async function onScan() {
  if (!input.value.trim()) return;
  error.value = '';
  result.value = null;
  loading.value = true;
  try {
    const data = await request(api.post('/barcode/scan', { barcode: input.value.trim() }));
    result.value = data;
    input.value = '';
    emit('scanned');
    if (showBatches.value) await loadBatches();
  } catch (err) {
    error.value = err.message;
  } finally {
    loading.value = false;
    scanInput.value?.focus();
  }
}

async function loadBatches() {
  const data = await request(api.get('/barcode/batches'));
  batches.value = data.batches;
}

async function deleteBatch(id) {
  const confirmed = await confirmAction({
    title: '스캔 기록 삭제',
    message: '이 상품의 스캔 기록을 삭제하면 제조사 재고가 1개 차감됩니다.',
    confirmText: '삭제',
    danger: true
  });
  if (!confirmed) return;
  await request(api.delete(`/barcode/batches/${id}`), { successMessage: '스캔 기록이 삭제되고 재고가 1개 차감되었습니다.' });
  emit('scanned');
  await loadBatches();
}

async function toggleBatches() {
  showBatches.value = !showBatches.value;
  if (showBatches.value) await loadBatches();
}

function focus() { scanInput.value?.focus(); }
defineExpose({ focus });
</script>

<template>
  <div class="barcode-section">
    <div class="barcode-header">
      <h3>개별 상품 바코드 입고</h3>
      <span class="barcode-format-hint">상품 한 개를 스캔할 때마다 재고가 1개 증가합니다.</span>
    </div>

    <div class="barcode-input-row">
      <div class="barcode-input-wrap">
        <span class="barcode-icon">▣</span>
        <input
          ref="scanInput"
          v-model="input"
          class="barcode-input"
          placeholder="바코드를 스캐너로 읽거나 직접 입력하세요"
          autocomplete="off"
          @keyup.enter="onScan"
        />
      </div>
      <button class="primary" :disabled="loading" @click="onScan">
        {{ loading ? '처리 중...' : '입력' }}
      </button>
    </div>

    <div class="barcode-example">
      <span class="example-label">예시</span>
      <code>ATG|PB-10000|SN2024000001|20240601</code>
      <span class="example-desc">→ PB-10000 개별 상품 1개 입고</span>
    </div>

    <!-- 스캔 결과 -->
    <div v-if="result" class="scan-result">
      <div class="scan-result-icon">✓</div>
      <div class="scan-result-body">
        <div class="scan-result-title">입고 완료</div>
        <div class="scan-result-row">
          <span>제품</span><strong>{{ result.product.name }} {{ result.product.model_name }}</strong>
        </div>
        <div class="scan-result-row">
          <span>개별식별번호</span><strong>{{ result.parsed.lotNumber || '-' }}</strong>
        </div>
        <div class="scan-result-row">
          <span>제조일자</span><strong>{{ result.parsed.manufactureDate || '-' }}</strong>
        </div>
        <div class="scan-result-row">
          <span>입고 수량</span><strong class="scan-qty">+1개</strong>
        </div>
      </div>
    </div>

    <p v-if="error" class="error">{{ error }}</p>

    <!-- 스캔 이력 -->
    <div class="barcode-history-toggle">
      <button class="secondary" @click="toggleBatches">
        {{ showBatches ? '▲ 개별 스캔 이력 닫기' : '▼ 개별 스캔 이력 보기' }}
      </button>
    </div>

    <div v-if="showBatches">
      <table class="barcode-table">
        <thead>
          <tr>
            <th>스캔일시</th><th>제품</th><th>모델</th><th>개별식별번호</th>
            <th>제조일자</th><th>담당자</th><th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="b in batches" :key="b.id">
            <td>{{ b.scanned_at?.slice(0, 16).replace('T', ' ') }}</td>
            <td>{{ b.product_name }}</td>
            <td>{{ b.model_name }}</td>
            <td>{{ b.lot_number || '-' }}</td>
            <td>{{ b.manufacture_date?.slice(0, 10) || '-' }}</td>
            <td>{{ b.scanned_by_name || '-' }}</td>
            <td>
              <button class="btn-danger" style="padding:3px 8px;font-size:11px" @click="deleteBatch(b.id)">삭제</button>
            </td>
          </tr>
          <tr v-if="!batches.length">
            <td colspan="7" class="empty-row">스캔 이력이 없습니다.</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
