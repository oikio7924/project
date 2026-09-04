<script setup>
import { ref, computed, watch } from 'vue';
import { api } from '../api';
import { notify, confirmAction } from '../services/notification';

const props = defineProps({
  show: { type: Boolean, default: false },
  user: { type: Object, default: null },
  availableDistributors: { type: Array, default: () => [] }
});
const emit = defineEmits(['close', 'deleted']);

const step = ref('choice'); // 'choice' | 'confirm' | 'reassign'
const action = ref(null); // 'member' | 'purge'
const submitting = ref(false);
const reassigning = ref(false);
const dealers = ref([]);
const bulkDistributorId = ref(null);
const individualDistributorId = ref({});
// 재배정을 적용해도 목록에서 대리점 행 자체는 지우지 않고, 어떤 대리점이 끝났는지만 표시로 남긴다.
const appliedDealerIds = ref({});
const allDealersApplied = computed(() => dealers.value.length > 0 && dealers.value.every((d) => appliedDealerIds.value[d.id]));
// confirm 화면에 재배정을 마치고 돌아온 건지 기억해뒀다가, "이전"을 눌렀을 때
// 선택 화면이 아니라 재배정 화면으로 돌아가게 한다.
const cameFromReassign = ref(false);

// 관리자(is_owner)가 아닌 제조사·총판 소속 개인 직원은 [모든 데이터 삭제]가 [회원 삭제]와 결과가 같아
// 고를 필요가 없다 — 회사 단위 대상(대리점, 총판 관리자)만 선택 화면을 거친다.
const isStaffTarget = computed(() => !!props.user && !props.user.is_owner && ['admin', 'distributor'].includes(props.user.role));

// 총판 관리자(is_owner)는 자기 자신 명의로 직접 발주한 이력(POST /orders/self)을 가질 수 있어
// [회원 삭제]와 [모든 데이터 삭제]의 결과가 서로 다르다 — 그대로 선택 화면을 거친다.
const isDistributorOwnerTarget = computed(() => !!props.user && props.user.is_owner && props.user.role === 'distributor');

const displayName = computed(() => {
  if (!props.user) return '';
  return isStaffTarget.value ? props.user.name : (props.user.company_name || props.user.name);
});

watch(() => props.show, (val) => {
  if (val) {
    dealers.value = [];
    bulkDistributorId.value = null;
    individualDistributorId.value = {};
    appliedDealerIds.value = {};
    cameFromReassign.value = false;
    if (isStaffTarget.value) {
      action.value = 'member';
      step.value = 'confirm';
    } else {
      action.value = null;
      step.value = 'choice';
    }
  }
});

const memberDescription = computed(() => {
  if (isDistributorOwnerTarget.value) {
    return `'${displayName.value}'의 개인정보(아이디·연락처·주소·사업자번호 등)만 삭제되며, 총판이 직접 발주한 이력을 포함해 발주·출고 이력은 모두 그대로 보존됩니다. 소속 직원 계정도 함께 삭제됩니다.`;
  }
  return '회원 계정의 개인정보(아이디·연락처·주소·사업자번호 등)만 삭제되며, 상호명과 발주·출고 등 업무 이력은 그대로 보존됩니다.';
});

const purgeDescription = computed(() => {
  if (props.user?.role === 'distributor') {
    return `'${displayName.value}'의 재고·판매가 정보와 총판이 직접 발주한 이력이 함께 삭제됩니다. 대리점이 발주해 총판이 전환해준 이력은 그대로 보존됩니다. 소속 직원 계정도 함께 삭제됩니다.`;
  }
  return `'${displayName.value}'의 발주·출고·판매 이력이 모두 함께 삭제됩니다.`;
});

const chosenDescription = computed(() => (action.value === 'member' ? memberDescription.value : purgeDescription.value));

function chooseAction(next) {
  action.value = next;
  cameFromReassign.value = false;
  step.value = 'confirm';
}

function close() {
  emit('close');
}

