<template>
  <div class="container">
    <div class="header">
      <h1>Manage Shipments</h1>
      <button class="add-btn" @click="addShipment">
        <i class="fa-solid fa-plus"></i> Add Shipment
      </button>
    </div>
    <div class="card">
      <table>
        <thead>
          <tr>
            <th>Stt</th>
            <th>Description</th>
            <th>Type</th>
            <th>Create Date</th>
            <th>Estimated Delivery</th>
            <th>Price</th>
            <th>Status</th>
            <th>Update Date</th>
            <th>Edit</th>
            <th>Delete</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(shipment, index) in shipments" :key="shipment.id">
            <td>{{ index + 1 }}</td>
            <td>{{ shipment.description }}</td>
            <td class="fw-bold">{{ shipment.type }}</td>
            <td>{{ shipment.createdAt ? shipment.createdAt.split("T")[0] : 'N/A' }}</td>
            <td class="text-center fw-bold">{{ shipment.estimated_day }}</td>
            <td class="fw-bold">{{ shipment.price | currency }} <span class="text-danger me-1">VND</span></td>
            <td v-if="shipment.active == true" class="text-success fw-bold">{{ shipment.active }}</td>
            <td v-else class="text-danger fw-bold">{{ shipment.active }}</td>
            <td>{{ shipment.updatedAt ? shipment.updatedAt.split("T")[0] : 'N/A' }}</td>
            <td>
              <button class="edit-btn" @click="editShipment(shipment)">
                <i class="fa-solid fa-edit"></i>
              </button>
            </td>
            <td>
              <button class="delete-btn" @click="deleteShipment(shipment.id)">
                <i class="fa-solid fa-trash"></i>
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="showAddShipmentModal" class="modal">
      <div class="modal-content">
        <span class="close" @click="closeModal">&times;</span>
        <h2>Add Shipment</h2>
        <form @submit.prevent="handleAddShipment">
          <div>
            <label for="desc">Description</label>
            <input type="text" v-model="newShipment.description" required>
          </div>
          <div>
            <label for="type">Type</label>
            <input type="text" v-model="newShipment.type" required>
          </div>
          <div>
            <label for="">Estimated Delivery Date</label>
            <input type="number" v-model="newShipment.estimated_day" required>
          </div>
          <div>
            <label for="price">Price</label>
            <input type="number" v-model="newShipment.price" required>
          </div>
          <div class="mb-3">
            <label for="active">Active</label>
            <select name="active" id="" v-model="newShipment.active" class="form-select">
              <option :value="true">Yes</option>
              <option :value="false">No</option>
            </select>
          </div>
          <div class="text-end">
            <button class="btn" type="submit">Add Shipment</button>
          </div>
        </form>
      </div>
    </div>
    <div v-if="showEditShipmentModal" class="modal">
      <div class="modal-content">
        <span class="close" @click="closeModal">&times;</span>
        <h2>Update Shipment</h2>
        <form @submit.prevent="handleUpdateShipment(shipmentForm.id)">
          <div>
            <label for="desc">Description</label>
            <input type="text" v-model="shipmentForm.description" required>
          </div>
          <div>
            <label for="type">Type</label>
            <input type="text" v-model="shipmentForm.type" required>
          </div>
          <div>
            <label for="">Estimated Delivery Date</label>
            <input type="number" v-model="shipmentForm.estimated_day" required>
          </div>
          <div>
            <label for="price">Price</label>
            <input type="number" v-model="shipmentForm.price" required>
          </div>
          <div class="mb-3">
            <label for="active">Active</label>
            <select name="active" id="" v-model="shipmentForm.active" class="form-select">
              <option :value="true">Yes</option>
              <option :value="false">No</option>
            </select>
          </div>
          <div class="text-end">
            <button class="btn" type="submit">Update Shipment</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: 'Shipment',
  data() {
    return {
      shipments: [],
      showAddShipmentModal: false,
      showEditShipmentModal: false,
      shipmentForm: {
        id: null,
        description: null,
        type: null,
        estimated_day: null,
        price: null,
        active: null,
      },
      newShipment: {
        description: "",
        type: "",
        estimated_day: null,
        price: null,
        active: null,
      },
    };
  },
  created() {
    this.fetchShipments();
  },
  methods: {
    async fetchShipments() {
      try {
        const response = await axios.get('http://localhost:8080/api/v1/shipments',{
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });
        this.shipments = response.data.data; 
        this.shipmentForm = response.data.data;
      } catch (error) {
        console.error('Error fetching shipments:', error);
      }
    },
    addShipment() {
      this.showAddShipmentModal = true;
      this.clearForm();
    },
    async handleAddShipment() {
      try{
        const response = await axios.post(`http://localhost:8080/api/v1/shipments`,this.newShipment ,{
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });
        alert("Add shipment successfully");
        this.showAddShipmentModal = false;
        window.location.reload();
      }
      catch (error) {
        console.error('Error adding shipment:', error);
      }
    },
    editShipment(shipment) {
      this.showEditShipmentModal = true;
      this.shipmentForm = { ...shipment };
    },
    async handleUpdateShipment(shipmentId){
      try{
        const response = axios.put(`http://localhost:8080/api/v1/shipments/${shipmentId}`,this.shipmentForm,{
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });
        alert("Update shipment successfully");
        this.showEditShipmentModal = false;
        window.location.reload();
      }
      catch (error) {
        console.error('Error updating shipment:', error);
      }
    },
    async deleteShipment(id) {
      confirm("Are you sure you want to delete?");
      try{
        const response = await axios.delete(`http://localhost:8080/api/v1/shipments/${id}`,{
          headers: {
            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
          },
        });
        alert("Delete shipment successfully");
        this.fetchShipments();
      }
      catch (error) {
        console.error('Error deleting shipment:', error);
      }
    },
    
    closeModal() {
      this.showAddShipmentModal = false;
      this.showEditShipmentModal = false;
    },
    clearForm() {
      this.shipmentForm = {
        id: null,
        description: null,
        type: null,
        estimatedDay: null,
        price: null,
      }
    },
  },
  filters: {
    currency(value) {
      return value ? `$${value.toFixed(2)}` : '$0.00';
    },
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
}

