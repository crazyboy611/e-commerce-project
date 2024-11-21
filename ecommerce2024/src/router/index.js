import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import ProductList from '../views/ProductList.vue'
import DetailProduct from '../components/DetailProduct.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView,
    props: true
  },
  {
    path: '/about',
    name: 'about',
    component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue')
  },
  {
    path: '/ProductList',
    name: 'ProductList',
    component: () => import(/* webpackChunkName: "ProductList" */ '../views/ProductList.vue'),
    props: true
  },
  {
    path: '/detail/:product',
    name: 'DetailProduct',
    component: DetailProduct,
    props: true,
  },
  {
    path: '/ShoppingCartView/:product',
    name: 'ShoppingCartView',
    component: () => import(/* webpackChunkName: "ShoppingCart" */ '../views/ShoppingCart.vue'),
    meta: { requiresAuth: true },
    props: true
  },
  {
    path: '/Checkout/:product',
    name: 'Checkout',
    component: () => import(/* webpackChunkName: "Checkout" */ '../views/Checkout.vue'),
    meta: { requiresAuth: true },
    props: true
  },
  {
    path: '/contact',
    name: 'contact',
    component: () => import(/* webpackChunkName: "contact" */ '../views/Contact.vue')
  },
  {
    path: '/Login',
    name: 'Login',
    component: () => import(/* webpackChunkName: "Login" */ '../views/Auth/Login.vue')
  },
  {
    path: '/Register',
    name: 'Register',
    component: () => import(/* webpackChunkName: "Register" */ '../views/Auth/Register.vue')
  },
  {
    path: '/Profile',
    name: 'Profile',
    component: () => import(/* webpackChunkName: "Register" */ '../views/Auth/Profile.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/ForgotPassword',
    name: 'ForgotPassword',
    component: () => import(/* webpackChunkName: "ForgotPassword" */ '../views/Auth/ForgotPassword.vue'),
  },
  {
    path: '/ChangePassword',
    name: 'ChangePassword',
    component: () => import(/* webpackChunkName: "ProductList" */ '../views/Auth/ChangePw.vue'),
    props: true,
    meta: { requiresAuth: true }
  },
  {
    path: '/PurchaseOrder',
    name: 'PurchaseOrder',
    component: () => import(/* webpackChunkName: "ProductList" */ '../components/PurchaseOrder.vue'),
    meta: { requiresAuth: true }
  },
  {
    path: '/newlist',
    name: 'newlist',
    component: () => import(/* webpackChunkName: "ProductList" */ '../views/NewListView.vue'),
  },
  {
    path: '/news/:id',
    name: 'NewsDetail',
    component: () => import(/* webpackChunkName: "ProductList" */ '../components/DetailNew.vue'),
    props: true
  },
  {
    path: '/reset_password',
    name: 'reset_password',
    component: () => import(/* webpackChunkName: "ProductList" */ '../views/Auth/AuthResetPW.vue'),
  },
  {
    path: '/auth/google/callback',
    name: 'GoogleCallback',
    component: () => import(/* webpackChunkName: "ProductList" */ '../views/Auth/callBack.vue'),
  },
  {
    path: '/createPWUserGG',
    name: 'createPWUserGG',
    component: () => import(/* webpackChunkName: "ProductList" */ '../views/Auth/createPWUserGG.vue'),
  },
  {
    path: '/TransferVNPay',
    name: 'TransferVNPay',
    component: () => import(/* webpackChunkName: "ProductList" */ '../views/TransferVNPay.vue'),
  },
  {
    path: '/orders/checkout/vn-pay/callback',
    name: 'TransferVNPayCallBack',
    component: () => import(/* webpackChunkName: "ProductList" */ '../views/TransferVNPayCallBack.vue'),
  },
  {
    path: '/ProductListCategory',
    name: 'ProductListCategory',
    component: () => import(/* webpackChunkName: "ProductList" */ '../views/ProductListCategory.vue'),
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

// Navigation Guard
router.beforeEach((to, from, next) => {
  const isAuthenticated = !!sessionStorage.getItem('accessToken'); // Check if the user is logged in

  if (to.matched.some(record => record.meta.requiresAuth)) {
    // If the route requires authentication and the user is not authenticated
    if (!isAuthenticated) {
      next({
        path: '/Login',
        query: { redirect: to.fullPath } // Redirect to the sign-up page with the target route
      });
    } else {
      next(); // Allow access if authenticated
    }
  } else {
    next(); // Allow access if the route does not require authentication
  }
})

export default router;
