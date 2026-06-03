<script setup>
defineProps({
  label: String,
  value: [String, Number],
  hint: String
});
</script>

<template>
  <section class="kpi">
    <span>{{ label }}</span>
    <strong>{{ value }}</strong>
    <small>{{ hint }}</small>
  </section>
</template>
