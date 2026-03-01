<template>
  <div class="activity-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input
        v-model="searchText"
        placeholder="搜索活动名称"
        class="search-input"
        clearable
        @keyup.enter="handleSearch"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
      </el-input>
      <el-button type="primary" @click="handleSearch">搜索</el-button>
      <el-button @click="handleReset">重置</el-button>
    </div>

    <!-- 活动列表 -->
    <div class="activity-list" v-loading="loading">
      <template v-if="activityList && activityList.length > 0">
        <el-row :gutter="20">
          <el-col
            v-for="(item, index) in activityList"
            :key="index"
            :span="8"
          >
            <el-card
              v-if="item"
              class="activity-item"
              shadow="hover"
              @click="handleViewDetail(item)"
            >
              <el-image
                :src="getImageUrl(item.pic)"
                class="activity-img"
                fit="cover"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                  </div>
                </template>
              </el-image>

              <div class="activity-content">
                <h3 class="title">{{ item.activityName || '未命名活动' }}</h3>
                <p class="time">
                  <el-icon><Clock /></el-icon>
                  {{ formatDateTime(item.startTime) }} 至 {{ formatDateTime(item.endTime) }}
                </p>
                <p class="location">
                  <el-icon><Location /></el-icon>
                  {{ item.location || '暂无地点' }}
                </p>
                <el-button type="primary" @click.stop="handleBooking(item)">预约</el-button>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </template>

      <el-empty v-else description="暂无活动数据" />
    </div>

    <!-- 活动详情对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="currentActivity?.activityName || '活动详情'"
      width="70%"
    >
      <div class="detail-wrapper" v-if="currentActivity">
         <div class="left-section">
          <el-image
            :src="getImageUrl(currentActivity.pic)"
            class="detail-img"
            fit="cover"
          />
          <div class="basic-info">
            <div class="info-item">
              <el-icon><Location /></el-icon>
              <span>地点：{{ currentActivity.location || '暂无' }}</span>
            </div>
            <div class="info-item">
              <el-icon><Clock /></el-icon>
              <span>时间：{{ formatDateTime(currentActivity.startTime) }} 至 {{ formatDateTime(currentActivity.endTime) }}</span>
            </div>
          </div>
        </div>

        <div class="right-section">
          <div class="description-section">
            <h3>活动介绍</h3>
            <p>{{ currentActivity.description || '暂无介绍' }}</p>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Search, Clock, Picture, Location } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { get, post } from '@/api/api'
import moment from 'moment'

// 数据定义
const loading = ref(false)
const activityList = ref([])
const searchText = ref('')
const dialogVisible = ref(false)
const currentActivity = ref(null)

// 当前用户信息
const currentUser = computed(() => {
  const storedUser = localStorage.getItem('userInfo')
  return storedUser ? JSON.parse(storedUser) : null
})

// 获取活动列表
const getActivityList = async () => {
  loading.value = true
  try {
    const res = await get('/api/admin/activity/list', {
      activityName: searchText.value
    })
    if (res && res.data) {
      activityList.value = Array.isArray(res.data) ? res.data : (res.data.records || [])
    }
  } catch (error) {
    console.error('获取活动列表失败:', error)
    ElMessage.error('获取活动列表失败')
    activityList.value = []
  } finally {
    loading.value = false
  }
}

// 搜索和重置
const handleSearch = () => getActivityList()
const handleReset = () => {
  searchText.value = ''
  getActivityList()
}

// 处理预约逻辑
const handleBooking = async (item, event) => {
  if (!currentUser.value) {
    ElMessage.error('请先登录后再预约')
    return
  }

  try {
    await ElMessageBox.confirm(
      `确认预约活动 "${item.activityName}" 吗？`,
      '提示',
      { type: 'warning' }
    )
    const payload = {
      userId: currentUser.value.id,
      userName: currentUser.value.username,
      activityId: item.id,
      activityName: item.activityName,
      bookingTime: new Date(),
      status: '已确认'
    }
    await post('/api/admin/activityBooking/add', payload)
    ElMessage.success('预约成功')
  } catch (error) {
    console.error('预约失败:', error)
    if (error !== 'cancel') {
      ElMessage.error('预约失败，请稍后重试')
    }
  }
}

// 获取图片URL
const getImageUrl = (pic) => {
  if (!pic) return ''
  if (pic.startsWith('http')) return pic
  return `http://localhost:8081/api/admin/activity/image/${pic}`
}

// 格式化日期时间
const formatDateTime = (dateTimeString) => {
  if (!dateTimeString) return '未设置'
  return moment(dateTimeString).format('YYYY-MM-DD HH:mm:ss')
}

// 查看详情
const handleViewDetail = (item) => {
  currentActivity.value = item
  dialogVisible.value = true
}

// 初始化
getActivityList()
</script>

<style scoped>
.activity-container {
  padding: 20px;
}

.search-bar {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;

  .search-input {
    width: 300px;
  }
}

.activity-list {
  max-height: 80vh;
  overflow-y: auto;
  padding-right: 10px;
}

.activity-item {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-5px);
  }
}

.activity-img {
  width: 100%;
  height: 200px;
  border-radius: 4px;

  .image-slot {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
    background: #f5f7fa;
    color: #909399;
    font-size: 30px;
  }
}

.activity-content {
  padding: 15px 0;

  .title {
    font-size: 18px;
    font-weight: bold;
    margin: 0 0 10px;
  }

  .time,
  .location {
    display: flex;
    align-items: center;
    gap: 5px;
    margin: 8px 0;
    color: #666;
  }
}

.detail-wrapper {
  display: flex;
  gap: 20px;
}

.left-section {
  width: 40%;

  .detail-img {
    width: 100%;
    height: 300px;
    border-radius: 8px;
  }

  .basic-info {
    margin-top: 20px;

    .info-item {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 12px;
      color: #666;
    }
  }
}

.right-section {
  flex: 1;

  h3 {
    margin: 0 0 16px;
    color: #303133;
  }
}

@media screen and (max-width: 768px) {
  .detail-wrapper {
    flex-direction: column;
  }

  .left-section {
    width: 100%;
  }
}
</style>
