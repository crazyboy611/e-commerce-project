<template>
  <div class="container py-5">
    <!-- Header -->
    <div class="header">
      <h1>Manage Contacts</h1>
    </div>

    <!-- Card with Table -->
    <div class="card">
      <div class="card-body p-0">
        <table class="table table-striped table-hover mb-0">
          <thead class="table-primary">
            <tr>
              <th>ID</th>
              <th>Full Name</th>
              <th>Email or Phone</th>
              <th>Content</th>
              <th>Created At</th>
              <th>Delete</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(contact, index) in contacts" :key="contact.id">
              <td>{{ contact.id }}</td>
              <td>{{ contact.fullName }}</td>
              <td>{{ contact.emailOrPhoneNumber }}</td>
              <td>{{ contact.content }}</td>
              <td>{{ formatDate(contact.createdAt.split('T')[0]) }}</td>
              <td>
                <button class="btn btn-danger btn-sm" @click="deleteContact(contact.id)">
                  <i class="fa-solid fa-trash"></i>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Pagination -->
    <div class="d-flex justify-content-between align-items-center mt-4">
      <button class="btn btn-outline-primary" :disabled="currentPage === 0" @click="changePage(currentPage - 1)">
        <i class="fa-solid fa-chevron-left"></i> Previous
      </button>
      <span>Page {{ currentPage + 1 }} of {{ totalPages }}</span>
      <button class="btn btn-outline-primary" :disabled="currentPage === totalPages - 1"
        @click="changePage(currentPage + 1)">
        Next <i class="fa-solid fa-chevron-right"></i>
      </button>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  name: "ContactManagement",
  data() {
    return {
      contacts: [],
      showAddContactModal: false,
      showEditContactModal: false,
      currentPage: 0,
      totalPages: 0,
      pageSize: 5,
      contactForm: {
        id: null,
        full_name: "",
        email_or_phone: "",
        content: "",
        created_at: "",
        updated_at: "",
      },
    };
  },
  mounted() {
    this.fetchContacts();
  },
  methods: {
    formatDate(dateString) {
      if (!dateString) return "";
      const date = new Date(dateString);
      return new Intl.DateTimeFormat('vi-VN').format(date);
    },
    async fetchContacts() {
      try {
        const response = await axios.get(`http://localhost:8080/api/v1/contact_us?size=${this.pageSize}&page=${this.currentPage}`, {
          headers: {
            'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
          }
        });
        this.contacts = response.data.data.content;
        this.currentPage = response.data.data.pageable.pageNumber;
        this.totalPages = response.data.data.totalPages;

      } catch (error) {
        console.error("Failed to fetch contacts:", error);
      }
    },
    async deleteContact(id) {
      if (!confirm("Are you sure you want to delete this contact?")) {
        return;
      }
      try {
        const response = await axios.delete(`http://localhost:8080/api/v1/contact_us/${id}`, {
          headers: {
            'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
          }
        });
        this.contacts = this.contacts.filter((contact) => contact.id !== id);
        this.fetchContacts();
      } catch (error) {
        console.error("Failed to delete contact:", error);
      }
    },
    changePage(page) {
      if (page >= 0 && page < this.totalPages) {
        this.currentPage = page;
        this.fetchContacts();
      }
    },
    closeModal() {
      this.showAddContactModal = false;
      this.showEditContactModal = false;
    },
  },
};
</script>

<style scoped>
.card {
  border: 1px solid #dee2e6;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  border-radius: 0.5rem;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding: 1rem;
  border-bottom: 1px solid #dee2e6;
  background-color: #f8f9fa;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  border-radius: 0.5rem 0.5rem 0 0;
}

.modal-content {
  border-radius: 0.5rem;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}
</style>