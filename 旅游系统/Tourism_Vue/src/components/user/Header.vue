<template>
  <div class="header">
    <div class="header-content">
      <!-- 导航菜单 -->
      <div class="nav-menu">
        <el-menu
          mode="horizontal"
          :router="true"
          :default-active="activeMenu"
        >
          <el-menu-item index="/home">首页</el-menu-item>
          <el-menu-item index="/ScenicSpot">景点推荐</el-menu-item>
		  <el-menu-item index="/ScenicNews">景点新闻</el-menu-item>
		  <el-menu-item index="/TouristConsultation">游客咨询</el-menu-item>
          <el-menu-item index="/Routeselection">路线规划</el-menu-item>
		  <el-menu-item index="/LodgingInfo">民宿推荐</el-menu-item>
     
		  <el-menu-item index="/Activity">文化活动</el-menu-item>
		  <el-menu-item index="/MeOrder">点单</el-menu-item>
		  		<el-menu-item index="/Order">查看订单</el-menu-item>
				<el-menu-item index="/Food">美食推荐</el-menu-item>
				<el-menu-item index="/ScenicShare">景点分享</el-menu-item>
        </el-menu>
      </div>

      <!-- 右侧功能区 -->
      <div class="right-menu">
 

        <!-- 用户信息 -->
        <div class="user-info" v-if="userInfo">
          <el-dropdown @command="handleCommand">
            <span class="user-name">{{ userInfo.username }}</span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">个人中心</el-dropdown-item>
                <el-dropdown-item command="favorites">我的收藏</el-dropdown-item>
                <el-dropdown-item command="settings">账号设置</el-dropdown-item>
                <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>

        <!-- 未登录状态 -->
        <div class="login-btns" v-else>
          <el-button type="primary" @click="handleLogin">登录/注册</el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Search } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const searchKeyword = ref('')
const userInfo = ref(JSON.parse(localStorage.getItem('userInfo')))

// 当前激活的菜单
const activeMenu = computed(() => route.path)

// 搜索处理
const handleSearch = () => {
  if (!searchKeyword.value.trim()) return
  router.push({
    path: '/search',
    query: { keyword: searchKeyword.value }
  })
}

// 下拉菜单命令处理
const handleCommand = (command) => {
  switch (command) {
    case 'profile':
      router.push('/user/profile')
      break
    case 'favorites':
      router.push('/user/favorites')
      break
    case 'settings':
      router.push('/user/settings')
      break
    case 'logout':
      handleLogout()
      break
  }
}

const handleLogin = () => router.push('/')  



const handleLogout = () => {
  localStorage.removeItem('token')
  localStorage.removeItem('userInfo')
  router.push('/login')
}
</script>

<style scoped>
.header {
  height: 60px;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
}

.header-content {
  max-width: 1200px;
  height: 100%;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
}

.nav-menu {
  flex: 1;
  
  :deep(.el-menu) {
    border: none;
    justify-content: center;
  }
  
  :deep(.el-menu-item) {
    font-size: 16px;
    height: 60px;
    line-height: 60px;
  }
}

.right-menu {
  display: flex;
  align-items: center;
  gap: 20px;
  
  .search-box {
    width: 200px;
    
    :deep(.el-input__wrapper) {
      border-radius: 20px;
    }
  }
  
  .user-info {
    .user-name {
      font-size: 14px;
      color: #333;
      cursor: pointer;
    }
  }
  
  .login-btns {
    display: flex;
    gap: 10px;
  }
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .nav-menu {
    :deep(.el-menu-item) {
      padding: 0 12px;
    }
  }
  
  .right-menu {
    .search-box {
      display: none;
    }
  }
}
</style> 