<template>
  <div class="container">
    <div class="header">
      <h1 class="text-start">Orders Users</h1>
    </div>
    <div class="search-sort">
      <input type="text" v-model="searchQuery" placeholder="Search product or User..." class="form-control mb-3" />
    </div>
    <div class="card">
      <div class="table-responsive">
        <table v-if="filteredOrders.length">
          <thead>
            <tr>
              <th>Order ID</th>
              <th>Full Name</th>
              <th>Phone</th>
              <th>Total Money</th>
              <th>Number of Deliveries</th>
              <th class="date-header">
                Date of Delivery
                <div class="sort-buttons">
                  <button @click="sortDate('asc')" class="sort-btn"><i class="fa-solid fa-arrow-up"></i></button>
                  <button @click="sortDate('desc')" class="sort-btn"><i class="fa-solid fa-arrow-down"></i></button>
                </div>
              </th>
              <th>Status</th>
              <th>Detail</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(order, index) in paginatedOrders" :key="order.orderId"
              :class="{ 'danger': order.deliveryCount > 5, 'success': order.status === 'success', 'warning': order.status === 'delivering' }">
              <td>{{ order.orderId }}</td>
              <td style="white-space: nowrap;">{{ order.fullName }}</td>
              <td style="white-space: nowrap;">{{ maskPhone(order.phone) }}</td>
              <td>${{ order.totalAmount }}</td>
              <td class="text-center">
                <input type="text" v-model.number="order.deliveryCount" @input="checkDeliveryCount(order)"
                  class="input-delivery-count" />
              </td>
              <td>{{ order.date }}</td>
              <td>
                <span :class="{
                  'delivering-warning': order.status === 'delivering',
                  'success-success': order.status === 'success',
                  'cancel-danger': order.status === 'cancelled'
                }">
                  {{ order.status === 'cancelled' ? 'Cancelled' : (order.status === 'success' ? 'Completed' :
                    'Delivering') }}
                </span>
              </td>
              <td>
                <button @click="viewOrderDetails(order)">
                  <i class="fa-solid fa-circle-info"></i>
                </button>
              </td>
              <td class="check">
                <template v-if="order.status === 'delivering'">
                  <input type="checkbox" @click.stop="confirmSuccess(order)" class="checkbox-delivering"
                    :checked="order.status === 'success'" />
                </template>

                <template v-else-if="order.status === 'success'">
                  <input type="checkbox" class="checkbox-delivering" checked disabled />
                </template>

                <template v-else>
                  <i class="fa-solid fa-xmark fs-5 text-danger fw-bold"></i>
                </template>
              </td>

            </tr>
          </tbody>
        </table>
        <p v-else class="text-center">No orders found</p>
      </div>
    </div>

    <!-- Pagination controls -->
    <div class="pagination">
      <button :disabled="currentPage === 1" @click="prevPage">
        <i class="fa-solid fa-chevron-left"></i>
      </button>
      <span>{{ currentPage }}/{{ totalPages }}</span>
      <button :disabled="currentPage === totalPages" @click="nextPage">
        <i class="fa-solid fa-chevron-right"></i>
      </button>
    </div>

    <!-- Order Details Modal -->
    <div v-if="showOrderDetailsModal" class="modal" @click.self="closeModal">
      <div class="modal-content">
        <span class="close fs-3 fw-bold" @click="closeModal">&times;</span>
        <h2>Order Details</h2>
        <p><strong>Order ID:</strong> {{ selectedOrder.orderId }}</p>
        <p><strong>Payment Method:</strong> {{ selectedOrder.paymentMethod }}</p>
        <p><strong>Discount Code:</strong> {{ selectedOrder.discountCode[0].code }}</p>
        <p><strong>Address:</strong> {{ selectedOrder.selectedAddress.detail }}</p>
        <p><strong>Email:</strong> {{ maskPhone(selectedOrder.email) }}</p>
        <p><strong>Shipment:</strong> {{ selectedOrder.selectedShipment.desc }}</p>
        <span><strong>Price Shipment:</strong> ${{ selectedOrder.selectedShipment.price }}</span>
        <p class="border rounded p-3 mt-3"><strong>Total Amount:</strong> <span class="fw-bold text-danger">${{
          selectedOrder.totalAmount }}</span></p>
      </div>
    </div>
    <!-- Product Details Modal -->
    <div v-if="showProductDetailsModal" class="modal" @click.self="closeProductModal">
      <div class="modal-content">
        <span class="close fs-3 fw-bold" @click="closeProductModal">&times;</span>
        <h2>Product Details</h2>
        <img :src="selectedProduct.image" alt="Product Image" class="img-fluid mb-3" />
        <p><strong>Product Name:</strong> {{ selectedProduct.name }}</p>
        <p><strong>Price:</strong> ${{ selectedProduct.price }}</p>
        <p><strong>Average Rating:</strong> {{ selectedProductAverageRating }}</p>
      </div>
    </div>
  </div>
