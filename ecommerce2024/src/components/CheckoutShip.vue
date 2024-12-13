<template>
    <div class="container">
        <div class="my-3">
            <p class="fw-bold">Select Shipping</p>
            <div class="container">
                <div v-for="(shipment, index) in shipments" :key="index"
                    class="address-item d-flex justify-content-between align-items-center border p-3 my-4">
                    <div class="d-flex align-items-center">
                        <input type="radio" :id="'shipment' + index" name="shipment" v-model="selectedShipmentType"
                            :value="shipment.type" @change="selectShipment(shipment)" class="me-5 custom-radio" />
                        <label :for="'shipment' + index" class="me-3">
                            <span class="fw-bold">{{ shipment.type }}</span>
                            <p>{{ shipment.description }}</p>
                            <div>
                                <small class="text-muted">Delivery by: {{ getShipments(shipment.estimated_day) }}</small>
                            </div>
                        </label>
                    </div>
                    <div>
                        <span class="fw-bold">{{ shipment.price.toFixed(3) }} VND</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'CheckoutShip',
    props: {
        selectedShipment: {
            type: Object,
            default: () => ({})
        }
    },
    data() {
        return {
            selectedShipmentType: null,
            shipments: [
                // {
                //     id:'1',
                //     type: 'Free',
                //     desc: 'Regular shipment',
                //     date: this.getShipments(4),
                //     price: 0,
                // },
                // {
                //     id: '2',
                //     type: 'Standard',
                //     desc: 'Express shipping',
                //     date: this.getShipments(3),
                //     price: 10,
                // },
                // {
                //     id:'3',
                //     type: 'Premium',
                //     desc: 'Priority shipping',
                //     date: this.getShipments(2),
                //     price: 20,
                // }
            ],
        };
    },
    methods: {
        getShipments(day) {
            const today = new Date();
            today.setDate(today.getDate() + day);
            return today.toISOString().split('T')[0];
        },
        selectShipment(shipment) {
            this.$emit('update:selectedShipment', shipment);
        },
        async fetchShipments() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/shipments`,{
                    headers: {
                        Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
                    }
                });
                this.shipments = response.data.data;
            }
            catch(error){
                console.error('Error fetching shipments:', error);  
            }
        }
    },
    mounted() {
        this.fetchShipments();
    }
}
</script>

<style scoped>
.address-item {
    border: 1px solid #e0e0e0;
    border-radius: 5px;
    transition: 0.3s;
}

.address-item:hover {
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
}

.custom-radio {
    width: 20px;
    height: 20px;
    cursor: pointer;
}
</style>
