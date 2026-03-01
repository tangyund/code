<template>
  <div class="respond-consultation-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input
        v-model="searchText"
        placeholder="搜索咨询内容"
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

    <!-- 咨询列表 -->
    <div class="respond-consultation-list" v-loading="loading">
      <template v-if="consultationList && consultationList.length > 0">
        <el-row :gutter="20">
          <el-col
            v-for="(item, index) in consultationList"
            :key="index"
            :span="12"
          >
            <el-card
              v-if="item"
              class="respond-consultation-item"
              shadow="hover"
            >
              <div class="respond-consultation-content">
                <p>咨询内容: {{ item.content || '暂无内容' }}</p>
                <p v-if="item.response">回复内容: {{ item.response }}</p>
              </div>
              <div class="operation-buttons">
                <el-button type="primary" @click="handleReply(item)">回复</el-button>
                <el-button type="primary" @click="handleEditReply(item)">修改回复</el-button>
                <el-button type="danger" @click="handleDelete(item)">删除</el-button>
              </div>
            </el-card>
          </el-col>
        </el-row>
      </template>

      <el-empty v-else description="暂无咨询数据" />
    </div>

    <!-- 回复/修改对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType ==='reply'? '回复咨询' : '修改回复'"
      width="500px"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="回复内容" prop="response">
          <el-input type="textarea" v-model="form.response" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm" :loading="isSubmitting">
          {{ dialogType ==='reply'? '回复' : '修改' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Search } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { get, post, put, del } from '@/api/api'
import { useRouter } from 'vue-router'

const router = useRouter()
const loading = ref(false)
const consultationList = ref([])
const searchText = ref('')
const dialogVisible = ref(false)
const dialogType = ref('reply')
const form = ref({
  response: ''
})
const rules = {
  response: [{ required: true, message: '请输入回复内容', trigger: 'blur' }]
}
const isSubmitting = ref(false)
const formRef = ref(null)

// 获取咨询列表
const getList = async () => {
  loading.value = true
  try {
    const res = await get('/api/admin/touristConsultation/list', {
      likeContent: `%${searchText.value}%` // 修改为支持模糊查询的参数
    })
    if (res && res.data) {
      consultationList.value = Array.isArray(res.data)? res.data : (res.data.records || [])
    }
  } catch (error) {
    console.error('获取数据失败:', error)
    ElMessage.error('获取咨询列表失败')
    consultationList.value = []
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

// 回复咨询
const handleReply = (item) => {
  dialogType.value ='reply'
  form.value = {...item }
  dialogVisible.value = true
}

// 修改回复
const handleEditReply = (item) => {
  dialogType.value = 'edit'
  form.value = {...item }
  dialogVisible.value = true
}

// 提交表单
const submitForm = async () => {
  if (isSubmitting.value) return;
  isSubmitting.value = true;
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (dialogType.value ==='reply') {
          await post('/api/admin/touristConsultation/reply', form.value)
          ElMessage.success('回复成功')
        } else {
          await put('/api/admin/touristConsultation/updateReply', form.value)
          ElMessage.success('修改回复成功')
        }
        dialogVisible.value = false
        getList()
      } catch (error) {
        ElMessage.error('操作失败：' + error.message)
      } finally {
        isSubmitting.value = false;
      }
    }
  })
}

// 删除咨询
const handleDelete = async (item) => {
  if (isSubmitting.value) return;
  isSubmitting.value = true;
  try {
    await ElMessageBox.confirm(
      `确定要删除该咨询吗？`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    await del(`/api/admin/touristConsultation/delete/${item.id}`)
    ElMessage.success('删除成功')
    getList()
  } catch (error) {
    if (error!== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error('删除失败：' + error.message)
    }
  } finally {
    isSubmitting.value = false;
  }
}

// 初始化
getList()
</script>

<style scoped>
.respond-consultation-container {
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

.respond-consultation-list {
  max-height: 80vh; /* 设置最大高度 */
  overflow-y: auto; /* 添加垂直滚动条 */
  padding-right: 10px; /* 避免滚动条遮挡内容 */
}

.respond-consultation-item {
  margin-bottom: 20px;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-5px);
  }
}

.respond-consultation-content {
  padding: 15px 0;

 p {
    margin: 0 0 10px;
  }
}

.operation-buttons {
  margin-top: 10px;
}

.el-dialog {
  /* 可以在这里添加一些自定义样式 */
}

.el-form {
  /* 可以在这里添加一些自定义样式 */
}
</style>