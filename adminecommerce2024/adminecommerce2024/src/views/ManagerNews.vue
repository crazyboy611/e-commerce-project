<template>
    <div class=" d-flex justify-content-between flex-wrap">
        <div class="">
            <div class="d-flex justify-content-between align-items-center">
                <h2>News Manager</h2>
                <!-- Add News Button -->
                <button class="btn btn-primary" @click="openModal()">
                    <i class="fas fa-plus"></i>
                </button>
            </div>
            <div class="d-flex align-items-center flex-wrap my-3">
                <!-- Category Filter -->
                <select v-model="selectedCategory" @change="filterByCategory" class="me-2 select">
                    <option value="">All Categories</option>
                    <option v-for="category in categories" :key="category" :value="category">{{ category }}</option>
                </select>

                <!-- Search Input -->
                <div class="search-container">
                    <input type="text" v-model="searchQuery" placeholder="Search news title..."
                        @input="filterBySearch" />
                </div>
            </div>

            <!-- News List -->
            <table class="table" v-if="filteredNews.length">
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="news in paginatedNews" :key="news.id" :class="{ 'table-warning': news.status === 'Main' }">
                        <td>{{ news.title }}</td>
                        <td>{{ news.category }}</td>
                        <td>{{ news.status }}</td>
                        <td>
                            <button class="btn btn-secondary me-1" @click="viewNewsDetails(news)">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-warning me-1" @click="openModal(news)">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-danger" @click="deleteNews(news.id)">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p v-else class="text-center">Not found title news</p>

            <!-- Pagination -->
            <div class="pagination">
                <button :disabled="currentPage === 1" @click="changePage(currentPage - 1)"><i
                        class="fa-solid fa-angle-left"></i></button>
                <span>{{ currentPage }}/{{ totalPages }}</span>
                <button :disabled="currentPage === totalPages" @click="changePage(currentPage + 1)"><i
                        class="fa-solid fa-chevron-right"></i></button>
            </div>
        </div>

        <!-- News Details / Edit Section -->
        <div class="demo-news" v-if="isModalOpen">
            <div class="card">
                <div class="card-body">
                    <h3>{{ modalMode === 'view' ? 'News Details' : modalMode === 'add' ? 'Add News' : 'Edit News' }}
                    </h3>
                    <!-- Display Mode -->
                    <div v-if="modalMode === 'view'">
                        <img v-if="currentNews.image" :src="currentNews.image" alt="News Image"
                            class="card-img-top my-3" />
                        <p><strong>Title:</strong> {{ currentNews.title }}</p>
                        <p><strong>Category:</strong> {{ currentNews.category }}</p>
                        <p><strong>Status:</strong> {{ currentNews.status }}</p>
                        <p><strong>Content:</strong> {{ currentNews.content }}</p>
                    </div>

                    <!-- Edit/Add Mode -->
                    <div v-else>
                        <input type="file" accept="image/*" />
                        <input v-model="currentNews.title" placeholder="Title" />
                        <select v-model="currentNews.category">
                            <option v-for="category in categories" :key="category" :value="category">{{ category }}
                            </option>
                        </select>
                        <select v-model="currentNews.status">
                            <option value="Main">Main</option>
                            <option value="Secondary">Secondary</option>
                        </select>
                        <textarea v-model="currentNews.content" placeholder="Content"></textarea>
                    </div>
                    <div class="text-end">
                        <button class="btn btn-primary" @click="saveNews">Save</button>
                        <button class="btn btn-secondary" @click="closeModal">Cancel</button>
                    </div>

                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: 'NewsManager',
    data() {
        return {
            newsList: [
                { id: 1, title: 'Breaking News: New Policies Introduced', category: 'Politics', status: 'Main', content: 'Details about new policies...', image: 'https://via.placeholder.com/150' },
                { id: 2, title: 'Local Sports Team Wins Championship', category: 'Sports', status: 'Main', content: 'The local team has won the championship after a thrilling game...', image: 'https://via.placeholder.com/150' },
                { id: 3, title: 'Tech Innovations in 2024', category: 'Technology', status: 'Secondary', content: 'An overview of the most exciting tech innovations...', image: 'https://via.placeholder.com/150' },
                { id: 4, title: 'Tech Innovations in 2024', category: 'Technology', status: 'Secondary', content: 'An overview of the most exciting tech innovations...', image: 'https://via.placeholder.com/150' },
                { id: 5, title: 'Tech Innovations in 2024', category: 'Technology', status: 'Secondary', content: 'An overview of the most exciting tech innovations...', image: 'https://via.placeholder.com/150' },
                { id: 6, title: 'Tech Innovations in 2024', category: 'Technology', status: 'Secondary', content: 'An overview of the most exciting tech innovations...', image: 'https://via.placeholder.com/150' },
            ],
            categories: ['Politics', 'Sports', 'Entertainment', 'Technology'],
            selectedCategory: '',
            searchQuery: '',
            isModalOpen: false,
            modalMode: 'add',
            currentNews: {
                id: null,
                title: '',
                category: '',
                status: 'Main',
                content: '',
                image: '',
            },
            currentPage: 1,
            itemsPerPage: 5,
        };
    },
    computed: {
        filteredNews() {
            return this.newsList.filter((news) => {
                const matchesCategory = this.selectedCategory ? news.category === this.selectedCategory : true;
                const matchesSearch = news.title.toLowerCase().includes(this.searchQuery.toLowerCase());
                return matchesCategory && matchesSearch;
            });
        },
        totalPages() {
            return Math.ceil(this.filteredNews.length / this.itemsPerPage);
        },
        paginatedNews() {
            const start = (this.currentPage - 1) * this.itemsPerPage;
            return this.filteredNews.slice(start, start + this.itemsPerPage);
        },
    },
    methods: {
        openModal(news = null) {
            this.isModalOpen = true;
            if (news) {
                this.modalMode = 'edit';
                Object.assign(this.currentNews, { ...news });
            } else {
                this.modalMode = 'add';
                this.resetCurrentNews();
            }
        },
        viewNewsDetails(news) {
            this.modalMode = 'view';
            this.isModalOpen = true;
            Object.assign(this.currentNews, { ...news });
        },
        saveNews() {
            if (this.modalMode === 'add') {
                this.newsList.push({ ...this.currentNews, id: Date.now() });
            } else {
                const index = this.newsList.findIndex((item) => item.id === this.currentNews.id);
                if (index !== -1) {
                    this.newsList[index] = { ...this.currentNews };
                }
            }
            this.closeModal();
        },
        deleteNews(id) {
            const index = this.newsList.findIndex((news) => news.id === id);
            if (index !== -1) {
                this.newsList.splice(index, 1);
            }
        },
        closeModal() {
            this.isModalOpen = false;
            this.resetCurrentNews();
        },
        resetCurrentNews() {
            this.currentNews.id = null;
            this.currentNews.title = '';
            this.currentNews.category = '';
            this.currentNews.status = 'Main';
            this.currentNews.content = '';
            this.currentNews.image = '';
        },
        changePage(page) {
            if (page >= 1 && page <= this.totalPages) {
                this.currentPage = page;
            }
        },
    },
};
</script>


