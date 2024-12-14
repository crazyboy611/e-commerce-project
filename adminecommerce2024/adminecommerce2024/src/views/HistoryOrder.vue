<template>
  <div class="container">
    <div class="header d-flex">
      <div>
        <h1>History Orders</h1>
      </div>
    </div>
    <div class="search-sort">
      <input type="text" v-model="searchQuery" placeholder="Search OrderID" class="form-control mb-3" />
    </div>
    <div class="card">
      <div class="table-responsive">
        <table v-if="filteredOrders.length">
          <thead>
            <tr>
              <th>Order ID</th>
              <th>Order date</th>
              <th>Shipping date</th>
              <th>Provider</th>
              <th>Status</th>
              <th>Address</th>
              <th>Total Money</th>
              <th>Detail</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(order, index) in paginatedOrders" :key="order.id">
              <td>{{ order.id }}</td>
              <td>{{ order.order_date.split('T')[0] }}</td>
              <td>{{ order.shipping_date }}</td>
              <td>{{ order.payment_details.provider }}</td>
              <td>{{ order.status }}</td>
              <td class="">{{ order.shipping_address }}</td>
              <td class="text-danger">{{ order.payment_details.amount.toFixed(3) }} VND</td>
              <td>
                <button @click="viewOrderDetails(order)"><i class="fa-solid fa-circle-info"></i></button>
              </td>
            </tr>
          </tbody>
        </table>
        <p v-else class="text-center">No orders found</p>
      </div>
    </div>

    <!-- Pagination controls -->
    <div class="pagination">
      <button :disabled="currentPage === 1" @click="prevPage"><i class="fa-solid fa-chevron-left"></i></button>
      <span>{{ currentPage }}/{{ totalPages }}</span>
      <button :disabled="currentPage === totalPages" @click="nextPage"><i
          class="fa-solid fa-chevron-right"></i></button>
    </div>

    <!-- Order Details Modal -->
    <div v-if="showOrderDetailsModal" class="modal" @click.self="closeModal">
      <div class="modal-content">
        <span class="close" @click="closeModal">&times;</span>
        <h2>Order Details</h2>
        <p><strong>Order ID:</strong> {{ selectedOrder.order_details?.[0].order_id }}</p>
        <p><strong>Shipment method:</strong> {{ selectedOrder.shipment.type }}</p>
        <p><strong>Discount Code:</strong> {{ 'null' }}</p>
        <p><strong>Address:</strong> {{ selectedOrder.shipping_address }}</p>
        <p><strong>Price shipment:</strong> <span>{{ selectedOrder.shipment?.price.toFixed(3) }} VND</span></p>
        <p class="border rounded p-3 mt-3"><strong>Total Amount:</strong> <span class="fw-bold text-danger">{{
          selectedOrder.payment_details.amount.toFixed(3) }} VND</span></p>
        <!-- <p><strong>Cart Items:</strong></p>
        <ul>
          <li v-for="item in paginatedCartItems" :key="item.id">
            <span><strong>Product:</strong> {{ item.order_details?.[0].product_name }}</span> |
            <span><strong>Quantity:</strong> {{ item.order_details?.[0].number_of_products }}</span> |
            <span><strong>Price:</strong> ${{ item.order_details?.[0].total_money }}</span>
          </li>
        </ul> -->
        <!-- Pagination for cart items -->
        <div class="pagination">
          <button :disabled="currentCartPage === 1" @click="prevCartPage">
            <i class="fa-solid fa-chevron-left"></i>
          </button>
          <span>{{ currentCartPage }}/{{ totalCartPages }}</span>
          <button :disabled="currentCartPage === totalCartPages" @click="nextCartPage">
            <i class="fa-solid fa-chevron-right"></i>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'HistoryOrder',
  data() {
    return {
      orderData: [],
      showOrderDetailsModal: false,
      selectedOrder: null,
      currentPage: 1,
      itemsPerPage: 3,
      currentCartPage: 1,
      cartItemsPerPage: 3,
      sortDirection: '',
      searchQuery: '',
      searchQueryYear: '',
      selectedMonth: new Date().getMonth() + 1, // Default to current month
      months: Array.from({ length: 12 }, (_, i) => i + 1), // Options from 1 to 12
    };
  },
  computed: {
    totalPages() {
      return Math.ceil(this.filteredOrders.length / this.itemsPerPage);
    },
    totalCartPages() {
      if (!this.orderData || !Array.isArray(this.orderData)) return 0;
      return Math.ceil(this.orderData.length / this.cartItemsPerPage);
    },
    paginatedCartItems() {
      if (!this.orderData) return [];
      const start = (this.currentCartPage - 1) * this.cartItemsPerPage;
      return this.orderData.slice(start, start + this.cartItemsPerPage);
    },
    totalRevenue() {
      // Get the entered year or fallback to the current year if empty
      const currentYear = new Date().getFullYear();
      const year = this.searchQueryYear ? parseInt(this.searchQueryYear, 10) : currentYear;

      // Ensure the year is a valid number
      if (isNaN(year)) {
        return 0; // Return 0 if the year is invalid
      }

      // Filter orders by the selected month and specified year
      return this.orderData
        .filter(order => {
          const orderDate = new Date(order.shipping_date.split('-').reverse().join('-'));
          return (
            orderDate.getFullYear() === year &&
            orderDate.getMonth() + 1 === parseInt(this.selectedMonth, 10) // Ensure selectedMonth is parsed as an integer
          );
        })
        .reduce((total, order) => total + parseFloat(order.totalAmount || 0), 0); // Safeguard against potential NaN values
    },

    filteredOrders() {
      return this.orderData.filter(order =>
        order.id.toLowerCase().includes(this.searchQuery.toLowerCase())
      );
    },
    paginatedOrders() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      return this.filteredOrders.slice(start, start + this.itemsPerPage);
    },
  },
  mounted() {
    this.fetchHistoryOrder();
  },
  methods: {
    async fetchHistoryOrder() {
      try {
        const response = await axios.get('http://localhost:8080/api/v1/orders?size=5&page=', {
          headers: {
            'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
            'Accept': '*/*'
          }
        });
        if (response.data.status === 200) {
          this.orderData = response.data.data.orders
        } else {
          console.log(response.data.message)
        }
      } catch (error) {

      }
    },
    closeModal() {
      this.showOrderDetailsModal = false;
      this.selectedOrder = null; // Reset selectedOrder when modal is closed
    },
    viewOrderDetails(order) {
      this.selectedOrder = order;
      this.showOrderDetailsModal = true;
    },
    deleteOrder(orderId) {
      this.orderData = this.orderData.filter(order => order.id !== orderId);
      console.log('Order deleted:', orderId);
    },
    prevPage() {
      if (this.currentPage > 1) this.currentPage--;
    },
    nextPage() {
      if (this.currentPage < this.totalPages) this.currentPage++;
    },
    prevCartPage() {
      if (this.currentCartPage > 1) this.currentCartPage--;
    },
    nextCartPage() {
      if (this.currentCartPage < this.totalCartPages) this.currentCartPage++;
    },
    sortDate(direction) {
      this.sortDirection = direction;
      this.orderData.sort((a, b) => {
        const dateA = new Date(a.shipping_date.split('-').reverse().join('-'));
        const dateB = new Date(b.shipping_date.split('-').reverse().join('-'));
        return direction === 'asc' ? dateA - dateB : dateB - dateA;
      });
    },
    calculateTotalRevenue() {
      // Triggers the recalculation of `totalRevenue` based on selectedMonth
    },
  },
};
</script>



