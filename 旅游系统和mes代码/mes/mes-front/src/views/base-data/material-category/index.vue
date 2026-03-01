<template>
  <div class="material-category-container">
    <!-- 搜索栏部分 -->
    <el-card class="search-card">
      <el-form :model="searchForm" label-width="80px" inline>
        <el-form-item label="分类名称">
          <el-input v-model="searchForm.name" placeholder="请输入分类名称" clearable />
        </el-form-item>
        <el-form-item label="分类编码">
          <el-input v-model="searchForm.code" placeholder="请输入分类编码" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option label="启用" value="1" />
            <el-option label="禁用" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 工具栏部分 -->
    <div class="toolbar">
      <el-button type="primary" @click="handleAdd">新增分类</el-button>
      <el-button type="danger" @click="handleBatchDelete" :disabled="selectedCategories.length === 0">批量删除</el-button>
    </div>

    <!-- 列表 -->
    <el-card class="table-card">
      <el-table
        :data="categoryList"
        row-key="id"
        border
        stripe
        :tree-props="{ children: 'children', hasChildren: 'hasChildren' }"
        @selection-change="handleSelectionChange"
        :lazy="true"
        :load="handlerDataLoad"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="分类名称" />
        <el-table-column prop="code" label="分类编码" />
        <el-table-column prop="remark" label="描述" />
        <el-table-column prop="createdTime" label="创建时间" width="180" />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="scope">
            <el-tag :type="scope.row.status == '1' ? 'success' : 'danger'">
              {{ scope.row.status == '1' ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button size="small" @click="handlerAddSubCategory(scope.row)" type="success">
              <el-icon><Plus /></el-icon>
            </el-button>
            <el-button size="small" @click="handleEdit(scope.row)">
              <el-icon><EditPen /></el-icon>
            </el-button>
            <el-button 
              size="small" 
              type="danger" 
              @click="handleDelete(scope.row)"
            >
              <el-icon><Delete /></el-icon>
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 分页栏 -->
    <div class="pagination-container">
      <el-pagination
        v-model:current-page="pagination.currentPage"
        v-model:page-size="pagination.pageSize"
        :page-sizes="[10, 20, 50, 100]"
        :total="pagination.total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 分类编辑/新增对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="500px"
      @close="handleDialogClose"
    >
      <el-form 
        :model="categoryForm" 
        :rules="categoryFormRules" 
        ref="categoryFormRef" 
        label-width="100px"
      >
        <el-form-item label="父分类">
          <el-tag v-if="categoryForm.parentId == 0">根分类</el-tag>
          <el-tag v-else>{{ categoryForm.parentName }}</el-tag>
        </el-form-item>
        <el-form-item label="分类名称" prop="name">
          <el-input v-model="categoryForm.name" />
        </el-form-item>
        <el-form-item label="分类编码" prop="code">
          <el-input v-model="categoryForm.code" />
        </el-form-item>
        <el-form-item label="描述" prop="remark">
          <el-input v-model="categoryForm.remark" type="textarea" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="categoryForm.status">
            <el-radio label="1">启用</el-radio>
            <el-radio label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="cancelAddOrEditCategory">取消</el-button>
          <el-button type="primary" @click="submitCategoryForm">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCategoryPage, addCategory, getCategoryTree } from "@/api/material-category.js"

export default {
  name: "MaterialCategoryManagement",
  setup() {
    // 搜索表单
    const searchForm = reactive({
      name: '',
      code: '',
      status: ''
    })

    // 分页信息
    const pagination = reactive({
      currentPage: 1,
      pageSize: 10,
      total: 0
    })

    // 分类列表数据
    const categoryList = ref([])

    // 选中的分类
    const selectedCategories = ref([])

    // 对话框相关
    const dialogVisible = ref(false)
    const dialogTitle = ref('')
    const isEdit = ref(false)
    
    // 分类表单
    const categoryForm = reactive({
      parentId: 0,
      id: '',
      name: '',
      code: '',
      remark: '',
      status: '1',
      parentName: ''
    })
    
    // 表单验证规则
    const categoryFormRules = {
      name: [
        { required: true, message: '请输入分类名称', trigger: 'blur' }
      ],
      code: [
        { required: true, message: '请输入分类编码', trigger: 'blur' }
      ]
    }
    
    const categoryFormRef = ref()

    const handlerDataLoad = (row, treeNode, resolve) => {
      getCategoryTree(row.id, null).then(res => {
        resolve(res.data)
      })
    }

    // 处理搜索
    const handleSearch = (parentId = 0) => {
      getCategoryPage(
        pagination.currentPage, 
        pagination.pageSize, 
        {
          parentId: parentId,
          name: searchForm.name || undefined,
          code: searchForm.code || undefined,
          status: searchForm.status || undefined
        }
      ).then(res => {
        categoryList.value = res.data.records
        pagination.total = res.data.total
      })
    }

    // 重置搜索
    const resetSearch = () => {
      searchForm.name = ''
      searchForm.code = ''
      searchForm.status = ''
      handleSearch()
      ElMessage.info('重置搜索条件')
    }

    // 关闭编辑/新增对话框
    const cancelAddOrEditCategory = () => {
      dialogVisible.value = false
      categoryFormRef.value.resetFields()
    }

    // 处理新增分类
    const handleAdd = () => {
      dialogTitle.value = '新增分类'
      isEdit.value = false
      // 重置表单
      Object.assign(categoryForm, {
        parentId: 0,
        id: '',
        name: '',
        code: '',
        remark: '',
        status: '1',
        parentName: ''
      })
      dialogVisible.value = true
    }

    // 处理编辑分类
    const handleEdit = (row) => {
      dialogTitle.value = '编辑分类'
      isEdit.value = true
      // 填充表单数据
      Object.assign(categoryForm, row)
      dialogVisible.value = true
    }

    // 处理删除分类
    const handleDelete = (row) => {
      ElMessageBox.confirm(
        `确定要删除分类 "${row.name}" 吗？`,
        '确认删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      ).then(() => {
        // 模拟删除操作
        ElMessage.success('删除成功')
        handleSearch()
      }).catch(() => {
        ElMessage.info('已取消删除')
      })
    }

    // 处理批量删除
    const handleBatchDelete = () => {
      ElMessageBox.confirm(
        `确定要删除选中的 ${selectedCategories.value.length} 个分类吗？`,
        '确认删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      ).then(() => {
        // 模拟批量删除操作
        ElMessage.success('批量删除成功')
        selectedCategories.value = []
        handleSearch()
      }).catch(() => {
        ElMessage.info('已取消删除')
      })
    }

    // 提交分类表单
    const submitCategoryForm = () => {
      categoryFormRef.value.validate((valid) => {
        if (valid) {
          if (isEdit.value) {
            // 模拟更新操作
            ElMessage.success('分类信息更新成功')
          } else {
            addCategory(categoryForm).then(res => {
              if (res.code == 200) {
                // 模拟新增操作
                ElMessage.success('分类新增成功')
                cancelAddOrEditCategory()
                handleSearch()
              } else {
                ElMessage.error(res.message)
              }
            })
          }
          dialogVisible.value = false
        }
      })
    }

    // 行级新增按钮
    const handlerAddSubCategory = (row) => {
      categoryForm.parentId = row.id
      categoryForm.parentName = row.name
      dialogTitle.value = '新增子分类'
      isEdit.value = false
      // 重置表单（保留父级信息）
      Object.assign(categoryForm, {
        id: '',
        name: '',
        code: '',
        remark: '',
        status: '1'
      })
      dialogVisible.value = true
    }

    // 处理对话框关闭
    const handleDialogClose = () => {
      categoryFormRef.value.resetFields()
    }

    // 处理选中项变化
    const handleSelectionChange = (selection) => {
      selectedCategories.value = selection
    }

    // 处理分页大小变化
    const handleSizeChange = (val) => {
      pagination.pageSize = val
      handleSearch()
    }

    // 处理当前页变化
    const handleCurrentChange = (val) => {
      pagination.currentPage = val
      handleSearch()
    }

    // 初始化数据
    onMounted(() => {
      handleSearch()
    })

    return {
      searchForm,
      pagination,
      categoryList,
      selectedCategories,
      dialogVisible,
      dialogTitle,
      categoryForm,
      categoryFormRules,
      categoryFormRef,
      handleSearch,
      resetSearch,
      handleAdd,
      handleEdit,
      handleDelete,
      handleBatchDelete,
      submitCategoryForm,
      handleDialogClose,
      handleSelectionChange,
      handleSizeChange,
      handleCurrentChange,
      handlerDataLoad,
      cancelAddOrEditCategory,
      handlerAddSubCategory
    }
  }
}
</script>

<style scoped>
.material-category-container {
  padding: 20px;
}

.search-card {
  margin-bottom: 20px;
}

.toolbar {
  margin-bottom: 20px;
}

.table-card {
  margin-bottom: 20px;
}

.pagination-container {
  display: flex;
  justify-content: flex-end;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>