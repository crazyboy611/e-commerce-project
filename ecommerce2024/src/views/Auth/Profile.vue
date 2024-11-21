<template>
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="profile-card p-5 shadow-lg my-5">
                    <h2 class="text-center mb-4">User Profile</h2>
                    <div class="row">
                        <div class="col-md-12 text-center avatar-image">
                            <img :src="imageUrl" alt="Profile Avatar" class="avatar mb-3" />
                            <button class="position-absolute upload-btn" @click="triggerFileInput"
                                :disabled="!isEditing">
                                <i class="fa fa-camera"></i>
                            </button>
                            <!-- Hidden file input -->
                            <input type="file" ref="fileInput" class="d-none" @change="onImageUpload"
                                :disabled="!isEditing" />
                        </div>
                        <div class="col-md-6 my-4">
                            <label for="fullName" class="form-label"><strong>User Name:</strong></label>
                            <input type="text" class="form-control" id="fullName" :value="username" disabled />
                        </div>
                        <div class="col-md-6 my-4">
                            <label for="phone_number" class="form-label"><strong>Phone:</strong></label>
                            <input type="text" class="form-control" id="phone_number" v-model="phone_number"
                                :disabled="!isEditing" />
                        </div>
                        <div class="col-md-6 mb-4">
                            <label for="email" class="form-label"><strong>Email:</strong></label>
                            <input type="email" class="form-control" id="email" v-model="email"
                                :disabled="!isEditing" />
                        </div>
                        <div class="col-md-6 mb-4">
                            <label for="address" class="form-label"><strong>Address:</strong></label>
                            <input type="text" class="form-control" id="address" v-model="address"
                                :disabled="!isEditing" />
                        </div>
                    </div>
                    <div class="text-end my-4">
                        <button class="btn btn-secondary me-4" @click="toggleEdit">{{ isEditing ? 'Cancel' : 'Update'
                            }}</button>
                        <button class="btn btn-primary" @click="saveProfile" :disabled="!isEditing">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    name: 'Profile',
    data() {
        return {
            phone_number: '',
            email: '',
            address: '',
            profileImage: '',
            isEditing: false,
            username: '',
            id: '',
            role_id: '2',
            imageUrl: '',
            no_password: '',
        };
    },
    computed: {
        profileImageUrl() {
            return this.imageUrl || '';
        }
    },
    watch: {
        profileImage: {
            immediate: true,
            handler() {
                this.fetchProfileImage();
            }
        }
    },
    mounted() {
        this.fetchProfile();
    },
    methods: {
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
                    this.phone_number = profileData.phone_number;
                    this.email = profileData.email;
                    this.address = profileData.address;
                    this.profileImage = profileData.profile_image;
                    this.role_id = profileData.role_id;
                    this.no_password = profileData.no_password;
                    sessionStorage.setItem('no_password', this.no_password);
                    sessionStorage.setItem("id", this.id);
                } else {
                    console.log(response.data.message);
                }
            } catch (error) {
                console.log(error);
            }
        },
        toggleEdit() {
            this.isEditing = !this.isEditing;
        },
        triggerFileInput() {
            this.$refs.fileInput.click();
        },
        async onImageUpload(event) {
            const file = event.target.files[0];
            if (file) {
                try {
                    const formData = new FormData();
                    formData.append('file', file);
                    const response = await axios.post('http://localhost:8080/api/v1/users/upload_profile_image', formData, {
                        headers: {
                            'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                            'Content-Type': 'multipart/form-data'
                        }
                    });
                    if (response.data.status === 201) {
                        this.profileImage = response.data.data;
                        alert('Profile image updated successfully!');
                    } else {
                        alert('Failed to update profile image: ' + response.data.message);
                    }
                } catch (error) {
                    console.error('Error uploading profile image:', error);
                    alert('An error occurred while uploading the profile image.');
                }
            }
        },
        async fetchProfileImage() {
            const accessToken = sessionStorage.getItem('accessToken');
            const no_password = sessionStorage.getItem('no_password');
            if (!accessToken) {
                console.error('Access token not found.');
                return;
            }
            if (no_password === 'false') {
                this.imageUrl = this.profileImage;
            }
            else if (this.profileImage) {
                try {
                    const response = await axios.get(`http://localhost:8080/api/v1/users/profile_images/${this.profileImage}`, {
                        headers: {
                            'Authorization': `Bearer ${accessToken}`,
                            'Accept': '*/*'
                        },
                        responseType: 'blob' // Get the image as a Blob
                    });

                    // Create an object URL for the blob and assign it to imageUrl
                    this.imageUrl = URL.createObjectURL(response.data);
                } catch (error) {
                    console.error('Error fetching profile image:', error);
                    this.imageUrl = ''; // Clear image URL if an error occurs
                    if (error.response && error.response.status === 401) {
                        console.error('Unauthorized access - check if the token is valid or has expired.');
                    }
                }
            } else {
                this.imageUrl = ''; // Clear URL if no profile image
            }
        },
        async saveProfile() {
            const accessToken = sessionStorage.getItem('accessToken');
            if (this.isEditing) {
                const updatedProfile = {
                    phone_number: this.phone_number,
                    email: this.email,
                    address: this.address,
                    role_id: '2'
                };

                try {
                    const response = await axios.put(`http://localhost:8080/api/v1/users`, updatedProfile, {
                        headers: {
                            'Authorization': `Bearer ${accessToken}`,
                            'Content-Type': 'application/json'
                        }
                    });
                    if (response.data.status === 200) {
                        alert('Profile updated successfully!');
                        this.isEditing = false;
                        this.fetchProfile(); // Refresh profile data
                        this.isAuthenticated = false; // Update authentication state
                    } else {
                        alert('Failed to update profile: ' + response.data.message);
                    }
                } catch (error) {
                    console.error('Error updating profile:', error);
                    alert('An error occurred while updating the profile.');
                }
            }
        }
    }
};
</script>

<style scoped>
.profile-card {
    background-color: #fff;
    border-radius: 10px;
}

h2 {
    color: #007bff;
}

.avatar-image {
    position: relative;
}

.avatar {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    object-fit: cover;
    border: 3px solid #007bff;
    position: relative;
}

.upload-btn {
    font-size: 12px;
    padding: 4px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    bottom: 0;
    transform: translate(-50%, 0);
    border: none;
    cursor: pointer;
    outline-style: none;
    background-color: white;
    width: 20px;
    border-radius: 5px;
}

.form-label {
    font-weight: bold;
}

button {
    width: 120px;
}

input[disabled] {
    background-color: #e9ecef;
    opacity: 1;
}
</style>
