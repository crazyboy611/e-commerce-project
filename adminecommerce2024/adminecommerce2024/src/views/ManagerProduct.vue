<template>
  <div class="container">
    <div class="header">
      <h1>Manage Products</h1>
      <button class="btn btn-success" @click="addProduct">
        <i class="fa-solid fa-plus"></i> Add Product
      </button>
    </div>
    <div class="card">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Price</th>
            <th>Created At</th>
            <th>Updated At</th>
            <th>Active</th>
            <th>Thumbnail</th>
            <th>Edit</th>
            <th>Delete</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(product, index) in products" :key="product.id">
            <td>{{ product.id }}</td>
            <td>{{ product.name }}</td>
            <td>{{ product.price | currency }}</td>
            <td>{{ product.created_at.split("T")[0] }}</td>
            <td>{{ product.updated_at.split("T")[0] }}</td>
            <td>
              <span :class="{ 'badge bg-success': product.active, 'badge bg-danger': !product.active }">
                {{ product.active ? 'Active' : 'Inactive' }}
              </span>
            </td>
            <td>
              <img :src="`http://localhost:8080/api/v1/products/images/${product.thumbnail}`" alt="Product Thumbnail"
                width="50">
            </td>
            <td>
              <button class="btn btn-primary" @click="editProduct(product)">
                <i class="fa-solid fa-edit"></i>
              </button>
            </td>
            <td>
              <button class="btn btn-danger" @click="deleteProduct(product.id)">
                <i class="fa-solid fa-trash"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="pagination">
      <button :disabled="currentPage === 0" @click="changePage(currentPage - 1)">
        <i class="fa-solid fa-chevron-left"></i>
      </button>
      <span>Page {{ currentPage + 1 }} of {{ totalPages }}</span>
      <button :disabled="currentPage === totalPages - 1" @click="changePage(currentPage + 1)">
        <i class="fa-solid fa-chevron-right"></i>
      </button>
    </div>

    <!-- Add/Edit Product Modal -->
    <div v-if="showAddProductModal || showEditProductModal" class="modal fade show d-block">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">{{ showEditProductModal ? 'Edit Product' : 'Add Product' }}</h5>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="saveProduct">
              <div class="mb-3">
                <label for="name" class="form-label">Product Name</label>
                <input type="text" class="form-control" v-model="productForm.name" required>
              </div>
              <div class="mb-3">
                <label for="price" class="form-label">Price</label>
                <input type="number" class="form-control" v-model="productForm.price" required min="0">
              </div>
              <div class="mb-3">
                <label for="createdAt" class="form-label">Created At</label>
                <input type="date" class="form-control" v-model="productForm.createdAt" required>
              </div>
              <div class="mb-3">
                <label for="updatedAt" class="form-label">Updated At</label>
                <input type="date" class="form-control" v-model="productForm.updatedAt">
              </div>
              <div class="mb-3">
                <label for="description" class="form-label">Description</label>
                <textarea class="form-control" v-model="productForm.description"></textarea>
              </div>
              <div class="mb-3">
                <label for="thumbnail" class="form-label">Thumbnail URL</label>
                <input type="text" class="form-control" v-model="productForm.thumbnail">
              </div>
              <div class="mb-3">
                <label for="active" class="form-label">Active</label>
                <select class="form-select" v-model="productForm.active">
                  <option :value="true">Active</option>
                  <option :value="false">Inactive</option>
                </select>
              </div>
              <div class="text-end">
                <button type="submit" class="btn btn-success">{{ showEditProductModal ? 'Update' : 'Add' }}
                  Product</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'ProductManagement',
  data() {
    return {
      products: [],
      showAddProductModal: false,
      showEditProductModal: false,
      currentPage: 0,
      totalPages: 0,
      pageSize: 5,
      // productForm: {
      //   id: null,
      //   name: '',
      //   price: 0,
      //   createdAt: '',
      //   updatedAt: '',
      //   description: '',
      //   active: true,
      //   thumbnail: ''
      // },
    };
  },
  mounted() {
    this.fetchProducts();
  },
  methods: {
    async fetchProducts() {
      try {
        const response = await axios.get(`http://localhost:8080/api/v1/products?&size=${this.pageSize}&page=${this.currentPage}&sort_by=id&sort_dir=asc`);
        this.products = response.data.data.product_response;
        this.currentPage = response.data.data.page_no;
        this.pageSize = response.data.data.page_size;
        this.totalPages = response.data.data.total_pages;
        this.totalElements = response.data.data.total_elements;
      } catch (error) {
        console.error('Failed to fetch products:', error);
      }
    },
    addProduct() {
      this.showAddProductModal = true;
      this.clearForm();
    },
    editProduct(product) {
      this.showEditProductModal = true;
      this.productForm = { ...product };
    },
    async deleteProduct(id) {
      try {
        await axios.delete(`http://localhost:8080/api/v1/products/${id}`);
        this.products = this.products.filter(product => product.id !== id);
      } catch (error) {
        console.error('Failed to delete product:', error);
      }
    },
    async saveProduct() {
      if (this.showEditProductModal) {
        try {
          await axios.put(`http://localhost:8080/api/v1/products/${this.productForm.id}`, this.productForm);
          const index = this.products.findIndex(p => p.id === this.productForm.id);
          this.products.splice(index, 1, { ...this.productForm });
        } catch (error) {
          console.error('Failed to update product:', error);
        }
      } else {
        try {
          const response = await axios.post('http://localhost:8080/api/v1/products', this.productForm);
          this.products.push(response.data);
        } catch (error) {
          console.error('Failed to add product:', error);
        }
      }
      this.closeModal();
      this.clearForm();
    },
    changePage(page) {
      if (page >= 0 && page < this.totalPages) {
        this.currentPage = page;
        this.fetchProducts(this.activeTab);
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    },
    closeModal() {
      this.showAddProductModal = false;
      this.showEditProductModal = false;
    },
    clearForm() {
      this.productForm = {
        id: null,
        name: '',
        price: 0,
        createdAt: '',
        updatedAt: '',
        description: '',
        active: true,
        thumbnail: ''
      };
    }
  },
  filters: {
    currency(value) {
      return value ? `$${value.toFixed(2)}` : '$0.00';
    }
  }
};
</script>


<style scoped>
.container {
  margin: 50px auto;
  max-width: 1200px;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

h1 {
  font-size: 2rem;
  color: #333;
}

.card {
  background-color: #fff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}

.table {
  width: 100%;
}

th,
td {
  text-align: left;
  padding: 15px;
}

.btn-success {
  background-color: #28a745;
  color: #fff;
}

.modal-content {
  padding: 20px;
  border-radius: 10px;
}

.text-end button {
  background-color: #8abaee;
  color: white;
  font-weight: 500;
  border: none;
}

.text-end button:hover {
  background-color: #4e81df;
}
.pagination {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: 20px;
}

.pagination button {
  padding: 8px 16px;
  background-color: #007bff;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.pagination button:hover {
  background-color: #0056b3;
}

.pagination button:disabled {
  background-color: #d3d3d3;
  color: #ffffff;
  cursor: not-allowed;
  opacity: 0.7;
}
</style>