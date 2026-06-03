<script setup>
const props = defineProps({
  products: { type: Array, default: () => [] }
});
const rows = defineModel({ type: Array, default: () => [] });

function addRow() {
  rows.value.push({ product_id: props.products[0]?.id || '', quantity: 1, unit_price: props.products[0]?.base_price || 0 });
}

function removeRow(index) {
  rows.value.splice(index, 1);
}

function syncProduct(row) {
  const product = props.products.find((item) => item.id === Number(row.product_id));
  if (product) row.unit_price = product.base_price;
}

function money(value) {
  return Number(value || 0).toLocaleString('ko-KR');
}
</script>

<template>
  <div class="line-editor">
    <table>
      <thead>
        <tr>
          <th>제품</th>
          <th>수량</th>
          <th>단가</th>
          <th>합계</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(row, index) in rows" :key="index">
          <td>
            <select v-model.number="row.product_id" @change="syncProduct(row)">
              <option v-for="product in products" :key="product.id" :value="product.id">
                {{ product.name }} {{ product.model_name }}
              </option>
            </select>
          </td>
          <td><input v-model.number="row.quantity" type="number" min="1" /></td>
          <td><input v-model.number="row.unit_price" type="number" min="0" /></td>
          <td>{{ money(Number(row.quantity || 0) * Number(row.unit_price || 0)) }}</td>
          <td><button class="icon-btn" type="button" @click="removeRow(index)">×</button></td>
        </tr>
      </tbody>
    </table>
    <button class="secondary" type="button" @click="addRow">행 추가</button>
  </div>
</template>
