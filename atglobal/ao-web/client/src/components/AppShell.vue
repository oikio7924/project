<script setup>
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth';

defineProps({
  title: { type: String, required: true },
  menu: { type: Array, default: () => [] }
});

const router = useRouter();
const auth = useAuthStore();

async function logout() {
  await auth.logout();
  router.push('/login');
}
</script>

<template>
  <div class="app-shell">
    <aside class="sidebar">
      <div class="brand">
        <strong>AT GLOBAL</strong>
        <span>{{ title }}</span>
      </div>
      <nav>
        <router-link v-for="item in menu" :key="item.to" :to="item.to">{{ item.label }}</router-link>
      </nav>
    </aside>
    <main class="workspace">
      <header class="topbar">
        <div>
          <p class="eyebrow">{{ auth.user?.company_name || auth.user?.name }}</p>
          <h1>{{ title }}</h1>
        </div>
        <button class="ghost" type="button" @click="logout">로그아웃</button>
      </header>
      <slot />
    </main>
  </div>
</template>
