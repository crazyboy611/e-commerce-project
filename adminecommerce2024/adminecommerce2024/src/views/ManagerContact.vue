<template>
    <div class="container py-5">
      <!-- Header -->
      <div class="header">
        <h1>Manage Contacts</h1>
        <button class="btn btn-success" @click="addContact">
          <i class="fa-solid fa-plus"></i> Add Contact
        </button>
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
                <th>Updated At</th>
                <th>Edit</th>
                <th>Delete</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(contact, index) in contacts" :key="contact.id">
                <td>{{ contact.id }}</td>
                <td>{{ contact.full_name }}</td>
                <td>{{ contact.email_or_phone }}</td>
                <td>{{ contact.content }}</td>
                <td>{{ contact.created_at.split('T')[0] }}</td>
                <td>{{ contact.updated_at.split('T')[0] }}</td>
                <td>
                  <button class="btn btn-primary btn-sm" @click="editContact(contact)">
                    <i class="fa-solid fa-edit"></i>
                  </button>
                </td>
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
        <button class="btn btn-outline-primary" :disabled="currentPage === totalPages - 1" @click="changePage(currentPage + 1)">
          Next <i class="fa-solid fa-chevron-right"></i>
        </button>
      </div>
  
      <!-- Add/Edit Contact Modal -->
      <div v-if="showAddContactModal || showEditContactModal" class="modal fade show d-block" tabindex="-1">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title">{{ showEditContactModal ? 'Edit Contact' : 'Add Contact' }}</h5>
              <button type="button" class="btn-close" @click="closeModal"></button>
            </div>
            <div class="modal-body">
              <form @submit.prevent="saveContact">
                <div class="mb-3">
                  <label class="form-label">Full Name</label>
                  <input type="text" class="form-control" v-model="contactForm.full_name" required>
                </div>
                <div class="mb-3">
                  <label class="form-label">Email or Phone</label>
                  <input type="text" class="form-control" v-model="contactForm.email_or_phone" required>
                </div>
                <div class="mb-3">
                  <label class="form-label">Content</label>
                  <textarea class="form-control" v-model="contactForm.content" required></textarea>
                </div>
                <div class="mb-3">
                  <label class="form-label">Created At</label>
                  <input type="date" class="form-control" v-model="contactForm.created_at" required>
                </div>
                <div class="mb-3">
                  <label class="form-label">Updated At</label>
                  <input type="date" class="form-control" v-model="contactForm.updated_at">
                </div>
                <div class="text-end">
                  <button type="submit" class="btn btn-success">
                    {{ showEditContactModal ? 'Update' : 'Add' }} Contact
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
      async fetchContacts() {
        try {
          const response = await axios.get(
            `http://localhost:8080/api/v1/contacts?size=${this.pageSize}&page=${this.currentPage}`
          );
          this.contacts = response.data.data.contacts;
          this.currentPage = response.data.data.page_no;
          this.totalPages = response.data.data.total_pages;
        } catch (error) {
          console.error("Failed to fetch contacts:", error);
        }
      },
      addContact() {
        this.showAddContactModal = true;
        this.clearForm();
      },
      editContact(contact) {
        this.showEditContactModal = true;
        this.contactForm = { ...contact };
      },
      async deleteContact(id) {
        try {
          await axios.delete(`http://localhost:8080/api/v1/contacts/${id}`);
          this.contacts = this.contacts.filter((contact) => contact.id !== id);
        } catch (error) {
          console.error("Failed to delete contact:", error);
        }
      },
      async saveContact() {
        if (this.showEditContactModal) {
          try {
            await axios.put(
              `http://localhost:8080/api/v1/contacts/${this.contactForm.id}`,
              this.contactForm
            );
            const index = this.contacts.findIndex(
              (c) => c.id === this.contactForm.id
            );
            this.contacts.splice(index, 1, { ...this.contactForm });
          } catch (error) {
            console.error("Failed to update contact:", error);
          }
        } else {
          try {
            const response = await axios.post(
              "http://localhost:8080/api/v1/contacts",
              this.contactForm
            );
            this.contacts.push(response.data);
          } catch (error) {
            console.error("Failed to add contact:", error);
          }
        }
        this.closeModal();
        this.clearForm();
      },
      changePage(page) {
        if (page >= 0 && page < this.totalPages) {
          this.currentPage = page;
          this.fetchContacts();
          window.scrollTo({ top: 0, behavior: "smooth" });
        }
      },
      closeModal() {
        this.showAddContactModal = false;
        this.showEditContactModal = false;
      },
      clearForm() {
        this.contactForm = {
          id: null,
          full_name: "",
          email_or_phone: "",
          content: "",
          created_at: "",
          updated_at: "",
        };
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
  