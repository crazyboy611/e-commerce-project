<template>
  <div class="container">
      <ShoppingCart :cartItems="cartItems" />
      <ProductList @add-to-cart="addToCart" />
  </div>
</template>

<script>
import ProductList from '../components/ListProduct.vue';
import ShoppingCart from '../components/ListShoppingCart.vue';

export default {
  name:'ShoppingCartView',
  data() {
    return {
      cartItems: [] // Store the cart items here
    };
  },
  components: {
    ProductList,
    ShoppingCart
  },
  methods: {
    addToCart(product) {
      // Check if product already exists in cart
      const existingProduct = this.cartItems.find(item => item.id === product.id);
      if (existingProduct) {
        // If exists, increase quantity
        existingProduct.quantity++;
      } else {
        // Add product with quantity 1
        this.cartItems.push({ ...product, quantity: 1 });
      }
      console.log('Product added to cart:', this.cartItems);
    }
  }
}
</script>
