import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueDevTools(),
  ],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:9898',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '')
      },
      '/pro-api': {
        target: 'http://localhost:9198',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/pro-api/, '')
      }
    }
  }
})
