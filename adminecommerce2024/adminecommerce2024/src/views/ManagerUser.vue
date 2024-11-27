<template>
    <div class="container">
        <div class="header">
            <h1>Manage Users</h1>
        </div>
        <div class="search">
            <input type="text" v-model="searchQuery" placeholder="Search full name" class="form-control mb-3" />
        </div>
        <div class="card">
            <table v-if="filteredUsers.length">
                <thead>
                    <tr>
                        <th>Stt</th>
                        <th>Full Name</th>
                        <th>Address</th>
                        <th>Phone</th>
                        <th>Email</th>
                        <th>Status</th>
                        <th class="text-center">Block</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(user, index) in paginatedUsers" :key="user.id" :class="{ 'bg-danger': !user.active }">
                        <td>{{ (currentPage - 1) * itemsPerPage + index + 1 }}</td>
                        <td><a href="#" @click="showDetail(user)">{{ user.full_name }}</a></td>
                        <td class="fw-bold">{{ user.address }}</td>
                        <td>{{ maskPhone(user.phone_number) }}</td>
                        <td class="fw-bold">{{ maskEmail(user.email) }}</td>
                        <td v-if="user.active == true" class="text-success">Active</td>
                        <td v-else class="text-danger">Inactive</td>
                        <td class="text-center">
                            <input type="checkbox" :checked="!user.active" @change="blockUser(user, !user.active)">
                        </td>
                    </tr>
                </tbody>
            </table>
            <p v-else class="text-center">No matching users found.</p>
            <!-- Pagination controls -->
            <div class="pagination">
                <button :disabled="currentPage === 1" @click="prevPage"><i
                        class="fa-solid fa-chevron-left"></i></button>
                <span>{{ currentPage }}/{{ totalPages }}</span>
                <button :disabled="currentPage === totalPages" @click="nextPage"><i
                        class="fa-solid fa-chevron-right"></i></button>
            </div>

        </div>

        <!-- Modal for User Details -->
        <div v-if="showModal" class="modal" @click.self="closeModal">
            <div class="modal-content">
                <span class="close" @click="closeModal">&times;</span>
                <h2>User Details</h2>
                <img :src="imageUrl" alt="User Image" width="150" />
                <p><strong>Name:</strong> {{ selectedUser.full_name }}</p>
                <p><strong>Address:</strong> {{ selectedUser.address }}</p>
                <p><strong>Phone:</strong> {{ maskPhone(selectedUser.phone_number) }}</p>
                <p><strong>Email:</strong> {{ maskEmail(selectedUser.email) }}</p>
            </div>
        </div>

    </div>
</template>

