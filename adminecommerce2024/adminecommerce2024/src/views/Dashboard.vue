<template>
    <div class="my-5">
        <div class="dashboard container-fluid d-flex justify-content-between flex-wrap">
            <div class="left-section">
                <div class="d-flex container-fluid flex-wrap mb-5">
                    <router-link to="/HistoryOrderUser" class="flex-item">
                        <div class="card total-delivery-success">
                            <p>Products purchased this month</p>
                            <p class="fs-5">234 products</p>
                        </div>
                    </router-link>
                    <router-link to="/HistoryOrderUser" class="flex-item">
                        <div class="card total-delivery-cancelled">
                            <p>Total products bestseller</p>
                            <p class="fs-5">15 products</p>
                        </div>
                    </router-link>
                    <router-link to="/HistoryOrder" class="flex-item">
                        <div class="card total-inventory">
                            <p>Inventory products</p>
                            <p class="fs-5">50 products</p>
                        </div>
                    </router-link>
                    <router-link to="/HistoryOrder" class="flex-item">
                        <div class="card total-revenue">
                            <p>Total revenue of the month</p>
                            <p class="fs-5"><span class="text-danger">$</span>500.00</p>
                        </div>
                    </router-link>
                </div>

                <!-- Product Sales Line Chart -->
                <div class="w-100 mb-5">
                    <v-card>
                        <v-card-title class="fw-bold fs-3">Product Sales</v-card-title>
                        <v-card-text>
                            <apexchart type="line" :options="productSalesOptions" :series="productSalesSeries" />
                        </v-card-text>
                    </v-card>
                </div>
                <div class="text-end mt-5">
                    <button class="btn btn-secondary">
                        <i class="fa-solid fa-plus me-2"></i>Report sale
                    </button>
                </div>
            </div>

            <div class="right-section">
                <v-card>
                    <v-card-title class="fw-bold fs-3">Products Bestseller</v-card-title>
                    <div class="text-end my-4">

                        <!-- Sort by Select Dropdown -->
                        <select v-model="sortOrder" @change="sortProducts" class="mb-3">
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
        <div class="inventory">
            
        </div>
    </div>
</template>

<script>
import VueApexCharts from "vue3-apexcharts";

export default {
    name: "Dashboard",
    components: {
        apexchart: VueApexCharts,
    },
    data() {
        return {
            // Product Sales Line Chart Data
            productSalesOptions: {
                chart: {
                    type: "line",
                    height: 350,
                    toolbar: {
                        show: true,
                    },
                },
                xaxis: {
                    categories: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                },
            },
            productSalesSeries: [
                {
                    name: "Sales",
                    data: [620, 800, 700, 780, 660, 900, 840],
                },
            ],
            // Upcoming Schedules
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
            sortOrder: 'asc', // Initial sort order
            expandedIndex: null, // Track which card is expanded
        };
    },
    computed: {
        limitedSchedules() {
            return this.productBestSellers.slice(Math.max(this.productBestSellers.length - 5, 0));
        },
        sortedProducts() {
            return this.productBestSellers.slice().sort((a, b) =>
                this.sortOrder === 'asc'
                    ? a.quantity_sold - b.quantity_sold
                    : b.quantity_sold - a.quantity_sold
            );
        },
    },
    methods: {
        downloadExcel() {
            const data = this.productSalesSeries[0].data.map((value, index) => {
                return {
                    Day: this.productSalesOptions.xaxis.categories[index],
                    Sales: value,
                };
            });

            const ws = XLSX.utils.json_to_sheet(data);
            const wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, "Product Sales");

            XLSX.writeFile(wb, "product_sales_report.xlsx");
        },
        toggleSortOrder() {
            this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
        },
        openModal(product) {
            this.selectedProduct = product;
        },
        closeModal() {
            this.selectedProduct = null;
        },
        sortProducts() {
            // Trigger sort when sortOrder changes
            this.sortedProducts;
        },
        toggleDetails(index) {
            this.expandedIndex = this.expandedIndex === index ? null : index;
        },
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
select{
    border: none;
    outline-style: none;
    padding: 10px;
}
</style>