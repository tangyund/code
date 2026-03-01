<template>
  <div class="log-container">

    <!-- 搜索栏部分 -->
    <el-card class="search-card">
      <el-form :model="searchForm" label-width="80px" inline>
        <el-form-item label="操作人">
          <el-input v-model="searchForm.operator" placeholder="请输入操作人" clearable />
        </el-form-item>
        <el-form-item label="操作类型">
          <el-select v-model="searchForm.operationType" placeholder="请选择操作类型" clearable>
            <el-option label="新增" value="create" />
            <el-option label="修改" value="update" />
            <el-option label="删除" value="delete" />
            <el-option label="查询" value="query" />
          </el-select>
        </el-form-item>
        <el-form-item label="操作时间">
          <el-date-picker
            v-model="searchForm.operationTime"
            type="daterange"
            range-separator="至"
            start-placeholder="开始日期"
            end-placeholder="结束日期"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 工具栏部分 -->
    <div class="toolbar">
      <el-button type="danger" @click="handleBatchDelete" :disabled="selectedLogs.length === 0">批量删除</el-button>
    </div>

    <!-- 列表 -->
    <el-card class="table-card">
      <el-table
        :data="logList"
        border
        stripe
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="operator" label="操作人" />
        <el-table-column prop="operationType" label="操作类型" width="100">
          <template #default="scope">
            <el-tag :type="getOperationTypeTag(scope.row.operationType)">
              {{ getOperationTypeName(scope.row.operationType) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="operationModule" label="操作模块" />
        <el-table-column prop="operationDesc" label="操作描述" />
        <el-table-column prop="operationTime" label="操作时间" width="180" />
        <el-table-column prop="ipAddress" label="IP地址" width="150" />
        <el-table-column label="操作" width="120" fixed="right">
          <template #default="scope">
            <el-button size="small" @click="handleView(scope.row)">详情</el-button>
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

    <!-- 日志详情对话框 -->
    <el-dialog
      title="日志详情"
      v-model="detailDialogVisible"
      width="600px"
    >
      <el-form 
        :model="logDetail" 
        label-width="100px"
        disabled
      >
        <el-form-item label="操作人">
          <el-input v-model="logDetail.operator" />
        </el-form-item>
        <el-form-item label="操作类型">
          <el-input v-model="logDetail.operationType" />
        </el-form-item>
        <el-form-item label="操作模块">
          <el-input v-model="logDetail.operationModule" />
        </el-form-item>
        <el-form-item label="操作描述">
          <el-input v-model="logDetail.operationDesc" type="textarea" />
        </el-form-item>
        <el-form-item label="操作时间">
          <el-input v-model="logDetail.operationTime" />
        </el-form-item>
        <el-form-item label="IP地址">
          <el-input v-model="logDetail.ipAddress" />
        </el-form-item>
        <el-form-item label="请求URL">
          <el-input v-model="logDetail.requestUrl" />
        </el-form-item>
        <el-form-item label="请求方法">
          <el-input v-model="logDetail.requestMethod" />
        </el-form-item>
        <el-form-item label="请求参数">
          <el-input v-model="logDetail.requestParams" type="textarea" />
        </el-form-item>
        <el-form-item label="响应结果">
          <el-input v-model="logDetail.responseResult" type="textarea" />
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button type="primary" @click="detailDialogVisible = false">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

export default {
  name: "LogManagement",
  setup() {
    // 搜索表单
    const searchForm = reactive({
      operator: '',
      operationType: '',
      operationTime: ''
    })

    // 分页信息
    const pagination = reactive({
      currentPage: 1,
      pageSize: 10,
      total: 0
    })

    // 日志列表数据
    const logList = ref([
      {
        id: 1,
        operator: 'admin',
        operationType: 'create',
        operationModule: '用户管理',
        operationDesc: '新增用户: user1',
        operationTime: '2023-01-01 12:00:00',
        ipAddress: '192.168.1.100',
        requestUrl: '/api/user',
        requestMethod: 'POST',
        requestParams: '{"username":"user1","email":"user1@example.com"}',
        responseResult: '{"code":200,"message":"success"}'
      },
      {
        id: 2,
        operator: 'admin',
        operationType: 'update',
        operationModule: '角色管理',
        operationDesc: '修改角色: 管理员',
        operationTime: '2023-02-01 14:30:00',
        ipAddress: '192.168.1.100',
        requestUrl: '/api/role/1',
        requestMethod: 'PUT',
        requestParams: '{"name":"管理员","code":"admin"}',
        responseResult: '{"code":200,"message":"success"}'
      },
      {
        id: 3,
        operator: 'user1',
        operationType: 'delete',
        operationModule: '权限管理',
        operationDesc: '删除权限: 权限管理',
        operationTime: '2023-03-01 16:45:00',
        ipAddress: '192.168.1.101',
        requestUrl: '/api/permission/3',
        requestMethod: 'DELETE',
        requestParams: '{}',
        responseResult: '{"code":200,"message":"success"}'
      }
    ])

    // 选中的日志
    const selectedLogs = ref([])

    // 详情对话框相关
    const detailDialogVisible = ref(false)
    
    // 日志详情表单
    const logDetail = reactive({
      id: '',
      operator: '',
      operationType: '',
      operationModule: '',
      operationDesc: '',
      operationTime: '',
      ipAddress: '',
      requestUrl: '',
      requestMethod: '',
      requestParams: '',
      responseResult: ''
    })

    // 处理搜索
    const handleSearch = () => {

      // 模拟搜索结果
      pagination.total = logList.value.length
    }

    // 重置搜索
    const resetSearch = () => {
      searchForm.operator = ''
      searchForm.operationType = ''
      searchForm.operationTime = ''
      ElMessage.info('重置搜索条件')
    }

    // 处理查看日志详情
    const handleView = (row) => {
      // 填充详情数据
      Object.assign(logDetail, row)
      detailDialogVisible.value = true
    }

    // 处理删除日志
    const handleDelete = (row) => {
      ElMessageBox.confirm(
        `确定要删除该日志记录吗？`,
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
        `确定要删除选中的 ${selectedLogs.value.length} 条日志记录吗？`,
        '确认删除',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
      ).then(() => {
        // 模拟批量删除操作
        ElMessage.success('批量删除成功')
        selectedLogs.value = []
      }).catch(() => {
        ElMessage.info('已取消删除')
      })
    }

    // 处理选中项变化
    const handleSelectionChange = (selection) => {
      selectedLogs.value = selection
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

    // 获取操作类型标签类型
    const getOperationTypeTag = (type) => {
      const tagMap = {
        create: 'success',
        update: 'warning',
        delete: 'danger',
        query: 'info'
      }
      return tagMap[type] || 'info'
    }

    // 获取操作类型名称
    const getOperationTypeName = (type) => {
      const nameMap = {
        create: '新增',
        update: '修改',
        delete: '删除',
        query: '查询'
      }
      return nameMap[type] || '未知'
    }

    // 初始化数据
    onMounted(() => {
      pagination.total = logList.value.length
    })

    return {
      searchForm,
      pagination,
      logList,
      selectedLogs,
      detailDialogVisible,
      logDetail,
      handleSearch,
      resetSearch,
      handleView,
      handleDelete,
      handleBatchDelete,
      handleSelectionChange,
      handleSizeChange,
      handleCurrentChange,
      getOperationTypeTag,
      getOperationTypeName
    }
  }
}
</script>

<style scoped>
.log-container {
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