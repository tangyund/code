<template>
  <div class="lodging-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="民宿名称">
          <el-input v-model="searchForm.name" placeholder="请输入民宿名称" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <div class="operation-bar">
      <el-button type="primary" @click="handleAdd">添加民宿</el-button>
      <el-button
        type="danger"
        @click="handleBatchDelete"
        :disabled="selectedLodgingIds.length === 0"
      >批量删除</el-button>
    </div>

    <!-- 民宿列表表格 -->
    <el-table
      :data="lodgingList"
      v-loading="loading"
      border
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="民宿名称" />
      <el-table-column prop="location" label="地址" />
      <el-table-column prop="price" label="价格">
        <template #default="scope">
          {{ scope.row.price ? `¥${scope.row.price}` : '免费' }}
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
            class="lodging-image"
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
      :title="dialogType === 'add' ? '添加民宿' : '编辑民宿'"
      width="500px"
    >
      <el-form
        ref="lodgingFormRef"
        :model="lodgingForm"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="民宿名称" prop="name">
          <el-input v-model="lodgingForm.name" />
        </el-form-item>
        <el-form-item label="地址" prop="location">
          <el-input v-model="lodgingForm.location" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number v-model="lodgingForm.price" :min="0" />
        </el-form-item>
        <el-form-item label="联系方式" prop="contactInfo">
          <el-input v-model="lodgingForm.contactInfo" />
        </el-form-item>
        <el-form-item label="图片" prop="pic">
          <el-upload
            class="lodging-uploader"
            :action="`${apiUrl}/api/admin/lodging/upload`"
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
                v-if="lodgingForm.pic"
                :src="getImageUrl(lodgingForm.pic)"
                class="lodging-image"
              />
              <div v-else class="upload-placeholder">
                <el-icon class="lodging-uploader-icon"><Plus /></el-icon>
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
        <el-form-item label="描述" prop="description">
          <el-input type="textarea" v-model="lodgingForm.description" />
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
const lodgingList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const lodgingFormRef = ref(null)
const selectedLodgingIds = ref([])

// 搜索表单
const searchForm = ref({
  name: '',
})

// 民宿表单
const lodgingForm = ref({
  id: null,
  name: '',
  location: '',
  price: 0,
  contactInfo: '',
  pic: '',
  description: '',
})

// 表单验证规则
const rules = {
  name: [{ required: true, message: '请输入民宿名称', trigger: 'blur' }],
  location: [{ required: true, message: '请输入地址', trigger: 'blur' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
  contactInfo: [{ required: true, message: '请输入联系方式', trigger: 'blur' }],
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
    lodgingForm.value.pic = response.data
    ElMessage.success('图片上传成功')
    uploadProgress.value = 100

    // 1秒后重置进度条
    setTimeout(() => {
      uploadProgress.value = 0
    }, 1000)
  } else {
    ElMessage.error(response.msg || '上传失败')
    lodgingForm.value.pic = ''
  }
}

// 处理上传失败
const handleUploadError = (error) => {
  console.error('上传失败:', error)
  ElMessage.error('图片上传失败，请重试')
  uploadProgress.value = 0
  lodgingForm.value.pic = ''
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

// 获取民宿列表
const getLodgingList = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    }
    const res = await api.get('/api/admin/lodging/list', params)
    lodgingList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('获取民宿列表失败:', error)
    ElMessage.error('获取民宿列表失败')
  } finally {
    loading.value = false
  }
}

// 获取图片URL
const getImageUrl = (pic) => {
  if (!pic) return ''
  if (pic.startsWith('http')) return pic
  return `${apiUrl}/api/admin/lodging/image/${pic}`
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1 // 搜索时回到第一页
  getLodgingList()
}

// 重置搜索
const resetSearch = () => {
  searchForm.value = { name: '' }
  currentPage.value = 1 // 重置时回到第一页
  getLodgingList()
}

// 添加民宿
const handleAdd = () => {
  dialogType.value = 'add'
  lodgingForm.value = {
    id: null,
    name: '',
    location: '',
    price: 0,
    contactInfo: '',
    pic: '',
    description: '',
  }
  dialogVisible.value = true
  // 清除表单校验状态
  lodgingFormRef.value?.resetFields()
}

// 编辑民宿
const handleEdit = (row) => {
  dialogType.value = 'edit'
  lodgingForm.value = { ...row } // 浅拷贝，避免直接修改原数据
  dialogVisible.value = true
  // 清除表单校验状态
  lodgingFormRef.value?.resetFields()
}

// 删除民宿
const handleDelete = async (row) => {
    try {
        await ElMessageBox.confirm('确定要删除该民宿吗?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        })

        // 使用 api.del 而不是 api.delete
        await api.del(`/api/admin/lodging/delete/${row.id}`);
        ElMessage.success('删除成功')
        getLodgingList()
    } catch (error) {
        if(error !== 'cancel') {
            console.error('删除民宿失败', error)
            ElMessage.error('删除民宿失败')
        }
    }
}

// 批量删除民宿
const handleBatchDelete = async () => {
  if (selectedLodgingIds.value.length === 0) {
    ElMessage.warning('请选择要删除的民宿')
    return
  }

  try {
    await ElMessageBox.confirm('确定要批量删除选中的民宿吗?', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning',
    })
    await api.post('/api/admin/lodging/batchDelete', {
      data: selectedLodgingIds.value,
    })
    ElMessage.success('批量删除成功')
    selectedLodgingIds.value = [] // 清空选择
    getLodgingList()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除民宿失败', error)
      ElMessage.error('批量删除民宿失败')
    }
  }
}

// 提交表单
const submitForm = async () => {
  lodgingFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (dialogType.value === 'add') {
          await api.post('/api/admin/lodging/add', lodgingForm.value)
          ElMessage.success('添加成功')
        } else {
          await api.put('/api/admin/lodging/update', lodgingForm.value)
          ElMessage.success('更新成功')
        }
        dialogVisible.value = false
        getLodgingList()
      } catch (error) {
        console.error('提交表单失败:', error)
        ElMessage.error('提交表单失败')
      }
    } else {
      console.log('表单验证失败')
      return false
    }
  })
}

// 分页相关
const handleSizeChange = (size) => {
  pageSize.value = size
  getLodgingList()
}

const handleCurrentChange = (page) => {
  currentPage.value = page
  getLodgingList()
}

// 表格选择
const handleSelectionChange = (val) => {
  selectedLodgingIds.value = val.map((item) => item.id)
}

// 初始化
onMounted(() => {
  getLodgingList()
})
</script>

<style scoped>
.lodging-list {
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

.image-placeholder {
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f5f5f5;
  color: #bbb;
  font-size: 12px;
  height: 100%;
}

.lodging-uploader {
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

  .lodging-uploader-icon {
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

.lodging-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 表格中的图片样式 */
.el-table .lodging-image {
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
