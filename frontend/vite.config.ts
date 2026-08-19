import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { fileURLToPath, URL } from 'node:url'
import { execSync } from 'child_process'
import pkg from './package.json'

let commitHash = 'unknown'
try {
  commitHash = execSync('git rev-parse --short HEAD', { encoding: 'utf-8' }).trim()
} catch {
  commitHash = 'unknown'
}
const version = pkg.version

export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  define: {
    'import.meta.env.VITE_APP_VERSION': JSON.stringify(version),
    'import.meta.env.VITE_GIT_COMMIT': JSON.stringify(commitHash)
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://backend:8000',
        changeOrigin: true
      }
    }
  }
})
