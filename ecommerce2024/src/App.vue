<template>
    <div class="container-fuild">
        <navbar :totalItems="totalItems" />
        <router-view @update-total-items="updateTotalItems" />
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
    data() {
        return {
            totalItems: 0
        };
    },
    methods: {
        updateTotalItems(total) {
            this.totalItems = total;
        }
    }
}
</script>
<style>
a {
    text-decoration: none;
}
</style>