<template>
    <div class="container-fuild">
        <navbar />
    </div>
    <div class="container-fuild">
        <FooterPage />
    </div>
</template>
<script>
import navbar from './components/Navbar.vue';
import FooterPage from './components/FooterPage.vue';
export default {
    components: {
        navbar,
        FooterPage
    },
    methods: {
        async checkToken() {
            try {
                const token = sessionStorage.getItem('accessToken');
                if (!token) {
                    alert('You are not logged in. Redirecting to login page...');
                    this.$router.push('/Login');
                    return;
                }

                const response = await axios.post(`http://localhost:8080/api/v1/users/introspect`, {
                    token: token
                });

                if (!response.data.authenticated) {
                    sessionStorage.removeItem('accessToken');
                    sessionStorage.removeItem('fullName');
                    sessionStorage.clear();
                    alert('Session expired. Please log in again.');
                    this.$router.push('/Login');
                }
            } catch (error) {
                console.error('Error during token validation:', error);
                alert('An error occurred while validating your session. Please log in again.');
                sessionStorage.clear();
                this.$router.push('/Login');
            }
        }
    },
    beforeMount() {
        this.checkToken();
    }
}
</script>
<style>
a {
    text-decoration: none;
}
</style>