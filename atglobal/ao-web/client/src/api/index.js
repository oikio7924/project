import axios from 'axios';
import { notify } from '../services/notification';

export const api = axios.create({
  baseURL: '/api',
  withCredentials: true
});

const successMessages = {
  post: '처리가 완료되었습니다.',
  patch: '저장되었습니다.',
  put: '저장되었습니다.',
  delete: '삭제되었습니다.'
};

export async function request(promise, options = {}) {
  try {
    const { data, config } = await promise;
    const method = config?.method?.toLowerCase();
    if (!options.silent && successMessages[method]) {
      notify(options.successMessage || data?.message || successMessages[method]);
    }
    return data;
  } catch (error) {
    const message = error.response?.data?.message || '요청 처리 중 오류가 발생했습니다.';
    if (!options.silent) notify(message, 'error');
    throw new Error(message);
  }
}
