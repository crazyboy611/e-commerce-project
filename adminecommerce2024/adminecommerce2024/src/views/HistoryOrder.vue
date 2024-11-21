<template>
  <div class="container">
    <div class="header d-flex">
      <div>
        <h1>History Orders</h1>
      </div>
      <div class="select-month">
        <p class="fs-4 me-5">
          Total revenue month
          <select v-model="selectedMonth" @change="calculateTotalRevenue">
            <option v-for="month in months" :key="month" :value="month">{{ month }}</option>
          </select>
          year
          <input type="text" v-model="searchQueryYear" class="input-year" />
          :
          <span class="text-danger fw-bold">$</span>
          <span class="fw-bold">{{ totalRevenue.toFixed(2) }}</span>
        </p>
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
              <th class="date-header">
                Date
                <div class="sort-buttons">
                  <button @click="sortDate('asc')" class="sort-btn"><i
                      class="fa-solid fa-arrow-up text-light"></i></button>
                  <button @click="sortDate('desc')" class="sort-btn"><i
                      class="fa-solid fa-arrow-down text-light"></i></button>
                </div>
              </th>
              <th>Payment Method</th>
              <th>Address</th>
              <th>Shipment</th>
              <th>Total Money</th>
              <th>Detail</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(order, index) in paginatedOrders" :key="order.id" class="fw-bold">
              <td>{{ order.id }}</td>
              <td class="text-secondary flex-nowrap">{{ order.shipping_date }}</td>
              <td>{{ order.payment_method }}</td>
              <td class="">{{ order.shipping_address }}</td>
              <td>{{ order.shipping_method }}</td>
              <td class="text-danger fs-5">${{ order.total_money }}</td>
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
        <p><strong>Payment Method:</strong> {{ selectedOrder.payment_method }}</p>
        <p><strong>Discount Code:</strong> {{ 'null' }}</p>
        <p><strong>Address:</strong> {{ selectedOrder.shipping_address }}</p>
        <p><strong>Shipment:</strong> {{ selectedOrder.shipping_method}}</p>
        <span><strong>Price shipment:</strong> ${{ selectedOrder.order_details?.[0].unit_price }}</span>
        <p class="border rounded p-3 mt-3"><strong>Total Amount:</strong> <span class="fw-bold text-danger">${{
          selectedOrder.total_money }}</span></p>
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
    margin: 50px auto;
    max-width: 1200px;
    padding: 20px;
    background-color: #f5f7fa;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
  }

  h1 {
    font-size: 2.5rem;
    color: #333;
    font-weight: 700;
    letter-spacing: 1px;
  }

  .card {
    background-color: #fff;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  }

  table {
    width: 100%;
    border-collapse: collapse;
    font-family: 'Arial', sans-serif;
  }

  .table-responsive {
    overflow-x: auto;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    text-align: left;
    font-size: 16px;
    min-width: 600px;
    /* Ensures the table won't shrink too much */
  }

  table th,
  table td {
    padding: 12px;
    border-bottom: 1px solid #ddd;
  }

  th {
    background-color: #f4f4f4;
  }

  th,
  td {
    padding: 15px;
    text-align: left;
    border-bottom: 1px solid #ddd;
  }

  th {
    background-color: #343a40;
    color: #fff;
    letter-spacing: 0.05rem;
  }

  td {
    color: #333;
    font-size: 1rem;
  }

  tr:hover {
    background-color: #f9f9f9;
    transition: background-color 0.3s ease;
  }

  tr:nth-child(even) {
    background-color: #f2f2f2;
  }

  .delete-btn i,
  .delete-btn:hover i {
    color: #e74c3c;
    font-size: 1.2rem;
    transition: color 0.3s ease;
  }

  button i {
    font-size: 1.1rem;
  }

  button:hover {
    color: #007bff;
  }

  button:focus {
    outline: none;
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

  /* Modal Styling */
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

  /* Responsive Design */
  @media (max-width: 768px) {
    h1 {
      font-size: 2rem;
    }

    table {
      font-size: 0.9rem;
    }

    th,
    td {
      padding: 10px;
    }

    .modal-content {
      width: 90%;
      max-width: 350px;
    }
  }

  @media (max-width: 576px) {
    table {
      font-size: 0.85rem;
      overflow-x: auto;
    }

    .modal-content {
      width: 95%;
    }

    .modal-content h2 {
      font-size: 1.5rem;
    }
  }

  button {
    border: none;
    background-color: transparent;
    cursor: pointer;
  }

  button:hover {
    background-color: rgba(0, 0, 0, 0.05);
    border-radius: 5px;
  }

  li {
    border: 1px solid rgb(218, 217, 217);
    list-style-type: none;
    border-radius: 10px;
    padding: 10px;
    margin: 5px 0;
  }

  .table-responsive {
    width: 100%;
    overflow-x: auto;
    /* Makes the table scrollable on smaller screens */
  }

  @media (max-width: 768px) {
    table {
      font-size: 0.9rem;
      display: block;
      /* Makes the table responsive */
      overflow-x: auto;
      /* Enables horizontal scroll */
    }

    th,
    td {
      white-space: nowrap;
      /* Prevents text wrapping */
    }
  }

  /* Pagination for cart items */
  .pagination {
    display: flex;
    justify-content: center;
    margin-top: 15px;
  }

  .pagination button {
    background: none;
    border: none;
    color: #007bff;
    font-size: 1.5rem;
    cursor: pointer;
    margin: 0 5px;
  }

  .pagination button:disabled {
    color: #ccc;
  }

  .pagination span {
    font-size: 1.2rem;
  }

  .date-header {
    white-space: nowrap;
    /* Prevents text from wrapping to a new line */
    text-align: left;
    /* Aligns the text to the left */
  }

  .sort-buttons {
    display: inline-flex;
    /* Ensures the buttons stay inline with the text */
    gap: 5px;
    /* Adds some spacing between the buttons */
  }

  .sort-btn {
    border: none;
    background: none;
    padding: 0;
    cursor: pointer;
  }

  .select-month {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
    font-family: Arial, sans-serif;
  }

  .select-month p {
    margin: 0;
    font-size: 1.25rem;
    color: #333;
  }

  .select-month select {
    margin: 0 8px;
    padding: 4px 8px;
    font-size: 1rem;
    border: 1px solid #ccc;
    border-radius: 4px;
    background-color: #f8f9fa;
    color: #333;
    cursor: pointer;
    outline: none;
    transition: border-color 0.3s ease;
  }

  .select-month select:hover {
    border-color: #007bff;
  }

  .text-danger {
    color: #dc3545;
  }

  .fw-bold {
    font-weight: bold;
  }

  .input-year {
    width: 90px;
    margin: 0 8px;
    padding: 4px 8px;
    font-size: 1rem;
    border: 1px solid #ccc;
    border-radius: 4px;
    background-color: #f8f9fa;
    color: #333;
    cursor: pointer;
    outline: none;
    transition: border-color 0.3s ease;
  }
</style>