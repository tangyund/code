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
      <el-form-item label="物料编号">
        <el-input v-model="searchForm.material.code" placeholder="物料编号" clearable />
      </el-form-item>
      <el-form-item label="订单编号">
        <el-input v-model="searchForm.customerOrder.code" placeholder="订单编号" clearable />
      </el-form-item>
      <el-form-item label="状态">
        <el-select style="width: 120px;" v-model="searchForm.status" placeholder="请选择状态" clearable>

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
  <!-- 其他弹窗 -->

  <el-dialog
    :title="dialogTitle"
    v-model="addOrUpdateDialogVisable"
    width="80%">
    <el-form v-model="productionOrderForm">
      <el-form-item label="编号">
        <el-input v-model="productionOrderForm.productionOrderCode"/>
        <el-switch
            @click="autoCode"
          v-model="isAutoCode"
          size="large"
          inline-prompt
          active-text="生成"
          inactive-text="生成"/>
      </el-form-item>
      <el-form-item label="工单名称">
        <el-input v-model="productionOrderForm.productionOrderName"/>
      </el-form-item>
    </el-form>
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="cancelAddOrUpdate">取消</el-button>
        <el-button v-if="!isDetail" type="primary" @click="submitProductionOrderForm">确定</el-button>
      </span>
    </template>
  </el-dialog>

</template>

<script setup>
// 导入必须的内容
import {ref,onMounted} from "vue";
import {ElMessage,ElMessageBox} from "element-plus";
import {getProductionOrderList,getAutoCode,queryByCode,addProductionOrder,deleteProductionOrder,updateProductionOrder,batchDeleteProductionOrder} from "@/api/production-order.js";

// ----- 属性声明 ↓
// 绑定搜索表单的数据
const searchForm = {
  productionOrderCode:"",
  productionOrderName:"",
  material:{code:""},
  customerOrder:{code:''},
  status:""
}
// 工单列表数据
const productionOrderList = ref([])
// 分页相关数据
const pagination = ref({
  currentPage:1,
  pageSize:10,
  total:0
})
// 弹窗的标题
const dialogTitle = "新增工单";
// 弹窗标记
const addOrUpdateDialogVisable = ref(false);
// 编辑标记
const isEdit = ref(false);
// 新增/编辑表单的数据绑定对象
const productionOrderForm = ref({
  //....
})
// 是否自动生成编号标记
const isAutoCode = ref(false);
// 是否是显示详情的标记
const isDetail = ref(false);
// ----- 属性声明 ↑
// -- 函数声明 ↓
// 提交新增/编辑表单的按钮事件
const submitProductionOrderForm = ()=>{

}
// 取消新增/编辑的事件
const cancelAddOrUpdate = ()=>{
  addOrUpdateDialogVisable.value = false;
}
// 自动生成编号的事件
const autoCode = ()=>{

}
// 新增工单的按钮事件
const handleAdd = ()=>{
  //....
  addOrUpdateDialogVisable.value = true;
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
const handleSearch=()=>{
  // 调用查询的接口查询数据
  let params = {};// 这里需要组织参数--------------
  getProductionOrderList(params).then(res=>{
    productionOrderList.value = res.data.list;
    pagination.value.total = res.data.total;
  })
}

// -- 函数声明 ↑
onMounted(()=>{
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