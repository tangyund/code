<template>
  <div class="activity-booking-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="用户名">
          <el-input v-model="searchForm.userName" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item label="活动名称">
          <el-input v-model="searchForm.activityName" placeholder="请输入活动名称" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <div class="operation-bar">
      <el-button type="primary" @click="handleAdd">添加预订</el-button>
      <el-button
        type="danger"
        @click="handleBatchDelete"
        :disabled="selectedBookingIds.length === 0"
      >批量删除</el-button>
    </div>

    <!-- 预订列表表格 -->
    <el-table
      :data="bookingList"
      v-loading="loading"
      border
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="userName" label="用户名" />
      <el-table-column prop="activityName" label="活动名称" />
      <el-table-column prop="bookingTime" label="预订时间">
        <template #default="scope">
          {{ formatDateTime(scope.row.bookingTime) }}
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" />
       <el-table-column label="图片" width="100">
        <template #default="scope">
          <el-image 
            v-if="scope.row.pic"
            :src="getImageUrl(scope.row.pic)" 
            :preview-src-list="[getImageUrl(scope.row.pic)]"
            fit="cover"
            class="booking-image"
          />
          <span v-else>暂无图片</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="220">
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
      :title="dialogType === 'add' ? '添加预订' : '编辑预订'"
      width="500px"
    >
      <el-form
        ref="bookingFormRef"
        :model="bookingForm"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="用户名" prop="userName">
          <el-input v-model="bookingForm.userName" />
        </el-form-item>
        <el-form-item label="活动名称" prop="activityName">
          <el-input v-model="bookingForm.activityName" />
        </el-form-item>
        <el-form-item label="预订时间" prop="bookingTime">
          <el-date-picker
            v-model="bookingForm.bookingTime"
            type="datetime"
            placeholder="请选择预订时间"
          />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="bookingForm.status" placeholder="请选择状态">
            <el-option label="已预订" value="已预订" />
            <el-option label="已取消" value="已取消" />
            <el-option label="已完成" value="已完成" />
          </el-select>
        </el-form-item>
         <el-form-item label="图片" prop="pic">
          <el-upload
            class="booking-uploader"
            :action="`${apiUrl}/api/admin/activityBooking/upload`"
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
                v-if="bookingForm.pic" 
                :src="getImageUrl(bookingForm.pic)" 
                class="booking-image" 
              />
              <div v-else class="upload-placeholder">
                <el-icon class="booking-uploader-icon"><Plus /></el-icon>
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
import moment from 'moment'

// 添加环境变量引用
const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8081'

// 数据定义
const loading = ref(false)
const bookingList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const bookingFormRef = ref(null)
const selectedBookingIds = ref([])

// 搜索表单
const searchForm = ref({
  userName: '',
  activityName: '',
})

// 预订表单
const bookingForm = ref({
  userName: '',
  activityName: '',
  bookingTime: '',
  status: '已预订',
  pic: ''
})

// 表单验证规则
const rules = {
  userName: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  activityName: [{ required: true, message: '请输入活动名称', trigger: 'blur' }],
  bookingTime: [{ required: true, message: '请选择预订时间', trigger: 'change' }],
  status: [{ required: true, message: '请选择状态', trigger: 'change' }],
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
    bookingForm.value.pic = response.data
    ElMessage.success('图片上传成功')
    uploadProgress.value = 100
    
    // 1秒后重置进度条
    setTimeout(() => {
      uploadProgress.value = 0
    }, 1000)
  } else {
    ElMessage.error(response.msg || '上传失败')
    bookingForm.value.pic = ''
  }
}

// 处理上传失败
const handleUploadError = (error) => {
  console.error('上传失败:', error)
  ElMessage.error('图片上传失败，请重试')
  uploadProgress.value = 0
  bookingForm.value.pic = ''
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


// 获取预订列表
const getBookingList = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    }
    const res = await api.get('/api/admin/activityBooking/list', params)
    bookingList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('获取预订列表失败:', error)
    ElMessage.error('获取预订列表失败')
  } finally {
    loading.value = false
  }
}

// 获取图片URL
const getImageUrl = (pic) => {
  if (!pic) return ''
  if (pic.startsWith('http')) return pic
  return `${apiUrl}/api/admin/activityBooking/image/${pic}`
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  getBookingList()
}

// 重置搜索
const resetSearch = () => {
  searchForm.value = {
    userName: '',
    activityName: '',
  }
  handleSearch()
}

// 添加预订
const handleAdd = () => {
  dialogType.value = 'add'
  bookingForm.value = {
    userName: '',
    activityName: '',
    bookingTime: '',
    status: '已预订',
    pic: ''
  }
  dialogVisible.value = true
}

// 编辑预订
const handleEdit = (row) => {
  dialogType.value = 'edit'
  bookingForm.value = { ...row }
  dialogVisible.value = true
}

// 提交表单
const submitForm = async () => {
  if (!bookingFormRef.value) return

  await bookingFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const payload = { ...bookingForm.value }
        if (dialogType.value === 'add') {
          await api.post('/api/admin/activityBooking/add', payload)
          ElMessage.success('添加成功')
        } else {
          await api.put('/api/admin/activityBooking/update', payload)
          ElMessage.success('更新成功')
        }
        dialogVisible.value = false
        getBookingList()
      } catch (error) {
        console.error('操作失败:', error)
        ElMessage.error('操作失败')
      }
    }
  })
}

// 删除预订
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确认删除该预订吗？', '提示', {
      type: 'warning',
    })
    await api.del(`/api/admin/activityBooking/delete/${row.id}`)
    ElMessage.success('删除成功')
    getBookingList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// 批量删除预订
const handleBatchDelete = async () => {
  if (selectedBookingIds.value.length === 0) {
    ElMessage.warning('请选择要删除的预订')
    return
  }
  try {
    await ElMessageBox.confirm('确认批量删除选中的预订吗？', '提示', {
      type: 'warning',
    })
    await api.post('/api/admin/activityBooking/batch', {
      data: selectedBookingIds.value,
    })
    ElMessage.success('批量删除成功')
    selectedBookingIds.value = []
    getBookingList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('批量删除失败')
    }
  }
}

// 分页大小改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getBookingList()
}

// 页码改变
const handleCurrentChange = (val) => {
  currentPage.value = val
  getBookingList()
}

// 表格选择改变
const handleSelectionChange = (val) => {
  selectedBookingIds.value = val.map((item) => item.id)
}

// 格式化日期
const formatDateTime = (dateTimeString) => {
  if (!dateTimeString) return ''
  return moment(dateTimeString).format('YYYY-MM-DD HH:mm:ss')
}

// 初始化
onMounted(() => {
  getBookingList()
})
</script>

<style scoped>
.activity-booking-list {
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

.booking-uploader {
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
  
  .booking-uploader-icon {
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

.booking-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 表格中的图片样式 */
.el-table .booking-image {
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
