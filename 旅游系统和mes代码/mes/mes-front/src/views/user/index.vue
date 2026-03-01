<template>
  <div class="user-container">
    <!-- 搜索栏部分 -->
    <el-card class="search-card">
      <el-form :model="searchForm" label-width="80px" inline>
        <el-form-item label="用户名">
          <el-input v-model="searchForm.username" placeholder="请输入用户名" clearable />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="searchForm.email" placeholder="请输入邮箱" clearable />
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
      <el-button type="primary" @click="handleAdd">新增用户</el-button>
      <el-button type="danger" @click="handleBatchDelete" :disabled="selectedUsers.length === 0">批量删除</el-button>
    </div>

    <!-- 列表 -->
    <el-card class="table-card">
      <el-table
        :data="userList"
        border
        stripe
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="username" label="用户名" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="role" label="角色" >
          <template #default="scope">
            {{getRoleNames(scope.row)}}
          </template>
        </el-table-column>
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

    <!-- 用户编辑/新增对话框 -->
    <el-dialog
      :title="dialogTitle"
      v-model="dialogVisible"
      width="500px"
      @close="handleDialogClose"
    >
      <el-form 
        :model="userForm" 
        :rules="userFormRules" 
        ref="userFormRef" 
        label-width="80px"
      >
        <el-form-item label="头像" prop="username">
          <el-upload
              class="avatar-uploader"
              action="http://localhost:9898/upload/image"
              :show-file-list="false"
              :on-success="handleAvatarSuccess"
              name="uploadFile"
          >
            <img v-if="imageUrl" :src="imageUrl" class="avatar" />
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item label="用户名" prop="username">
          <el-input v-model="userForm.username" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="userForm.email" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input type="password" v-model="userForm.password" />
        </el-form-item>
        <el-form-item label="真实姓名" prop="fullName">
          <el-input v-model="userForm.fullName" />
        </el-form-item>
        <el-form-item label="手机号码" prop="phone">
          <el-input  v-model="userForm.phone" />
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select v-model="userForm.roles" multiple placeholder="请选择角色" style="width: 100%">
            <el-option v-for="role in roles" :label="role.roleName" :value="role.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="userForm.status">
            <el-radio label="1">启用</el-radio>
            <el-radio label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input type="textarea" v-model="userForm.remark" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitUserForm">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {getUserList} from "@/api/user.js";
import {getRoleList} from "@/api/role.js";

export default {
  name: "UserManagement",
  setup() {
    // 搜索表单
    const searchForm = reactive({
      username: '',
      email: '',
      status: ''
    })

    // 分页信息
    const pagination = reactive({
      currentPage: 1,
      pageSize: 10,
      total: 0
    })

    // 用户列表数据
    const userList = ref([])

    // 选中的用户
    const selectedUsers = ref([])

    // 对话框相关
    const dialogVisible = ref(false)
    const dialogTitle = ref('')
    const isEdit = ref(false)
    
    // 用户表单
    const userForm = reactive({
      id: '',
      username: '',
      email: '',
      role: '',
      status: '1',
      password:'123456',
      roles:[]
    })
    
    // 表单验证规则
    const userFormRules = {
      username: [
        { required: true, message: '请输入用户名', trigger: 'blur' }
      ],
      email: [
        { required: true, message: '请输入邮箱', trigger: 'blur' },
        { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
      ],
      role: [
        { required: true, message: '请选择角色', trigger: 'change' }
      ]
    }

    // 角色列表
    const roles = ref([]);
    
    const userFormRef = ref()
    // 上传头像成功的图片访问地址
    const imageUrl = ref('')
    // 上传头像的处理函数
    const handleAvatarSuccess = (response,uploadFile)=>{
      imageUrl.value = response.data;
    }
    // 处理搜索
    const handleSearch = () => {
        getUserList({username:searchForm.username,email:searchForm.email,status:searchForm.status,pageNum:pagination.currentPage,size:pagination.pageSize})
            .then(res=>{
              userList.value = res.data;
              pagination.total = res.total;
            })
    }

    // 重置搜索
    const resetSearch = () => {
      searchForm.username = ''
      searchForm.email = ''
      searchForm.status = ''
      ElMessage.info('重置搜索条件')
    }
    // 处理显示列表中的角色名称
    const getRoleNames=(user)=>{
      let roleNames = '';
      user.roles.forEach(role=>roleNames += role.roleName + ",");
      return roleNames.substring(0,roleNames.length - 1);
    }
    // 处理新增用户
    const handleAdd = () => {
      loadRoles();
      dialogTitle.value = '新增用户'
      isEdit.value = false
      // 重置表单
      Object.assign(userForm, {
        id: '',
        username: '',
        email: '',
        role: '',
        status: '1'
      })
      dialogVisible.value = true
    }

    // 处理编辑用户
    const handleEdit = (row) => {
      dialogTitle.value = '编辑用户'
      isEdit.value = true
      // 填充表单数据
      Object.assign(userForm, row)
      dialogVisible.value = true
    }

    // 处理删除用户
    const handleDelete = (row) => {
      ElMessageBox.confirm(
        `确定要删除用户 "${row.username}" 吗？`,
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
        `确定要删除选中的 ${selectedUsers.value.length} 个用户吗？`,
        '确认删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      ).then(() => {
        // 模拟批量删除操作
        ElMessage.success('批量删除成功')
        selectedUsers.value = []
      }).catch(() => {
        ElMessage.info('已取消删除')
      })
    }

    // 提交用户表单
    const submitUserForm = () => {
      userFormRef.value.validate((valid) => {
        if (valid) {
          if (isEdit.value) {
            // 模拟更新操作
            ElMessage.success('用户信息更新成功')
          } else {
            // 模拟新增操作
            ElMessage.success('用户新增成功')
          }
          dialogVisible.value = false
        }
      })
    }

    // 处理对话框关闭
    const handleDialogClose = () => {
      userFormRef.value.resetFields()
    }

    // 处理选中项变化
    const handleSelectionChange = (selection) => {
      selectedUsers.value = selection
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

    // 加载所有角色
    const loadRoles = ()=>{
      getRoleList({pageNum:1,size:1000}).then(res=>{
        roles.value = res.data;
      })
    }

    // 初始化数据
    onMounted(() => {
      handleSearch();

    })

    return {
      searchForm,
      pagination,
      userList,
      selectedUsers,
      dialogVisible,
      dialogTitle,
      userForm,
      userFormRules,
      userFormRef,
      imageUrl,
      roles,
      handleSearch,
      resetSearch,
      handleAdd,
      handleEdit,
      handleDelete,
      handleBatchDelete,
      submitUserForm,
      handleDialogClose,
      handleSelectionChange,
      handleSizeChange,
      handleCurrentChange,
      getRoleNames,
      handleAvatarSuccess,
      loadRoles
    }
  }
}
</script>

<style scoped>
.user-container {
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

<style scoped>
.avatar-uploader .avatar {
  width: 178px;
  height: 178px;
  display: block;
}
</style>

<style>
.avatar-uploader .el-upload {
  border: 1px dashed var(--el-border-color);
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
  border-color: var(--el-color-primary);
}

.el-icon.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  text-align: center;
}
</style>