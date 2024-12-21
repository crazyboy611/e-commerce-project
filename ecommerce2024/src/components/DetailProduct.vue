<template>
    <div v-if="nameCategory == 'Điện thoại'" class="container">
        <div class="detail-content my-5 d-flex  flex-wrap justify-content-between">
            <div class="img d-flex">
                <div class="image-product" v-if="parsedProduct.thumbnail">
                    <img :src="`http://localhost:8080/api/v1/products/images/${parsedProduct.thumbnail}`"
                        @error="setDefailtImage" width="413px" alt="vcbcvc">
                </div>
                <div class="img-select">
                    <div class="img-select d-flex mt-3" v-for="(image, id) in parsedProduct.product_images" :key="id">
                        <img :src="`http://localhost:8080/api/v1/products/images/${image.image_url}`"
                            @click="selectImage(image.image_url)" class="thumbnail-image me-2" width="70px"
                            alt="Thumbnail">
                    </div>
                </div>
            </div>
            <div class="content ms-5 mt-3">
                <h2>{{ parsedProduct.name }}</h2>
                <p class="fs-1 fw-bold text-danger">{{ currencyFormat(parsedProduct.price) }}</p>
                <div class=" mt-3 mb-2">
                    <p class="">{{ parsedProduct.description }}</p>
                </div>
                <div>
                    <div class="memory-detail d-flex align-item-center justify-content-center">
                        <div class="detail">
                            <p><i class="fas fa-mobile-alt"></i> Screen size</p>
                            <h5 class="fw-bold text-center">{{ getAttributeValue("mobile_screen_size") }}"</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-microchip"></i> CPU</p>
                            <h5 class="fw-bold text-center">{{ getAttributeValue("mobile_cpu") }}</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-memory"></i> RAM</p>
                            <!-- <h5 class="fw-bold text-center">{{ getAttributeValue("mobile_ram") }}</h5> -->
                            <h5 v-if='getAttributeValue("mobile_ram") >= 0' class="fw-bold text-center">{{
                                getAttributeValue("mobile_ram") }} GB</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-battery-full"></i> Battery Capacity</p>
                            <h5 class="fw-bold text-center">{{ getAttributeValue("mobile_battery_capacity") }} mAh</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-building"></i> Os</p>
                            <h5 class="fw-bold text-center">{{ getAttributeValue("mobile_os") }}</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-database"></i> Storage</p>
                            <h5 v-if='getAttributeValue("mobile_storage") < 1000' class="fw-bold text-center">{{
                                getAttributeValue("mobile_storage") }} Gb</h5>
                            <h5 v-else-if='getAttributeValue("mobile_storage") > 1000' class="fw-bold text-center">{{
                                getAttributeValue("mobile_storage") }} Tb</h5>
                        </div>
                    </div>
                </div>
                <div class="text-center my-3">
                    <router-link :to="{ name: 'ShoppingCartView', params: { product: JSON.stringify(parsedProduct) } }">
                        <button class="btn btn-outline-dark me-1 my-1">Add to shopping
                            Cart</button>
                    </router-link>
                    <router-link :to="{ name: 'Checkout', params: { product: JSON.stringify(parsedProduct) } }">
                        <button class="btn btn-dark px-5 my-1" @click="purchaseProduct">Purchase</button>
                    </router-link>
                </div>
                <div class="quanlity d-flex justify-content-evenly">
                    <div class="d-flex align-item-center me-1">
                        <div class="me-1">
                            <i class="fa-solid fa-truck-fast fs-3"></i>
                        </div>
                        <div class="fw-bold">
                            <p class="">Free Delivery</p>
                            <span class="fw-bold text-dark">1-2 day</span>
                        </div>
                    </div>
                    <div class="d-flex align-item-center me-1">
                        <div class="me-2">
                            <i class="fa-solid fa-ranking-star fs-3"></i>
                        </div>
                        <div class="fw-bold">
                            <p>Quanlity</p>
                        </div>
                    </div>
                    <div class="d-flex align-item-center">
                        <div class="me-2">
                            <i class="fa-solid fa-award fs-3"></i>
                        </div>
                        <div class="fw-bold">
                            <p>Guaranteed</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="detail-product container mt-5">
            <h1>Details</h1>
            <p>
                {{ parsedProduct.descriptionDetail }}
            </p>
            <div class="list-group list-group-flush">
                <div class="list-group-item" v-for="(attribute, index) in parsedProduct.attributes.slice(0, 4)"
                    :key="index">
                    <h3>{{ formatAttributeNameMobile(attribute.name) }}</h3>
                    <div class="d-flex justify-content-between">
                        <p>{{ attribute.name.replace(/_/g, ' ') }}</p>
                        <p class="fw-bold">{{ attribute.value }}</p>
                    </div>
                </div>
            </div>
            <div class="detail-collapse mb-3 text-center" v-if="parsedProduct.attributes.length > 4">
                <div class="collapse" id="collapseExample">
                    <div class="container text-start">
                        <div class="list-group list-group-flush">
                            <div v-for="(attribute, index) in parsedProduct.attributes.slice(4)" :key="index + 4"
                                class="list-group-item">
                                <h3>{{ formatAttributeNameMobile(attribute.name) }}</h3>
                                <div class="d-flex justify-content-between">
                                    <p>{{ attribute.name.replace(/_/g, ' ') }}</p>
                                    <p class="fw-bold">{{ attribute.value }}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <p class="d-inline-flex gap-1">
                    <a class="text-secondary" data-bs-toggle="collapse" href="#collapseExample" role="button"
                        aria-expanded="false" aria-controls="collapseExample" @click="toggleCollapse">
                        View more
                        <i :class="collapsed ? 'fa-chevron-down' : 'fa-chevron-up'" class="fa-solid"></i>
                    </a>
                </p>
            </div>
        </div>
        <div class="reviews my-5" id="reviews-product">
            <div class="container mt-5">
                <div v-if="isReviewsProduct == 'true'">
                    <h3>Reviews</h3>
                    <div class="text-center review-section d-flex justify-content-evenly flex-wrap">
                        <div class="number-star text-center my-3">
                            <h1 id="average-rating" class="average-rating">{{ averageRating }}</h1>
                            <div id="static-stars" class="static-stars">
                                <i v-for="i in 5" :key="i" class="fa-solid fa-star"
                                    :class="{ 'text-warning': i <= averageRating }"></i>
                            </div>
                        </div>

                        <div class="comment-user">
                            <p class="fs-4 text-secondary review-prompt">Leave comments and reviews for product</p>
                            <div class="text-center">
                                <form @submit.prevent="submitReview" class="review-form">
                                    <input type="text" placeholder="Comment" v-model="comment"
                                        class="form-control comment-input">
                                    <div id="review-stars" class="review-stars my-4">
                                        <i v-for="(star, index) in 5" :key="index" :class="getStarClass(index)"
                                            @click="setRating(index)" @mouseover="handleHover(index)"
                                            @mouseleave="resetHover"></i>
                                    </div>
                                    <button type="submit" class="btn btn-danger submit-btn">Submit Review</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="comment-user2 my-5">
                    <h2>Comment and Review</h2>
                    <div class="user1 d-flex mt-5" v-for="(comment, index) in allComments" :key="index">
                        <div>
                            <div class="">
                                <p class="fw-bold fs-4">{{ comment.user_full_name }}</p>
                                <p class="text-secondary">{{ formatDate(comment.created_at.split("T")[0]) }}</p>
                            </div>
                            <p class="text-secondary">{{ comment.comment }}</p>
                        </div>
                    </div>
                    <div class="pagination mt-4">
                        <button :disabled="currentPage === 1" @click="changePage(currentPage - 1)">
                            <i class="fa-solid fa-chevron-left"></i>
                        </button>
                        <span>Page {{ currentPage }} of {{ totalPages }}</span>
                        <button :disabled="currentPage === totalPages" @click="changePage(currentPage + 1)">
                            <i class="fa-solid fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div v-if="nameCategory == 'Laptop'" class="container">
        <div class="detail-content my-5 d-flex  flex-wrap justify-content-between">
            <div class="img d-flex">
                <div class="image-product" v-if="parsedProduct.thumbnail">
                    <img :src="`http://localhost:8080/api/v1/products/images/${parsedProduct.thumbnail}`"
                        @error="setDefailtImage" width="413px" alt="vcbcvc">
                </div>
                <div class="img-select">
                    <div class="img-select d-flex mt-3" v-for="(image, id) in parsedProduct.product_images" :key="id">
                        <img :src="`http://localhost:8080/api/v1/products/images/${image.image_url}`"
                            @click="selectImage(image.image_url)" class="thumbnail-image me-2" width="70px"
                            alt="Thumbnail">
                    </div>
                </div>
            </div>
            <div class="content ms-5 mt-3">
                <h2>{{ parsedProduct.name }}</h2>
                <p class="fs-1 fw-bold text-danger">{{ currencyFormat(parsedProduct.price) }}</p>
                <div class=" mt-3 mb-2">
                    <p class="">{{ parsedProduct.description }}</p>
                </div>
                <div>
                    <div class="memory-detail d-flex align-item-center justify-content-center">
                        <div class="detail">
                            <p><i class="fas fa-mobile-alt"></i> Screen size</p>
                            <h5 class="fw-bold text-center">{{ getAttributeValue("laptop_screen_size") }}"</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-microchip"></i> CPU</p>
                            <h5 class="fw-bold text-center">{{ getAttributeValue("laptop_cpu") }}</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-memory"></i> RAM</p>
                            <!-- <h5 class="fw-bold text-center">{{ getAttributeValue("mobile_ram") }}</h5> -->
                            <h5 v-if='getAttributeValue("laptop_ram") >= 0' class="fw-bold text-center">{{
                                getAttributeValue("laptop_ram") }} GB</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-battery-full"></i> Battery Capacity</p>
                            <h5 class="fw-bold text-center">{{ getAttributeValue("laptop_battery_capacity") }} mAh</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-building"></i> Os</p>
                            <h5 class="fw-bold text-center">{{ getAttributeValue("laptop_os") }}</h5>
                        </div>
                        <div class="detail">
                            <p><i class="fa-solid fa-database"></i> Storage</p>
                            <h5 v-if='getAttributeValue("laptop_storage") < 1000' class="fw-bold text-center">{{
                                getAttributeValue("laptop_storage") }} Gb</h5>
                            <h5 v-else-if='getAttributeValue("laptop_storage") > 1000' class="fw-bold text-center">{{
                                getAttributeValue("laptop_storage") }} Tb</h5>
                        </div>
                    </div>
                </div>
                <div class="text-center my-3">
                    <router-link :to="{ name: 'ShoppingCartView', params: { product: JSON.stringify(parsedProduct) } }">
                        <button class="btn btn-outline-dark me-1 my-1">Add to shopping
                            Cart</button>
                    </router-link>
                    <router-link :to="{ name: 'Checkout', params: { product: JSON.stringify(parsedProduct) } }">
                        <button class="btn btn-dark px-5 my-1" @click="purchaseProduct">Purchase</button>
                    </router-link>
                </div>
                <div class="quanlity d-flex justify-content-evenly">
                    <div class="d-flex align-item-center me-1">
                        <div class="me-1">
                            <i class="fa-solid fa-truck-fast fs-3"></i>
                        </div>
                        <div class="fw-bold">
                            <p class="">Free Delivery</p>
                            <span class="fw-bold text-dark">1-2 day</span>
                        </div>
                    </div>
                    <div class="d-flex align-item-center me-1">
                        <div class="me-2">
                            <i class="fa-solid fa-ranking-star fs-3"></i>
                        </div>
                        <div class="fw-bold">
                            <p>Quanlity</p>
                        </div>
                    </div>
                    <div class="d-flex align-item-center">
                        <div class="me-2">
                            <i class="fa-solid fa-award fs-3"></i>
                        </div>
                        <div class="fw-bold">
                            <p>Guaranteed</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="detail-product container mt-5">
            <h1>Details</h1>
            <p>
                {{ parsedProduct.descriptionDetail }}
            </p>
            <div class="list-group list-group-flush">
                <div class="list-group-item" v-for="(attribute, index) in parsedProduct.attributes.slice(0, 4)"
                    :key="index">
                    <h3>{{ formatAttributeNameLaptop(attribute.name) }}</h3>
                    <div class="d-flex justify-content-between">
                        <p>{{ attribute.name.replace(/_/g, ' ') }}</p>
                        <p class="fw-bold">{{ attribute.value }}</p>
                    </div>
                </div>
            </div>
            <div class="detail-collapse mb-3 text-center" v-if="parsedProduct.attributes.length > 4">
                <div class="collapse" id="collapseExample">
                    <div class="container text-start">
                        <div class="list-group list-group-flush">
                            <div v-for="(attribute, index) in parsedProduct.attributes.slice(4)" :key="index + 4"
                                class="list-group-item">
                                <h3>{{ formatAttributeNameLaptop(attribute.name) }}</h3>
                                <div class="d-flex justify-content-between">
                                    <p>{{ attribute.name.replace(/_/g, ' ') }}</p>
                                    <p class="fw-bold">{{ attribute.value }}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <p class="d-inline-flex gap-1">
                    <a class="text-secondary" data-bs-toggle="collapse" href="#collapseExample" role="button"
                        aria-expanded="false" aria-controls="collapseExample" @click="toggleCollapse">
                        View more
                        <i :class="collapsed ? 'fa-chevron-down' : 'fa-chevron-up'" class="fa-solid"></i>
                    </a>
                </p>
            </div>
        </div>
        <div class="reviews my-5" id="reviews-product">
            <div class="container mt-5">
                <div v-if="isReviewsProduct == true">
                    <h3>Reviews</h3>
                    <div class="text-center review-section d-flex justify-content-evenly flex-wrap">
                        <div class="number-star text-center my-3">
                            <h1 id="average-rating" class="average-rating">{{ averageRating }}</h1>
                            <div id="static-stars" class="static-stars">
                                <i v-for="i in 5" :key="i" class="fa-solid fa-star"
                                    :class="{ 'text-warning': i <= averageRating }"></i>
                            </div>
                        </div>

                        <!-- Comment & Review Form Section -->
                        <div class="comment-user">
                            <p class="fs-4 text-secondary review-prompt">Leave comments and reviews for product</p>
                            <div class="text-center">
                                <form @submit.prevent="submitReview" class="review-form">
                                    <input type="text" placeholder="Comment" v-model="comment"
                                        class="form-control comment-input">
                                    <div id="review-stars" class="review-stars my-4">
                                        <i v-for="(star, index) in 5" :key="index" :class="getStarClass(index)"
                                            @click="setRating(index)" @mouseover="handleHover(index)"
                                            @mouseleave="resetHover"></i>
                                    </div>
                                    <button type="submit" class="btn btn-danger submit-btn">Submit Review</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="comment-user2 my-5">
                    <h2>Comment and Review</h2>
                    <div class="user1 d-flex mt-5" v-for="(comment, index) in allComments" :key="index">
                        <div>
                            <div class="">
                                <p class="fw-bold fs-4">{{ comment.user_full_name }}</p>
                                <p class="text-secondary">{{ formatDate(comment.created_at.split("T")[0]) }}</p>
                            </div>
                            <p class="text-secondary">{{ comment.comment }}</p>
                        </div>
                    </div>
                    <div class="pagination mt-4">
                        <button :disabled="currentPage === 1" @click="changePage(currentPage - 1)">
                            <i class="fa-solid fa-chevron-left"></i>
                        </button>
                        <span>Page {{ currentPage }} of {{ totalPages }}</span>
                        <button :disabled="currentPage === totalPages" @click="changePage(currentPage + 1)">
                            <i class="fa-solid fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <section class="section-6 my-5">
        <div class="container">
            <h3> <span class="text-danger">Hot Products</span></h3>
            <div class="row my-5">
                <div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-3" v-for="(product, index) in discountProducts"
                    :key="index">
                    <router-link :to="{ name: 'DetailProduct', params: { product: product.id } }" style="text-decoration: none;">
                        <div class="card h-100 d-flex flex-column">
                            <div class="card-body d-flex flex-column">
                                <router-link class="text-end"
                                    :to="{ name: 'ShoppingCartView', params: { product: JSON.stringify(product) } }"> <i
                                        class="fa-solid fa-cart-shopping text-end fs-5"></i></router-link>
                                <img :src="`http://localhost:8080/api/v1/products/images/${product.thumbnail}`"
                                    class="img-fluid card-img-top p-5" :alt="product.name">
                                <h3 class="card-title mb-2 text-center">{{ product.name }}</h3>
                                <p class="card-text text-center">{{ product.description }}</p>
                                <p class="card-text text-center text-muted">{{ product.category_name }}</p>
                                <p class="card-text text-center"><strong>{{ currencyFormat(product.price) }}</strong>
                                </p>
                                <div class="my-2 mt-3 text-center">
                                    <!-- Pass product data via route params -->
                                    <router-link
                                        :to="{ name: 'Checkout', params: { product: JSON.stringify(product) } }">
                                        <button class="btn btn-dark px-5 my-1"
                                            @click="purchaseProductDiscount(product)">Purchase</button>
                                    </router-link>
                                </div>
                            </div>
                        </div>
                    </router-link>
                </div>
            </div>
        </div>
    </section>
