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
              <option value="SchülerIn">SchülerIn</option>
              <option value="LehrerIn">LehrerIn</option>
              <option value="MitschülerIn">MitschülerIn</option>
            </select>
          </div>
          <button type="submit" :disabled="creating" class="btn-primary">
            {{ creating ? 'Erstellen...' : 'Benutzer erstellen' }}
          </button>
        </form>
      </div>
      
      <div class="card">
        <h2>Backup / Restore / Export / Import</h2>
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
          <button @click="exportAll" class="btn-secondary">
            Alle Daten exportieren (CSV)
          </button>
          <div class="import-section">
            <label>CSV Import:</label>
            <input type="file" @change="onFileSelect" accept=".csv" />
            <button @click="importCSV" :disabled="!selectedFile || importing" class="btn-primary">
              {{ importing ? 'Importiere...' : 'Importieren' }}
            </button>
          </div>
        </div>
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

      <div class="card full-width">
        <h2>Alle Benutzer verwalten</h2>
        <div class="table-container">
          <table class="admin-table">
          <thead>
            <tr>
              <th @click="adminSort('id')">ID <span v-if="adminSortKey === 'id'" class="sort-icon">{{ adminSortDirection === 'asc' ? '▲' : '▼' }}</span></th>
              <th @click="adminSort('vorname')">Vorname <span v-if="adminSortKey === 'vorname'" class="sort-icon">{{ adminSortDirection === 'asc' ? '▲' : '▼' }}</span></th>
              <th @click="adminSort('nachname')">Nachname <span v-if="adminSortKey === 'nachname'" class="sort-icon">{{ adminSortDirection === 'asc' ? '▲' : '▼' }}</span></th>
              <th @click="adminSort('email_1')">E-Mail <span v-if="adminSortKey === 'email_1'" class="sort-icon">{{ adminSortDirection === 'asc' ? '▲' : '▼' }}</span></th>
              <th @click="adminSort('username')">Benutzername <span v-if="adminSortKey === 'username'" class="sort-icon">{{ adminSortDirection === 'asc' ? '▲' : '▼' }}</span></th>
              <th @click="adminSort('gruppe')">Gruppe <span v-if="adminSortKey === 'gruppe'" class="sort-icon">{{ adminSortDirection === 'asc' ? '▲' : '▼' }}</span></th>
              <th @click="adminSort('admin')">Admin <span v-if="adminSortKey === 'admin'" class="sort-icon">{{ adminSortDirection === 'asc' ? '▲' : '▼' }}</span></th>
              <th>Aktionen</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in sortedUsers" :key="user.id">
              <td>{{ user.id }}</td>
              <td>{{ user.vorname }}</td>
              <td>{{ user.nachname }}</td>
              <td>{{ user.email_1 }}</td>
              <td>{{ user.username || '-' }}</td>
              <td>{{ user.gruppe }}</td>
              <td>{{ user.admin ? 'Ja' : 'Nein' }}</td>
              <td>
                <button @click="editUser(user)" class="btn-small">Bearbeiten</button>
              </td>
            </tr>
          </tbody>
          </table>
        </div>
      </div>
    </div>

    <div v-if="editingUser" class="modal-overlay" @click.self="cancelEdit">
      <div class="modal">
        <h3>Benutzer bearbeiten</h3>
        <form @submit.prevent="saveEdit">
          <div class="form-row">
            <div class="form-group">
              <label>Vorname</label>
              <input v-model="editForm.vorname" type="text" required />
            </div>
            <div class="form-group">
              <label>Nachname</label>
              <input v-model="editForm.nachname" type="text" required />
            </div>
          </div>
          <div class="form-group">
            <label>Geburtsname</label>
            <input v-model="editForm.geburtsname" type="text" />
          </div>
          <div class="form-group">
            <label>E-Mail 1</label>
            <input v-model="editForm.email_1" type="email" required />
          </div>
          <div class="form-group">
            <label>E-Mail 2</label>
            <input v-model="editForm.email_2" type="email" />
          </div>
          <div class="form-group">
            <label>Adresse</label>
            <input v-model="editForm.adresse" type="text" />
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>PLZ</label>
              <input v-model="editForm.plz" type="text" />
            </div>
            <div class="form-group">
              <label>Ort</label>
              <input v-model="editForm.ort" type="text" />
            </div>
            <div class="form-group">
              <label>Land</label>
              <input v-model="editForm.land" type="text" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>Telefon 1</label>
              <input v-model="editForm.telefon_1" type="tel" />
            </div>
            <div class="form-group">
              <label>Telefon 2</label>
              <input v-model="editForm.telefon_2" type="tel" />
            </div>
          </div>
          <div class="form-group">
            <label>Mobil</label>
            <input v-model="editForm.mobil" type="tel" />
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>Erreichbarkeit</label>
              <select v-model="editForm.erreichbarkeit">
                <option value="-unbekannt-">-unbekannt-</option>
                <option value="E-Mail">E-Mail</option>
                <option value="Festnetz">Festnetz</option>
                <option value="WhatsApp">WhatsApp</option>
                <option value="verstorben">verstorben</option>
              </select>
            </div>
            <div class="form-group">
              <label>Benutzername</label>
              <input v-model="editForm.username" type="text" />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label>Gruppe</label>
              <select v-model="editForm.gruppe">
                <option value="SchülerIn">SchülerIn</option>
                <option value="LehrerIn">LehrerIn</option>
                <option value="MitschülerIn">MitschülerIn</option>
              </select>
            </div>
            <div class="form-group">
              <label>
                <input type="checkbox" v-model="editForm.admin" />
                Admin-Rechte
              </label>
            </div>
          </div>
          <div class="form-actions">
            <button type="submit" class="btn-primary">Speichern</button>
            <button type="button" @click="cancelEdit" class="btn-secondary">Abbrechen</button>
          </div>
        </form>
      </div>
    </div>
    
    <div v-if="message" class="message">{{ message }}</div>
    <div v-if="error" class="error">{{ error }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { createPerson, updatePerson, getAllPersons, importCSV as importCSVApi, backupDatabase as backupDatabaseApi, restoreDatabase as restoreDatabaseApi, exportAllData as exportAllDataApi, generateMagicLinks as generateMagicLinksApi } from '../api/admin'

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
  gruppe: 'SchülerIn'
})

