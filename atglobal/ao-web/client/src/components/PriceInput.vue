<script setup>
defineProps({
  modelValue: { type: Number, default: 0 },
  placeholder: { type: String, default: '0' }
});
const emit = defineEmits(['update:modelValue']);

function format(v) {
  const n = Number(v) || 0;
  return n ? n.toLocaleString('ko-KR', { maximumFractionDigits: 0 }) : '';
}

function onInput(e) {
  const raw = e.target.value.replace(/[^0-9]/g, '');
  const num = Number(raw) || 0;
  emit('update:modelValue', num);
  e.target.value = format(num);
}
</script>

<template>
  <input
    type="text"
    inputmode="numeric"
    :value="format(modelValue)"
    :placeholder="placeholder"
    @input="onInput"
  />
</template>
