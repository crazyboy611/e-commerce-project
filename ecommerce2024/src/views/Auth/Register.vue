<template>
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-6 card my-4">
        <div class="px-5 mb-4">
          <h3 class="text-center mt-5">Register</h3>
          <form @submit.prevent="submitForm">
            <!-- Phone Field -->
            <div class="mb-3">
              <label for="registerPhone" class="form-label">Phone<span class="text-danger">(*)</span></label>
              <input type="tel" v-model="register.phone_number" class="form-control" id="registerPhone"
                placeholder="Enter your phone number" required>
              <div v-if="phoneError" class="text-danger mt-2">Please enter a valid 10-digit phone number.</div>
            </div>

            <!-- Fullname Field -->
            <div class="mb-3">
              <label for="registerFullname" class="form-label">Fullname<span class="text-danger">(*)</span></label>
              <input type="text" v-model="register.fullname" class="form-control" id="registerFullname"
                placeholder="Enter your fullname" required>
            </div>

            <!-- Address Field -->
            <div class="mb-3">
              <label for="registerAddress" class="form-label">Address<span class="text-danger">(*)</span></label>
              <input type="text" v-model="register.address" class="form-control" id="registerAddress"
                placeholder="Enter your address" required>
            </div>

            <!-- Email Field -->
            <div class="mb-3">
              <label for="registerEmail" class="form-label">Email address</label>
              <input type="email" v-model="register.email" class="form-control" id="registerEmail"
                placeholder="Enter your email">
              <div v-if="emailError" class="text-danger mt-2">Please enter a valid email address.</div>
            </div>

            <!-- Password Field -->
            <div class="mb-3">
              <label for="registerPassword" class="form-label">Password<span class="text-danger">(*)</span></label>
              <div class="input-group">
                <input :type="showPassword ? 'text' : 'password'" v-model="register.password" class="form-control"
                  id="registerPassword" placeholder="Create a password" required>
                <span class="input-group-text" @click="togglePasswordVisibility">
                  <i :class="showPassword ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye'"></i>
                </span>
              </div>
              <div v-if="passwordError" class="text-danger mt-2">{{ passwordError }}</div>
            </div>

            <!-- Confirm Password Field -->
            <div class="mb-3">
              <label for="confirmPassword" class="form-label">Confirm Password<span class="text-danger">(*)</span></label>
              <div class="input-group">
                <input :type="showConfirmPassword ? 'text' : 'password'" v-model="register.retype_password" class="form-control"
                  id="confirmPassword" placeholder="Confirm your password" required>
                <span class="input-group-text" @click="toggleConfirmPasswordVisibility">
                  <i :class="showConfirmPassword ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye'"></i>
                </span>
              </div>
              <div v-if="confirmPasswordError" class="text-danger mt-2">Passwords do not match!</div>
            </div>

            <!-- Register Button -->
            <button type="submit" class="btn btn-primary w-100">Register</button>
          </form>

          <!-- Login Link -->
          <p class="text-center mt-3">Already have an account? <router-link to="/Login">Login here</router-link></p>

        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'Register',
  data() {
    return {
      register: {
        phone_number: '',
        fullname: '',
        address: '',
        email: '',
        password: '',
        retype_password: '',
        role_id: '2'
      },
      showPassword: false,
      showConfirmPassword: false,
      phoneError: false,
      emailError: false,
      passwordError: '',
      confirmPasswordError: false
    };
  },
  methods: {
    togglePasswordVisibility() {
      this.showPassword = !this.showPassword;
    },
    toggleConfirmPasswordVisibility() {
      this.showConfirmPassword = !this.showConfirmPassword;
    },
    async submitForm() {
      this.resetErrors();

      // Validation
      const phonePattern = /^[0-9]{10}$/;
      if (!phonePattern.test(this.register.phone_number)) {
        this.phoneError = true;
      }

      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (this.register.email && !emailPattern.test(this.register.email)) {
        this.emailError = true;
      }

      if (this.register.password.length < 8) {
        this.passwordError = 'Password must be at least 8 characters long.';
      }

      if (this.register.password !== this.register.retype_password) {
        this.confirmPasswordError = true;
      }

      if (!this.phoneError && !this.emailError && !this.passwordError && !this.confirmPasswordError) {
        try {
          const response = await axios.post(`http://localhost:8080/api/v1/users/register`, this.register);
          if (response.data.status === 200) {
            alert('Registration successful!');
            this.$router.push('/Login');
          } else {
            alert('Registration failed: ' + response.data.message);
          }
        } catch (error) {
          alert(error.response.data.error);
        }
      }
    },
    resetErrors() {
      this.phoneError = false;
      this.emailError = false;
      this.passwordError = '';
      this.confirmPasswordError = false;
    },
    loginWithFacebook() {
      alert('Logging in with Facebook...');
    },
    loginWithGoogle() {
      alert('Logging in with Google...');
    }
  }
};
</script>
<style scoped>
  .container {
  margin-top: 50px;
}

.text-danger {
  font-size: 0.875rem;
}

.hr-with-text {
  display: flex;
  align-items: center;
  text-align: center;
  margin: 20px 0;
}

.hr-with-text hr {
  flex-grow: 1;
  border: none;
  border-top: 1px solid #ccc;
  margin: 0 10px;
}

.hr-with-text span {
  color: #999;
  font-size: 14px;
}

.card {
  background-color: rgb(250, 249, 249);
}

a {
  text-decoration: none;
}
.hr-with-text {
  display: flex;
  align-items: center;
  justify-content: center;
}

.hr-with-text hr {
  flex: 1;
  border-top: 1px solid #dee2e6;
}

.hr-with-text span {
  margin: 0 10px;
  color: #6c757d;
}

.social-login-buttons .btn {
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>
