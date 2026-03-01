<template>
  <el-menu
    :default-active="activeMenu"
    class="el-menu-vertical"
    background-color="#304156"
    text-color="#fff"
    active-text-color="#409EFF"
    router
  >
    <el-menu-item index="/ScenicSpotList">
      <el-icon><Location /></el-icon>
      <span>景点管理</span>
    </el-menu-item>
    
    <el-menu-item index="/ScenicRatingList">
      <el-icon><Star /></el-icon>
      <span>评价管理</span>
    </el-menu-item>
	
	<el-menu-item index="/ScenicNewsList">
	  <el-icon><Star /></el-icon>
	  <span>新闻管理</span>
	</el-menu-item>
	
	<el-menu-item index="/RespondConsultation">
	  <el-icon><Star /></el-icon>
	  <span>咨询回复</span>
	</el-menu-item>

    <el-menu-item index="/RouteList">
      <el-icon><Connection /></el-icon>
      <span>路线管理</span>
    </el-menu-item>

    <el-menu-item index="/UserList">
      <el-icon><User /></el-icon>
      <span>用户管理</span>
    </el-menu-item>
	<el-menu-item index="/LodgingInfoList">
	  <el-icon><School /></el-icon>
	  <span>民宿管理</span>
	</el-menu-item>
	<el-menu-item index="/FoodVendor">
	  <el-icon><DishDot /></el-icon>
	  <span>商家管理</span>
	</el-menu-item>
	<el-menu-item index="/FoodOrder">
	  <el-icon><Bell /></el-icon>
	  <span>订单管理</span>
	  </el-menu-item>
	  <el-menu-item index="/ActivityList">
	    <el-icon><Flag /></el-icon>
	    <span>活动管理</span>
	</el-menu-item>
	
	<el-menu-item index="/ActivityBookingList">
	    <el-icon><AlarmClock /></el-icon>
	    <span>预约管理</span>
	</el-menu-item>
	<el-menu-item index="/ScenicSpotShare">
	  <el-icon><Share /></el-icon>
	  <span>景点分享</span>
	</el-menu-item>
	
	<el-menu-item index="/FoodRecommend">
	  <el-icon><Food /></el-icon>
	  <span>美食推荐</span>
	</el-menu-item>
	
  </el-menu>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { Location, Star, User, Connection } from '@element-plus/icons-vue'

const route = useRoute()
const activeMenu = computed(() => route.path)

// 使用 defineExpose 显式导出 activeMenu
defineExpose({
  activeMenu
})
</script>

<style scoped>
.container {
  height: 100%;
}

.el-menu {
  border-right: none;
  height: 100%;
}

:deep(.el-menu-item) {
  &:hover {
    background-color: #263445 !important;
  }

  &.is-active {
    background-color: #263445 !important;
  }
}

/* 图标样式 */
.el-icon {
  vertical-align: middle;
  margin-right: 10px;
  width: 24px;
  text-align: center;
}

/* 文字样式 */
span {
  vertical-align: middle;
}
</style>
