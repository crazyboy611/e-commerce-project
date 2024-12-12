<template>
  <div class="container">
    <div class="header">
      <h1>Manage Categories</h1>
      <button class="btn btn-success" @click="showAddCategoryModal = true">
        <i class="fa-solid fa-plus"></i> Add Category
      </button>
    </div>
    <div class="card">
      <table class="table table-striped">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Subcategories</th>
            <th>Edit</th>
            <th>Delete</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(category, index) in categories" :key="category.id">
            <td>{{ category.id }}</td>
            <td>
              <button class="btn btn-link" @click="toggleSubcategoryTable(category.id)">
                {{ category.name }}
              </button>
            </td>
            <td>
              <div v-for="(subCategory, index) in category.sub_categories" :key="subCategory.id">
                {{ subCategory.name }}
              </div>
            </td>
            <td>
              <button class="btn btn-primary" @click="editCategory(category)">
                <i class="fa-solid fa-edit"></i>
              </button>
            </td>
            <td>
              <button class="btn btn-danger" @click="deleteCategory(category.id)">
                <i class="fa-solid fa-trash"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Modal for Editing Category -->
    <div v-if="showEditCategoryModal" class="modal fade show d-block">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Edit Category</h5>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="saveCategory">
              <div class="mb-3">
                <label for="name" class="form-label">Category Name</label>
                <input type="text" class="form-control" v-model="categoryForm.name" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Subcategories</label>
                <div v-for="(subCategory, index) in categoryForm.sub_categories" :key="index" class="input-group mb-2">
                  <input type="text" class="form-control" v-model="subCategory.name" placeholder="Subcategory Name"
                    required />
                  <button type="button" class="btn btn-danger" @click="removeSubCategory(index)">
                    <i class="fa-solid fa-trash"></i>
                  </button>
                </div>
                <button type="button" class="btn btn-primary btn-sm" @click="addSubCategory">
                  <i class="fa-solid fa-plus"></i> Add Subcategory
                </button>
              </div>
              <div class="text-end">
                <button type="submit" class="btn btn-success">
                  Update Category
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <div v-if="showAddCategoryModal" class="modal fade show d-block">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Add Category</h5>
            <button type="button" class="btn-close" @click="closeModal"></button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="saveCategory">
              <div class="mb-3">
                <label for="name" class="form-label">Category Name</label>
                <input type="text" class="form-control" v-model="newCategory.name" required>
              </div>
              <div class="text-end">
                <button type="submit" class="btn btn-success">
                  Add Category
                </button>
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
  name: 'CategoryManagement',
  data() {
    return {
      categories: [],
      showAddCategoryModal: false,
      showEditCategoryModal: false,
      categoryForm: {
        id: null,
        name: '',
        description: '',
        sub_categories: [],
      },
      newCategory: {
        name: '',
        description: '',
        sub_categories: [],
      },
    };
  },
  mounted() {
    this.fetchCtegories();
  },
  methods: {
    addSubCategory() {
      this.categoryForm.sub_categories.push({ name: "" });
    },
    removeSubCategory(index) {
      this.categoryForm.sub_categories.splice(index, 1);
    },
    async fetchCtegories() {
      try {
        const response = await axios.get('http://localhost:8080/api/v1/categories');
        this.categories = response.data.data;
      }
      catch (error) {
        console.error('Failed to fetch categories:', error);
      }
    },
    addCategory() {
      this.showAddCategoryModal = true;
      this.clearForm();
    },
    editCategory(category) {
      this.showEditCategoryModal = true;
      this.categoryForm = { ...category };
    },
    deleteCategory(id) {
      this.categories = this.categories.filter(category => category.id !== id);
    },
    saveCategory() {
      if (this.showEditCategoryModal) {
        const index = this.categories.findIndex(c => c.id === this.categoryForm.id);
        this.categories.splice(index, 1, { ...this.categoryForm });
        this.showEditCategoryModal = false;
      } else {
        this.categoryForm.id = Date.now(); // Temporary ID generation
        this.categories.push({ ...this.categoryForm });
        this.showAddCategoryModal = false;
      }
      this.clearForm();
    },
    closeModal() {
      this.showAddCategoryModal = false;
      this.showEditCategoryModal = false;
    },
    clearForm() {
      this.categoryForm = {
        id: null,
        name: '',
        description: '',
      };
    }
  }
};
</script>

<style scoped>
.btn-link {
  text-decoration: none;
  color: #333;
}

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
</style>