<template>
  <div class="food-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input
        v-model="searchText"
        placeholder="搜索美食名称"
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

    <!-- 美食排行榜 -->
    <div class="ranking-section">
      <h2 class="ranking-title">
        <el-icon><Trophy /></el-icon>
        美食排行榜
      </h2>
      <el-card class="ranking-card">
        <el-table 
          :data="rankingList.slice(0, 3)" 
          style="width: 100%" 
          :show-header="false"
          v-loading="!rankingList.length"
        >
          <el-table-column width="80">
            <template #default="scope">
              <div class="rank-number" :class="'rank-' + (scope.$index + 1)">
                {{ scope.$index + 1 }}
              </div>
            </template>
          </el-table-column>
          <el-table-column>
            <template #default="scope">
              <div class="food-info">
                <div class="food-header">
                  <span class="food-name">{{ scope.row.name }}</span>
                  <span class="food-desc">{{ scope.row.description }}</span>
                </div>
                <div class="rating-info">
                  <el-rate
                    v-model="scope.row.avgRating"
                    disabled
                    show-score
                    text-color="#ff9900"
                    score-template="{value}"
                  />
                  <span class="rating-count">({{ scope.row.ratingCount }}人评分)</span>
                </div>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </el-card>
    </div>

    <!-- 美食列表 -->
    <div class="food-list-container">
      <div class="food-list" v-loading="loading">
        <template v-if="foodList && foodList.length > 0">
          <el-row :gutter="20">
            <el-col v-for="(item, index) in foodList" :key="index" :span="8">
              <el-card
                class="food-item"
                shadow="hover"
                @click="handleViewDetail(item)"
              >
                <el-image
                  :src="getImageUrl(item.pic)"
                  class="food-img"
                  fit="cover"
                >
                  <template #error>
                    <div class="image-slot">
                      <el-icon><Picture /></el-icon>
                    </div>
                  </template>
                </el-image>
                <div class="food-content">
                  <h3 class="title">{{ item.name || '未命名美食' }}</h3>
                  <p class="description">{{ item.description || '暂无描述' }}</p>
                  <div class="rating-info">
                    <el-rate
                      v-model="item.avgRating"
                      disabled
                      show-score
                      text-color="#ff9900"
                    />
                    <span class="rating-count">({{ item.ratingCount || 0 }}人评分)</span>
                  </div>
                  <div class="tags" v-if="item.tags">
                    <el-tag
                      v-for="tag in item.tags.split(',')"
                      :key="tag"
                      size="small"
                      class="tag-item"
                    >
                      {{ tag }}
                    </el-tag>
                  </div>
                </div>
              </el-card>
            </el-col>
          </el-row>
        </template>
        <el-empty v-else description="暂无美食数据" />
      </div>
    </div>

    <!-- 评分对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="currentFood?.name || '美食评分'"
      width="50%"
    >
      <div class="rating-dialog" v-if="currentFood">
        <el-image
          :src="getImageUrl(currentFood.pic)"
          class="detail-img"
          fit="cover"
        />
        
        <div class="rating-section">
          <h3>{{ currentFood.name }}</h3>
          <p class="description">{{ currentFood.description }}</p>
          
          <div class="current-rating">
            <span class="label">当前评分：</span>
            <el-rate
              v-model="currentFood.avgRating"
              disabled
              show-score
              text-color="#ff9900"
            />
            <span class="count">({{ currentFood.ratingCount || 0 }}人评分)</span>
          </div>

          <div class="user-rating">
            <span class="label">我的评分：</span>
            <el-rate
              v-model="userRating"
              allow-half
              show-score
              text-color="#ff9900"
            />
          </div>

          <el-input
            v-model="ratingComment"
            type="textarea"
            :rows="3"
            placeholder="请输入评价（选填）"
          />

          <div class="dialog-footer">
            <el-button @click="dialogVisible = false">取消</el-button>
            <el-button type="primary" @click="submitRating">提交评分</el-button>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>


<script setup>
import { ref, onMounted } from 'vue'
import { Search, Picture, Trophy } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import { get, post } from '@/api/api'

const loading = ref(false)
const foodList = ref([])
const searchText = ref('')
const dialogVisible = ref(false)
const currentFood = ref(null)
const userRating = ref(0)
const ratingComment = ref('')
const rankingList = ref([])

// 获取美食列表
const getList = async () => {
  loading.value = true
  try {
    const res = await get('/api/admin/foodRecommend/page', {
      name: searchText.value
    })
    if (res && res.data) {
      foodList.value = Array.isArray(res.data) ? res.data : (res.data.records || [])
    }
  } catch (error) {
    console.error('获取数据失败:', error)
    ElMessage.error('获取美食列表失败')
    foodList.value = []
  } finally {
    loading.value = false
  }
}

