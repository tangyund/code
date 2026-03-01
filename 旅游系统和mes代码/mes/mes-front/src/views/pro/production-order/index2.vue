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
      <el-form-item label="物料编号">
        <el-input v-model="searchForm.materialCode" placeholder="物料编号" clearable />
      </el-form-item>
      <el-form-item label="物料名称">
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
        <el-button x type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="resetSearch">重置</el-button>
      </el-form-item>
    </el-form>
  </el-card>
  <!-- 工具栏 -->
  <div class="toolbar">
    <el-button type="primary" @click="handleAdd">新增工单</el-button>
  </div>
  <!-- 列表 -->
  <el-card class="table-card">
    <el-table
        :data="productionOrderList"
        border
        stripe
        @selection-change="handleSelectionChange"
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

<!--  新增/编辑弹窗-->
  <el-dialog
      :title="dialogTitle"
      v-model="addOrUpdateDialogVisable"
      width="90%">
    <el-form v-model="productionOrderForm">
      <el-form-item label="编号">
        <el-input v-model="productionOrderForm.productionOrderCode" :disabled="isCheck"/>
        <el-switch
            @click="autoCode"
            v-model="isAutoCode"
            size="large"
            inline-prompt
            active-text="生成"
            inactive-text="生成"/>
      </el-form-item>

      <el-form-item label="工单名称">
        <el-input v-model="productionOrderForm.productionOrderName" :disabled="isCheck"/>
      </el-form-item>

      <el-form-item label="来源类型">
       <el-radio-group v-model="productionOrderForm.productionOrderSource" :disabled="isCheck">
         <el-radio :label="1">客户订单</el-radio>
         <el-radio :label="2">库存备货</el-radio>
       </el-radio-group>
      </el-form-item>

      <el-form-item label="订单编号" v-if="productionOrderForm.productionOrderSource==1">
        <el-input v-model="productionOrderForm.orderCode" :disabled="isCheck"/>
      </el-form-item>
      <el-form-item label="工单类型">
      <el-select v-model="productionOrderForm.productionOrderType" placeholder="工单类型">
        <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :disabled="isCheck"
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
        <el-input v-model="productionOrderForm.materialName" placeholder="产品名称" :disabled="isCheck" readonly />
      </el-form-item>

      <el-form-item label="工单数量">
        <el-input-number v-model="productionOrderForm.productionOrderQuantity" @change="handleChange" :min="1" :max="10" label="工单数量" :disabled="isCheck"></el-input-number>
      </el-form-item>

      <el-form-item label="需求日期">
        <el-date-picker
            v-model="productionOrderForm.requestDate"
            type="date"
            placeholder="请选择需求日期"
            format="YYYY-MM-DD"
            value-format="YYYY-MM-DD"
            :disabled="isCheck">
        </el-date-picker>
      </el-form-item>

      <el-form-item label="工单备注">
        <el-input v-model="productionOrderForm.remark" placeholder="备注" :disabled="isCheck" />
      </el-form-item>



      <el-form-item v-if="isEdit == false" label="Bom组成" >
        <MaterialBomList
            :material-code="productionOrderForm.materialCode"/>
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

<!--  供应商弹窗-->
  <el-dialog
      title="选择供应商"
  v-model="supplierFormVisible"
  width="80%">
  <!-- 2. 监听子组件触发的 'select' 和 'cancel' 事件 -->
  <supplierdigo
      @select="onSupplierSelected"
      @cancel="supplierFormVisible = false"
  />
  </el-dialog>

<!--  物料选择弹窗-->
  <el-dialog
      title="选择物料"
      v-model="materialFormVisible"
      width="80%">
    <!-- 2. 监听子组件触发的 'select' 和 'cancel' 事件 -->
    <material
        @select="onMaterialSelected"
        @cancel="materialFormVisible = false"
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

// 加载工单类型字典的函数
const loadProductOrderDictDataList=()=>{
  getDictDataList({dictType:"PRODUCTION_ORDER_TYPE"}).then(res=>{
    productionOrderTypeDictDataList.value = res.data.records;
  })
}
const onSupplierSelected = (supplier) => {
  // supplier 参数就是子组件 emit 出来的对象 {id, code, name}
  console.log("选中的供应商:", supplier);

  // 2. 将供应商编号回填到表单中
  productionOrderForm.value.supplierCode = supplier.code;
  productionOrderForm.value.supplierName = supplier.name;

  // 3. 关闭供应商选择弹窗
  supplierFormVisible.value = false;
}
const onMaterialSelected = (material) => {
  // supplier 参数就是子组件 emit 出来的对象 {id, code, name}
  console.log("选中的无聊:", material);

  // 2. 将供应商编号回填到表单中
  productionOrderForm.value.materialCode = material.code;
  productionOrderForm.value.materialName = material.name;

  // 3. 关闭供应商选择弹窗
  materialFormVisible.value = false;
}



// 提交新增/编辑表单的按钮事件
const submitProductionOrderForm = ()=>{
  const submitData = { ...productionOrderForm.value };
  if (isEdit.value==true){
    // 新增工单
    addProductionOrder(submitData).then((res) => {
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
    updateProductionOrder(submitData).then((res) => {
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

  const submitData = {...productionOrderForm.value};
  auditProductionOrder(submitData.id).then((res) => {
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

    const submitData = { ...productionOrderForm.value };
    cancleProductionOrder(submitData.id).then((res) => {
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
    return deleteProductionOrder(id);
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
  getProductionOrder(id).then(res => {
    productionOrderForm.value = res.data;

    // 设置关联信息
    if (res.data.material) {
      materialInfo.value = {
        name: res.data.material.name,
        specification: res.data.material.specification,
        unitName: res.data.material.unit ? res.data.material.unit.name : ''
      };
    }

    addOrUpdateDialogVisable.value = true;
  })
};
//行级别提交事件
const handleConfirm=(id)=>{
  confirmProductionOrder(id).then(res=>{
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
  getProductionOrder(id).then(res => {
    productionOrderForm.value = res.data;
    addOrUpdateDialogVisable.value = true;
  })

};


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