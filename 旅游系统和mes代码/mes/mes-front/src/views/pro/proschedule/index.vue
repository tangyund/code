<template>
  <!-- 搜索栏 -->
  <el-card class="search-card">
    <el-form :model="searchForm" label-width="80px" inline>
      <el-form-item label="工单编号">
        <el-input v-model="searchForm.productionOrderCode" placeholder="工单编号" clearable />
      </el-form-item>
      <el-form-item label="工单名称">
        <el-input v-model="searchForm.productionOrderName" placeholder="工单名称" clearable />
      </el-form-item>
      <el-form-item label="单据来源">
        <el-select style="width: 120px" clearable v-model="searchForm.productionOrderSource" placeholder="单据来源">
          <el-option label="客户订单" :value="1"/>
          <el-option label="库存备货" :value="2"/>
        </el-select>
      </el-form-item>
      <el-form-item label="产品编号">
        <el-input v-model="searchForm.materialCode" placeholder="物料编号" clearable />
      </el-form-item>
      <el-form-item label="产品名称">
        <el-input v-model="searchForm.materialName" placeholder="物料名称" clearable />
      </el-form-item>
      <el-form-item label="客户编号">
        <el-input v-model="searchForm.customerCode" placeholder="客户编号" clearable />
      </el-form-item>
      <el-form-item label="客户名称">
        <el-input v-model="searchForm.customerName" placeholder="客户名称" clearable />
      </el-form-item>
      <el-form-item label="工单类型">
        <el-select style="width: 120px" clearable v-model="searchForm.productionOrderType" placeholder="单据来源">
          <el-option
              v-for="dictData in productionOrderTypeDictDataList"
              :value="dictData.id"
              :label="dictData.dictLabel"
              :key="dictData.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="需求日期">
        <el-date-picker
            v-model="searchForm.requestDate"
            type="date"
            placeholder="请选择需求日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD">
        </el-date-picker>
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>
  </el-card>
  <!-- 工具栏 -->

  <!-- 列表 -->
  <el-card class="table-card">
    <el-table
        :data="productionOrderList"
        border
        stripe

    >
      <el-table-column prop="productionOrderCode" label="工单编号">
        <template #default="scope">
          <el-link type="primary" @click="">{{scope.row.productionOrderCode}}</el-link>
        </template>
      </el-table-column>
      <el-table-column prop="productionOrderName" label="工单名称"/>
      <el-table-column prop="typeDictData.dictLabel" label="工单类型"/>
      <el-table-column prop="productionOrderSource" label="工单来源">
        <template #default="scope">
          {{scope.row.productionOrderSource == 1?'客户订单':'库存备货'}}
        </template>
      </el-table-column>
      <el-table-column prop="orderCode" label="订单编号"/>
      <el-table-column prop="materialCode" label="产品/物料编号"/>
      <el-table-column prop="materialName" label="产品/物料名称"/>
      <el-table-column prop="material.specification" label="规格"/>
      <el-table-column prop="material.unit.name" label="单位"/>
      <el-table-column prop="producedQuantity" label="已生产数量"/>
      <el-table-column prop="customerCode" label="客户编号"/>
      <el-table-column prop="customerName" label="客户名称"/>
      <el-table-column prop="requestDate" label="需求日期"/>
      <el-table-column prop="statusDictData.dictLabel" label="状态">
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="scope">
          <el-button size="small"  @click="handleEdit(scope.row.id,scope.row.materialCode,scope.row.productionOrderCode)">排产</el-button>
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
  <!-- 其他弹窗 -->

  <!--  新增/编辑弹窗-->
  <el-dialog
      :title="dialogTitle"
      v-model="addOrUpdateDialogVisable"
      width="90%">
    <el-form v-model="productionOrderForm">
      <el-form-item label="编号">
        <el-input v-model="productionOrderForm.productionOrderCode" :disabled="isCheck"/>
      </el-form-item>

      <el-form-item label="工单名称">
        <el-input v-model="productionOrderForm.productionOrderName" :disabled="isCheck"/>
      </el-form-item>

      <el-form-item label="来源类型">
        <el-radio-group v-model="productionOrderForm.productionOrderSource" :disabled="true">
          <el-radio :label="1">客户订单</el-radio>
          <el-radio :label="2">库存备货</el-radio>
        </el-radio-group>
      </el-form-item>


      <el-form-item label="订单编号" v-if="productionOrderForm.productionOrderSource==1">
        <el-input v-model="productionOrderForm.orderCode" :disabled="isCheck"/>
      </el-form-item>
      <el-form-item label="工单状态">
        <el-select v-model="productionOrderForm.status" placeholder="工单类型">
          <el-option
              v-for="item in editOptions"
              :key="item.value"
              :label="item.label"
              :disabled="true"
              :value="item.value">
          </el-option>
        </el-select >
      </el-form-item>

      <el-form-item label="供应商编号" prop="supplierCode"
                    v-if="productionOrderForm.productionOrderType==37||productionOrderForm.productionOrderType==38">
        <el-input v-model="productionOrderForm.supplierCode" placeholder="请选择供应商" :disabled="isCheck">
          <template #append>
            <el-button  @click="supplierFormVisible = true">选择</el-button>
          </template>
        </el-input>
      </el-form-item>

      <el-form-item label="供应商名称" v-if="productionOrderForm.productionOrderType==37||productionOrderForm.productionOrderType==38">
        <el-input v-model="productionOrderForm.supplierName" placeholder="供应商名称" :disabled="isCheck" readonly />
      </el-form-item>

      <el-form-item label="产品编号">
        <el-input v-model="productionOrderForm.materialCode" placeholder="请选择物料" :disabled="isCheck" >
          <template #append>
            <el-button  @click="materialFormVisible = true">选择</el-button>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item label="产品名称">
        <el-input v-model="productionOrderForm.material.name" placeholder="产品名称" :disabled="isCheck" readonly />
      </el-form-item>
      <el-form-item label="产品规格">
        <el-input v-model="productionOrderForm.material.specification" placeholder="产品名称" :disabled="isCheck" readonly />
      </el-form-item>
      <el-form-item label="单位">
        <el-input v-model="productionOrderForm.material.unit.name" placeholder="产品名称" :disabled="isCheck" readonly />
      </el-form-item>

      <el-form-item label="工单数量">
        <el-input v-model="productionOrderForm.productionOrderQuantity" label="工单数量" :disabled="isCheck"></el-input>
      </el-form-item>

      <el-form-item label="需求日期">
        <el-date-picker
            v-model="productionOrderForm.requestDate"
            type="date"
            placeholder="请选择需求日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            :disabled="true">
        </el-date-picker>
      </el-form-item>

      <el-form-item label="工单备注">
        <el-input v-model="productionOrderForm.remark" placeholder="备注" :disabled="isCheck" />
      </el-form-item>

      <el-tabs type="border-card" @tab-click="handleWorkflowTabClick ">
         <el-tab-pane
             v-for="workflow in workflowlist"
             :name="workflow.id"
             :label="workflow.workflowName">
           <el-tabs  @tab-click="handleProcessTabClick">
             <el-tab-pane
                 v-for="proce  in workflow.process"
                 :label="proce.processName"
                 :name ="proce.id"
             >
               <el-row>
                  <el-button-group>
                    <el-button @click="openEditDialog(workflow.id,proce.id)">新增</el-button>
                    <el-button @click="editDialogtask">修改</el-button>
                    <el-button @click="deleteDialogtask">删除</el-button>
                  </el-button-group>
               </el-row>
               <el-row>
                 <el-table
                     tooltip-effect="dark"
                     style="width: 100%"
                     @selection-change="handletasklistedit"
                    :data="proce.tasklist">
                   <el-table-column
                       type="selection"
                       width="55">
                   </el-table-column>
                   <el-table-column prop="taskCode" label="任务编号"/>
                   <el-table-column prop="taskName" label="任务名称"/>
                   <el-table-column prop="workstationCode" label="工作站编号"/>
                   <el-table-column prop="workstationName" label="工作站名称"/>
                   <el-table-column prop="scheduledQuantity" label="排产数量"/>
                   <el-table-column prop="producedQuantity" label="已产数量"/>
                   <el-table-column prop="productionDuration" label="生产时长"/>
                   <el-table-column prop="estimatedCompletionTime" label="预计时间"/>
                   <el-table-column prop="displayColor" label="显示颜色">
                     <template #default="scop">
                     <el-color-picker v-model="scop.row.displayColor" readonly />
                     </template>
                   </el-table-column>
                 </el-table>
               </el-row>
             </el-tab-pane>
           </el-tabs>
         </el-tab-pane>
      </el-tabs>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="cancelAddOrUpdate">取消</el-button>
      </span>
    </template>
  </el-dialog>

  <!--  供应商弹窗-->
  <el-dialog
      title="选择供应商"
      :disabled="true"
      v-model="supplierFormVisible"
      width="80%">
    <supplierdigo
        @select="onSupplierSelected"
        @cancel="supplierFormVisible = false"
    />
  </el-dialog>

  <!--  物料选择弹窗-->
  <el-dialog
      title="选择物料"
      :disabled="true"
      v-model="materialFormVisible"
      width="80%">
    <material
        @select="onMaterialSelected"
        @cancel="materialFormVisible = false"
    />
  </el-dialog>

