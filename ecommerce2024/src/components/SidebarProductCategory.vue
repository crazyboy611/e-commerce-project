<template>
  <div class="navlist my-3">
    <h4>Product / {{ productsCategory }} / {{ productsSubCategory }} </h4>

    <!-- RAM Selection -->
    <div class="my-3">
      <div>
        <div class="dropdown mt-2">
          <a class="dropdown-toggle text-secondary" data-bs-toggle="collapse" :data-bs-target="'#ramCollapse'"
            aria-controls="ramCollapse" aria-expanded="false">
            RAM
          </a>
        </div>
        <div class="collapse mx-2" :id="'ramCollapse'">
          <ul class="list-group list-group-flush mt-3">
            <li class="list-group-item d-flex">
              <input type="radio" id="ram4" name="ram" v-model="selectedRam" value="1" @click="toggleRam('1')" />
              <label class="ms-2" for="ram4">1GB</label>
            </li>
            <li class="list-group-item d-flex">
              <input type="radio" id="ram6" name="ram" v-model="selectedRam" value="2" @click="toggleRam('2')" />
              <label class="ms-2" for="ram6">2GB</label>
            </li>
            <li class="list-group-item d-flex">
              <input type="radio" id="ram8" name="ram" v-model="selectedRam" value="3" @click="toggleRam('3')" />
              <label class="ms-2" for="ram8">3GB</label>
            </li>
          </ul>
        </div>
      </div>
    </div>
    <div class="my-3">
      <div>
        <div class="dropdown mt-2">
          <a class="dropdown-toggle text-secondary" data-bs-toggle="collapse" :data-bs-target="'#storageCollapse'"
            aria-controls="storageCollapse" aria-expanded="false">
            Storage
          </a>
        </div>
        <div class="collapse mx-2" :id="'storageCollapse'">
          <ul class="list-group list-group-flush mt-3">
            <li class="list-group-item d-flex">
              <input type="radio" id="storage64" name="storage" v-model="selectedStorage" value="33"
                @click="toggleStorage('33')" />
              <label class="ms-2" for="storage64">33GB</label>
            </li>
            <li class="list-group-item d-flex">
              <input type="radio" id="storage128" name="storage" v-model="selectedStorage" value="61"
                @click="toggleStorage('61')" />
              <label class="ms-2" for="storage128">61GB</label>
            </li>
            <li class="list-group-item d-flex">
              <input type="radio" id="storage256" name="storage" v-model="selectedStorage" value="248"
                @click="toggleStorage('248')" />
              <label class="ms-2" for="storage256">248GB</label>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <div class="mt-5">
      <label for="priceRange" class="form-label">
        Price Range: <span class="text-danger fs-5 ms-3">{{ priceRange }} VND</span>
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
      selectedStorage: null,
      priceRange: 0,
    };
  },
  methods: {
    updatePriceRange() {
      this.$emit('price-change', this.priceRange);
    },
    toggleRam(value) {
      this.selectedRam = this.selectedRam === value ? null : value;
      this.$emit('updateRam', this.selectedRam);
    },
    toggleStorage(value) {
      this.selectedStorage = this.selectedStorage === value ? null : value;
      this.$emit('updateStorage', this.selectedStorage);
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