</template>



<script>
import axios from 'axios';

export default {
    name: 'DetailProduct',
    props: {
        product: {
            type: String,
            required: true
        },
        parsedProduct: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            discountProducts: [],
            parsedProduct: {},
            productId: null,
            rating: 0,
            hoverRating: 0,
            comment: "",
            collapsed: true,
            userId: 0,
            currentPage: 1,
            pageSize: 5,
            totalElements: 0,
            totalPages: 0,
            allComments: [],
            averageRating: 0.00,
            nameCategory: "",
            isReviewsProduct: false,
        };
    },
    created() {
        try {
            this.productId = JSON.parse(decodeURIComponent(this.product));
        } catch (error) {
            console.error('Error parsing product:', error);
        }
    },
    methods: {
        currencyFormat(value) {
            if (!value) return "0 VNĐ";
            return new Intl.NumberFormat('vi-VN').format(value) + " VNĐ";
        },
        formatDate(dateString) {
            if (!dateString) return "";
            const date = new Date(dateString);
            return new Intl.DateTimeFormat('vi-VN').format(date);
        },
        async fetchProductDetails() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/products/details/${this.productId}`)
                if (response.data.status === 200) {
                    this.parsedProduct = response.data.data;
                    this.nameCategory = response.data.data.category.name;
                }
                else {
                    console.error('Error fetching product details:', response.data.message);
                }
            }
            catch (error) {
                console.error('Error fetching product details:', error);
            }
        },
        async fetchDiscoutProducts() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/products?is_hot=true&page=0&size=10&sort_by=id&sort_dir=asc`);
                if (response.data && response.data.status == 200) {
                    const allProductDiscount = response.data.data.product_response;
                    this.discountProducts = this.getRandomDiscountProducts(allProductDiscount, 4);
                    this.fetchReivewUser();
                    this.fetchAveragedReviews();
                }
                else {
                    console.error('Failed to fetch discount products');
                }
            }
            catch (error) {
                console.error('Failed to fetch discount products', error);
            }
        },
        loadReviewsProduct() {
            this.isReviewsProduct = sessionStorage.getItem('reviewsProducts');
            console.log(this.isReviewsProduct);
            this.$router.push({ name: 'DetailProduct', hash: '#reviews-product' });
        },
        getRandomDiscountProducts(products, count) {
            return products.map(product => ({ product, sort: Math.random() })).sort((a, b) => a.sort - b.sort).slice(0, count).map(({ product }) => product);
        },
        formatAttributeNameMobile(name) {
            return name.replace('mobile_', '').replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase());
        },
        formatAttributeNameLaptop(name) {
            return name.replace('laptop_', '').replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase());
        },
        getAttributeValue(attributeName) {
            const attribute = this.parsedProduct.attributes.find(attr => attr.name === attributeName);
            return attribute ? attribute.value : "N/A";
        },
        updateParsedProduct() {
            this.parsedProduct = {
                ...this.parsedProduct,
                color: this.selectedColor,
                memory: this.selectedMemory,
            };
            console.log("Parsed product updated:", this.parsedProduct);
        },
        getStarClass(index) {
            if (index < this.hoverRating || (this.hoverRating === 0 && index < this.rating)) {
                return 'fa-solid fa-star text-warning';
            }
            return 'fa-regular fa-star';
        },
        setRating(index) {
            this.rating = index + 1;
        },
        // Phương thức thay đổi giá trị hoverRating khi di chuột qua ngôi sao
        handleHover(index) {
            this.hoverRating = index + 1;
        },
        // Phương thức reset lại hoverRating khi rời chuột khỏi ngôi sao
        resetHover() {
            this.hoverRating = 0;
        },
        async fetchProfile() {
            try {
                const response = await axios.get('http://localhost:8080/api/v1/users/detail', {
                    headers: {
                        'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                    }
                });
                if (response.data.status === 200) {
                    const profileData = response.data.data;
                    this.userId = profileData.id;
                } else {
                    console.log(response.data.message);
                }
            } catch (error) {
                console.log(error);
            }
        },
        async submitReview() {
            if (this.rating === 0) {
                alert("Please select a rating before submitting!");
                return;
            }
            try {
                const response = await axios.post(`http://localhost:8080/api/v1/ratings`, {
                    rate: this.rating,
                    comment: this.comment,
                    product_id: this.productId,
                    user_id: this.userId
                }, {
                    headers: {
                        'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                    }
                });
                if (response.data && response.data.status == 200) {
                    alert("Review submitted successfully!");
                    this.comment = "";
                    this.rating = 0;
                    sessionStorage.removeItem('reviewsProducts');
                    this.fetchReivewUser();
                }
                else {
                    alert("An unexpected error occurred. Please try again.");
                }
            }
            catch (error) {
                if (error.response && error.response.data && error.response.data.error) {
                    const errorMessage = error.response.data.error[0];
                    alert(errorMessage);
                    window.scrollTo({ top: 0, behavior: 'smooth' });

                }
                else {
                    alert("An unexpected error occurred. Please try again.");
                }
            }
        },
        addToCart(product) {
            const productToAdd = { ...product, color: this.selectedColor, memory: this.selectedMemory };
            this.$emit('add-to-cart', productToAdd);
            sessionStorage.removeItem('reviewsProducts');
        },
        selectImage(imageUrl) {
            this.parsedProduct.thumbnail = imageUrl;
        },
        toggleCollapse() {
            this.collapsed = !this.collapsed;
        },
        purchaseProduct() {
            const productArray = Array.isArray(this.parsedProduct) ? this.parsedProduct : [this.parsedProduct];
            const checkoutData = productArray.map(item => ({
                id: item.id,
                name: item.name,
                quantity: 1,
                quantityInStock: item.quantity,
                price: item.price,
                total: (item.price * item.quantityPurchase).toFixed(2),
                thumbnail: item.thumbnail,
            }));

            // Store it in sessionStorage as a stringified array
            sessionStorage.setItem('checkProductCart', JSON.stringify(checkoutData));
            sessionStorage.removeItem('reviewsProducts');
            this.$router.push({ name: 'Checkout' });
        },
        purchaseProductDiscount(product) {
            const checkoutData = {
                id: product.id,
                name: product.name,
                quantity: 1,
                price: product.price,
                total: (product.price),
                thumbnail: product.thumbnail
            };

            sessionStorage.setItem('checkProductCart', JSON.stringify([checkoutData]));
            sessionStorage.removeItem('reviewsProducts');
            this.$router.push({ name: 'Checkout', params: { product: JSON.stringify(checkoutData) } });
        },
        async fetchReivewUser() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/ratings/product/${this.productId}?page=${this.currentPage - 1}&size=${this.pageSize}`);
                if (response.data && response.data.status == 200) {
                    this.allComments = response.data.data.rate_response;
                    this.totalElements = response.data.data.total_elements;
                    this.totalPages = Math.ceil(this.totalElements / this.pageSize);
                }
                else {
                    console.error('Failed to fetch reviews');
                }
            }
            catch (error) {
                console.error(error);
            }
        },
        changePage(page) {
            if (page >= 1 && page <= this.totalPages) {
                this.currentPage = page;
                this.fetchReviewUser();
            }
        },
        async fetchAveragedReviews() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/ratings/average_by_product/${this.productId}`);
                if (response.data && response.data.status == 200) {
                    this.averageRating = response.data.data;
                }
                else {
                    console.error('Failed to fetch average rating');
                }
            }
            catch (error) {
                console.error(error);
            }
        }
    },
    mounted() {
        this.fetchProductDetails();
        this.fetchProfile();
        this.fetchDiscoutProducts();
        this.fetchReivewUser();
        this.fetchAveragedReviews();
        this.loadReviewsProduct();
    },
}

