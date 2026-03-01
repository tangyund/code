<template>
    <div class="customer-container">
        <!-- 搜索栏部分 -->
        <el-card class="search-card">
            <el-form :model="searchForm" label-width="80px" inline>
                <el-form-item label="工序编码">
                    <el-input v-model="searchForm.processCode" placeholder="工序编码" clearable />
                </el-form-item>
                <el-form-item label="工序名称">
                    <el-input v-model="searchForm.processName" placeholder="工序名称" clearable />
                </el-form-item>
                <el-form-item label="状态">
                    <el-select style="width: 120px;" v-model="searchForm.isActive" placeholder="请选择状态" clearable>

                        <el-option label="启用" value="1" />
                        <el-option label="禁用" value="0" />
                    </el-select>
                </el-form-item>
                <el-form-item>
                    <el-button x type="primary" @click="handleSearch">搜索</el-button>
                    <el-button @click="resetSearch">重置</el-button>
                </el-form-item>
            </el-form>
        </el-card>

        <!-- 工具栏部分 -->
        <div class="toolbar">
            <el-button type="primary" @click="handleAdd">新增工序</el-button>
            <el-button type="danger" @click="handleBatchDelete" :disabled="selectedProcess.length === 0">批量删除</el-button>
        </div>

        <!-- 列表 -->
      <el-card class="table-card">
            <el-table
                    :data="processList"
                    border
                    stripe
                    @selection-change="handleSelectionChange"
            >
                <el-table-column type="selection" width="55" />
                <el-table-column prop="id" label="ID" width="80" />
                <el-table-column prop="processCode" label="工序编码" >
                    <template #default="scope">
                        <el-link @click="handlerShowProcess(scope.row)">{{scope.row.processCode}}</el-link>
                    </template>
                </el-table-column>
                <el-table-column prop="processName" label="工序名称" />
                <el-table-column prop="processDescription" label="工序说明" />
                <el-table-column prop="createTime" label="创建时间" width="180" />
                <el-table-column prop="isActive" label="状态" width="80">
                    <template #default="scope">
                        <el-tag :type="scope.row.isActive == '1' ? 'success' : 'danger'">
                            {{ scope.row.isActive == '1' ? '启用' : '禁用' }}
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
                    :model="processForm"
                    :rules="processFormRules"
                    ref="processFormRef"
                    label-width="80px"

            >
                <el-form-item label="工序编码"  prop="cprocessCode">
                  <el-row style="width: 100%">
                    <el-col :span="22">
                      <el-input :disabled="isDetail" v-model="processForm.processCode" />
                    </el-col>
                    <el-col :span="2">
                      <el-switch @click="autoCode" v-if="!isDetail"
                          v-model="isAutoCode"
                          size="large"
                          inline-prompt
                          active-text="生成"
                          inactive-text="生成"
                      />
                    </el-col>
                  </el-row>


                </el-form-item>
                <el-form-item label="工序名称" prop="processName">
                    <el-input :disabled="isDetail" v-model="processForm.processName" />
                </el-form-item>
                <el-form-item label="工序说明" prop="processDescription">
                    <el-input :disabled="isDetail" type="textarea" v-model="processForm.processDescription" />
                </el-form-item>
                <el-form-item label="备注信息" prop="remarks">
                    <el-input :disabled="isDetail" type="textarea"  v-model="processForm.remarks" />
                </el-form-item>
                <el-form-item label="状态" prop="status">
                    <el-radio-group :disabled="isDetail" v-model="processForm.isActive">
                        <el-radio :label="1">启用</el-radio>
                        <el-radio :label="0">禁用</el-radio>
                    </el-radio-group>
                </el-form-item>
            </el-form>
            <el-card v-show="isDetail || isEdit" >
                <template #header>
                    <div class="card-header">
                        <span>工序步骤</span>
                    </div>
                </template>
                <template #default>
                    <!-- 工具栏部分 -->
                    <div class="toolbar" v-if="isEdit">
                        <el-button type="primary" @click="handleStepAdd">新增工序步骤</el-button>
                    </div>
                    <el-table
                            :data="processStepList"
                            border
                            stripe
                    >
                        <el-table-column prop="id" label="ID" width="80" />
                        <el-table-column prop="stepOrder" label="步骤顺序"/>
                        <el-table-column prop="materialUrl" label="材料URL"/>
                        <el-table-column prop="auxiliaryEquipment" label="辅助设备"/>
                        <el-table-column prop="auxiliaryMaterials" label="辅助材料"/>
                        <el-table-column prop="stepDescription" label="步骤说明"/>
                        <el-table-column  v-if="isEdit" label="操作" width="200">
                            <template #default="scope">
                                <el-button size="small" @click="handleStepEdit(scope.row)">编辑</el-button>
                                <el-button
                                    size="small"
                                    type="danger"
                                    @click="handleStepDelete(scope.row)"
                                >
                                    删除
                                </el-button>
                            </template>
                        </el-table-column>
                    </el-table>
                    <el-pagination
                        style="margin-top: 15px"
                            v-model:current-page="processStepPagination.currentPage"
                            v-model:page-size="processStepPagination.pageSize"
                            :page-sizes="[10, 20, 50, 100]"
                            :total="processStepPagination.total"
                            layout="total, sizes, prev, pager, next, jumper"
                            @size-change="handleProcessStepSizeChange"
                            @current-change="handleProcessStepCurrentChange"
                    />
                </template>
            </el-card>
            <el-dialog :title="processStepWinTitle" v-model="processStepWinDialogVisible" width="80%">
                <el-form
                        :model="processStepForm"
                        :rules="processStepFormRules"
                        ref="processStepFormRef"
                        label-width="80px"
                >
                    <el-form-item label="步骤顺序" prop="stepOrder">
                        <el-input v-model="processStepForm.stepOrder" />
                    </el-form-item>
                    <el-form-item label="材料URL" prop="materialUrl">
                        <el-input v-model="processStepForm.materialUrl" />
                    </el-form-item>
                    <el-form-item label="辅助设备" prop="auxiliaryEquipment">
                        <el-input v-model="processStepForm.auxiliaryEquipment" />
                    </el-form-item>
                    <el-form-item label="辅助材料" prop="auxiliaryMaterials">
                        <el-input v-model="processStepForm.auxiliaryMaterials" />
                    </el-form-item>
                    <el-form-item label="步骤说明" prop="stepDescription">
                        <el-input type="textarea" v-model="processStepForm.stepDescription" />
                    </el-form-item>
                    <el-form-item label="备注信息" prop="remarks">
                        <el-input type="textarea" v-model="processStepForm.remarks" />
                    </el-form-item>
                </el-form>
                <template #footer>
                    <span class="dialog-footer">
                      <el-button @click="cancelAddOrUpdateProcessStep">取消</el-button>
                      <el-button type="primary" @click="submitProcessStepForm">确定</el-button>
                    </span>
                </template>
            </el-dialog>
            <template #footer>
                <span class="dialog-footer">
                  <el-button @click="dialogVisible = false">取消</el-button>
                  <el-button v-if="!isDetail" type="primary" @click="submitProcessForm">确定</el-button>
                </span>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
    getProcessList,
    addProcess,
    queryByCode,
    updateProcess,
    deleteProcess,
    batchDeleteProcess,
    getAutoCode
} from "@/api/process.js";
import {
    getProcessStepList,
    addProcessStep,
    deleteProcessStep,
    updateProcessStep,
    getProcessStepById
} from "@/api/processStep.js";


