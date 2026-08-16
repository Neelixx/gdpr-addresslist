<template>
  <div class="privacy">
    <h1>Datenschutzerklärung</h1>
    <div class="privacy-content">
      <h2>{{ title }}</h2>
      <pre class="privacy-text">{{ content }}</pre>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { getPublicPrivacyPolicy } from '../api/admin'

const title = ref('')
const content = ref('')

onMounted(async () => {
  try {
    const response = await getPublicPrivacyPolicy()
    title.value = response.data.title
    content.value = response.data.content
  } catch (e) {
    console.error('Fehler beim Laden der Datenschutzerklärung', e)
  }
})
</script>

<style scoped>
.privacy {
  max-width: 800px;
  margin: 0 auto;
}

h1 {
  color: #2c3e50;
  margin-bottom: 2rem;
}

.privacy-content {
  background: white;
  padding: 2rem;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.privacy-content h2 {
  margin-bottom: 1rem;
  color: #2c3e50;
}

.privacy-text {
  white-space: pre-wrap;
  font-family: inherit;
  font-size: 1rem;
  line-height: 1.6;
  color: #555;
  margin: 0;
}
</style>
