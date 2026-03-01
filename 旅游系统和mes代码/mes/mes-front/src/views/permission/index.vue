<template>
  <div class="permission-container">
    <!-- 搜索栏部分 -->
    <el-card class="search-card">
      <el-form :model="searchForm" label-width="80px" inline>
        <el-form-item label="权限名称">
          <el-input v-model="searchForm.name" placeholder="请输入权限名称" clearable />
        </el-form-item>
        <el-form-item label="权限标识">
          <el-input v-model="searchForm.code" placeholder="请输入权限标识" clearable />
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
      <el-button type="primary" @click="handleAdd">新增权限</el-button>
      <el-button type="danger" @click="handleBatchDelete" :disabled="selectedPermissions.length === 0">批量删除</el-button>
    </div>

    <!-- 列表 -->
    <el-card class="table-card">
      <el-table
        :data="permissionList"
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
        <el-table-column prop="permissionName" label="权限名称" />
        <el-table-column prop="permissionCode" label="权限标识" />
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
              <el-button size="small" @click="handlerAddSubPermission(scope.row)" type="success" ><el-icon><Plus /></el-icon></el-button>
            <el-button size="small" @click="handleEdit(scope.row)"><el-icon><EditPen /></el-icon></el-button>
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

    <!-- 权限编辑/新增对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="500px"
      @close="handleDialogClose"
    >
      <el-form 
        :model="permissionForm" 
        :rules="permissionFormRules" 
        ref="permissionFormRef" 
        label-width="100px"
      >
          <el-form-item label="父权限">
              <el-tag v-if="permissionForm.parentId == 0">根权限</el-tag>
              <el-tag v-else>{{ permissionForm.parentName }}</el-tag>
          </el-form-item>
        <el-form-item label="权限名称" prop="permissionName">
          <el-input v-model="permissionForm.permissionName" />
        </el-form-item>
        <el-form-item label="权限标识" prop="permissionCode">
          <el-input v-model="permissionForm.permissionCode" />
        </el-form-item>
          <el-form-item label="权限类型" prop="permissionType">
              <el-radio-group v-model="permissionForm.permissionType">
                  <el-radio checked label="1">菜单</el-radio>
                  <el-radio label="2">按钮</el-radio>
                  <el-radio label="3">接口</el-radio>
              </el-radio-group>
          </el-form-item>
          <el-form-item label="资源路径" prop="path">
              <el-input v-model="permissionForm.path" />
          </el-form-item>
          <el-form-item label="组件路径" prop="component">
              <el-input v-model="permissionForm.component" />
          </el-form-item>
          <el-form-item label="菜单排序" prop="sort">
              <el-input type="number" v-model="permissionForm.sort" />
          </el-form-item>
        <el-form-item label="描述" prop="remark">
          <el-input v-model="permissionForm.remark" type="textarea" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="permissionForm.status">
            <el-radio label="1">启用</el-radio>
            <el-radio label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="canceAddOrEditPermission">取消</el-button>
          <el-button type="primary" @click="submitPermissionForm">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {getPermissionList,addPermission,getPermissionById} from "@/api/permission.js";