// 搜索表单
const searchForm = reactive({
    processCode:'',
    processName:'',
    isActive: ''
})

// 分页信息
const pagination = reactive({
    currentPage: 1,
    pageSize: 10,
    total: 0
})

// 用户列表数据
const processList = ref([])

// 选中的用户
const selectedProcess = ref([])

// 对话框相关
const dialogVisible = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)

// 用户表单
const processForm = reactive({
    id: '',
    processCode: '',
    processName: '',
    processDescription: '',
    remarks: '',
    isActive:''
})
// 是否展示详情标记
const isDetail = ref(false);

// 表单验证规则
const processFormRules = {
}

// 是否自动生成编号
const isAutoCode = ref(false);



const handlerShowProcess = (row) => {
    dialogTitle.value = '查看工序'
    // 填充表单数据
    getProcessStepById(row.id).then(res=>{
        Object.assign(processForm, row)
        dialogVisible.value = true
        isDetail.value = true;
        loadProcessStepList(row.id)
    })

}

const processFormRef = ref()


// 工序步骤相关属性----↓
// 工序步骤列表
const processStepList = ref([])
const processStepWinDialogVisible = ref(false);
const processStepForm = reactive({
    id: '',
    processId: '',
    stepOrder: '',
    materialUrl: '',
    auxiliaryEquipment: '',
    auxiliaryMaterials: '',
    stepDescription:'',
    remarks:'',
})
const processStepIsEdit = ref(false);
const processStepPagination = reactive({
    currentPage: 1,
    pageSize: 10,
    total: 0
})
const processStepWinTitle = ref('新增工序步骤');


