<template>
    <div class="m-5 d-flex flex-wrap">
        <sidebarProductCategory :sections="sections" :selectedSubCategory="selectedCategory"
            @price-change="updatePriceRange" @category-change="updateCategory" :productsCategory="productsCategory"
            :productsSubCategory="productsSubCategory" @updateRam="updateRamFilter"
            @updateStorage="updateStorageFilter" />

        <ListProduct :products="allProducts" :current-page="currentPage" :total-pages="totalPages"
            :total-elems="totalElements" @change-page="changePage" @sort="handleSort" @search="updateSearch" />
    </div>
</template>

<script>
import axios from 'axios';
import sidebarProductCategory from '../components/SidebarProductCategory.vue';
import ListProduct from '../components/ListProduct.vue';

export default {
    components: {
        sidebarProductCategory,
        ListProduct
    },
    data() {
        return {
            sections: [],
            selectedCategory: null,
            priceRange: null,
            productsCategory: '',
            productsSubCategory: '',
            selectedRam: null,
            selectedStorage: null,
            allProducts: [],
            currentPage: 1,
            pageSize: 8,
            totalElements: 0,
            totalPages: 0,
            sortCriteria: 'id',
            sortDirection: null,
            search: '',
        };
    },
    created() {
        const storedCategory = sessionStorage.getItem('productCategory');
        if (storedCategory) {
            try {
                this.selectedCategory = JSON.parse(storedCategory);
                console.log("Loaded stored category:", this.selectedCategory);
            } catch (error) {
                console.error("Error parsing stored category from sessionStorage:", error);
            }
        }
    },
    methods: {
        updateCategory(selectedCategory) {
            console.log("updateCategory called with:", selectedCategory);
            this.selectedCategory = selectedCategory;
            sessionStorage.setItem('productCategory', JSON.stringify(selectedCategory));
            this.fetchProductsByCategory(selectedCategory);
        },
        async fetchProductsByCategory(category) {
            const categoryString = Array.isArray(category) ? category[0] : category;
            if (!categoryString) {
                console.warn("No category provided for fetching products.");
                return;
            }

            console.log("fetchProductsByCategory called with:", categoryString);
            const [sectionId, subCategoryId] = categoryString.split('-');

            try {
                const response = await axios.get(`http://localhost:8080/api/v1/categories/${sectionId}`);
                const subCategory = response.data.data.sub_categories.find(sub => sub.id == subCategoryId);
                if (subCategory) {
                    this.productsSubCategory = subCategory.name;
                    this.productsCategory = response.data.data.name;
                    console.log("Category:", this.productsCategory);
                    console.log("Subcategory:", this.productsSubCategory);
                } else {
                    console.warn("Subcategory not found for ID:", subCategoryId);
                }
            } catch (error) {
                console.error("Error fetching products by category:", error);
            }
        },
        async fetchProducts() {
            this.selectedCategoryId = sessionStorage.getItem('selectedCategoryId') || '';

            const categoryIdParams = this.selectedCategoryId
                ? `&category_id=${this.selectedCategoryId}`
                : '';

            const categoryString = this.selectedCategory ? this.selectedCategory[0] : null;
            if (!categoryString) {
                console.warn("No category provided for fetching products.");
                return;
            }
            const [sectionId, subCategoryId] = categoryString.split('-');

            const searchParam = this.search ? `&search=${this.search}` : '';
            const categoryParams = sectionId && subCategoryId
                ? `&category_id=${sectionId}&subcategory_id=${subCategoryId}`
                : '';
            const sortParams = this.sortCriteria && this.sortDirection
                ? `&sort_dir=${this.sortDirection}`
                : '';

            const sortPrice = this.priceRange
                ? `&price=0-${this.priceRange}` : '';

            const ramParam = this.selectedRam
                ? sectionId === '1'
                    ? `&mobile_ram=${this.selectedRam}`
                    : sectionId === '2'
                        ? `&laptop_ram=${this.selectedRam}`
                        : ''
                : '';

            const storageParam = this.selectedStorage
                ? sectionId === '1'
                    ? `&mobile_storage=${this.selectedStorage}`
                    : sectionId === '2'
                        ? `&laptop_storage=${this.selectedStorage}`
                        : ''
                : '';


            try {
                const response = await axios.get(`http://localhost:8080/api/v1/products?page=${this.currentPage - 1}&size=${this.pageSize}${categoryIdParams}${searchParam}${sortParams}${categoryParams}${ramParam}${storageParam}${sortPrice}&sort_by=${this.sortCriteria}`);
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
        updateRamFilter(selectedRam) {
            this.selectedRam = selectedRam;
            this.currentPage = 1;
            this.fetchProducts(); // Fetch products with the updated filter
        },
        updateStorageFilter(selectedStorage) {
            this.selectedStorage = selectedStorage;
            this.currentPage = 1;
            this.fetchProducts(); // Fetch products with the updated filter
        }
    },
    mounted() {
        if (this.selectedCategory) {
            this.fetchProductsByCategory(this.selectedCategory);
            this.fetchProducts();
        }
    }
};
</script>
