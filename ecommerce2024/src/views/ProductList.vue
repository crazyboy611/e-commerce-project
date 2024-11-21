<template>
  <div class="m-5 d-flex flex-wrap">
    <NavlistProduct @category-change="updateSelectedCategories" @price-change="updatePriceRange"
      @discount-change="updateDiscountFilter" />
    <ListProduct :products="allProducts" :current-page="currentPage" :total-pages="totalPages"
      :total-elems="totalElements" @change-page="changePage" @sort="handleSort" @search="updateSearch" />
  </div>
</template>

<script>
import NavlistProduct from '../components/NavlistProduct.vue';
import ListProduct from '../components/ListProduct.vue';
import axios from 'axios';

export default {
  name: 'ProductListView',
  components: {
    NavlistProduct,
    ListProduct,
  },
  data() {
    return {
      allProducts: [],
      selectedSubCategory: this.categoryId || '',
      selectedCategoryId: sessionStorage.getItem('selectedCategoryId') || '',
      priceRange: null,
      discountFilter: false,
      currentPage: 1,
      pageSize: 8,
      totalElements: 0,
      totalPages: 0,
      sortDirection: '',
      sortCriteria: 'id',
      search: '',
    };
  },
  created() {
    this.fetchProducts();
  },
  watch: {
    categoryId(newCategoryId) {
      this.currentPage = 1;
      this.fetchProducts();
    }
  },
  methods: {
    async fetchProducts() {

      this.selectedCategoryId = sessionStorage.getItem('selectedCategoryId') || '';

      const categoryIdParams = this.selectedCategoryId
        ? `&category_id=${this.selectedCategoryId}`
        : '';

      const searchParam = this.search ? `&search=${this.search}` : '';

      const selectedCategory = this.selectedSubCategory ? this.selectedSubCategory.split('-') : [];
      const categoryParams = selectedCategory.length === 2
        ? `&category_id=${selectedCategory[0]}&subcategory_id=${selectedCategory[1]}`
        : '';

      const sortParams = this.sortCriteria && this.sortDirection
        ? `&sort_dir=${this.sortDirection}`
        : '';
      const sortPrice = this.priceRange
        ? `&price=0-${this.priceRange}` : '';

      const discountParam = this.discountFilter ? `&is_hot=true` : '';

      try {
        const response = await axios.get(`http://localhost:8080/api/v1/products?page=${this.currentPage - 1}&size=${this.pageSize}${searchParam}${sortParams}${categoryParams}${categoryIdParams}${sortPrice}${discountParam}&sort_by=${this.sortCriteria}`, {
          headers: {
            'Authorization': `${this.accessToken}`,
          },
        });
        this.allProducts = response.data.data.product_response;
        this.totalElements = response.data.data.total_elements;
        this.totalPages = Math.ceil(this.totalElements / this.pageSize);
        sessionStorage.removeItem('selectedCategoryId');
        this.selectedSubCategory = '';
      } catch (error) {
        console.error(error);
      }
    },
    changePage(page) {
      if (page >= 1 && page <= this.totalPages) {
        this.currentPage = page;
        this.fetchProducts();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },
    updateSelectedCategories(selectedCategory) {
      this.selectedSubCategory = selectedCategory;
      this.currentPage = 1;
      this.fetchProducts();
    },
    updatePriceRange(newPriceRange) {
      this.priceRange = newPriceRange;
      this.currentPage = 1;
      this.fetchProducts();
    },
    updateDiscountFilter(discount) {
      this.discountFilter = discount;
      this.currentPage = 1;
      this.fetchProducts();
    },
    handleSort({ criteria, direction }) {
      this.sortCriteria = criteria;
      this.sortDirection = direction;
      this.currentPage = 1;
      this.fetchProducts();
    },
    updateSearch(searchTerm) {
      this.search = searchTerm;
      this.currentPage = 1;
      this.fetchProducts();
    },
  },
};
</script>
