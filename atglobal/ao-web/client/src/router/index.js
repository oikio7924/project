import { createRouter, createWebHistory } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import LoginPage from '../pages/LoginPage.vue';
import AdminPage from '../pages/admin/AdminPage.vue';
import DistributorPage from '../pages/distributor/DistributorPage.vue';
import DealerPage from '../pages/dealer/DealerPage.vue';

const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', component: LoginPage },
  { path: '/register', component: LoginPage, props: { registerOnly: true } },
  { path: '/admin/:view?', component: AdminPage, meta: { role: 'admin' } },
  { path: '/distributor/:view?', component: DistributorPage, meta: { role: 'distributor' } },
  { path: '/dealer', component: DealerPage, meta: { role: 'dealer' } }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach(async (to) => {
  const auth = useAuthStore();
  if (!auth.ready) await auth.loadMe();

  if (to.path === '/login' && auth.user) {
    return auth.user.role === 'admin'
      ? '/admin'
      : auth.user.role === 'distributor'
        ? '/distributor'
        : '/dealer';
  }

  if (to.meta.role && !auth.user) return '/login';
  if (to.meta.role && auth.user.role !== to.meta.role) return '/login';
  return true;
});

export default router;
