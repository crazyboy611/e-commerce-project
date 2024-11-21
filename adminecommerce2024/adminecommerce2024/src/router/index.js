import { createRouter, createWebHistory } from 'vue-router'


const routes = [
  {
    path: '/SignIn',
    name: 'SignIn',
    component: () => import(/* webpackChunkName: "about" */ '../views/SignIn.vue'),
  },
  {
    path: '/',
    name: 'Dashboard',
    component: () => import(/* webpackChunkName: "about" */ '../views/Dashboard.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/about',
    name: 'about',
    component: () => import(/* webpackChunkName: "about" */ '../views/AboutView.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/Shipment',
    name: 'Shipment',
    component: () => import(/* webpackChunkName: "about" */ '../views/Shipment.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/ManagerUser',
    name: 'ManagerUser',
    component: () => import(/* webpackChunkName: "about" */ '../views/ManagerUser.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/HistoryOrder',
    name: 'HistoryOrder',
    component: () => import(/* webpackChunkName: "about" */ '../views/HistoryOrder.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/HistoryOrderUser',
    name: 'HistoryOrderUser',
    component: () => import(/* webpackChunkName: "about" */ '../views/HistoryOrderUser.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/CommentsAndReviews',
    name: 'CommentsAndReviews',
    component: () => import(/* webpackChunkName: "about" */ '../views/CommentsAndReviews.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/ManagerNews',
    name: 'ManagerNews',
    component: () => import(/* webpackChunkName: "about" */ '../views/ManagerNews.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/ManagerNewsComments',
    name: 'ManagerNewsComments',
    component: () => import(/* webpackChunkName: "about" */ '../views/ManagerNewsComment.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/ManagerDiscountCode',
    name: 'ManagerDiscountCode',
    component: () => import(/* webpackChunkName: "about" */ '../views/ManagerDiscountCode.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/ManagerCategories',
    name: 'ManagerCategories',
    component: () => import(/* webpackChunkName: "about" */ '../views/ManagerCategories.vue'),
    meta: { requiresAuth: true } // Protected route
  },
  {
    path: '/ManagerProduct',
    name: 'ManagerProduct',
    component: () => import(/* webpackChunkName: "about" */ '../views/ManagerProduct.vue'),
    meta: { requiresAuth: true } // Protected route
  }

]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

// Navigation Guard to enforce sign-in
router.beforeEach((to, from, next) => {
  const isAuthenticated = !!sessionStorage.getItem('accessToken'); // Check if user is logged in

  if (to.matched.some(record => record.meta.requiresAuth)) {
    // If the route requires authentication and the user is not authenticated
    if (!isAuthenticated) {
      next({
        path: '/SignIn', // Redirect to SignIn page
        query: { redirect: to.fullPath } // Target route for redirection
      });
    } else {
      next(); // Allow access if authenticated
    }
  } else {
    next(); // Allow access if the route does not require authentication
  }
});


export default router