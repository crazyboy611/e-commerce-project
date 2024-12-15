<template>
    <div class="">
        <div class="my-3">
            <form @submit.prevent="handlePayment">
                <div class="d-flex justify-content-between flex-wrap">
                    <div class="list-product" v-if="selectedItems && selectedItems.length > 0">
                        <p class="fw-bold">Summary</p>
                        <div class="my-3 list-cart">
                            <div class=" list-group list-group-flush" v-for="(item, index) in selectedItems"
                                :key="item.id">
                                <div class="d-flex align-items-center my-3">
                                    <div class="me-3">
                                        <img :src="`http://localhost:8080/api/v1/products/images/${item.thumbnail}`"
                                            alt="Product Image" width="100px" />
                                    </div>
                                    <div class="me-3 flex-grow-1">
                                        <p class="product-name text-bold mb-0">{{ item.name }}</p>
                                    </div>
                                    <div class="quantity d-flex align-items-center mx-3">
                                        <button class="btn btn-outline-secondary btn-quantity"
                                            @click="decreaseQuantity(item)"><i
                                                class="fa-solid fa-minus fw-bold"></i></button>
                                        <input type="text" class="form-control text-center quantity-input"
                                            v-model="item.quantity" readonly />
                                        <button class="btn btn-outline-secondary btn-quantity"
                                            @click="increaseQuantity(item)"><i
                                                class="fa-solid fa-plus fw-bold"></i></button>
                                    </div>
                                    <div class="price me-3">
                                        <p class="mb-0 fw-bold">{{ currencyFormat(item.price * item.quantity) }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div v-else>
                        <p>No items in the cart.</p>
                    </div>
                    <div class="payment card p-5">
                        <p class="text-center fw-bold fs-4">Total</p>
                        <div v-if="isEmail" class="mt-3">
                            <label for="phone">Phone Number</label>
                            <input type="text" id="phone" v-model="receiverPhoneNumber" class="form-control"
                                placeholder="Enter your phone number" required />
                        </div>
                        <div v-else class="mt-3">
                            <label for="phone">Phone Number</label>
                            <input type="text" id="phone" v-model="receiverPhoneNumber" class="form-control" required />
                        </div>
                        <div class="total mt-3">
                            <form @submit.prevent="validateDiscountCode">
                                <label for="discount-code">Discount code</label><br />
                                <input type="text" name="discount-code" id="discount-code" placeholder="Code"
                                    v-model="enteredCode" @blur="validateDiscountCode" />
                                <div class="error-message text-danger">{{ errorMessage }}</div>
                                <div class="payment-options d-flex">
                                    <input class="me-1" type="radio" name="payment" id="cash" value="cash"
                                        v-model="paymentMethod" />
                                    <label class="me-5" for="cash">Pay cash</label>
                                    <input class="me-1" type="radio" name="payment" id="vnpay" value="vnpay"
                                        v-model="paymentMethod" />
                                    <label for="bank">Bank transfer</label><br />
                                </div>
                            </form>
                        </div>
                        <p class="mt-3"><strong>Address:</strong></p>
                        <input type="text" id="address" v-model="addressUser" class="form-control mb-3"
                            placeholder="Enter your address" required />
                        <p class="fw-bold">Shipment Method: </p>
                        <div class="d-flex justify-content-between">
                            <div class="me-4">
                                <p class="fw-bold text-danger">{{ selectedShipment.type }}</p>
                            </div>
                            <div class="me-3">
                                <p class="fw-bold text-danger">{{ currencyFormat(selectedShipment.price) }}</p>
                            </div>
                        </div>
                        <div class="d-flex justify-content-between">
                            <div class="me-4">
                                <p>Subtotal:</p>
                                <p v-if="isDiscountApplied" class="text-danger fw-bold">Discount</p>
                                <p class="fs-4">Total:</p>
                            </div>
                            <div>
                                <p>{{ calculateSubtotal().toFixed(3) }} VND</p>
                                <p v-if="isDiscountApplied" class="text-danger">
                                    {{ isDiscountApplied ? '-29.000' : '0' }} VND
                                </p>
                                <p class="fs-4 text-danger">{{ currencyFormat(calculateTotal()) }}</p>
                            </div>
                        </div>
                        <div class="mt-3 text-start">
                            <input type="checkbox" v-model="isTotalConfirmed" required /> Confirm total
                        </div>
                        <div class="text-end" v-if="paymentMethod === 'vnpay'">
                            <button type="submit" class="btn btn-primary mt-3">Order and Transfer</button>
                        </div>
                        <div class="text-end" v-if="paymentMethod === 'cash'">
                            <button type="submit" class="btn btn-primary mt-3">Order</button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'CheckoutPayment',
    props: {
        selectedShipment: {
            type: Object,
            required: true,
        },
        isDiscountApplied: {
            type: Boolean,
            default: false,
        },
    },
    data() {
        return {
            selectedItems: [],
            isTotalConfirmed: false,
            paymentMethod: '',
            discountCode: [
                {
                    code: '10102004duc',
                },
            ],
            isDiscountApplied: false,
            errorMessage: '',
            enteredCode: '',
            receiverPhoneNumber: '',
            addressUser: '',
            isEmail: false,
        };
    },
    async created() {
        const storedselectedItems = sessionStorage.getItem('checkProductCart');
        this.selectedItems = storedselectedItems ? JSON.parse(storedselectedItems) : [];
        if (!Array.isArray(this.selectedItems)) {
            this.selectedItems = [];
        }

        this.selectedItems.forEach(item => {
            if (!item.quantity || item.quantity < 1) {
                item.quantity = 1;
            }
        });
        this.isLoading = true;
        try {
            const response = await axios.get('http://localhost:8080/api/v1/users/detail', {
                headers: {
                    'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                }
            });
            const address = response.data.data.address || '';
            const phoneNumber = response.data.data.phone_number;
            if (phoneNumber || address) {
                this.addressUser = address;
                this.receiverPhoneNumber = phoneNumber;
            } else {
                this.isEmail = true;
            }
        } catch (error) {
            this.isEmail = true;
        }
        finally {
            this.isLoading = false;
        }
    },
    methods: {
        currencyFormat(value) {
            if (!value) return "0 VNĐ";
            return new Intl.NumberFormat('vi-VN').format(value) + " VNĐ";
        },
        increaseQuantity(item) {
            if (item.quantity < item.quantityInStock) {
                item.quantity++;
                this.updateSessionCart();
            }
            else{
                alert("Not enough products");
            }
        },
        decreaseQuantity(item) {
            if (item.quantity > 1) {
                item.quantity--;
                this.updateSessionCart();
            }
        },
        updateSessionCart() {
            sessionStorage.setItem('selectedItems', JSON.stringify(this.selectedItems));
            this.$emit('update-cart', this.selectedItems);
        },
        calculateSubtotal() {
            return this.selectedItems.reduce((total, item) => total + item.price * item.quantity, 0);
        },
        calculateTotal() {
            const subtotal = this.calculateSubtotal();
            const shippingAndHandling = this.isDiscountApplied ? 29 : 0; // Adjust based on discount
            return subtotal - shippingAndHandling + this.selectedShipment.price;
        },
        validateDiscountCode() {
            const isValidCode = this.discountCode.some((code) => code.code === this.enteredCode.trim());

            if (isValidCode) {
                this.isDiscountApplied = true;
                this.errorMessage = '';
            } else {
                this.isDiscountApplied = false;
                this.errorMessage = 'Invalid discount code. Please try again.';
            }
        },
        // generateQRCode() {
        //     const paymentInfo = {
        //         bankAccount: '0865172698',
        //         bankName: 'MB Bank', 
        //         amount: this.calculateTotal().toFixed(2), 
        //         description: `Thanh toán đơn hàng Order code: ${this.orderId}`, 
        //         currency: 'VND', 
        //     };

        //     const qrCodeData = `BANKCODE1010_BANKFORCYBERTEAM7CC_TO${paymentInfo.bankAccount}_${paymentInfo.amount} ${paymentInfo.currency}_${paymentInfo.description}`;

        //     QRCode.toCanvas(this.$refs.qrcodeCanvas, qrCodeData, { width: 200 }, (error) => {
        //         if (error) console.error(error);
        //         console.log('QR code thanh toán đã được tạo!');
        //     });
        // },
        // generateOrderId() {
        //     const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        //     let orderId = '';
        //     for (let i = 0; i < 10; i++) {
        //         const randomIndex = Math.floor(Math.random() * characters.length);
        //         orderId += characters[randomIndex];
        //     }
        //     return orderId;
        // },
        async handlePayment() {
            const amount = this.calculateTotal().toFixed(2);
            const orderDetails = {
                selectedItems: this.selectedItems.map((item) => ({
                    id: item.id,
                    name: item.name,
                    quantity: item.quantity,
                    price: item.price,
                    total: (item.price * item.quantity).toFixed(2),
                })),
                receiver_full_name: sessionStorage.getItem('fullName'),
                receiver_phone_number: this.isEmail ? this.receiverPhoneNumber : sessionStorage.getItem('emailOrPhone'),
                status: 'pending',
                shipment_id: this.selectedShipment.id,
                shipping_address: this.addressUser,
                shipping_date: this.selectedShipment.date,
                cart_items: this.selectedItems.map((item) => ({
                    product_id: item.id,
                    name: item.name,
                    quantity: item.quantity,
                })),
                payment_details: {
                    amount: amount,
                    provider: this.paymentMethod
                }

            };
            try {
                const response = await axios.post(
                    `http://localhost:8080/api/v1/orders?payment_type=${this.paymentMethod}`,
                    orderDetails,
                    {
                        headers: {
                            Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
                            'Content-Type': 'application/json'
                        }
                    }
                );

                if (response && response.data && response.data.status === 200) {
                    const totalAmount = this.calculateTotal(); // Ensure correct total calculation

                    if (this.paymentMethod === 'cash') {
                        alert(`Payment of ${totalAmount.toFixed(2)} VND in cash processed successfully!`);
                        sessionStorage.removeItem('checkProductCart');
                        this.$router.push({ name: 'PurchaseOrder' });
                    } else if (this.paymentMethod === 'vnpay') {
                        alert(`Payment of ${totalAmount.toFixed(2)} VND via bank transfer processed successfully!`);
                        sessionStorage.removeItem('checkProductCart');
                        const orderTransfer = {
                            id: response.data.data.id,
                            amount: response.data.data?.payment_details.amount,
                        };

                        if (orderTransfer.id && orderTransfer.amount) {
                            sessionStorage.setItem('OrderTransfer', JSON.stringify(orderTransfer));
                            this.$router.push({ name: 'TransferVNPay' });
                        } else {
                            alert('Order transfer details are missing.');
                        }
                    } else {
                        alert('Please select a payment method.');
                        return;
                    }
                } else {
                    alert('Unexpected response from the server. Please try again.');
                }
            } catch (error) {
                const errorMessage = error.response?.data?.error || 'An unknown error occurred.';
                alert('An error occurred while processing your payment. Please try again later. ' + errorMessage);
            }
        },
    }
};
</script>

<style scoped>
.container {
    font-size: 18px;
    max-width: 1200px;
    /* Added max-width for better layout control */
    margin: 0 auto;
    /* Center the container */
}

.text-throught {
    text-decoration: line-through;
}

.list-product {
    width: 100%;
    /* Use full width for responsiveness */
    max-width: 600px;
    /* Set a maximum width for larger screens */
    margin-bottom: 2rem;
    /* Add spacing below the product list */
}

.payment {
    width: 50%;
    background-color: rgb(238, 237, 237);
    border-radius: 8px;
    /* Added border radius for smoother edges */
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    /* Subtle shadow for elevation */
    padding: 2rem;
    /* Increased padding for a better look */
}

.payment .text-end button {
    width: 100%;
    /* Full width for better accessibility */
    padding: 0.75rem;
    /* Added padding for better button size */
    font-size: 1.2rem;
    /* Increased font size for better readability */
}

.total {
    font-size: 18px;
}

.total p {
    font-weight: 500;
}

.total #discount-code {
    width: 100%;
    margin: 10px 0;
    padding: 10px;
    /* Unified padding */
    border: 1px solid rgb(216, 213, 213);
    border-radius: 10px;
    overflow: hidden;
    /* Adjusted to ensure good visual flow */
}