// 自动生成工序编号的函数
const autoCode=()=>{
  if(isAutoCode.value){
    // 生成编号
    getAutoCode().then(res=>{
      if(res.code == 200){
        processForm.processCode = res.data;
      }else{
        isAutoCode.value = false;
        ElMessage.error("编号自动生成失败")
      }
    })
  }else{
    processForm.processCode = "";
  }
}


// 工序步骤相关属性----↑
// 工序步骤相关方法---↓
// 删除工序步骤按钮事件
const handleStepDelete=(row) => {
    ElMessageBox.confirm(
        `确定要删除工序步骤 "${row.stepOrder}" 吗？`,
        '确认删除',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        }
    ).then(() => {
        // 模拟删除操作
        deleteProcessStep(row.id).then(res=>{
            if (res.code == 200){
                ElMessage.success('删除成功')
                loadProcessStepList(processForm.id)
            }else{
                ElMessage.error('删除失败')
            }
        })
    }).catch(() => {
        ElMessage.info('已取消删除')
    })
}
// 编辑工序步骤按钮事件
const handleStepEdit = (row) => {
    processStepWinTitle.value = '编辑工序步骤';
    processStepIsEdit.value = true;
    getProcessStepById(row.id)
        .then(res=>{
            processStepForm.id = res.data.id;
            processStepForm.processId = res.data.processId;
            processStepForm.stepOrder = res.data.stepOrder;
            processStepForm.materialUrl = res.data.materialUrl;
            processStepForm.auxiliaryEquipment = res.data.auxiliaryEquipment;
            processStepForm.auxiliaryMaterials = res.data.auxiliaryMaterials;
            processStepForm.stepDescription = res.data.stepDescription;
            processStepForm.remarks = res.data.remarks;
            processStepWinDialogVisible.value = true;
        })
}
const loadProcessStepList = (processId) => {
    getProcessStepList({processId:processId,pageNum:processStepPagination.currentPage,size:processStepPagination.pageSize})
        .then(res=>{
            processStepList.value = res.data.list;
            processStepPagination.total = res.data.total;
        })
}
//  处理新增工序步骤
const handleStepAdd = () => {
    processStepWinTitle.value = '新增工序步骤';
    processStepIsEdit.value = false;
    processStepWinDialogVisible.value = true;
}
// 关闭新增工序步骤弹窗
const cancelAddOrUpdateProcessStep = () => {
    processStepWinDialogVisible.value = false;
    processStepForm.processId = '';
    processStepForm.id = '';
    processStepForm.stepOrder = '';
    processStepForm.materialUrl = '';
    processStepForm.auxiliaryEquipment = '';
    processStepForm.auxiliaryMaterials = '';
    processStepForm.stepDescription = '';
    processStepForm.remarks = '';
}
// 新增/编辑工序步骤
const submitProcessStepForm = () => {
    processStepForm.processId = processForm.id;
    console.log(processStepForm)
    if(processStepIsEdit.value){
        updateProcessStep(processStepForm)
            .then(res=>{
                if (res.code == 200){
                    ElMessage.success('修改工序步骤成功');
                    cancelAddOrUpdateProcessStep();
                    loadProcessStepList(processForm.id);
                }else{
                    ElMessage.error(res.message)
                }
            })
    }else{
        addProcessStep(processStepForm)
            .then(res=>{
                if (res.code == 200){
                    ElMessage.success('新增工序步骤成功');
                    cancelAddOrUpdateProcessStep();
                    loadProcessStepList(processForm.id);
                }else{
                    ElMessage.error(res.message)
                }
            })
    }
}
const handleProcessStepSizeChange=(size) => {
    processStepPagination.pageSize = size;
    loadProcessStepList(processForm.id);
}
const handleProcessStepCurrentChange=(currentPage) => {
    processStepPagination.currentPage = currentPage;
    loadProcessStepList(processForm.id);
}
// 工序步骤相关方法---↑
// 处理搜索
const handleSearch = () => {
    getProcessList({processCode:searchForm.processCode,processName:searchForm.processName,isActive:searchForm.isActive,page:pagination.currentPage,size:pagination.pageSize})
        .then(res=>{
            processList.value = res.data.list;
            pagination.total = res.data.total;
        })
}

