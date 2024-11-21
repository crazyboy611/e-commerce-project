<template>
    <div class="new-list-container container">
      <div class="sidebar">
        <div class="nav">
          <h3>DANH MỤC TIN TỨC</h3>
          <ul>
            <li><a href="/">Trang chủ</a></li>
            <li><a href="/ProductList">Sản phẩm</a></li>
            <li><a href="/newlist">Tin tức</a></li>
            <li><a href="/contact">Liên hệ</a></li>
          </ul>
        </div>
        <div class="highlight-news">
          <h2>TIN TỨC NỔI BẬT</h2>
          <ul>
            <li v-for="news in getAllTitlesWithIds()" :key="news.id">
                <router-link :to="{ name: 'NewsDetail', params: { id: news.id } }">{{ news.title }}<hr></router-link>
            </li>
          </ul>
        </div>
      </div>
      <div class="news-list">
        <div class="card-container">
          <div class="card" v-for="news in newsList" :key="news.id">
            <img :src="news.image" alt="Tin tức hình ảnh" class="card-image" @click="goToDetail(news.id)" />
            <div class="date_and_auther d-flex justify-content-between">
              <div><i class="fa-regular fa-clock"></i><span class="ms-2">{{ news.date }}</span> </div>
              <div><i class="fa-regular fa-user"></i><span class="ms-2">{{ news.author }}</span></div>
              </div>
            <div class="card-content">
              <h3><a @click="goToDetail(news.id)">{{ gh_text(news.title,10) }}</a></h3>
              <p>{{ gh_text(news.summary,30) }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    name: 'NewList',
    props: {
      newsList: {
        type: Array,
        required: true,
      },
      highlightNews: { // Thêm prop cho tin tức nổi bật
        type: Array,
        required: true,
      },
    },
    methods: {
      gh_text(text, maxWords) {
        const words = text.split(' ');
        if (words.length > maxWords) {
          return words.slice(0, maxWords).join(' ') + '...';
        }
        return text;
      },
      goToDetail(id) {
        this.$router.push({ name: 'NewsDetail', params: { id } });
      },
      getAllTitlesWithIds() {
        return this.newsList.map(({ id, title }) => ({ id, title }));
      },
      getAllTitles() {
        return this.newsList.map(news =>news.title);
      },  
      selectNews(news) {
        this.$emit('news-selected', news);
      },
      getNewsById(id) {
        // Tìm kiếm trong mảng newsList theo id
        const newsItem = this.newsList.find(news => news.id === id);
        
        // Kiểm tra xem tin tức có tồn tại không
        if (newsItem) {
          return {
            title: newsItem.title,
            summary: newsItem.summary,
            content: newsItem.content,
            image: newsItem.image,
          };
        } else {
          return null; // Trả về null nếu không tìm thấy tin tức theo id
        }
      }
    },
  };
  </script>
  
  <style scoped>
  .new-list-container {
    display: flex;
  }
  
  .sidebar {
    width: 25%; /* Chiếm 1 phần */
    background-color: #f8f9fa;
    padding: 15px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  }
  
  .sidebar h3 {
    margin-bottom: 15px;
    font-weight: bold;
  }
  
  .sidebar ul {
    list-style: none;
    padding: 0;
  }
  
  .sidebar li {
    margin-bottom: 10px;
  }
  
  .sidebar a {
    text-decoration: none;
    color: #000;
  }
  
  .sidebar a:hover {
    color: #ff5722; /* Màu cam */
  }
  
  .news-list {
    width: 75%; /* Chiếm 2 phần */
    padding: 15px;
  }
  
  .card-container {
    display: flex;
    flex-wrap: wrap;
    gap: 20px;
  }
  
  .card {
    background-color: #fff;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 20px;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    cursor: pointer;
    width: calc(33.333% - 20px);
  }
  
  .card-image {
    width: 100%;
    height: auto;
    border-radius: 5px;
  }
  
  .card-content {
    margin-top: 10px;
  }
  
  .card h3 {
    margin: 0 0 10px;
  }
  
  .card p {
    margin: 0;
  }
  
  .highlight-news {
    margin-top: 20px; /* Khoảng cách giữa danh sách tin tức và tin tức nổi bật */
  }
  
  .highlight-news h2 {
    margin-bottom: 10px; /* Khoảng cách tiêu đề */
  }
  
  .highlight-news ul {
    list-style: none; /* Bỏ dấu đầu dòng */
    padding: 0; /* Bỏ padding */
  }
  
  .highlight-news li {
    margin-bottom: 5px; /* Khoảng cách giữa các mục tin nổi bật */
  }
  .date_and_auther{
    font-size: 13px;
    color:#ddd;
  }
  </style>
  