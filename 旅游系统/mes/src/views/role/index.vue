<template>
  <div class="role-container">
    <!-- 搜索栏部分 -->
    <el-card class="search-card">
      <el-form :model="searchForm" label-width="80px" inline>
        <el-form-item label="角色名称">
          <el-input v-model="searchForm.roleName" placeholder="请输入角色名称" clearable />
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
      <el-button type="primary" @click="handleAdd">新增角色</el-button>
      <el-button type="danger" @click="handleBatchDelete" :disabled="selectedRoles.length === 0">批量删除</el-button>
    </div>

    <!-- 列表 -->
    <el-card class="table-card">
      <el-table
        :data="roleList"
        border
        stripe
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="roleName" label="角色名称" />
        <el-table-column prop="roleCode" label="角色标识" />
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
            <el-button size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button 
              size="small" 
              type="danger" 
              @click="handleDelete(scope.row)"
            >
              删除
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

    <!-- 角色编辑/新增对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="500px"
      @close="handleDialogClose"
    >
      <el-form 
        :model="roleForm" 
        :rules="roleFormRules" 
        ref="roleFormRef" 
        label-width="100px"
      >
        <el-form-item label="角色名称" prop="roleName">
          <el-input v-model="roleForm.roleName" />
        </el-form-item>
        <el-form-item label="角色标识" prop="roleCode">
          <el-input v-model="roleForm.roleCode" />
        </el-form-item>
        <el-form-item label="描述" prop="remark">
          <el-input v-model="roleForm.remark" type="textarea" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="roleForm.status">
            <el-radio label="1">启用</el-radio>
            <el-radio label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
          <el-form-item label="权限">
              <el-tree
                      v-model="roleForm.permissionIds"
                      :data="permissions"
                      :render-after-expand="false"
                      show-checkbox
                      style="width: 240px"
                      lazy
                      :load="loadPermissions"
                      :props="props"
                      multiple
                      ref="permissionTree"
                      node-key="id"
              />

          </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitRoleForm">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, reactive, onMounted,useTemplateRef } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {addRole, getRoleList} from "@/api/role.js";
import {getPermissionList,getPermissionByRoleId} from "@/api/permission.js";

