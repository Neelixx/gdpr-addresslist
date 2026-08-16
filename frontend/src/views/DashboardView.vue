<template>
  <div class="dashboard">
    <h1>Meine Daten</h1>
    
    <div v-if="!person" class="loading">
      Lade Daten...
    </div>
    
    <div v-else>
      <div class="card">
        <h2>Meine Daten</h2>
        <form @submit.prevent="updateData">
          <div class="form-row">
            <div class="form-group">
              <label>Benutzername</label>
              <input v-model="form.username" type="text" />
            </div>
            <div class="form-group">
              <label>Vorname</label>
              <input v-model="form.vorname" type="text" />
            </div>
            <div class="form-group">
              <label>Nachname</label>
              <input v-model="form.nachname" type="text" />
            </div>
          </div>
          
          <div class="form-group">
            <label>Geburtsname</label>
            <input v-model="form.geburtsname" type="text" />
          </div>
          
          <div class="form-row">
            <div class="form-group">
              <label>E-Mail 1</label>
              <input v-model="form.email_1" type="email" />
            </div>
            <div class="form-group">
              <label>E-Mail 2</label>
              <input v-model="form.email_2" type="email" />
            </div>
          </div>
          
          <div class="form-group">
            <label>Erreichbarkeit</label>
            <select v-model="form.erreichbarkeit">
              <option value="-unbekannt-">-unbekannt-</option>
              <option value="E-Mail">E-Mail</option>
              <option value="Festnetz">Festnetz</option>
              <option value="WhatsApp">WhatsApp</option>
              <option value="verstorben">verstorben</option>
            </select>
          </div>
          
          <div class="form-row">
            <div class="form-group">
              <label>Telefon 1</label>
              <input v-model="form.telefon_1" type="tel" />
            </div>
            <div class="form-group">
              <label>Telefon 2</label>
              <input v-model="form.telefon_2" type="tel" />
            </div>
          </div>
          
          <div class="form-group">
            <label>Mobil</label>
            <input v-model="form.mobil" type="tel" />
          </div>
          
          <div class="form-group">
            <label>Adresse</label>
            <input v-model="form.adresse" type="text" />
          </div>
          
          <div class="form-row">
            <div class="form-group">
              <label>PLZ</label>
              <input v-model="form.plz" type="text" />
            </div>
            <div class="form-group">
              <label>Ort</label>
              <input v-model="form.ort" type="text" />
            </div>
            <div class="form-group">
              <label>Land</label>
              <input v-model="form.land" type="text" />
            </div>
          </div>
          
          <div class="form-group">
            <label>Notizen</label>
            <textarea v-model="form.notizen" rows="3"></textarea>
          </div>
          
          <button type="submit" :disabled="saving" class="btn-primary">
            {{ saving ? 'Speichern...' : 'Speichern' }}
          </button>
        </form>
      </div>
      
      <div class="card">
        <h2>Einwilligungen</h2>
        <ConsentManager :person="person" @updated="loadData" />
      </div>
      
      <div class="card">
        <h2>Passwort ändern</h2>
        <form @submit.prevent="changePassword">
          <div class="form-row">
            <div class="form-group">
              <label>Neues Passwort</label>
              <input v-model="newPassword" type="password" required />
            </div>
            <div class="form-group">
              <label>Passwort bestätigen</label>
              <input v-model="confirmPassword" type="password" required />
            </div>
          </div>
          <button type="submit" :disabled="changingPassword" class="btn-primary">
            {{ changingPassword ? 'Speichern...' : 'Passwort ändern' }}
          </button>
        </form>
      </div>
      
      <div class="card">
        <h2>Daten exportieren</h2>
        <button @click="exportData" class="btn-secondary">
          Meine Daten exportieren (CSV)
        </button>
      </div>
      
      <div class="card danger">
        <h2>Löschung</h2>
        <p>Löschen Sie Ihre Daten gemäß dem Recht auf Vergessenwerden.</p>
        <button @click="deleteData" class="btn-danger">
          Daten löschen
        </button>
      </div>
      
      <div v-if="isAdmin" class="card admin">
        <h2>Admin-Bereich</h2>
        <router-link to="/admin" class="btn-admin">Admin-Panel</router-link>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { getMyData, updateMyData, deleteMyData, exportData as exportDataApi, changePassword as changePasswordApi } from '../api/persons'
import type { Person } from '../api/persons'
import ConsentManager from '../components/ConsentManager.vue'

const router = useRouter()
const authStore = useAuthStore()
const person = ref<Person | null>(null)
const saving = ref(false)
const changingPassword = ref(false)
const isAdmin = computed(() => authStore.isAdmin)

const form = reactive({
  username: '',
  vorname: '',
  nachname: '',
  geburtsname: '',
  email_1: '',
  email_2: '',
  telefon_1: '',
  telefon_2: '',
  mobil: '',
  adresse: '',
  plz: '',
  ort: '',
  land: '',
  notizen: '',
  erreichbarkeit: '-unbekannt-'
})