async function execute() {
  if (!props.user) return;
  submitting.value = true;
  try {
    if (action.value === 'member') {
      const { data } = await api.delete(`/users/${props.user.id}`);
      notify(data?.message || '회원 삭제 처리가 완료되었습니다.');
    } else {
      const { data } = await api.post(`/users/${props.user.id}/purge`);
      notify(data?.message || '모든 데이터가 삭제되었습니다.');
    }
    emit('deleted');
  } catch (err) {
    if (err.response?.status === 409 && err.response.data?.needsReassignment) {
      dealers.value = err.response.data.dealers || [];
      bulkDistributorId.value = null;
      individualDistributorId.value = {};
      appliedDealerIds.value = {};
      step.value = 'reassign';
    } else {
      notify(err.response?.data?.message || '처리 중 오류가 발생했습니다.', 'error');
    }
  } finally {
    submitting.value = false;
  }
}

// 상단 일괄 배정 드롭다운을 고르면, 아직 적용 전이라도 아래 개별 드롭다운에 같은 총판을
// 미리 채워서 "일괄 적용이 잘 될 것"임을 바로 눈으로 확인할 수 있게 한다.
watch(bulkDistributorId, (val) => {
  if (!val) return;
  const synced = {};
  for (const dealer of dealers.value) synced[dealer.id] = val;
  individualDistributorId.value = synced;
});

async function applyBulkReassign() {
  if (!bulkDistributorId.value || !dealers.value.length) return;
  const confirmed = await confirmAction({
    title: '재배정 확정',
    message: '선택한 총판으로 소속 대리점을 모두 재배정하시겠습니까?',
    confirmText: '재배정 확정'
  });
  if (!confirmed) return;
  reassigning.value = true;
  try {
    await Promise.all(
      dealers.value.map((dealer) => api.patch(`/users/${dealer.id}/distributor`, { distributor_id: bulkDistributorId.value }))
    );
    notify('소속 대리점을 모두 재배정했습니다.');
    const applied = { ...appliedDealerIds.value };
    for (const dealer of dealers.value) applied[dealer.id] = true;
    appliedDealerIds.value = applied;
    // 전체 적용은 한 번에 모든 대리점을 처리하는 동작이라, 개별 적용과 달리 검토할 필요 없이 바로 다음으로 넘어간다.
    proceedAfterReassign();
  } catch (err) {
    notify(err.response?.data?.message || '재배정 중 오류가 발생했습니다.', 'error');
  } finally {
    reassigning.value = false;
  }
}

async function applyIndividualReassign(dealer) {
  const distributorId = individualDistributorId.value[dealer.id];
  if (!distributorId) return;
  reassigning.value = true;
  try {
    await api.patch(`/users/${dealer.id}/distributor`, { distributor_id: distributorId });
    appliedDealerIds.value = { ...appliedDealerIds.value, [dealer.id]: true };
    notify('적용되었습니다.');
  } catch (err) {
    notify(err.response?.data?.message || '재배정 중 오류가 발생했습니다.', 'error');
  } finally {
    reassigning.value = false;
  }
}

function proceedAfterReassign() {
  cameFromReassign.value = true;
  step.value = 'confirm';
}

// 재배정 화면에서 넘어온 경우, "이전"을 누르면 완료 잠금을 풀어 다시 재배정할 수 있게 한다.
function goToPreviousStep() {
  if (cameFromReassign.value) {
    appliedDealerIds.value = {};
    step.value = 'reassign';
  } else {
    step.value = 'choice';
  }
}
</script>