export default {
  name: "RoleManagement",
  setup() {
    // 搜索表单
    const searchForm = reactive({
      roleName: '',
      status: ''
    })

    // 分页信息
    const pagination = reactive({
      currentPage: 1,
      pageSize: 10,
      total: 0
    })

    // 角色列表数据
    const roleList = ref([
      {
        id: 1,
        name: '管理员',
        code: 'admin',
        description: '系统管理员',
        createTime: '2023-01-01 12:00:00',
        status: '1'
      },
      {
        id: 2,
        name: '普通用户',
        code: 'user',
        description: '普通用户角色',
        createTime: '2023-02-01 12:00:00',
        status: '1'
      },
      {
        id: 3,
        name: '访客',
        code: 'guest',
        description: '访客角色',
        createTime: '2023-03-01 12:00:00',
        status: '0'
      }
    ])

      const permissions = ref([]);

    const props = {
      label: 'permissionName',
      value: 'id',
      children: 'children',
        isLeaf:'hasChildren'
    }

    const permissionTree = useTemplateRef("permissionTree");

    // 选中的角色
    const selectedRoles = ref([])

    // 对话框相关
    const dialogVisible = ref(false)
    const dialogTitle = ref('')
    const isEdit = ref(false)
    
    // 角色表单
    const roleForm = reactive({
      id: '',
        roleName: '',
        roleCode: '',
        remark: '',
      status: '1',
        permissionIds:[]
    })
    
    // 表单验证规则
    const roleFormRules = {
      name: [
        { required: true, message: '请输入角色名称', trigger: 'blur' }
      ],
      code: [
        { required: true, message: '请输入角色标识', trigger: 'blur' }
      ]
    }
    
    const roleFormRef = ref()

    // 处理搜索
    const handleSearch = () => {
        getRoleList({roleName:searchForm.roleName,status:searchForm.status,pageNum:pagination.currentPage,size:pagination.pageSize})
            .then( res=>{
                if(res.code == '200'){
                    roleList.value = res.data;
                    pagination.total = res.total;
                }
            })
      // 模拟搜索结果
      // pagination.total = roleList.value.length
    }

    // 重置搜索
    const resetSearch = () => {
      searchForm.name = ''
      searchForm.status = ''
      ElMessage.info('重置搜索条件')
    }

    // 处理新增角色
    const handleAdd = () => {
        loadPermissions();
      dialogTitle.value = '新增角色'
      isEdit.value = false
      // 重置表单
      Object.assign(roleForm, {
          id: '',
          roleName: '',
          roleCode: '',
          remark: '',
          status: '1',
          permissionIds:[]
      })
      dialogVisible.value = true
    }

    // 处理编辑角色
    const handleEdit = (row) => {
        loadPermissions();
        loadPermissionByRoleId(row.id);
      dialogTitle.value = '编辑角色'
      isEdit.value = true
      // 填充表单数据
      Object.assign(roleForm, row)
      dialogVisible.value = true
    }

    // 处理删除角色
    const handleDelete = (row) => {
      ElMessageBox.confirm(
        `确定要删除角色 "${row.name}" 吗？`,
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
        `确定要删除选中的 ${selectedRoles.value.length} 个角色吗？`,
        '确认删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      ).then(() => {
        // 模拟批量删除操作
        ElMessage.success('批量删除成功')
        selectedRoles.value = []
      }).catch(() => {
        ElMessage.info('已取消删除')
      })
    }

    // 提交角色表单
    const submitRoleForm = () => {
      roleFormRef.value.validate((valid) => {
        if (valid) {
          if (isEdit.value) {
            // 模拟更新操作
            ElMessage.success('角色信息更新成功')
          } else {
              permissionTree.value.getCheckedNodes().forEach(node=>roleForm.permissionIds.push(node.id));
              addRole(roleForm).then(res=>{
                  if(res.code == '200'){
                    ElMessage.success('角色新增成功');
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

    const canceAddOrEditPermission=()=>{
        permissionTree.value.setCheckedKeys([]);
        // 重置表单
        Object.assign(roleForm, {
            id: '',
            roleName: '',
            roleCode: '',
            remark: '',
            status: '1',
            permissionIds:[]
        })
        dialogVisible.value = true
    }
    
    const  loadPermissionByRoleId = (roleId) => {
        getPermissionByRoleId(roleId).then(res=>{
            let keys = [];
            res.data.forEach(permission=>keys.push(permission.id));
            console.log(keys)
            permissionTree.value.setCheckedKeys(keys,false);
        })
    }

    // 处理对话框关闭
    const handleDialogClose = () => {
      roleFormRef.value.resetFields()
    }

    // 处理选中项变化
    const handleSelectionChange = (selection) => {
      selectedRoles.value = selection
    }

    // 处理分页大小变化
    const handleSizeChange = (val) => {
      pagination.pageSize = val
      ElMessage.info(`每页显示 ${val} 条`)
        handleSearch()
    }

    // 处理当前页变化
    const handleCurrentChange = (val) => {
      pagination.currentPage = val
        handleSearch()
      ElMessage.info(`当前页: ${val}`)
    }
    // 加载所有权限列表
    const loadPermissions=(permission,resolve)=>{
        console.log(permission)
        if(permission && permission.data && permission.data.id){
          getPermissionList({parentId:permission.data.id,pageNum:1,size:1000}).then(res=>{
              res.data.forEach(permission =>permission.hasChildren = !permission.hasChildren)
              resolve(res.data);
          })
        }else{
            getPermissionList({parentId:0,pageNum:1,size:1000}).then(res=>{
                res.data.forEach(permission =>permission.hasChildren = !permission.hasChildren)
                permissions.value = res.data;
            })
        }
    }

    // 初始化数据
    onMounted(() => {
        handleSearch();
    })

    return {
      searchForm,
      pagination,
      roleList,
      selectedRoles,
      dialogVisible,
      dialogTitle,
      roleForm,
      roleFormRules,
      roleFormRef,
        permissions,
        props,
        permissionTree,
      handleSearch,
      resetSearch,
      handleAdd,
      handleEdit,
      handleDelete,
      handleBatchDelete,
      submitRoleForm,
      handleDialogClose,
      handleSelectionChange,
      handleSizeChange,
      handleCurrentChange,
        loadPermissions
    }
  }
}
</script>

<style scoped>
.role-container {
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