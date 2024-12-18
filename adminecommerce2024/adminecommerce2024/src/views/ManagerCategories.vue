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
            <th>Active</th>
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
              <span :class="{ 'badge bg-success': category.active, 'badge bg-danger': !category.active }">
                {{ category.active ? 'Active' : 'Inactive' }}
              </span>
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
            <form @submit.prevent="updateCategory">
              <div class="mb-3">
                <label for="name" class="form-label">Category Name</label>
                <input type="text" class="form-control" v-model="categoryForm.name" required>
              </div>
              <div class="mb-3">
                  <label for="active" class="form-label">Active</label>
                  <select class="form-select" v-model="categoryForm.active">
                    <option :value="true">Active</option>
                    <option :value="false">Inactive</option>
                  </select>
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
              <div class="mb-3">
                  <label for="active" class="form-label">Active</label>
                  <select class="form-select" v-model="newCategory.active">
                    <option :value="true">Active</option>
                    <option :value="false">Inactive</option>
                  </select>
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
      currentCategoryId:null,
      categories: [],
      showEditAttributeModal: false,
      showAddCategoryModal: false,
      showEditCategoryModal: false,
      categoryForm: {
        id: null,
        name: '',
        active:true,
        description: '',
        sub_categories: [],
      },
      newCategory: {
        name: '',
        active:true,
        description: '',
        sub_categories: [],
      },
    };
  },
  mounted() {
    this.fetchCategories();
  },
  methods: {
    
    async fetchCategories() {
      try {
        const response = await axios.get('http://localhost:8080/api/v1/categories/admin',{
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });
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
    
    async deleteCategory(categoryId) {
      if (confirm('Are you sure you want to delete this category?')) {
        try {
          const response = await axios.delete(`http://localhost:8080/api/v1/categories/${categoryId}`, {
            headers: {
              Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
            },
          });
        alert(response.data.message);
        // alert('Category deleted successfully');
          this.fetchCategories();
        } catch (error) {
          console.error('Failed to delete category:', error);
        }
      }
    },
    async saveCategory() {
      try {
        const response = await axios.post('http://localhost:8080/api/v1/categories', 
          { name: this.newCategory.name,
            active:this.newCategory.active
           }, 
          {
            headers: {
              Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
            },
          }
        );
        alert(response.data.message);
        // alert('Category added successfully');
        this.closeModal();  
        this.newCategory.name = '';  
        this.fetchCategories();
      } catch (error) {
        console.error('Failed to add category:', error);
        if (error.response) {
          alert(`Error: ${error.response.data.message}`);
        } else {
          alert(response.data.message);
        }
      }
    },
    editCategory(category) {
      this.currentCategoryId = category.id;
      this.categoryForm = { ...category };;
      this.showEditCategoryModal = true; 
    },
    addSubCategory() {
      this.categoryForm.sub_categories.push({ name: "" });
     },
    async removeSubCategory(index) {
      const subCategory = this.categoryForm.sub_categories[index]; // Lấy subcategory cần xóa
      const subCategoryId = subCategory.id; 

      try {
        const response = await axios.delete(`http://localhost:8080/api/v1/sub_categories/${subCategoryId}`, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });

        this.categoryForm.sub_categories.splice(index, 1); // Loại bỏ subcategory khỏi mảng

        alert(response.data.message);
        // alert('Subcategory đã được xóa thành công');
      } catch (error) {
        console.error('Lỗi khi xóa subcategory:', error);
        alert(eror.response.data.error);
        // alert('Lỗi khi xóa subcategory');
      }
    },

    async updateCategory() {
      try {
        // Lấy danh sách sub_categories từ categoryForm
        const subCategoriesData = this.categoryForm.sub_categories.map(subcat => {
          return {
            name: subcat.name // Tên của subcategory
          };
        });

        for (let subcat of subCategoriesData) {
          try {
            const existingSubCategory = await this.checkSubCategoryByName(subcat.name);

            if (!existingSubCategory) {
              const createdSubCategory = await this.createSubCategory(subcat);
              await this.insertSubCategoryToCategory(this.currentCategoryId, createdSubCategory.data.name);
            } else {
              await this.insertSubCategoryToCategory(this.currentCategoryId, existingSubCategory.name);
            }
          } catch (error) {
            console.error('Lỗi khi xử lý subcategory:', subcat.name, error);
          }
        }
        const response = await axios.put(`http://localhost:8080/api/v1/categories/${this.currentCategoryId}`, {
          name: this.categoryForm.name,
          active: this.categoryForm.active
        }, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`, 
          },
        });

        alert(response.data.message);
        // alert('Category updated successfully');
        this.closeModal();
        this.fetchCategories(); // Tải lại danh sách category

      } catch (error) {
        console.error('Failed to update category:', error);
        alert(response.data.message);
        // alert('Error updating category');
      }
    },

    async createSubCategory(subCategory) {
      try {
        const response = await axios.post('http://localhost:8080/api/v1/sub_categories', {
          name: subCategory.name
        }, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });
        return response.data; 
      } catch (error) {
        console.error('Failed to create subcategory:', error);
        alert(response.data.message);
        // alert('Error creating subcategory');
        throw error; 
      }
    },

    async insertSubCategoryToCategory(categoryId, subCategoryName) {
      try {
        const response = await axios.post(`http://localhost:8080/api/v1/categories/add_subcategory/${categoryId}`, {
          name: subCategoryName  
        }, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`, 
          },
        });

        console.log('Subcategory added to category successfully:', response.data); 
        return response.data; 
      } catch (error) {
        if (error.response) {
          const status = error.response.status;

          if (status === 400) {
            alert(error.response.data.error);
          } else {
            alert(error.response.data.error);
            throw error; // Nếu là lỗi khác, ném lại lỗi để xử lý ở mức cao hơn
          }
        } else {
          console.error("Lỗi không có phản hồi từ server:", error);
          alert("Không thể kết nối đến server");
        throw error; 
        }
      }
    },
    async checkSubCategoryByName(name) {
      try {
        const response = await axios.get(`http://localhost:8080/api/v1/sub_categories`, {
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });

        const subcategories = response.data.data;

        const foundSubCategory = subcategories.find(subcat => subcat.name === name);

        return foundSubCategory || null;
      } catch (error) {
        if (error.response) {
          const message = error.response.data.message || 'Lỗi không xác định';
          console.error(`Lỗi khi kiểm tra subcategory ${name}:`, message);
          alert(`Không thể kiểm tra subcategory: ${message}`);
        } else {
          console.error('Lỗi không có phản hồi từ server:', error);
          alert('Không thể kết nối đến server');
        }
        throw error;
      }
    },

    closeModal() {
      this.showAddCategoryModal = false;
      this.showEditCategoryModal = false;
      this.showEditAttributeModal= false;
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