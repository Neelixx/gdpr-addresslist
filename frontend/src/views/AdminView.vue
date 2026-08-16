<template>
  <div class="admin">
    <h1>Admin-Panel</h1>
    
    <div class="admin-grid">
      <div class="card">
        <h2>Benutzer anlegen</h2>
        <form @submit.prevent="createUser">
          <div class="form-row">
            <div class="form-group">
              <label>Benutzername</label>
              <input v-model="newUser.username" type="text" required />
            </div>
            <div class="form-group">
              <label>Passwort</label>
              <input v-model="newUser.password" type="password" required />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>Vorname</label>
              <input v-model="newUser.vorname" type="text" required />
            </div>
            <div class="form-group">
              <label>Nachname</label>
              <input v-model="newUser.nachname" type="text" required />
            </div>
          </div>
          <div class="form-group">
            <label>E-Mail</label>
            <input v-model="newUser.email_1" type="email" required />
          </div>
          <div class="form-group">
            <label>Gruppe</label>
            <select v-model="newUser.gruppe">
              <option value="student">SchülerIn</option>
              <option value="teacher">LehrerIn</option>
              <option value="classmate">MitschülerIn</option>
            </select>
          </div>
          <button type="submit" :disabled="creating" class="btn-primary">
            {{ creating ? 'Erstellen...' : 'Benutzer erstellen' }}
          </button>
        </form>
      </div>
      
      <div class="card">
        <h2>CSV Import</h2>
        <p class="hint">Importiert Personen aus einer CSV-Datei. Vor dem Import wird automatisch ein Backup erstellt.</p>
        <input type="file" @change="onFileSelect" accept=".csv" />
        <button @click="importCSV" :disabled="!selectedFile || importing" class="btn-primary">
          {{ importing ? 'Importiere...' : 'Importieren' }}
        </button>
      </div>
      
      <div class="card">
        <h2>Backup / Restore</h2>
        <div class="backup-actions">
          <button @click="downloadBackup" class="btn-secondary">
            Backup herunterladen
          </button>
          <div class="restore">
            <label>Restore aus .sql Datei:</label>
            <input type="file" @change="onRestoreSelect" accept=".sql" />
            <button @click="restoreDatabase" :disabled="!restoreFile || restoring" class="btn-danger">
              {{ restoring ? 'Wiederherstellen...' : 'Datenbank wiederherstellen' }}
            </button>
          </div>
        </div>
      </div>
      
      <div class="card">
        <h2>Export</h2>
        <button @click="exportAll" class="btn-secondary">
          Alle Daten exportieren (CSV)
        </button>
      </div>
      
      <div class="card">
        <h2>Magic Links generieren</h2>
        <p class="hint">Generiert Magic Links für ausgewählte Benutzer.</p>
        <div class="user-list">
          <div v-for="user in users" :key="user.id" class="user-item">
            <input type="checkbox" :value="user.id" v-model="selectedUserIds" />
            <label>{{ user.vorname }} {{ user.nachname }} ({{ user.email_1 }})</label>
          </div>
        </div>
        <button @click="generateLinks" :disabled="selectedUserIds.length === 0" class="btn-primary">
          Magic Links generieren
        </button>
      </div>
    </div>
    
    <div v-if="message" class="message">{{ message }}</div>
    <div v-if="error" class="error">{{ error }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { createPerson, getAllPersons, importCSV as importCSVApi, backupDatabase as backupDatabaseApi, restoreDatabase as restoreDatabaseApi, exportAllData as exportAllDataApi, generateMagicLinks as generateMagicLinksApi } from '../api/admin'

const authStore = useAuthStore()
const users = ref([])
const selectedUserIds = ref<number[]>([])
const creating = ref(false)
const importing = ref(false)
const restoring = ref(false)
const selectedFile = ref<File | null>(null)
const restoreFile = ref<File |null>(null)
const message = ref('')
const error = ref('')

const newUser = ref({
  username: '',
  password: '',
  vorname: '',
  nachname: '',
  email_1: '',
  gruppe: 'student'
})

onMounted(() => {
  loadUsers()
})

async function loadUsers() {
  try {
    users.value = await getAllPersons()
  } catch (e) {
    error.value = 'Fehler beim Laden der Benutzer'
  }
}

async function createUser() {
  creating.value = true
  try {
    await createPerson(newUser.value)
    message.value = 'Benutzer erfolgreich erstellt'
    newUser.value = {
      username: '',
      password: '',
      vorname: '',
      nachname: '',
      email_1: '',
      gruppe: 'student'
    }
    loadUsers()
  } catch (e) {
    error.value = 'Fehler beim Erstellen des Benutzers'
  } finally {
    creating.value = false
  }
}

function onFileSelect(event: Event) {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    selectedFile.value = target.files[0]
  }
}

