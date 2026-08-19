import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import LoginView from '../views/LoginView.vue'
import DashboardView from '../views/DashboardView.vue'
import PrivacyPolicyView from '../views/PrivacyPolicyView.vue'
import AdminView from '../views/AdminView.vue'
import PublicPersonsView from '../views/PublicPersonsView.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', name: 'home', component: HomeView },
    { path: '/login', name: 'login', component: LoginView },
    { path: '/meine-daten', name: 'meine-daten', component: DashboardView, meta: { requiresAuth: true } },
    { path: '/privacy', name: 'privacy', component: PrivacyPolicyView },
    { path: '/auth/verify', name: 'verify', component: LoginView },
    { path: '/admin', name: 'admin', component: AdminView, meta: { requiresAuth: true, requiresAdmin: true } },
    { path: '/persons', name: 'persons', component: PublicPersonsView, meta: { requiresAuth: true } }
  ]
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const isAdmin = localStorage.getItem('isAdmin') === 'true'
  
  if (to.meta.requiresAuth && !token) {
    next('/login')
  } else if (to.meta.requiresAdmin && !isAdmin) {
    next('/meine-daten')
  } else {
    next()
  }
})

export default router
