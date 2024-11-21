<script>
import axios from 'axios';

export default {
  name: "ForgotPassword",
  props: {
    emailOrPhone: {
      type: String,
      default: '' // Add a default value to prevent issues if not passed
    }
  },
  data() {
    return {
      showNewPassword: false,
      showConfirmPassword: false,
      newPassword: '',
      confirmPassword: '',
      token: '',
      error: '',
    };
  },
  mounted() {
    const urlParamsToken = new URLSearchParams(window.location.search);
    this.token = urlParamsToken.get('token');
  },
  methods: {
    // Toggle password visibility
    toggleNewPasswordVisibility() {
      this.showNewPassword = !this.showNewPassword;
    },
    toggleConfirmPasswordVisibility() {
      this.showConfirmPassword = !this.showConfirmPassword;
    },

    // Function to validate email format
    validateEmail(email) {
      const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return regex.test(email);
    },

    // Function to validate phone number (10 digits)
    validatePhone(phone) {
      const regex = /^\d{10}$/;
      return regex.test(phone);
    },

    // Handle form submission
    async handleChangePassword() {
      if (this.newPassword.length < 8) {
        alert('Password must be at least 8 characters long.');
        return;
      }

      // Check if passwords match
      if (this.newPassword !== this.confirmPassword) {
        this.error = 'passwords do not match.';
        return;
      }
      this.error = '';
      try {
        const response = await axios.post(`http://localhost:8080/api/v1/users/reset_password?token=${this.token}`, {
          password: this.newPassword,
          retype_password: this.confirmPassword
        }, {
          headers: {
            'Content-Type': 'application/json'
          }
        });
        alert(response.data.message);
        this.newPassword = '';
        this.confirmPassword = '';
        this.$router.push('/Login');
      }
      catch (error) {
        this.error = error.response.data.message;
      }
    },

    // Handle back navigation
    handleBack() {
      this.$router.back(); // Navigates to the previous page
    }
  }
};
</script>

<template>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" />

  <div class="container d-flex justify-content-center align-items-center my-5">
    <div class="content d-flex flex-wrap border rounded shadow-lg p-4 justify-content-between">
      <!-- Left content -->
      <div class="ct-left p-5">
        <h2 class="mb-3">Reset Your Password?</h2>
        <!-- Form starts here -->
        <div>
          <form @submit.prevent="handleChangePassword">
            <!-- Create Password -->
            <div class="mb-3 position-relative">
              <label for="new-password" class="form-label">Create Password</label>
              <input v-model="newPassword" :type="showNewPassword ? 'text' : 'password'" class="form-control"
                id="new-password" placeholder="Create password" required />
              <i class="fa-solid" :class="showNewPassword ? 'fa-eye-slash' : 'fa-eye'"
                @click="toggleNewPasswordVisibility"
                style="right: 10px; top: 42px; cursor: pointer; position: absolute"></i>
            </div>

            <!-- Re-enter Password -->
            <div class="mb-3 position-relative">
              <label for="confirm-password" class="form-label">Re-enter Password</label>
              <input v-model="confirmPassword" :type="showConfirmPassword ? 'text' : 'password'" class="form-control"
                id="confirm-password" placeholder="Re-enter password" required />
              <i class="fa-solid" :class="showConfirmPassword ? 'fa-eye-slash' : 'fa-eye'"
                @click="toggleConfirmPasswordVisibility"
                style="right: 10px; top: 42px; cursor: pointer; position: absolute"></i>
            </div>
            <div v-if="error" class="text-danger mt-3">{{ error }}</div>
            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary w-100 mb-3">Submit</button>
          </form>
        </div>
      </div>

      <!-- Right Image -->
      <div class="ct-right d-flex align-item-center">
        <img class="img-fluid" src="@/ImageIcon/Logo2.png" alt="Forgot password" />
      </div>
    </div>
  </div>
</template>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.position-relative .fa-eye {
  cursor: pointer;
}

.content {
  height: auto;
}

.ct-left button {
  text-decoration: none;
}
</style>
