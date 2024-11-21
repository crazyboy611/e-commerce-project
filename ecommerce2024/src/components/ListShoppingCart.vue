<template>
  <div class="d-flex justify-content-between flex-wrap my-5">
    <div class="my-5 list-cart">
      <!-- Loop through cartItems and display each product -->
      <div class="list-product list-group list-group-flush" v-for="(item, index) in cartItems" :key="index">
        <div class="d-flex align-items-center my-3">
          <div class="form-check" checkoutSelectedItems>
            <input type="checkbox" class="form-check-input" :id="'checkout-item-' + index" v-model="item.checked" />
          </div>
          <div class="me-3">
            <img :src="`http://localhost:8080/api/v1/products/images/${item.thumbnail}`" alt="Product Image" width="100px" />
          </div>
          <div class="me-3 flex-grow-1">
            <p class="product-name text-bold mb-0">{{ item.name }}</p>
            <p class="mb-0 text-muted"><span class="text-black fw-bold">Memory : </span>{{ item.memory }} - <span class="text-black fw-bold">Color : </span>{{ item.color }}</p>
          </div>
          <div class="quantity d-flex align-items-center me-3">
            <button class="btn btn-outline-secondary btn-quantity" @click="decreaseQuantity(item)"><i
                class="fa-solid fa-minus fw-bold"></i></button>
            <input type="text" class="form-control text-center quantity-input" v-model="item.quantity" readonly />
            <button class="btn btn-outline-secondary btn-quantity" @click="increaseQuantity(item)"><i
                class="fa-solid fa-plus fw-bold"></i></button>
          </div>
          <div class="price me-3">
            <p class="mb-0">{{ (item.price * item.quantity).toFixed(2) }} VND</p>
          </div>
          <div>
            <button class="close-btn" @click="removeFromCart(item)">
              <i class="fa-solid fa-xmark"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
    <div class="total">
      <div class="card p-3 mt-5">
        <div class="d-flex fs-5">
          <p class="me-5">SubTotal</p>
          <p class="ms-5">{{ calculateSubtotal() }} VND</p>
        </div>
        <button class="btn btn-dark mt-2" @click="checkoutSelectedItems">Check out</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ListShoppingCart',
  props: {
    cartItems: Array, // Accept cartItems as prop from parent, if necessary
  },
  data() {
    return {
      // Initialize cartItems as an empty array by default
      cartItems: [],
    };
  },
  created() {
    // Load cart data from sessionStorage if available
    const storedCart = sessionStorage.getItem('cartProducts');
    if (storedCart) {
      this.cartItems = JSON.parse(storedCart);
    }
    // Ensure each item has a default quantity of 1 if not already set
    this.cartItems.forEach(item => {
      if (!item.quantity || item.quantity < 1) {
        item.quantity = 1; // Directly set the quantity property
      }
    });
  },
  methods: {
    removeFromCart(product) {
      // Remove product from cartItems array
      const updatedCart = this.cartItems.filter(item => item.id !== product.id);
      this.cartItems = updatedCart;

      // Update sessionStorage with the modified cart items
      sessionStorage.setItem('cartProducts', JSON.stringify(this.cartItems));

      // Emit the updated cart items to notify parent components, if needed
      this.$emit('update-cart', this.cartItems);
    },
    increaseQuantity(item) {
      // Increment quantity
      item.quantity++;
      this.updateSessionStorage();
      this.$emit('update-cart', this.cartItems);
    },
    decreaseQuantity(item) {
      if (item.quantity > 1) {
        item.quantity--;
        this.updateSessionStorage();
        this.$emit('update-cart', this.cartItems);
      }
    },
    updateSessionStorage() {
      // Helper method to keep session storage in sync with cartItems
      sessionStorage.setItem('cartProducts', JSON.stringify(this.cartItems));
    },
    calculateSubtotal() {
      const total = this.cartItems.reduce((total, item) => total + (item.price * item.quantity), 0);
      return parseFloat(total.toFixed(2)); // Rounds to 2 decimal places and converts back to float
    },
    proceedToCheckout() {
      this.$router.push('/checkout');
    },
    checkoutSelectedItems() {
      // Create an array of selected items
      const selectedItems = this.cartItems.filter(item => item.checked);

      // Proceed only if there are selected items
      if (selectedItems.length === 0) {
        alert('Please select at least one item to check out.');
        return;
      }

      // You can adjust the data passed to the checkout page
      const checkoutData = selectedItems.map(item => ({
        id: item.id,
        name: item.name,
        quantity: item.quantity,
        price: item.price,
        total: (item.price * item.quantity).toFixed(2),
        thumbnail: item.thumbnail,
        color: item.color,
        memory: item.memory,
      }));
      sessionStorage.setItem('checkProductCart', JSON.stringify(checkoutData));
      this.$router.push({ name: 'Checkout' });
    },
  }
}
</script>



<style scoped>
a {
  text-decoration: none;
  font-size: 16px;
  color: white;
}

.container {
  max-width: 800px;
}

.list-cart {
  width: 70%;
}

.product-name {
  font-weight: 700;
  font-size: 18px;
}

.text-muted {
  font-size: 14px;
}

.list-product {
  border: none;
}

.btn-quantity {
  border: none;
  width: 30px;
  height: 30px;
  padding: 0;
}

.btn-quantity:hover {
  cursor: pointer;
  background-color: rgb(233, 230, 230);
  color: black;
}

.quantity-input {
  width: 50px;
  border: none;
  text-align: center;
}

.close-btn {
  border: none;
  background: none;
  padding: 0;
  font-size: 20px;
  width: 30px;
  height: 30px;
}

.close-btn:hover {
  cursor: pointer;
  color: black;
  background-color: rgb(233, 230, 230);
  border-radius: 10px;
}

.price {
  min-width: 80px;
}

.total {
  font-size: 18px;
}

.total p {
  font-weight: 500;
}

.total #discount-code {
  width: 100%;
  margin: 10px 0;
  padding: 10px 0 10px 10px;
  border: 1px solid rgb(216, 213, 213);
  border-radius: 10px;
  overflow: none;
}

.total label {
  font-weight: 500;
}

.total .my-4 {
  width: 100%;
  margin: 10px 0;
  padding: 10px 0 10px 10px;
  border: 1px solid rgb(216, 213, 213);
  border-radius: 10px;
  overflow: none;

}

.total .date {
  width: 45%;
  padding: 10px 0 10px 10px;
  border: 1px solid rgb(216, 213, 213);
  border-radius: 10px;
  overflow: none;
}

.total .cvv {
  width: 45%;
  padding: 10px 0 10px 10px;
  border: 1px solid rgb(216, 213, 213);
  border-radius: 10px;
  overflow: none;
}

.total button {
  width: 100%;
}

.error-message {
  margin: 10px 0;
  font-size: 14px;
}

.text-throught {
  text-decoration: line-through;
}
</style>
