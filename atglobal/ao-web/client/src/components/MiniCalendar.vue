<script setup>
import { computed, ref } from 'vue';

const props = defineProps({
  markedDates: { type: Array, default: () => [] },
  selectedDate: { type: String, default: null },
  allowAnyDate: { type: Boolean, default: false }
});
const emit = defineEmits(['select']);

const calBase = ref(new Date());
const calYear = computed(() => calBase.value.getFullYear());
const calMonth = computed(() => calBase.value.getMonth());
const calLabel = computed(() => `${calYear.value}년 ${calMonth.value + 1}월`);

const DOW = ['일', '월', '화', '수', '목', '금', '토'];

const cells = computed(() => {
  const firstDow = new Date(calYear.value, calMonth.value, 1).getDay();
  const daysInMonth = new Date(calYear.value, calMonth.value + 1, 0).getDate();
  const today = new Date();

  const result = [];
  for (let i = 0; i < firstDow; i++) result.push(null);
  for (let d = 1; d <= daysInMonth; d++) {
    const isToday = today.getFullYear() === calYear.value && today.getMonth() === calMonth.value && today.getDate() === d;
    const hasEvent = props.markedDates.some((dateStr) => {
      const md = new Date(dateStr);
      return md.getFullYear() === calYear.value && md.getMonth() === calMonth.value && md.getDate() === d;
    });
    const dateStr = `${calYear.value}-${String(calMonth.value + 1).padStart(2, '0')}-${String(d).padStart(2, '0')}`;
    const isSelected = props.selectedDate === dateStr;
    result.push({ d, isToday, hasEvent, dateStr, isSelected });
  }
  return result;
});

function prev() { calBase.value = new Date(calYear.value, calMonth.value - 1, 1); }
function next() { calBase.value = new Date(calYear.value, calMonth.value + 1, 1); }

function clickCell(cell) {
  if (!cell.hasEvent && !props.allowAnyDate) return;
  emit('select', cell.isSelected ? null : cell.dateStr);
}
</script>

<template>
  <div class="mini-cal">
    <div class="cal-head">
      <button class="cal-nav" type="button" @click="prev">‹</button>
      <span class="cal-title">{{ calLabel }}</span>
      <button class="cal-nav" type="button" @click="next">›</button>
    </div>
    <div class="cal-grid">
      <div v-for="(d, i) in DOW" :key="d" class="cal-dn" :class="{ sun: i === 0, sat: i === 6 }">{{ d }}</div>
      <template v-for="(cell, ci) in cells" :key="ci">
        <div v-if="!cell" class="cal-cell empty"></div>
        <div
          v-else
          class="cal-cell"
          :class="{
            today: cell.isToday && !cell.isSelected,
            'has-order': cell.hasEvent && !cell.isToday && !cell.isSelected,
            'cal-selected': cell.isSelected,
            'cal-clickable': cell.hasEvent || allowAnyDate,
            sun: (ci % 7) === 0 && !cell.isSelected,
            sat: (ci % 7) === 6 && !cell.isSelected
          }"
          @click="clickCell(cell)"
        >
          {{ cell.d }}
          <span v-if="cell.hasEvent && !cell.isToday" class="cal-dot"></span>
        </div>
      </template>
    </div>
    <div class="cal-legend">
      ● 발주 등록일
    </div>
  </div>
</template>