<!--  新增tasklist表-->
  <el-dialog :title="tasklistname" v-model="dialogAddVisible" width="80%">
    <el-form :model="tasklistForm" label-width="120px">
      <el-form-item label="任务编号">
        <el-input v-model="tasklistForm.taskCode" placeholder="请输入任务编号" />
      </el-form-item>
      <el-form-item label="任务名称">
        <el-input v-model="tasklistForm.taskName" placeholder="请输入任务名称" />
      </el-form-item>
      <el-form-item label="工作站">
        <el-input v-model="tasklistForm.workstationCode" placeholder="请选择工作站" >
          <template #append>
            <el-button  @click="stationFormVisible = true">选择</el-button>
          </template>
        </el-input>
      </el-form-item>

      <el-form-item label="工作站名称">
        <el-input v-model="tasklistForm.workstationName" placeholder="请输入工作站名称" />
      </el-form-item>

      <el-form-item label="排产数量" >
        <el-input-number v-model="tasklistForm.scheduledQuantity" @change="handleworklistChange" :min="1" :max="10" ></el-input-number>
      </el-form-item>

      <el-form-item label="甘特图颜色" prop="displayColor">
        <el-space size="small">
          <el-color-picker v-model="tasklistForm.displayColor" />
          <el-input v-model="tasklistForm.displayColor" style="width: 180px;" />
        </el-space>
      </el-form-item>

      <el-form-item label="开始时间" >
        <el-date-picker
            v-model="tasklistForm.startTime"
            type="datetime"
            placeholder="请选择开始时间"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            style="width: 30%;"
        />
      </el-form-item>

      <el-form-item label="生产时长" >
        <el-input-number v-model="tasklistForm.productionDuration" @change="handleworklistimeChange" ></el-input-number>
      </el-form-item>

      <el-form-item label="完成时间" >
        <el-date-picker
            v-model="tasklistForm.estimatedCompletionTime"
            type="datetime"
            placeholder="完成时间"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            style="width: 30%;"
            readonly
        />
      </el-form-item>

    </el-form>

    <!-- 为弹窗添加底部按钮 -->
    <template #footer>
    <span class="dialog-footer">
      <el-button @click="dialogAddVisible = false">取消</el-button>
      <el-button v-if="taskListEdit==false" type="primary" @click="submitTaskForm">确定</el-button>
      <el-button v-if="taskListEdit==true" type="primary" @click="editTaskForm">提交</el-button>
    </span>
    </template>
  </el-dialog>