<style scoped>
.container {
  margin: 20px auto;
  max-width: 1200px;
  padding: 15px;
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.header h1 {
  font-size: 2rem;
  font-weight: bold;
  color: #333;
  margin-bottom: 20px;
}
/* Card and Table */
.card {
  background: #fff;
  border-radius: 8px;
  padding: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.table-responsive {
  margin-top: 10px;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin: 20px 0;
}

thead th {
  background-color: #007bff;
  color: #fff;
  text-align: left;
  padding: 10px;
}

tbody td {
  padding: 10px;
  border-top: 1px solid #ddd;
  vertical-align: middle;
}

tbody tr:nth-child(odd) {
  background-color: #f9f9f9;
}

.text-danger {
  font-weight: bold;
  color: #e3342f;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
}

.pagination button {
  border: none;
  background-color: transparent;
  color: #007bff;
  font-size: 1.5rem;
  cursor: pointer;
  margin: 0 10px;
}

.pagination span {
  font-size: 1.2rem;
  color: #333;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: #fff;
  padding: 30px;
  border-radius: 12px;
  width: 100%;
  max-width: 500px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.modal-content h2 {
  margin-bottom: 20px;
  font-size: 1.8rem;
  color: #333;
}

.modal-content p {
  margin-bottom: 10px;
  font-size: 1rem;
  color: #555;
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
  color: #007bff;
  transition: color 0.3s ease;
}
button {
  background-color: transparent;
  border: none;
  cursor: pointer;
}

button:hover {
  color: #007bff;
}

.fa-circle-info {
  color: #007bff;
}

.fa-circle-info:hover {
  color: #0056b3;
}

/* Responsive Design */
@media (max-width: 768px) {
  .header h1 {
    font-size: 1.5rem;
  }

  table {
    font-size: 0.9rem;
  }

  .modal-content {
    padding: 15px;
  }
}
</style>