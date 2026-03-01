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

      <el-form-item label="产品编号">
        <el-input v-model="searchForm.materialCode" placeholder="物料编号" clearable />
      </el-form-item>
      <el-form-item label="产品名称">
        <el-input v-model="searchForm.materialName" placeholder="物料名称" clearable />
      </el-form-item>
      <el-form-item label="客户名称">
        <el-input v-model="searchForm.customerName" placeholder="客户名称" clearable />
      </el-form-item>
      <el-form-item>
        <el-button x type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>
  </el-card>
  <!-- 工具栏 -->
  <div class="toolbar">
    <el-button type="primary" @click="handleSelect" :disabled="selectedworkstation.length !== 1">选择产品</el-button>
    <el-button @click="handleCancel">取消</el-button>
  </div>
  <!-- 列表 -->
  <el-card class="table-card">
    <el-table
        :data="productionOrderList"
        border
        stripe
        @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
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
      <el-table-column prop="productionOrderQuantity" label="工单数量"/>
      <el-table-column prop="producedQuantity" label="已生产数量"/>
      <el-table-column prop="customerCode" label="客户编号"/>
      <el-table-column prop="customerName" label="客户名称"/>
      <el-table-column prop="requestDate" label="需求日期"/>
      <el-table-column prop="statusDictData.dictLabel" label="状态">
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="scope">
          <el-button size="small" v-if="scope.row.statusDictData.dictValue == 1" @click="handleEdit(scope.row.id)">编辑</el-button>
          <el-button
              v-if="scope.row.statusDictData.dictValue == 1" size="small" type="danger" @click="handleDelete(scope.row.id)">删除
          </el-button>
          <el-button size="small" type="success" v-if="scope.row.statusDictData.dictValue == 1" @click="handleConfirm(scope.row.id)">提交</el-button>
          <el-button size="small" type="warning" v-if="scope.row.statusDictData.dictValue == 2" @click="handleCheck(scope.row.id)">审核</el-button>
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

</template>

<script setup>
// 导入必须的内容
import {ref, onMounted, defineEmits} from "vue";
import {ElMessage,ElMessageBox} from "element-plus";
import {
  getProductionOrderList,
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

// ----- 属性声明 ↓
// 绑定搜索表单的数据
const searchForm = ref({
  productionOrderCode:"",
  productionOrderName:"",
  materialCode:"",
  materialName:"",
  status:"",
  productionOrderSource:"",
  customerCode:"",
  customerName:"",
  productionOrderType:"",
})
// 工单列表数据
const emit = defineEmits(['select', 'cancel'])
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
const materialFormVisible=ref(false)
const selectedworkstation = ref([])
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
  status: 1,
  remark: ""
})
const materialInfo = ref({
  name: "",
  specification: "",
  unitName: ""
});
const handleSelectionChange = (selection) => {
  // 限制只能选择一个
  if (selection.length > 1) {
    // 保留最后一个选中项
    selectedworkstation.value = [selection.pop()]
  } else {
    selectedworkstation.value = selection
  }
}

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
//审核标记
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

const handleCancel = () => {
  emit('cancel')
  searchForm.value = {
    workstationCode:"",
    processName:"",
    processId:"",
    workshopName:"",
  };
  pagination.value.currentPage = 1;
  handleSearch();
}


// 加载工单类型字典的函数
const loadProductOrderDictDataList=()=>{
  getDictDataList({dictType:"PRODUCTION_ORDER_TYPE"}).then(res=>{
    productionOrderTypeDictDataList.value = res.data.records;
  })
}
const handleSelect = () => {
  if (selectedworkstation.value.length !== 1) {
    ElMessage.warning('请选择一个工单')
    return
  }
  const selected = selectedworkstation.value[0]
  // 向父组件发送选择的供应商信息，包含编号
  emit('select', {
    productionOrderCode: selected.productionOrderCode,
    materialCode: selected.materialCode,
    name: selected.material.name,
    unitName: selected.material.unit.name,
    specification: selected.material.specification,
  })


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
  // 调用查询的接口查询数据
  let params = {

  };// 这里需要组织参数--------------
  // 请求参数就是searchForm.vaue 和  page相关的参数
  params = searchForm.value;// 这里只包含了搜索条件，没有分页参数
  params.pageNum = pagination.value.currentPage;
  params.pageSize = pagination.value.pageSize;
  getProductionOrderList(params).then(res=>{
    productionOrderList.value = res.data.list;
    pagination.value.total = res.data.total;
  })


}
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
    status: 1,
    remark: ""
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