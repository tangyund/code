<template>
  <div class="food-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="美食名称">
          <el-input 
            v-model="searchForm.name" 
            placeholder="请输入美食名称" 
            clearable
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <div class="operation-bar">
      <el-button type="primary" @click="handleAdd">添加美食</el-button>
    </div>

    <!-- 美食列表表格 -->
    <el-table 
      :data="foodList" 
      v-loading="loading" 
      border
      stripe
    >
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="美食名称" />
      <el-table-column label="美食描述" min-width="300">
        <template #default="scope">
          <div style="white-space: pre-line;">{{ scope.row.description }}</div>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="推荐时间" width="180">
        <template #default="scope">
          {{ formatDateTime(scope.row.createTime) }}
        </template>
      </el-table-column>
      <el-table-column label="图片" width="100">
        <template #default="scope">
          <el-image 
            v-if="scope.row.pic"
            :src="getImageUrl(scope.row.pic)" 
            :preview-src-list="[getImageUrl(scope.row.pic)]"
            fit="cover"
            class="food-image"
          />
          <span v-else>暂无图片</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200">
        <template #default="scope">
          <el-button type="primary" link @click="handleEdit(scope.row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(scope.row)">删除</el-button>
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

    <!-- 添加/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加美食' : '编辑美食'"
      width="500px"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="美食名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入美食名称"/>
        </el-form-item>
        <el-form-item label="美食描述" prop="description">
          <el-input 
            type="textarea" 
            v-model="form.description" 
            :rows="3"
            placeholder="请输入美食描述"
          />
        </el-form-item>
        <el-form-item label="图片" prop="pic">
          <el-upload
            class="food-uploader"
            :action="`${apiUrl}/api/admin/foodRecommend/upload`"
            :headers="uploadHeaders"
            :show-file-list="false"
            :on-success="handleUploadSuccess"
            :on-error="handleUploadError"
            :before-upload="beforeUpload"
            :on-progress="handleProgress"
            accept=".jpg,.jpeg,.png,.webp"
          >
            <div class="upload-content">
              <img 
                v-if="form.pic" 
                :src="getImageUrl(form.pic)" 
                class="food-image" 
              />
              <div v-else class="upload-placeholder">
                <el-icon class="food-uploader-icon"><Plus /></el-icon>
                <div class="el-upload__text">点击上传图片</div>
              </div>
            </div>
            
            <!-- 上传进度条 -->
            <el-progress
              v-if="uploadProgress > 0 && uploadProgress < 100"
              :percentage="uploadProgress"
              :stroke-width="6"
              class="upload-progress"
            />
          </el-upload>
          <div class="upload-tip">
            支持 jpg/png/webp 格式图片，大小不超过 2MB
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import api from '@/api/api'

// 基础URL
const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8081'

// 数据定义
const loading = ref(false)
const foodList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const formRef = ref(null)
const uploadProgress = ref(0)

// 上传请求头
const uploadHeaders = ref({
  // 如果需要添加token等认证信息，可以在这里添加
})

// 搜索表单
const searchForm = ref({
  name: ''
})

// 表单数据
const form = ref({
  id: undefined,
  name: '',
  description: '',
  pic: ''
})

// 表单验证规则
const rules = {
  name: [{ required: true, message: '请输入美食名称', trigger: 'blur' }],
  description: [{ required: true, message: '请输入美食描述', trigger: 'blur' }]
}

// 获取图片URL
const getImageUrl = (pic) => {
  if (!pic) return ''
  if (pic.startsWith('http')) return pic
  return `${apiUrl}/api/admin/foodRecommend/image/${pic}`
}

// 格式化日期时间
const formatDateTime = (time) => {
  if (!time) return ''
  return new Date(time).toLocaleString()
}

// 修改获取列表的方法
const getList = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      name: searchForm.value.name || undefined
    }
    const res = await api.get('/api/admin/foodRecommend/page', params)
    if (res.code === 200) {
      foodList.value = res.data.records || []
      total.value = res.data.total || 0
    } else {
      ElMessage.error(res.msg || '获取数据失败')
    }
  } catch (error) {
    console.error('获取列表失败:', error)
    ElMessage.error(error.response?.data?.msg || '获取列表失败')
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
  searchForm.value = { name: '' }
  currentPage.value = 1
  getList()
}

