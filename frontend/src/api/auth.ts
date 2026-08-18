import api from './client'

export interface MagicLinkRequest {
  email: string
  hcaptcha_token: string
}

export interface MagicLinkVerify {
  token: string
}

export interface LoginRequest {
  username: string
  password: string
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
