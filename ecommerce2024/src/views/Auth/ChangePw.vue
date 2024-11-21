<template>
  <div class="d-flex justify-content-center align-items-center vh-100">
    <div class="col-md-6">
      <h2 class="text-center">Đổi Mật Khẩu</h2>
      <form @submit.prevent="changePW">
        <div class="mb-3">
          <label for="currentPassword" class="form-label">Mật khẩu hiện tại</label>
          <input type="password" class="form-control" v-model="currentPassword" required>
        </div>
        <div class="mb-3">
          <label for="newPassword" class="form-label">Mật khẩu mới</label>
          <input type="password" class="form-control" v-model="newPassword" required>
        </div>
        <div class="mb-3">
          <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
          <input type="password" class="form-control" v-model="confirmPassword" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Đổi mật khẩu</button>
        <div v-if="error" class="text-danger mt-3">{{ error }}</div>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'ChangePassword',
  data() {
    return {
      currentPassword: '',
      newPassword: '',
      confirmPassword: '',
      error: '' // Thông báo lỗi
    };
  },
  mounted() {
    this.fetchProfile();
  },
  methods: {
    handleChangePassword() {
      // Kiểm tra xem mật khẩu mới và xác nhận mật khẩu có khớp không
      if (this.newPassword !== this.confirmPassword) {
        this.error = 'Mật khẩu không khớp.';
      } else {
        this.error = '';
        alert('Đổi mật khẩu thành công!');
        // Thêm xử lý đổi mật khẩu ở đây, ví dụ: gửi dữ liệu lên server
      }
    },
    async fetchProfile() {
      try {
        const response = await axios.get('http://localhost:8080/api/v1/users/detail', {
          headers: {
            'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
          }
        });
        if (response.data.status === 200) {
          const profileData = response.data.data;
          this.id = profileData.id;
          this.username = profileData.full_name;
          this.phone = profileData.phone_number;
          this.email = profileData.email;
          this.address = profileData.address;
          this.profileImage = profileData.profile_image;
          this.role_id = profileData.role_id;
          sessionStorage.setItem("id", this.id);
        } else {
          console.log(response.data.message);
        }
      } catch (error) {
        console.log(error);
      }
    },
    async changePW() {
      try {
        const response = await axios.post(`http://localhost:8080/api/v1/users/change_password/${sessionStorage.getItem('id')}`, {
          password: this.currentPassword,
          new_password: this.newPassword,
          confirm_password: this.confirmPassword
        }, {
          headers: {
            'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
            'Content-Type': 'application/json'
          }
        });
        if (response.data.status === 200) {
          alert(response.data.message);
          sessionStorage.removeItem('accessToken'); // Remove user token from sessionStorage
          sessionStorage.removeItem('fullName'); // Remove username from sessionStorage
          this.$router.push('/Login');
        }
      }
      catch (error) {
        alert(error.response.data.message);
      }
    }
  }
};
</script>

<style scoped>
/* Thêm CSS nếu cần */
</style>