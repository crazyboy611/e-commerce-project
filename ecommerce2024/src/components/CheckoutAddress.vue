<template>
    <div class="container">
        <div class="my-3">
            <p class="fw-bold">Select Address</p>
            <div v-for="(address, index) in addresses" :key="index"
                class="address-item d-flex justify-content-between align-items-center border p-3 my-2">
                <div class="d-flex align-items-center">
                    <input 
                        type="radio" 
                        :id="'address' + index" 
                        name="address" 
                        v-model="selectedAddressLabel" 
                        :value="address.label" 
                        @change="selectAddress(address)" 
                        class="me-5 custom-radio" 
                    />
                    <label :for="'address' + index" class="me-3">
                        <span class="fw-bold">{{ address.label }}</span>
                        <p>{{ address.detail }}</p>
                        <p>{{ address.phone }}</p>
                    </label>
                </div>
                <div>
                    <button class="btn btn-link" @click="editAddress(index)">
                        <i class="fa-solid fa-pencil text-dark"></i>
                    </button>
                    <button class="btn btn-link" @click="confirmRemoveAddress(index)">
                        <i class="fa-solid fa-xmark text-dark"></i>
                    </button>
                </div>
            </div>
            <div class="text-center">
                <button class="btn btn-outline-none" @click="addNewAddress">
                    <div class="circle">
                        <i class="fa-solid fa-square-plus fs-3"></i>
                    </div>
                    Add New Address
                </button>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'CheckoutAddress',
    props: {
        selectedAddress: {
            type: Object,
            default: null
        }
    },
    data() {
        return {
            selectedAddressLabel: null,  // New field to store label of selected address
            addresses: [
                {
                    label: '2118 Thornridge',
                    detail: '2118 Thornridge Cir. Syracuse, Connecticut 35624',
                    phone: '(209) 555-0104',
                    type: 'HOME'
                },
                {
                    label: 'Headoffice',
                    detail: '2715 Ash Dr. San Jose, South Dakota 83475',
                    phone: '(704) 555-0127',
                    type: 'OFFICE'
                },
            ],
        };
    },
    methods: {
        selectAddress(address) {
            this.$emit('update:selectedAddress', address);  // Emit the selected address object to parent
        },
        editAddress(index) {
            const newAddress = prompt('Enter new address details:', JSON.stringify(this.addresses[index]));
            if (newAddress) {
                try {
                    const addressDetails = JSON.parse(newAddress);
                    this.$set(this.addresses, index, addressDetails);
                } catch (e) {
                    alert('Invalid address format. Please try again.');
                }
            }
        },
        confirmRemoveAddress(index) {
            if (confirm('Are you sure you want to delete this address?')) {
                this.removeAddress(index);
            }
        },
        removeAddress(index) {
            this.addresses.splice(index, 1);
        },
        addNewAddress() {
            const newAddress = prompt('Enter new address details (label, detail, phone):', 'Label, Detail, Phone');
            if (newAddress) {
                const [label, detail, phone] = newAddress.split(',').map(item => item.trim());
                if (label && detail && phone) {
                    this.addresses.push({ label, detail, phone });
                } else {
                    alert('Please provide all address details.');
                }
            }
        },
    },
};
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
