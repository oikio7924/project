<script setup>
import { dismissToast, notificationState, resolveConfirm } from '../services/notification';
import AlertModal from './AlertModal.vue';
</script>

<template>
  <TransitionGroup name="toast" tag="div" class="toast-stack" aria-live="polite">
    <div
      v-for="toast in notificationState.toasts"
      :key="toast.id"
      class="app-toast"
      :class="`toast-${toast.type}`"
    >
      <span>{{ toast.message }}</span>
      <button type="button" aria-label="알림 닫기" @click="dismissToast(toast.id)">×</button>
    </div>
  </TransitionGroup>

  <AlertModal
    v-if="notificationState.confirm"
    :show="!!notificationState.confirm"
    :title="notificationState.confirm.title"
    :message="notificationState.confirm.message"
    :confirm-text="notificationState.confirm.confirmText"
    cancel-text="취소"
    :danger="notificationState.confirm.danger"
    @confirm="resolveConfirm(true)"
    @cancel="resolveConfirm(false)"
  />
</template>
