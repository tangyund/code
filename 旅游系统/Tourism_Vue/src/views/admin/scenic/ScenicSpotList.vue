<template>
  <div class="scenic-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="景点名称">
          <el-input v-model="searchForm.name" placeholder="请输入景点名称" />
        </el-form-item>
        <el-form-item label="地址">
          <el-input v-model="searchForm.location" placeholder="请输入地址" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <div class="operation-bar">
      <el-button type="primary" @click="handleAdd">添加景点</el-button>
    </div>

    <!-- 景点列表表格 -->
    <el-table :data="scenicList" v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="景点名称" />
      <el-table-column prop="location" label="地址" />
      <el-table-column prop="openingHours" label="开放时间" />
      <el-table-column prop="ticketPrice" label="票价">
        <template #default="scope">
          ¥{{ scope.row.ticketPrice }}
        </template>
      </el-table-column>
      <el-table-column prop="contactInfo" label="联系方式" />
      <el-table-column label="图片" width="100">
        <template #default="scope">
          <el-image 
            v-if="scope.row.pic"
            :src="getImageUrl(scope.row.pic)" 
            :preview-src-list="[getImageUrl(scope.row.pic)]"
            fit="cover"
            class="scenic-image"
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
      :title="dialogType === 'add' ? '添加景点' : '编辑景点'"
      width="500px"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="景点名称" prop="name">
          <el-input v-model="form.name" />
        </el-form-item>
        <el-form-item label="地址" prop="location">
          <el-input v-model="form.location" />
        </el-form-item>
        <el-form-item label="开放时间" prop="openingHours">
          <el-input v-model="form.openingHours" />
        </el-form-item>
        <el-form-item label="票价" prop="ticketPrice">
          <el-input-number v-model="form.ticketPrice" :min="0" :precision="2" />
        </el-form-item>
        <el-form-item label="联系方式" prop="contactInfo">
          <el-input v-model="form.contactInfo" />
        </el-form-item>
        <el-form-item label="景点描述" prop="description">
          <el-input type="textarea" v-model="form.description" :rows="3" />
        </el-form-item>
        <el-form-item label="图片" prop="pic">
          <el-upload
            class="scenic-uploader"
            :action="`${apiUrl}/api/admin/scenicSpot/upload`"
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
                class="scenic-image" 
              />
              <div v-else class="upload-placeholder">
                <el-icon class="scenic-uploader-icon"><Plus /></el-icon>
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
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import api from '@/api/api'

// 添加环境变量引用
const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8081'

// 数据定义
const loading = ref(false)
const scenicList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const formRef = ref(null)

// 搜索表单
const searchForm = ref({
  name: '',
  location: ''
})

// 表单数据
const form = ref({
  name: '',
  location: '',
  openingHours: '',
  ticketPrice: 0,
  contactInfo: '',
  description: '',
  pic: ''
})

// 表单验证规则
const rules = {
  name: [{ required: true, message: '请输入景点名称', trigger: 'blur' }],
  location: [{ required: true, message: '请输入地址', trigger: 'blur' }],
  openingHours: [{ required: true, message: '请输入开放时间', trigger: 'blur' }],
  ticketPrice: [{ required: true, message: '请输入票价', trigger: 'blur' }],
  contactInfo: [{ required: true, message: '请输入联系方式', trigger: 'blur' }]
}

// 上传相关
const uploadProgress = ref(0)
const uploadHeaders = computed(() => {
  return {
    // 如果需要认证，在这里添加token
    // 'Authorization': `Bearer ${store.state.token}`
  }
})

// 处理上传进度
const handleProgress = (event) => {
  uploadProgress.value = Math.round(event.percent)
}

// 处理上传成功
const handleUploadSuccess = (response) => {
  if (response.code === 200) {
    form.value.pic = response.data
    ElMessage.success('图片上传成功')
    uploadProgress.value = 100
    
    // 1秒后重置进度条
    setTimeout(() => {
      uploadProgress.value = 0
    }, 1000)
  } else {
    ElMessage.error(response.msg || '上传失败')
    form.value.pic = ''
  }
}

