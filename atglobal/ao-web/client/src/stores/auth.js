import { defineStore } from 'pinia';
import { api, request } from '../api';

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    ready: false
  }),
  actions: {
    async loadMe() {
      try {
        const data = await request(api.get('/auth/me'));
        this.user = data.user;
      } catch {
        this.user = null;
      } finally {
        this.ready = true;
      }
    },
    async login(form) {
      const data = await request(api.post('/auth/login', form));
      this.user = data.user;
      return data.user;
    },
    async logout() {
      await request(api.post('/auth/logout'));
      this.user = null;
      localStorage.removeItem('atg_auto_login');
    }
  }
});