.total label {
    font-weight: 500;
    margin-bottom: 0.5rem;
    /* Added spacing below labels */
    display: block;
    /* Ensure labels are on separate lines */
}

.total .my-4 {
    width: 100%;
    margin: 10px 0;
    padding: 10px;
    border: 1px solid rgb(216, 213, 213);
    border-radius: 10px;
}

.total .date,
.total .cvv {
    width: 45%;
    /* Adjusted width for better spacing */
    padding: 10px;
    border: 1px solid rgb(216, 213, 213);
    border-radius: 10px;
    margin-right: 5%;
    /* Add spacing between date and CVV inputs */
}

.total .date:last-child,
.total .cvv:last-child {
    margin-right: 0;
    /* Remove right margin on the last input */
}

.total button {
    width: 100%;
}

.error-message {
    margin: 10px 0;
    font-size: 14px;
    color: red;
    /* Explicitly set error message color */
}

/* Responsive design adjustments */
@media (max-width: 768px) {
    .list-product {
        width: 100%;
        /* Full width on smaller screens */
    }

    .payment {
        padding: 1.5rem;
        /* Reduced padding for smaller screens */
    }

    .total .date,
    .total .cvv {
        width: 100%;
        /* Full width for inputs on smaller screens */
        margin-right: 0;
        /* Reset margin */
        margin-bottom: 1rem;
        /* Add spacing below inputs */
    }

    .total button {
        font-size: 1rem;
        /* Adjust button font size */
    }
}

.btn-quantity {
    border: none;
    width: 30px;
    height: 30px;
    padding: 0;
    font-weight: 600;
}

.btn-quantity:hover {
    cursor: pointer;
    background-color: rgb(233, 230, 230);
    color: black;
    font-weight: 600;
}

.quantity-input {
    width: 50px;
    border: none;
    text-align: center;
    font-weight: 600;
}
</style>
