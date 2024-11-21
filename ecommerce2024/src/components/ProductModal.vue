<template>
  <div class="modal fade show d-block" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header d-flex justify-content-between align-items-center">
          <h5 class="modal-title">{{ product.name }}</h5>
          <button type="button" class="close btn btn-danger" @click="$emit('close')">
            <i class="fa-solid fa-xmark"></i>
          </button>
        </div>
        <div class="modal-body">
          <div class="row">
            <div class="col-md-6 text-center">
              <img :src="product.image" class="img-fluid" :alt="product.name">
              <!-- Small image selection -->
              <div class="small-images mt-2">
                <img v-for="image in product.additionalImages" :src="image" class="img-thumbnail" :alt="product.name" style="width: 60px; margin-right: 5px;">
              </div>
            </div>
            <div class="col-md-6">
              <h3 class="price text-danger">{{ product.price.toLocaleString() }}₫</h3>
              <p class="text-muted">Giá cũ: <del>{{ product.oldPrice.toLocaleString() }}₫</del></p>
              <p class="text-muted">{{ product.description }}</p>
              <ul>
                <li v-for="detail in product.details">{{ detail }}</li>
              </ul>
              <!-- Color options -->
              <div class="color-options mt-3">
                <h5>Màu sắc:</h5>
                <button v-for="color in product.colors" :key="color" class="btn btn-outline-secondary me-2">{{ color }}</button>
              </div>
              <!-- Quantity selection -->
              <div class="quantity mt-3">
                <h5>Số lượng:</h5>
                <div class="input-group">
                  <button class="btn btn-outline-secondary" @click="decreaseQuantity">-</button>
                  <input type="text" class="form-control text-center" v-model="quantity">
                  <button class="btn btn-outline-secondary" @click="increaseQuantity">+</button>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer d-flex">
          <button type="button" class="btn btn-warning" @click="addToCart"><i class="fa-solid fa-cart-shopping"></i> Thêm vào giỏ hàng</button>
          <button type="button" class="btn btn-primary">Purchase</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ProductModal',
  emits: ['close'],
  props: {
    product: {
      type: Object,
      required: true,
      validator(value) {
        return ['name', 'image', 'description', 'additionalImages', 'price', 'oldPrice', 'details', 'colors'].every(key => key in value);
      }
    },
  },
  data() {
    return {
      quantity: 1,
    };
  },
  methods: {
    increaseQuantity() {
      this.quantity++;
    },
    decreaseQuantity() {
      if (this.quantity > 1) this.quantity--;
    },
    addToCart() {
      // Logic to add product to cart with selected quantity
      console.log(`Added ${this.quantity} of ${this.product.name} to cart`);
    },
  },
};
</script>

<style scoped>
.modal {
  background-color: rgba(0, 0, 0, 0.5);
}

.modal-dialog {
  max-width: 800px;
}

.price {
  font-size: 24px;
}

.small-images img {
  cursor: pointer;
  border: 1px solid #ddd;
}

.color-options button {
  margin-bottom: 5px;
}
</style>
