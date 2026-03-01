<template>
  <div class="news-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="新闻标题">
          <el-input v-model="searchForm.title" placeholder="请输入新闻标题" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <div class="operation-bar">
      <el-button type="primary" @click="handleAdd">添加新闻</el-button>
    </div>

    <!-- 新闻列表表格 -->
    <el-table :data="newsList" v-loading="loading" border>
      <el-table-column prop="id" label="ID" width="180" />
      <el-table-column prop="title" label="新闻标题" />
      <el-table-column label="图片" width="180">
        <template #default="scope">
          <el-image 
            v-if="scope.row.pic"
            :src="getImageUrl(scope.row.pic)" 
            :preview-src-list="[getImageUrl(scope.row.pic)]"
            fit="cover"
            class="news-image"
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
      :title="dialogType === 'add'? '添加新闻' : '编辑新闻'"
      width="500px"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="新闻标题" prop="title">
          <el-input v-model="form.title" />
        </el-form-item>
        <el-form-item label="新闻内容" prop="content">
          <el-input type="textarea" v-model="form.content" :rows="3" />
        </el-form-item>
        <el-form-item label="图片" prop="pic">
          <el-upload
            class="news-uploader"
            :action="`${apiUrl}/api/admin/scenicNews/upload`"
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
                class="news-image" 
              />
              <div v-else class="upload-placeholder">
                <el-icon class="news-uploader-icon"><Plus /></el-icon>
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
// 不再需要dayjs
// import dayjs from 'dayjs'

// 添加环境变量引用
const apiUrl = import.meta.env.VITE_API_URL || 'http://localhost:8081'

// 数据定义
const loading = ref(false)
const newsList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const formRef = ref(null)
const currentEditIndex = ref(-1)

// 搜索表单
const searchForm = ref({
  title: ''
})

// 表单数据
const form = ref({
  title: '',
  content: '',
  pic: ''
})

// 表单验证规则
const rules = {
  title: [{ required: true, message: '请输入新闻标题', trigger: 'blur' }],
  content: [{ required: true, message: '请输入新闻内容', trigger: 'blur' }]
  // 由于现在自动生成日期，移除publishTime的必填验证
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

    // 更新newsList中对应新闻的pic字段
    if (currentEditIndex.value!== -1) {
      newsList.value[currentEditIndex.value].pic = response.data
    }

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
  return `${apiUrl}/api/admin/scenicNews/image/${pic}`
}

// 去掉格式化日期函数
// const formatDate = (date) => {
//   return dayjs(date).format('YYYY-MM-DD HH:mm:ss')
// }

// 获取列表
const getList = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      title: searchForm.value.title
    }

    console.log('请求参数:', params)

    const res = await api.get('/api/admin/scenicNews/list', params)
    console.log('响应数据:', res)

    if (res && res.data) {
      newsList.value = res.data.records || []
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
    title: ''
  }
  currentPage.value = 1
  getList()
}

// 添加新闻
const handleAdd = () => {
  dialogType.value = 'add'
  currentEditIndex.value = -1
  form.value = {
    title: '',
    // 去掉publishTime字段
    // publishTime: dayjs().format('yyyy-MM-dd HH:mm:ss'),
    content: '',
    pic: ''
  }
  dialogVisible.value = true
}

// 编辑新闻
const handleEdit = (row, index) => {
  dialogType.value = 'edit'
  currentEditIndex.value = index
  form.value = {...row }
  dialogVisible.value = true
}

// 提交表单
const submitForm = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (dialogType.value === 'add') {
          await api.post('/api/admin/scenicNews/add', form.value)
          ElMessage.success('添加成功')
        } else {
          await api.put('/api/admin/scenicNews/update', form.value)
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

// 删除新闻
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除新闻 "${row.title}" 吗？`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )

    const res = await api.del(`/api/admin/scenicNews/delete/${row.id}`)

    if (res.code === 200) {
      ElMessage.success('删除成功')
      await getList()
    } else {
      ElMessage.error(res.msg || '删除失败')
    }
  } catch (error) {
    if (error!== 'cancel') {
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
.news-list {
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

.news-uploader {
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
  
.news-uploader-icon {
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

.news-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 表格中的图片样式 */
.el-table.news-image {
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
