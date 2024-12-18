<template>
  <div class="container my-5">
    <h1>Lịch Sử Mua Hàng</h1>

    <!-- Tabs for filtering orders -->
    <div class="tabs">
      <div class="tab" :class="{ active: activeTab === 'all' }" @click="filterOrders('all')">Tất cả đơn hàng</div>
      <div class="tab" :class="{ active: activeTab === 'pending' }" @click="filterOrders('pending')">Chưa xử lý
      </div>
      <div class="tab" :class="{ active: activeTab === 'processing' }" @click="filterOrders('processing')">Đang xử lý
      </div>
      <div class="tab" :class="{ active: activeTab === 'shipped' }" @click="filterOrders('shipped')">Đang giao
        hàng</div>
      <div class="tab" :class="{ active: activeTab === 'delivered' }" @click="filterOrders('delivered')">Đã nhận hàng
      </div>
      <div class="tab" :class="{ active: activeTab === 'cancelled' }" @click="filterOrders('cancelled')">Đã hủy</div>
    </div>
    <div class="order-list">
      <div v-for="order in filteredOrders" :key="order.id" class="order-item">
        <div class="p_status d-flex justify-content-end">
          <div v-if="order.status === 'pending'">CHƯA XỬ LÝ</div>
          <div v-else-if="order.status === 'processing'">ĐANG XỬ LÝ</div>
          <div v-else-if="order.status === 'shipped'">ĐANG GIAO HÀNG</div>
          <div v-else-if="order.status === 'delivered '">ĐÃ NHẬN</div>
          <div v-else-if="order.status === 'cancelled'">ĐÃ HỦY</div>
        </div>
        <hr>
        <div class="product-list d-flex justify-content-between">
          <div>
            <div @click="showOrderDetails(order)" style="cursor: pointer;"><span><i class="fa-solid fa-circle-info fs-5 me-2"></i></span>OrderID: <span class="fw-bold">{{ order.id }}</span></div>
            <div>
              Order date: {{ formatDate(order.order_date.split('T')[0]) }} <br>
              Shipment date: {{ formatDate(order.shipping_date) }}
            </div>
            <div v-for="product in order.order_details" :key="product.id" class="product-item">
              <div class="d-flex align-items-center">
                <img :src="`http://localhost:8080/api/v1/products/images/${product.thumbnail}`"
                  :alt="product.product_name" />
                <div class="order-details">
                  <div class="product-name">{{ product.product_name }}</div>
                  <div class="product-quantity">Số lượng: {{ product.quantity }}</div>
                  <div class="product-price">Giá: {{ currencyFormat(product.price) }}</div>
                </div>
              </div>
              <div v-if="order.status === 'delivered' && order.payment_details.paid == true">
                <router-link :to="{ name: 'DetailProduct', params: { product: product.product_id } }">
                  <button class="review-button" @click="displayReviews">
                    Đánh giá
                  </button>
                </router-link>
              </div>
            </div>
          </div>
          <div>
            <div class="order-total">Tổng đơn hàng: {{ currencyFormat(order.payment_details.amount) }}</div>
            <div>
              <button v-if="order.status === 'shipped' && order.payment_details.paid ==true" class="received-button" @click="markAsReceived(order)">
                Đã nhận được hàng
              </button><br>
              <button v-if="order.status === 'pending'" class="buy-again-button" @click="markCancelled(order)">
                Huỷ
              </button><br>
              <button v-if="order.payment_details.paid === false && order.payment_details.provider == 'vnpay'"
                class="received-button" @click="paymentAgain(order.payment_details)">
                Thanh toán
              </button><br>
              <button v-if="order.status === 'cancelled' || order.status == 'delivered'" class="buy-again-button"
                @click="buyAgain(order.order_details)">
                Mua lại
              </button><br>

            </div>
          </div>
        </div>
      </div>
    </div>

    <div v-if="selectedOrder" class="modal">
      <div class="modal-content">
        <span class="close" @click="closeModal"><i class="fa-solid fa-xmark"></i></span>
        <h2>Chi tiết đơn hàng</h2>
        <p><strong>Người nhận:</strong> {{ selectedOrder.receiver_full_name }}</p>
        <p><strong>Số điện thoại:</strong> {{ selectedOrder.receiver_phone_number }}</p>
        <p><strong>Email người mua:</strong> {{ selectedOrder.buyer_email }}</p>
        <p><strong>Ghi chú:</strong> {{ selectedOrder.note || 'Không có ghi chú' }}</p>
        <p><strong>Ngày đặt hàng:</strong> {{ formatDate(selectedOrder.order_date.split('T')[0]) }}</p>
        <p><strong>Trạng thái:</strong> {{ selectedOrder.status }}</p>
        <p><strong>Tổng tiền:</strong> {{ currencyFormat(selectedOrder.payment_details.amount) }}</p>
        <p><strong>Phương thức vận chuyển:</strong> {{ selectedOrder.shipment.type }}</p>
        <p><strong>Địa chỉ nhận hàng:</strong> {{ selectedOrder.shipping_address }}</p>
        <p><strong>Ngày giao hàng:</strong> {{ formatDate(selectedOrder.shipping_date) }}</p>
        <p><strong>Phương thức thanh toán:</strong> {{ selectedOrder.payment_details.provider }}</p>
        <p v-if="selectedOrder.payment_details.paid == false" class="text-danger">Chưa thanh toán đơn hàng</p>
        <p v-else class="text-success">Đã thanh toán đơn hàng</p>
      </div>
    </div>


    <div class="pagination">
      <button :disabled="currentPage === 0" @click="changePage(currentPage - 1)">
        <i class="fa-solid fa-chevron-left"></i>
      </button>
      <span>Page {{ currentPage + 1 }} of {{ totalPages }}</span>
      <button :disabled="currentPage === totalPages - 1" @click="changePage(currentPage + 1)">
        <i class="fa-solid fa-chevron-right"></i>
      </button>
    </div>


  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      orders: [],
      activeTab: 'all',
      currentPage: 0,
      totalPages: 0,
      pageSize: 5,
      selectedOrder: null,
      selectedProduct: null,
      orderId: null,
      amount: null,
      loading: false
    };
  },
  computed: {
    filteredOrders() {
      if (this.activeTab === 'all') return this.orders;
      return this.orders.filter(order => order.status === this.activeTab);
    },
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
    async fetchOrders(status = 'all') {
      try {
        const statusParam = status !== 'all' ? `&status=${status}` : '';
        const response = await axios.get(`http://localhost:8080/api/v1/users/my-order?sort_by=orderDate&sort_dir=desc&size=${this.pageSize}&page=${this.currentPage}${statusParam}`, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          }
        });
        if (response.data && response.data.status === 200) {
          this.orders = response.data.data.orders;

          // Map pagination data from API response
          this.currentPage = response.data.data.page_no;
          this.pageSize = response.data.data.page_size;
          this.totalPages = response.data.data.total_pages;
          this.totalElements = response.data.data.total_elements;
        }
      } catch (error) {
        console.error('Error fetching orders:', error);
      }
    },
    changePage(page) {
      if (page >= 0 && page < this.totalPages) {
        this.currentPage = page;
        this.fetchOrders(this.activeTab);
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },
    filterOrders(status) {
      this.activeTab = status;
      this.currentPage = 0;
      this.fetchOrders(status);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    },
    async markAsReceived(order) {
      // console.log(order);
      try {
        const updateStatus = {
          orderId: order.id,
          status: 'delivered'
        };

        const response = await axios.put(
          `http://localhost:8080/api/v1/orders/update_status/${order.id}?status=delivered`,
          updateStatus,
          {
            headers: {
              Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
            },
          }
        );

        if (response.data && response.data.status === 200) {
          alert("Đã nhận đơn hàng thành công!");
          this.fetchOrders();
        } else {
          alert("Đã xảy ra lỗi khi nhận đơn hàng!");
        }
      } catch (error) {
        console.error("Error marking order as received:", error);
        if (error.response && error.response.status === 401) {
          alert("Authentication error: Please log in again.");
        } else {
          alert("An error occurred. Please try again.");
        }
      }
    },
    async markCancelled(order) {
      // console.log(order);
      try {
        const updateStatus = {
          orderId: order.id,
          status: 'cancelled'
        };

        const response = await axios.put(
          `http://localhost:8080/api/v1/orders/update_status/${order.id}?status=cancelled`,
          updateStatus,
          {
            headers: {
              Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
            },
          }
        );

        if (response.data && response.data.status === 200) {
          alert("Đã huỷ đơn hàng thành công!");
          this.fetchOrders();
        } else {
          alert("Đã xảy ra lỗi khi huỷ đơn hàng!");
        }
      } catch (error) {
        console.error("Error marking order as cancelled:", error);
        if (error.response && error.response.status === 401) {
          alert("Authentication error: Please log in again.");
        } else {
          alert("An error occurred. Please try again.");
        }
      }
    },
    selectProduct() {
      console.log("Selected product:", this.selectedProduct);
    },
    showOrderDetails(order) {
      this.selectedOrder = order;
    },
    closeModal() {
      this.selectedOrder = null;
    },
    buyAgain(orderDetails) {
      const checkoutData = orderDetails.map(detail => ({
        id: detail.product_id,
        name: detail.product_name,
        quantity: detail.quantity || 1,
        price: detail.price || 0,
        total: detail.price && detail.quantity
          ? detail.price * detail.quantity
          : 0,
        thumbnail: detail.thumbnail
      }));
      sessionStorage.setItem('checkProductCart', JSON.stringify(checkoutData));
      this.$router.push({ name: 'Checkout', params: { product: JSON.stringify(checkoutData) } });
    },
    async paymentAgain(payment_details) {
      this.orderId = payment_details.orderId;
      this.amount = payment_details.amount;
      const orderTransfer = {
        order_id: payment_details.orderId,
        amount: payment_details.amount
      }
      this.loading = true;
      try {
        const response = await axios.post(`http://localhost:8080/api/v1/orders/checkout/vn-pay?order_id=${this.orderId}&amount=${this.amount}`, orderTransfer, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          }
        });

        if (response.data.status === 200 && response.data.data) {
          window.location.href = response.data.data;
          this.$router.push({ name: 'TransferVNPayCallBack' });
        } else {
          console.error("Payment initiation failed:", response.data.message);
        }
      } catch (error) {
        console.error("Error during VNPay payment process:", error);
      } finally {
        this.loading = false;
      }
    },
    displayReviews() {
      sessionStorage.setItem('reviewsProducts', true);
    }
  },
  mounted() {
    this.fetchOrders();
  }
};
</script>



