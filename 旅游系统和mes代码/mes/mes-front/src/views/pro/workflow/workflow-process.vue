<template>
<el-row style="margin: 10px">
    <el-col :span="12">
        <el-button type="primary" @click="handlerAdd">新增</el-button>
        <el-button :disabled="isCanDelete" type="primary" @click="handlerDeletes">删除</el-button>
    </el-col>
</el-row>
  <el-row style="margin: 10px">
      <el-col :span="24">
        <el-table
          :data="workflowProcessList"
          stripe
          border
          @selection-change="handleSelectionChange"
          style="width: 100%">
            <el-table-column type="selection" width="55" />
          <el-table-column
                  fixed="left"
            prop="id"
            label="ID"/>
            <el-table-column
                    fixed="left"
                    prop="stepOrder"
                    label="序号"/>
            <el-table-column
                    fixed="left"
                    prop="process.processCode"
                    label="工序编号"/>
            <el-table-column
                    fixed="left"
                    prop="process.processName"
                    label="工序名称"/>
            <el-table-column
                    prop="nextProcess.processName"
                    label="下一道工序">
                <template v-slot="scope">
                    {{ scope.row.nextProcess?scope.row.nextProcess.processName:'无' }}
                </template>
            </el-table-column>
            <el-table-column
                    prop="relationNextDict.dictLabel"
                    label="与下一道工序关系">
                <template v-slot="scope">
                    {{ scope.row.nextProcess?scope.row.relationNextDict.dictLabel:'无' }}
                </template>
            </el-table-column>
            <el-table-column
                    prop="isCritical"
                    label="关键工序">
                <template v-slot="scope">
                    <el-tag :type="scope.row.isCritical == '1' ? 'success' : 'danger'">{{scope.row.isCritical=='1'?'是':'否'}}</el-tag>
                </template>
            </el-table-column>
            <el-table-column
                    prop="needInspection"
                    label="质检确认">
                <template v-slot="scope">
                    <el-tag :type="scope.row.needInspection == '1' ? 'success' : 'danger'">{{scope.row.needInspection=='1'?'是':'否'}}</el-tag>
                </template>
            </el-table-column>
            <el-table-column
                    prop="prepTime"
                    label="准备时间(min)"/>
            <el-table-column
                    prop="waitTime"
                    label="等待时间(min)"/>
            <el-table-column
                    prop="ganttColor"
                    label="甘特图颜色">
                <template v-slot="scope">
                    <el-color-picker v-model="scope.row.ganttColor" disabled />
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
      </el-col>
  </el-row>
    <el-row style="margin: 10px">
      <el-col :span="24">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="page"
          :page-sizes="[10, 20, 30, 40]"
          :page-size="size"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total">
        </el-pagination>
      </el-col>
  </el-row>

  <!-- 新增工序组成模态框 -->
  <el-dialog title="新增工艺组成" v-model="addProcessdialogVisible">
      <el-form ref="workflowProcessFormRef" :model="workflowProcessForm" label-width="auto">
          <el-row>
              <el-col :span="12">
                  <el-form-item label="序号">
                      <el-input-number v-model="workflowProcessForm.stepOrder" />
                  </el-form-item>
              </el-col>
              <el-col :span="12">
                  <el-form-item label="工序">
                      <el-select v-model="workflowProcessForm.processId" placeholder="请选择工序">
                          <el-option
                                  v-for="item in processList"
                                  :key="item.id"
                                  :label="item.processName"
                                  :value="item.id">
                          </el-option>
                      </el-select>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span="12">
                  <el-form-item label="与下一道工序关系">
                      <el-tooltip
                              class="box-item"
                              effect="dark"
                              placement="right"
                      >
                          <template #content>
                              <template v-for="item in relationNextContent">
                                  {{item}}<br/>
                              </template>
                          </template>
                        <el-select v-model="workflowProcessForm.relationNext" placeholder="请选择与下一道工序关系">
                            <el-option
                                    v-for="item in relationNextList"
                                    :key="item.id"
                                    :label="item.dictLabel"
                                    :value="item.id"
                            />
                        </el-select>
                      </el-tooltip>
                  </el-form-item>
              </el-col>
              <el-col :span="12">
                  <el-form-item label="甘特图颜色">
                      <el-color-picker v-model="workflowProcessForm.ganttColor" />
                  </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span="12">
                  <el-form-item label="关键工序">
                      <el-radio-group v-model="workflowProcessForm.isCritical">
                          <el-radio :label="1">是</el-radio>
                          <el-radio :label="0">否</el-radio>
                      </el-radio-group>
                  </el-form-item>
              </el-col>
              <el-col :span="12">
                  <el-form-item label="质检确认">
                      <el-radio-group v-model="workflowProcessForm.needInspection">
                          <el-radio :label="1">是</el-radio>
                          <el-radio :label="0">否</el-radio>
                      </el-radio-group>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span="12">
                  <el-form-item label="准备时间(min)">
                      <el-input-number v-model="workflowProcessForm.prepTime"/>
                  </el-form-item>
              </el-col>
              <el-col :span="12">
                  <el-form-item label="等待时间(min)">
                      <el-input-number v-model="workflowProcessForm.waitTime"/>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span="24">
                  <el-form-item label="备注">
                      <el-input type="textarea" v-model="workflowProcessForm.remarks" />
                  </el-form-item>
              </el-col>
          </el-row>

      </el-form>
      <template #footer>
        <el-button @click="cancelAddOrUpdate">取消</el-button>
        <el-button type="primary" @click="handlerSubmit">保存</el-button>
      </template>
  </el-dialog>

