<template>
  <div class="consent-manager">
    <h3>Einwilligungen verwalten</h3>
    <div class="consent-item">
      <label>
        <input type="checkbox" :checked="person.consent_storage" @change="updateConsent('consent_storage', $event)" />
        <span>Zustimmung zur Speicherung der Daten</span>
      </label>
    </div>
    <div class="consent-item">
      <label>
        <input type="checkbox" :checked="person.consent_sharing" @change="updateConsent('consent_sharing', $event)" />
        <span>Zustimmung, dass Daten für andere Nutzer sichtbar sind</span>
      </label>
    </div>
    <div class="consent-item">
      <label>
        <input type="checkbox" :checked="person.consent_photos" @change="updateConsent('consent_photos', $event)" />
        <span>Zustimmung zum Teilen von Fotos</span>
      </label>
    </div>
    <p v-if="message" class="message">{{ message }}</p>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import type { Person } from '../api/persons'
import { updateMyData } from '../api/persons'

const props = defineProps<{
  person: Person
}>()

const emit = defineEmits(['updated'])
const message = ref('')

async function updateConsent(field: string, event: Event) {
  const target = event.target as HTMLInputElement
  message.value = 'Speichern...'
  try {
    await updateMyData({ [field]: target.checked })
    message.value = 'Gespeichert!'
    emit('updated')
    setTimeout(() => { message.value = '' }, 2000)
  } catch (e) {
    message.value = 'Fehler beim Speichern'
  }
}
</script>

<style scoped>
.consent-manager h3 {
  margin-bottom: 1rem;
  color: #2c3e50;
}

.consent-item {
  margin-bottom: 1rem;
}

.consent-item label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
}

.consent-item input[type="checkbox"] {
  width: auto;
}

.message {
  margin-top: 1rem;
  padding: 0.5rem;
  border-radius: 4px;
  color: #27ae60;
  font-size: 0.9rem;
}
</style>
