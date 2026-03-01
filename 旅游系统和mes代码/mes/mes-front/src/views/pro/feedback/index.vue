<template>
  <!-- 搜索栏 -->
  <el-card class="search-card">
    <el-form :model="searchForm" label-width="80px" inline>
      <el-form-item label="报工类型">
        <el-select style="width: 120px" clearable v-model="searchForm.typeId" placeholder="单据来源">
          <el-option label="自行报工" :value="1"/>
          <el-option label="统一报工" :value="2"/>
        </el-select>
      </el-form-item>
      <el-form-item label="工作站名称">
        <el-input v-model="searchForm.stationName" placeholder="请输入工作站名称"  />
      </el-form-item>
      <el-form-item label="生产工单编号">
        <el-input v-model="searchForm.productionOrderCode" placeholder="请输入生产工单编号"  />
      </el-form-item>
      <el-form-item label="产品物料编码">
        <el-input v-model="searchForm.materialCode" placeholder="请输入物料编码" clearable />
      </el-form-item>
      <el-form-item label="产品物料名称">
        <el-input v-model="searchForm.materialName" placeholder="请输入产品物料名称" clearable />
      </el-form-item>
      <el-form-item label="报工人">
        <el-input v-model="searchForm.createBy" placeholder="请输入报工人" clearable />
      </el-form-item>
      <el-form-item label="审核人">
        <el-input v-model="searchForm.reviewBy" placeholder="请输入审核人" clearable />
      </el-form-item>
      <el-form-item label="状态">
          <el-select style="width: 120px;" v-model="searchForm.status" placeholder="请选择状态" clearable>
            <el-option
                v-for="dictData in productionOrderStatusDictDataList"
                :label="dictData.dictLabel"
                :value="dictData.id"
                :key="dictData.id"/>
          </el-select>
      </el-form-item>
      <el-form-item>
        <el-button  type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>
  </el-card>
  <!-- 工具栏 -->
  <div class="toolbar">
    <el-button type="primary" @click="handleAdd">新增工单</el-button>
    <el-button type="danger" @click="handlebathDelete">删除</el-button>
  </div>
  <!-- 列表 -->
  <el-card class="table-card">
    <el-table
        :data="reportList"
        border
        stripe
        @selection-change="handleSelectionChange"
    >
      <el-table-column
          type="selection"
          width="55">
      </el-table-column>
      <el-table-column prop="reportCode" label="报工单号"/>
      <el-table-column prop="typeId" label="报工类型">
        <template #default="scope">
          {{scope.row.typeId == 1?'自行报工':'统一报工'}}
        </template>
      </el-table-column>
      <el-table-column prop="stationName" label="工作站"/>
      <el-table-column prop="processName" label="工序"/>
      <el-table-column prop="productionOrderCode" label="生产工单编号"/>
      <el-table-column prop="materialCode" label="产品物料编码"/>
      <el-table-column prop="materialName" label="产品物料名称"/>
      <el-table-column prop="material.specification" label="规格"/>
      <el-table-column prop="material.unit.name" label="单位"/>
      <el-table-column prop="reportNum" label="报工数量"/>
      <el-table-column prop="createBy" label="报工人"/>
      <el-table-column prop="createTime" label="报工时间"/>
      <el-table-column prop="reviewBy" label="审核人"/>
      <el-table-column prop="status" label="状态">
        <template #default="scope">
          {{scope.row.status == 39?'草稿':scope.row.status == 40?'待审核':'已完成'}}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="scope">
          <el-button size="small" v-if="scope.row.status == 39" @click="handleEdit(scope.row.id)">编辑</el-button>
          <el-button
              v-if="scope.row.status ==39 " size="small" type="danger" @click="handleDelete(scope.row.id)">删除
          </el-button>
          <el-button size="small" type="success" v-if="scope.row.status == 39" @click="handleConfirm(scope.row.id)">提交</el-button>
          <el-button size="small" type="warning" v-if="scope.row.status == 40" @click="handleCheck(scope.row.id)">审核</el-button>
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
    <el-form v-model="ReportForm">
      <el-form-item label="报工类型">
        <el-select v-model="ReportForm.typeId" placeholder="请选择报工类型">
          <el-option label="自行报工" value="1" />
          <el-option label="统一报工" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item label="报工单号">
        <el-input v-model="ReportForm.reportCode" />
      </el-form-item>

      <el-form-item label="生产工单">
        <el-input v-model="ReportForm.productionOrderCode" placeholder="请选择工单">
        <template #append>
          <el-button  @click="orderFormVisible= true">选择</el-button>
        </template>
        </el-input>
      </el-form-item>
      <el-form-item label="工作站">
        <el-input v-model="ReportForm.stationName" placeholder="请选择工作站" >
          <template #append>
            <el-button  @click="stationFormVisible = true">选择</el-button>
          </template>
        </el-input>
      </el-form-item>
      <el-form-item label="生产任务">
        <el-input v-model="ReportForm.taskCode" />
      </el-form-item>
      <el-form-item label="产品编码">
        <el-input v-model="ReportForm.materialCode" />
      </el-form-item>
      <el-form-item label="产品名称">
        <el-input v-model="ReportForm.materialName" />
      </el-form-item>
      <el-form-item label="单位">
        <el-input v-model="ReportForm.material.unit.name" />
      </el-form-item>
      <el-form-item label="规格">
        <el-input v-model="ReportForm.material.specification" />
      </el-form-item>
      <el-form-item label="报工数量">
        <el-input v-model="ReportForm.reportNum" />
      </el-form-item>
      <el-form-item label="报工人">
        <el-input v-model="ReportForm.createBy" />
      </el-form-item>
      <el-form-item label="报工时间" >
        <el-date-picker
            v-model="ReportForm.createTime"
            type="datetime"
            placeholder="请选择开始时间"
            format="YYYY-MM-DD HH:mm:ss"
            value-format="YYYY-MM-DD HH:mm:ss"
            style="width: 30%;"
        />
      </el-form-item>
      <el-form-item label="审核人">
        <el-input v-model="ReportForm.reviewBy" />
      </el-form-item>
      <el-form-item label="备注">
        <el-input v-model="ReportForm.remark" />
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="cancelAddOrUpdate">取消</el-button>
        <el-button v-if="!isCheck"  type="primary" @click="submitProductionOrderForm">确定</el-button>
        <el-button v-if="isCheck" type="warning" @click="submitCheck">审核</el-button>
        <el-button v-if="isCheck" type="default" @click="cancelCheck">打回草稿</el-button>
      </span>
    </template>
  </el-dialog>



  <!--  选择工作站弹窗-->
  <el-dialog
      title="工作站"
      v-model="stationFormVisible"
      width="80%">
    <!-- 2. 监听子组件触发的 'select' 和 'cancel' 事件 -->

    <station-toal
        @select="onStationSelected"
        @cancel="stationFormVisible = false"
    />

  </el-dialog>
  <!--  选择工单弹窗-->
  <el-dialog
      title="工单选择"
      v-model="orderFormVisible"
      width="80%">
    <!-- 2. 监听子组件触发的 'select' 和 'cancel' 事件 -->

   <gongdan
       @select="onGongdanSelected"
       @cancel="orderFormVisible = false"
   ></gongdan>

  </el-dialog>