</script>



<style scoped>
a {
    text-decoration: none;
}

.detail-content {
    width: 100%;
}

.content {
    width: 50%;
}

.content .color .checkbox {
    width: 30px;
    height: 30px;
    margin-right: 10px;
    border: 1px solid #ccc;
    cursor: pointer;
}

.color .checkbox.black {
    background-color: black;
}

.color .checkbox.gold {
    background-color: gold;
}

.color .checkbox.red {
    background-color: red;
}

.color .checkbox.white {
    background-color: white;
}

.color .checkbox.blue {
    background-color: blue;
}

.memory {
    padding: 10px 20px;
    border: 1px solid #ccc;
    cursor: pointer;
}

.memory,
.color .checkbox {
    transition: border-color 0.3s ease;
}

.memory.active,
.color .checkbox.active {
    border: 5px solid gray;
}

.d-flex .memory {
    padding: 5px 15px;
    text-align: center;
    border: 1px solid rgb(158, 157, 157);
    border-radius: 10px;
    cursor: pointer;
}


.memory.active {
    background-color: #000000;
    color: white;
}

.memory-detail {
    display: flex;
    flex-wrap: wrap;
}

/* Corrected media query */
@media screen and (max-width: 1000px) {
    .memory-detail {
        flex-wrap: nowrap;
        /* Changed from no-wrap to nowrap */
        justify-content: space-evenly;
        text-align: center;
    }

    .memory-detail .detail {
        background-color: rgb(233, 229, 229);
        border-radius: 10px;
        text-align: center;
    }
}