function onRestoreSelect(event: Event) {
  const target = event.target as HTMLInputElement
  if (target.files && target.files[0]) {
    restoreFile.value = target.files[0]
  }
}

async function importCSV() {
  if (!selectedFile.value) return
  
  if (!confirm('Vor dem Import wird automatisch ein Backup erstellt. Fortfahren?')) {
    return
  }
  
  importing.value = true
  try {
    const result = await importCSVApi(selectedFile.value)
    message.value = result.message
    selectedFile.value = null
  } catch (e) {
    error.value = 'Fehler beim Import'
  } finally {
    importing.value = false
  }
}

async function downloadBackup() {
  try {
    const blob = await backupDatabaseApi()
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `backup_${new Date().toISOString().split('T')[0]}.sql`
    a.click()
    window.URL.revokeObjectURL(url)
  } catch (e) {
    error.value = 'Fehler beim Backup'
  }
}

async function restoreDatabase() {
  if (!restoreFile.value) return
  
  if (!confirm('Datenbank wirklich wiederherstellen? Alle aktuellen Daten gehen verloren!')) {
    return
  }
  
  restoring.value = true
  try {
    const result = await restoreDatabaseApi(restoreFile.value)
    message.value = result.message
    restoreFile.value = null
  } catch (e) {
    error.value = 'Fehler beim Wiederherstellen'
  } finally {
    restoring.value = false
  }
}

async function exportAll() {
  try {
    const result = await exportAllDataApi()
    const blob = new Blob([result.csv], { type: 'text/csv' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `export_${new Date().toISOString().split('T')[0]}.csv`
    a.click()
    window.URL.revokeObjectURL(url)
  } catch (e) {
    error.value = 'Fehler beim Export'
  }
}

async function generateLinks() {
  try {
    const result = await generateMagicLinksApi(selectedUserIds.value)
    message.value = `${result.links.length} Magic Links generiert`
    selectedUserIds.value = []
  } catch (e) {
    error.value = 'Fehler beim Generieren der Magic Links'
  }
}
</script>

<style scoped>
.admin {
  max-width: 1200px;
  margin: 0 auto;
}

h1 {
  margin-bottom: 2rem;
  color: #2c3e50;
}

.admin-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
  gap: 1.5rem;
}

.card {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.card h2 {
  margin-bottom: 1rem;
  color: #2c3e50;
  font-size: 1.1rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 1rem;
}

.form-group {
  margin-bottom: 1rem;
}

label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  font-size: 0.9rem;
}

input, select {
  width: 100%;
  padding: 0.6rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 0.95rem;
}

.btn-primary, .btn-secondary, .btn-danger {
  padding: 0.6rem 1.2rem;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.95rem;
  margin-top: 0.5rem;
}

.btn-primary {
  background-color: #3498db;
  color: white;
}

.btn-secondary {
  background-color: #95a5a6;
  color: white;
}

.btn-danger {
  background-color: #c0392b;
  color: white;
}

.btn-primary:disabled, .btn-secondary:disabled, .btn-danger:disabled {
  background-color: #bdc3c7;
  cursor: not-allowed;
}

.hint {
  font-size: 0.85rem;
  color: #666;
  margin-bottom: 1rem;
}

.backup-actions {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.restore {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.user-list {
  max-height: 200px;
  overflow-y: auto;
  border: 1px solid #eee;
  padding: 0.5rem;
  border-radius: 4px;
  margin-bottom: 1rem;
}

.user-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.3rem 0;
}

.user-item input {
  width: auto;
}

.user-item label {
  margin: 0;
  font-weight: normal;
}

.message {
  margin-top: 1rem;
  padding: 0.75rem;
  background-color: #d4edda;
  color: #155724;
  border-radius: 4px;
}

.error {
  margin-top: 1rem;
  padding: 0.75rem;
  background-color: #fee;
  color: #c00;
  border-radius: 4px;
}
</style>
