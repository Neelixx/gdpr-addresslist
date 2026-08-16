import api from './client'

export interface Group {
  id: number
  name: string
  created_at: string
}

export const getGroups = () => {
  return api.get('/groups/')
}

export const createGroup = (name: string) => {
  return api.post('/groups/', { name })
}

export const updateGroup = (id: number, name: string) => {
  return api.put(`/groups/${id}`, { name })
}

export const deleteGroup = (id: number) => {
  return api.delete(`/groups/${id}`)
}