// 处理上传失败
const handleUploadError = (error) => {
  console.error('上传失败:', error)
  ElMessage.error('图片上传失败，请重试')
  uploadProgress.value = 0
  form.value.pic = ''
}

// 上传前校验
const beforeUpload = (file) => {
  // 重置进度条
  uploadProgress.value = 0
  
  // 检查文件类型
  const allowedTypes = ['image/jpeg', 'image/png', 'image/webp']
  const isValidType = allowedTypes.includes(file.type)
  if (!isValidType) {
    ElMessage.error('只能上传 JPG/PNG/WEBP 格式的图片!')
    return false
  }
  
  // 检查文件大小
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
    return false
  }
  
  return true
}

// 获取图片URL
const getImageUrl = (pic) => {
  if (!pic) return ''
  if (pic.startsWith('http')) return pic
  return `${apiUrl}/api/admin/scenicSpot/image/${pic}`
}

// 获取列表
const getList = async () => {
  loading.value = true
  try {
    // 修改请求参数格式
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      name: searchForm.value.name,
      location: searchForm.value.location
    }
    
    console.log('请求参数:', params) // 调试用
    
    const res = await api.get('/api/admin/scenicSpot/list', params)
    console.log('响应数据:', res) // 调试用
    
    if (res && res.data) {
      scenicList.value = res.data.records || []
      total.value = res.data.total || 0
    } else {
      ElMessage.error('获取数据失败')
    }
  } catch (error) {
    console.error('获取列表失败:', error)
    ElMessage.error(error.message || '获取列表失败')
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
  searchForm.value = {
    name: '',
    location: ''
  }
  currentPage.value = 1
  getList()
}

// 添加景点
const handleAdd = () => {
  dialogType.value = 'add'
  form.value = {
    name: '',
    location: '',
    openingHours: '',
    ticketPrice: 0,
    contactInfo: '',
    description: '',
    pic: ''
  }
  dialogVisible.value = true
}

// 编辑景点
const handleEdit = (row) => {
  dialogType.value = 'edit'
  form.value = { ...row }
  dialogVisible.value = true
}

// 提交表单
const submitForm = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (dialogType.value === 'add') {
          await api.post('/api/admin/scenicSpot/add', form.value)
          ElMessage.success('添加成功')
        } else {
          await api.put('/api/admin/scenicSpot/update', form.value)
          ElMessage.success('更新成功')
        }
        dialogVisible.value = false
        getList()
      } catch (error) {
        ElMessage.error('操作失败')
      }
    }
  })
}

// 删除景点
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除景点 "${row.name}" 吗？`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    // 修改这里：使用 api.del 而不是 api.delete
    const res = await api.del(`/api/admin/scenicSpot/delete/${row.id}`)
    
    if (res.code === 200) {
      ElMessage.success('删除成功')
      await getList() // 重新加载列表
    } else {
      ElMessage.error(res.msg || '删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error('删除失败：' + (error.message || '未知错误'))
    }
  }
}

// 分页大小改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getList()
}

// 页码改变
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
.scenic-list {
  padding: 20px;
}

.search-form {
  margin-bottom: 20px;
}

.operation-bar {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.scenic-uploader {
  display: block;
  
  .upload-content {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    width: 178px;
    height: 178px;
    display: flex;
    justify-content: center;
    align-items: center;
    
    &:hover {
      border-color: #409EFF;
    }
  }
}

.upload-placeholder {
  text-align: center;
  
  .scenic-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    margin-bottom: 8px;
  }
  
  .el-upload__text {
    color: #8c939d;
    font-size: 14px;
  }
}

.upload-progress {
  position: absolute;
  bottom: 10px;
  left: 10px;
  right: 10px;
  z-index: 10;
  
  :deep(.el-progress-bar__outer) {
    background-color: rgba(255, 255, 255, 0.7);
  }
}

.upload-tip {
  color: #909399;
  font-size: 12px;
  margin-top: 8px;
  line-height: 1.4;
}

.scenic-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 表格中的图片样式 */
.el-table .scenic-image {
  width: 50px;
  height: 50px;
  border-radius: 4px;
  cursor: pointer;
  transition: transform 0.3s;
  
  &:hover {
    transform: scale(1.1);
  }
}
</style>
