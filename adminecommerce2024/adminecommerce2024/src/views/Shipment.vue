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
            <th>Shipment</th>
            <th>Type</th>
            <th>Estimated Delivery Date</th>
            <th>Price</th>
            <th>Edit</th>
            <th>Delete</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(shipment, index) in shipments" :key="shipment.id">
            <td>{{ index + 1 }}</td>
            <td>{{ shipment.desc }}</td>
            <td class="fw-bold">{{ shipment.type }}</td>
            <td>{{ shipment.estimatedDeliveryDate }}</td>
            <td class="fw-bold"><span class="text-danger me-1">$</span>{{ shipment.price | currency }}</td>
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

    <!-- Add/Edit Shipment Modal -->
    <div v-if="showAddShipmentModal || showEditShipmentModal" class="modal">
      <div class="modal-content">
        <span class="close" @click="closeModal">&times;</span>
        <h2>{{ showEditShipmentModal ? 'Edit Shipment' : 'Add Shipment' }}</h2>
        <form @submit.prevent="saveShipment">
          <div>
            <label for="desc">Description</label>
            <input type="text" v-model="shipmentForm.desc" required>
          </div>
          <div>
            <label for="type">Type</label>
            <input type="text" v-model="shipmentForm.type" required>
          </div>
          <div>
            <label for="date">Estimated Delivery Date</label>
            <input type="date" v-model="shipmentForm.estimatedDeliveryDate" required>
          </div>
          <div>
            <label for="price">Price</label>
            <input type="number" v-model="shipmentForm.price" required min="0">
          </div>
          <div class="text-end">
            <button class="btn" type="submit">{{ showEditShipmentModal ? 'Update' : 'Add' }} Shipment</button>
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
      shipments: [
        {
          id: 1,
          desc: 'Regular shipment',
          type: 'Free',
          estimatedDeliveryDate: '2022-01-01',
          price: 0.00,
        },
        {
          id: 2,
          desc: 'Express shipping',
          type: 'Standard',
          estimatedDeliveryDate: '2022-01-02',
          price: 20.00,
        },
      ],
      showAddShipmentModal: false,
      showEditShipmentModal: false,
      shipmentForm: {
        id: null,
        desc: '',
        type: '',
        estimatedDeliveryDate: '',
        price: 0,
      },
    };
  },

  methods: {
    // async fetchShipment(){
    //   try {
    //     const response = await axios.get('')
    //   } catch (error) {
        
    //   }
    // },
    addShipment() {
      this.showAddShipmentModal = true;
      this.clearForm();
    },
    editShipment(shipment) {
      this.showEditShipmentModal = true;
      this.shipmentForm = { ...shipment };
    },
    deleteShipment(id) {
      this.shipments = this.shipments.filter(shipment => shipment.id !== id);
    },
    saveShipment() {
      if (this.showEditShipmentModal) {
        const index = this.shipments.findIndex(s => s.id === this.shipmentForm.id);
        this.shipments.splice(index, 1, { ...this.shipmentForm });
        this.showEditShipmentModal = false;
      } else {
        this.shipmentForm.id = Date.now(); // Temporary ID generation
        this.shipments.push({ ...this.shipmentForm });
        this.showAddShipmentModal = false;
      }
      this.clearForm();
    },
    closeModal() {
      this.showAddShipmentModal = false;
      this.showEditShipmentModal = false;
    },
    clearForm() {
      this.shipmentForm = {
        id: null,
        desc: '',
        type: '',
        estimatedDeliveryDate: '',
        price: 0,
      };
    }
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