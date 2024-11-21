<template>
  <div class="container">
    <div class="m-5">
      <div class="my-3 d-flex justify-content-between">
        <div v-for="(item, index) in steps" :key="index" class="d-flex align-items-center">
          <div>
            <i :class="item.icon" :style="{ opacity: currentStep === item.step ? 1 : 0.5 }"></i>
          </div>
          <div class="ms-2">
            <span :style="{ opacity: currentStep === item.step ? 1 : 0.5 }">{{ 'Step ' + item.step }}</span>
            <p class="fw-bold fs-5" :style="{ opacity: currentStep === item.step ? 1 : 0.5 }">{{ item.title }}</p>
          </div>
        </div>
      </div>

      <div class="my-5">
        <CheckoutShip v-if="currentStep === 1" v-model:selectedShipment="selectedShipment" />
        <CheckoutPayment
          v-if="currentStep === 2"
          :selectedAddress="selectedAddress"
          :selectedShipment="selectedShipment"
          :cartItems="selectedItems"
          :paymentMethod="paymentMethod"
          @proceed-to-checkout="handleCheckout"
          @update-order="updateOrder"
        />
      </div>

      <div class="my-3 d-flex justify-content-end">
        <button class="btn btn-light btn-outline-dark me-3" @click="goToPreviousStep">
          Back
        </button>
        <button
          class="btn btn-dark"
          v-if="currentStep < steps.length"
          @click="goToNextStep"
          :disabled="isNextDisabled"
        >
          Next
        </button>
        <button
          v-else
          class="btn btn-dark"
          @click="processPayment"
          :disabled="isNextDisabled"
        >
          Pay
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import CheckoutShip from "../components/CheckoutShip.vue";
import CheckoutPayment from "../components/CheckoutPayment.vue";

export default {
  name: "Checkout",
  components: {
    CheckoutShip,
    CheckoutPayment,
  },
  props: {
    product: String,
  },
  data() {
    return {
      currentStep: 1,
      selectedShipment: null,
      selectedItems: [],
      paymentMethod: null,
      steps: [
        {
          icon: "fa-solid fa-truck fs-4",
          step: 1,
          title: "Delivery",
        },
        {
          icon: "fa-solid fa-credit-card fs-4",
          step: 2,
          title: "Payment",
        },
      ],
    };
  },
  computed: {
    isNextDisabled() {
      return (this.currentStep === 1 && !this.selectedShipment) ||
        (this.currentStep === 2 && !this.paymentMethod);
    },
  },
  created() {
    const storedItems = sessionStorage.getItem("checkProductCart");
    if (storedItems) {
      this.selectedItems = JSON.parse(storedItems);
    }
  },
  methods: {
    goToNextStep() {
      if (this.currentStep < this.steps.length) {
        this.currentStep++;
      }
    },
    goToPreviousStep() {
      if (this.currentStep > 1) {
        this.currentStep--;
      } else {
        this.$router.push("/shopping-cart-view");
      }
    },
    processPayment() {
      console.log("Processing payment...");
      this.$router.push("/confirmation");
    },
    handleCheckout(orderDetails) {
      console.log("Order Details for Checkout:", orderDetails);
    },
    updateOrder(updateItem) {
      this.selectedItems = updateItem.cartItems;
      this.$emit("update-order", updateItem);
    },
  },
};
</script>
