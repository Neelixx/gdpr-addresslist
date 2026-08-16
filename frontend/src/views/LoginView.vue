<template>
  <div class="login">
    <div class="login-card">
      <h1>Anmelden</h1>
      
      <div class="tabs">
        <button 
          :class="['tab', { active: loginMode === 'password' }]" 
          @click="loginMode = 'password'"
        >
          Passwort
        </button>
        <button 
          :class="['tab', { active: loginMode === 'magic' }]" 
          @click="loginMode = 'magic'"
        >
          Magic Link
        </button>
      </div>
      
      <form v-if="loginMode === 'password'" @submit.prevent="loginWithPassword">
        <div class="form-group">
          <label for="username">Benutzername / E-Mail</label>
          <input
            v-model="username"
            type="text"
            id="username"
            placeholder="admin"
            required
          />
        </div>
        <div class="form-group">
          <label for="password">Passwort</label>
          <input
            v-model="password"
            type="password"
            id="password"
            placeholder="Passwort"
            required
          />
        </div>
        <button type="submit" :disabled="loading" class="btn-primary">
          {{ loading ? 'Anmelden...' : 'Anmelden' }}
        </button>
      </form>
      
      <form v-else @submit.prevent="requestLink">
        <div class="form-group">
          <label for="email">E-Mail</label>
          <input
            v-model="email"
            type="email"
            id="email"
            placeholder="ihre@email.de"
            required
          />
        </div>
        <button type="submit" :disabled="loading" class="btn-primary">
          {{ loading ? 'Senden...' : 'Magic Link anfordern' }}
        </button>
      </form>
      
      <div v-if="magicLink" class="magic-link">
        <p><strong>Magic Link generiert:</strong></p>
        <code>{{ magicLink }}</code>
        <p class="hint">Kopieren Sie diesen Link in Ihren Browser.</p>
      </div>
      
      <div v-if="error" class="error">
        {{ error }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { requestMagicLink, verifyMagicLink } from '../api/auth'
import api from '../api/client'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const loginMode = ref<'password' | 'magic'>('password')
const username = ref('')
const password = ref('')
const email = ref('')
const loading = ref(false)
const magicLink = ref('')
const error = ref('')

onMounted(() => {
  error.value = ''
  magicLink.value = ''
  const token = route.query.token
  if (token) {
    verifyToken(token as string)
  }
})

async function loginWithPassword() {
  if (loading.value) return
  loading.value = true
  error.value = ''
  magicLink.value = ''
  try {
    const response = await api.post('/auth/login', {
      username: username.value,
      password: password.value
    })
    authStore.setAuth(response.data.access_token, Number(response.data.person_id), !!response.data.admin)
    username.value = ''
    password.value = ''
    window.location.href = '/meine-daten'
  } catch (e: any) {
    error.value = e.response?.data?.detail || 'Anmeldung fehlgeschlagen'
  } finally {
    loading.value = false
  }
}

async function requestLink() {
  loading.value = true
  error.value = ''
  try {
    const response = await requestMagicLink({ email: email.value })
    magicLink.value = response.data.magic_link
  } catch (e: any) {
    error.value = e.response?.data?.detail || 'Fehler beim Anfordern des Magic Links'
  } finally {
    loading.value = false
  }
}

async function verifyToken(token: string) {
  loading.value = true
  error.value = ''
  try {
    const response = await verifyMagicLink({ token })
    authStore.setAuth(response.data.access_token, response.data.person_id, response.data.admin)
    router.push('/meine-daten')
  } catch (e: any) {
    error.value = e.response?.data?.detail || 'Ungültiger oder abgelaufener Token'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: calc(100vh - 80px);
}

.login-card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  max-width: 400px;
  width: 100%;
}

h1 {
  margin-bottom: 1rem;
  color: #2c3e50;
}

.tabs {
  display: flex;
  margin-bottom: 1.5rem;
  border-bottom: 2px solid #eee;
}

.tab {
  flex: 1;
  padding: 0.75rem;
  background: none;
  border: none;
  cursor: pointer;
  font-size: 1rem;
  color: #666;
  border-bottom: 2px solid transparent;
  margin-bottom: -2px;
}

.tab.active {
  color: #3498db;
  border-bottom-color: #3498db;
  font-weight: 500;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

.btn-primary {
  width: 100%;
  padding: 0.75rem;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
}

.btn-primary:disabled {
  background-color: #95a5a6;
  cursor: not-allowed;
}

.magic-link {
  margin-top: 1.5rem;
  padding: 1rem;
  background-color: #f8f9fa;
  border-radius: 4px;
}

.magic-link code {
  display: block;
  word-break: break-all;
  margin: 0.5rem 0;
  font-size: 0.85rem;
}

.hint {
  font-size: 0.85rem;
  color: #666;
}

.error {
  margin-top: 1rem;
  padding: 0.75rem;
  background-color: #fee;
  color: #c00;
  border-radius: 4px;
}
</style>