.add-btn i {
  margin-right: 5px;
}

.add-btn:hover {
  background-color: #218838;
}

.card {
  background-color: #fff;
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  font-family: 'Arial', sans-serif;
}

th,
td {
  padding: 15px;
  text-align: left;
}

th {
  background-color: #343a40;
  color: #fff;
}

tr:nth-child(even) {
  background-color: #f2f2f2;
}

.edit-btn,
.delete-btn {
  background-color: transparent;
  border: none;
  cursor: pointer;
  font-size: 1.2rem;
}

.edit-btn i {
  color: #007bff;
}

.edit-btn:hover i {
  color: #0056b3;
}

.delete-btn i {
  color: #dc3545;
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
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background-color: #fff;
  padding: 20px;
  border-radius: 10px;
  width: 100%;
  max-width: 400px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
}

.modal-content h2 {
  margin-bottom: 20px;
}

.modal-content label {
  display: block;
  margin-bottom: 5px;
}

.modal-content input {
  width: 100%;
  padding: 8px;
  margin-bottom: 20px;
  border: 1px solid #ccc;
  border-radius: 5px;
}

.close {
  position: absolute;
  top: 10px;
  right: 20px;
  font-size: 1.5rem;
  cursor: pointer;
}

/* Responsive Design */
@media (max-width: 768px) {
  .header h1 {
    font-size: 1.5rem;
  }

  .add-btn {
    padding: 8px 15px;
    font-size: 0.9rem;
  }

  table {
    font-size: 0.9rem;
  }

  th,
  td {
    padding: 10px;
  }
}

@media (max-width: 576px) {
  .card {
    overflow-x: auto;
  }

  table {
    width: 600px;
    /* Ensure the table overflows on small screens */
  }

  th,
  td {
    white-space: nowrap;
    /* Prevent table text from wrapping */
  }

  .modal-content {
    width: 90%;
    max-width: 300px;
  }

  .modal-content h2 {
    font-size: 1.2rem;
  }
}
.text-end button{
  background-color: #8abaee;
  color: white;
  font-weight: 500;
  border: none;
  outline-style: none;
}
.text-end button:hover{
  background-color: #4e81df;
}
</style>