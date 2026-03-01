<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Clock, Timer, Location, Check, InfoFilled } from '@element-plus/icons-vue'
import { get } from '@/api/api'
import { useRouter } from 'vue-router'

const router = useRouter()
const loading = ref(false)
const routeList = ref([])
const userInfo = ref({})

// 初始化用户信息
const initUserInfo = () => {
  try {
    userInfo.value = JSON.parse(localStorage.getItem('userInfo') || '{}')
  } catch (e) {
    userInfo.value = {}
  }
}

// 获取路线列表
const getRouteList = async () => {
  loading.value = true
  try {
    const res = await get('/api/admin/route/list')
    console.log('路线数据:', res)
    if (res?.data?.records) {
      routeList.value = res.data.records
    } else {
      routeList.value = []
      ElMessage.error('获取路线列表失败')
    }
  } catch (error) {
    console.error('获取路线列表失败:', error)
    routeList.value = []
    ElMessage.error('获取路线列表失败')
  } finally {
    loading.value = false
  }
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return '暂无'
  return new Date(dateStr).toLocaleString()
}

// 格式化景点列表
const formatSpotNames = (spots) => {
  if (!spots || !Array.isArray(spots) || spots.length === 0) return '暂无景点'
  return spots.map(spot => spot?.scenicSpot?.name || '未命名景点').join(' → ')
}

// 选择路线
const handleSelect = async (route) => {
  if (!userInfo.value.id) {
    ElMessageBox.confirm(
      '请先登录后再选择路线',
      '提示',
      {
        confirmButtonText: '去登录',
        cancelButtonText: '取消',
        type: 'warning'
      }
    ).then(() => {
      router.push('/login')
    }).catch(() => {})
    return
  }

  try {
    await ElMessageBox.confirm(
      `确定选择路线"${route.routeName}"吗？`,
      '选择路线',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }
    )

    loading.value = true
    // 修改请求方式，直接传递参数而不是使用params对象
    const res = await get(`/api/user/route/select?userId=${userInfo.value.id}&routeId=${route.id}`)
    
    if (res.code === 200) {
      ElMessage.success('路线选择成功')
      await ElMessageBox.confirm(
        '路线选择成功，是否查看路线详情？',
        '提示',
        {
          cancelButtonText: '继续浏览',
        }
      ).then(() => {
    
      }).catch(() => {})
    } else {
      ElMessage.error(res.msg || '选择路线失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('选择路线失败:', error)
      ElMessage.error('选择路线失败')
    }
  } finally {
    loading.value = false
  }
}



onMounted(() => {
  initUserInfo()
  getRouteList()
})
</script>

<template>
  <div class="app-container" style="width: 100%; overflow: auto;">
    <div class="route-container">
      <div class="route-header">
        <h2>推荐路线</h2>
        <p>精心规划的景区游览路线，让您的旅程更加便捷</p>
      </div>

      <div class="route-list" v-loading="loading">
        <el-empty v-if="!routeList || routeList.length === 0" description="暂无路线数据" />
        
        <el-row v-else :gutter="20">
          <el-col 
            v-for="route in routeList" 
            :key="route?.id || index"
            :span="8"
          >
            <el-card 
              class="route-item" 
              shadow="hover"
            >
              <div class="route-content">
                <div class="route-header">
                  <h3 class="route-name">{{ route?.routeName || '未命名路线' }}</h3>
                  <el-tag size="small" type="info">路线 {{ route?.id }}</el-tag>
                </div>
                
                <div class="route-info">
                  <div class="info-item">
                    <el-icon><Clock /></el-icon>
                    <span>创建时间: {{ formatDate(route?.createTime) }}</span>
                  </div>
                  <div class="info-item">
                    <el-icon><Timer /></el-icon>
                    <span>总时长: {{ route?.totalDuration || 0 }}小时</span>
                  </div>
                  <div class="info-item">
                    <el-icon><Location /></el-icon>
                    <span>景点数: {{ route?.spots?.length || 0 }}</span>
                  </div>
                </div>

                <div class="spots-list">
                  <h4>包含景点:</h4>
                  <div class="spots-flow">
                    {{ formatSpotNames(route?.spots) }}
                  </div>
                </div>

                <p class="description">{{ route?.description || '暂无描述' }}</p>

                <div class="route-actions">
                  <el-tooltip
                    :content="!userInfo.id? '请先登录' : '选择此路线作为您的游览路线'"
                    placement="top"
                  >
                    <el-button 
                      type="primary" 
                      size="small" 
                      @click="handleSelect(route)"
                      :loading="loading"
                    >
                      <el-icon><Check /></el-icon>
                      选择路线
                    </el-button>
                  </el-tooltip>
                  
                </div>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </div>
  </div>
</template>

<style scoped>
.app-container {
  height: 90vh; /* 视口高度 */
}
	
.route-container {
  padding: 20px;
}

.route-header {
  margin-bottom: 30px;
  text-align: center;
}

.route-header h2 {
  font-size: 24px;
  color: #303133;
  margin-bottom: 10px;
}

.route-header p {
  color: #909399;
  font-size: 14px;
}

.route-list {
  margin-top: 20px;
}

.route-item {
  margin-bottom: 20px;
  height: 100%;
}

.route-content {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.route-content .route-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  text-align: left;
}

.route-name {
  margin: 0;
  font-size: 18px;
  color: #303133;
}

.route-info {
  margin: 15px 0;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  color: #606266;
  font-size: 14px;
}

.spots-list {
  padding: 10px;
  background: #f5f7fa;
  border-radius: 4px;
}

.spots-list h4 {
  margin: 0 0 8px;
  font-size: 14px;
  color: #303133;
}

.spots-flow {
  color: #409EFF;
  font-size: 13px;
  line-height: 1.5;
  word-break: break-all;
}

.description {
  margin: 15px 0;
  color: #666;
  font-size: 14px;
  line-height: 1.5;
}

.route-actions {
  margin-top: auto;
  padding-top: 15px;
  display: flex;
  gap: 10px;
  justify-content: flex-end;
}

.route-actions .el-button {
  display: flex;
  align-items: center;
  gap: 4px;
}
</style>