// 重置搜索
const resetSearch = () => {
    searchForm.processCode = ''
    searchForm.processName = ''
    searchForm.isActive = ''
}

// 处理新增用户
const handleAdd = () => {
    dialogTitle.value = '新增工序'
    isEdit.value = false
    // 重置表单
    Object.assign(processForm, {
        id: '',
        processCode: '',
        processName: '',
        processDescription: '',
        remarks: '',
        isActive:''
    })
    dialogVisible.value = true
}

// 处理编辑用户
const handleEdit = (row) => {
    dialogTitle.value = '编辑工序'
    isEdit.value = true
    // 填充表单数据
    Object.assign(processForm, row)
    dialogVisible.value = true;
    loadProcessStepList(row.id);
}

// 处理删除用户
const handleDelete = (row) => {
    ElMessageBox.confirm(
        `确定要删除工序 "${row.processName}" 吗？`,
        '确认删除',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        }
    ).then(() => {
        // 模拟删除操作
        deleteProcess(row.id).then(res=>{
            if (res.code==200){
                ElMessage.success('删除成功')
                handleSearch();
            }else {
                ElMessage.error('删除失败')
            }
        })
    }).catch(() => {
        ElMessage.info('已取消删除')
    })
}

// 处理批量删除
const handleBatchDelete = () => {
    ElMessageBox.confirm(
        `确定要删除选中的 ${selectedProcess.value.length} 个工序吗？`,
        '确认删除',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        }
    ).then(() => {
        let param = '';
        selectedProcess.value.forEach(item => {
            param += "id=" + item.id + "&";
        })
        param = param.substring(0, param.length - 1);
        batchDeleteProcess(param).then(res=>{
            if (res.code==200){
                ElMessage.success('批量删除成功')
                handleSearch();
            }else {
                ElMessage.error('批量删除失败')
            }
        })
        selectedProcess.value = []
    }).catch(() => {
        ElMessage.info('已取消删除')
    })
}

// 提交用户表单
const submitProcessForm = () => {
    processFormRef.value.validate((valid) => {
        if (valid) {
            if (isEdit.value) {
                updateProcess(processForm).then(res=>{
                    if (res.code==200){
                        ElMessage.success('编辑工序成功')
                        handleSearch();
                    }else{
                        ElMessage.error(res.message);
                    }
                })
            } else {
                addProcess(processForm).then(res=>{
                    if (res.code==200){
                        ElMessage.success('新增工序成功')
                        handleSearch();
                    }else{
                        ElMessage.error(res.message);
                    }
                })
            }
            dialogVisible.value = false
        }
    })
}

// 处理对话框关闭
const handleDialogClose = () => {
    processFormRef.value.resetFields()
    isDetail.value = false;
    isEdit.value = false;
    isAutoCode.value = false;
}

// 处理选中项变化
const handleSelectionChange = (selection) => {
    selectedProcess.value = selection
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