<template>
  <div class="container mt-5">
    <div class="row justify-content-around mx-2">
      <div class="col-md-4 d-flex align-items-center">
        <img :src="require('@/ImageLogo/Logo2.png')" class="img-fluid" alt="Login Image" />
      </div>
      <div class="col-md-5 card mb-5">
        <!-- Login Form -->
        <div id="loginForm" class="form-container active p-3">
          <h3 class="text-center mt-5">Login</h3>
          <form @submit.prevent="login" class="mb-5">
            <div class="mb-3">
              <label for="loginPhoneOrEmail" class="form-label">Phone or Email</label>
              <input v-model="emailOrPhone" type="text" class="form-control" id="loginPhoneOrEmail"
                placeholder="Enter your phone or email" @blur="validateEmailOrPhone" required />
              <small class="text-danger">{{ emailOrPhoneError }}</small>
            </div>
            <div class="mb-3">
              <label for="loginPassword" class="form-label">Password</label>
              <div class="input-group">
                <input v-model="password" :type="showPassword ? 'text' : 'password'" class="form-control"
                  id="loginPassword" placeholder="Enter your password" @blur="validatePassword" required />
                <span class="input-group-text" @click="togglePasswordVisibility">
                  <i :class="showPassword ? 'fa-solid fa-eye-slash' : 'fa-solid fa-eye'"></i>
                </span>
              </div>
              <small class="text-danger">{{ passwordError }}</small>
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: "SignIn",
  data() {
    return {
      emailOrPhone: "",
      password: "",
      showPassword: false,
      emailOrPhoneError: "",
      passwordError: "",
    };
  },
  methods: {
    togglePasswordVisibility() {
      this.showPassword = !this.showPassword;
    },
    validateEmailOrPhone() {
      const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      const phonePattern = /^[0-9]{10}$/;
      if (!emailPattern.test(this.emailOrPhone) && !phonePattern.test(this.emailOrPhone)) {
        this.emailOrPhoneError = "Please enter a valid email or phone number.";
      } else {
        this.emailOrPhoneError = "";
      }
    },
    validatePassword() {
      if (this.password.length < 8) {
        this.passwordError = "Password must be at least 8 characters long.";
      } else {
        this.passwordError = "";
      }
    },
    async login() {
      this.validateEmailOrPhone();
      this.validatePassword();

      if (this.emailOrPhoneError || this.passwordError) return;

      try {
        const response = await axios.post('http://localhost:8080/api/v1/users/login', {
          user_name: this.emailOrPhone,
          password: this.password,
        });

        if (response.data.status === 200 && response.data.data.authenticated) {
          const accessToken = response.data.data.access_token;
          const fullName = response.data.data.user_full_name;
          sessionStorage.setItem("accessToken", accessToken);
          sessionStorage.setItem("fullName", fullName);
          if (sessionStorage.getItem("fullName") == 'admin') {
            alert("login ok");
            setTimeout(() => {
              location.reload(); // Reload the current page
            }, 500);

            this.$router.push("/");
          }
          else {
            alert("Login failed! Only admin can access this page.");
            this.$router.push("/SignIn");
          }
        } else {
          alert("Login failed! Phone number, email, or password is incorrect.");
        }
      } catch (error) {
        console.error("Login error:", error);
        alert("An error occurred during login. Please try again.");
      }
    },
  },
};
</script>



<style scoped>
.container {
  margin-top: 50px;
}

.img-fluid {
  height: 100%;
  width: 100%;
  border-radius: 0.5rem;
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

@media (max-width: 1195px) {
  .img-fluid {
    display: none;
  }

  .row {
    justify-content: center;
  }

  #loginForm {
    margin: 0 auto;
  }
}

.card {
  background-color: rgb(250, 249, 249);
}

a {
  text-decoration: none;
}
</style>
