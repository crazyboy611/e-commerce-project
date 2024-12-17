<template>
  <div class="my-3">
    <div class="header">
      <h1>Manage Products</h1>
      <button class="btn btn-success" @click="addProduct">
        <i class="fa-solid fa-plus"></i> Add Product
      </button>
    </div>
    <div class="d-flex justify-content-between">
      <div>
        <div class="card">
          <input type="text" v-model="searchQuery" placeholder="Search product..." class="form-control mb-3" />
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
                <td>{{ currencyFormat(product.price) }}</td>
                <td>{{ formatDate(product.created_at.split("T")[0]) }}</td>
                <td>{{ formatDate(product.updated_at.split("T")[0]) }}</td>
                <td>
                  <span :class="{ 'badge bg-success': product.active, 'badge bg-danger': !product.active }">
                    {{ product.active ? 'Active' : 'Inactive' }}
                  </span>
                </td>
                <td>
                  <img :src="`http://localhost:8080/api/v1/products/images/${product.thumbnail}`"
                    alt="Product Thumbnail" width="50">
                </td>
                <td>
                  <button class="btn btn-primary" @click="editProduct(product.id)">
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
      </div>


      <div v-if="showAddProductModal" class="showAdd">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header d-flex justify-content-between">
              <h5 class="modal-title">Add Product</h5>
              <button class="btn btn-danger" @click="closeModal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <div class="modal-body">
              <form @submit.prevent="handleAddProduct">
                <div class="mb-3">
                  <label for="name" class="form-label">Product Name</label>
                  <input type="text" class="form-control" v-model="newProduct.name" required>
                </div>
                <div class="mb-3">
                  <label for="description" class="form-label">Description</label>
                  <textarea class="form-control" v-model="newProduct.description"></textarea>
                </div>
                <div class="mb-3">
                  <label for="thumbnail" class="form-label">Thumbnail URL</label>
                  <input type="file" class="form-control" @change="handleFileUpload">
                </div>
                <div class="mb-3">
                  <label for="price" class="form-label">Price</label>
                  <input type="number" class="form-control" v-model="newProduct.price" required>
                </div>
                <div class="mb-3">
                  <label for="quantity" class="form-label">Quantity</label>
                  <input type="number" class="form-control" v-model="newProduct.quantity" />
                </div>
                <div class="mb-3">
                  <label for="is_hot" class="form-label">Is Hot</label>
                  <select class="form-select" v-model="newProduct.is_hot">
                    <option :value="true">Yes</option>
                    <option :value="false">No</option>
                  </select>
                </div>
                <div class="mb-3">
                  <label for="subcategory" class="form-label">Subcategory</label>
                  <select class="form-select" v-model="newProduct.subcategory" multiple>
                    <option v-for="subcategory in subcategories" :key="subcategory.id" :value="subcategory.id">
                      {{ subcategory.name }}
                    </option>
                  </select>
                </div>
                <div class="mb-3">
                  <label for="active" class="form-label">Active</label>
                  <select class="form-select" v-model="newProduct.active">
                    <option :value="true">Active</option>
                    <option :value="false">Inactive</option>
                  </select>
                </div>
                <div class="mb-3">
                  <label class="form-label">Attributes</label>
                  <div v-for="(attr, index) in productForm.product_attributes" :key="index" class="mb-2">
                    <input type="text" v-model="attr.name" placeholder="Attribute Name" class="form-control mb-1">
                    <input type="text" v-model="attr.value" placeholder="Attribute Value" class="form-control">
                  </div>
                  <button type="button" class="btn btn-primary btn-sm mt-2" @click="addAttribute">
                    Add Attribute
                  </button>
                </div>
                <div class="text-end">
                  <button type="submit" class="btn btn-success">Add
                    Product</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
      <div v-if="showEditProductModal" class="showEdit">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header d-flex justify-content-between">
              <h5 class="modal-title">Edit Product</h5>
              <button class="btn btn-danger" @click="closeModal"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <div class="modal-body">
              <form @submit.prevent="handleUpdateProduct(productForm.id)">
                <!-- Name -->
                <div class="mb-3">
                  <label for="name" class="form-label">Product Name</label>
                  <input type="text" class="form-control" v-model="productForm.name" required>
                </div>
                <!-- Description -->
                <div class="mb-3">
                  <label for="description" class="form-label">Description</label>
                  <textarea class="form-control" v-model="productForm.description"></textarea>
                </div>
                <div class="mb-3">
                  <label for="thumbnail" class="form-label">Thumbnail</label>
                  <div v-if="productForm.thumbnail">
                    <img :src="`http://localhost:8080/api/v1/products/images/${productForm.thumbnail}`"
                      alt="Current Thumbnail" class="img-fluid mb-2" style="max-width: 100px;">
                  </div>
                  <input type="file" class="form-control" @change="handleFileUpload">
                </div>
                <!-- <div class="mb-3">
                  <label for="product_images" class="form-label">Product Images</label>
                  <div class="d-flex flex-wrap">
                    <div v-for="image in productForm.product_images" :key="image.id" class="me-2 mb-2">
                      <img :src="`http://localhost:8080/api/v1/products/images/${image.image_url}`" alt="Product Image"
                        class="img-thumbnail" style="width: 100px; height: 100px;">
                      <button type="button" class="btn btn-danger btn-sm mt-1 d-block" @click="removeImage(image.id)">
                        Remove
                      </button>
                    </div>
                  </div>
                  <input type="file" class="form-control mt-2" multiple @change="handleMultipleImagesUpload">
                </div> -->
                <!-- Price -->
                <div class="mb-3">
                  <label for="price" class="form-label">Price</label>
                  <input type="number" class="form-control" v-model="productForm.price" required min="0">
                </div>
                <!-- Quantity -->
                <div class="mb-3">
                  <label for="quantity" class="form-label">Quantity</label>
                  <input type="number" class="form-control" v-model="productForm.quantity" min="0" />
                </div>
                <!-- Is Hot -->
                <div class="mb-3">
                  <label for="is_hot" class="form-label">Is Hot</label>
                  <select class="form-select" v-model="productForm.hot">
                    <option :value="true">Yes</option>
                    <option :value="false">No</option>
                  </select>
                </div>
                <!-- Subcategory -->
                <div class="mb-3">
                  <label for="subcategory" class="form-label">Subcategory</label>
                  <select class="form-select" v-model="productForm.subcategory" multiple>
                    <option v-for="subcategory in subcategories" :key="subcategory.id" :value="subcategory.id">
                      {{ subcategory.name }}
                    </option>
                  </select>
                </div>
                <div class="mb-3">
                  <label for="active" class="form-label">Active</label>
                  <select class="form-select" v-model="productForm.active">
                    <option :value="true">Active</option>
                    <option :value="false">Inactive</option>
                  </select>
                </div>
                <!-- Attributes -->
                <!-- <div class="mb-3">
                  <label class="form-label">Attributes</label>
                  <div v-for="(attr, index) in productForm.product_attributes" :key="index" class="mb-2">
                    <input type="text" v-model="attr.name" placeholder="Attribute Name" class="form-control mb-1">
                    <input type="text" v-model="attr.value" placeholder="Attribute Value" class="form-control">
                  </div>
                  <button type="button" class="btn btn-primary btn-sm mt-2" @click="addAttribute">
                    Add Attribute
                  </button>
                </div> -->
                <div class="text-end">
                  <button type="submit" class="btn btn-success">Update Product</button>
                </div>
              </form>
            </div>
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
      searchQuery: '',
      productId: null,
      products: [],
      showAddProductModal: false,
      showEditProductModal: false,
      currentPage: 0,
      totalPages: 0,
      pageSize: 10,
      productForm: {
        id: null,
        name: '',
        description: '',
        price: 0,
        thumbnail: null,
        subcategory: [],
        quantity: 0,
        is_hot: false,
        active: true,
        product_attributes: [],
      },
      newProduct: {
        name: '',
        description: '',
        price: 0,
        thumbnail: null,
        subcategory: [],
        quantity: 0,
        is_hot: false,
        active: true,
        product_attributes: [],
      },
    };
  },
  created() {
    this.fetchProducts();
    this.fetchSubcategories();
  },
  watch: {
    searchQuery: {
      handler() {
        this.currentPage = 0;
        this.fetchProducts();
      },
      immediate: true,
    },
  },
  methods: {
    currencyFormat(value) {
      if (!value) return "0 VNĐ";
      return new Intl.NumberFormat('vi-VN').format(value) + " VNĐ";
    },
    formatDate(dateString) {
      if (!dateString) return "";
      const date = new Date(dateString);
      return new Intl.DateTimeFormat('vi-VN').format(date);
    },
    async fetchProducts() {
      const searchParam = this.searchQuery ? `&search=${this.searchQuery}` : '';
      try {
        const response = await axios.get(`http://localhost:8080/api/v1/products?&size=${this.pageSize}&page=${this.currentPage}${searchParam}&sort_by=id&sort_dir=asc`);
        this.products = response.data.data.product_response;
        this.currentPage = response.data.data.page_no;
        this.pageSize = response.data.data.page_size;
        this.totalPages = response.data.data.total_pages;
        this.totalElements = response.data.data.total_elements;
      } catch (error) {
        console.error('Failed to fetch products:', error);
      }
    },
    async fetchSubcategories() {
      try {
        const response = await axios.get('http://localhost:8080/api/v1/sub_categories');
        this.subcategories = response.data.data;
      } catch (error) {
        console.error('Failed to fetch subcategories:', error);
      }
    },
    handleFileUpload(event) {
      const file = event.target.files[0];
      if (file) {
        this.productForm.thumbnail = file.name;
        this.newProduct.thumbnail = file.name;
        // console.log(this.productForm.thumbnail);
      }
    },
    addProduct() {
      this.showAddProductModal = true;
      this.clearForm();
    },
    async handleAddProduct() {
      try {
        const response = await axios.post(`http://localhost:8080/api/v1/products`, this.newProduct, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });
        alert('Add product successfully');
        window.location.reload();
      }
      catch (error) {
        console.error('Failed to add product:', error);
      }
    },
    async editProduct(productId) {
      this.showEditProductModal = true;
      try {
        const response = await axios.get(`http://localhost:8080/api/v1/products/details/${productId}`);
        const product = response.data.data;
        const subcategoryIds = product.subcategory.map(subcat => subcat.id);
        this.productForm = {
          ...product,
          subcategory: subcategoryIds
        };
      } catch (error) {
        console.error('Failed to edit product:', error);
      }
    },
    async handleUpdateProduct(productId) {
      try {
        const response = await axios.put(`http://localhost:8080/api/v1/products/${productId}`, this.productForm, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });
        alert('Update product successfully');
        this.closeModal();
        this.fetchProducts();
      } catch (error) {
        console.error('Failed to update product:', error);
      }
    },
    async deleteProduct(productId) {
      confirm('Are you sure you want to delete this product?');
      try {
        const response = await axios.delete(`http://localhost:8080/api/v1/products/${productId}`, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });
        alert('Delete product successfully');
        this.fetchProducts();
      } catch (error) {
        console.error('Failed to delete product:', error);
      }
    },
    changePage(newPage) {
      if (newPage >= 0 && newPage < this.totalPages) {
        this.currentPage = newPage;
        this.fetchProducts();
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
      return value ? `$${value}` : '$0';
    }
  }
};
</script>


<style scoped>
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


.modal-content {
  border-radius: 8px;
}


.modal-header .btn-close {
  background: none;
  border: none;
  color: red;
  font-size: 20px;
  cursor: pointer;
}

.form-label {
  font-weight: bold;
}

.form-control {
  margin-bottom: 10px;
}

.btn {
  cursor: pointer;
}

.btn-primary {
  background-color: #007bff;
  border: none;
}

.btn-success {
  background-color: #28a745;
  border: none;
}

.btn-danger {
  background-color: #dc3545;
  border: none;
}

.btn:hover {
  opacity: 0.9;
}

/* Add Product Modal */
.showAdd,
.showEdit {
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1050;
}

.showAdd .modal-dialog,
.showEdit .modal-dialog {
  background: white;
  border-radius: 8px;
  width: 90%;
  max-width: 500px;
}

/* Attributes styling */
.mb-3 input[type="text"] {
  margin-bottom: 5px;
}

.btn-sm {
  padding: 5px 10px;
  font-size: 12px;
}
</style>