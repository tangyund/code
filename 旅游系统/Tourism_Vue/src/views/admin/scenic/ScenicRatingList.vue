<template>
  <div class="rating-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="景点名称">
          <el-input v-model="searchForm.spotName" placeholder="请输入景点名称" />
        </el-form-item>
        <el-form-item label="用户名">
          <el-input v-model="searchForm.userName" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 评价列表 -->
    <el-table 
      :data="ratingList" 
      v-loading="loading" 
      border 
      stripe
      style="width: 100%"
    >
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="spotName" label="景点名称" />
      <el-table-column prop="userName" label="用户名" />
      <el-table-column label="评分" width="200">
        <template #default="scope">
          <el-rate
            v-model="scope.row.rating"
            disabled
            show-score
            text-color="#ff9900"
          />
        </template>
      </el-table-column>
      <el-table-column prop="review" label="评价内容" show-overflow-tooltip />
      <el-table-column prop="ratingTime" label="评价时间" width="180" />
      <el-table-column label="操作" width="150" fixed="right">
        <template #default="scope">
          <el-button type="primary" link @click="handleView(scope.row)">
            查看
          </el-button>
          <el-button type="danger" link @click="handleDelete(scope.row)">
            删除
          </el-button>
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
      />
    </div>

    <!-- 查看评价对话框 -->
    <el-dialog v-model="dialogVisible" title="评价详情" width="500px">
      <div class="rating-detail">
        <p><strong>景点名称：</strong>{{ currentRating.scenicName }}</p>
        <p><strong>用户名：</strong>{{ currentRating.username }}</p>
        <p>
          <strong>评分：</strong>
          <el-rate
            v-model="currentRating.rating"
            disabled
            show-score
            text-color="#ff9900"
          />
        </p>
        <p><strong>评价内容：</strong></p>
        <div class="comment">{{ currentRating.comment }}</div>
        <p><strong>评价时间：</strong>{{ currentRating.createTime }}</p>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import api from '@/api/api'

// 数据定义
const loading = ref(false)
const ratingList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const currentRating = ref({})
const searchForm = ref({
  spotName: '',
  userName: ''
})

// 获取评价列表
const getRatingList = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      userName: searchForm.value.userName || ''
    }
    
    // 添加调试日志
    console.log('发送请求参数:', params)
    
    // 设置超时时间
    const res = await api.get('/api/admin/scenicRating/list', params, {
      timeout: 5000 // 5秒超时
    })
    
    console.log('接收到响应:', res)

    // 检查响应结构
    if (res && res.data) {
      if (Array.isArray(res.data)) {
        // 如果返回的是数组
        ratingList.value = res.data
        total.value = res.data.length
      } else if (res.data.records) {
        // 如果返回的是分页对象
        ratingList.value = res.data.records
        total.value = res.data.total
      } else {
        ratingList.value = []
        total.value = 0
      }
    } else {
      ratingList.value = []
      total.value = 0
    }
  } catch (error) {
    console.error('获取评价列表失败:', error)
    ElMessage.error(error.message || '获取评价列表失败')
    ratingList.value = []
    total.value = 0
  } finally {
    // 确保loading状态被重置
    loading.value = false
  }
}

// 确保组件卸载时取消加载状态
onUnmounted(() => {
  loading.value = false
})

// 添加错误处理的重试机制
const handleSearch = async () => {
  currentPage.value = 1
  try {
    await getRatingList()
  } catch (error) {
    console.error('搜索失败:', error)
    loading.value = false
  }
}

// 重置搜索
const resetSearch = () => {
  searchForm.value = {
    spotName: '',
    userName: ''
  }
  currentPage.value = 1
  getRatingList()
}

// 查看评价详情
const handleView = (row) => {
  currentRating.value = { ...row }
  dialogVisible.value = true
}

// 删除评价
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该评价吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    // 修改删除请求路径
    const res = await api.del(`/api/admin/scenicRating/delete/${row.id}`)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      getRatingList()
    } else {
      ElMessage.error(res.msg || '删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 分页大小改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getRatingList()
}

// 页码改变
const handleCurrentChange = (val) => {
  currentPage.value = val
  getRatingList()
}

// 批量删除
const handleBatchDelete = async (rows) => {
  try {
    await ElMessageBox.confirm('确定要删除选中的评价吗��', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })
    const ids = rows.map(row => row.id)
    const res = await api.post('/api/admin/scenicRating/batchDelete', ids)
    if (res.code === 200) {
      ElMessage.success('批量删除成功')
      getRatingList()
    } else {
      ElMessage.error(res.msg || '批量删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
      ElMessage.error('批量删除失败')
    }
  }
}

// 初始化时获取数据
onMounted(() => {
  getRatingList()
})
</script>

<style scoped>
.rating-list {
  padding: 20px;
}

.search-form {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.rating-detail {
  padding: 10px;
}

.rating-detail p {
  margin: 10px 0;
  line-height: 1.5;
}

.rating-detail .comment {
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
  margin: 10px 0;
  white-space: pre-wrap;
  line-height: 1.6;
}

.el-rate {
  display: inline-block;
  vertical-align: text-bottom;
}
</style>
