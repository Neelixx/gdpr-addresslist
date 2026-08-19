<template>
  <div class="home">
    <h1>Willkommen bei der Alumni-Adressverwaltung</h1>
    <p class="subtitle">DSGVO-konforme Verwaltung von Kontaktdaten für Alumni-Events</p>
    
    <div class="features">
      <div class="feature">
        <h3>Datenschutz</h3>
        <p>Vollständige DSGVO-Konformität mit expliziter Einwilligungsverwaltung</p>
      </div>
      <div class="feature">
        <h3>Self-Service</h3>
        <p>Eigenständige Verwaltung Ihrer Daten und Einwilligungen</p>
      </div>
      <div class="feature">
        <h3>Recht auf Vergessenwerden</h3>
        <p>Einfache Löschung oder Anonymisierung Ihrer Daten</p>
      </div>
    </div>
    
    <div v-if="isLoggedIn && alumniWebsite" class="alumni-website">
      <h3>Alumni-Netzwerk</h3>
      <a :href="alumniWebsite" target="_blank" rel="noopener noreferrer" class="btn-primary">
        Zur Alumni-Webseite
      </a>
    </div>
    
    <div class="cta">
      <router-link v-if="!isLoggedIn" to="/login" class="btn-primary">Anmelden</router-link>
      <router-link v-else to="/meine-daten" class="btn-primary">Zu Meine Daten</router-link>
      <router-link to="/privacy" class="btn-secondary">Datenschutzerklärung</router-link>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { getPrivacyPolicy as getPrivacyPolicyApi } from '../api/admin'

const authStore = useAuthStore()
const isLoggedIn = computed(() => authStore.isLoggedIn)
const alumniWebsite = ref('')

async function loadPrivacyPolicy() {
  try {
    const response = await getPrivacyPolicyApi()
    alumniWebsite.value = response.data.alumni_website || ''
  } catch (e) {
    console.error('Fehler beim Laden der Datenschutzerklärung', e)
  }
}

onMounted(() => {
  loadPrivacyPolicy()
})
</script>

<style scoped>
.home {
  text-align: center;
  padding: 4rem 2rem;
}

h1 {
  color: #2c3e50;
  margin-bottom: 1rem;
}

.subtitle {
  color: #666;
  font-size: 1.1rem;
  margin-bottom: 3rem;
}

.features {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-bottom: 3rem;
}

.feature {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.feature h3 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.feature p {
  color: #666;
}

.alumni-website {
  margin-bottom: 2rem;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 1rem;
}

.alumni-website h3 {
  margin: 0;
  color: #2c3e50;
}

.cta {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

.btn-primary, .btn-secondary {
  padding: 0.75rem 2rem;
  border-radius: 4px;
  text-decoration: none;
  font-weight: 500;
}

.btn-primary {
  background-color: #3498db;
  color: white;
}

.btn-primary:hover {
  background-color: #2980b9;
}

.btn-secondary {
  background-color: #95a5a6;
  color: white;
}

.btn-secondary:hover {
  background-color: #7f8c8d;
}
</style>