<!--  选择工作站弹窗-->
  <el-dialog
      title="工作站"
      v-model="stationFormVisible"
      width="80%">
    <!-- 2. 监听子组件触发的 'select' 和 'cancel' 事件 -->
    <station
        :itemId="tasklistForm.processId"
        @select="onStationSelected"
        @cancel="stationFormVisible = false"
    />

  </el-dialog>

</template>

<script setup>
// 导入必须的内容
import {ref,onMounted} from "vue";
import {ElMessage,ElMessageBox} from "element-plus";
import {
  getProductionOrderList,
  getProductionOrder,
  addProductionOrder,
  updateProductionOrder,
  confirmProductionOrder,
  deleteProductionOrder,
  getProductionOrderBom,
  batchDeleteProcess,
  getTask,
  updateTaskList,
  deleteTaskList,
  generateProductionOrderCode, auditProductionOrder,cancleProductionOrder,getProcesslist,getTaskList,calculateCompletionTime,addTask
} from "@/api/allDoneOrder.js";
// 导入字典相关的API
import {getDictDataList} from "@/api/dictData.js";
import Supplierdigo from "@/views/pro/production-order/supplierdigo.vue";
import Material from "@/views/pro/production-order/material.vue";
import * as row from "element-plus/es/locale/index";
import MaterialBomList from "@/views/pro/production-order/MaterialBomList.vue";
import Station from "@/views/pro/proschedule/station.vue";

