<template>
    <div class="my-5">
        <div class="dashboard container-fluid d-flex justify-content-between flex-wrap">
            <div class="left-section">
                <!-- Product Sales Line Chart -->
                <div class=" mb-5">
                    <h2>Revenue</h2>
                    <div class="d-flex my-4">
                        <p>Year <input type="number" name="year" v-model="selectedYear" @change="fetchRevenueData"
                                placeholder="Enter Year" class=" mb-3 rounded" /></p>
                        <p>Total revennue year: <span class="text-danger fw-bold" v-if="totalRevenueYear">{{
                            totalRevenueYear.toFixed(3) }} VND</span><span class="text-danger fw-bold" v-else>0
                                VND</span></p>
                    </div>
                    <v-card>
                        <v-card-text>
                            <apexchart type="bar" :options="productSalesOptions" :series="productSalesSeries"
                                width="100%" height="350" />
                        </v-card-text>
                    </v-card>
                </div>
                <div class="my-4">
                    <h2>Product Sales</h2>
                    <p>
                        Month
                        <select v-model="selectedMonth" @change="fetchRevenueProduct" class="my-3 rounded">
                            <option v-for="month in 12" :key="month" :value="month">
                                {{ month }}
                            </option>
                        </select>
                    </p>

                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Quantity Sold</th>
                                <th>Revenue</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(product, index) in productSale" :key="index">
                                <td>
                                    <a href="#" @click.prevent="viewProductDetails(product.product_id)">
                                        {{ product.product_id }}
                                    </a>
                                </td>
                                <td>{{ product.quantity }}</td>
                                <td><span class="text-danger fs-5">{{ product.revenue.toFixed(3) }} VND</span></td>
                            </tr>
                        </tbody>
                    </table>
                    <div v-if="showProductDetailsModal" class="modal" @click.self="closeProductModal">
                        <div class="modal-content">
                            <span class="close fs-3 fw-bold" @click="closeProductModal">&times;</span>
                            <h2>Product Details</h2>
                            <img :src="`http://localhost:8080/api/v1/products/images/${detailProductSeller.thumbnail}`"
                                alt="Product Image" class="img-fluid mb-3" />
                            <p><strong>Product Name:</strong> {{ detailProductSeller.name }}</p>
                            <p><strong>Price:</strong> ${{ detailProductSeller.price }}</p>
                            <p>Quantity: {{ detailProductSeller.quantity }}</p>
                        </div>
                    </div>
                    <div class="pagination d-flex justify-content-center mt-4">
                        <button class="btn btn-primary mx-2" :disabled="currentPage === 0"
                            @click="changePage(currentPage - 1)">
                            <i class="fa-solid fa-chevron-left"></i>
                        </button>
                        <span>{{ currentPage + 1 }} of {{ totalPages }}</span>
                        <button class="btn btn-primary mx-2" :disabled="currentPage + 1 >= totalPages"
                            @click="changePage(currentPage + 1)">
                            <i class="fa-solid fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div class="right-section">
                <v-card>
                    <v-card-title class="fw-bold fs-3">Products Bestseller</v-card-title>
                    <div class="text-end my-4">
                        <!-- Sort by Select Dropdown -->
                        <select v-model="sortOrder" @change="sortProducts" class="form-select mb-3">
                            <option value="asc">Ascending</option>
                            <option value="desc">Descending</option>
                        </select>
                    </div>

                    <v-card-text>
                        <div v-for="(productBestSeller, index) in sortedProducts" :key="index"
                            class="card my-2 py-3 px-3 history-card">
                            <!-- Card Header with Toggle -->
                            <div class="d-flex justify-content-between align-items-center"
                                @click="toggleDetails(index)">
                                <p>{{ productBestSeller.name }}</p>
                                <p><span class="text-danger fs-5">$</span>{{ productBestSeller.price }}</p>
                            </div>

                            <!-- Expandable Details Section -->
                            <div v-if="expandedIndex === index" class="expandable-details">
                                <p>Quantity Sold: {{ productBestSeller.quantity_sold }}</p>
                            </div>
                        </div>
                    </v-card-text>
                </v-card>
            </div>
        </div>
    </div>
</template>

<script>
import axios from "axios";
import VueApexCharts from "vue3-apexcharts";

