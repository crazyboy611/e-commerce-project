<template>
  <div class="navlist my-3">
    <h4>Product / {{ productsCategory }} / {{ productsSubCategory }} </h4>

    <!-- RAM Selection -->
    <div class="my-3">
      <div>
        <!-- <div class="mt-5">
          <label for="" class="form-label">
            RAM: <span class="text-danger fs-5 ms-3">{{ selectedRam }} GB</span>
          </label>
          <input type="range" class="form-range" id="" v-model="selectedRam" min="1" max="1000"
            @input="toggleRam" />
        </div> -->
        <div class="dropdown mt-2">
          <a class="dropdown-toggle text-secondary" data-bs-toggle="collapse" :data-bs-target="'#ramCollapse'"
            aria-controls="ramCollapse" aria-expanded="false">
            RAM
          </a>
        </div>

        <div class="collapse mx-2" :id="'ramCollapse'">
          <ul class="list-group list-group-flush mt-3">
            <li class="list-group-item d-flex">
              <input type="radio" id="ram4" name="ram" v-model="selectedRam" value="1" @click="toggleRam('0-4')" />
              <label class="ms-2" for="ram4">Nhỏ hơn 4GB</label>
            </li>
            <li class="list-group-item d-flex">
              <input type="radio" id="ram6" name="ram" v-model="selectedRam" value="2" @click="toggleRam('4-8')" />
              <label class="ms-2" for="ram6">Từ 4GB đến 8GB</label>
            </li>
            <li class="list-group-item d-flex">
              <input type="radio" id="ram6" name="ram" v-model="selectedRam" value="3" @click="toggleRam('8-16')" />
              <label class="ms-2" for="ram6">Từ 8GB đến 16GB</label>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <div class="my-3">
      <div>
        <!-- <div class="mt-5">
          <label for="" class="form-label">
            Storage: <span class="text-danger fs-5 ms-3">{{ selectedStorage }} GB</span>
          </label>
          <input type="range" class="form-range" id="" v-model="selectedStorage" min="1" max="1000"
            @input="toggleStorage" />
        </div> -->
        <div class="dropdown mt-2">
          <a class="dropdown-toggle text-secondary" data-bs-toggle="collapse" :data-bs-target="'#storageCollapse'"
            aria-controls="storageCollapse" aria-expanded="false">
            Storage
          </a>
        </div>
        <div class="collapse mx-2" :id="'storageCollapse'">
          <ul class="list-group list-group-flush mt-3">
            <li class="list-group-item d-flex">
              <input type="radio" id="storage64" name="storage" v-model="selectedStorage" value="1"
                @click="toggleStorage('0-256')" />
              <label class="ms-2" for="storage64">Nhỏ hơn 256GB</label>
            </li>
            <li class="list-group-item d-flex">
              <input type="radio" id="storage128" name="storage" v-model="selectedStorage" value="2"
                @click="toggleStorage('256-512')" />
              <label class="ms-2" for="storage128">Từ 256GB đến 512GB</label>
            </li>
            <li class="list-group-item d-flex">
              <input type="radio" id="storage256" name="storage" v-model="selectedStorage" value="3"
                @click="toggleStorage('512-1000')" />
              <label class="ms-2" for="storage256">Từ 512GB đến 1TB</label>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <div class="mt-5">
      <label for="priceRange" class="form-label">
        Price Range: <span class="text-danger fs-5 ms-3">{{ currencyFormat(priceRange) }}</span>
      </label>
      <input type="range" class="form-range" id="priceRange" v-model="priceRange" min="1" max="10000000"
        @input="updatePriceRange" />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    productsCategory: String,
    productsSubCategory: String,
  },
  data() {
    return {
      selectedRam: null,
      selectedStorage: 0,
      priceRange: 0,
    };
  },
  methods: {
    currencyFormat(value) {
      if (!value) return "0 VNĐ";
      return new Intl.NumberFormat('vi-VN').format(value) + " VNĐ";
    },
    updatePriceRange() {
      this.$emit('price-change', this.priceRange);
    },
    toggleRam(value) {
      this.$emit('updateRam', value);
    },
    toggleStorage(value) {
      this.$emit('updateStorage', value);
    }
  }
};
</script>



<style scoped>
.navlist {
  width: 20%;
  margin-left: 5%;
}

.dropdown {
  cursor: pointer;
}

.collapse>.my-3 {
  border: none;
  outline: none;
}

.list-group {
  list-style-type: none;
  border: none;
}

ul {
  border: none;
}

a {
  text-decoration: none;
}

small {
  font-size: 12px;
}

@media (max-width: 768px) {
  .search-input {
    width: 100%;
  }
}
</style>