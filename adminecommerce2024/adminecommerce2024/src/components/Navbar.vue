<template>
    <div class="navbar-content" v-if="isAuthenticated">
        <!-- Navbar -->

        <div class="mt-2">
            <nav class="navbar rounded navbar-expand-lg">
                <div class="container">
                    <!-- Toggle button only visible on small screens -->
                    <button class="navbar-toggler d-lg-none btn btn-light" data-bs-toggle="offcanvas"
                        data-bs-target="#offcanvasSidebar" aria-controls="offcanvasSidebar" aria-expanded="false"
                        aria-label="Toggle navigation">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <div class="d-flex align-item-center">
                        <div class="ms-5 search-bar">
                            <input type="text" name="search" v-model="searchQuery" placeholder="Search..."
                                @focus="hideIcon" @blur="showIcon" @input="showSuggestions">
                            <i class="fa-solid fa-magnifying-glass" v-if="showSearchIcon"></i>

                            <!-- Suggestions list -->
                            <ul v-if="filteredGroups.length > 0" class="suggestions-list">
                                <!-- Loop through filtered groups -->
                                <li v-for="group in filteredGroups" :key="group.name">
                                    <!-- Group name -->
                                    <div @click.prevent="!group.subItems || group.subItems.length === 0 ? navigateTo(group.link) : null"
                                        :class="{ 'disabled': group.subItems && group.subItems.length > 0 }"
                                        style="cursor: pointer;">
                                        <i :class="group.iconClass"></i> {{ group.name }}
                                    </div>

                                    <!-- SubItems (if any match) -->
                                    <ul v-if="group.subItems && group.subItems.length > 0">
                                        <li v-for="subItem in group.subItems" :key="subItem.name"
                                            @click.prevent="navigateTo(subItem.link)">
                                            <i class="fa-solid fa-arrow-right ms-3"></i> {{ subItem.name }}
                                        </li>
                                    </ul>
                                </li>
                            </ul>

                        </div>
                    </div>
                    <!-- User Profile Dropdown -->
                    <div class="dropdown">
                        <button class="btn  dropdown-toggle" type="button" id="profileDropdown"
                            data-bs-toggle="dropdown" aria-expanded="false">
                            <!-- <img src="https://via.placeholder.com/30" alt="Profile" class="rounded-circle"> -->
                            <span class="fw-bold">Admin</span>
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                            <!-- <li><a class="dropdown-item" href="#"><i class="fa-solid fa-user me-1"></i>Profile</a></li> -->
                            <li><a class="dropdown-item" href="#"><i class="fa-solid fa-gear me-1"></i>Settings</a></li>
                            <li><a class="dropdown-item" @click="logout"><i
                                        class="fa-solid fa-right-from-bracket me-1"></i>Logout</a></li>
                        </ul>
                    </div>
                </div>
            </nav>

        </div>
        <div class="d-flex">
            <!-- Offcanvas Sidebar - Hidden on larger screens, toggled on small screens -->
            <div class="offcanvas offcanvas-start d-lg-none rounded" tabindex="-1" id="offcanvasSidebar"
                aria-labelledby="offcanvasSidebarLabel" @click="hideNotifications">
                <div class="offcanvas-header mb-5">
                    <a class="offcanvas-title text-center" id="offcanvasSidebarLabel"><router-link
                            class="text-center fw-bold" to="/"><img :src="require('@/ImageLogo/Logo2.png')" width="100%"
                                alt="">Administration</router-link></a>

                    <div class="position-absolute top-0 end-0 m-3">
                        <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                    </div>
                </div>
                <div class="offcanvas-body">
                    <!-- Sidebar Items -->
                    <ul class="nav flex-column">
                        <li v-for="group in groups" :key="group.name" class="nav-item">
                            <!-- Check if the group has sub-items -->
                            <div v-if="group.subItems && group.subItems.length">
                                <a class="nav-link d-flex align-items-center dropdown-toggle" href="#"
                                    @click="toggleDropdown(group.name)">
                                    <i :class="group.iconClass"></i>
                                    <span>{{ group.name }}</span>
                                </a>
                                <!-- Display dropdown menu for sub-items -->
                                <ul class="dropdown-menu p-3" v-if="group.isDropdownOpen"
                                    style="position: static; display: block;">
                                    <li v-for="subItem in group.subItems" :key="subItem.name"
                                        class="list-group-item d-flex mb-2">
                                        <router-link :to="subItem.link"><span>{{ subItem.name }}</span></router-link>
                                    </li>
                                </ul>
                            </div>
                            <!-- For groups without sub-items -->
                            <div v-else>
                                <a class="nav-link d-flex align-items-center" href="#">
                                    <i :class="group.iconClass"></i>
                                    <router-link :to="group.link"><span>{{ group.name }}</span></router-link>
                                </a>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Sidebar always visible on larger screens -->
            <div class="d-none sidebar-lg d-lg-block rounded " @click="hideNotifications">
                <div class="p-3">
                    <div class="text-center mb-5">
                        <a class="offcanvas-title" id="offcanvasSidebarLabel">
                            <router-link class="text-center fw-bold" to="/"><img :src="require('@/ImageLogo/Logo2.png')"
                                    width="100%" alt="">
                                Administration
                            </router-link>

                        </a>
                    </div>
                    <ul class="nav flex-column">
                        <li v-for="group in groups" :key="group.name" class="nav-item">
                            <!-- Check if the group has sub-items -->
                            <div v-if="group.subItems && group.subItems.length">
                                <a class="nav-link d-flex align-items-center dropdown-toggle" href="#"
                                    @click="toggleDropdown(group.name)">
                                    <i :class="group.iconClass"></i>
                                    <span>{{ group.name }}</span>
                                </a>
                                <!-- Display dropdown menu for sub-items -->
                                <ul class="dropdown-menu p-3" v-if="group.isDropdownOpen"
                                    style="position: static; display: block;">
                                    <li v-for="subItem in group.subItems" :key="subItem.name"
                                        class="list-group-item d-flex mb-2">
                                        <router-link :to="subItem.link"><span>{{ subItem.name }}</span></router-link>
                                    </li>
                                </ul>
                            </div>
                            <!-- For groups without sub-items -->
                            <div v-else>
                                <a class="nav-link d-flex align-items-center" href="#">
                                    <i :class="group.iconClass"></i>
                                    <router-link :to="group.link"><span>{{ group.name }}</span></router-link>
                                </a>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="mt-5 content container" @click="hideNotifications; hideDropdown" :class="{ 'dimmed': showNotifications }">
                <div class="">
                    <router-view @click="hideNotifications" />
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'Navbar',
    data() {
        return {
            showDropdownProduct: false, // State for products dropdown
            showDropdownOrder: false, // State for orders dropdown
            showNotifications: false, // State for notifications
            notifications: [
                { message: 'New order received!' },
                { message: 'Product stock updated' },
                { message: 'New customer signed up' }
            ], // Example notifications
            isAuthenticated: false,
            username: '',
            searchQuery: "",
            showSearchIcon: true,
            filteredGroups: [], // This will hold the search results
            groups: [
                {
                    name: "DashBoard",
                    link: "/",
                    iconClass: "fa-solid fa-house me-2",
                    subItems: null
                },
                {
                    name: "Products",
                    iconClass: "fa-solid fa-list me-2",
                    isDropdownOpen: false,
                    subItems: [
                        { name: "Manager Products", link: "/ManagerProduct" },
                        { name: "Manager Categories", link: "/ManagerCategories" }
                    ]
                },
                {
                    name: "News",
                    iconClass: "fa-solid fa-newspaper me-2",
                    isDropdownOpen: false,
                    subItems: [
                        { name: "Manager News", link: "/ManagerNews" },
                        { name: "Manager Comment in News", link: "/ManagerNewsComments" }
                    ]
                },
                {
                    name: "Shipment",
                    link: "/Shipment",
                    iconClass: "fa-solid fa-truck me-2",
                    subItems: null
                },
                {
                    name: "ManagerUsers",
                    link: "/ManagerUser",
                    iconClass: "fa-solid fa-user me-2",
                    subItems: null
                },
                {
                    name: "Order",
                    iconClass: "fa-solid fa-receipt me-2",
                    isDropdownOpen: false,
                    subItems: [
                        { name: "History Orders", link: "/HistoryOrder" },
                        { name: "History Orders User", link: "/HistoryOrderUser" }
                    ]
                },
                {
                    name: "Comments And Reviews",
                    link: "/CommentsAndReviews",
                    iconClass: "fa-solid fa-star me-2",
                    subItems: null
                },
                {
                    name: "Discount Code",
                    link: "/ManagerDiscountCode",
                    iconClass: "fa-solid fa-hand-holding-dollar me-2",
                    subItems: null
                },
                
                {
                    name: "Manager Contact",
                    link: "/ManagerContact",
                    iconClass: "fa-regular fa-comment me-2",
                    subItems: null
                },
            ]
        };
    },
    mounted() {
        this.checkAuthStatus();
    },
    computed: {
        filteredGroups() {
            if (this.searchQuery.trim()) {
                const searchQuery = this.searchQuery.toLowerCase();

                return this.groups.reduce((acc, group) => {
                    // Check if the group name matches the search query
                    if (group.name.toLowerCase().includes(searchQuery)) {
                        acc.push({
                            ...group,
                            subItems: group.subItems ? [] : null, // Do not display subItems if searching by group name
                        });
                    }

                    // If group has subItems, check if any subItems match the search query
                    if (group.subItems && group.subItems.length) {
                        const matchedSubItems = group.subItems.filter(subItem =>
                            subItem.name.toLowerCase().includes(searchQuery)
                        );

                        if (matchedSubItems.length) {
                            // If subItems match, display the group with the matched subItems
                            acc.push({
                                ...group,
                                subItems: matchedSubItems
                            });
                        }
                    }

                    return acc;
                }, []);
            } else {
                return [];
            }
        }
    },
    methods: {
        toggleNotifications() {
            this.showNotifications = !this.showNotifications;
        },
        hideNotifications() {
            this.showNotifications = false;
        },

        toggleDropdownProduct() {
            this.showDropdownProduct = !this.showDropdownProduct;
            this.showDropdownOrder = false;
        },
        toggleDropdownOrder() {
            this.showDropdownOrder = !this.showDropdownOrder;
            this.showDropdownProduct = false;
        },
        toggleDropdown(groupName) {
            // Find the group in the list and toggle its dropdown
            this.groups = this.groups.map(group => {
                if (group.name === groupName) {
                    group.isDropdownOpen = !group.isDropdownOpen;
                }
                return group;
            });
        },
        hideDropdown() {
            this.showDropdownProduct = false; // Hide product dropdown
            this.showDropdownOrder = false; // Hide order dropdown
        },
        checkAuthStatus() {
            this.isAuthenticated = !!sessionStorage.getItem('accessToken'); // Check if token exists
        },
        // Handle user logout
        logout() {
            this.$emit('logout');
            this.$router.push('/SignIn');
        },
        hideIcon() {
            this.showSearchIcon = false;
        },
        showIcon() {
            this.showSearchIcon = true;
        },
        showSuggestions() {
            this.showSuggestionList = this.searchQuery.trim() !== "";
        },
        navigateTo(link) {
            // Kiểm tra xem link có tồn tại không
            if (link) {
                this.$router.push(link)
                    .then(() => {
                        // Xóa truy vấn tìm kiếm sau khi điều hướng thành công
                        this.searchQuery = "";
                        // Ẩn các gợi ý sau khi điều hướng thành công
                        this.showSuggestions();
                    })
                    .catch(err => {
                        console.error("Navigation error:", err); // Xử lý lỗi nếu có
                    });
            }
        }

    }
};
</script>