// 获取排行榜数据
const getRankingList = async () => {
  try {
    const res = await get('/api/food/ranking')
    if (res && res.code === 200) {
      rankingList.value = res.data || []
      // 确保评分值是数字类型
      rankingList.value = rankingList.value.map(item => ({
        ...item,
        avgRating: Number(item.avgRating) || 0,
        ratingCount: Number(item.ratingCount) || 0
      }))
    }
  } catch (error) {
    console.error('获取排行榜失败:', error)
    ElMessage.error('获取排行榜失败')
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
  return `http://localhost:8081/api/admin/foodRecommend/image/${pic}`
}

// 查看详情并评分
const handleViewDetail = (item) => {
  currentFood.value = item
  userRating.value = 0
  ratingComment.value = ''
  dialogVisible.value = true
}

// 提交评分
const submitRating = async () => {
  if (!userRating.value) {
    ElMessage.warning('请先进行评分')
    return
  }

  try {
    const res = await post('/api/food/rating/submit', {
      foodId: currentFood.value.id,
      rating: userRating.value,
      review: ratingComment.value || '',
      userId: 1  // 临时使用默认用户ID
    })

    if (res.code === 200) {
      ElMessage.success('评分成功')
      dialogVisible.value = false
      // 刷新列表和排行榜
      getList()
      getRankingList()
    } else {
      ElMessage.error(res.msg || '评分失败')
    }
  } catch (error) {
    console.error('评分失败:', error)
    ElMessage.error('评分失败，请稍后重试')
  }
}

// 初始化
onMounted(() => {
  getList()
  getRankingList()
})
</script>


<style scoped>
.food-container {
  padding: 20px;
  height: 100vh;
}

.search-bar {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
}

.search-input {
  width: 300px;
}

/* 排行榜样式 */
.ranking-section {
  margin: 20px 0;
}

.ranking-title {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 16px;
  color: #303133;
}

.ranking-title .el-icon {
  color: #ffd700;
}

.ranking-card {
  margin-bottom: 20px;
}

.rank-number {
  width: 28px;
  height: 28px;
  line-height: 28px;
  text-align: center;
  border-radius: 50%;
  font-weight: bold;
  font-size: 16px;
  margin: 0 auto;
}

.rank-1 {
  background: linear-gradient(135deg, #ffd700, #ffb700);
  color: #fff;
  box-shadow: 0 2px 6px rgba(255, 215, 0, 0.3);
}

.rank-2 {
  background: linear-gradient(135deg, #c0c0c0, #a0a0a0);
  color: #fff;
  box-shadow: 0 2px 6px rgba(192, 192, 192, 0.3);
}

.rank-3 {
  background: linear-gradient(135deg, #cd7f32, #a05a20);
  color: #fff;
  box-shadow: 0 2px 6px rgba(205, 127, 50, 0.3);
}

.food-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.food-header {
  display: flex;
  align-items: center;
  gap: 10px;
}

.food-name {
  font-weight: bold;
  font-size: 16px;
  color: #303133;
}

.food-desc {
  color: #909399;
  font-size: 14px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.rating-info {
  display: flex;
  align-items: center;
  gap: 8px;
}

.rating-count {
  color: #909399;
  font-size: 14px;
}

.food-list-container {
  height: 550px;
  overflow-y: auto;
}

.food-item {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;
  height: 360px;
  display: flex;
  flex-direction: column;
}

.food-item:hover {
  transform: translateY(-5px);
}

.food-img {
  width: 100%;
  height: 200px;
  border-radius: 4px;
  object-fit: cover;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
  font-size: 30px;
}

.food-content {
  padding: 15px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.title {
  font-size: 18px;
  font-weight: bold;
  margin: 0 0 10px;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.description {
  color: #666;
  margin: 8px 0;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
  overflow: hidden;
  flex: 1;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
  margin-top: auto;
}

.rating-dialog {
  display: flex;
  gap: 20px;
}

.detail-img {
  width: 200px;
  height: 200px;
  border-radius: 8px;
  object-fit: cover;
}

.rating-section {
  flex: 1;
}

.rating-section h3 {
  margin: 0 0 10px;
  font-size: 20px;
}

.rating-section .description {
  color: #666;
  margin-bottom: 20px;
}

.current-rating,
.user-rating {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 10px;
}

.current-rating .label,
.user-rating .label {
  width: 80px;
}

.current-rating .count {
  color: #909399;
  font-size: 14px;
}

.dialog-footer {
  margin-top: 20px;
  text-align: right;
}

@media screen and (max-width: 768px) {
  .search-bar {
    flex-direction: column;
  }
  
  .search-bar .search-input {
    width: 100%;
  }

  .rating-dialog {
    flex-direction: column;
  }
  
  .rating-dialog .detail-img {
    width: 100%;
    height: 200px;
  }
}
</style>