</template>

<script setup>
import { ref, reactive, toRaw, watch, onMounted } from 'vue'
import { getWorkflowProcessPage, getWorkflowProcessById, addWorkflowProcess, updateWorkflowProcess, deleteWorkflowProcess, batchDeleteWorkflowProcess } from '@/api/workflowProcess'
import {getDictDataList} from "@/api/dictData.js";
import {getProcessList} from "@/api/process.js";
import {ElMessage,ElMessageBox} from "element-plus";
import {batchDeleteWorkflow} from "@/api/workflow.js";

const workflowProcessList = ref([])
const total = ref(0)
const page = ref(1)
const size = ref(10)
const addProcessdialogVisible = ref(false);

const workflowProcessForm = reactive({
  id: '',
  workflowId: '',
  processId: '',
  stepOrder: '',
  relationNext: '',
  ganttColor: '',
  isCritical: '',
  needInspection: '',
  prepTime: '',
  waitTime: '',
    remarks: ''
})
const relationNextList = ref([])
const relationNextContent = ref([])
const isEdit = ref(false);
const selectedRows = ref([]);
const isCanDelete = ref(true)

const props = defineProps({
  workflowId: {
    type: Number
  }
})
const processList = ref([])
watch(() => props.workflowId, (newValue, oldValue) => {
  if (newValue) {
    getWorkflowProcessList()
  }
})

onMounted(()=>{
    getWorkflowProcessList();
})

const handleSelectionChange = (srs)=>{
    selectedRows.value = [];
    srs.forEach(row=>{
        selectedRows.value.push(row);
    })
  if(selectedRows.value.length > 0){
      isCanDelete.value = false;
  }else{
      isCanDelete.value = true;
  }
}

const handlerDeletes = ()=>{
    ElMessageBox.confirm(
        `确定要删除选中的 工序 吗？`,
        '确认删除',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        }
    ).then(() => {
        let params = "";
        selectedRows.value.forEach(row => {
            params += "id=" + row.id + "&";
        });
        params =  params.substring(0, params.length - 1);
        batchDeleteWorkflowProcess(params).then(res=>{
            ElMessage.success('删除成功')
            getWorkflowProcessList();
        })
    }).catch(() => {
        ElMessage.info('已取消删除')
    })
}