// ----- 属性声明 ↓
// 绑定搜索表单的数据
let searchForm = ref({
  productionOrderCode:"",
  productionOrderName:"",
  materialCode:"",
  materialName:"",
  status:"",
  productionOrderSource:"",
  customerCode:"",
  customerName:"",
  productionOrderType:"",
  requestDate:"",
})
// 工单列表数据
const productionOrderList = ref([]);
// 分页相关数据
const pagination = ref({
  currentPage:1,
  pageSize:10,
  total:0
})
// 弹窗的标题
let dialogTitle = "新增工单";
// 弹窗标记
const addOrUpdateDialogVisable = ref(false);
const supplierFormVisible=ref(false)
const stationFormVisible=ref(false)
const dialogAddVisible=ref(false)

// 新增/编辑表单的数据绑定对象
let productionOrderForm = ref({
  id: null,
  productionOrderCode: "",
  productionOrderName: "",
  productionOrderType: "",
  productionOrderSource: null, // 默认不选中任何选项，让用户明确选择
  orderCode: "",
  materialCode: "",
  productionOrderQuantity: 1,
  producedQuantity:"",
  customerCode: "",
  supplierCode: "",
  supplierName:"",
  requestDate: "",
  material:{
    name:"",
    specification:"",
    unit:{
      name:""
    },
  },
  status:"",
  remark: ""
})
let tasklistForm = ref({

  id: "",
  taskCode: "",
  taskName: "",
  workstationCode: "",
  workstationName: "",
  workflowId: "",
  processId: "",
  scheduledQuantity: "",
  producedQuantity: "",
  startTime: "",
  productionDuration: "",
  estimatedCompletionTime: "",
  displayColor: "",
  productionOrderCode:""
  
})
const materialInfo = ref({
  name: "",
  specification: "",
  unitName: ""
});


const options = ref([
  { value: 36, label: '自产'  },
  { value: 37, label: '外协' },
  { value: 38, label: '外购' },
]);
const editOptions = ref([
  { value: 39, label: '草稿'},
  { value: 40, label: '确认'},
  { value: 41, label: '已审核'},
]);
const handleChange = (value) => {
  console.log(value);
  productionOrderForm.value.productionOrderQuantity = value;
};
const handleworklistChange = (value) => {
  console.log(value);
  tasklistForm.value.scheduledQuantity= value;
};



