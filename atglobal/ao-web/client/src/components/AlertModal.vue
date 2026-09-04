<script setup>
import { watch, onUnmounted } from 'vue';

const props = defineProps({
  show:        { type: Boolean, default: false },
  title:       { type: String,  default: '알림' },
  message:     { type: String,  default: '' },
  confirmText: { type: String,  default: '확인' },
  cancelText:  { type: String,  default: '' },
  danger:      { type: Boolean, default: false },
});
const emit = defineEmits(['confirm', 'cancel']);

function onKeydown(e) {
  if (e.key === 'Escape') emit('cancel');
  if (e.key === 'Enter')  emit('confirm');
}

watch(() => props.show, (val) => {
  if (val) document.addEventListener('keydown', onKeydown);
  else     document.removeEventListener('keydown', onKeydown);
});

onUnmounted(() => document.removeEventListener('keydown', onKeydown));
</script>

<template>
  <Teleport to="body">
    <div v-if="show" class="alert-modal-overlay" @click.self="$emit('cancel')">
      <div class="alert-modal" role="alertdialog" aria-modal="true">
        <div class="alert-modal-title">{{ title }}</div>
        <div class="alert-modal-message">{{ message }}</div>
        <div class="alert-modal-actions" :class="{ 'two-btn': cancelText }">
          <button v-if="cancelText" class="secondary alert-modal-btn" type="button" @click="$emit('cancel')">{{ cancelText }}</button>
          <button
            class="alert-modal-btn"
            :class="danger ? 'btn-danger' : 'primary'"
            type="button"
            @click="$emit('confirm')"
          >{{ confirmText }}</button>
        </div>
      </div>
    </div>
  </Teleport>
</template>