.memory-detail .detail {
    background-color: rgb(233, 229, 229);
    width: 200px;
    padding: 8px 20px;
    border-radius: 10px;
    text-align: center;
    margin: 5px;
}

.quanlity .align-item-center {
    border: 1px solid rgb(218, 215, 215);
    padding: 8px 20px;
    align-items: center;
    border-radius: 10px;
    text-align: center;
}

.reviews {
    width: 100%;
}

.reviews .review-section {
    padding: 1.5rem;
    background-color: #f9f9f9;
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.reviews .number-star {
    background-color: rgb(231, 230, 230);
    padding: 40px 50px;
    border-radius: 10px;
}

#average-rating {
    font-size: 3rem;
    font-weight: bold;
    color: #4b3617;
    margin: 0;
}

.static-stars {
    display: flex;
    align-items: center;
    margin-top: 0.5rem;
    color: #ff9800;
}

.static-stars i {
    font-size: 1.5rem;
}

.review-prompt {
    font-weight: 500;
    color: #555;
    margin-bottom: 1rem;
}

.review-stars i {
    font-size: 1.8rem;
    color: #d3d3d3;
    transition: color 0.3s ease, transform 0.2s ease;
    cursor: pointer;
    margin: 0 0.1rem;
}

.review-stars i:hover,
.review-stars i.active {
    color: #ff9800;
    transform: scale(1.1);
}

