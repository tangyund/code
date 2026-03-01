<template>
  <div class="welcome-container">
    <el-row :gutter="20" class="welcome-header">
      <el-col :span="24">
        <el-card class="welcome-card">
          <div class="welcome-content">
            <h1>欢迎使用权限管理系统</h1>
            <p>一个功能完善、安全可靠的后台权限管理平台</p>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="stats-row">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-item">
            <el-icon class="stat-icon" color="#409EFF"><User /></el-icon>
            <div class="stat-info">
              <div class="stat-number">{{ stats.users }}</div>
              <div class="stat-label">用户总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-item">
            <el-icon class="stat-icon" color="#67C23A"><UserFilled /></el-icon>
            <div class="stat-info">
              <div class="stat-number">{{ stats.roles }}</div>
              <div class="stat-label">角色数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-item">
            <el-icon class="stat-icon" color="#E6A23C"><Lock /></el-icon>
            <div class="stat-info">
              <div class="stat-number">{{ stats.permissions }}</div>
              <div class="stat-label">权限数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-item">
            <el-icon class="stat-icon" color="#F56C6C"><Document /></el-icon>
            <div class="stat-info">
              <div class="stat-number">{{ stats.logs }}</div>
              <div class="stat-label">今日操作</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" class="content-row">
      <el-col :span="16">
        <el-card class="chart-card">
          <template #header>
            <div class="card-header">
              <span>系统概览</span>
            </div>
          </template>
          <div class="chart-container">
            <div class="chart-placeholder">
              <el-icon size="50" color="#C0C4CC"><PieChart /></el-icon>
              <p>系统数据统计图表</p>
            </div>
          </div>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card class="info-card">
          <template #header>
            <div class="card-header">
              <span>系统信息</span>
            </div>
          </template>
          <div class="info-content">
            <ul>
              <li><span class="info-label">系统名称：</span><span>权限管理系统</span></li>
              <li><span class="info-label">版本号：</span><span>v1.0.0</span></li>
              <li><span class="info-label">开发者：</span><span>技术团队</span></li>
              <li><span class="info-label">更新时间：</span><span>{{ currentTime }}</span></li>
              <li><span class="info-label">运行状态：</span><el-tag type="success">正常运行</el-tag></li>
            </ul>
          </div>
        </el-card>
        
        <el-card class="recent-card">
          <template #header>
            <div class="card-header">
              <span>最近操作</span>
            </div>
          </template>
          <div class="recent-content">
            <el-timeline>
              <el-timeline-item
                v-for="(activity, index) in recentActivities"
                :key="index"
                :timestamp="activity.timestamp"
                placement="top"
              >
                <el-card>
                  <h4>{{ activity.title }}</h4>
                  <p>{{ activity.content }}</p>
                </el-card>
              </el-timeline-item>
            </el-timeline>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { User, UserFilled, Lock, Document, PieChart } from '@element-plus/icons-vue'

export default {
  name: "Welcome",
  components: {
    User,
    UserFilled,
    Lock,
    Document,
    PieChart
  },
  setup() {
    const currentTime = ref(new Date().toLocaleString())
    
    const stats = ref({
      users: 128,
      roles: 8,
      permissions: 24,
      logs: 42
    })
    
    const recentActivities = ref([
      {
        timestamp: '2023-05-15 14:30',
        title: '新增用户',
        content: '管理员创建了新用户 "张三"'
      },
      {
        timestamp: '2023-05-15 10:15',
        title: '角色更新',
        content: '更新了"管理员"角色的权限配置'
      },
      {
        timestamp: '2023-05-14 16:45',
        title: '权限调整',
        content: '为"访客"角色添加了查看权限'
      },
      {
        timestamp: '2023-05-14 09:20',
        title: '系统维护',
        content: '完成了系统安全更新'
      }
    ])
    
    onMounted(() => {
      // 模拟定时更新时间
      setInterval(() => {
        currentTime.value = new Date().toLocaleString()
      }, 1000)
    })
    
    return {
      stats,
      recentActivities,
      currentTime
    }
  }
}
</script>

<style scoped>
.welcome-container {
  padding: 20px;
}

.welcome-header {
  margin-bottom: 20px;
}

.welcome-card {
  text-align: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
}

.welcome-content h1 {
  font-size: 28px;
  margin-bottom: 10px;
}

.welcome-content p {
  font-size: 16px;
  opacity: 0.9;
}

.stats-row {
  margin-bottom: 20px;
}

.stat-card {
  border-radius: 8px;
  transition: transform 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.stat-item {
  display: flex;
  align-items: center;
}

.stat-icon {
  font-size: 40px;
  margin-right: 15px;
}

.stat-info {
  flex: 1;
}

.stat-number {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 5px;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

.content-row {
  margin-bottom: 20px;
}

.chart-card, .info-card, .recent-card {
  margin-bottom: 20px;
}

.card-header {
  font-weight: bold;
  font-size: 16px;
}

.chart-container {
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.chart-placeholder {
  text-align: center;
  color: #C0C4CC;
}

.info-content ul {
  padding: 0;
  margin: 0;
  list-style: none;
}

.info-content li {
  padding: 8px 0;
  border-bottom: 1px solid #EBEEF5;
  display: flex;
  justify-content: space-between;
}

.info-content li:last-child {
  border-bottom: none;
}

.info-label {
  font-weight: bold;
  color: #606266;
}

.recent-content {
  max-height: 300px;
  overflow-y: auto;
}
</style>