<template>
  <section v-if="show && user" class="modal-backdrop" @click.self="close">
    <div class="modal" style="width:min(560px, 100%)">
      <template v-if="step === 'choice'">
        <h2>삭제 유형을 선택해주세요</h2>
        <p class="text-muted" style="margin:0 0 14px"><strong>'{{ displayName }}'</strong> 회원을 삭제합니다</p>
        <button type="button" class="delete-type-card" @click="chooseAction('member')">
          <h3>회원 삭제</h3>
          <p>{{ memberDescription }}</p>
        </button>
        <button type="button" class="delete-type-card" @click="chooseAction('purge')">
          <h3>모든 데이터 삭제</h3>
          <p>{{ purgeDescription }}</p>
        </button>
        <div class="actions end">
          <button class="secondary" type="button" @click="close">취소</button>
        </div>
      </template>

      <template v-else-if="step === 'confirm'">
        <h2>정말 삭제하시겠습니까?</h2>
        <p class="text-muted" style="margin:0 0 4px;font-weight:700">
          <strong>'{{ displayName }}'</strong> 회원을 {{ action === 'member' ? '삭제합니다' : '모든 데이터와 함께 삭제합니다' }}
        </p>
        <p class="text-muted">{{ chosenDescription }}</p>
        <p class="delete-warning">이 작업은 복구할 수 없습니다.</p>
        <div class="actions end">
          <button v-if="!isStaffTarget" class="secondary" type="button" :disabled="submitting" @click="goToPreviousStep">이전</button>
          <button v-else class="secondary" type="button" :disabled="submitting" @click="close">취소</button>
          <button class="btn-danger" type="button" :disabled="submitting" @click="execute">
            {{ submitting ? '처리 중...' : '삭제' }}
          </button>
        </div>
      </template>

      <template v-else-if="step === 'reassign'">
        <h2>소속 대리점을 먼저 확인해주세요</h2>
        <p class="text-muted">이 총판에 소속된 대리점이 남아있어 삭제할 수 없습니다. 아래에서 대리점을 다른 총판으로 재배정한 뒤 삭제를 진행해주세요.</p>

        <div style="margin-bottom:12px">
          <select v-model.number="bulkDistributorId" :disabled="allDealersApplied">
            <option :value="null">일괄 배정할 총판 선택</option>
            <option v-for="dist in availableDistributors" :key="dist.id" :value="dist.id">{{ dist.company_name }}</option>
          </select>
        </div>

        <table class="member-table">
          <thead><tr><th>대리점</th><th>재배정할 총판</th><th></th></tr></thead>
          <tbody>
            <tr v-for="dealer in dealers" :key="dealer.id">
              <td>{{ dealer.company_name || dealer.name }}</td>
              <td>
                <select v-model.number="individualDistributorId[dealer.id]" :disabled="!!appliedDealerIds[dealer.id]">
                  <option :value="null">총판 선택</option>
                  <option v-for="dist in availableDistributors" :key="dist.id" :value="dist.id">{{ dist.company_name }}</option>
                </select>
              </td>
              <td>
                <span v-if="appliedDealerIds[dealer.id]" class="badge s-SHIPPED">완료</span>
                <button
                  v-else
                  type="button"
                  :disabled="!individualDistributorId[dealer.id] || reassigning"
                  @click="applyIndividualReassign(dealer)"
                >적용</button>
              </td>
            </tr>
          </tbody>
        </table>

        <div class="actions end">
          <button class="secondary" type="button" @click="close">닫기</button>
          <button
            class="primary"
            type="button"
            style="white-space:nowrap;flex-shrink:0"
            :disabled="allDealersApplied ? false : (!bulkDistributorId || reassigning)"
            @click="allDealersApplied ? proceedAfterReassign() : applyBulkReassign()"
          >
            {{ allDealersApplied ? '다음' : '전체 적용' }}
          </button>
        </div>
      </template>
    </div>
  </section>
</template>

<style scoped>
.delete-type-card {
  display: block;
  width: 100%;
  text-align: left;
  background: var(--panel);
  border: 1px solid var(--line);
  border-radius: 8px;
  padding: 14px;
  margin-bottom: 12px;
  cursor: pointer;
  transition: border-color .15s, background .15s;
}
.delete-type-card:hover {
  border-color: var(--navy);
  background: #f5f7fb;
}
.delete-type-card h3 {
  margin: 0 0 6px;
  color: var(--red);
}
.delete-type-card p {
  margin: 0;
  color: var(--muted);
  font-size: 13px;
  line-height: 1.5;
}
.delete-warning {
  color: var(--red);
  font-weight: 700;
  margin: 10px 0 0;
}
</style>
