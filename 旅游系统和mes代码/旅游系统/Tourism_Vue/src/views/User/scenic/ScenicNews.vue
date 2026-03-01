<template>
  <div class="scenic-news-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input
        v-model="searchText"
        placeholder="搜索新闻标题"
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

    <!-- 新闻列表 -->
    <div class="scenic-news-list" v-loading="loading">
      <template v-if="newsList && newsList.length > 0">
        <el-row :gutter="20">
          <el-col
            v-for="(item, index) in newsList"
            :key="index"
            :span="8"
          >
            <el-card
              v-if="item"
              class="scenic-news-item"
              shadow="hover"
              @click="handleViewDetail(item)"
            >
              <el-image
                :src="getImageUrl(item.pic)"
                class="scenic-news-img"
                fit="cover"
              >
                <template #error>
                  <div class="image-slot">
                    <el-icon><Picture /></el-icon>
                  </div>
                </template>
              </el-image>

              <div class="scenic-news-content">
                <h3 class="title">{{ item.title || '未命名新闻' }}</h3>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </template>

      <el-empty v-else description="暂无新闻数据" />
    </div>

    <!-- 详情对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="currentNews?.title || '新闻详情'"
      width="70%"
    >
      <div class="detail-wrapper" v-if="currentNews">
        <div class="left-section">
          <el-image
            :src="getImageUrl(currentNews.pic)"
            class="detail-img"
            fit="cover"
          />
        </div>

        <div class="right-section">
          <div class="description-section">
            <h3>新闻内容</h3>
            <p>{{ currentNews.content || '暂无内容' }}</p>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Search, Picture } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { get, post } from '@/api/api'
import { useRouter } from 'vue-router'

const router = useRouter()
const loading = ref(false)
const newsList = ref([])
const searchText = ref('')
const dialogVisible = ref(false)
const currentNews = ref(null)

// 获取图片URL
const getImageUrl = (pic) => {
  if (!pic) return ''
  if (pic.startsWith('http')) return pic
  return `http://localhost:8081/api/admin/scenicNews/image/${pic}`
}

// 获取新闻列表
const getList = async () => {
  loading.value = true
  try {
    const res = await get('/api/admin/scenicNews/list', {
      title: searchText.value
    })
    if (res && res.data) {
      newsList.value = Array.isArray(res.data)? res.data : (res.data.records || [])
    }
  } catch (error) {
    console.error('获取数据失败:', error)
    ElMessage.error('获取新闻列表失败')
    newsList.value = []
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

// 查看详情
const handleViewDetail = async (item) => {
  currentNews.value = item
  dialogVisible.value = true
}

// 初始化
getList()
</script>

<style scoped>
.scenic-news-container {
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

.scenic-news-list {
  max-height: 80vh; /* 设置最大高度 */
  overflow-y: auto; /* 添加垂直滚动条 */
  padding-right: 10px; /* 避免滚动条遮挡内容 */
}

.scenic-news-item {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-5px);
  }
}

.scenic-news-img {
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

.scenic-news-content {
  padding: 15px 0;

.title {
    font-size: 18px;
    font-weight: bold;
    margin: 0 0 10px;
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