<template>
  <el-menu
    :default-active="activeMenu"
    class="el-menu-vertical"
    background-color="#304156"
    text-color="#fff"
    active-text-color="#409EFF"
    router
  >
    <el-menu-item index="/VScenicSpotList">
      <el-icon><Location /></el-icon>
      <span>景点管理</span>
    </el-menu-item>

    <el-menu-item index="/VScenicRatingList">
      <el-icon><Star /></el-icon>
      <span>评价管理</span>
    </el-menu-item>

    <el-menu-item index="/VFoodOrder">
      <el-icon><User /></el-icon>
      <span>订单管理</span>
    </el-menu-item>
	
	<el-menu-item index="/VMenu">
	  <el-icon><User /></el-icon>
	  <span>菜品管理</span>
	</el-menu-item>
	
	
  </el-menu>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { Location, Star, User } from '@element-plus/icons-vue'

const route = useRoute()
const activeMenu = computed(() => route.path)
</script>

<style scoped>
.el-menu {
  border-right: none;
  height: 100%;
}

.el-menu-item {
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
