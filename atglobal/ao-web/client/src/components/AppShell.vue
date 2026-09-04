<script setup>
import { computed, ref } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import headerLogo from '../assets/header_logo.png';

const props = defineProps({
  title: { type: String, required: true },
  menu: { type: Array, default: () => [] },
  refreshing: { type: Boolean, default: false },
  lastRefreshed: { type: Date, default: null }
});
defineEmits(['refresh']);

const lastRefreshedLabel = computed(() => {
  const d = props.lastRefreshed;
  if (!d) return '';
  const p = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}.${p(d.getMonth() + 1)}.${p(d.getDate())} ${p(d.getHours())}:${p(d.getMinutes())}:${p(d.getSeconds())} 기준`;
});

const router = useRouter();
const route = useRoute();
const auth = useAuthStore();

const roleLabel = { admin: 'ADMIN', distributor: 'DISTRIBUTOR', dealer: 'DEALER' };
const drawer = ref(false);

// 제조사는 고정 로고, 총판은 설정에서 직접 등록한 로고 — 등록 안 했으면 공란
const brandLogoSrc = computed(() => auth.user?.role === 'admin' ? headerLogo : (auth.user?.logo_url || null));

const homePath = computed(() => `/${auth.user?.role ?? ''}`);

function goHome() {
  drawer.value = false;
  if (route.path !== homePath.value) router.push(homePath.value);
}

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
        <img v-if="brandLogoSrc" :src="brandLogoSrc" alt="로고" class="brand-logo" role="button" @click="goHome" />
        <button v-if="!brandLogoSrc" class="btn-home" type="button" title="메인으로 이동" @click="goHome">
          <svg class="icon-home" viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 2.1 1 12h3v9h6v-6h4v6h6v-9h3z" /></svg>
          홈
        </button>
        <span class="brand-divider"></span>
        <span class="brand-sub">종합 유통 관리 시스템</span>
      </div>
      <div class="brand-bar-right">
        <span class="role-tag">{{ roleLabel[auth.user?.role] }}</span>
        <span class="user-name">{{ auth.user?.company_name }}</span>
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
        :class="{ on: route.path === item.to || (item.to !== '/admin' && item.to !== '/distributor' && route.path.startsWith(item.to + '/')) }"
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
                <img v-if="brandLogoSrc" :src="brandLogoSrc" alt="로고" class="drawer-brand-logo" role="button" @click="goHome" />
                <button v-if="!brandLogoSrc" class="btn-home drawer-btn-home" type="button" title="메인으로 이동" @click="goHome">
                  <svg class="icon-home" viewBox="0 0 24 24" width="14" height="14" fill="currentColor"><path d="M12 2.1 1 12h3v9h6v-6h4v6h6v-9h3z" /></svg>
                  홈
                </button>
                <div class="drawer-user-info">
                  <span class="drawer-role">{{ roleLabel[auth.user?.role] }}</span>
                  {{ auth.user?.company_name }}
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
                :class="{ on: route.path === item.to || (item.to !== '/admin' && item.to !== '/distributor' && route.path.startsWith(item.to + '/')) }"
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
      <div class="page-title-row">
        <div class="page-title">{{ title }}</div>
        <button class="ghost icon-btn page-refresh-btn" type="button" :disabled="refreshing"
          :class="{ spinning: refreshing }" title="새로고침" @click="$emit('refresh')">↻</button>
        <span v-if="lastRefreshedLabel" class="last-refreshed">{{ lastRefreshedLabel }}</span>
      </div>
      <div class="view-scroller">
        <slot />
      </div>
    </main>

  </div>
</template>