</template>


<script>
export default {
  name: 'OrdersUsers',
  data() {
    return {
      orders: [
        // Sample data for testing
        {
          orderId: '12345',
          fullName: 'John Doe',
          phone: '123-456-7890',
          email: 'john@example.com',
          totalAmount: 100.0,
          deliveryCount: 3,
          status: 'delivering',
          date: '18-09-2024',
          selectedAddress: { detail: '123 Main St, Cityville' },
          selectedShipment: { desc: 'Express shipping', price: 10 },
          paymentMethod: 'Credit Card',
          discountCode: [{ code: 'SAVE10' }],
        },
        {
          orderId: '12345',
          fullName: 'John Doe',
          phone: '123-456-7890',
          email: 'john@example.com',
          totalAmount: 100.0,
          deliveryCount: 3,
          status: 'success',
          date: '18-09-2024',
          selectedAddress: { detail: '123 Main St, Cityville' },
          selectedShipment: { desc: 'Express shipping', price: 10 },
          paymentMethod: 'Credit Card',
          discountCode: [{ code: 'SAVE10' }],
        },
        {
          orderId: '67890',
          fullName: 'Jane Smith',
          phone: '987-654-3210',
          email: 'jane@example.com',
          totalAmount: 200.0,
          deliveryCount: 6,
          status: 'cancelled',
          date: '09-11-2023',
          selectedAddress: { detail: '456 Another St, Townsville' },
          selectedShipment: { desc: 'Standard shipping', price: 5 },
          paymentMethod: 'PayPal',
          discountCode: [{ code: 'OFF20' }],
        },
        {
          orderId: '12345',
          fullName: 'John Doe',
          phone: '123-456-7890',
          email: 'john@example.com',
          totalAmount: 100.0,
          deliveryCount: 4,
          status: 'success',
          date: '18-09-2024',
          selectedAddress: { detail: '123 Main St, Cityville' },
          selectedShipment: { desc: 'Express shipping', price: 10 },
          paymentMethod: 'Credit Card',
          discountCode: [{ code: 'SAVE10' }],
        },
        {
          orderId: '12345',
          fullName: 'John Doe',
          phone: '123-456-7890',
          email: 'john@example.com',
          totalAmount: 100.0,
          deliveryCount: 1,
          status: 'success',
          date: '12-10-2024',
          selectedAddress: { detail: '123 Main St, Cityville' },
          selectedShipment: { desc: 'Express shipping', price: 10 },
          paymentMethod: 'Credit Card',
          discountCode: [{ code: 'SAVE10' }],
        },
        {
          orderId: '12345',
          fullName: 'John Doe',
          phone: '123-456-7890',
          email: 'john@example.com',
          totalAmount: 100.0,
          deliveryCount: 2,
          status: 'delivering',
          date: '09-11-2024',
          selectedAddress: { detail: '123 Main St, Cityville' },
          selectedShipment: { desc: 'Express shipping', price: 10 },
          paymentMethod: 'Credit Card',
          discountCode: [{ code: 'SAVE10' }],
        },
      ],
      paginatedOrders: [],
      currentPage: 1,
      itemsPerPage: 5,
      showOrderDetailsModal: false,
      selectedOrder: {},
      sortDirection: '',
      searchQuery: '',
    };
  },

  computed: {
    totalPages() {
      return Math.ceil(this.filteredOrders.length / this.itemsPerPage);
    },
    paginatedOrders() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      return this.filteredOrders.slice(start, start + this.itemsPerPage);
    },
    filteredOrders() {
      const query = this.searchQuery.toLowerCase();
      return this.orders.filter(order => {
        return (
          order.fullName.toLowerCase().includes(query) ||
          order.orderId.includes(query) // Adjust this to match the fields you want to search
        );
      });
    },
    totalDeliveriesSuccess() {
      return this.filteredOrders.filter(order => order.status === 'success').length;
    },
    totalDeliveriesCancelled() {
      return this.filteredOrders.filter(order => order.status === 'cancelled').length;
    },
  },

  methods: {
    sortDate(direction) {
      this.sortDirection = direction;
      this.orders.sort((a, b) => {
        const dateA = new Date(a.date.split('-').reverse().join('-'));
        const dateB = new Date(b.date.split('-').reverse().join('-'));
        return direction === 'asc' ? dateA - dateB : dateB - dateA;
      });
      this.updatePaginatedOrders();
    },

    updatePaginatedOrders() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      const end = start + this.itemsPerPage;
      this.paginatedOrders = this.orders.slice(start, end);
    },

    confirmSuccess(order) {
      const confirmed = confirm('You confirm success delivery?');
      if (confirmed) {
        order.status = 'success';
        this.updatePaginatedOrders(); // Update the displayed orders
      }
    },

    viewOrderDetails(order) {
      this.selectedOrder = order;
      this.showOrderDetailsModal = true;
    },

    deleteOrder(orderId) {
      this.orders = this.orders.filter(order => order.orderId !== orderId);
      this.updatePaginatedOrders();
    },

    closeModal() {
      this.showOrderDetailsModal = false;
    },

    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
      }
    },

    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
      }
    },
    maskPhone(phone) {
      return `${phone.slice(0, 3)}****${phone.slice(-3)}`;
    },
    maskEmail(email) {
      const [user, domain] = email.split('@');
      return `${user.slice(0, 1)}****${user.slice(50)}@${domain}`;
    },
    closeModal() {
      this.showOrderDetailsModal = false;
    },

    closeProductModal() {
      this.showProductDetailsModal = false;
    },
    checkDeliveryCount(order) {
      // Limit delivery attempts to a maximum of 3
      if (order.deliveryCount < 0) {
        order.deliveryCount = 0;
      }

      // Update order status based on delivery count
      if (order.deliveryCount > 5) {
        order.status = 'cancelled'; // e.g., failed after 3 attempts
      }
    }
  },

  mounted() {
    this.updatePaginatedOrders();
  },

};
</script>