export default {
  name: "PermissionManagement",
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

    // 权限列表数据
    const permissionList = ref([
      {
        id: 1,
        name: '用户管理',
        code: 'user:manage',
        description: '用户管理权限',
        createTime: '2023-01-01 12:00:00',
        status: '1'
      },
      {
        id: 2,
        name: '角色管理',
        code: 'role:manage',
        description: '角色管理权限',
        createTime: '2023-02-01 12:00:00',
        status: '1'
      },
      {
        id: 3,
        name: '权限管理',
        code: 'permission:manage',
        description: '权限管理权限',
        createTime: '2023-03-01 12:00:00',
        status: '0'
      }
    ])

    // 选中的权限
    const selectedPermissions = ref([])

    // 对话框相关
    const dialogVisible = ref(false)
    const dialogTitle = ref('')
    const isEdit = ref(false)
    
    // 权限表单
    const permissionForm = reactive({
        parentId:0,
      id: '',
        permissionName: '',
        permissionCode: '',
        remark: '',
      status: '1',
        sort:0,
        component:"",
        path:"",
        permissionType:"1",
    })
    
    // 表单验证规则
    const permissionFormRules = {
      name: [
        { required: true, message: '请输入权限名称', trigger: 'blur' }
      ],
      code: [
        { required: true, message: '请输入权限标识', trigger: 'blur' }
      ]
    }
    
    const permissionFormRef = ref()


      const handlerDataLoad = (row, treeNode, resolve)=>{
          console.log(123)
          getPermissionList({parentId:row.id,pageNum:1,size:1000}).then(res=>{
              console.log( res)
              resolve(res.data);
          });
      }
    // 处理搜索
    const handleSearch = (parentId) => {
      // 模拟搜索结果
        getPermissionList({parentId:parentId,pageNum:pagination.currentPage,size:pagination.pageSize}).then(res=>{
            console.log( res)
            permissionList.value = res.data;
            pagination.total = res.total;
        });
    }

    // 重置搜索
    const resetSearch = () => {
      searchForm.name = ''
      searchForm.code = ''
      searchForm.status = ''
      ElMessage.info('重置搜索条件')
    }

    // 关闭编辑/新增对话框
      const canceAddOrEditPermission = ()=>{
        dialogVisible.value = false;
        permissionFormRef.value.resetFields();
      }

    // 处理新增权限
    const handleAdd = () => {
      dialogTitle.value = '新增权限'
      isEdit.value = false
      // 重置表单
      Object.assign(permissionForm, {
        id: '',
        name: '',
        code: '',
        description: '',
        status: '1'
      })
      dialogVisible.value = true
    }

    // 处理编辑权限
    const handleEdit = (row) => {
      dialogTitle.value = '编辑权限'
      isEdit.value = true
      // 填充表单数据
      Object.assign(permissionForm, row)
      dialogVisible.value = true
    }

    // 处理删除权限
    const handleDelete = (row) => {
      ElMessageBox.confirm(
        `确定要删除权限 "${row.name}" 吗？`,
        '确认删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      ).then(() => {
        // 模拟删除操作
        ElMessage.success('删除成功')
      }).catch(() => {
        ElMessage.info('已取消删除')
      })
    }

    // 处理批量删除
    const handleBatchDelete = () => {
      ElMessageBox.confirm(
        `确定要删除选中的 ${selectedPermissions.value.length} 个权限吗？`,
        '确认删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      ).then(() => {
        // 模拟批量删除操作
        ElMessage.success('批量删除成功')
        selectedPermissions.value = []
      }).catch(() => {
        ElMessage.info('已取消删除')
      })
    }

    // 提交权限表单
    const submitPermissionForm = () => {
      permissionFormRef.value.validate((valid) => {
        if (valid) {
          if (isEdit.value) {
            // 模拟更新操作
            ElMessage.success('权限信息更新成功')
          } else {
              addPermission(permissionForm).then(res=>{
                  if (res.code == 200){
                      // 模拟新增操作
                      ElMessage.success('权限新增成功')
                      canceAddOrEditPermission();
                      handleSearch(0);
                  }else{
                      ElMessage.error(res.message);
                  }
              })
          }
          dialogVisible.value = false
        }
      })
    }
    // 行级新增按钮
    const handlerAddSubPermission= (row)=>{
        permissionForm.parentId = row.id;
        permissionForm.parentName = row.permissionName;
        dialogVisible.value = true;
    }

    // 处理对话框关闭
    const handleDialogClose = () => {
      permissionFormRef.value.resetFields()
    }

    // 处理选中项变化
    const handleSelectionChange = (selection) => {
      selectedPermissions.value = selection
    }

    // 处理分页大小变化
    const handleSizeChange = (val) => {
      pagination.pageSize = val
      ElMessage.info(`每页显示 ${val} 条`)
    }

    // 处理当前页变化
    const handleCurrentChange = (val) => {
      pagination.currentPage = val
      ElMessage.info(`当前页: ${val}`)
    }

    // 初始化数据
    onMounted(() => {
        handleSearch(0);
    })

    return {
      searchForm,
      pagination,
      permissionList,
      selectedPermissions,
      dialogVisible,
      dialogTitle,
      permissionForm,
      permissionFormRules,
      permissionFormRef,
      handleSearch,
      resetSearch,
      handleAdd,
      handleEdit,
      handleDelete,
      handleBatchDelete,
      submitPermissionForm,
      handleDialogClose,
      handleSelectionChange,
      handleSizeChange,
      handleCurrentChange,
        handlerDataLoad,
        canceAddOrEditPermission,
        handlerAddSubPermission
    }
  }
}
</script>

<style scoped>
.permission-container {
  padding: 20px;
}

.breadcrumb {
  margin-bottom: 20px;
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