const editingUser = ref<any>(null)
const editForm = ref({
  vorname: '',
  nachname: '',
  geburtsname: '',
  adresse: '',
  land: '',
  ort: '',
  plz: '',
  telefon_1: '',
  telefon_2: '',
  mobil: '',
  erreichbarkeit: '-unbekannt-',
  email_1: '',
  email_2: '',
  username: '',
  gruppe: 'SchülerIn',
  admin: false
})

const adminSortKey = ref<string>('id')
const adminSortDirection = ref<'asc' | 'desc'>('asc')

const sortedUsers = computed(() => {
  const data = [...users.value]
  const key = adminSortKey.value
  const dir = adminSortDirection.value === 'asc' ? 1 : -1

  data.sort((a, b) => {
    const aVal = (a as any)[key] ?? ''
    const bVal = (b as any)[key] ?? ''
    const cmp = String(aVal).localeCompare(String(bVal), 'de')
    return dir * cmp
  })

  return data
})

function adminSort(key: string) {
  if (adminSortKey.value === key) {
    adminSortDirection.value = adminSortDirection.value === 'asc' ? 'desc' : 'asc'
  } else {
    adminSortKey.value = key
    adminSortDirection.value = 'asc'
  }
}

onMounted(() => {
  loadUsers()
})

async function loadUsers() {
  try {
    const response = await getAllPersons()
    users.value = response.data
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

function editUser(user: any) {
  editingUser.value = user
  editForm.value.vorname = user.vorname
  editForm.value.nachname = user.nachname
  editForm.value.geburtsname = user.geburtsname || ''
  editForm.value.adresse = user.adresse || ''
  editForm.value.land = user.land || ''
  editForm.value.ort = user.ort || ''
  editForm.value.plz = user.plz || ''
  editForm.value.telefon_1 = user.telefon_1 || ''
  editForm.value.telefon_2 = user.telefon_2 || ''
  editForm.value.mobil = user.mobil || ''
  editForm.value.erreichbarkeit = user.erreichbarkeit || '-unbekannt-'
  editForm.value.email_1 = user.email_1 || ''
  editForm.value.email_2 = user.email_2 || ''
  editForm.value.username = user.username || ''
  editForm.value.gruppe = user.gruppe
  editForm.value.admin = user.admin
}

function cancelEdit() {
  editingUser.value = null
}

async function saveEdit() {
  try {
    await updatePerson(editingUser.value.id, editForm.value)
    message.value = 'Benutzer aktualisiert'
    editingUser.value = null
    loadUsers()
  } catch (e) {
    error.value = 'Fehler beim Aktualisieren'
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
    const response = await importCSVApi(selectedFile.value)
    message.value = response.data.message
    selectedFile.value = null
  } catch (e) {
    error.value = 'Fehler beim Import'
  } finally {
    importing.value = false
  }
}

async function downloadBackup() {
  try {
    const response = await backupDatabaseApi()
    const blob = response.data
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
    const response = await restoreDatabaseApi(restoreFile.value)
    message.value = response.data.message
    restoreFile.value = null
  } catch (e) {
    error.value = 'Fehler beim Wiederherstellen'
  } finally {
    restoring.value = false
  }
}

async function exportAll() {
  try {
    const response = await exportAllDataApi()
    const blob = new Blob([response.data.csv], { type: 'text/csv' })
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
    const response = await generateMagicLinksApi(selectedUserIds.value)
    message.value = `${response.data.links.length} Magic Links generiert`
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

.full-width {
  grid-column: 1 / -1;
}

.table-container {
  overflow-x: auto;
}

.admin-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.95rem;
}

.admin-table th,
.admin-table td {
  text-align: left;
  padding: 0.75rem;
  border-bottom: 1px solid #eee;
}

.admin-table th {
  background-color: #f8f9fa;
  font-weight: 600;
  color: #2c3e50;
  cursor: pointer;
  user-select: none;
  white-space: nowrap;
}

.admin-table th:hover {
  background-color: #e9ecef;
}

.admin-table tr:hover {
  background-color: #f8f9fa;
}

.sort-icon {
  margin-left: 0.5rem;
  font-size: 0.8rem;
  color: #3498db;
}

.btn-small {
  padding: 0.4rem 0.8rem;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 0.85rem;
}

.btn-small:hover {
  background-color: #2980b9;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  width: 100%;
  max-width: 500px;
  max-height: 90vh;
  overflow-y: auto;
}

.modal h3 {
  margin-top: 0;
  margin-bottom: 1.5rem;
  color: #2c3e50;
}

.form-actions {
  display: flex;
  gap: 1rem;
  margin-top: 1.5rem;
}

.form-actions .btn-primary {
  flex: 1;
}

.form-actions .btn-secondary {
  flex: 1;
}
</style>
