<template>
  <div class="vendor-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="商家名称">
          <el-input v-model="searchForm.name" placeholder="请输入商家名称" />
        </el-form-item>
        <el-form-item label="商家地址">
          <el-input v-model="searchForm.location" placeholder="请输入商家地址" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <div class="operation-bar">
      <el-button type="primary" @click="handleAdd">添加商家</el-button>
      <el-button
        type="danger"
        @click="handleBatchDelete"
        :disabled="selectedVendorIds.length === 0"
      >批量删除</el-button>
    </div>

    <!-- 商家列表表格 -->
    <el-table
      :data="vendorList"
      v-loading="loading"
      border
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="商家名称" />
      <el-table-column prop="description" label="商家描述" min-width="200" />
      <el-table-column prop="location" label="地址" />
      <el-table-column prop="contactInfo" label="联系电话" />
      <el-table-column label="操作" width="220">
        <template #default="scope">
          <el-button type="primary" link @click="handleEdit(scope.row)"
            >编辑</el-button
          >
          <el-button type="danger" link @click="handleDelete(scope.row)"
            >删除</el-button
          >
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
      :title="dialogType === 'add' ? '添加商家' : '编辑商家'"
      width="500px"
    >
      <el-form
        ref="vendorFormRef"
        :model="vendorForm"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="商家名称" prop="name">
          <el-input v-model="vendorForm.name" />
        </el-form-item>
        <el-form-item label="商家描述" prop="description">
          <el-input type="textarea" v-model="vendorForm.description" />
        </el-form-item>
        <el-form-item label="地址" prop="location">
          <el-input v-model="vendorForm.location" />
        </el-form-item>
        <el-form-item label="商家电话" prop="contactInfo">
          <el-input v-model="vendorForm.contactInfo" />
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
import api from '@/api/api'

// 数据定义
const loading = ref(false)
const vendorList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const vendorFormRef = ref(null)
const selectedVendorIds = ref([])

// 搜索表单
const searchForm = ref({
  name: '',
  location: '',
})

// 商家表单
const vendorForm = ref({
  name: '',
  location: '',
  description: '',
  contactInfo: '',
})

// 表单验证规则
const rules = {
  name: [{ required: true, message: '请输入商家名称', trigger: 'blur' }],
  location: [{ required: true, message: '请输入地址', trigger: 'blur' }],
  description: [{ required: true, message: '请输入商家描述', trigger: 'blur' }],
  contactInfo: [{ required: true, message: '请输入联系电话', trigger: 'blur' }],
}

// 获取商家列表
const getVendorList = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    }
    const res = await api.get('/api/admin/foodVendor/list', params) // 使用 /list 接口
    vendorList.value = res.data.records || [] // 使用 records
    total.value = res.data.total || 0
  } catch (error) {
    console.error('获取商家列表失败:', error)
    ElMessage.error('获取商家列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  getVendorList()
}

// 重置搜索
const resetSearch = () => {
  searchForm.value = {
    name: '',
    location: '',
  }
  handleSearch()
}

// 添加商家
const handleAdd = () => {
  dialogType.value = 'add'
  vendorForm.value = {
    name: '',
    location: '',
    description: '',
    contactInfo: '',
  }
  dialogVisible.value = true
}

// 编辑商家
const handleEdit = (row) => {
  dialogType.value = 'edit'
  vendorForm.value = { ...row }
  dialogVisible.value = true
}

// 提交表单
const submitForm = async () => {
  if (!vendorFormRef.value) return

  await vendorFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (dialogType.value === 'add') {
          await api.post('/api/admin/foodVendor/add', vendorForm.value)
          ElMessage.success('添加成功')
        } else {
          await api.put('/api/admin/foodVendor/update', vendorForm.value)
          ElMessage.success('更新成功')
        }
        dialogVisible.value = false
        getVendorList()
      } catch (error) {
        ElMessage.error('操作失败')
      }
    }
  })
}

// 删除商家
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确认删除该商家吗？', '提示', {
      type: 'warning',
    })
    await api.del(`/api/admin/foodVendor/delete/${row.id}`)
    ElMessage.success('删除成功')
    getVendorList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// 批量删除商家
const handleBatchDelete = async () => {
  if (selectedVendorIds.value.length === 0) {
    ElMessage.warning('请选择要删除的商家')
    return
  }
  try {
    await ElMessageBox.confirm('确认批量删除选中的商家吗？', '提示', {
      type: 'warning',
    })
    await api.delete('/api/admin/foodVendor/batch', {
      data: selectedVendorIds.value,
    })
    ElMessage.success('批量删除成功')
    selectedVendorIds.value = [] // 清空选择
    getVendorList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('批量删除失败')
    }
  }
}

// 分页大小改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getVendorList()
}

// 页码改变
const handleCurrentChange = (val) => {
  currentPage.value = val
  getVendorList()
}

// 表格选择改变
const handleSelectionChange = (val) => {
  selectedVendorIds.value = val.map((item) => item.id)
}

// 初始化
onMounted(() => {
  getVendorList()
})
</script>

<style scoped>
.vendor-list {
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
</style>
