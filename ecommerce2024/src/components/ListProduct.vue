<template>
  <div class="container">
    <div class="d-flex mb-3 justify-content-between flex-wrap">
      <div class="dropdown">
        <a class="dropdown-toggle text-secondary" type="button" data-bs-toggle="dropdown" aria-expanded="false">
          Sort by
        </a>
        <ul class="dropdown-menu">
          <li><a class="dropdown-item" @click="sortBy('rating')">By Rating</a></li>
          <li><a class="dropdown-item" @click="sortBy('priceAsc')">By Price Increases</a></li>
          <li><a class="dropdown-item" @click="sortBy('priceDesc')">By Price Decreases</a></li>
        </ul>
      </div>
      <div id="search-input">
        <form class="ms-5 d-flex" id="search-input" @submit.prevent="emitSearch">
          <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search" v-model="search"
            @input="emitSearch">
          <i v-if="search == ''" class="fa-solid fa-magnifying-glass"></i>
        </form>
      </div>
      <div>
        <p>Selected Products: <span class="fw-bold">{{ totalElems }}</span></p>
      </div>
    </div>

    <div class="row my-5">
      <div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-3" v-for="(product, index) in products" :key="product.id">
        <div class="card h-100 d-flex flex-column">
          <div class="card-body d-flex flex-column">
            <i class="fas fa-heart text-end fs-5" @click="addToCart(product.id)"></i>
            <img :src="`http://localhost:8080/api/v1/products/images/${product.thumbnail}`"
              class="img-fluid card-img-top p-5" :alt="product.name">
            <h5 class="card-title mb-2 text-center">{{ product.name }}</h5>
            <p class="text-center fw-bold fs-5"><span class="text-danger">{{ product.price }} VND</span></p>
            <div class="my-2 mt-auto text-center">
              <router-link :to="{ name: 'DetailProduct', params: { product: product.id } }">
                <button>Buy Now</button>
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <nav>
      <ul class="pagination justify-content-center">
        <li class="page-item" :class="{ disabled: currentPage === 1 }">
          <a class="page-link" href="#" @click.prevent="$emit('change-page', currentPage - 1)">
            <i class="fa-solid fa-angle-left"></i>
          </a>
        </li>
        <li class="page-item" v-for="page in totalPages" :key="page" :class="{ active: page === currentPage }">
          <a class="page-link" href="#" @click.prevent="$emit('change-page', page)">{{ page }}</a>
        </li>
        <li class="page-item" :class="{ disabled: currentPage === totalPages }">
          <a class="page-link" href="#" @click.prevent="$emit('change-page', currentPage + 1)">
            <i class="fa-solid fa-chevron-right"></i>
          </a>
        </li>
      </ul>
      <div class="text-center">
        <span>Page {{ currentPage }} of {{ totalPages }}</span>
      </div>
    </nav>
  </div>
</template>

<script>

export default {
  data() {
    return {
      search: '',
    };
  },
  props: {
    products: {
      type: Array,
      required: true,
    },
    currentPage: {
      type: Number,
      required: true,
    },
    totalPages: {
      type: Number,
      required: true,
    },
    totalElems: {
      type: Number,
      required: true,
    },
  },
  methods: {
    setDefailtImage(event) {
      event.src = this.defaultImage;
    },
    addToCart(productId) {
      // Logic to add the product to the cart
    },
    sortBy(criteria) {
      let direction = null; 
      if (criteria === 'priceAsc') {
        criteria = 'price';
        direction = 'asc';
      } else if (criteria === 'priceDesc') {
        criteria = 'price';
        direction = 'desc';
      } else {
        direction = 'desc'; 
      }

      this.$emit('sort', { criteria, direction });
    },
    emitSearch() {
      this.$emit('search', this.search);
    },
  },
};
</script>

<style scoped>
a {
  text-decoration: none;
}

.dropdown .dropdown-item {
  cursor: pointer;

}

.my-5 .card {
  background-color: #F6F6F6;
  outline: none;
  border: none;
  border-radius: 10px;
}

.my-5 .card .fa-heart {
  outline: #000000;
  cursor: pointer;
  color: #999494;
}

.my-5 .card .fa-heart:hover {
  color: red;
}

.my-5 .card button {
  padding: 15px 50px;
  border: none;
  border-radius: 10px;
  outline: auto;
  background-color: #000000;
  color: white;
  font-weight: 600;
}

.pagination .page-item.disabled .page-link {
  pointer-events: none;
  background-color: #e9ecef;
}

.pagination .page-item.active .page-link {
  background-color: #8a8787;
  border-color: #8a8787;
  color: white;
}

form {
  position: relative;
}

form i {
  position: absolute;
  top: 50%;
  right: 8%;
  transform: translateY(-50%);
  font-size: 24px;
  color: #343A40;
  cursor: pointer;
}

form input {
  margin: 0 auto;
  width: 372px;
  height: 56px;
  border: none;

  background: #F5F5F5;
  border-radius: 8px;
}
</style>
