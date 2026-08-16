import api from './client'

export interface Person {
  id: number
  gruppe: string
  vorname: string
  nachname: string
  geburtsname?: string
  adresse?: string
  land?: string
  ort?: string
  plz?: string
  telefon_1?: string
  telefon_2?: string
  mobil?: string
  erreichbarkeit: string
  email_1?: string
  email_2?: string
  username?: string
  admin: boolean
  notizen?: string
  consent_storage: boolean
  consent_sharing: boolean
  consent_photos: boolean
  is_deleted: boolean | null
  is_blocked: boolean | null
  created_at: string
  updated_at?: string
}

export interface PublicPerson {
  id: number
  gruppe: string
  vorname: string
  nachname: string
  adresse?: string
  land?: string
  ort?: string
  plz?: string
  telefon_1?: string
  telefon_2?: string
  mobil?: string
  erreichbarkeit: string
  email_1?: string
  email_2?: string
  admin: boolean
  consent_sharing: boolean
}

export const getMyData = () => {
  return api.get('/persons/me')
}

export const updateMyData = (data: Partial<Person>) => {
  return api.put('/persons/me', data)
}

export const deleteMyData = () => {
  return api.delete('/persons/me')
}

export const exportData = () => {
  return api.get('/persons/export')
}

export const getPublicPersons = () => {
  return api.get('/persons/')
}

export const changePassword = (password: string) => {
  return api.post('/persons/me/password', { password })
}