<style scoped>
a {
    text-decoration: none;
    color: black;
    font-size: 15px;

}

.navbar {
    background-color: #71b3f5;
}

.dropdown-menu {
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    border: none;
    cursor: pointer;
    background-color: rgb(248, 245, 245);
    margin-bottom: 10px;
}

/* Offcanvas Sidebar Styles */
.offcanvas {
    width: 250px;
    margin-top: 60px;
    /* Adjust to match navbar height */
    background-color: #71b3f5;
}

.sidebar-lg {
    width: 250px;
    margin-top: 60px;
    background-color: #71b3f5;
    /* Adjust to match navbar height */
}

.offcanvas-header,
.sidebar-lg h5 {
    align-items: center;
}

.nav-link {
    color: #000;
    padding: 10px 10px;
    display: block;
    border-radius: 10px;
}

.nav-link:hover {
    background-color: #e9ecef;
    border-radius: 20px;
    color: black;
}

.nav-link.active {
    background-color: #d9e9ff;
    color: #007bff;
}

button {
    border: none;
    outline-style: none;
}

.search-bar {
    position: relative;
    display: flex;
    align-items: center;
}

.navbar .search-bar input {
    border: none;
    border-radius: 20px;
    padding: 0.5rem 1rem;
    background-color: #e9ecef;
}

