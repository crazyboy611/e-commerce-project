<template>
  <div class="dashboard">
    <div class="sidebar bg-dark text-white p-3" style="width: 250px; height: 100vh; position: fixed;">
      <h2>Admin Dashboard</h2>
      <ul class="nav flex-column">
        <li class="nav-item">
          <router-link to="/admin/dashboard" class="nav-link text-white">Dashboard</router-link>
        </li>
        <li class="nav-item">
          <router-link to="/admin/users" class="nav-link text-white">Users</router-link>
        </li>
        <li class="nav-item">
          <router-link to="/admin/settings" class="nav-link text-white">Settings</router-link>
        </li>
      </ul>
    </div>
    
    <main class="content" style="margin-left: 250px;">
      <header class="bg-light p-3">
        <h1>Admin Panel</h1>
      </header>
      <div class="pt-3 container-fluid">
        <div class="row">
          <div class="col-md-4">
            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title">Total Users</h5>
                <p class="card-text">100</p>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title">Total Orders</h5>
                <p class="card-text">200</p>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="card mb-4">
              <div class="card-body">
                <h5 class="card-title">Total Revenue</h5>
                <p class="card-text">$5000</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
export default {
  name: 'AdminDashboard',
};
</script>

<style scoped>
.dashboard {
  display: flex;
}

.sidebar {
  position: fixed;
  height: 100vh;
}

.content {
  margin-left: 250px;
  flex-grow: 1;
}

.card {
  transition: transform 0.2s;
}

.card:hover {
  transform: scale(1.05);
}
</style>
