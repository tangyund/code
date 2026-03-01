<template>
  <div class="scenic-share">
    <!-- 页面标题 -->
    <div class="page-header">
      <h2>景点分享管理</h2>
      <div class="header-desc">查看用户对景点的分享与评价</div>
    </div>

    <!-- 搜索表单 -->
    <div class="search-form card-container">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="用户名称">
          <el-input 
            v-model="searchForm.userName" 
            placeholder="请输入用户名称" 
            clearable
            prefix-icon="User"
          />
        </el-form-item>
        <el-form-item label="景点名称">
          <el-input 
            v-model="searchForm.spotName" 
            placeholder="请输入景点名称" 
            clearable
            prefix-icon="Location"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch" :icon="Search">查询</el-button>
          <el-button @click="resetSearch" :icon="Refresh">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 分享列表表格 -->
    <div class="card-container-wrapper">
        <div class="card-container">
          <el-table
            :data="shareList"
            v-loading="loading"
            border
            stripe
            highlight-current-row
            class="custom-table"
          >
            <el-table-column type="index" label="#" width="50" />
            <el-table-column prop="userName" label="用户名称" />
            <el-table-column prop="spotName" label="景点名称" />
            <el-table-column prop="shareContent" label="分享内容">
              <template #default="scope">
                <el-tooltip
                  effect="dark"
                  :content="scope.row.shareContent"
                  placement="top-start"
                >
                  <span class="content-text">{{ scope.row.shareContent }}</span>
                </el-tooltip>
              </template>
            </el-table-column>
            <el-table-column prop="shareTime" label="分享时间" width="180">
              <template #default="scope">
                <span class="time-text">{{ formatDateTime(scope.row.shareTime) }}</span>
              </template>
            </el-table-column>
          </el-table>
    
          <!-- 分页 -->
          <div class="pagination">
            <el-pagination
              v-model:current-page="currentPage"
              v-model:page-size="pageSize"
              :total="total"
              :page-sizes="[10, 20, 50, 100]"
              layout="total, sizes, prev, pager, next, jumper"
              @size-change="handleSizeChange"
              @current-change="handleCurrentChange"
              background
            />
          </div>
        </div>
      </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Search, Refresh, User, Location } from '@element-plus/icons-vue'
import api from '@/api/api'

// 数据定义
const loading = ref(false)
const shareList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)

// 搜索表单
const searchForm = ref({
  userName: '',
  spotName: ''
})

// 获取列表
const getList = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    }
    const res = await api.get('/api/admin/scenicShare/page', params)
    shareList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('获取列表失败:', error)
    ElMessage.error('获取列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  getList()
}

// 重置搜索
const resetSearch = () => {
  searchForm.value = {
    userName: '',
    spotName: ''
  }
  currentPage.value = 1
  getList()
}

// 分页大小改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getList()
}

// 页码改变
const handleCurrentChange = (val) => {
  currentPage.value = val
  getList()
}

// 格式化日期时间
const formatDateTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  return date.toLocaleString()
}

// 初始化
onMounted(() => {
  getList()
})
</script>

<style scoped>
.scenic-share {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: 100vh;
}

.page-header {
  margin-bottom: 24px;
}

.page-header h2 {
  font-size: 24px;
  color: #303133;
  margin: 0 0 8px 0;
}

.header-desc {
  color: #909399;
  font-size: 14px;
}

.card-container {
  background: #fff;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  margin-bottom: 20px;
}

.search-form :deep(.el-input__wrapper) {
  border-radius: 4px;
}

.search-form :deep(.el-button) {
  padding: 12px 20px;
  border-radius: 4px;
}

.custom-table {
  margin: 16px 0;
}

.custom-table :deep(.el-table__header) {
  background-color: #f5f7fa;
}

.custom-table :deep(.el-table__row:hover) {
  background-color: #f5f7fa;
}

.content-text {
  color: #606266;
  display: block;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  max-width: 300px;
}

.time-text {
  color: #909399;
  font-size: 13px;
}

.card-container-wrapper {
  height: 550px; /* 设置固定高度 */
  overflow-y: auto; /* 启用垂直滚动条 */
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-pagination.is-background .el-pager li:not(.disabled).active) {
  background-color: #409eff;
}

/* 添加过渡效果 */
.el-table tr {
  transition: all 0.3s ease;
}

.el-button {
  transition: all 0.3s ease;
}

/* 响应式布局 */
@media screen and (max-width: 768px) {
  .search-form :deep(.el-form-item) {
    margin-bottom: 16px;
  }
  
  .content-text {
    max-width: 200px;
  }
}
</style>