<script setup>
defineProps({ status: String });

const labels = {
  PENDING: '수신 대기',
  RECEIVED: '수신 확인',
  CONVERTED: '전환 완료',
  CONFIRMED: '수주 확인',
  SHIPPED: '출고 완료',
  CANCELLED: '취소'
};
</script>

<template>
  <span class="badge" :class="`s-${status}`">{{ labels[status] || status }}</span>
</template>
