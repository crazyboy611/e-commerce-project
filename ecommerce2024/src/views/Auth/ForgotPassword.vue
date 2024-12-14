<script>
import axios from 'axios';

export default {
  name: "ForgotPassword",
  data() {
    return {
      showNewPassword: false,
      showConfirmPassword: false,
      emailOrPhone: '',
      emailOrPhoneError: '', // For validation errors
    };
  },
  computed: {
    // Use a computed property to link the input value to the prop
    emailOrPhoneInput: {
      get() {
        return this.emailOrPhone;
      },
      set(value) {
        this.$emit('update:emailOrPhone', value); // Emit the updated value to parent
      }
    }
  },
  mounted() {
    // Retrieve emailOrPhone from sessionStorage when the component is mounted
    const storedEmailOrPhone = sessionStorage.getItem("emailOrPhone");
    if (storedEmailOrPhone) {
      this.emailOrPhone = storedEmailOrPhone;
    }
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
    validateEmail() {
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      return emailPattern.test(this.emailOrPhone);
    },

    // Function to validate phone number (10 digits)
    validatePhone() {
      const phonePattern = /^\d{10}$/;
      return phonePattern.test(this.emailOrPhone);
    },

    // Handle form submission
    async fetchForgotPW() {
      // Input validation for email or phone
      if (!this.validateEmail() && !this.validatePhone()) {
        this.emailOrPhoneError = "Please enter a valid email or a 10-digit phone number.";
        return;
      } else {
        this.emailOrPhoneError = ""; // Clear the error message if valid
      }

      try {
        // Send forgot password request
        const response = await axios.post(
          `http://localhost:8080/api/v1/users/forgot_password?email=${this.emailOrPhone}`,
          {
            headers: {
              'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
            },
          }
        );

        if (response.status === 200) {
          alert(response.data.message);
        } else {
          alert("Failed to send password reset link.");
        }
      } catch (error) {
        console.error(error);
        alert(error.response?.data?.error || "An error occurred. Please try again.");
      }
    },

    handleBack() {
      this.$router.back(); 
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
        <div class="d-flex align-items-center mb-4 text-dark">
          <button @click="handleBack" class="btn btn-link text-dark">
            <i class="fa-solid fa-arrow-left me-2"></i> Back
          </button>
        </div>
        <h2 class="mb-3">Forgot Your Password?</h2>
        <!-- Form starts here -->
        <div>
          <form @submit.prevent="fetchForgotPW">
            <!-- Text input -->
            <div class="mb-3">
              <label for="Text" class="form-label">Email or Phone</label>
              <input v-model="emailOrPhoneInput" type="text" class="form-control" id="Text"
                placeholder="Enter your Email or Phone" required />
            </div>


            <!-- Submit Button -->
            <button type="submit" class="btn btn-primary w-100 mb-3" >Submit</button>
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