<script>
import axios from 'axios';
export default {
    name: 'ManagerUser',
    data() {
        return {
            users: [],
            showModal: false,
            profileImage: '',
            imageUrl: '',
            provider: '',
            selectedUser: {},
            currentPage: 1,
            itemsPerPage: 5, // 5 items per page
            searchQuery: '',
        };
    },
    computed: {
        filteredUsers() {
            const query = this.searchQuery.toLowerCase();
            return this.users.filter((user) => {
                return user.full_name.toLowerCase().includes(query);
            });
        },
        totalPages() {
            return Math.ceil(this.filteredUsers.length / this.itemsPerPage);
        },
        paginatedUsers() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            const end = start + this.itemsPerPage;
            return this.filteredUsers.slice(start, end);
        },
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
        this.fetchUser();
    },
    methods: {
        async fetchUser() {
            try {
                const response = await axios.get('http://localhost:8080/api/v1/users?size=10&page=0', {
                    headers: {
                        'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                        'Accept': '*/*'
                    }
                });
                if (response.data.status === 200) {
                    this.users = response.data.data.user_list;
                } else {
                    console.log(response.data.message);
                }
            } catch (error) {
                console.log(error);
            }
        },
        maskPhone(phone) {
            if (!phone) return 'null';
            return `${phone.slice(0, 3)}****${phone.slice(-3)}`;
        },
        maskEmail(email) {
            if (!email) return 'null'; // xử lý trường hợp null hoặc undefined
            const [user, domain] = email.split('@');
            return `${user.slice(0, 1)}****${user.slice(1)}@${domain}`;
        },
        deleteUser(id) {
            this.users = this.users.filter((user) => user.id !== id);
            console.log('Delete User:', id);
        },
        showDetail(user) {
            this.selectedUser = user;
            this.showModal = true;
            this.profileImage = this.selectedUser.profile_image;
            this.provider = this.selectedUser.provider;
        },
        async fetchProfileImage() {
            const accessToken = sessionStorage.getItem('accessToken');
            if (!accessToken) {
                console.error('Access token not found.');
                return;
            }
            if (this.provider == "google") {
                this.imageUrl = this.profileImage;
            }
            else if (this.profileImage) {
                console.log(this.provider);
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
                    this.imageUrl = '';
                    if (error.response && error.response.status === 401) {
                        console.error('Unauthorized access - check if the token is valid or has expired.');
                    }
                }
            } else {
                this.imageUrl = '';
            }
        },
        closeModal() {
            this.showModal = false;
        },
        async blockUser(user,isBlocking) {
            try {
                const response = await axios.put(`http://localhost:8080/api/v1/users/${user.id}`, { userId: user.id }, {
                    headers: {
                        'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                    }
                });
                if (response.data && response.data.status == 200) {
                    user.active = !isBlocking;
                    alert("Blocking successfully");
                }
                else {
                    alert("BLocking failed");
                    user.active = isBlocking;
                }
            }
            catch (error) {
                alert("An error code");
                user.active = isBlocking;
            }

        },
        prevPage() {
            if (this.currentPage > 1) {
                this.currentPage--;
            }
        },
        nextPage() {
            if (this.currentPage < this.totalPages) {
                this.currentPage++;
            }
        },
    },
};
</script>
<style scoped>
a {
    text-decoration: none;
    color: #333;
    transition: color 0.3s ease;
}

a:hover {
    color: #007bff;
}

.container {
    margin: 50px auto;
    padding: 20px;
    background-color: #f9f9f9;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

h1 {
    font-size: 2rem;
    color: #333;
}

.card {
    background-color: #fff;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}

table {
    width: 100%;
    border-collapse: collapse;
}

th,
td {
    padding: 15px;
    text-align: left;
    white-space: nowrap;
}

th {
    background-color: #343a40;
    color: #fff;
}

tr:nth-child(even) {
    background-color: #f2f2f2;
}

.delete-btn {
    background-color: transparent;
    border: none;
    cursor: pointer;
    font-size: 1.2rem;
}

.delete-btn i {
    color: #dc3545;
}

.delete-btn:hover i {
    color: #c82333;
}

/* Modal Styles */
.modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    opacity: 1;
    transition: opacity 0.3s ease;
}

.modal-content {
    background-color: #fff;
    padding: 20px;
    border-radius: 10px;
    width: 400px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
    position: relative;
    transform: translateY(0);
    transition: transform 0.3s ease;
}

.modal-content h2 {
    margin-bottom: 20px;
}

.modal-content img {
    border-radius: 50%;
    margin-bottom: 20px;
}

.modal-content p {
    margin-bottom: 10px;
}

.close {
    position: absolute;
    top: 10px;
    right: 20px;
    font-size: 1.5rem;
    cursor: pointer;
    color: #333;
    transition: color 0.3s ease;
}

.close:hover {
    color: #007bff;
}

.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
}

.pagination button {
    margin: 0 10px;
    padding: 5px 10px;
    border: none;
    background-color: #007bff;
    color: white;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s ease;
}

.pagination button:hover {
    background-color: #0056b3;
}

.pagination button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
}

.pagination span {
    margin: 0 10px;
    font-weight: bold;
}

@media (max-width: 768px) {
    table {
        display: block;
        width: 100%;
        overflow-x: auto;
    }

    th,
    td {
        white-space: nowrap;
    }

    .modal-content {
        width: 90%;
    }
}

.container {
    padding: 20px;
    background-color: #f9f9f9;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.header {
    margin-bottom: 20px;
}

.card {
    margin-top: 10px;
}

.table {
    width: 100%;
    border-collapse: collapse;
}

.table th,
.table td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #ddd;
}

.table th {
    background-color: #f2f2f2;
}

.text-center {
    text-align: center;
}

.pagination {
    display: flex;
    justify-content: center;
    margin-top: 10px;
}

.pagination button {
    margin: 0 5px;
    padding: 5px 10px;
}

.modal-report {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 1000;
}

.modal-report-content {
    background-color: white;
    padding: 20px;
    border-radius: 8px;
    width: 300px;
    position: relative;
}

.modal-report .close {
    position: absolute;
    top: 10px;
    right: 15px;
    cursor: pointer;
    font-size: 18px;
}
</style>