.search-bar i {
    position: absolute;
    right: 15px;
    font-weight: 800;
    font-size: 18px;
}

/* 
.search-bar i {
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
} */

.suggestions-list {
    list-style-type: none;
    padding: 0;
    margin-top: 5px;
    background-color: #fff;
    border: 1px solid #ccc;
    border-radius: 5px;
    position: absolute;
    top: 100%;
    width: 100%;
    z-index: 100;
}

.suggestions-list li {
    padding: 10px;
    cursor: pointer;
}

.suggestions-list li:hover {
    background-color: #f0f0f0;
}


.dimmed {
    opacity: 0.3;
    /* Applies to background content */
}

.notification-btn {
    background-color: transparent;
    border: none;
    position: relative;
}

.notification-btn .badge {
    position: absolute;
    top: -5px;
    right: -5px;
    background-color: red;
    color: white;
    padding: 5px 10px;
    font-size: 12px;
}

.notification-list {
    position: absolute;
    top: 70%;
    left: 20%;
    width: 300px;
    max-height: 200px;
    background-color: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    overflow-y: auto;
    z-index: 1050;
}

.notification-item {
    padding: 10px;
    border-bottom: 1px solid #f1f1f1;
    font-size: 14px;
    color: #333;
}

.notification-item:last-child {
    border-bottom: none;
}

