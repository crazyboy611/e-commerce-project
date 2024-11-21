<template>
    <div class="comment-manager">
        <h2>Comments for News</h2>
        <div class="search-sort">
            <input type="text" v-model="searchQuery" placeholder="Search by news name or user ID..." class="search-input" />
            <select v-model="sortOrder" class="sort-select">
                <option value="asc">Asc Date</option>
                <option value="desc">Desc Date</option>
            </select>
        </div>
        <table class="table" v-if="filteredComments.length">
            <thead>
                <tr>
                    <th>News ID</th>
                    <th>News Name</th>
                    <th>User ID</th>
                    <th>Comment</th>
                    <th>Detail</th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="comment in paginatedComments" :key="comment.id">
                    <td>{{ comment.newsId }}</td>
                    <td>{{ comment.newsName }}</td>
                    <td>{{ comment.userId }}</td>
                    <td>{{ comment.comment }}</td>
                    <td>
                        <i class="fas fa-info-circle" @click="showDetails(comment)"></i>
                    </td>
                </tr>
            </tbody>
        </table>
        <p v-else class="text-center">No comments found.</p>
        
        <!-- Pagination Controls -->
        <div class="pagination">
            <button @click="currentPage--" :disabled="currentPage === 1"><i class="fa-solid fa-chevron-left"></i></button>
            <span>Page {{ currentPage }} of {{ totalPages }}</span>
            <button @click="currentPage++" :disabled="currentPage === totalPages"><i class="fa-solid fa-chevron-right"></i></button>
        </div>
        
        <!-- Detail Modal -->
        <div v-if="isDetailModalOpen" class="modal">
            <div class="modal-content">
                <span class="close" @click="closeDetailModal">&times;</span>
                <h3>Comment Details</h3>
                <p><strong>News Name:</strong> {{ selectedComment.newsName }}</p>
                <p><strong>Full Name:</strong> {{ selectedComment.fullName }}</p>
                <p><strong>Date:</strong> {{ formatDate(selectedComment.date) }}</p>
                <p><strong>Comment:</strong> {{ selectedComment.comment }}</p>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            searchQuery: '',
            sortOrder: 'asc',
            comments: [
                {
                    id: 1,
                    newsId: 1,
                    newsName: 'Sample News Title',
                    userId: 'user123',
                    fullName: 'John Doe',
                    comment: 'Great article! Really enjoyed it.',
                    date: '2024-10-20T12:34:56Z',
                },
                {
                    id: 2,
                    newsId: 2,
                    newsName: 'Sample News Title',
                    userId: 'user456',
                    fullName: 'Jane Smith',
                    comment: 'Very informative, thanks for sharing.',
                    date: '2024-10-21T15:20:30Z',
                },
                {
                    id: 3,
                    newsId: 3,
                    newsName: 'Another News Title',
                    userId: 'user789',
                    fullName: 'Alice Johnson',
                    comment: 'I found this very useful!',
                    date: '2024-10-22T09:15:45Z',
                },
                {
                    id: 4,
                    newsId: 4,
                    newsName: 'Yet Another News Title',
                    userId: 'user101',
                    fullName: 'Bob Brown',
                    comment: 'This is great info!',
                    date: '2024-10-22T10:00:00Z',
                },
                {
                    id: 5,
                    newsId: 5,
                    newsName: 'Breaking News Title',
                    userId: 'user102',
                    fullName: 'Charlie Green',
                    comment: 'Thanks for the update!',
                    date: '2024-10-22T10:15:00Z',
                },
                {
                    id: 6,
                    newsId: 6,
                    newsName: 'New Insights Title',
                    userId: 'user103',
                    fullName: 'Diana Blue',
                    comment: 'Interesting read!',
                    date: '2024-10-23T11:00:00Z',
                },
            ],
            isDetailModalOpen: false,
            selectedComment: {},
            currentPage: 1,
            commentsPerPage: 5,
        };
    },
    computed: {
        filteredComments() {
            return this.comments
                .filter(comment => {
                    const searchText = this.searchQuery.toLowerCase();
                    return (
                        comment.newsName.toLowerCase().includes(searchText) ||
                        comment.userId.toLowerCase().includes(searchText)
                    );
                })
                .sort((a, b) => {
                    const dateA = new Date(a.date);
                    const dateB = new Date(b.date);
                    return this.sortOrder === 'asc' ? dateA - dateB : dateB - dateA;
                });
        },
        totalPages() {
            return Math.ceil(this.filteredComments.length / this.commentsPerPage);
        },
        paginatedComments() {
            const start = (this.currentPage - 1) * this.commentsPerPage;
            return this.filteredComments.slice(start, start + this.commentsPerPage);
        },
    },
    methods: {
        formatDate(dateString) {
            const options = { year: 'numeric', month: 'long', day: 'numeric' };
            return new Date(dateString).toLocaleDateString(undefined, options);
        },
        showDetails(comment) {
            this.selectedComment = comment;
            this.isDetailModalOpen = true;
        },
        closeDetailModal() {
            this.isDetailModalOpen = false;
        },
    },
};
</script>


<style scoped>
.comment-manager {
    padding: 20px;
    background-color: #f9f9f9;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h2 {
    margin-bottom: 20px;
    color: #333;
}

.search-sort {
    display: flex;
    justify-content: space-between;
    margin-bottom: 15px;
}

.search-input {
    padding: 8px;
    border: 1px solid #ccc;
    border-radius: 4px;
    width: 60%;
}

.sort-select {
    border-radius: 4px;
    background-color: #fff;
    color: #343a40;
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
    background-color: #343a40;
    color: white;
}

.table tr:hover {
    background-color: #f1f1f1;
}

.btn {
    border: none;
    padding: 6px 12px;
    border-radius: 4px;
    cursor: pointer;
}

.btn-info {
    border: none;
    outline-style: none;
}

.modal {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.7);
    z-index: 1000;
}

.modal-content {
    background-color: white;
    padding: 20px;
    border-radius: 5px;
    width: 400px;
    position: relative;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
}

.close {
    cursor: pointer;
    position: absolute;
    top: 10px;
    right: 15px;
    font-size: 20px;
    color: #999;
}

.close:hover {
    color: #333;
}
.pagination {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 20px;
  gap: 10px;
}

.pagination button {
  padding: 0.5rem 1rem;
  background-color: #4a90e2;
  border: none;
  color: #fff;
  font-size: 1rem;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.pagination button:disabled {
  background-color: #ddd;
  cursor: not-allowed;
}

.pagination button:hover:enabled {
  background-color: #357ab9;
}
</style>