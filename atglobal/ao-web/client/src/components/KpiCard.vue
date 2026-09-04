<script setup>
defineProps({
  label: String,
  value: [String, Number],
  hint: String,
  note: String
});
</script>

<template>
  <section class="kpi">
    <div class="kpi-label-row">
      <span>{{ label }}</span>
      <small v-if="note" class="kpi-note">{{ note }}</small>
    </div>
    <div class="kpi-value-row">
      <strong>{{ value }}</strong>
      <em v-if="hint" class="kpi-unit">{{ hint }}</em>
    </div>
  </section>
</template>