// 添加
const handleAdd = () => {
  dialogType.value = 'add'
  form.value = {
    id: undefined,
    name: '',
    description: '',
    pic: ''
  }
  uploadProgress.value = 0
  dialogVisible.value = true
}

// 编辑
const handleEdit = (row) => {
  dialogType.value = 'edit'
  form.value = { ...row }
  uploadProgress.value = 0
  dialogVisible.value = true
}

// 修改删除方法
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除美食 "${row.name}" 吗？`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    const res = await api.del(`/api/admin/foodRecommend/delete/${row.id}`)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      getList()
    } else {
      ElMessage.error(res.msg || '删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error(error.response?.data?.msg || '删除失败')
    }
  }
}

// 修改 submitForm 方法
const submitForm = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        let res
        if (dialogType.value === 'add') {
          // 添加操作使用 post 请求
          res = await api.post('/api/admin/foodRecommend/add', form.value)
        } else {
          // 更新操作使用 put 请求
          res = await api.put('/api/admin/foodRecommend/update', form.value)
        }
        
        if (res.code === 200) {
          ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
          dialogVisible.value = false
          getList()
        } else {
          ElMessage.error(res.msg || '操作失败')
        }
      } catch (error) {
        console.error('操作失败:', error)
        ElMessage.error(error.response?.data?.msg || '操作失败')
      }
    }
  })
}

// 上传相关方法
const handleUploadSuccess = (response) => {
  uploadProgress.value = 100
  if (response.code === 200) {
    form.value.pic = response.data
    ElMessage.success('上传成功')
  } else {
    ElMessage.error(response.msg || '上传失败')
  }
}

const handleUploadError = () => {
  uploadProgress.value = 0
  ElMessage.error('上传失败')
}

const handleProgress = (event) => {
  uploadProgress.value = Math.round(event.percent)
}

const beforeUpload = (file) => {
  const isJPG = file.type === 'image/jpeg'
  const isPNG = file.type === 'image/png'
  const isWebP = file.type === 'image/webp'
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isJPG && !isPNG && !isWebP) {
    ElMessage.error('只能上传 JPG/PNG/WebP 格式的图片!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
    return false
  }
  uploadProgress.value = 0
  return true
}

// 分页方法
const handleSizeChange = (val) => {
  pageSize.value = val
  getList()
}

const handleCurrentChange = (val) => {
  currentPage.value = val
  getList()
}

// 初始化
onMounted(() => {
  getList()
})
</script>

<style scoped>
.food-list {
  padding: 20px;
}

.search-form {
  margin-bottom: 20px;
}

.operation-bar {
  margin-bottom: 20px;
}

.food-uploader {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  width: 178px;
  height: 178px;
}

.food-uploader:hover {
  border-color: #409EFF;
}

.upload-content {
  width: 100%;
  height: 100%;
  position: relative;
  display: flex;
  justify-content: center;
  align-items: center;
}

.upload-placeholder {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.food-image {
  width: 178px;
  height: 178px;
  object-fit: cover;
}

.food-uploader-icon {
  font-size: 28px;
  color: #8c939d;
}

.el-upload__text {
  color: #909399;
  font-size: 14px;
  margin-top: 8px;
}

.upload-progress {
  position: absolute;
  bottom: 10px;
  left: 10px;
  right: 10px;
}

.upload-tip {
  color: #909399;
  font-size: 12px;
  margin-top: 8px;
}

.el-table .food-image {
  width: 50px;
  height: 50px;
  border-radius: 4px;
  cursor: pointer;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 添加一些响应式样式 */
@media screen and (max-width: 768px) {
  .food-list {
    padding: 10px;
  }
  
  .food-uploader {
    width: 100%;
    max-width: 178px;
    margin: 0 auto;
  }
  
  .el-form-item {
    margin-bottom: 15px;
  }
}

/* 优化上传区域的交互效果 */
.food-uploader:hover .upload-placeholder {
  opacity: 0.8;
}

.food-uploader:active {
  border-color: #3a8ee6;
}

/* 添加图片加载动画 */
.food-image {
  transition: all 0.3s ease;
}

.food-image:hover {
  transform: scale(1.05);
}

/* 优化进度条样式 */
.upload-progress {
  background-color: rgba(255, 255, 255, 0.8);
  padding: 4px;
  border-radius: 4px;
}
</style>