<template>
    <div class="container">
        <div class="header">
            <h1 class="text-start">Comments and Reviews of Users</h1>
            <div class="search-sort">
                <input type="text" v-model="searchQuery" placeholder="Search product..." class="form-control mb-3" />
                <select v-model="sortOption" @change="sortComments" class="form-select mb-3">
                    <option value="date-asc">Sort by Date Ascending</option>
                    <option value="date-desc">Sort by Date Descending</option>
                    <option value="rating">Sort by Rating</option>
                </select>
            </div>
        </div>

        <!-- Comments Section -->
        <div class="comments">
            <div class="card">
                <div class="table-responsive">
                    <table v-if="filteredComments.length">
                        <thead>
                            <tr>
                                <th>Product ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Date of Comments</th>
                                <th>Rating</th>
                                <th>Comment</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(comment, index) in paginatedComments" :key="comment.id">
                                <td>
                                    <a href="#" @click.prevent="viewProductDetails(comment.productId)">
                                        {{ comment.productId }}
                                    </a>
                                </td>
                                <td style="white-space: nowrap;">
                                    <a href="#" @click.prevent="viewUserDetails(comment.user)">
                                        {{ comment.user.fullName }}
                                    </a>
                                </td>
                                <td>{{ maskEmail(comment.user.email) }}</td>
                                <td>{{ comment.date }}</td>
                                <td>{{ comment.rating }}</td>
                                <td>
                                    <a href="#" @click.prevent="viewCommentDetails(comment)" class="text-break">
                                        {{ comment.text.slice(0, 30) }}...
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <p v-else class="text-center">Not found order or user</p>
                </div>
            </div>

            <!-- Pagination controls -->
            <div class="pagination">
                <button :disabled="currentPage === 1" @click="prevPage">
                    <i class="fa-solid fa-chevron-left"></i>
                </button>
                <span>{{ currentPage }}/{{ totalPages }}</span>
                <button :disabled="currentPage === totalPages" @click="nextPage">
                    <i class="fa-solid fa-chevron-right"></i>
                </button>
            </div>

            <!-- User Details Modal -->
            <div v-if="showUserDetailsModal" class="modal" @click.self="closeUserModal">
                <div class="modal-content">
                    <span class="close fs-3 fw-bold" @click="closeUserModal">&times;</span>
                    <h2>User Details</h2>
                    <p><strong>Full Name:</strong> {{ selectedUser.fullName }}</p>
                    <p><strong>Email:</strong> {{ maskEmail(selectedUser.email) }}</p>
                    <p><strong>Phone:</strong> {{ maskPhone(selectedUser.phone) }}</p>
                    <p><strong>Address:</strong> {{ selectedUser.address }}</p>
                </div>
            </div>

            <!-- Comment Details Modal -->
            <div v-if="showCommentDetailsModal" class="modal" @click.self="closeCommentModal">
                <div class="modal-content">
                    <span class="close fs-3 fw-bold" @click="closeCommentModal">&times;</span>
                    <h2>Comment Details</h2>
                    <p><strong>Product ID:</strong> {{ selectedComment.productId }}</p>
                    <p class="border rounded p-3 mt-3 text-break">
                        <strong>Comment:</strong> {{ selectedComment.text }}
                    </p>
                </div>
            </div>

            <!-- Product Details Modal -->
            <div v-if="showProductDetailsModal" class="modal" @click.self="closeProductModal">
                <div class="modal-content">
                    <span class="close fs-3 fw-bold" @click="closeProductModal">&times;</span>
                    <h2>Product Details</h2>
                    <img :src="selectedProduct.image" alt="Product Image" class="img-fluid mb-3" />
                    <p><strong>Product Name:</strong> {{ selectedProduct.name }}</p>
                    <p><strong>Price:</strong> ${{ selectedProduct.price }}</p>
                    <p><strong>Average Rating:</strong> {{ selectedProductAverageRating }}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            searchQuery: '',
            sortOption: 'date-asc', // default sort option
            comments: [
                {
                    id: 1,
                    productId: 'P001',
                    user: {
                        fullName: 'John Doe',
                        email: 'john.doe@example.com',
                        phone: '1234567890',
                        address: '123 Main St, Springfield',
                    },
                    date: '2024-10-17',
                    rating: 4,
                    text: 'This product is great, but it could be improved in some areas.',
                },
                {
                    id: 2,
                    productId: 'P002',
                    user: {
                        fullName: 'Jane Smith',
                        email: 'jane.smith@example.com',
                        phone: '0987654321',
                        address: '456 Oak St, Springfield',
                    },
                    date: '2024-10-16',
                    rating: 4,
                    text: 'Absolutely love this product! It exceeded my expectations!',
                },
                {
                    id: 3,
                    productId: 'P003',
                    user: {
                        fullName: 'Jane Smith',
                        email: 'jane.smith@example.com',
                        phone: '0987654321',
                        address: '456 Oak St, Springfield',
                    },
                    date: '2024-10-20',
                    rating: 4,
                    text: 'Absolutely love this product! It exceeded my expectations!',
                },
                {
                    id: 4,
                    productId: 'P001',
                    user: {
                        fullName: 'Jane Smith',
                        email: 'jane.smith@example.com',
                        phone: '0987654321',
                        address: '456 Oak St, Springfield',
                    },
                    date: '2024-07-20',
                    rating: 5,
                    text: 'Absolutely love this product! It exceeded my expectations!',
                },
                {
                    id: 5,
                    productId: 'P002',
                    user: {
                        fullName: 'Jane Smith',
                        email: 'jane.smith@example.com',
                        phone: '0987654321',
                        address: '456 Oak St, Springfield',
                    },
                    date: '2024-06-22',
                    rating: 4,
                    text: 'Absolutely love this product! It exceeded my expectations!',
                },
                {
                    id: 6,
                    productId: 'P003',
                    user: {
                        fullName: 'Jane Smith',
                        email: 'jane.smith@example.com',
                        phone: '0987654321',
                        address: '456 Oak St, Springfield',
                    },
                    date: '2024-02-03',
                    rating: 5,
                    text: 'Absolutely love this product! It exceeded my expectations!',
                },
                {
                    id: 7,
                    productId: 'P001',
                    user: {
                        fullName: 'Jane Smith',
                        email: 'jane.smith@example.com',
                        phone: '0987654321',
                        address: '456 Oak St, Springfield',
                    },
                    date: '2024-08-08',
                    rating: 3,
                    text: 'Absolutely love this product! It exceeded my expectations!',
                },
                // Add more comments as needed
            ],
            products: [
                {
                    id: 'P001',
                    name: 'Product 1',
                    price: 29.99,
                    image: 'path/to/image1.jpg',
                },
                {
                    id: 'P002',
                    name: 'Product 2',
                    price: 49.99,
                    image: 'path/to/image2.jpg',
                },
                {
                    id: 'P003',
                    name: 'Product 3',
                    price: 39.99,
                    image: 'path/to/image2.jpg',
                },
                // Add more products as needed
            ],
            currentPage: 1,
            itemsPerPage: 5,
            showUserDetailsModal: false,
            showCommentDetailsModal: false,
            showProductDetailsModal: false,
            selectedUser: {},
            selectedComment: {},
            selectedProduct: {},
        };
    },

    computed: {
        totalPages() {
            return Math.ceil(this.filteredComments.length / this.itemsPerPage);
        },
        paginatedComments() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            return this.filteredComments.slice(start, start + this.itemsPerPage);
        },
        filteredComments() {
            let sortedComments = [...this.comments];

            // Sort the comments based on the selected sort option
            if (this.sortOption === 'date-asc') {
                sortedComments.sort((a, b) => new Date(a.date) - new Date(b.date));
            } else if (this.sortOption === 'date-desc') {
                sortedComments.sort((a, b) => new Date(b.date) - new Date(a.date));
            } else if (this.sortOption === 'rating') {
                sortedComments.sort((a, b) => b.rating - a.rating);
            }

            // Apply search query filter
            if (this.searchQuery) {
                sortedComments = sortedComments.filter(comment =>
                    comment.productId.toLowerCase().includes(this.searchQuery.toLowerCase())
                );
            }

            // Return a new array to trigger reactivity in Vue
            return sortedComments;
        },

        selectedProductAverageRating() {
            const ratings = this.comments
                .filter(comment => comment.productId === this.selectedProduct.id)
                .map(comment => comment.rating);
            const totalRatings = ratings.reduce((sum, rating) => sum + rating, 0);
            return ratings.length ? (totalRatings / ratings.length).toFixed(2) : 0;
        },
    },

    methods: {
        viewUserDetails(user) {
            this.selectedUser = user;
            this.showUserDetailsModal = true;
        },

        viewCommentDetails(comment) {
            this.selectedComment = comment;
            this.showCommentDetailsModal = true;
        },

        viewProductDetails(productId) {
            this.selectedProduct = this.products.find(product => product.id === productId);
            this.showProductDetailsModal = true;
        },

        deleteComment(commentId) {
            this.comments = this.comments.filter(comment => comment.id !== commentId);
        },

        closeUserModal() {
            this.showUserDetailsModal = false;
        },

        closeCommentModal() {
            this.showCommentDetailsModal = false;
        },

        closeProductModal() {
            this.showProductDetailsModal = false;
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

        maskPhone(phone) {
            return `${phone.slice(0, 3)}****${phone.slice(-3)}`;
        },
        maskEmail(email) {
            const [user, domain] = email.split('@');
            return `${user.slice(0, 1)}****${user.slice(50)}@${domain}`;
        },

        sortComments() {
            // This method can be empty because sorting is handled in the filteredComments computed property
        },
    },
};
</script>

