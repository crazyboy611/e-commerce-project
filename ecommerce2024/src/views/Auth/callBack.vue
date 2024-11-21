<template>
    <div>
        <p>Redirecting, please wait...</p>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'GoogleCallback',
    async mounted() {
        const urlParams = new URLSearchParams(window.location.search);
        const code = urlParams.get('code');

        if (code) {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/users/oauth2/social/callback?code=${code}&login_type=google`);
                
                if (response.data && response.data.status === 200 && response.data.data.authenticated) {
                    const accessToken = response.data.data.access_token;
                    const fullName = response.data.data.user_full_name;

                    sessionStorage.setItem("accessToken", accessToken);
                    sessionStorage.setItem("fullName", fullName);
                    sessionStorage.setItem("loginType", 'google');
                    const redirect = this.$route.query.redirect || '/createPWUserGG';
                    this.$router.push(redirect);
                } else {
                    alert("Login failed! Please check your login details.");
                }
            } catch (error) {
                console.error('Error fetching user data:', error);
                this.$router.push('/login'); 
            }
        } else {
            console.error('No code parameter found in the URL');
            this.$router.push('/login');
        }
    }
};
</script>

<style scoped>
/* Add styles as needed */
</style>
