<template>
    <div class="container">
        <div class="header">
            <h1 class="text-start">Comments and Reviews of Users</h1>
            <!-- <div class="search-sort">
                <input type="text" v-model="searchQuery" placeholder="Search product..." class="form-control mb-3" />
                <select v-model="sortOption" @change="sortComments" class="form-select mb-3">
                    <option value="date-asc">Sort by Date Ascending</option>
                    <option value="date-desc">Sort by Date Descending</option>
                    <option value="rating">Sort by Rating</option>
                </select>
            </div> -->
        </div>

        <div class="comments">
            <div class="card">
                <div class="table-responsive">
                    <table v-if="filteredComments.length">
                        <thead>
                            <tr>
                                <th>Product ID</th>
                                <th>Full Name</th>
                                <th>Date of Comments</th>
                                <th>Rating</th>
                                <th>Comment</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(comment, index) in comments" :key="comment.id">
                                <td>
                                    <a href="#" @click.prevent="viewProductDetails(comment.product_id)">
                                        {{ comment.product_id }}
                                    </a>
                                </td>
                                <td style="white-space: nowrap;">
                                    {{ comment.user_full_name }}
                                </td>
                                <td>{{ comment.created_at.split('T')[0] }}</td>
                                <td>{{ comment.rate }}</td>
                                <td>
                                    <a href="#" @click.prevent="viewCommentDetails(comment)" class="text-break">
                                        {{ comment.comment.slice(0, 30) }}...
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <p v-else class="text-center">Not found order or user</p>
                </div>
            </div>

            <div class="pagination">
                <button :disabled="currentPage === 0" @click="changePage(currentPage - 1)">
                    <i class="fa-solid fa-chevron-left"></i>
                </button>
                <span>Page {{ currentPage + 1 }} of {{ totalPages }}</span>
                <button :disabled="currentPage === totalPages - 1" @click="changePage(currentPage + 1)">
                    <i class="fa-solid fa-chevron-right"></i>
                </button>
            </div>

            <div v-if="showCommentDetailsModal" class="modal" @click.self="closeCommentModal">
                <div class="modal-content">
                    <span class="close fs-3 fw-bold" @click="closeCommentModal">&times;</span>
                    <h2>Comment Details</h2>
                    <p><strong>Product ID:</strong> {{ selectedComment.product_id }}</p>
                    <p class="border rounded p-3 mt-3 text-break">
                        <strong>Comment:</strong> {{ selectedComment.comment }}
                    </p>
                </div>
            </div>

            <div v-if="showProductDetailsModal" class="modal" @click.self="closeProductModal">
                <div class="modal-content">
                    <span class="close fs-3 fw-bold" @click="closeProductModal">&times;</span>
                    <h2>Product Details</h2>
                    <img :src="`http://localhost:8080/api/v1/products/images/${selectedProduct.image}`"
                        alt="Product Image" class="img-fluid mb-3" />
                    <p><strong>Product Name:</strong> {{ selectedProduct.name }}</p>
                    <p><strong>Price:</strong> ${{ selectedProduct.price }}</p>
                    <p><strong>Average Rating:</strong> {{ ratingAVG }}</p>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
    data() {
        return {
            searchQuery: '',
            sortOption: 'date-asc',
            comments: [],
            products: [],
            currentPage: 0,
            totalPages: 0,
            pageSize: 5,
            showUserDetailsModal: false,
            showCommentDetailsModal: false,
            showProductDetailsModal: false,
            selectedComment: {},
            selectedProduct: {},
            ratingAVG: 0,
        };
    },

    computed: {
        filteredComments() {
              let sortedComments = [...this.comments];

            

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
    mounted() {
        this.fetchComments();
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

        async viewProductDetails(productId) {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/products/details/${productId}`);
                this.selectedProduct = response.data.data;
                this.showProductDetailsModal = true;
                const reponsen2 = await axios.get(`http://localhost:8080/api/v1/ratings/average_by_product/${productId}`);
                this.ratingAVG = reponsen2.data.data;
            }
            catch (error) {
                console.error(error);
                alert("No found product");
            }
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
        async fetchComments() {
            try {
                const response = await axios.get(`http://localhost:8080/api/v1/ratings?size=${this.pageSize}&page=${this.currentPage}`, {
                    headers: {
                        'Authorization': `Bearer ${sessionStorage.getItem('accessToken')}`,
                    }
                });
                this.comments = response.data.data.content;
                this.totalPages = response.data.data.totalPages;
                this.currentPage = response.data.data.pageable.pageNumber;
            }
            catch (error) {
                console.error(error);
            }
        },
        changePage(newPage) {
            if (newPage >= 0 && newPage < this.totalPages) {
                this.currentPage = newPage;
                this.fetchComments();
            }
        },
    }
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
    font-weight: 500;
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
