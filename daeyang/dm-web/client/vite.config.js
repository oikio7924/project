import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      // 개발 시 /api 요청을 Express 서버로 전달
      '/api': 'http://localhost:3010'
    }
  }
})
