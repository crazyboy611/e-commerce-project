<template>
    <div class="new-view">
      <NewList :newsList="paginatedNewsList" @news-selected="viewDetail" v-if="!selectedNews" />
      <DetailNew :news="selectedNews" @back="backToList" v-else />
      
      <div v-if="!selectedNews" class="pagination">
        <button @click="prevPage" :disabled="currentPage === 1"><i class="fa-solid fa-chevron-left"></i></button>
        <span>Trang {{ currentPage }} / {{ totalPages }}</span>
        <button @click="nextPage" :disabled="currentPage === totalPages"><i class="fa-solid fa-chevron-right"></i></button>
      </div>
    </div>
  </template>
  
  
  <script>
  import NewList from '../components/NewList.vue';
  import DetailNew from '../components/DetailNew.vue';
  
  export default {
    name: 'NewView',
    components: {
      NewList,
      DetailNew,
    },
    data() {
      return {
        newsList: [
          { 
            id: 1, 
            title: 'Chính thức mở bán Laptop RedmiBook 15, “mưa” ưa đãi, mua ngay thôi!', 
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            summary: 'Đừng “nhìn mặt mà bắt hình dong”, Snapdragon 480 tốt...', 
            image: require('../ImageProduct/ip14_1TB_blue.png') 
          },
          { 
            id: 2, 
            title: 'Apple chính thức mở bán iPhone 14 tại Việt Nam ngày 14/10', 
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            summary: 'Camera Zeiss và chip hình ảnh Vivo V1+ “song kiếm hợp bích” sẽ...', 
            image: require('../ImageProduct/ip14_1TB_yellow.png') 
          },
          { 
            id: 3, 
            title: 'Đánh giá HP ZBook Studio G11: Có gì để thuyết phục bạn bỏ ra tận 50 triệu đồng?', 
            date: '25/06/2024',
            author: 'Nguyễn Văn Duy',
            summary: 'Đừng “nhìn mặt mà bắt hình dong”, Snapdragon 480 tốt...', 
            image: require('../ImageProduct/ip14pro1.png') 
          },
          { 
            id: 4, 
            title: 'Đánh giá Xiaomi Redmi 14C: Một lựa chọn xứng đáng trong phân khúc 3 triệu đồng!', 
            summary: 'Đừng “nhìn mặt mà bắt hình dong”, Snapdragon 480 tốt...', 
            image: require('../ImageProduct/Macbook1.png') 
          },
          { 
            id: 5, 
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G', 
            summary: 'Đừng “nhìn mặt mà bắt hình dong”, Snapdragon 480 tốt...', 
            image: require('../ImageProduct/samsung1.png') 
          },
          { 
            id: 6, 
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G', 
            summary: 'Đừng “nhìn mặt mà bắt hình dong”, Snapdragon 480 tốt...', 
            image: require('../ImageProduct/samsung2.png') 
          },
          { 
            id: 7, 
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G', 
            summary: 'Đừng “nhìn mặt mà bắt hình dong”, Snapdragon 480 tốt...', 
            image: require('../ImageProduct/camera1.png') 
          },
          { 
            id: 8, 
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G', 
            summary: 'Đừng “nhìn mặt mà bắt hình dong”, Snapdragon 480 tốt...', 
            image: require('../ImageProduct/camera1.png') 
          },
          { 
            id: 9, 
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G', 
            summary: 'Đừng “nhìn mặt mà bắt hình dong”, Snapdragon 480 tốt...', 
            image: require('../ImageProduct/camera1.png') 
          },
          { 
            id: 10, 
            title: 'Đánh giá hiệu năng và pin Nokia X10 5G', 
            summary: 'Đừng “nhìn mặt mà bắt hình dong”, Snapdragon 480 tốt...', 
            image: require('../ImageProduct/camera1.png') 
          },
  
          // Thêm tin tức khác nếu cần
        ],
        selectedNews: null,
        currentPage: 1,
        itemsPerPage: 6, // Số lượng tin tức trên mỗi trang
      };
    },
    computed: {
      paginatedNewsList() {
        const start = (this.currentPage - 1) * this.itemsPerPage;
        const end = start + this.itemsPerPage;
        return this.newsList.slice(start, end);
      },
      totalPages() {
        return Math.ceil(this.newsList.length / this.itemsPerPage);
      }
    },
    methods: {
      viewDetail(news) {
        this.selectedNews = news;
      },
      backToList() {
        this.selectedNews = null;
      },
      nextPage() {
        if (this.currentPage < this.totalPages) {
          this.currentPage++;
        }
      },
      prevPage() {
        if (this.currentPage > 1) {
          this.currentPage--;
        }
      }
    },
  };
  </script>
  
  <style scoped>
  .new-view {
    padding: 20px;
  }
  .pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 20px;
  }
  
  .pagination button {
    padding: 10px;
    margin: 0 5px;
    cursor: pointer;
  }
  
  .pagination button:disabled {
    cursor: not-allowed;
    opacity: 0.5;
  }
  
  </style>
  