const newPassword = ref('')
const confirmPassword = ref('')

onMounted(() => {
  loadData()
})

async function loadData() {
  try {
    const response = await getMyData()
    person.value = response.data
    form.username = response.data.username || ''
    form.vorname = response.data.vorname
    form.nachname = response.data.nachname
    form.geburtsname = response.data.geburtsname || ''
    form.email_1 = response.data.email_1 || ''
    form.email_2 = response.data.email_2 || ''
    form.telefon_1 = response.data.telefon_1 || ''
    form.telefon_2 = response.data.telefon_2 || ''
    form.mobil = response.data.mobil || ''
    form.erreichbarkeit = response.data.erreichbarkeit || '-unbekannt-'
    form.adresse = response.data.adresse || ''
    form.plz = response.data.plz || ''
    form.ort = response.data.ort || ''
    form.land = response.data.land || ''
    form.notizen = response.data.notizen || ''
  } catch (e) {
    console.error('Fehler beim Laden der Daten', e)
  }
}

async function updateData() {
  if (form.erreichbarkeit === 'Festnetz' && !form.telefon_1 && !form.telefon_2) {
    alert('Bitte geben Sie mindestens eine Festnetznummer an, wenn die Erreichbarkeit auf Festnetz gesetzt wird.')
    return
  }
  if (form.erreichbarkeit === 'WhatsApp' && !form.mobil) {
    alert('Bitte geben Sie eine Mobilnummer an, wenn die Erreichbarkeit auf WhatsApp gesetzt wird.')
    return
  }
  if (form.erreichbarkeit === 'E-Mail' && !form.email_1 && !form.email_2) {
    alert('Bitte geben Sie mindestens eine E-Mail-Adresse an, wenn die Erreichbarkeit auf E-Mail gesetzt wird.')
    return
  }
  
  saving.value = true
  try {
    await updateMyData(form)
    alert('Daten erfolgreich aktualisiert')
  } catch (e) {
    alert('Fehler beim Speichern')
  } finally {
    saving.value = false
  }
}

async function exportData() {
  try {
    const response = await exportDataApi()
    const csv = convertToCSV(response.data)
    downloadCSV(csv, 'meine_daten.csv')
  } catch (e) {
    alert('Fehler beim Export')
  }
}

function convertToCSV(data: any[]): string {
  if (!data.length) return ''
  const headers = Object.keys(data[0]).filter(k => !['id', 'created_at', 'updated_at', 'is_deleted', 'is_blocked', 'password'].includes(k))
  const rows = [headers.join(',')]
  for (const row of data) {
    rows.push(headers.map(h => `"${row[h] || ''}"`).join(','))
  }
  return rows.join('\n')
}

function downloadCSV(csv: string, filename: string) {
  const blob = new Blob([csv], { type: 'text/csv' })
  const url = window.URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = filename
  a.click()
  window.URL.revokeObjectURL(url)
}

async function deleteData() {
  if (!confirm('Möchten Sie Ihre Daten wirklich löschen? Dies kann nicht rückgängig gemacht werden.')) {
    return
  }
  try {
    await deleteMyData()
    authStore.logout()
    router.push('/')
  } catch (e) {
    alert('Fehler beim Löschen')
  }
}

async function changePassword() {
  if (newPassword.value !== confirmPassword.value) {
    alert('Passwörter stimmen nicht überein')
    return
  }
  changingPassword.value = true
  try {
    await changePasswordApi(newPassword.value)
    alert('Passwort erfolgreich geändert')
    newPassword.value = ''
    confirmPassword.value = ''
  } catch (e) {
    alert('Fehler beim Ändern des Passworts')
  } finally {
    changingPassword.value = false
  }
}
</script>

<style scoped>
.dashboard {
  max-width: 800px;
  margin: 0 auto;
}

h1 {
  margin-bottom: 2rem;
  color: #2c3e50;
}

.card {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  margin-bottom: 2rem;
}

.card h2 {
  margin-bottom: 1.5rem;
  color: #2c3e50;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

input, textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

.btn-primary {
  padding: 0.75rem 1.5rem;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
}

.btn-primary:disabled {
  background-color: #95a5a6;
  cursor: not-allowed;
}

.btn-secondary {
  padding: 0.75rem 1.5rem;
  background-color: #95a5a6;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
}

.btn-danger {
  padding: 0.75rem 1.5rem;
  background-color: #c0392b;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1rem;
}

.btn-danger:hover {
  background-color: #a93226;
}

.danger {
  border-left: 4px solid #c0392b;
}

.admin {
  border-left: 4px solid #27ae60;
}

.btn-admin {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  background-color: #27ae60;
  color: white;
  text-decoration: none;
  border-radius: 4px;
}

.loading {
  text-align: center;
  padding: 2rem;
  color: #666;
}
</style>
