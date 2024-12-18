<template>
  <div class="container">
    <div class="row justify-content-around mx-2">
      <div class="col-md-4 d-flex align-items-center">
        <img src="@/ImageIcon/Logo2.png" class="img-fluid" alt="Login Image" />
      </div>
      <div class="col-md-5 card mb-5">
        <!-- Login Form -->
        <div id="loginForm" class="form-container active p-3">
          <h3 class="text-center mt-5">Login</h3>
          <form @submit.prevent="login">
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
              <div class="d-flex justify-content-between mt-2">
                <div>
                  <small class="text-danger">{{ passwordError }}</small>
                </div>
                <div>
                  <router-link v-if="emailOrPhone" to="/ForgotPassword">
                    Forgot Password?
                  </router-link>
                </div>
              </div>
            </div>
            <!-- <div class="mb-3 form-check">
              <input type="checkbox" class="form-check-input" id="rememberMe" v-model="rememberMe" />
              <label class="form-check-label" for="rememberMe">Remember me</label>
            </div> -->
            <button v-if="disableButton==false" type="submit" class="btn btn-primary w-100">Login</button>
            <button v-else type="submit" class="btn bg-danger w-100" disabled>Block Login</button>
          </form>
          <p class="text-center mt-3">
            Don't have an account? <router-link to="/Register">Sign up here</router-link>
          </p>
          <div class="hr-with-text">
            <hr />
            <span>Or login with</span>
            <hr />
          </div>
          <div class="social-login-buttons d-flex">
            <button class="btn btn-outline-primary w-100 m-2" @click="loginWithFacebook">
              <i class="fa-brands fa-facebook me-2"></i> Facebook
            </button>
            <button class="btn btn-outline-danger w-100 m-2" @click="loginWithGoogle">
              <i class="fa-brands fa-google me-2"></i> Google
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
export default {
  name: "Login",
  data() {
    return {
      emailOrPhone: "",
      password: "",
      showPassword: false,
      emailOrPhoneError: "",
      passwordError: "",
      loginType: "",
      password: '',
      loginAttempts: 0, // Track login attempts
      disableButton: false, // Toggle reCAPTCHA
      rememberMe: false,
    };
  },
  methods: {
    togglePasswordVisibility() {
      this.showPassword = !this.showPassword;
    },
    validateEmailOrPhone() {
      const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
      const phonePattern = /^[0-9]{10}$/; // Assuming a 10-digit phone number
      if (!emailPattern.test(this.emailOrPhone) && !phonePattern.test(this.emailOrPhone)) {
        this.emailOrPhoneError = "Please enter a valid email or phone number.";
      } else {
        this.emailOrPhoneError = ""; // Reset error message
        sessionStorage.setItem("emailOrPhone", this.emailOrPhone);
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
        })
        if (response.data.status === 200 && response.data.data.authenticated) {
          const accessToken = response.data.data.access_token;
          const fullName = response.data.data.user_full_name;
          sessionStorage.setItem("accessToken", accessToken);
          sessionStorage.setItem("fullName", fullName);
          alert("login ok");
          const redirect = this.$route.query.redirect || '/';
          this.$router.push(redirect);
          this.loginAttempts = 0;
        }
        else {
          this.loginAttempts++;
          alert("Login failed! Phone number, email, or password is incorrect.");
        }
        if (this.loginAttempts > 3) {
          alert('')
          this.disableButton = true;
        }
      }
      catch (error) {
        this.loginAttempts++;
        alert("Login failed! Phone number, email, or password is incorrect.");
        if (this.loginAttempts > 3) {
          this.disableButton = true;
        }
      }
    },
    async loginWithGoogle() {
      this.loginType = "google";
      try {
        const response = await axios.post(`http://localhost:8080/api/v1/users/oauth2/login?login_type=${this.loginType}`);
        if (response.data.status === 200) {
          window.location.href = response.data.data;
        }
        else {
          alert("Failed to login with Google. Please try again.");
        }
      }
      catch (error) {
        console.error(error.response.data.error);
      }
    },
    async loginWithFacebook() {
      this.loginType = "facebook";
      try {
        const response = await axios.post(`http://localhost:8080/api/v1/users/oauth2/login?login_type=${this.loginType}`);
        if (response.data.status === 200) {
          window.location.href = response.data.data;
        }
        else {
          alert("Failed to login with Facebook. Please try again.");
        }
      }
      catch (error) {
        console.error(error.response.data.error);
      }
    }
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
