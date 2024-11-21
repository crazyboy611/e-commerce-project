<template>
  <div class="container">
      <h1>Payment VNPay</h1>
      <p><span>Order: </span>{{ orderId }}</p>
      <p><span>Amount: </span>{{ amount }} VND</p>
      <button @click="paymentVNPay" class="btn btn-primary">
          Pay with VNPay
          <div class="spinner-border text-primary" v-if="loading" role="status">
              <span class="visually-hidden">Loading...</span>
          </div>
      </button>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'TransferVNPay',
  data() {
      return {
          orderId: null,
          amount: null,
          loading: false
      };
  },
  created() {
      const orderTransfer = JSON.parse(sessionStorage.getItem('OrderTransfer'));
      
      if (orderTransfer) {
          this.orderId = orderTransfer.id;
          this.amount = orderTransfer.amount;
      } else {
          console.error("No order transfer data found.");
      }
  },
  methods: {
      async paymentVNPay() {
          this.loading = true;
          try {
              const response = await axios.post(`http://localhost:8080/api/v1/orders/checkout/vn-pay?order_id=${this.orderId}&amount=${this.amount}`);
              
              if (response.data.status === 200 && response.data.data) {
                  // Redirect to the VNPay URL provided in the response
                  window.location.href = response.data.data;
              } else {
                  console.error("Payment initiation failed:", response.data.message);
              }
          } catch (error) {
              console.error("Error during VNPay payment process:", error);
          } finally {
              this.loading = false;
          }
      }
  }
};
</script>

<style scoped>
.container {
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
  text-align: center;
}
</style>
