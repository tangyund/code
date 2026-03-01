<template>
  <div class="app-wrapper">
    <!-- 顶部导航 -->
    <div class="header-container">
      <Header />
    </div>
    
    <!-- 主要内容区 -->
    <div class="main-container">
      <div class="app-main">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script setup>
import Header from '@/components/user/Header.vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const router = useRouter()

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('userInfo')
  router.push('/login')
  ElMessage.success('退出成功')
}
</script>

<style scoped>
.app-wrapper {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f7fa;
}

.header-container {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 999;
  background-color: #fff;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
  height: 60px;
}

.main-container {
  flex: 1;
  margin-top: 60px; /* 顶栏高度 */
  min-height: calc(100vh - 60px); /* 减去顶栏高度 */
}

.app-main {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  height: 100%;
}

/* 响应式设计 */
@media screen and (max-width: 1200px) {
  .app-main {
    padding: 20px;
    margin: 0 20px;
  }
}

@media screen and (max-width: 768px) {
  .app-main {
    padding: 15px;
    margin: 0 15px;
  }
}
</style>