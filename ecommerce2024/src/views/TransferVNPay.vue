<template>
    <div class="container my-5">
        <div class="my-5">
            <h1>Payment VNPay</h1>
            <p>Order: <span class="fw-bold">{{ orderId }}</span></p>
            <p>Shipping Date: <span>{{ shipping_date }}</span></p>
            <p><span>Amount: </span>{{ currencyFormat(amount) }} </p>
            <button @click="paymentVNPay" class="btn btn-primary">
                Pay with VNPay
                <div class="spinner-border text-primary" v-if="loading" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </button>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'TransferVNPay',
    data() {
        return {
            orderId: null,
            amount: null,
            loading: false,
            shipping_date: null,
        };
    },
    created() {
        const orderTransfer = JSON.parse(sessionStorage.getItem('OrderTransfer'));

        if (orderTransfer) {
            this.orderId = orderTransfer.id;
            this.amount = orderTransfer.amount;
            this.shipping_date = orderTransfer.shipping_date;
        } else {
            console.error("No order transfer data found.");
        }
    },
    methods: {
        currencyFormat(value) {
            if (!value) return "0 VNĐ";
            return new Intl.NumberFormat('vi-VN').format(value) + " VNĐ";
        },
        formatDate(dateString) {
            if (!dateString) return "";
            const date = new Date(dateString);
            return new Intl.DateTimeFormat('vi-VN').format(date);
        },
        async paymentVNPay() {
            const orderTransfer = {
                order_id: this.orderId,
                amount: this.amount
            }
            this.loading = true;
            try {
                const response = await axios.post(`http://localhost:8080/api/v1/orders/checkout/vn-pay?order_id=${this.orderId}&amount=${this.amount}`, orderTransfer, {
                    headers: {
                        Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
                    }
                });

                if (response.data.status === 200 && response.data.data) {
                    window.location.href = response.data.data;
                    this.$router.push({ name: 'TransferVNPayCallBack' });
                } else {
                    console.error("Payment initiation failed:", response.data.message);
                }
            } catch (error) {
                console.error("Error during VNPay payment process:", error);
            } finally {
                this.loading = false;
            }
        }
    }
};
</script>

<style scoped>
.container {
    max-width: 500px;
    margin: 0 auto;
    padding: 20px;
    text-align: center;
    height: 40vh;
}
</style>