export default {
    name: "Dashboard",
    components: {
        apexchart: VueApexCharts,
    },
    data() {
        return {
            selectedYear: new Date().getFullYear(),
            selectedMonth: new Date().getMonth() + 1,
            currentPage: 0,
            totalPages: 0,
            pageSize: 5,
            productSale: [],
            detailProductSeller: [],
            showProductDetailsModal: false,
            totalRevenueYear: 0,
            productSalesOptions: {
                chart: {
                    type: 'bar',
                    height: 350,
                    toolbar: {
                        show: true,
                    },
                },
                plotOptions: {
                    bar: {
                        horizontal: false,
                        columnWidth: "50%",
                        endingShape: "rounded",
                    },
                },
                dataLabels: {
                    enabled: false,
                },
                xaxis: {
                    categories: [
                        "Tháng 1",
                        "Tháng 2",
                        "Tháng 3",
                        "Tháng 4",
                        "Tháng 5",
                        "Tháng 6",
                        "Tháng 7",
                        "Tháng 8",
                        "Tháng 9",
                        "Tháng 10",
                        "Tháng 11",
                        "Tháng 12",
                    ],
                },
                tooltip: {
                    y: {
                        formatter: function (value) {
                            return `${value.toFixed(3)} VND`;
                        },
                    },
                },
            },
            productSalesSeries: [
                {
                    name: "Revenue",
                    data: [],
                },
            ],
            productBestSellers: [
                {
                    id: 1,
                    name: "Iphone 13",
                    price: 23,
                    quantity_sold: 14
                },
                {
                    id: 2,
                    name: "Samsung Galaxy S24 Ultra",
                    price: 23,
                    quantity_sold: 12
                },
                {
                    id: 3,
                    name: "Iphone 15",
                    price: 23,
                    quantity_sold: 20
                },
                {
                    id: 4,
                    name: "Iphone 16",
                    price: 23,
                    quantity_sold: 33
                },
                {
                    id: 5,
                    name: "Lenovo",
                    price: 100,
                    quantity_sold: 25
                }
            ],
            sortOrder: 'asc',
            expandedIndex: null,
        };
    },
    computed: {
        sortedProducts() {
            return this.productBestSellers.slice().sort((a, b) =>
                this.sortOrder === 'asc'
                    ? a.quantity_sold - b.quantity_sold
                    : b.quantity_sold - a.quantity_sold
            );
        },
    },
    methods: {
        async fetchRevenueData() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/statistics/monthly_revenue?year=${this.selectedYear}`, {
                    headers: {
                        'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                    },
                });

                if (response.data.status === 200) {
                    const apiData = response.data.data;
                    const monthlyRevenue = Array(12).fill(0);

                    apiData.forEach(({ month, revenue }) => {
                        monthlyRevenue[month - 1] = revenue;
                    });

                    this.productSalesSeries[0].data = monthlyRevenue;
                    const response2 = await axios.get(`http://localhost:8080/api/v1/statistics/yearly_revenue?year=${this.selectedYear}`, {
                        headers: {
                            'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                        },
                    });
                    this.totalRevenueYear = response2.data.data.revenue;
                } else {
                    console.error("Failed to fetch data: ", response.data.message);
                }
            } catch (error) {
                console.error("Error fetching revenue data: ", error);
            }
        },
        async fetchRevenueProduct() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/statistics/product_revenue?month=${this.selectedMonth}&year=${this.selectedYear}&size=${this.pageSize}&page=${this.currentPage}`, {
                    headers: {
                        'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                    },
                });
                this.productSale = response.data.data.content;
                this.totalPages = response.data.data.totalPages;
                this.currentPage = response.data.data.pageable.pageNumber;
            }
            catch (error) {
                alert("Error fetching revenue product data");
                console.error("Error fetching revenue product data: ", error);
            }
        },
        changePage(newPage) {
            if (newPage >= 0 && newPage < this.totalPages) {
                this.currentPage = newPage;
                this.fetchRevenueProduct();
            }
        },
        async viewProductDetails(productId) {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/products/details/${productId}`, {
                    headers: {
                        'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                    },
                });
                this.detailProductSeller = response.data.data;
                this.showProductDetailsModal = true;
            }
            catch (error) {
                console.error("Error fetching product details: ", error);
            }
        },
        closeProductModal() {
            this.showProductDetailsModal = false;
        },
        toggleDetails(index) {
            this.expandedIndex = this.expandedIndex === index ? null : index;
        },
    },
    mounted() {
        this.fetchRevenueData();
        this.fetchRevenueProduct();
        this.viewProductDetails();
    },
};
</script>

<style scoped>
.dashboard {
    display: flex;
    flex-wrap: wrap;
}

.left-section {
    flex: 1;
    margin-right: 20px;
    font-weight: bold;
}

.right-section {
    flex: 0.3;
}

.left-section .card {
    padding: 10px 20px;
}

a {
    text-decoration: none;
}

.flex-item {
    flex: 1 1 300px;
    margin: 10px;
}

.card {
    min-width: 250px;
}

@media (max-width: 768px) {

    .left-section,
    .right-section {
        flex: 1 1 100%;
    }
}

.left-section .d-flex {
    gap: 15px;
    justify-content: space-between;
}

/* Flex Item/Card Styles */
.left-section .flex-item {
    flex: 1;
    min-width: 250px;
    text-decoration: none;
}

.left-section .card {
    padding: 20px;
    border-radius: 8px;
    color: #fff;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    text-align: center;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
    cursor: pointer;
}

.left-section .card p {
    margin: 0;
}

.left-section .card p.fs-5 {
    font-size: 1.25rem;
    font-weight: bold;
}

/* Card Colors */
.total-delivery-success {
    background-color: #28a745;
    /* Green */
}

.total-delivery-cancelled {
    background-color: #dc3545;
    /* Red */
}

.total-revenue {
    background-color: #ffc107;
    /* Amber */
    color: #333;
}

.total-inventory {
    background-color: #d19872;
    /* Amber */
    color: #333;
}

/* Hover Effects */
.card:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.history-card {
    cursor: pointer;
    transition: transform 0.3s ease;
}

.history-card:hover {
    transform: scale(1.03);
}

.expandable-details {
    padding: 10px 0;
    font-size: 0.9rem;
    color: #555;
}

select {
    border: none;
    outline-style: none;
    padding: 10px;
}

.modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
}

.modal-content {
    background: white;
    padding: 30px;
    border-radius: 10px;
    width: 500px;
    position: relative;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.close {
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 1.8rem;
    cursor: pointer;
    color: #333;
}

.close:hover {
    color: #dc3545;
}

.modal-content h2 {
    margin-bottom: 20px;
    font-size: 1.8rem;
    color: #343a40;
}

.modal-content p {
    font-size: 1.1rem;
    margin: 10px 0;
    color: #495057;
}
</style>