</template>

<script setup>
// 导入必须的内容
import {ref,onMounted} from "vue";
import {ElMessage,ElMessageBox} from "element-plus";
import {
  getProductionOrder,
  addProductionOrder,
  updateProductionOrder,
  confirmProductionOrder,
  deleteProductionOrder,
  getProductionOrderBom,
  generateProductionOrderCode, auditProductionOrder,cancleProductionOrder
} from "@/api/production-order-api.js";
// 导入字典相关的API
import {getDictDataList} from "@/api/dictData.js";
import Supplierdigo from "@/views/pro/production-order/supplierdigo.vue";
import Material from "@/views/pro/production-order/material.vue";
import * as row from "element-plus/es/locale/index";
import MaterialBomList from "@/views/pro/production-order/MaterialBomList.vue";
import {
  addReport,
  auditReport, batchDelete,
  cancleReport,
  confirmReport,
  deleteReport,
  getList,
  getReport,
  updateReport
} from "@/api/feedback.js";
import Station from "@/views/pro/proschedule/station.vue";
import {batchDeleteProcess} from "@/api/allDoneOrder.js";
import StationToal from "@/views/pro/feedback/stationToal.vue";
import Gongdan from "@/views/pro/feedback/gongdan.vue";

// ----- 属性声明 ↓
// 绑定搜索表单的数据
const searchForm = ref({
  typeId:"",
  stationName:"",
  productionOrderCode:"",
  materialCode:"",
  materialName:"",
  createBy:"",
  reviewBy:"",
  status:"",

})
// 工单列表数据