<style scoped>
.news-manager {
    width: 90%;
    max-width: 800px;
    margin: auto;
    padding: 20px;
    font-family: Arial, sans-serif;
}

h2 {
    margin-bottom: 20px;
}

.search-container {
    margin-bottom: 10px;
    width: 70%;
}

input[type="text"] {
    width: 100%;
    padding: 8px;
    border-radius: 4px;
    border: 1px solid #ddd;
}

select {
    margin: 5px 0;
    padding: 4px;
    border-radius: 4px;
    border: 1px solid #ddd;
}

.btn {
    display: inline-flex;
    align-items: center;
    margin: 5px 0;
    padding: 8px 12px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s;
}

.btn-primary {
    background-color: #007BFF;
    color: white;
}

.btn-primary:hover {
    background-color: #0056b3;
}

.btn-secondary {
    background-color: #6c757d;
    color: white;
}

.btn-secondary:hover {
    background-color: #5a6268;
}

.btn-warning {
    background-color: #ffc107;
    color: black;
}

.btn-warning:hover {
    background-color: #e0a800;
}

.btn-danger {
    background-color: #dc3545;
    color: white;
}

.btn-danger:hover {
    background-color: #c82333;
}

.pagination {
    margin-top: 20px;
    display: flex;
    justify-content: center;
}

