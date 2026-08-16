import api from './client'

export interface MagicLinkRequest {
  email: string
}

export interface MagicLinkVerify {
  token: string
}

export interface LoginRequest {
  username: string
  password: string
}

export interface MagicLinkGenerateResponse {
  id: number
  name: string
  email: string
  magic_link: string
}

export const requestMagicLink = (data: MagicLinkRequest) => {
  return api.post('/auth/magic-link', data)
}

export const verifyMagicLink = (data: MagicLinkVerify) => {
  return api.post('/auth/verify', data)
}

export const login = (data: LoginRequest) => {
  return api.post('/auth/login', data)
}

export const createPerson = (data: any) => {
  return api.post('/admin/persons', data)
}

export const getAllPersons = () => {
  return api.get('/admin/persons')
}

export const importCSV = (file: File) => {
  const formData = new FormData()
  formData.append('file', file)
  return api.post('/admin/import', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export const backupDatabase = () => {
  return api.get('/admin/backup', { responseType: 'blob' })
}

export const restoreDatabase = (file: File) => {
  const formData = new FormData()
  formData.append('file', file)
  return api.post('/admin/restore', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export const exportAllData = () => {
  return api.get('/admin/export/all')
}

export const generateMagicLinks = (personIds: number[]) => {
  const formData = new FormData()
  personIds.forEach(id => formData.append('person_ids', id.toString()))
  return api.post('/admin/magic-links', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}