const handleworklistimeChange = async (value) => {
  console.log('生产时长变化:', value);
  // 更新生产时长
  tasklistForm.value.productionDuration = value;
  // 检查开始时间是否已选择
  if (!tasklistForm.value.startTime) {
    console.log('请先选择开始时间');
    return; // 如果没有开始时间则不调用接口
  }
  try {
    const response = await calculateCompletionTime(
        tasklistForm.value.startTime,
        tasklistForm.value.productionDuration
    );

    if (response.success) {
      // 将计算结果赋值给预计完成时间
      tasklistForm.value.estimatedCompletionTime = response.estimatedCompletionTime;
      console.log('计算完成时间:', tasklistForm.value.estimatedCompletionTime);
    } else {
      console.error('计算失败:', response.message);
    }
  } catch (error) {
    console.error('请求出错:', error);
  }
};


// 是否自动生成编号标记
const isAutoCode = ref(false);
// 是否是显示详情的标记
const isDetail = ref(false);
// 编辑标记
let isEdit =ref(false)
// 审核标记
const isCheck=ref(false)
// 工单类型字典列表
const productionOrderTypeDictDataList = ref([]);
// 工单状态点列表
const productionOrderStatusDictDataList = ref([]);
// ----- 属性声明 ↑

// -- 函数声明 ↓
const loadProductionOrderStatusDictDataList=()=>{
  getDictDataList({dictType:"PRODUCTION_ORDER_STATUS"}).then(res=>{
    productionOrderStatusDictDataList.value = res.data.records;
  })
}
// 定义当前激活的标签页
const activeName = ref('first');

// 标签页点击事件处理函数
const handleClick = (tab) => {
  // 从标签name中提取工序ID
  const processId = tab.name.replace('process-', '');
  // 找到当前激活的工序
  activeProcess.value = processes.value.find(p => p.id === processId);
  console.log('当前激活的工序:', activeProcess.value);

  // 可以在这里加载该工序的详细数据
  // loadProcessDetails(processId);
};

// 加载工单类型字典的函数
const loadProductOrderDictDataList=()=>{
  getDictDataList({dictType:"PRODUCTION_ORDER_TYPE"}).then(res=>{
    productionOrderTypeDictDataList.value = res.data.records;
  })
}
const onSupplierSelected = (supplier) => {
  console.log("选中的供应商:", supplier);
  productionOrderForm.value.supplierCode = supplier.code;
  productionOrderForm.value.supplierName = supplier.name;
  supplierFormVisible.value = false;
}
const onStationSelected = (station) => {
  console.log("选中的物料:", station);
  tasklistForm.value.workstationCode = station.code;
  tasklistForm.value.workstationName = station.name;
  stationFormVisible.value = false;
}







// 取消新增/编辑的事件
const cancelAddOrUpdate = ()=>{
  addOrUpdateDialogVisable.value = false;
  isCheck.value = false;
  isEdit.value = false;
  resetForm();
}


//当前选中工艺
const currentWorklowId=ref(undefined);
const currentProductCode=ref(undefined)

const workflowlist = ref([]);

//排产
const handleEdit=(id,materialCode,productionOrderCode)=>{
  isEdit.value = false;
  resetForm();
  currentProductCode.value=productionOrderCode
  dialogTitle = "编辑工单";
  getProductionOrder(id).then(res => {
    productionOrderForm.value = res.data;
    if (res.data.material) {
      materialInfo.value = {
        name: res.data.material.name,
        specification: res.data.material.specification,
        unitName: res.data.material.unit ? res.data.material.unit.name : ''
      };
    }

  });
  getProcesslist(materialCode).then(res=>{
    if (res.code === 200 && res.success) {
      workflowlist.value = res.data

    }
  });
  addOrUpdateDialogVisable.value = true;
};
//绑定选中工艺
const handleWorkflowTabClick=(panel)=>{
 currentWorklowId.value=panel.props.name;
}
//选中行
const currentRow = ref(null);
//选中当前行
const handletasklistedit=(val)=>{
  multipleSelection.value = val;

}
const taskListEdit=ref(false)

