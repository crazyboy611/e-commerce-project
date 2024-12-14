<template>
  <div class="container">
    <div class="header">
      <h1>Manage Discount Codes</h1>
      <button class="add-btn" @click="addDiscount">
        <i class="fa-solid fa-plus"></i> Add
      </button>
    </div>
    <div class="controls">
      <select v-model="sortOrder">
        <option value="asc">Asc date</option>
        <option value="desc">Desc date</option>
      </select>
      <input type="text" v-model="search" placeholder="Search by code, description, or expiration date" />
    </div>
    <div class="card">
      <div class="table-responsive">
        <table v-if="filteredDiscounts.length">
          <thead>
            <tr>
              <th>ID</th>
              <th>Code</th>
              <th>Description</th>
              <th>Discount</th>
              <th>Expiration Date</th>
              <th>Status</th>
              <th>Edit</th>
              <th>Delete</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(discount, index) in paginatedDiscounts" :key="discount.id"
              :class="{ 'danger': discount.status === 'Inactive', 'success': discount.status === 'Active' }">
              <td>{{ index + 1 + (currentPage - 1) * itemsPerPage }}</td>
              <td>{{ discount.code }}</td>
              <td>{{ discount.desc }}</td>
              <td>{{ discount.discountValue }}{{ discount.type === 'Percentage' ? '%' : '$' }}</td>
              <td>{{ discount.expirationDate }}</td>
              <td :class="discount.status === 'Active' ? 'text-success' : 'text-danger'">{{ discount.status }}</td>
              <td>
                <button class="edit-btn" @click="editDiscount(discount)">
                  <i class="fa-solid fa-edit"></i>
                </button>
              </td>
              <td>
                <button class="delete-btn" @click="deleteDiscount(discount.id)">
                  <i class="fa-solid fa-trash"></i>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <p v-else class="text-center">Not discount code</p>
        <!-- Pagination Controls -->
        <div class="pagination">
          <button @click="currentPage--" :disabled="currentPage === 1"><i class="fa-solid fa-chevron-left"></i></button>
          <span>Page {{ currentPage }} of {{ totalPages }}</span>
          <button @click="currentPage++" :disabled="currentPage === totalPages"><i class="fa-solid fa-chevron-right"></i></button>
        </div>
      </div>
    </div>

    <!-- Add/Edit Discount Code Modal -->
    <div v-if="showAddDiscountModal || showEditDiscountModal" class="modal">
      <div class="modal-content">
        <span class="close" @click="closeModal">&times;</span>
        <h2>{{ showEditDiscountModal ? 'Edit Discount Code' : 'Add Discount Code' }}</h2>
        <form @submit.prevent="saveDiscount">
          <div>
            <label for="code">Code</label>
            <input type="text" v-model="discountForm.code" required>
          </div>
          <div>
            <label for="type">Description</label>
            <input type="text" name="" id="" v-model="discountForm.desc">
          </div>
          <div>
            <label for="discountValue">Discount Value</label>
            <input type="number" v-model="discountForm.discountValue" required min="0">
          </div>
          <div>
            <label for="expirationDate">Expiration Date</label>
            <input type="date" v-model="discountForm.expirationDate" required>
          </div>
          <div>
            <label for="status">Status</label>
            <select v-model="discountForm.status">
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>
            </select>
          </div>
          <div class="text-end">
            <button class="btn" type="submit">{{ showEditDiscountModal ? 'Update' : 'Add' }} Discount</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'ManagerDiscountCode',
  data() {
    return {
      discountCodes: [
        {
          id: 1,
          code: 'NEWYEAR2023',
          desc: '$20 maxium',
          discountValue: 15,
          expirationDate: '2024-01-01',
          status: 'Active',
        },
        {
          id: 2,
          code: 'SUMMER50',
          desc: '$50 maxium',
          discountValue: 50,
          expirationDate: '2024-06-30',
          status: 'Inactive',
        },
        {
          id: 3,
          code: 'SUMMER10PERCENT',
          desc: '10% maxium',
          discountValue: 50,
          expirationDate: '2024-06-30',
          status: 'Active',
        },
        {
          id: 4,
          code: 'SUMMER10PERCENT',
          desc: '10% maxium',
          discountValue: 50,
          expirationDate: '2024-06-30',
          status: 'Active',
        },
        {
          id: 5,
          code: 'SUMMER10PERCENT',
          desc: '10% maxium',
          discountValue: 50,
          expirationDate: '2024-06-30',
          status: 'Active',
        },
        {
          id: 6,
          code: 'SUMMER10PERCENT',
          desc: '10% maxium',
          discountValue: 50,
          expirationDate: '2024-06-30',
          status: 'Active',
        },
      ],
      showAddDiscountModal: false,
      showEditDiscountModal: false,
      discountForm: {
        id: null,
        code: '',
        desc: '',
        discountValue: 0,
        expirationDate: '',
        status: 'Active',
      },
      search: '',
      sortOrder: 'asc',
      currentPage: 1,
      itemsPerPage: 5,
    };
  },
  computed: {
    filteredDiscounts() {
      return this.discountCodes
        .filter(discount =>
          [discount.code, discount.desc, discount.expirationDate]
            .join(' ')
            .toLowerCase()
            .includes(this.search.toLowerCase())
        )
        .sort((a, b) => {
          const dateA = new Date(a.expirationDate);
          const dateB = new Date(b.expirationDate);
          return this.sortOrder === 'asc' ? dateA - dateB : dateB - dateA;
        });
    },
    paginatedDiscounts() {
      const start = (this.currentPage - 1) * this.itemsPerPage;
      const end = start + this.itemsPerPage;
      return this.filteredDiscounts.slice(start, end);
    },
    totalPages() {
      return Math.ceil(this.filteredDiscounts.length / this.itemsPerPage);
    },
  },
  methods: {
    addDiscount() {
      this.showAddDiscountModal = true;
      this.clearForm();
    },
    editDiscount(discount) {
      this.showEditDiscountModal = true;
      this.discountForm = { ...discount };
    },
    deleteDiscount(id) {
      this.discountCodes = this.discountCodes.filter(discount => discount.id !== id);
    },
    saveDiscount() {
      if (this.showEditDiscountModal) {
        const index = this.discountCodes.findIndex(d => d.id === this.discountForm.id);
        this.discountCodes.splice(index, 1, { ...this.discountForm });
        this.showEditDiscountModal = false;
      } else {
        this.discountForm.id = Date.now(); // Temporary ID generation
        this.discountCodes.push({ ...this.discountForm });
        this.showAddDiscountModal = false;
      }
      this.clearForm();
    },
    closeModal() {
      this.showAddDiscountModal = false;
      this.showEditDiscountModal = false;
    },
    clearForm() {
      this.discountForm = {
        id: null,
        code: '',
        type: 'Percentage',
        discountValue: 0,
        expirationDate: '',
        status: 'Active',
      };
    }
  },
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
  font-family: Arial, sans-serif;
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

