<template>
  <div class="scenic-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input
        v-model="searchText"
        placeholder="搜索景点名称"
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

    <!-- 景点列表 -->
    <div class="scenic-list" v-loading="loading">
      <template v-if="scenicList && scenicList.length > 0">
        <el-row :gutter="20">
          <el-col
            v-for="(item, index) in scenicList"
            :key="index"
            :span="8"
          >
            <el-card
              class="scenic-item"
              shadow="hover"
              @click="handleViewDetail(item)"
            >
              <el-image
                :src="getImageUrl(item.pic)"
                class="scenic-img"
                fit="cover"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                  </div>
                </template>
              </el-image>

              <div class="scenic-content">
                <h3 class="title">{{ item.name || '未命名景点' }}</h3>
                <p class="address">
                  <el-icon><Location /></el-icon>
                  {{ item.location || '暂无地址' }}
                </p>
                <p class="time">
                  <el-icon><Clock /></el-icon>
                  {{ item.openingHours || '暂无时间' }}
                </p>
                <p class="price" v-if="item.ticketPrice > 0">
                  ¥<span class="amount">{{ item.ticketPrice }}</span>
                </p>
                <p class="price free" v-else>免费开放</p>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </template>

      <el-empty v-else description="暂无景点数据" />
    </div>

    <!-- 详情对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="currentSpot?.name || '景点详情'"
      width="70%"
    >
      <div class="detail-wrapper" v-if="currentSpot">
        <div class="left-section">
          <el-image
            :src="getImageUrl(currentSpot.pic)"
            class="detail-img"
            fit="cover"
          />
          <div class="basic-info">
            <div class="info-item">
              <el-icon><Location /></el-icon>
              <span>地址：{{ currentSpot.location || '暂无' }}</span>
            </div>
            <div class="info-item">
              <el-icon><Clock /></el-icon>
              <span>开放时间：{{ currentSpot.openingHours || '暂无' }}</span>
            </div>
            <div class="info-item">
              <el-icon><Ticket /></el-icon>
              <span>门票：{{ currentSpot.ticketPrice > 0 ? `¥${currentSpot.ticketPrice}` : '免费开放' }}</span>
            </div>
          </div>
        </div>

        <div class="right-section">
          <div class="description-section">
            <h3>景点介绍</h3>
            <p>{{ currentSpot.description || '暂无介绍' }}</p>
          </div>

          <!-- 评分区域 -->
          <div class="rating-section">
            <h3>景点评分</h3>
            <div class="rating-summary">
              <div v-if="!userInfo" class="login-tip">
                <el-alert
                  title="请登录后进行评分"
                  type="info"
                  :closable="false"
                >
                  <template #default>
                    <el-button type="primary" size="small" @click="handleLogin">
                      去登录
                    </el-button>
                  </template>
                </el-alert>
              </div>

              <template v-else>
                <div class="user-rating">
                  <span class="rating-label">我的评分</span>
                  <el-rate
                    v-model="userRating"
                    allow-half
                    show-score
                    text-color="#ff9900"
                  />
                </div>
                <div class="rating-input">
                  <el-input
                    v-model="ratingComment"
                    type="textarea"
                    :rows="3"
                    placeholder="请输入您的评价（选填）"
                  />
                  <el-button type="primary" @click="submitRating">提交评分</el-button>
                </div>
              </template>
            </div>
          </div>

          <!-- 分享区域 -->
<div class="share-section">
  <h3>景点分享</h3>
  <div class="share-content">
    <div v-if="!userInfo" class="login-tip">
      <el-alert
        title="请登录后进行分享"
        type="info"
        :closable="false"
      >
        <template #default>
          <el-button type="primary" size="small" @click="handleLogin">
            去登录
          </el-button>
        </template>
      </el-alert>
    </div>

    <template v-else>
      <div class="share-form">
        <el-input
          v-model="shareForm.description"
          type="textarea"
          :rows="4"
          placeholder="分享你的游玩体验、建议或者小贴士..."
          maxlength="500"
          show-word-limit
        />
        <div class="share-actions">
          <el-button type="primary" @click="submitShare" :loading="sharing">
            发布分享
          </el-button>
        </div>
      </div>
    </template>
  </div>
</div>

          <!-- 评价列表 -->
          <div class="ratings-list" v-if="ratingList.length > 0">
            <h3>用户评价</h3>
            <el-scrollbar height="200px">
              <div
                v-for="rating in ratingList"
                :key="rating.id"
                class="rating-item"
              >
                <div class="rating-header">
                  <span class="user-name">{{ rating.userName }}</span>
                  <span class="rating-time">{{ formatDate(rating.ratingTime) }}</span>
                </div>
                <el-rate
                  v-model="rating.rating"
                  disabled
                  show-score
                  text-color="#ff9900"
                />
                <p class="comment" v-if="rating.review">{{ rating.review }}</p>
              </div>
            </el-scrollbar>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Search, Location, Picture, Clock, Ticket, Plus } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { get, post } from '@/api/api'
import { useRouter } from 'vue-router'

const router = useRouter()
const loading = ref(false)
const scenicList = ref([])
const searchText = ref('')
const dialogVisible = ref(false)
const currentSpot = ref(null)
const userRating = ref(0)
const ratingComment = ref('')
const ratingList = ref([])
const sharing = ref(false)

// 分享表单
const shareForm = ref({
  description: '',
  pic: '',
  scenicSpotId: '',
  scenicName: '',
  userId: '',
  userName: ''
})

// 获取用户信息
const userInfo = computed(() => {
  const storedUser = localStorage.getItem('userInfo')
  return storedUser ? JSON.parse(storedUser) : null
})

// 上传请求头
const uploadHeaders = computed(() => ({
  Authorization: localStorage.getItem('token') || ''
}))