const openEdit=ref(false)

let tasklistname="新增弹窗"

const multipleSelection = ref([]);

const deleteDialogtask=()=>{
  const currentWorkflowId = currentWorklowId.value;
  const currentProcessId = multipleSelection.value[0].processId;
  if (multipleSelection.value.length==1){

    const deletedRow = multipleSelection.value[0];
    deleteTaskList(deletedRow.id).then(res=>{
      if (res.code === 200 && res.success)
        ElMessage.success("删除成功")
      else ElMessage.error("删除失败")
      refreshCurrentTaskList(currentWorkflowId, currentProcessId);
      multipleSelection.value = [];
    })
  }
  else {
    const ids = multipleSelection.value.map(item => item.id);
    batchDeleteProcess(ids).then(res=>{
      if (res.code === 200 && res.success)
        ElMessage.success("删除成功")
      else ElMessage.error("删除失败")
      refreshCurrentTaskList(currentWorkflowId, currentProcessId);
      multipleSelection.value = [];
    })
  }


}
//修改tasklsit弹窗
const editDialogtask=()=>{

  taskListEdit.value=true
  tasklistname="修改参数"
 if (multipleSelection.value.length>1)
 {
   ElMessage.error("选择行数过多");
 } else {
   const selectedRow = multipleSelection.value[0];
   resettasklistForm();
   getTask(selectedRow.id).then(res => {
     if (res.code === 200 && res.success)
       tasklistForm.value = res.data
   })
   tasklistForm.value.productionOrderCode=currentProductCode.value
   console.log(tasklistForm.value.productionOrderCode)
   dialogAddVisible.value = true;

 }




}

//新增弹窗
const openEditDialog = (workflowId, processId) => {

  tasklistname="新增弹窗"

  resettasklistForm();

  tasklistForm.value.productionOrderCode=currentProductCode.value
  console.log(tasklistForm.value.productionOrderCode)
  tasklistForm.value.workflowId = workflowId;
  tasklistForm.value.processId = processId;


  dialogAddVisible.value = true;

}
const editTaskForm=()=>{

  const editDate={
    ...tasklistForm.value,
    startTime: tasklistForm.value.startTime.replace('T', ' '),
    estimatedCompletionTime: tasklistForm.value.estimatedCompletionTime.replace('T', ' '),


  }


  updateTaskList(editDate).then((res) => {
    // 检查返回结果是否真正成功
    if (res && res.code === 200) {
      ElMessage.success('修改成功');
      dialogAddVisible.value = false;
      refreshCurrentTaskList()
    } else {
      // 处理业务错误
      console.error('修改工单失败：', res?.msg || '未知错误');
      ElMessage.error(res?.msg || '新增工单失败');
    }
  })


}


