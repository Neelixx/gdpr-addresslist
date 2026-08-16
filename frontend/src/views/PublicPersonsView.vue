<template>
  <div class="public-persons">
    <h1>Öffentliche Adressliste</h1>
    <p class="subtitle">Alle Personen, die der Weitergabe ihrer Daten zugestimmt haben.</p>
    
    <div v-if="loading" class="loading">
      Lade Daten...
    </div>
    
    <div v-else-if="sortedPersons.length === 0" class="empty">
      Keine Einträge vorhanden.
    </div>
    
    <div v-else class="table-wrapper">
      <table class="persons-table">
        <thead>
          <tr>
            <th @click="sort('vorname')">Vorname <span v-if="sortKey === 'vorname'" class="sort-icon">{{ sortDirection === 'asc' ? '▲' : '▼' }}</span></th>
            <th @click="sort('nachname')">Nachname <span v-if="sortKey === 'nachname'" class="sort-icon">{{ sortDirection === 'asc' ? '▲' : '▼' }}</span></th>
            <th @click="sort('gruppe')">Gruppe <span v-if="sortKey === 'gruppe'" class="sort-icon">{{ sortDirection === 'asc' ? '▲' : '▼' }}</span></th>
            <th @click="sort('adresse')">Adresse <span v-if="sortKey === 'adresse'" class="sort-icon">{{ sortDirection === 'asc' ? '▲' : '▼' }}</span></th>
            <th>Telefon</th>
            <th>Mobil</th>
            <th>E-Mail</th>
            <th @click="sort('erreichbarkeit')">Erreichbarkeit <span v-if="sortKey === 'erreichbarkeit'" class="sort-icon">{{ sortDirection === 'asc' ? '▲' : '▼' }}</span></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="person in sortedPersons" :key="person.id">
            <td>{{ person.vorname }}</td>
            <td>{{ person.nachname }}</td>
            <td>{{ person.gruppe }}</td>
            <td>{{ person.adresse }}, {{ person.plz }} {{ person.ort }}, {{ person.land }}</td>
            <td>{{ person.telefon_1 || '-' }}</td>
            <td>{{ person.mobil || '-' }}</td>
            <td>{{ person.email_1 || '-' }}</td>
            <td>{{ person.erreichbarkeit }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { getPublicPersons } from '../api/persons'
import type { PublicPerson } from '../api/persons'

const persons = ref<PublicPerson[]>([])
const loading = ref(true)
const sortKey = ref<string>('vorname')
const sortDirection = ref<'asc' | 'desc'>('asc')

const sortedPersons = computed(() => {
  const data = [...persons.value]
  const key = sortKey.value
  const dir = sortDirection.value === 'asc' ? 1 : -1
  
  data.sort((a, b) => {
    const aVal = (a as any)[key] || ''
    const bVal = (b as any)[key] || ''
    const cmp = String(aVal).localeCompare(String(bVal), 'de')
    return dir * cmp
  })
  
  return data
})

function sort(key: string) {
  if (sortKey.value === key) {
    sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortKey.value = key
    sortDirection.value = 'asc'
  }
}

onMounted(async () => {
  try {
    const response = await getPublicPersons()
    persons.value = response.data
  } catch (e) {
    console.error('Fehler beim Laden der öffentlichen Liste', e)
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.public-persons {
  max-width: 1400px;
  margin: 0 auto;
}

h1 {
  color: #2c3e50;
  margin-bottom: 0.5rem;
}

.subtitle {
  color: #666;
  margin-bottom: 2rem;
}

.loading, .empty {
  text-align: center;
  padding: 3rem;
  color: #666;
}

.table-wrapper {
  overflow-x: auto;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.persons-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.95rem;
}

.persons-table th,
.persons-table td {
  text-align: left;
  padding: 0.75rem 1rem;
  border-bottom: 1px solid #eee;
}

.persons-table th {
  background-color: #f8f9fa;
  font-weight: 600;
  color: #2c3e50;
  cursor: pointer;
  user-select: none;
  white-space: nowrap;
}

.persons-table th:hover {
  background-color: #e9ecef;
}

.persons-table tbody tr:hover {
  background-color: #f8f9fa;
}

.sort-icon {
  margin-left: 0.5rem;
  font-size: 0.8rem;
  color: #3498db;
}
</style>
