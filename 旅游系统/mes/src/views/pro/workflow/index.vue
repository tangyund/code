<template>
    <div class="customer-container">
        <!-- 搜索栏部分 -->
        <el-card class="search-card">
            <el-form :model="searchForm" label-width="80px" inline>
                <el-form-item label="工艺编码">
                    <el-input v-model="searchForm.workflowCode" placeholder="工艺编码" clearable />
                </el-form-item>
                <el-form-item label="工艺名">
                    <el-input v-model="searchForm.workflowName" placeholder="工艺名" clearable />
                </el-form-item>
                <el-form-item label="状态">
                    <el-select v-model="searchForm.status" style="width:100px" placeholder="请选择状态" clearable>
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
            <el-button type="primary" @click="handleAdd">新增工艺</el-button>
            <el-button type="danger" @click="handleBatchDelete" :disabled="selectedWorkflows.length === 0">批量删除</el-button>
        </div>

        <!-- 列表 -->
        <el-card class="table-card">
            <el-table
                    :data="workflowList"
                    border
                    stripe
                    @selection-change="handleSelectionChange"
            >
                <el-table-column type="selection" width="55" />
                <el-table-column prop="id" label="ID" width="80" />
                <el-table-column prop="workflowCode" label="工艺编号" />
                <el-table-column prop="workflowName" label="工艺名" />
                <el-table-column prop="workflowDescription" label="工艺流程说明" />
                <el-table-column prop="createTime" label="创建时间" width="180" />
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
                width="80%"
                @close="handleDialogClose"
        >
            <el-form
                    :model="workflowForm"
                    :rules="workflowFormRules"
                    ref="workflowFormRef"
                    label-width="auto"
            >
                <el-form-item label="工艺编号" prop="workflowCode">
                    <el-input v-model="workflowForm.workflowCode" />
                </el-form-item>
                <el-form-item label="工艺名称" prop="workflowName">
                    <el-input v-model="workflowForm.workflowName" />
                </el-form-item>
                <el-form-item label="工艺流程说明" prop="workflowDescription">
                    <el-input type="textarea"  v-model="workflowForm.workflowDescription" />
                </el-form-item>
                <el-form-item label="备注" prop="description">
                    <el-input type="textarea" v-model="workflowForm.remarks" />
                </el-form-item>
                <el-form-item label="状态" prop="status">
                    <el-radio-group v-model="workflowForm.status">
                        <el-radio :label="1">启用</el-radio>
                        <el-radio :label="0">禁用</el-radio>
                    </el-radio-group>
                </el-form-item>
            </el-form>
            <el-card v-if="isEdit">
                <el-tabs type="border-card">
                    <el-tab-pane label="组成工序">
                        <WorkflowProcess  :workflowId="workflowForm.id"></WorkflowProcess>
                    </el-tab-pane>
                    <el-tab-pane label="关联产品">
                        <workflow-product :workflowId="workflowForm.id"/>
                    </el-tab-pane>
                </el-tabs>

            </el-card>
            <template #footer>
        <span class="dialog-footer">
          <el-button @click="cancelAddOrupdateWorkflow">取消</el-button>
          <el-button type="primary" @click="submitworkflowForm">确定</el-button>
        </span>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {getWorkflowPage,getWorkflowByCode,addWorkflow,updateWorkflow,deleteWorkflow,batchDeleteWorkflow} from "@/api/workflow.js";
import WorkflowProcess from "@/views/pro/workflow/workflow-process.vue";
import WorkflowProduct from "@/views/pro/workflow/workflow-product.vue";

// 搜索表单
const searchForm = reactive({
    workflowCode:'',
    workflowName:'',
    status: ''
})

// 分页信息
const pagination = reactive({
    currentPage: 1,
    pageSize: 10,
    total: 0
})

// 用户列表数据
const workflowList = ref([])

// 选中的用户
const selectedWorkflows = ref([])

// 对话框相关
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)

// 用户表单
const workflowForm = reactive({
    id: '',
    workflowCode: '',
    workflowName: '',
    status: '',
    workflowDescription: ''
})

// 表单验证规则
const workflowFormRules = {
}



const workflowFormRef = ref()

// 处理搜索
const handleSearch = () => {
    getWorkflowPage(pagination.currentPage, pagination.pageSize, searchForm).then(res=>{
        workflowList.value = res.data.list;
        pagination.total = res.data.total;
    })
}

// 重置搜索
const resetSearch = () => {
    searchForm.workflowCode = ''
    searchForm.workflowName = ''
    searchForm.status = ''
}

// 处理新增用户
const handleAdd = () => {
    dialogTitle.value = '新增工艺'
    isEdit.value = false
    // 重置表单
    Object.assign(workflowForm, {
        id: '',
        workflowCode: '',
        workflowName: '',
        status: '',
        workflowDescription: ''
    })
    dialogVisible.value = true
}

// 处理编辑用户
const handleEdit = (row) => {
    dialogTitle.value = '编辑工艺'
    isEdit.value = true
    // 填充表单数据
    getWorkflowByCode(row.workflowCode).then(res=>{
        Object.assign(workflowForm, res.data)
        Object.assign(workflowForm, row)
        dialogVisible.value = true
    })

}

// 处理删除用户
const handleDelete = (row) => {
    ElMessageBox.confirm(
        `确定要删除工艺 "${row.workflowName}" 吗？`,
        '确认删除',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        }
    ).then(() => {
        deleteWorkflow(row.id).then(res=>{
            ElMessage.success('删除成功')
            handleSearch();
        })
    }).catch(() => {
        ElMessage.info('已取消删除')
    })
}

// 处理批量删除
const handleBatchDelete = () => {
    ElMessageBox.confirm(
        `确定要删除选中的 ${selectedWorkflows.value.length} 个用户吗？`,
        '确认删除',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        }
    ).then(() => {
        let params = "";
        selectedWorkflows.value.forEach(item => {
            params += "id=" + item.id + "&"
        })
        params = params.substring(0, params.length - 1)
        batchDeleteWorkflow(params).then(res=>{
            ElMessage.success('删除成功')
            handleSearch();
        })
    }).catch(() => {
        ElMessage.info('已取消删除')
    })
}

const cancelAddOrupdateWorkflow = () => {
    dialogVisible.value = false
}

// 提交用户表单
const submitworkflowForm = () => {
    workflowFormRef.value.validate((valid) => {
        if (valid) {
            if (isEdit.value) {
                updateWorkflow(workflowForm).then(res=>{
                    if (res.code == 200){
                        ElMessage.success("修改工艺成功");
                        handleSearch()  ;
                        cancelAddOrupdateWorkflow();
                    }else{
                        ElMessage.error(res.message)
                    }
                })
            } else {
                addWorkflow(workflowForm).then(res=>{
                    if (res.code == 200){
                        ElMessage.success("添加工艺成功");
                        handleSearch()  ;
                        cancelAddOrupdateWorkflow();
                    }else{
                        ElMessage.error(res.message)
                    }
                })
            }
        }
    })
}

// 处理对话框关闭
const handleDialogClose = () => {
    workflowFormRef.value.resetFields()
}

// 处理选中项变化
const handleSelectionChange = (selection) => {
    selectedWorkflows.value = selection
}

// 处理分页大小变化
const handleSizeChange = (val) => {
    pagination.pageSize = val
    handleSearch();
}

// 处理当前页变化
const handleCurrentChange = (val) => {
    pagination.currentPage = val
    handleSearch();
}



// 初始化数据
onMounted(() => {
    handleSearch();

})


</script>

<style scoped>
.customer-container {
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