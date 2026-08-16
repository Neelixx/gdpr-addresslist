import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(localStorage.getItem('token'))
  const personId = ref<number | null>(parseInt(localStorage.getItem('personId') || '0') || null)
  const isAdmin = ref<boolean>(localStorage.getItem('isAdmin') === 'true')

  const isLoggedIn = computed(() => !!token.value)

  function setAuth(tokenValue: string, personIdValue: number, isAdminValue: boolean) {
    token.value = tokenValue
    personId.value = personIdValue
    isAdmin.value = isAdminValue
    localStorage.setItem('token', tokenValue)
    localStorage.setItem('personId', personIdValue.toString())
    localStorage.setItem('isAdmin', isAdminValue.toString())
  }

  function logout() {
    token.value = null
    personId.value = null
    isAdmin.value = false
    localStorage.removeItem('token')
    localStorage.removeItem('personId')
    localStorage.removeItem('isAdmin')
  }

  return { token, personId, isAdmin, isLoggedIn, setAuth, logout }
})
