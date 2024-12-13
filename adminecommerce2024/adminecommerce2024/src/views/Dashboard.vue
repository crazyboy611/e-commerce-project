<template>
    <div class="my-5">
        <div class="dashboard container-fluid d-flex justify-content-between flex-wrap">
            <div class="left-section">
                <!-- Product Sales Line Chart -->
                <div class=" mb-5">
                    <h2>Revenue</h2>
                    <input type="number" name="year" v-model="selectedYear" @change="fetchRevenueData"
                        placeholder="Enter Year" class="form-control mb-3" />
                    <v-card>
                        <v-card-text>
                            <apexchart type="bar" :options="productSalesOptions" :series="productSalesSeries"
                                width="100%" height="350" />
                        </v-card-text>
                    </v-card>
                </div>
                <div class="text-end mt-5">
                    <button class="btn btn-secondary" >
                        <i class="fa-solid fa-plus me-2"></i>Report sale
                    </button>
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
            selectedYear: 2024,
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
                            return `$${value.toFixed(3)}`;
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
                } else {
                    console.error("Failed to fetch data: ", response.data.message);
                }
            } catch (error) {
                console.error("Error fetching revenue data: ", error);
            }
        },
        toggleDetails(index) {
            this.expandedIndex = this.expandedIndex === index ? null : index;
        },
    },
    mounted() {
        this.fetchRevenueData();
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
</style>