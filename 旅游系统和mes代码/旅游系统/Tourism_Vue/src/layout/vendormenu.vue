<template>
  <div class="app-wrapper">
    <div class="sidebar-container">
      <vendorMenu />  <!--  这里修改了 -->
    </div>
    <div class="main-container">
      <div class="app-main">
        <router-view />
      </div>
    </div>
  </div>
</template>

<script setup>
import vendorMenu from '@/components/vendor/vendorMenu.vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'

const router = useRouter()

const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('userInfo')
  router.push('/login')
  ElMessage.success('退出成功') // 这里修改了
}
</script>

<style scoped>
.app-wrapper {
  display: flex;
  height: 100vh;
  width: 100%;
}

.sidebar-container {
  width: 210px;
  background-color: #304156;
}

.main-container {
  flex: 1;
  overflow: auto;
}

.app-main {
  padding: 20px;
}
</style>
