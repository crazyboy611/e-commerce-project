<template>
  <div>
    <Navbar v-if="isAuthenticated" @logout="handleLogout" />
    <SignIn v-else />
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import Navbar from '@/components/Navbar.vue';
import SignIn from '@/views/SignIn.vue';

export default {
  components: {
    Navbar,
    SignIn,
  },
  setup() {
    const isAuthenticated = ref(false);

    const checkAuthentication = () => {
      isAuthenticated.value = !!sessionStorage.getItem('accessToken');
    };

    const handleLogout = () => {
      sessionStorage.removeItem('accessToken');
      isAuthenticated.value = false;
    };

    onMounted(checkAuthentication);

    return {
      isAuthenticated,
      handleLogout,
    };
  }
};
</script>

<style scoped>
/* Add any relevant styles if necessary */
</style>
