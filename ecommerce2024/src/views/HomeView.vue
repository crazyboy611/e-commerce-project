<template>
    <section class="section-1">
        <div class="container d-flex pt-5 justify-content-between">
            <div class="content">
                <b class="text-secondary fs-2">New Product</b>
                <h1 class="text-white fw-lighter">Iphone 14 <span class="fw-bold">Pro Max</span></h1>
                <p class="text-secondary fs-4 mb-5">Create to change everything for the better. For everyone.</p>
                <a href="/">
                    <button class="fw-medium fs-5">Buy</button>
                </a>
            </div>
            <div class="image">
                <img src="../ImageProduct/IphoneImage.png" alt="">
            </div>
        </div>
    </section>
    <section class="section-2">
        <div class=" d-flex py-5 justify-content-between flex-wrap">
            <div class="section-2-left">
                <div class="d-flex justify-content-between">
                    <div class="image">
                        <img src="../ImagePR/airpod.png" width="300px" alt="">
                    </div>
                    <div class="content mt-5 text-white">
                        <h2 class="fw-lighter">Air pod <span class="fw-bold">Pro Gen 2</span></h2>
                        <p>Watch quiet the noise</p>
                        <p>Watch the film</p>
                    </div>
                </div>
                <div class="d-flex mt-3">
                    <div class="d-flex">
                        <div class="image">
                            <img src="../ImagePR/headphone.png" alt="">
                        </div>
                        <div class="content ms-5 mt-5">
                            <h2>Headphone</h2>
                            <p>Upgrade your sound quality with Bluetooth technology and noise cancellation.</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="d-flex section-2-right py-3 mt-3">
                <div class="content mt-5 pt-5 ms-5">
                    <h2 class="fw-lighter">Macbook <span class="fw-bold">Air</span></h2>
                    <p>The new 15‑inch MacBook Air makes room for more of what you love with a spacious Liquid
                        Retina display.</p>
                    <a href="/">
                        <button class="fw-medium fs-5">Buy</button>
                    </a>
                </div>
                <div class="image">
                    <img src="../ImagePR/MacBookPro.png" alt="">
                </div>
            </div>
        </div>
    </section>
    <section class="section-3">
        <div class="container">
            <div class="d-flex justify-content-between">
                <h2>Browse By Category</h2>
                <nav>
                    <ul class="pagination justify-content-center">
                        <li class="page-item" :class="{ disabled: currentPage === 1 }">
                            <a class="page-link" href="#" @click.prevent="setPage(currentPage - 1)"><i
                                    class="fa-solid fa-angle-left"></i></a>
                        </li>
                        <li class="page-item" :class="{ disabled: currentPage === totalPages }">
                            <a class="page-link" href="#" @click.prevent="setPage(currentPage + 1)"><i
                                    class="fa-solid fa-chevron-right"></i></a>
                        </li>
                    </ul>
                </nav>
            </div>
            <div class="row justify-content-center">
                <div v-for="category in paginatedCategories" :key="category.name" class="col-md-4">
                    <RouterLink class="router-link-category" :to="{ name: 'ProductList' }">
                        <div class="card text-center" @click="storeCategoryId(category.id)">
                            <i :class="category.icon"></i>
                            <p>{{ category.name }}</p>
                        </div>
                    </RouterLink>
                </div>
            </div>
        </div>
    </section>
    <!-- <section class="section-4">
        <div class="container">
            <div class="mt-5">
                
                <a href="#" @click.prevent="filterProducts('newProduct')">New Products</a>
                <a href="#" @click.prevent="filterProducts('bestSeller')">BestSeller</a>
                <a href="#" @click.prevent="filterProducts('LimitedQuatity')">Limited Quantity</a>
            </div>
            <div class="row my-5">
                
                <div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-3" v-for="(product, index) in filteredProducts"
                    :key="index">
                    <div class="card h-100 d-flex flex-column">
                        <div class="card-body d-flex flex-column">
                            <i class="fas fa-heart text-end fs-5"></i>
                            <img :src="product.image" class="img-fluid card-img-top p-5" :alt="product.name">
                            <h3 class="card-title mb-2 text-center">{{ product.name }}</h3>
                            <p class="text-center fw-bold fs-5"><span class="text-danger">{{ product.price }}</span> VND
                            </p>
                            <div class="my-2 mt-auto text-center">
                                <button @click="viewProduct(product)">Buy Now</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section> -->
    <!-- <section class="section-5 my-4">
        <div class="container">
            <h3 class="my-4">Popular Products</h3>
            <div id="carouselExample" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3000">
                <div class="carousel-inner">
                    <div class="carousel-item" :class="{ active: index === 0 }"
                        v-for="(chunk, index) in chunkedPopularProducts" :key="index">
                        <div class="row">
                            <div class="col-md-4 mb-3" v-for="(popularProduct, productIndex) in chunk"
                                :key="productIndex">
                                <div class="card h-100">
                                    <div class="card-body d-flex flex-column mt-3 text-white">
                                        <img :src="popularProduct.img" class="img-fluid card-img-top p-5" width="50%"
                                            :alt="popularProduct.name">
                                        <h3 class="card-title mb-2 text-center">{{ popularProduct.name }}</h3>
                                        <p>{{ popularProduct.description }}</p>
                                        <div class="my-2 mt-auto text-center">
                                            <button @click="viewProduct(popularProduct)">Buy Now</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#carouselExample"
                    data-bs-slide="prev">
                    <span class="carousel-control-prev-icon hiden" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carouselExample"
                    data-bs-slide="next">
                    <span class="carousel-control-next-icon hiden" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
        </div>
    </section> -->

    <section class="section-6 my-5" id="home-view-discount">
        <div class="container">
            <h3>Discount up to <span class="text-danger">50%</span></h3>
            <div class="row my-5">
                <div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-3" v-for="(product, index) in discountProducts"
                    :key="index">
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
                            <p class="card-text text-center"><strong>{{ currencyFormat(product.price) }}</strong></p>
                            <div class="my-2 mt-3 text-center">
                                <!-- Pass product data via route params -->
                                <router-link :to="{ name: 'Checkout', params: { product: JSON.stringify(product) } }">
                                    <button class="btn btn-dark px-5 my-1"
                                        @click="purchaseProduct(product)">Purchase</button>
                                </router-link>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>



    <section class="section-7">
        <img src="../ImagePR/Banner2.png" width="100%" height="50%" alt="">
        <div class="content">
            <RouterLink to="/ProductList"> 
                <button class="my-2 mt-3 text-center">Shop now</button>
            </RouterLink>
        </div>
    </section>
    <ProductModal v-if="selectedProduct" :product="selectedProduct" @close="selectedProduct = null" />
