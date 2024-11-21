<template>
    <div class="container-fuild bg-secondary">
        <div class="container p-3">
            <nav class="navbar navbar-expand-lg">
                <div class="container-fluid">
                    <a class="navbar-brand">
                        <router-link to="/"><img src="../ImageIcon/Logo.png" alt=""></router-link>
                    </a>
                    <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas"
                        data-bs-target="#offcanvasDarkNavbar" aria-controls="offcanvasDarkNavbar"
                        aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="offcanvas offcanvas-end text-bg-dark" tabindex="-1" id="offcanvasDarkNavbar"
                        aria-labelledby="offcanvasDarkNavbarLabel">
                        <div class="offcanvas-header">
                            <h5 class="offcanvas-title" id="offcanvasDarkNavbarLabel">
                                <a class="navbar-brand" href="#">
                                    <router-link to="/"><img src="../ImageIcon/Logo.png" alt=""></router-link>
                                </a>
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"
                                aria-label="Close"></button>
                        </div>
                        <div class="">
                            <div class="container-fuild">
                                <div class="navbar-collapse d-flex justify-content-between ms-5 container" id="">
                                    <div class="">
                                        <ul class="navbar-nav pe-3">
                                            <li class="nav-item">
                                                <a class="nav-link" aria-current="page"><router-link
                                                        to="/">Home</router-link></a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link"><router-link to="/newlist">News</router-link></a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link"><router-link
                                                        to="/ProductList">Product</router-link></a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" href="#"><router-link
                                                        to="/contact">Contact</router-link></a>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="me-5">
                                        <ul class="navbar-nav pe-3">
                                            <li class="nav-item">
                                                <a class="nav-link" href="#">
                                                    <router-link to="/ShoppingCartView/:product"><i
                                                            class="fa-solid fa-cart-shopping"></i></router-link>
                                                </a>
                                            </li>
                                            <li class="nav-item dropdown" v-if="!isAuthenticated">
                                                <a class="nav-link dropdown-toggle" href="#" role="button"
                                                    data-bs-toggle="dropdown" aria-expanded="false">
                                                    <i class="fa-solid fa-user"></i>
                                                </a>
                                                <ul class="dropdown-menu dropdown-menu-dark">
                                                    <li><a class="dropdown-item"><router-link
                                                                to="/Login">Login</router-link></a></li>
                                                    <li><a class="dropdown-item" href="#"><router-link
                                                                to="/Register">Register</router-link></a></li>
                                                </ul>
                                            </li>
                                            <li class="nav-item dropdown" v-else>
                                                <a class="nav-link dropdown-toggle" href="#" role="button"
                                                    data-bs-toggle="dropdown" aria-expanded="false">
                                                    {{ username }}
                                                </a>
                                                <ul class="dropdown-menu dropdown-menu-dark">
                                                    <li><a class="dropdown-item"><router-link
                                                                to="/Profile">Profile</router-link></a></li>
                                                    <li><a class="dropdown-item"><router-link
                                                                to="/PurchaseOrder">History
                                                                Order</router-link></a></li>
                                                    <li><a class="dropdown-item"><router-link
                                                                to="/ChangePassword">Change
                                                                Password</router-link></a></li>
                                                    <li><a class="dropdown-item" @click="logout"><i
                                                                class="fa-solid fa-right-from-bracket"></i></a></li>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </nav>
        </div>
    </div>
    <router-view />
</template>
<script>
export default {
    name: 'Navbar',
    data() {
        return {
            isAuthenticated: false,
            username: ''
        };
    },
    mounted() {
        this.checkAuthStatus();
    },
    methods: {
        // Check if the user is authenticated
        checkAuthStatus() {
            this.isAuthenticated = !!sessionStorage.getItem('accessToken'); // Check if session token exists
            this.username = sessionStorage.getItem('fullName'); // Retrieve username from sessionStorage
        },
        // Handle user logout
        logout() {
            sessionStorage.removeItem('accessToken'); // Remove user token from sessionStorage
            sessionStorage.removeItem('fullName'); // Remove username from sessionStorage
            sessionStorage.clear();
            this.isAuthenticated = false; // Update authentication state
            this.$router.push('/'); // Redirect to home after logout
        }
    },
    watch: {
        // Watch for route changes to update auth state
        $route() {
            this.checkAuthStatus();
        }
    }
};
</script>

<style scoped>
* {
    padding: 0;
    margin: 0;
    box-sizing: border-box;
}

a {
    text-decoration: none;
    font-size: 16px;
    color: white;
}

.navbar-collapse .nav-item {
    margin: 0 5px;
}

.navbar-collapse .nav-item .nav-link {
    font-weight: 700;
}


a:hover {
    cursor: pointer;
    color: #0e0d0d;
}
</style>
