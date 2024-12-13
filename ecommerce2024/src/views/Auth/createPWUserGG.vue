<template>
    <div class="d-flex justify-content-center align-items-center">
        <div class="col-md-6">
            <h2 class="text-center">Tạo Mật Khẩu</h2>
            <form @submit.prevent="changePassword">
                <div class="mb-3">
                    <label for="newPassword" class="form-label">Mật khẩu mới</label>
                    <input 
                        type="password" 
                        id="newPassword" 
                        class="form-control" 
                        v-model="newPassword" 
                        @input="clearError" 
                        required 
                        placeholder="Nhập mật khẩu mới"
                    >
                </div>
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                    <input 
                        type="password" 
                        id="confirmPassword" 
                        class="form-control" 
                        v-model="confirmPassword" 
                        @input="clearError" 
                        required 
                        placeholder="Xác nhận mật khẩu mới"
                    >
                </div>
                <button type="submit" class="btn btn-primary w-100" :disabled="isSubmitting">Tạo mật khẩu</button>
                <div v-if="error" class="text-danger mt-3">{{ error }}</div>
                <div v-if="successMessage" class="text-success mt-3">{{ successMessage }}</div>
            </form>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'CreatePassword',
    data() {
        return {
            newPassword: '',
            confirmPassword: '',
            error: '',
            successMessage: '',
            isSubmitting: false,
        };
    },
    methods: {
        clearError() {
            this.error = '';
            this.successMessage = '';
        },
        async changePassword() {
            // Validate input before sending request
            if (this.newPassword !== this.confirmPassword) {
                this.error = 'Mật khẩu không khớp. Vui lòng kiểm tra lại.';
                return;
            }

            if (this.newPassword.length < 8) {
                this.error = 'Mật khẩu phải có ít nhất 8 ký tự.';
                return;
            }

            // Prepare data for API call
            const payload = {
                password: this.newPassword,
                retype_password: this.confirmPassword
            };

            this.isSubmitting = true;
            try {
                const response = await axios.post(
                    'http://localhost:8080/api/v1/users/create_password',
                    payload,
                    {
                        headers: {
                            'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                        }
                    }
                );

                // Handle success response
                this.successMessage = response.data.message || 'Đổi mật khẩu thành công!';
                this.newPassword = '';
                this.confirmPassword = '';
                this.$router.push('/');
            } catch (error) {
                // Handle error response
                this.error = error.response?.data?.message || 'Có lỗi xảy ra. Vui lòng thử lại sau.';
            } finally {
                this.isSubmitting = false;
            }
        },
    },
};
</script>

<style scoped>
.d-flex {
    height: 50vh;
}

h2 {
    margin-bottom: 20px;
}

.btn[disabled] {
    cursor: not-allowed;
    opacity: 0.6;
}
</style>