</template>
<script>

import axios from 'axios';
import ProductModal from '../components/ProductModal.vue';
export default {
    components: {
        ProductModal
    },
    product: {
        type: Object,
        required: true
    },
    data() {
        return {
            categories: [
                // { name: 'Phone', icon: 'fas fa-mobile-alt fs-1', category_id: '1' },
                // { name: 'Camera', icon: 'fas fa-camera fs-1', category_id: '3' },
                // { name: 'Headphone', icon: 'fas fa-headphones-alt fs-1', category_id: '4' },
                // { name: 'Laptop', icon: 'fas fa-laptop fs-1', category_id: '2' },
                // { name: 'Computer', icon: 'fas fa-desktop fs-1', category_id: '5' },
                // { name: 'Accessories', icon: 'fa-regular fa-keyboard fs-1', category_id: '6' }
            ],
            newProducts: [
                {
                    name: 'iPhone 14 Blue',
                    image: require('../ImageProduct/ip14_1TB_blue.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'newProduct',
                },
                {
                    name: 'iPhone 14 Yellow',
                    image: require('../ImageProduct/ip14_1TB_yellow.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'newProduct',
                },
                {
                    name: 'iPhone 14 Classic',
                    image: require('../ImageProduct/ip14pro1.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'newProduct',
                },
                {
                    name: 'Sam Sung 1',
                    image: require('../ImageProduct/samsung1.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'bestSeller',
                },
                {
                    name: 'Sam Sung 2',
                    image: require('../ImageProduct/samsung2.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'bestSeller',
                },
                {
                    name: 'Ipad 1',
                    image: require('../ImageProduct/ipad2.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'bestSeller',
                },
                {
                    name: 'iPad 2',
                    image: require('../ImageProduct/ipad9.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'LimitedQuatity',
                },
                {
                    name: 'iPad 2',
                    image: require('../ImageProduct/ipad9.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'LimitedQuatity',
                },
                {
                    name: 'iPad 2',
                    image: require('../ImageProduct/ipad9.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'LimitedQuatity',
                },
                {
                    name: 'iPad 2',
                    image: require('../ImageProduct/ipad9.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'newProduct',
                },
                {
                    name: 'iPad 2',
                    image: require('../ImageProduct/ipad9.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'bestSeller',
                },
                {
                    name: 'iPad 2',
                    image: require('../ImageProduct/ipad9.png'),
                    description: 'Latest model with A14 Bionic chip...',
                    price: '15.000.000',
                    oldPrice: '17.000.000',
                    details: [
                        'A14 Bionic chip',
                        '5G capability',
                        'Super Retina XDR display'
                    ],
                    type: 'LimitedQuatity',
                }
            ],
            popularProducts: [
                {
                    img: require('../ImageProduct/airpod2.png'),
                    name: 'Popular Product',
                    description: 'iPad combines a magnificent 10.2-inch Retina display, incredible performance, multitasking and ease of use.',
                },
                {
                    img: require('../ImageProduct/ipad9.png'),
                    name: 'Ipad Pro',
                    description: 'iPad combines a magnificent 10.2-inch Retina display, incredible performance, multitasking and ease of use.',
                },
                {
                    img: require('../ImageProduct/samsung1.png'),
                    name: 'Samsung Galaxy S21',
                    description: 'iPad combines a magnificent 10.2-inch Retina display, incredible performance, multitasking and ease of use.',
                },
                {
                    img: require('../ImageProduct/Macbook1.png'),
                    name: 'Macbook Pro',
                    description: 'iPad combines a magnificent 10.2-inch Retina display, incredible performance, multitasking and ease of use.',
                },
                {
                    img: require('../ImageProduct/Macbook1.png'),
                    name: 'Macbook Pro',
                    description: 'iPad combines a magnificent 10.2-inch Retina display, incredible performance, multitasking and ease of use.',
                },
                {
                    img: require('../ImageProduct/Macbook1.png'),
                    name: 'Macbook Pro',
                    description: 'iPad combines a magnificent 10.2-inch Retina display, incredible performance, multitasking and ease of use.',
                }
            ],
            discountProducts: [],
            selectedCategory: 'newProduct',
            selectedProduct: null,
            currentPage: 1,
            itemsPerPage: 3
        };
    },
    computed: {
        filteredProducts() {
            return this.newProducts.filter(product => product.type === this.selectedCategory);
        },
        paginatedCategories() {
            const startIndex = (this.currentPage - 1) * this.itemsPerPage;
            const endIndex = startIndex + this.itemsPerPage;
            return this.categories.slice(startIndex, endIndex);
        },
        totalPages() {
            return Math.ceil(this.categories.length / this.itemsPerPage);
        },
        chunkedPopularProducts() {
            // Function to group popularProducts into chunks of 3
            const chunkSize = 3;
            const chunks = [];
            for (let i = 0; i < this.popularProducts.length; i += chunkSize) {
                chunks.push(this.popularProducts.slice(i, i + chunkSize));
            }
            return chunks;
        },
    },
    created() {
        this.fetchDiscoutProducts();
        this.fetchCategory();
    },
    methods: {
        async fetchDiscoutProducts() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/products?is_hot=true&page=0&size=10&sort_by=id&sort_dir=asc`);
                if (response.data && response.data.status == 200) {
                    const allProductDiscount = response.data.data.product_response;
                    this.discountProducts = this.getRandomDiscountProducts(allProductDiscount, 4);
                }
                else {
                    console.error('Failed to fetch discount products');
                }
            }
            catch (error) {
                console.error('Failed to fetch discount products', error);
            }
        },
        getRandomDiscountProducts(products, count) {
            return products.map(product => ({ product, sort: Math.random() })).sort((a, b) => a.sort - b.sort).slice(0, count).map(({ product }) => product);
        },
        filterProducts(categoryType) {
            this.selectedCategory = categoryType;
        },
        setPage(page) {
            this.currentPage = page;
        },
        viewProduct(product) {
            this.selectedProduct = product;
        },
        storeCategoryId(categoryId) {
            sessionStorage.setItem('selectedCategoryId', categoryId);
        },
        async fetchCategory() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/categories`);
                this.categories = response.data.data;
            }
            catch (error) {
                console.error('Failed to fetch categories', error);
            }
        },
        purchaseProduct(product) {
            const checkoutData = {
                id: product.id,
                name: product.name,
                quantity: 1,
                // quantityInStock: product.
                price: product.price,
                total: (product.price),
                thumbnail: product.thumbnail
            };

            sessionStorage.setItem('checkProductCart', JSON.stringify([checkoutData]));

            this.$router.push({ name: 'Checkout', params: { product: JSON.stringify(checkoutData) } });
        },
        currencyFormat(value) {
            if (!value) return "0 VNĐ";
            return new Intl.NumberFormat('vi-VN').format(value) + " VNĐ";
        },

    },

}

</script>
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

a {
    text-decoration: none;

}

.router-link-category {
    text-decoration: none;
}

.section-1 {
    background-color: #211C24;
    width: 100%;
}

.section-1 .content {
    margin: 10%;
    width: 50%;
}

.section-1 .image {
    width: 50%;
}

.section-1 .image img {
    width: 100%;
    height: auto;
    display: flex;
    align-items: end;
}

.section-1 .content>a>button {
    /* Auto layout */
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    padding: 16px 56px;
    gap: 8px;

    width: 191px;
    height: 56px;

    /* Main/White */
    border: 1px solid #FFFFFF;
    border-radius: 10px;

    /* Inside auto layout */
    flex: none;
    order: 2;
    flex-grow: 0;
    background-color: #211C24;
    color: #FFFFFF;
}

.section-1 .content>a>button:hover {
    background-color: #FFFFFF;
    color: #211C24;
    outline-style: inset;
    outline-color: #000000;
}

.content a {
    text-decoration: none;
    color: #FFFFFF;
}

.section2 {
    position: relative;
}

.section-2-left .content {
    width: 70%;
    font-size: 15px;
}

.section-2-right {
    background-color: #EDEDED;
    border-radius: 20px 0 0 20px;
}

.section-2-left .justify-content-between {
    background-color: #524f4f;
    border-radius: 0 20px 20px 0;
}

.section-2-left .mt-3 {
    background-color: #eba5a5;
    border-radius: 0 20px 20px 0;
}

.section-2-right .fs-5 {
    width: 191px;
    height: 56px;

    /* Main/White */
    border: 1px solid #211C24;
    border-radius: 10px;
}

.section-2-right .fs-5:hover {
    background-color: #211C24;
    color: #FFFFFF;
}

.section-3 {
    padding: 50px 0;
    text-align: center;
}

.section-3 .card {
    padding: 30px;
    border: 1px solid #ccc;
    border-radius: 5px;
    margin: 10px;
    background-color: #EDEDED;
}

.section-3 .card:hover {
    background-color: #c9c5c5;
}

.section-3 .card img {
    width: 100px;
    height: 100px;
    object-fit: contain;
}

.section-3 .card p {
    margin-top: 10px;
    font-weight: bold;
}

.section-4 .mt-5 a {
    text-decoration: none;
    color: #8B8B8B;
    font-size: 18px;
    margin-right: 2%;
    font-weight: 700;
}

.section-4 .mt-5 a:hover {
    color: #000000;
}

.section-4 .card {
    background-color: #F6F6F6;
    outline: none;
    border: none;
    border-radius: 10px;
}

.section-4 .card .fa-heart {
    outline: #000000;
    cursor: pointer;
    color: #999494;
}

.section-4 .card .fa-heart:hover {
    color: red;
}

.section-4 .card button {
    padding: 15px 50px;
    border: none;
    border-radius: 10px;
    outline: auto;
    background-color: #000000;
    color: white;
    font-weight: 600;
}

.section-5 .card {
    background-color: rgb(247, 110, 110);
    border: none;
    outline: none;
    border-radius: 10px;

}

.section-5 .card button {
    padding: 15px 50px;
    border: none;
    border-radius: 10px;
    outline: none;
    background-color: #000000;
    color: white;
    font-weight: 600;
}

.section-5 .card button:hover {
    background-color: #ffffff;
    color: #000000;
    font-weight: 600;
    outline-style: inset;
    outline-color: #000000;
}

.section-5 .d-flex {
    width: 100%;
}

.section-6 .card {
    height: 100%;
    background-color: #F6F6F6;
    outline: none;
    border: none;
    border-radius: 10px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}
.section-6 a{
    cursor: pointer;
    color: rgb(228, 64, 64);
}
.section-6 .card .card-title,
.section-6 .card .card-text {
    flex-grow: 1;
}

.section-6 .card button {
    padding: 15px 50px;
    border: none;
    border-radius: 10px;
    outline: none;
    background-color: #000000;
    color: white;
    font-weight: 600;
}

.section-7 {
    position: relative;
}

.section-7 .content {
    position: absolute;
    top: 50%;
    left: 50%;
    color: #FFFFFF;
    transform: translate(-50%, 60%);
    /* Di chuyển về giữa màn hình */
    text-align: center;
    /* Đảm bảo nội dung bên trong cũng được căn giữa theo chiều ngang */
}

.section-7 .content h2 {
    font-size: 50px;
}

.section-7 .content span {
    font-size: 60px;
}

.section-7 .content button {
    padding: 15px 50px;
    border: none;
    border-radius: 10px;
    outline: auto;
    background-color: #363535;
    color: white;
    font-weight: 600;
}

.section-7 .content button:hover {
    background-color: white;
    color: #000000;
    outline-style: inset;
    outline-color: #000000;
}

.section-6 .card .fa-heart {
    outline: #000000;
    cursor: pointer;
    color: #999494;
}

.section-6 .card .fa-heart:hover {
    color: red;
}

.section-6 .card button:hover {
    background-color: white;
    color: #000000;
    outline-style: inset;
    outline-color: #000000;
}

.section-4 .card button:hover {
    background-color: white;
    color: #000000;
    outline-style: inset;
    outline-color: #000000;
}

@media only screen and (max-width:800px) {
    .section-5 .d-flex {
        display: flex;
        flex-wrap: wrap;
    }

    .section-7 {
        width: 100%;
        /* Giảm padding khi vào màn hình nhỏ */
    }

    .section-7 .content {
        position: absolute;
        top: 50%;
        left: 50%;
        color: #FFFFFF;
        transform: translate(-50%, 30%);
        /* Di chuyển về giữa màn hình */
        text-align: center;
        /* Đảm bảo nội dung bên trong cũng được căn giữa theo chiều ngang */
    }

    .section-7 .content button {
        padding: 5px 20px;
        border: none;
        border-radius: 10px;
        outline: auto;
        background-color: #363535;
        color: white;
        font-weight: 600;
        font-size: 10px;
    }
}

.hiden {
    opacity: 0;
}
</style>
