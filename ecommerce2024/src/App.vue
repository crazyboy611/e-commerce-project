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
import ProductModal from './components/ProductModal.vue';
export default {
    components: {
        navbar,
        FooterPage
    }
}
</script>
<style>
    a{
        text-decoration: none;
    }
</style>