<template>
    <div class="container my-5 d-flex flex-wrap justify-content-between">
        <div class="my-5 ms-5">
            <h3 class="fw-bold">Cyber News of Cyber company</h3>
            <div class="mt-5">
                <p><i class="fa-solid fa-location-dot"></i><span class="fw-bold ms-2">Địa chỉ: </span> 55 Giải phóng,
                    Hai Bà Trưng , Hà Nội</p>
                <p><i class="fa-regular fa-envelope"></i><span class="fw-bold ms-2">Email:
                    </span>support@cyberTeam7cc.com</p>
                <p><i class="fa-solid fa-phone"></i><span class="fw-bold ms-2">Phone: </span>+(84) 865172699</p>
            </div>
            <p class="fw-bold mt-5">CONTACT WITH US</p>
            <form @submit.prevent="submitForm">
                <div class="form-group">
                    <input type="text" id="name" v-model="name" placeholder="Full name" required>
                </div>
                <div class="form-group">
                    <input type="text" id="email" v-model="email" placeholder="Number phone or Email" required>
                </div>
                <div class="form-group">
                    <textarea id="message" v-model="message" placeholder="Content" rows="6" required></textarea>
                </div>
                <div class="form-group text-end">
                    <button type="submit" class="btn btn-dark">Submit</button>
                </div>
            </form>
        </div>
        <div class="">
            <iframe
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.7334696247704!2d105.84074577584084!3d21.003318488650773!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ac773026b415%3A0x499b8b613889f78a!2zVHLGsOG7nW5nIMSQ4bqhaSBI4buNYyBYw6J5IEThu7FuZyBIw6AgTuG7mWkgLSBIVUNF!5e0!3m2!1svi!2s!4v1731851918527!5m2!1svi!2s"
                width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy"
                referrerpolicy="no-referrer-when-downgrade"></iframe>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'contact',
    data() {
        return {
            name: '',
            email: '',
            message: ''
        };
    },
    methods: {
        // Method to check if the input is a valid email or a 10-digit phone number
        checkValidate() {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/; // Email validation regex
            const phoneRegex = /^\d{10}$/; // 10-digit phone number regex

            if (emailRegex.test(this.email)) {
                return true; // Valid email
            } else if (phoneRegex.test(this.email)) {
                return true; // Valid 10-digit phone number
            } else {
                alert("Please enter a valid email or 10-digit phone number");
                return false;
            }
        },

        async submitForm() {
            if (this.checkValidate()) {
                const ideaUser = {
                    fullName : this.name,
                    email : this.email,
                    content : this.message,
                }
                try {
                    const response = await axios.post(`http://localhost:8080/api/v1/contact_us`, ideaUser);
                    if(response.data && response.data.status == 200){
                        alert("Your message has been sent successfully!");
                    }
                    else{
                        alert("Failed to send your message!");
                    }
                }
                catch(errors){
                    alert("Failed to send your message!");
                }
                this.name = '';
                this.email = '';
                this.message = '';
                this.$router.push(`/`);
            }
        }
    }
}
</script>

<style scoped>
form input {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid #ccc;
    border-radius: 10px;
}

form textarea {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid #ccc;
    border-radius: 10px;
    resize: vertical;
}

form button {
    width: 30%;
}
</style>
