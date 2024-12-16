<template>
    <div class="text-end m-5" v-if="vnp_TransactionStatus == '00'">
        <RouterLink to="/PurchaseOrder">
            <button class="btn btn-success">History my order</button>
        </RouterLink>
    </div>
    <div v-else class="text-start m-5">
        <RouterLink to="/">
            <button class="btn btn-danger">Return to Shopping</button>
        </RouterLink>
    </div>
    <div class="card container my-5">
        <h2 v-if="vnp_TransactionStatus == '00'" style="color: #4CAF50;"><i
                class="fa-solid fa-circle-check text-success"></i> {{ message }}</h2>
        <h2 v-else style="color: #b92c2c;"><i class="fa-solid fa-circle-xmark text-danger"></i> {{ message }}</h2>
        <p>{{ vnp_OrderInfo }}</p>
        <p>Amount: {{ currencyFormat(vnp_Amount) }}</p>
        <p>Bank Code: {{ vnp_BankCode }}</p>
        <p>Card Type: {{ vnp_CardType }}</p>
        <p>Pay Date: {{ formattedPayDate }}</p>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'TransferVNPayCallback',
    data() {
        return {
            message: "Payment Status",
            vnp_OrderInfo: '',
            vnp_BankCode: '',
            vnp_CardType: '',
            vnp_PayDate: '',
            vnp_TransactionStatus: '',
            vnp_Amount: '',
        };
    },
    computed: {
        formattedPayDate() {
            if (this.vnp_PayDate) {
                return `${this.vnp_PayDate.slice(0, 4)}/${this.vnp_PayDate.slice(4, 6)}/${this.vnp_PayDate.slice(6, 8)}`;
            }
            return 'N/A';
        }
    },
    methods: {
        formatDate(dateString) {
            if (!dateString) return "";
            const date = new Date(dateString);
            return new Intl.DateTimeFormat('vi-VN').format(date);
        },
        currencyFormat(value) {
            if (!value) return "0 VNĐ";
            return new Intl.NumberFormat('vi-VN').format(value) + " VNĐ";
        },
        async updateStatusPayment() {
            try {
                const orderTransferData = JSON.parse(sessionStorage.getItem('OrderTransfer'));
                if (!orderTransferData || !orderTransferData.id) {
                    console.error("OrderTransfer data is missing or invalid in sessionStorage.");
                    return;
                }
                const orderId = orderTransferData.id;
                const orderStatus = {
                    order_id: orderId,
                    status_code: this.vnp_TransactionStatus,
                    payment_type: 'vnpay'
                };
                const response = await axios.post(`http://localhost:8080/api/v1/orders/update_payment_status?order_id=${orderId}&status_code=${this.vnp_TransactionStatus}&payment_type=vnpay`, orderStatus, {
                    headers: {
                        Authorization: `Bearer ${sessionStorage.getItem('accessToken')}`,
                    }
                });
                if (response.data && response.data.status == 200) {
                    console.log("Payment status updated successfully:", response.data);
                } else {
                    console.error("Failed to update payment status:", response.data.message);
                }
            }
            catch (error) {
                console.error("Error during payment status update:", error.message);
            }
        }
    },
    mounted() {
        const urlParams = new URLSearchParams(window.location.search);
        this.vnp_OrderInfo = urlParams.get('vnp_OrderInfo') || 'N/A';
        this.vnp_BankCode = urlParams.get('vnp_BankCode') || 'N/A';
        this.vnp_CardType = urlParams.get('vnp_CardType') || 'N/A';
        this.vnp_PayDate = urlParams.get('vnp_PayDate') || 'N/A';
        this.vnp_TransactionStatus = urlParams.get('vnp_TransactionStatus') || 'N/A';
        this.vnp_Amount = urlParams.get('vnp_Amount') || 'N/A';

        const statusMessages = {
            '00': "Giao dịch thành công",
            '01': "Giao dịch chưa hoàn tất",
            '02': "Giao dịch bị lỗi",
            '04': "Giao dịch đảo ( Khách hàng đã bị trừ tiền tại Ngân hàng nhưng Giao dịch chưa thành công ở VNPAY)",
            '05': "VNPAY đang xử lý giao dịch này (Giao dịch hoàn tiền)",
            '06': "VNPAY đã gửi yêu cầu hoàn tiền sang Ngân hàng (Giao dịch hoàn tiền)",
            '07': "Giao dịch bị nghi ngờ gian lận",
            '08': "Giao dịch quá thời gian thanh toán",
            '09': "GIao dịch hoàn trả bị từ chối",
            '10': "Đã giao hàng",
            '11': "GIao dịch bị huỷ",
            '20': "Giao dịch đã được thanh toán cho merchant",
        };
        this.message = statusMessages[this.vnp_TransactionStatus] || "Đang đợi";
        if (this.vnp_TransactionStatus === '00') {
            this.updateStatusPayment();
        }
    }
};
</script>

<style scoped>
.card {
    padding: 20px;
    border: 1px solid #ddd;
    border-radius: 8px;
}

.container {
    height: 30vh;
}

/* h2 {
    color: rgb(192, 192, 6);
} */
</style>