.add-btn {
  background-color: #28a745;
  color: #fff;
  padding: 10px 20px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-size: 1rem;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: background-color 0.3s ease;
}

.add-btn:hover {
  background-color: #218838;
}

.card {
  background-color: #fff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}

table {
  width: 100%;
  border-collapse: collapse;
}

th,
td {
  padding: 15px;
  text-align: left;
}

th {
  background-color: #343a40;
  color: #fff;
  font-weight: bold;
  font-size: 0.9rem;
}

.danger {
  color: #dc3545;
}

.success {
  color: #28a745;
}

tr.danger {
  background-color: #f8d7da;
}

tr.success {
  background-color: #d4edda;
}

.edit-btn,
.delete-btn {
  background-color: transparent;
  border: none;
  cursor: pointer;
  font-size: 1.1rem;
}

.edit-btn i {
  color: #007bff;
  transition: color 0.3s ease;
}

.delete-btn i {
  color: #dc3545;
  transition: color 0.3s ease;
}

.edit-btn:hover i {
  color: #0056b3;
}

.delete-btn:hover i {
  color: #c82333;
}

/* Modal Styling */
.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.6);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: #fff;
  padding: 2rem;
  border-radius: 10px;
  width: 100%;
  max-width: 500px;
  position: relative;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.close {
  position: absolute;
  top: 10px;
  right: 15px;
  font-size: 1.5rem;
  font-weight: bold;
  color: #333;
  cursor: pointer;
  transition: color 0.3s;
}

.close:hover {
  color: #ff4c4c;
}

/* Form Styling */
.modal-content h2 {
  margin-bottom: 1rem;
  font-size: 1.5rem;
  color: #333;
}

.modal-content label {
  font-weight: bold;
  color: #555;
  margin-bottom: 0.5rem;
  display: block;
}

.modal-content input[type="text"],
.modal-content input[type="number"],
.modal-content input[type="date"],
.modal-content select {
  width: 100%;
  padding: 0.5rem;
  margin-top: 0.25rem;
  margin-bottom: 1rem;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 1rem;
  transition: border-color 0.3s;
}

.modal-content input:focus,
.modal-content select:focus {
  outline: none;
  border-color: #4a90e2;
}

/* Button Styling */
.modal-content .text-end {
  text-align: right;
}

.modal-content .btn {
  padding: 0.5rem 1.5rem;
  background-color: #4a90e2;
  border: none;
  color: #fff;
  font-size: 1rem;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.modal-content .btn:hover {
  background-color: #357ab9;
}

/* Pagination and Control Styling */
.controls {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 20px;
}

.controls select,
.controls input[type="text"] {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 1rem;
}

.controls input[type="text"] {
  width: 85%;
}

.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 20px;
  gap: 10px;
}

.pagination button {
  padding: 0.5rem 1rem;
  background-color: #4a90e2;
  border: none;
  color: #fff;
  font-size: 1rem;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.pagination button:disabled {
  background-color: #ddd;
  cursor: not-allowed;
}

.pagination button:hover:enabled {
  background-color: #357ab9;
}
/* Make table scrollable on smaller screens */
.table-responsive {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  /* Smooth scrolling for touch devices */
}

table {
  width: 100%;
  border-collapse: collapse;
  min-width: 600px; /* Optional: Set a minimum width for the table */
}
</style>