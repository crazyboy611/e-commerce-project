import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import bootstrap from 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import EventBus from './EventBus'

createApp(App).use(router).use(bootstrap).use(EventBus).mount('#app')