<style scoped>
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.header {
  text-align: center;
  margin-bottom: 20px;
}

.header h1 {
  font-size: 2.5rem;
  font-weight: bold;
  color: #343a40;
}

.card {
  background-color: white;
  border-radius: 10px;
  padding: 20px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.table-responsive {
  max-width: 100%;
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  padding: 12px 15px;
  text-align: left;
  border-bottom: 1px solid #dee2e6;
}

thead th {
  background-color: #343a40;
  color: white;
  font-weight: 600;
}

tbody tr {
  background-color: white;
  transition: background-color 0.3s ease;
}

th.date-header {
  position: relative;
}

.sort-buttons {
  display: inline-block;
  margin-left: 10px;
}

.sort-btn {
  background: none;
  border: none;
  cursor: pointer;
  color: white;
  font-size: 0.9rem;
  margin-left: 5px;
}

.sort-btn:hover {
  color: #ffc107;
}

td {
  font-size: 1rem;
  color: #495057;
}

tbody .warning {
  background-color: #fff3cd;
}

tbody .danger {
  background-color: #f8d7da;
  color: #721c24;
}

.delivering-warning {
  color: #fd7e14;
}

.success-success {
  color: #28a745;
}

.success {
  background-color: #74f392;
}

.warning {
  background-color: #ffc107;
}

.cancel-danger {
  color: #dc3545;
}

button {
  background: none;
  border: none;
  cursor: pointer;
}

button i {
  font-size: 1.2rem;
}

button:hover i {
  color: #007bff;
}

.delete-btn {
  color: #dc3545;
}

.delete-btn[disabled] {
  cursor: not-allowed;
  opacity: 0.6;
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

.modal-content span {
  font-size: 1.1rem;
  margin-top: 10px;
}

.fw-bold {
  font-weight: bold;
}

.text-danger {
  color: #dc3545;
}
.input-delivery-count {
  width: 50px;               /* Adjust width */
  padding: 5px;              /* Inner spacing */
  text-align: center;        /* Center text for better alignment */
  border: 1px solid #ddd;    /* Light border color */
  border-radius: 4px;        /* Rounded corners */
  outline: none;             /* Remove outline */
  transition: box-shadow 0.3s ease; /* Smooth shadow on focus */
}

/* Focus effect */
.input-delivery-count:focus {
  box-shadow: 0 0 5px rgba(0, 123, 255, 0.5); /* Blue shadow on focus */
  border-color: #007bff; /* Blue border on focus */
}

/* Styling for specific values (optional) */
.input-delivery-count:invalid {
  border-color: #e74c3c; /* Red border for invalid input */
}


/* Disabled checkbox styling */
.checkbox-delivering:disabled {
  background-color: #e0e0e0;
  border-color: #ccc;
  cursor: not-allowed;
}

/* Danger styling for red 'X' icon */
.checkbox-danger {
  color: red;
  font-size: 1.5em;
  font-weight: bold;
  display: inline-block;
}

/* Container for the cards */
.card-total {
  padding: 20px;
  border-radius: 10px;
  margin: 10px 0;
  transition: transform 0.3s;
}

/* Card hover effect */
.card-total:hover {
  transform: scale(1.05);
}

/* Delivery success card styling */
.total-delivery-success {
  background-color: #4CAF50;
  /* Green */
  color: white;
  border: 1px solid #388E3C;
  /* Darker green */
}

/* Delivery cancelled card styling */
.total-delivery-cancelled {
  background-color: #F44336;
  /* Red */
  color: white;
  border: 1px solid #D32F2F;
  /* Darker red */
}

/* Search input styling */
.search-sort {
  margin: 20px 0;
}

.search-sort input {
  padding: 10px;
  border: 1px solid #ccc;
  border-radius: 5px;
  width: 100%;
  /* Full width for responsiveness */
}

.search-sort input:focus {
  border-color: #66afe9;
  /* Blue border on focus */
  outline: none;
  /* Remove default outline */
}

/* Font size adjustment */
.fs-5 {
  font-size: 1.25rem;
  /* Font size for delivery count */
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .card {
    margin: 10px;
    /* Margin adjustment for smaller screens */
  }
}

a {
  text-decoration: none;
}
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}
.pagination button {
  background-color: #343a40;
  color: white;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  display: flex;
  justify-content: center;
  align-items: center;
  border: none;
  margin: 0 10px;
  font-size: 1.2rem;
  transition: background-color 0.3s ease;
}

.pagination button:disabled {
  background-color: #6c757d;
  cursor: not-allowed;
}

.pagination button:hover:not(:disabled) {
  background-color: #007bff;
}

.pagination span {
  font-size: 1.2rem;
  line-height: 40px;
}

/* General checkbox styling */
.checkbox-delivering {
  width: 20px;
  height: 20px;
  cursor: pointer;
  accent-color: #4CAF50;
  /* Green color for delivering */
  transition: all 0.3s ease;
  border-radius: 20px;
  border: none;
  outline-style: none;
}

/* Checkbox for success status */
.checkbox-delivering:checked {
  background-color: #4CAF50;
  /* Green background */
  border-color: #4CAF50;
  color: white;
}
</style>