// 获取景点列表
const getList = async () => {
  loading.value = true
  try {
    const res = await get('/api/admin/scenicSpot/list', {
      name: searchText.value
    })
    if (res && res.data) {
      scenicList.value = Array.isArray(res.data) ? res.data : (res.data.records || [])
    }
  } catch (error) {
    console.error('获取数据失败:', error)
    ElMessage.error('获取景点列表失败')
    scenicList.value = []
  } finally {
    loading.value = false
  }
}

// 搜索和重置
const handleSearch = () => getList()
const handleReset = () => {
  searchText.value = ''
  getList()
}

// 获取图片URL
const getImageUrl = (pic) => {
  if (!pic) return ''
  if (pic.startsWith('http')) return pic
  return `http://localhost:8081/api/admin/scenicSpot/image/${pic}`
}

// 格式化日期
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleString()
}

// 获取评分列表
const getRatings = async (spotId) => {
  try {
    const res = await get('/api/admin/scenicRating/list', {
      spotId: spotId,
      page: 1,
      pageSize: 10
    })
    if (res && res.data) {
      ratingList.value = res.data.records || []
    }
  } catch (error) {
    console.error('获取评分列表失败:', error)
  }
}

// 提交评分
const submitRating = async () => {
  if (!userInfo.value) {
    ElMessage.warning('请先登录后再评分')
    return
  }

  if (userRating.value === 0) {
    ElMessage.warning('请先进行评分')
    return
  }

  try {
    const rating = {
      userId: userInfo.value.id,
      userName: userInfo.value.username,
      spotId: currentSpot.value.id,
      spotName: currentSpot.value.name,
      rating: Math.round(userRating.value),
      review: ratingComment.value,
      ratingTime: new Date()
    }

    const res = await post('/api/admin/scenicRating/add', rating)

    if (res && res.code === 200) {
      ElMessage.success('评分成功')
      await getRatings(currentSpot.value.id)
      userRating.value = 0
      ratingComment.value = ''
    } else {
      ElMessage.error(res.msg || '评分失败')
    }
  } catch (error) {
    console.error('提交评分失败:', error)
    ElMessage.error('评分失败，请重试')
  }
}

// 处理图片上传成功
const handleUploadSuccess = (response) => {
  if (response.code === 200) {
    shareForm.value.pic = response.data
    ElMessage.success('图片上传成功')
  } else {
    ElMessage.error(response.msg || '上传失败')
  }
}

// 处理图片上传失败
const handleUploadError = () => {
  ElMessage.error('图片上传失败')
}

// 上传前验证
const beforeUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB!')
    return false
  }
  return true
}

// 提交分享
const submitShare = async () => {
  if (!shareForm.value.description.trim()) {
    ElMessage.warning('请输入分享内容')
    return
  }

  sharing.value = true
  try {
    const shareData = {
      ...shareForm.value,
      scenicSpotId: currentSpot.value.id,
      scenicName: currentSpot.value.name,
      userId: userInfo.value.id,
      userName: userInfo.value.username,
      createTime: new Date()
    }

    const res = await post('/api/admin/scenicShare/add', shareData)
    if (res.code === 200) {
      ElMessage.success('分享成功')
      shareForm.value = {
        description: '',
        pic: '',
        scenicSpotId: '',
        scenicName: '',
        userId: '',
        userName: ''
      }
    } else {
      ElMessage.error(res.msg || '分享失败')
    }
  } catch (error) {
    console.error('分享失败:', error)
    ElMessage.error('分享失败，请重试')
  } finally {
    sharing.value = false
  }
}

// 查看详情
const handleViewDetail = async (item) => {
  currentSpot.value = item
  dialogVisible.value = true
  await getRatings(item.id)
}

// 登录跳转
const handleLogin = () => {
  router.push('/login')
}

// 初始化
getList()
</script>

<style scoped>
.scenic-container {
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

.scenic-list {
  max-height: 80vh;
  overflow-y: auto;
  padding-right: 10px;
}

.scenic-item {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-5px);
  }
}

.scenic-img {
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

.scenic-content {
  padding: 15px 0;

  .title {
    font-size: 18px;
    font-weight: bold;
    margin: 0 0 10px;
  }

  .address,
  .time {
    display: flex;
    align-items: center;
    gap: 5px;
    margin: 8px 0;
    color: #666;
  }

  .price {
    margin: 10px 0 0;
    color: #f56c6c;

    .amount {
      font-size: 20px;
      font-weight: bold;
    }

    &.free {
      color: #67c23a;
    }
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

.rating-section,
.share-section {
  margin-top: 30px;
  padding: 20px;
  background: #f8f9fa;
  border-radius: 8px;
}

.share-content {
  margin-top: 15px;
}

.share-form {
  .el-textarea {
    margin-bottom: 15px;
  }
}

.upload-section {
  margin-bottom: 15px;
}

.share-uploader {
  :deep(.el-upload) {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    transition: var(--el-transition-duration-fast);
    
    &:hover {
      border-color: var(--el-color-primary);
    }
  }
}

.share-img {
  width: 148px;
  height: 148px;
  display: block;
  object-fit: cover;
}

.upload-placeholder {
  width: 148px;
  height: 148px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #8c939d;
  
  .el-icon {
    font-size: 28px;
    margin-bottom: 8px;
  }
}

.upload-tip {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

.share-actions {
  display: flex;
  justify-content: flex-end;
  margin-top: 15px;
}

.rating-item {
  padding: 12px;
  border-bottom: 1px solid #eee;

  .rating-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;

    .user-name {
      color: #409EFF;
    }

    .rating-time {
      color: #909399;
      font-size: 12px;
    }
  }

  .comment {
    margin: 8px 0 0;
    color: #666;
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