.pagination button {
    padding: 8px 12px;
    margin: 0 5px;
    border-radius: 4px;
    border: 1px solid #ddd;
    background-color: white;
    cursor: pointer;
}


/* Styles for the news table */
table {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
}

thead {
    background-color: #f8f9fa;
}

th,
td {
    padding: 12px;
    text-align: left;
    border-bottom: 1px solid #dee2e6;
}

th {
    font-weight: bold;
    color: #495057;
}

/* Styles for buttons */
.btn {
    padding: 8px 12px;
    border-radius: 4px;
    border: none;
    color: white;
    cursor: pointer;
}

.btn-secondary {
    background-color: #6c757d;
}

.btn-warning {
    background-color: #ffc107;
}

.btn-danger {
    background-color: #dc3545;
}

.btn:hover {
    opacity: 0.9;
}

/* Pagination styles */
.pagination {
    display: flex;
    justify-content: center;
    margin: 20px 0;
}

.pagination button {
    padding: 8px 12px;
    margin: 0 5px;
    border-radius: 4px;
    border: 1px solid #ddd;
    background-color: #fff;
    color: #495057;
    cursor: pointer;
}

.pagination button:disabled {
    background-color: #f8f9fa;
    color: #adb5bd;
    cursor: not-allowed;
}

.pagination span {
    margin: 0 10px;
    align-self: center;
}

/* Wrapper for Detail Modal */
.demo-news {
    background-color: #fff;
    border-radius: 10px;
    box-shadow: 0px 10px 25px rgba(0, 0, 0, 0.2);
    max-width: 500px;
    width: 90%;
    padding: 20px;
}

/* Card Styling */
.demo-news .card {
    border: none;
    border-radius: 10px;
}

.demo-news .card-img-top {
    border-radius: 10px;
    width: 100%;
    max-height: 200px;
    object-fit: cover;
}

/* Card Body Styling */
.demo-news .card-body {
    padding: 20px;
}

.demo-news .card-body h3 {
    font-size: 1.6em;
    color: #333;
    margin-bottom: 1em;
    font-weight: bold;
    text-align: center;
}

/* Styling for Input, Select, and Textarea in Detail Modal */
.demo-news input,
.demo-news select,
.demo-news textarea {
    width: 100%;
    padding: 12px 15px;
    margin-bottom: 15px;
    border: 1px solid #ced4da;
    border-radius: 8px;
    font-size: 1em;
    color: #495057;
    background-color: #f8f9fa;
    transition: border-color 0.3s ease, box-shadow 0.3s ease;
}

/* Focus Effect for Inputs */
.demo-news input[type="text"]:focus,
.demo-news select:focus,
.demo-news textarea:focus {
    border-color: #007bff;
    box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
    outline: none;
}

/* Styling for Textarea */
.demo-news textarea {
    resize: vertical;
    min-height: 120px;
}

/* Placeholder Text Color */
.demo-news input[type="text"]::placeholder,
.demo-news textarea::placeholder {
    color: #6c757d;
    opacity: 0.8;
}


/* Buttons Styling */
.demo-news .btn {
    padding: 10px 15px;
    font-size: 1em;
    border-radius: 5px;
    cursor: pointer;
    margin-right: 10px;
}

.demo-news .btn-primary {
    background-color: #007bff;
    color: white;
    border: none;
    transition: background-color 0.3s ease;
}

.demo-news .btn-primary:hover {
    background-color: #0056b3;
}

.demo-news .btn-secondary {
    background-color: #6c757d;
    color: white;
    border: none;
    transition: background-color 0.3s ease;
}

.demo-news .btn-secondary:hover {
    background-color: #5a6268;
}

/* Modal Animation */
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translate(-50%, -55%);
    }

    to {
        opacity: 1;
        transform: translate(-50%, -50%);
    }
}
</style>
