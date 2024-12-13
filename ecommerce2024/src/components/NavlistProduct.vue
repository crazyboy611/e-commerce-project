<template>
  <div class="navlist my-3">
    <h2>Categories</h2>
    <div class="my-3">
      <div v-for="(section, index) in categories" :key="index">
        <div class="dropdown mt-2">
          <a class="dropdown-toggle text-secondary" data-bs-toggle="collapse"
            :data-bs-target="'#categoryCollapse' + index" aria-controls="categoryCollapse" aria-expanded="false">
            {{ section.name }}
          </a>
        </div>
        <div class="collapse mx-2" :id="'categoryCollapse' + index">
          <ul class="list-group list-group-flush mt-3">
            <li class="list-group-item d-flex" v-for="subCategory in section.sub_categories" :key="subCategory.id">
              <input type="radio" :id="`subCategory-${subCategory.id}`" :value="`${section.id}-${subCategory.id}`"
                :checked="selectedSubCategory === `${section.id}-${subCategory.id}`"
                @click="handleRadioClick(`${section.id}-${subCategory.id}`)" />
              <label class="ms-2" :for="`subCategory-${subCategory.id}`">{{ subCategory.name }}</label>
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

    <div class="mt-5">
      <input type="radio" id="discountFilter" class="me-2" @click="toggleDiscountFilter" :checked="discountFilter" />
      <label for="discountFilter">Product discount</label>
    </div>

  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'NavlistProduct',
  data() {
    return {
      categories: [],
      selectedSubCategory: null, // Store a single selected subcategory
      priceRange: 0,
      discountFilter: false,
    };
  },
  created() {
    this.fetchCategories();
  },
  methods: {
    async fetchCategories() {
      try {
        const response = await axios.get('http://localhost:8080/api/v1/categories');
        if (response.data.status === 200) {
          this.categories = response.data.data;
        } else {
          console.error('Failed to fetch categories:', response.data.message);
        }
      } catch (error) {
        console.error('Error fetching categories:', error);
      }
    },
    handleRadioClick(subCategoryId) {
      this.selectedSubCategory = this.selectedSubCategory === subCategoryId ? null : subCategoryId;
      this.updateSelectedCategories();
      sessionStorage.setItem('productCategory', JSON.stringify([this.selectedSubCategory]));

      this.$router.push({ name: 'ProductListCategory', params: { productCategory: JSON.stringify(this.selectedSubCategory) } });
    },
    updateSelectedCategories() {
      this.$emit('category-change', this.selectedSubCategory);
    },
    updatePriceRange() {
      this.$emit('price-change', this.priceRange);
    },
    toggleDiscountFilter() {
      this.discountFilter = !this.discountFilter;
      this.$emit('discount-change', this.discountFilter);
    },
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