.notification-item:hover {
    background-color: #f8f9fa;
}

ul {
    padding: 10px 0 0 10px;
}

li {
    list-style-type: none;
}

.disabled {
    color: gray;
    /* Màu sắc mờ cho tên nhóm */
    pointer-events: none;
    /* Ngăn chặn các sự kiện chuột */
}
@media only screen and (max-width: 768px) {
    .content {
    padding: 0 10%;
}
}
.navbar-content {
    background-color: #f8f9fa;
}

.navbar {
    background-color: #ffffff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.notification-btn {
    background-color: transparent;
    border: none;
    color: #000;
}


.notification-item {
    padding: 8px;
    border-bottom: 1px solid #e9ecef;
}

.notification-item:last-child {
    border-bottom: none;
}

.search-bar {
    position: relative;
    display: flex;
    align-items: center;
}

.search-bar input[type="text"] {
    border: 1px solid #ced4da;
    border-radius: 8px;
    padding: 8px 12px;
    width: 300px;
}

.search-bar i {
    position: absolute;
    right: 10px;
    color: #6c757d;
}

.suggestions-list {
    position: absolute;
    top: 100%;
    left: 0;
    background-color: #ffffff;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    width: 100%;
    border-radius: 8px;
    z-index: 10;
    margin-top: 4px;
    list-style-type: none;
    padding: 0;
}

.suggestions-list li {
    padding: 8px;
    cursor: pointer;
}

.suggestions-list li:hover {
    background-color: #e9ecef;
}

.dropdown-menu {
    border-radius: 8px;
}

.offcanvas-start {
    background-color: #ffffff;
}

.sidebar-lg {
    width: 250px;
    background-color: #ffffff;
    box-shadow: 2px 0 4px rgba(0, 0, 0, 0.1);
}

.sidebar-lg .nav-link {
    color: #495057;
    padding: 10px 16px;
    display: flex;
    align-items: center;
    font-weight: 500;
    text-decoration: none;
}

.sidebar-lg .nav-link:hover {
    background-color: #e9ecef;
    border-radius: 8px;
}

.nav-link .fa-arrow-right {
    font-size: 0.75rem;
}

.dropdown-toggle::after {
    margin-left: auto;
}

.dropdown-toggle[aria-expanded="true"]::after {
    transform: rotate(180deg);
}

.content {
    margin: 0 auto;
    flex: 1;
}

.content.dimmed {
    opacity: 0.5;
}
</style>