<style scoped>
.container {
  width: 80%;
  margin: auto;
}


.tabs {
  display: flex;
  gap: 10px;
  margin-top: 20px;
}

.tab {
  padding: 10px 20px;
  cursor: pointer;
  background-color: white;
}

.tab.active {
  background-color: white;
  border-bottom: 1px solid #ee4d2d;
  color: #ee4d2d;
}

.order-list {
  margin-top: 20px;
}

.order-item {
  padding: 15px;

  margin-bottom: 20px;
}

.product-list {

  gap: 10px;

}

.product-item {

  padding: 10px;
}

.product-item img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  margin-right: 10px;

}

.order-details {
  display: flex;
  flex-direction: column;
  /* Đặt hướng của các phần tử trong order-details thành cột */
  flex-grow: 1;
  /* Để phần chi tiết chiếm không gian còn lại */
}

.product-name {
  font-weight: bold;
}

.product-quantity,
.product-price {
  color: #666;
}

.received-button {
  padding: 5px 10px;
  width: 200px;
  background-color: #28a745;
  color: white;
  border: none;
  cursor: pointer;
  margin-top: 10px;
  border-radius: 5px;
}

.received-button:hover {
  background-color: #218838;
}

.p_status {
  color: #ee4d2d;
}

.buy-again-button {
  padding: 5px 10px;
  width: 200px;
  background-color: rgb(238, 77, 45);
  color: white;
  border: none;
  cursor: pointer;
  margin-top: 10px;
  border-radius: 5px;
}

.buy-again-button:hover {
  background-color: rgb(215, 50, 17);
  border-color: rgb(186, 43, 15);
}

.review-button {
  padding: 5px 10px;
  width: 200px;
  background-color: rgb(238, 77, 45);
  color: white;
  border: none;
  cursor: pointer;
  margin-top: 10px;
  border-radius: 5px;
}

.review-button:hover {
  background-color: rgb(215, 50, 17);
  border-color: rgb(186, 43, 15);
}

.pagination {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: 20px;
}

.pagination button {
  padding: 8px 16px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.pagination button:hover {
  background-color: #0056b3;
}

.pagination button:disabled {
  background-color: #d3d3d3;
  color: #ffffff;
  cursor: not-allowed;
  opacity: 0.7;
}

.modal {
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
}

.modal-content {
  background-color: #fff;
  padding: 20px;
  width: 80%;
  max-width: 500px;
  border-radius: 8px;
}

.close {
  position: absolute;
  top: 10px;
  right: 10px;
  cursor: pointer;
}
</style>