<style scoped>
.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
    background-color: #f8f9fa;
    border-radius: 10px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.header {
    text-align: center;
    margin-bottom: 20px;
}

.header h1 {
    font-size: 2.5rem;
    font-weight: bold;
    color: #343a40;
}

.card {
    background-color: white;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.table-responsive {
    max-width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
}

th,
td {
    padding: 12px 15px;
    text-align: left;
    border-bottom: 1px solid #dee2e6;
}

thead th {
    background-color: #343a40;
    color: white;
    font-weight: 600;
}

tbody tr {
    background-color: white;
    transition: background-color 0.3s ease;
}

a {
    cursor: pointer;
    color: #007bff;
}

a:hover {
    text-decoration: underline;
}

.text-break {
    word-break: break-word;
}

/* Modals */
.modal {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
}

.modal-content {
    background: white;
    padding: 30px;
    border-radius: 10px;
    width: 500px;
    position: relative;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

.close {
    position: absolute;
    top: 15px;
    right: 20px;
    font-size: 1.8rem;
    cursor: pointer;
    color: #333;
}

.close:hover {
    color: #dc3545;
}

.modal-content h2 {
    margin-bottom: 20px;
    font-size: 1.8rem;
    color: #343a40;
}

.modal-content p {
    font-size: 1.1rem;
    margin: 10px 0;
    color: #495057;
}

.pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
}

.pagination button {
    padding: 5px 10px;
    margin: 0 5px;
    background-color: #007bff;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
}

.pagination button:disabled {
    background-color: #cccccc;
    cursor: not-allowed;
}

.pagination span {
    font-size: 1.2rem;
}

button {
    border: none;
    background-color: transparent;
    cursor: pointer;
}

button:hover {
    background-color: rgba(0, 0, 0, 0.05);
    border-radius: 5px;
}

a {
    list-style-type: none;
    color: #343a40;
    text-decoration: none;
}

.search-sort {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.form-control {
    width: 70%;
}

.form-select {
    width: 25%;
}
</style>
