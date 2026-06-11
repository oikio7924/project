<script setup>
import { ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useAuthStore } from '../stores/auth';

defineProps({
  title: { type: String, required: true },
  menu: { type: Array, default: () => [] }
});

const router = useRouter();
const route = useRoute();
const auth = useAuthStore();

const roleLabel = { admin: 'ADMIN', distributor: 'DISTRIBUTOR', dealer: 'DEALER' };
const drawer = ref(false);

async function logout() {
  await auth.logout();
  router.push('/login');
}
</script>

<template>
  <div class="app-shell">

    <!-- ── 브랜드 바 ── -->
    <div class="brand-bar">
      <div class="brand-bar-left">
        <!-- 모바일 햄버거 -->
        <button class="hamburger" aria-label="메뉴" @click="drawer = true">☰</button>
        <span class="brand-name">AT GLOBAL</span>
        <span class="brand-divider"></span>
        <span class="brand-sub">종합 유통 관리 시스템</span>
      </div>
      <div class="brand-bar-right">
        <span class="role-tag">{{ roleLabel[auth.user?.role] }}</span>
        <span class="user-name">{{ auth.user?.company_name || auth.user?.name }}</span>
        <button class="btn-logout" type="button" @click="logout">로그아웃</button>
      </div>
    </div>

    <!-- ── 네비게이션 바 (태블릿·데스크톱) ── -->
    <nav class="nav-bar">
      <router-link
        v-for="item in menu"
        :key="item.to"
        :to="item.to"
        class="nav-item"
        :class="{ on: route.path === item.to || (item.to !== '/admin' && item.to !== '/distributor' && route.path.startsWith(item.to)) }"
      >
        {{ item.label }}
      </router-link>
    </nav>

    <!-- ── 모바일 드로어 오버레이 ── -->
    <transition name="fade">
      <div v-if="drawer" class="drawer-overlay" @click.self="drawer = false">
        <transition name="slide">
          <div class="drawer">
            <div class="drawer-header">
              <div>
                <div class="drawer-brand">AT GLOBAL</div>
                <div class="drawer-user-info">
                  <span class="drawer-role">{{ roleLabel[auth.user?.role] }}</span>
                  {{ auth.user?.company_name || auth.user?.name }}
                </div>
              </div>
              <button class="drawer-close" @click="drawer = false">✕</button>
            </div>
            <nav class="drawer-nav">
              <router-link
                v-for="item in menu"
                :key="item.to"
                :to="item.to"
                class="drawer-item"
                :class="{ on: route.path === item.to || (item.to !== '/admin' && item.to !== '/distributor' && route.path.startsWith(item.to)) }"
                @click="drawer = false"
              >
                {{ item.label }}
              </router-link>
            </nav>
            <button class="drawer-logout-btn" @click="logout">로그아웃</button>
          </div>
        </transition>
      </div>
    </transition>

    <!-- ── 콘텐츠 ── -->
    <main class="workspace">
      <div class="page-title">{{ title }}</div>
      <slot />
    </main>

  </div>
</template>