.review-stars i.selected {
    color: #ff9800;
}

/* Submit button */
.submit-btn {
    font-size: 1rem;
    padding: 0.6rem;
    background-color: #ff4d4d;
    border-color: #ff4d4d;
}

.submit-btn:hover {
    background-color: #ff6666;
    border-color: #ff6666;
}

.review-section {
    display: flex;
    justify-content: center;
    /* Centers the content horizontally */
    align-items: center;
    /* Centers the content vertically if needed */
    gap: 2rem;
    /* Adds space between the number-star and comment-user sections */
    padding: 2rem;
    /* Adds padding around the review section */
}

.number-star {
    display: flex;
    flex-direction: column;
    align-items: center;
    /* Centers content in number-star */
    margin-bottom: 1.5rem;
}

.comment-user {
    max-width: 500px;
    /* Limits width of the comment section */
    width: 100%;
    text-align: center;
}

.review-form {
    margin-top: 1rem;
}

.review-stars i {
    font-size: 1.5rem;
    /* Sets the star icon size */
    color: #ffca28;
    /* Star color */
    cursor: pointer;
}

.submit-btn {
    margin-top: 1rem;
}

.container.comment-user2 {
    max-width: 800px;
    margin: 0 auto;
    padding: 1.5rem;
    background: #f8f9fa;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.user1 {
    padding: 1rem;
    margin-bottom: 1rem;
    border-radius: 8px;
    background-color: #ffffff;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
    transition: transform 0.2s ease;
}

.user1:hover {
    transform: scale(1.02);
}

.user1 .fw-bold {
    color: #343a40;
    font-size: 1.25rem;
    margin-bottom: 0.2rem;
}

.user1 .text-secondary {
    color: #6c757d;
}

.pagination {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1rem;
    margin-top: 2rem;
}

.pagination button {
    background-color: #007bff;
    color: #ffffff;
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 5px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s ease;
}

.pagination button:disabled {
    background-color: #cccccc;
    cursor: not-allowed;
}

.pagination button:not(:disabled):hover {
    background-color: #0056b3;
}

.pagination span {
    font-weight: 500;
    color: #495057;
    font-size: 1rem;
}
</style>