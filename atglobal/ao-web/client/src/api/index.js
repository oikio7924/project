import axios from 'axios';

export const api = axios.create({
  baseURL: '/api',
  withCredentials: true
});

export async function request(promise) {
  try {
    const { data } = await promise;
    return data;
  } catch (error) {
    throw new Error(error.response?.data?.message || '요청 처리 중 오류가 발생했습니다.');
  }
}
