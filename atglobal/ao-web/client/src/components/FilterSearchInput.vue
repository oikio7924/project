<script setup>
import { computed, ref } from 'vue';

const props = defineProps({
  options: { type: Array, default: () => [] }, // [{ value, display }]
  placeholder: { type: String, default: '선택 또는 검색어 입력' }
});
const emit = defineEmits(['add']);

const text = ref('');
const open = ref(false);
const highlight = ref(-1);

const filtered = computed(() => {
  const q = text.value.trim().toLowerCase();
  if (!q) return props.options;
  return props.options.filter((o) => String(o.display).toLowerCase().includes(q) || String(o.value).toLowerCase().includes(q));
});

function confirm() {
  const picked = highlight.value >= 0 ? filtered.value[highlight.value] : null;
  const value = picked ? picked.value : text.value.trim();
  if (!value) return;
  emit('add', value);
  text.value = '';
  open.value = false;
  highlight.value = -1;
}

function choose(opt) {
  emit('add', opt.value);
  text.value = '';
  open.value = false;
  highlight.value = -1;
}

function onBlur() {
  setTimeout(() => { open.value = false; highlight.value = -1; }, 150);
}

function move(delta) {
  if (!open.value) { open.value = true; return; }
  const max = filtered.value.length - 1;
  if (max < 0) return;
  highlight.value = Math.min(max, Math.max(0, highlight.value + delta));
}
</script>

<template>
  <div class="search-combo">
    <input
      type="text"
      class="filter-val-select"
      v-model="text"
      :placeholder="placeholder"
      @focus="open = true"
      @input="open = true; highlight = -1"
      @keydown.enter.prevent="confirm"
      @keydown.down.prevent="move(1)"
      @keydown.up.prevent="move(-1)"
      @keydown.esc="open = false"
      @blur="onBlur"
    />
    <ul v-if="open && filtered.length" class="search-combo-list">
      <li v-for="(opt, i) in filtered" :key="opt.value" :class="{ active: i === highlight }" @mousedown.prevent="choose(opt)">
        {{ opt.display }}
      </li>
    </ul>
  </div>
</template>

<style scoped>
.search-combo {
  position: relative;
  display: inline-block;
}
.search-combo-list {
  position: absolute;
  top: calc(100% + 2px);
  left: 0;
  width: 100%;
  max-height: 90px;
  overflow-y: auto;
  margin: 0;
  padding: 0;
  list-style: none;
  background: #fff;
  border: 1px solid var(--line);
  border-radius: 6px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.08);
  z-index: 50;
}
.search-combo-list li {
  padding: 6px 10px;
  font-size: 12px;
  line-height: 18px;
  cursor: pointer;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.search-combo-list li:hover,
.search-combo-list li.active {
  background: #eff4ff;
}
</style>
