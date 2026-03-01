<template>
  <div class="lodging-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input
        v-model="searchText"
        placeholder="搜索民宿名称"
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

    <!-- 民宿列表 -->
    <div class="lodging-list" v-loading="loading">
      <template v-if="lodgingList && lodgingList.length > 0">
        <el-row :gutter="20">
          <el-col
            v-for="(item, index) in lodgingList"
            :key="index"
            :span="8"
          >
            <el-card
              v-if="item"
              class="lodging-item"
              shadow="hover"
              @click="handleViewDetail(item)"
            >
              <el-image
                :src="getImageUrl(item.pic)"
                class="lodging-img"
                fit="cover"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                  </div>
                </template>
              </el-image>

              <div class="lodging-content">
                <h3 class="title">{{ item.name || '未命名民宿' }}</h3>
                <p class="location">
                  <el-icon><Location /></el-icon>
                  {{ item.location || '暂无地址' }}
                </p>
                <p class="price" v-if="item.price > 0">
                  ¥<span class="amount">{{ item.price }}</span>
                </p>
                <p class="price free" v-else>免费</p>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </template>

      <el-empty v-else description="暂无民宿数据" />
    </div>

    <!-- 民宿详情对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="currentLodging?.name || '民宿详情'"
      width="70%"
    >
      <div class="detail-wrapper" v-if="currentLodging">
        <div class="left-section">
          <el-image
            :src="getImageUrl(currentLodging.pic)"
            class="detail-img"
            fit="cover"
          />
          <div class="basic-info">
            <div class="info-item">
              <el-icon><Location /></el-icon>
              <span>地址：{{ currentLodging.location || '暂无' }}</span>
            </div>
            <div class="info-item">
              <el-icon><Ticket /></el-icon>
              <span>价格：{{ currentLodging.price > 0 ? `¥${currentLodging.price}` : '免费' }}</span>
            </div>
            <div class="info-item">
              <el-icon><Phone /></el-icon>
              <span>联系方式：{{ currentLodging.contactInfo || '暂无' }}</span>
            </div>
          </div>
        </div>

        <div class="right-section">
          <div class="description-section">
            <h3>民宿介绍</h3>
            <p>{{ currentLodging.description || '暂无介绍' }}</p>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Search, Location, Picture, Ticket, Phone } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { get } from '@/api/api'

// 数据定义
const loading = ref(false)
const lodgingList = ref([])
const searchText = ref('')
const dialogVisible = ref(false)
const currentLodging = ref(null)

// 获取民宿列表
const getList = async () => {
  loading.value = true
  try {
    const res = await get('/api/admin/lodging/list', {
      name: searchText.value
    })
    if (res && res.data) {
      lodgingList.value = Array.isArray(res.data) ? res.data : (res.data.records || [])
    }
  } catch (error) {
    console.error('获取民宿列表失败:', error)
    ElMessage.error('获取民宿列表失败')
    lodgingList.value = []
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
  return `http://localhost:8081/api/admin/lodging/image/${pic}`
}

// 查看详情
const handleViewDetail = (item) => {
  currentLodging.value = item
  dialogVisible.value = true
}

// 初始化
getList()
</script>

<style scoped>
.lodging-container {
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

.lodging-list {
  max-height: 80vh;
  overflow-y: auto;
  padding-right: 10px;
}

.lodging-item {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-5px);
  }
}

.lodging-img {
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

.lodging-content {
  padding: 15px 0;

  .title {
    font-size: 18px;
    font-weight: bold;
    margin: 0 0 10px;
  }

  .location {
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

@media screen and (max-width: 768px) {
  .detail-wrapper {
    flex-direction: column;
  }

  .left-section {
    width: 100%;
  }
}
</style>