const submitTaskForm=()=>{
  const submitData = {
    ...tasklistForm.value,
    startTime: tasklistForm.value.startTime.replace('T', ' '),
    estimatedCompletionTime: tasklistForm.value.estimatedCompletionTime.replace('T', ' '),


  };
    addTask(submitData).then((res) => {
      // 检查返回结果是否真正成功
      if (res && res.code === 200) {
        ElMessage.success('新增成功');
        dialogAddVisible.value = false;
        refreshCurrentTaskList()
      } else {
        // 处理业务错误
        console.error('新增工单失败：', res?.msg || '未知错误');
        ElMessage.error(res?.msg || '新增工单失败');
      }
    })


}
// 新增：刷新当前工序的任务列表
const refreshCurrentTaskList = (workflowId, processId) => {

  const targetWorkflowId = workflowId || currentWorklowId.value;
  const targetProcessId = processId || tasklistForm.value.processId;

  // 检查必要的ID是否存在
  if (!targetWorkflowId || !targetProcessId) {
    ElMessage.warning("无法定位任务列表，刷新失败");
    return;
  }

  // 找到对应的工作流和工序并刷新
  const currentWorkflow = workflowlist.value.find(wf => wf.id === targetWorkflowId);
  if (currentWorkflow) {
    const currentProcess = currentWorkflow.process.find(p => p.id === targetProcessId);
    if (currentProcess) {
      getTaskList(targetWorkflowId, targetProcessId,currentProductCode.value).then(res => {
        if (res.code === 200 && res.success) {
          currentProcess.tasklist = res.data;
        } else {
          ElMessage.error("刷新任务列表失败：" + (res?.msg || "未知错误"));
        }
      }).catch(error => {
        console.error("刷新请求失败：", error);
        ElMessage.error("网络错误，刷新失败");
      });
    } else {
      ElMessage.warning("未找到对应的工序");
    }
  } else {
    ElMessage.warning("未找到对应的工作流");
  }
};
const handleProcessTabClick=(panel)=>{
  // panel.props.name
  workflowlist.value.forEach(workflow=>{
    if (workflow.id==currentWorklowId.value){
      workflow.process.forEach(proce=>{
         if (proce.id==panel.props.name){
           let tas=ref([]);
           getTaskList(workflow.id,proce.id,currentProductCode.value).then(res=>{
             if (res.code === 200 && res.success) {
               tas.value = res.data
               proce.tasklist=tas.value;
             }

           })

         }

      });
    }
  });

}


// 改变每页大小的事件
const handleSizeChange =(pageSize)=>{
  pagination.value.pageSize = pageSize;
  handleSearch();
};

// 翻页事件
const handleCurrentChange =(newPage)=>{
  pagination.value.currentPage = newPage;
  handleSearch();
};

// 重置搜索表单
const resetSearch=()=>{
  searchForm.value = {
    productionOrderCode:"",
    productionOrderName:"",
    materialCode:"",
    materialName:"",
    status:"",
    productionOrderSource:"",
    customerCode:"",
    customerName:"",
    productionOrderType:"",
    requestDate:"",
  };
  handleSearch();
};

// 搜索数据
const handleSearch=()=> {
  const params = {
    ...searchForm.value,
    pageNum: pagination.value.currentPage,
    pageSize: pagination.value.pageSize
  };

  getProductionOrderList(params).then(res=>{
    productionOrderList.value = res.data.list;
    pagination.value.total = res.data.total;
  });
};

// 重置表单
const resetForm = () => {
  productionOrderForm.value = {
    id: null,
    productionOrderCode: "",
    productionOrderName: "",
    productionOrderType: "",
    productionOrderSource: null, // 默认不选中任何选项，让用户明确选择
    orderCode: "",
    materialCode: "",
    productionOrderQuantity: 1,
    producedQuantity:"",
    customerCode: "",
    supplierCode: "",
    supplierName:"",
    requestDate: "",
    material:{
      name:"",
      specification:"",
      unit:{
        name:""
      },
    },
    status:"",
    remark: ""
  };
};

const resettasklistForm = () => {
  tasklistForm.value= {

    id: "",
    taskCode: "",
    taskName: "",
    workstationCode: "",
    workstationName: "",
    workflowId: "",
    processId: "",
    scheduledQuantity: "",
    producedQuantity: "",
    startTime: "",
    productionDuration: "",
    estimatedCompletionTime: "",
    displayColor: "",
    productionOrderCode:"",

  };

}

// -- 函数声明 ↑

onMounted(()=>{
  loadProductionOrderStatusDictDataList();
  loadProductOrderDictDataList();
  handleSearch();
});
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

.process-detail {
  padding: 20px;
  min-height: 100px;
}

.empty-state {
  display: flex;
  justify-content: center;
  align-items: center;
}

.no-process {
  padding: 30px;
  text-align: center;
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
