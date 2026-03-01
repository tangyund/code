<template>
  <div class="menu-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="菜单名称">
          <el-input v-model="searchForm.name" placeholder="请输入菜单名称" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="searchForm.description" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <div class="operation-bar">
      <el-button type="primary" @click="handleAdd">添加菜单</el-button>
      <el-button
        type="danger"
        @click="handleBatchDelete"
        :disabled="selectedMenuIds.length === 0"
      >批量删除</el-button>
    </div>

    <!-- 菜单列表表格 -->
    <el-table
      :data="menuList"
      v-loading="loading"
      border
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="菜单名称" />
      <el-table-column prop="description" label="描述" />
      <el-table-column prop="price" label="价格" />
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
      :title="dialogType === 'add' ? '添加菜单' : '编辑菜单'"
      width="500px"
    >
      <el-form
        ref="menuFormRef"
        :model="menuForm"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="菜单名称" prop="name">
          <el-input v-model="menuForm.name" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="menuForm.description" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number v-model="menuForm.price" :min="0" />
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
const menuList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const menuFormRef = ref(null)
const selectedMenuIds = ref([])

// 搜索表单
const searchForm = ref({
  name: '',
  description: '',
})

// 菜单表单
const menuForm = ref({
  name: '',
  description: '',
  price: 0,
})

// 表单验证规则
const rules = {
  name: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
  price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
}

// 获取菜单列表
const getMenuList = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    }
    const res = await api.get('/api/admin/menu/list', params)
    menuList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('获取菜单列表失败:', error)
    ElMessage.error('获取菜单列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  getMenuList()
}

// 重置搜索
const resetSearch = () => {
  searchForm.value = {
    name: '',
    description: '',
  }
  handleSearch()
}

// 添加菜单
const handleAdd = () => {
  dialogType.value = 'add'
  menuForm.value = {
    name: '',
    description: '',
    price: 0,
  }
  dialogVisible.value = true
}

// 编辑菜单
const handleEdit = (row) => {
  dialogType.value = 'edit'
  menuForm.value = { ...row }
  dialogVisible.value = true
}

// 提交表单
const submitForm = async () => {
  if (!menuFormRef.value) return

  await menuFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const payload = {
          ...menuForm.value,
        }
        if (dialogType.value === 'add') {
          await api.post('/api/admin/menu/add', payload)
          ElMessage.success('添加成功')
        } else {
          await api.put('/api/admin/menu/update', payload)
          ElMessage.success('更新成功')
        }
        dialogVisible.value = false
        getMenuList()
      } catch (error) {
        console.error('操作失败:', error)
        ElMessage.error('操作失败')
      }
    }
  })
}

// 删除菜单
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确认删除该菜单吗？', '提示', {
      type: 'warning',
    })
    await api.del(`/api/admin/menu/delete/${row.id}`)
    ElMessage.success('删除成功')
    getMenuList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// 批量删除菜单
const handleBatchDelete = async () => {
  if (selectedMenuIds.value.length === 0) {
    ElMessage.warning('请选择要删除的菜单')
    return
  }
  try {
    await ElMessageBox.confirm('确认批量删除选中的菜单吗？', '提示', {
      type: 'warning',
    })
    await api.post('/api/admin/menu/batch', {
      data: selectedMenuIds.value,
    })
    ElMessage.success('批量删除成功')
    selectedMenuIds.value = []
    getMenuList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('批量删除失败')
    }
  }
}

// 分页大小改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getMenuList()
}

// 页码改变
const handleCurrentChange = (val) => {
  currentPage.value = val
  getMenuList()
}

// 表格选择改变
const handleSelectionChange = (val) => {
  selectedMenuIds.value = val.map((item) => item.id)
}

// 初始化
onMounted(() => {
  getMenuList()
})
</script>

<style scoped>
.menu-list {
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