const reportList = ref([]);
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
const orderFormVisible=ref(false)
const supplierFormVisible=ref(false)
const materialFormVisible=ref(false)

// 新增/编辑表单的数据绑定对象
let ReportForm = ref({
  id: "",
  reportCode: "",
  typeId:"" ,
  taskCode: "",
  stationName: "",
  processName: "",
  productionOrderCode: "",
  materialCode: "",
  materialName: "",
  status:39,
  reportNum:"" ,
  createTime: "",
  createBy: "",
  reviewBy: "",
  remark: "",
  updateTime: "",
  updateBy: "",
  deleteFlag:"" ,
  material:{
    specification:"",

    unit: {
      name:"",
    },
  }
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
  { value: 36, label: '自产'},
  { value: 37, label: '外协'},
  { value: 38, label: '外购'},
]);
const handleChange = (value) => {
  console.log(value);
  productionOrderForm.productionOrderQuantity=value
};
// 是否自动生成编号标记
const isAutoCode = ref(false);
// 是否是显示详情的标记
const isDetail = ref(false);
//编辑标记
let isEdit =ref(false)
//工作站选择标记
const stationFormVisible=ref(false)
//审核标记
const isCheck=ref(false)
// 工单类型字典列表
const productionOrderTypeDictDataList = ref([]);
// 工单状态点列表
const productionOrderStatusDictDataList = ref([]);
//批量删除列表
const multipleSelection = ref([]);
// ----- 属性声明 ↑
// -- 函数声明 ↓
const loadProductionOrderStatusDictDataList=()=>{
  getDictDataList({dictType:"PRODUCTION_ORDER_STATUS"}).then(res=>{
    productionOrderStatusDictDataList.value = res.data.records;
  })
}

// 加载工单类型字典的函数
const loadProductOrderDictDataList=()=>{
  getDictDataList({dictType:"PRODUCTION_ORDER_TYPE"}).then(res=>{
    productionOrderTypeDictDataList.value = res.data.records;
  })
}



// 提交新增/编辑表单的按钮事件
const submitProductionOrderForm = ()=>{
  const submitData = { ...ReportForm.value };
  if (isEdit.value==true){
    // 新增工单
    addReport(submitData).then((res) => {
      // 检查返回结果是否真正成功
      if (res && res.code === 200) {
        ElMessage.success('新增成功');
        addOrUpdateDialogVisable.value = false;
        handleSearch();
      } else {
        // 处理业务错误
        console.error('新增工单失败：', res?.msg || '未知错误');
        ElMessage.error(res?.msg || '新增工单失败');
      }
    })

  }
  else {
    // 编辑工单
    updateReport(submitData).then((res) => {
      // 检查返回结果是否真正成功
      if (res && res.code === 200) {
        ElMessage.success('修改成功');
        addOrUpdateDialogVisable.value = false;
        handleSearch();
      } else {
        // 处理业务错误
        console.error('修改工单失败：', res?.msg || '未知错误');
        ElMessage.error(res?.msg || '修改工单失败');
      }
    })
  }
}
const submitCheck=()=> {
  ReportForm.value.status=39;
  const submitData = {...ReportForm.value};
  auditReport(submitData.id).then((res) => {
    if (res && res.code === 200) {
      ElMessage.success('审核成功');
      addOrUpdateDialogVisable.value = false;
      handleSearch();
    } else {
      console.error('审核工单失败：', res?.msg || '未知错误');
      ElMessage.error(res?.msg || '审核工单失败');
    }
    isCheck.value = false
  });
}
const cancelCheck=()=>{

  const submitData = { ...ReportForm.value };
  cancleReport(submitData.id).then((res) => {
    if (res && res.code === 200) {
      ElMessage.success('打回草稿成功');
      addOrUpdateDialogVisable.value = false;
      handleSearch();
    } else {
      console.error('打回失败：', res?.msg || '未知错误');
      ElMessage.error(res?.msg || '打回失败');
    }
    isCheck.value=false
  });

}
// 取消新增/编辑的事件
const cancelAddOrUpdate = ()=>{
  addOrUpdateDialogVisable.value = false;
  isCheck.value=false;
  isEdit.value=false;
  resetForm()
}
// 自动生成编号的事件
const autoCode = ()=>{

}
// 新增工单的按钮事件
const handleAdd = ()=>{
  isEdit.value=true
  dialogTitle="新增工单"
  resetForm()

  addOrUpdateDialogVisable.value = true;
}
const handleSelectionChange=(val)=>{
  multipleSelection.value = val;

}