const handleDelete = (row)=>{
    ElMessageBox.confirm(
        `确定要删除选中的 ${row.process.processName} 吗？`,
        '确认删除',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        }
    ).then(() => {
       deleteWorkflowProcess(row.id).then(res=>{
           if (res.code == 200){
               ElMessage.success("删除完成");
               getWorkflowProcessList();
           }else{
               ElMessage.error("删除失败")
           }
       })
    }).catch(() => {
        ElMessage.info('已取消删除')
    })
}

const handleEdit = (row)=>{
    getWorkflowProcessById(row.id).then(res=>{
            workflowProcessForm.id = res.data.id
            workflowProcessForm.workflowId = res.data.workflowId
            workflowProcessForm.processId = res.data.processId
            workflowProcessForm.stepOrder = res.data.stepOrder
            workflowProcessForm.relationNext = res.data.relationNext
            workflowProcessForm.ganttColor = res.data.ganttColor
            workflowProcessForm.isCritical = res.data.isCritical
            workflowProcessForm.needInspection = res.data.needInspection
            workflowProcessForm.prepTime = res.data.prepTime
            workflowProcessForm.waitTime = res.data.waitTime
            workflowProcessForm.remarks = res.data.remarks
    });
    addProcessdialogVisible.value = true;
    isEdit.value = true;
    getDictDataList({dictType: 'process_next_relation', pageNum: 1, pageSize: 1000})
        .then(res=>{
            relationNextList.value = res.data.records;
            relationNextContent.value = [];
            res.data.records.forEach(item=>{
                relationNextContent.value.push(item.dictLabel + ':' + item.remark)
            })
        })
    getProcessList({pageNum: 1, pageSize: 1000})
        .then(res=>{
            processList.value = res.data.list;
        })
}

const handlerSubmit = () => {
    if (workflowProcessForm.id) {
      updateWorkflowProcess(workflowProcessForm)
        .then(res => {
            if (res.code == 200){
                ElMessage.success("修改流程成功");
                getWorkflowProcessList()
                cancelAddOrUpdate();
            }else{
                ElMessage.error(res.msg);
            }
        })
    } else {
      addWorkflowProcess(workflowProcessForm)
        .then(res => {
            if (res.code == 200){
                ElMessage.success("修改流程成功");
                getWorkflowProcessList()
                cancelAddOrUpdate();
            }else{
                ElMessage.error(res.msg);
            }
        })
    }
}
const cancelAddOrUpdate = () => {
  addProcessdialogVisible.value = false
    workflowProcessForm.id = ''
    workflowProcessForm.workflowId = ''
    workflowProcessForm.processId = ''
    workflowProcessForm.stepOrder = ''
    workflowProcessForm.relationNext = ''
    workflowProcessForm.ganttColor = ''
    workflowProcessForm.isCritical = ''
    workflowProcessForm.needInspection = ''
    workflowProcessForm.prepTime = ''
    workflowProcessForm.waitTime = ''
    workflowProcessForm.remarks = ''

}

const handlerAdd = () => {
    getDictDataList({dictType: 'process_next_relation', pageNum: 1, pageSize: 1000})
        .then(res=>{
            relationNextList.value = res.data.records;
            relationNextContent.value = [];
            res.data.records.forEach(item=>{
                relationNextContent.value.push(item.dictLabel + ':' + item.remark)
            })
        })
    getProcessList({pageNum: 1, pageSize: 1000})
    .then(res=>{
        processList.value = res.data.list;
    })
  addProcessdialogVisible.value = true
  workflowProcessForm.workflowId = props.workflowId
}

const getWorkflowProcessList = () => {
  getWorkflowProcessPage(page.value, size.value, {
    workflowId: props.workflowId
  }).then(res => {
    workflowProcessList.value = res.data.list
    total.value = res.data.total
  })
}

</script>

<style scoped>

</style>