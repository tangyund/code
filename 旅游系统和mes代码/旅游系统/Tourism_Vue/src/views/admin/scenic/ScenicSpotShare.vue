<template>
  <div class="scenic-share">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="用户名称">
          <el-input v-model="searchForm.userName" placeholder="请输入用户名称" />
        </el-form-item>
        <el-form-item label="景点名称">
          <el-input v-model="searchForm.spotName" placeholder="请输入景点名称" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <div class="operation-bar">
      <el-button type="primary" @click="handleAdd">添加分享</el-button>
    </div>

    <!-- 分享列表表格 -->
    <el-table :data="shareList" v-loading="loading" border>
      <el-table-column type="index" label="#" width="50" />
      <el-table-column prop="userName" label="用户名称" />
      <el-table-column prop="spotName" label="景点名称" />
      <el-table-column prop="shareContent" label="分享内容">
        <template #default="scope">
          <el-tooltip
            effect="dark"
            :content="scope.row.shareContent"
            placement="top-start"
          >
            <span>{{ scope.row.shareContent }}</span>
          </el-tooltip>
        </template>
      </el-table-column>
      <el-table-column prop="shareTime" label="分享时间" width="180">
        <template #default="scope">
          {{ formatDateTime(scope.row.shareTime) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
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
      :title="dialogType === 'add' ? '添加分享' : '编辑分享'"
      width="500px"
    >
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="用户名称" prop="userName">
          <el-input v-model="form.userName" />
        </el-form-item>
        <el-form-item label="景点名称" prop="spotName">
          <el-input v-model="form.spotName" />
        </el-form-item>
        <el-form-item label="分享内容" prop="shareContent">
          <el-input
            type="textarea"
            v-model="form.shareContent"
            :rows="4"
            placeholder="请输入分享内容"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitForm">确定</el-button>
        </span>
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
const shareList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const formRef = ref(null)

// 搜索表单
const searchForm = ref({
  userName: '',
  spotName: ''
})

// 表单数据
const form = ref({
  id: undefined,
  userName: '',
  spotName: '',
  shareContent: '',
  shareTime: undefined
})

// 表单验证规则
const rules = {
  userName: [{ required: true, message: '请输入用户名称', trigger: 'blur' }],
  spotName: [{ required: true, message: '请输入景点名称', trigger: 'blur' }],
  shareContent: [{ required: true, message: '请输入分享内容', trigger: 'blur' }]
}

// 获取列表
const getList = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    }
    const res = await api.get('/api/admin/scenicShare/page', params)
    shareList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('获取列表失败:', error)
    ElMessage.error('获取列表失败')
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
    userName: '',
    spotName: ''
  }
  currentPage.value = 1
  getList()
}

// 添加分享
const handleAdd = () => {
  dialogType.value = 'add'
  form.value = {
    id: undefined,
    userName: '',
    spotName: '',
    shareContent: '',
    shareTime: undefined
  }
  dialogVisible.value = true
}

// 编辑分享
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
        let res
        if (dialogType.value === 'add') {
          res = await api.post('/api/admin/scenicShare/add', form.value)
        } else {
          res = await api.put('/api/admin/scenicShare/update', form.value)
        }
        
        if (res.code === 200) {
          ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
          dialogVisible.value = false
          getList()
        }
      } catch (error) {
        ElMessage.error('操作失败')
      }
    }
  })
}

// 删除分享
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除该分享吗？`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    const res = await api.del(`/api/admin/scenicShare/delete/${row.id}`)
    if (res.code === 200) {
      ElMessage.success('删除成功')
      getList()
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
  getList()
}

// 页码改变
const handleCurrentChange = (val) => {
  currentPage.value = val
  getList()
}

// 格式化日期时间
const formatDateTime = (time) => {
  if (!time) return ''
  const date = new Date(time)
  return date.toLocaleString()
}

// 初始化
onMounted(() => {
  getList()
})
</script>

<style scoped>
.scenic-share {
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

.dialog-footer {
  text-align: right;
}

/* 文本超出显示省略号 */
.el-table .cell {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
</style>