const handlebathDelete=()=>{
  const ids = multipleSelection.value.map(item => item.id);
  batchDelete(ids).then(res=>{
    if (res.code === 200 && res.success)
      ElMessage.success("删除成功")
    else ElMessage.error("删除失败")+
    handleSearch();
    multipleSelection.value = [];
  })
}
//行级别删除按钮
const handleDelete = (id) => {
  ElMessageBox.confirm(
      `确定删除工单编号为"${id}"的数据项？`,
      '警告',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
  ).then(() => {
    return deleteReport(id);
  }).then(() => {
    ElMessage.success('删除成功');
    handleSearch();
  }).catch(error => {
    if (error !== 'cancel') {
      console.error('删除工单失败：', error);
      ElMessage.error('删除工单失败');
    }
  });
};

//行编辑事件
const handleEdit=(id)=>{
  isEdit.value=false
  resetForm();
  dialogTitle="编辑工单"
  getReport(id).then(res => {
    ReportForm.value = res.data;
    addOrUpdateDialogVisable.value = true;
  })
};
//行级别提交事件
const handleConfirm=(id)=>{
  confirmReport(id).then(res=>{
    if (res && res.code === 200) {
      ElMessage.success('确认成功');
      handleSearch();
    } else {
      console.error('确认工单失败：', res?.msg || '未知错误');
      ElMessage.error(res?.msg || '确认工单失败');
    }
  })
};
//行审核事件
const handleCheck=(id)=>{
  isCheck.value=true
  dialogTitle="审核工单"
  resetForm();
  getReport(id).then(res => {
    ReportForm.value = res.data;
    addOrUpdateDialogVisable.value = true;
  })


};
//选择工作站
const onStationSelected = (station) => {
  console.log("选中的物料:", station);
  ReportForm.value.stationName = station.name;
  stationFormVisible.value = false;
}
const onGongdanSelected = (gongDan) => {
  console.log("选中的工单:", gongDan);
  ReportForm.value.productionOrderCode = gongDan.productionOrderCode;
  ReportForm.value.materialCode=gongDan.materialCode;
  ReportForm.value.materialName=gongDan.name;
  ReportForm.value.material.unit.name=gongDan.unitName;
  ReportForm.value.material.specification=gongDan.specification;

  orderFormVisible.value = false;
}




// 改变了每页大小的事件
const handleSizeChange =(pageSize)=>{
  pagination.value.pageSize = pageSize;
  handleSearch();
}
// 改变页面的事件  翻页事件
const handleCurrentChange =(newPage)=>{
  pagination.value.currentPage = newPage;
  handleSearch();
}
// 搜索数据的事件
const handleSearch=()=> {

  let params = {

  };
  params = searchForm.value;// 这里只包含了搜索条件，没有分页参数
  params.pageNum = pagination.value.currentPage;
  params.pageSize = pagination.value.pageSize;
  getList(params).then(res=>{
    reportList.value = res.data.list;
    pagination.value.total = res.data.total;
  })


}
const resetForm = () => {
  ReportForm.value = {
    id: "",
    reportCode: "",
    typeId: "",
    taskCode: "",
    stationName: "",
    processName: "",
    productionOrderCode: "",
    materialCode: "",
    materialName: "",
    status:39,
    reportNum: "",
    createTime: "",
    createBy: "",
    reviewBy: "",
    remark: "",
    updateTime: "",
    updateBy: "",
    deleteFlag: "",
    material: {
      specification: "",

      unit: {
        name: "",
      },
    }
  };
};
// -- 函数声明 ↑
onMounted(()=>{
  loadProductionOrderStatusDictDataList();
  loadProductOrderDictDataList();
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