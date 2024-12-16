<template>
  <div class="container">
    <div class="header">
      <h1>History Orders</h1>
      <input type="text" v-model="searchQuery" placeholder="Search by Order ID" class="form-control mb-4"
        @change="searchOrderId" />
    </div>
    <div class="card">
      <div class="table-responsive">
        <table v-if="orderData">
          <thead>
            <tr>
              <th>Order ID</th>
              <th>Order date</th>
              <th>Shipping date</th>
              <th>Provider</th>
              <th>Status</th>
              <th>Paid</th>
              <th>Total Money</th>
              <th>Detail</th>
              <th>Edit status</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(order, index) in orderData" :key="order.id"
              :class="{ 'bg-danger': order.status == 'cancelled', 'bg-success': order.status == 'delivered' }">
              <td>{{ order.id }}</td>
              <td>{{ order.order_date.split('T')[0] }}</td>
              <td>{{ order.shipping_date }}</td>
              <td>{{ order.payment_details.provider }}</td>
              <td>{{ order.status }}</td>
              <!-- <td v-if="order.payment_details.paid == true" class="text-success fw-bold">{{ order.payment_details.paid
                }}</td>
              <td v-else class="text-danger fw-bold">{{ order.payment_details.paid }}</td> -->
              <td>{{ order.payment_details.paid }}</td>
              <td class="">{{ order.payment_details.amount.toFixed(3) }} VND</td>
              <td>
                <button @click="viewOrderDetails(order)"><i class="fa-solid fa-circle-info"></i></button>
              </td>
              <td>
                <button @click="editStatus(order)"><i class="fa-solid fa-pencil"></i></button>
              </td>
            </tr>
          </tbody>
        </table>
        <table v-else-if="orderSearchData">
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
            <tr>
              <td>{{ orderSearchData.id }}</td>
              <td>{{ orderSearchData.order_date.split('T')[0] }}</td>
              <td>{{ orderSearchData.shipping_date }}</td>
              <td>{{ orderSearchData.payment_details.provider }}</td>
              <td>{{ orderSearchData.status }}</td>
              <td class="">{{ orderSearchData.shipping_address }}</td>
              <td class="text-danger">{{ orderSearchData.payment_details.amount.toFixed(3) }} VND</td>
              <td>
                <button @click="viewOrderDetails(orderSearchData)"><i class="fa-solid fa-circle-info"></i></button>
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
        <p><strong>Cart Items:</strong></p>
        <ul>
          <li v-for="item in selectedOrder.order_details" :key="item.product_id">
            <div class="card my-2">
              <span>{{ item.product_name }} <img :src="`http://localhost:8080/api/v1/products/images/${item.thumbnail}`"
                  alt="Product Thumbnail" width="50"></span>
              <span><strong>Quantity:</strong> {{ item.quantity }}</span>
              <span><strong>Price:</strong> {{ item.price.toFixed(3) }} VND</span>
            </div>
          </li>
        </ul>
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
      orderSearchData: [],
      showOrderDetailsModal: false,
      selectedOrder: null,
      currentPage: 1,
      itemsPerPage: 10,
      totalPages: 0,
      currentCartPage: 1,
      cartItemsPerPage: 3,
      sortDirection: '',
      searchQuery: '',
    };
  },
  mounted() {
    this.fetchHistoryOrder();
  },
  methods: {
    async fetchHistoryOrder() {
      try {
        const response = await axios.get(`http://localhost:8080/api/v1/orders?size=${this.itemsPerPage}&page=${this.currentPage - 1}`, {
          headers: {
            'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
            'Accept': '*/*'
          }
        });
        if (response.data.status === 200) {
          this.orderData = response.data.data.orders;
          this.totalPages = response.data.data.total_pages;
        } else {
          console.log(response.data.message)
        }
      } catch (error) {

      }
    },
    async searchOrderId() {
      try {
        if (this.searchQuery) {
          const response = await axios.get(`http://localhost:8080/api/v1/orders/${this.searchQuery}`, {
            headers: {
              'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
            }
          });
          this.orderSearchData = response.data.data;
          this.orderData = null;
        }
        else {
          this.orderSearchData = null;
          this.fetchHistoryOrder();
        }
      }
      catch (error) {
        console.log(error);
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
      if (this.currentPage > 1) {
        this.currentPage--;
        this.fetchHistoryOrder();
      }
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
        this.fetchHistoryOrder();
      }
    },
  },
};
</script>



<style scoped>
li {
  list-style-type: none;
}

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
  background-color: #343a40;
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
  color: #343a40;
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
  color: #343a40;
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