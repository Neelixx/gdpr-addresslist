<template>
  <div id="app">
    <nav class="navbar">
      <div class="nav-brand">
        <router-link to="/">Alumni Adressverwaltung</router-link>
      </div>
      <div class="nav-links">
        <router-link to="/">Startseite</router-link>
        <router-link to="/privacy">Datenschutz</router-link>
        <router-link to="/persons">Adressliste</router-link>
        <router-link v-if="!isLoggedIn" to="/login">Anmelden</router-link>
        <template v-else>
          <router-link to="/meine-daten">Meine Daten</router-link>
          <router-link v-if="isAdmin" to="/admin">Admin-Panel</router-link>
          <button @click="logout" class="btn-logout">Abmelden</button>
        </template>
      </div>
    </nav>
    <main class="container">
      <router-view />
    </main>
<footer class="footer">
        <div class="footer-content">
          <div class="footer-left">
            <a href="https://github.com/Neelixx/gdpr-addresslist" target="_blank" rel="noopener noreferrer">
              gdpr-addresslist, MIT-License
            </a>
          </div>
          <div class="footer-right">
            <span>Version {{ version }} • Commit {{ commit }}</span>
          </div>
        </div>
      </footer>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from './stores/auth'

const router = useRouter()
const authStore = useAuthStore()
const isLoggedIn = computed(() => !!authStore.token)
const isAdmin = computed(() => authStore.isAdmin)

const version = import.meta.env.VITE_APP_VERSION || '1.0.0'
const commit = import.meta.env.VITE_GIT_COMMIT || 'unknown'

function logout() {
  authStore.logout()
  router.push('/')
}
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background-color: #f5f5f5;
  color: #333;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.navbar {
  background-color: #2c3e50;
  color: white;
  padding: 1rem 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav-brand a {
  color: white;
  text-decoration: none;
  font-size: 1.25rem;
  font-weight: bold;
}

.nav-links {
  display: flex;
  gap: 1.5rem;
  align-items: center;
}

.nav-links a {
  color: white;
  text-decoration: none;
}

.nav-links a:hover {
  text-decoration: underline;
}

.btn-logout {
  background: none;
  border: 1px solid white;
  color: white;
  padding: 0.5rem 1rem;
  cursor: pointer;
  border-radius: 4px;
}

.btn-logout:hover {
  background: white;
  color: #2c3e50;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  flex: 1;
}

.footer {
  background-color: #2c3e50;
  color: white;
  padding: 1.5rem 2rem;
  margin-top: auto;
}

.footer-content {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
}

.footer-left {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.footer-left a {
  color: #3498db;
  text-decoration: none;
}

.footer-left a:hover {
  text-decoration: underline;
}

.footer-right {
  font-size: 0.85rem;
  color: #bdc3c7;
}

@media (max-width: 768px) {
  .footer-content {
    flex-direction: column;
    text-align: center;
  }
}
</style>
