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
          :data="workflowProductList"
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
                    prop="product.code"
                    label="产品物料编码"/>
            <el-table-column
                    fixed="left"
                    prop="product.name"
                    label="产品物料名称"/>
            <el-table-column
                    fixed="left"
                    prop="product.specification"
                    label="规格"/>
            <el-table-column
                    prop="product.unit.name"
                    label="单位">
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
  <el-dialog title="新增关联产品/添加产品制程" v-model="addProductdialogVisible">
      <el-form ref="workflowProductFormRef" :model="workflowProductForm" label-width="auto">
          <el-row>
              <el-col :span="8">
                  <el-form-item label="产品物料编码">
                      <el-input v-model="workflowProductForm.product.code" placeholder="产品物料编码">
                          <template #append>
                              <el-button @click="showProductList"><el-icon><Search /></el-icon></el-button>
                          </template>
                      </el-input>
                  </el-form-item>
              </el-col>
              <el-col :span="8">
                  <el-form-item label="产品物料名称">
                      <el-input v-model="workflowProductForm.product.name" disabled placeholder="产品物料名称"/>
                  </el-form-item>
              </el-col>
              <el-col :span="8">
                  <el-form-item label="单位">
                      <el-input v-model="workflowProductForm.product.unit.name" disabled placeholder="单位"/>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span="24">
                  <el-form-item label="规格型号">
                    <el-input type="textarea" v-model="workflowProductForm.product.specification" disabled placeholder=""/>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-row>
              <el-col :span="24">
                  <el-form-item label="备注">
                      <el-input type="textarea" v-model="workflowProductForm.remarks" placeholder=""/>
                  </el-form-item>
              </el-col>
          </el-row>

      </el-form>
      <template #footer>
        <el-button @click="cancelAddOrUpdate">取消</el-button>
        <el-button type="primary" @click="handlerSubmit">保存</el-button>
      </template>
  </el-dialog>


  <el-dialog v-model="productListDialogVisable" title="选择产品物料" width="80%">
    <ProductList @select-product="handlerSelectProduct"/>
  </el-dialog>

</template>

<script setup>
import { ref, reactive, toRaw, watch, onMounted } from 'vue'
import {getWorkflowProductPage,getWorkflowProductById,addWorkflowProduct,updateWorkflowProduct,deleteWorkflowProduct,batchDeleteWorkflowProduct} from "@/api/workflowProduct.js";
import {getDictDataList} from "@/api/dictData.js";
import {getProcessList} from "@/api/process.js";
import {ElMessage,ElMessageBox} from "element-plus";
import ProductList from "@/views/pro/workflow/product-list.vue";
import {getMaterialByCode} from "@/api/material.js";

const workflowProductList = ref([])
const total = ref(0)
const page = ref(1)
const size = ref(10)
const addProductdialogVisible = ref(false);

const workflowProductForm = reactive({
    product:{unit:{}},
    productCode:'',
    remarks:'',
    workflowId:'',
    id:''
})
const relationNextList = ref([])
const relationNextContent = ref([])
const isEdit = ref(false);
const selectedRows = ref([]);
const isCanDelete = ref(true)
const productListDialogVisable = ref(false);

const props = defineProps({
  workflowId: {
    type: Number
  }
})
const processList = ref([])
watch(() => props.workflowId, (newValue, oldValue) => {
  if (newValue) {
    getworkflowProductList()
  }
})

const handlerSelectProduct = (productCode)=>{
    getMaterialByCode(productCode).then(res=>{
        console.log(res);
        workflowProductForm.product = res.data
        productListDialogVisable.value = false;
    })
}
const showProductList = ()=>{
    productListDialogVisable.value = true;
    console.log("???")
}

onMounted(()=>{
    getworkflowProductList();
})

const handleSelectionChange = (srs)=>{
    selectedRows.value = [];
    srs.forEach(row=>{
        selectedRows.value.push(row);
    })
    console.log(selectedRows.value)
  if(selectedRows.value.length > 0){
      isCanDelete.value = false;
  }else{
      isCanDelete.value = true;
  }
}

const handlerDeletes = ()=>{
    ElMessageBox.confirm(
        `确定要删除选中的 关联产品 吗？`,
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
        batchDeleteWorkflowProduct(params).then(res=>{
            ElMessage.success('删除成功')
            getworkflowProductList();
        })
    }).catch(() => {
        ElMessage.info('已取消删除')
    })
}

const handleDelete = (row)=>{
    ElMessageBox.confirm(
        `确定要删除选中的 ${row.product.name} 吗？`,
        '确认删除',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        }
    ).then(() => {
       deleteWorkflowProduct(row.id).then(res=>{
           if (res.code == 200){
               ElMessage.success("删除完成");
               getworkflowProductList();
           }else{
               ElMessage.error("删除失败")
           }
       })
    }).catch(() => {
        ElMessage.info('已取消删除')
    })
}

const handleEdit = (row)=>{
    getWorkflowProductById(row.id).then(res=>{
            workflowProductForm.id = res.data.id
            workflowProductForm.workflowId = res.data.workflowId
            workflowProductForm.productCode = res.data.productCode
            workflowProductForm.remarks = res.data.remarks
            workflowProductForm.product = res.data.product
    });
    addProductdialogVisible.value = true;
    isEdit.value = true;
    getDictDataList({dictType: 'process_next_relation', pageNum: 1, pageSize: 1000})
        .then(res=>{
            relationNextList.value = res.data.list;
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
    workflowProductForm.productCode = workflowProductForm.product.code;
    if (workflowProductForm.id) {
      updateWorkflowProduct(workflowProductForm)
        .then(res => {
            if (res.code == 200){
                ElMessage.success("修改流程成功");
                getworkflowProductList()
                cancelAddOrUpdate();
            }else{
                ElMessage.error(res.msg);
            }
        })
    } else {
      addWorkflowProduct(workflowProductForm)
        .then(res => {
            if (res.code == 200){
                ElMessage.success("修改流程成功");
                getworkflowProductList()
                cancelAddOrUpdate();
            }else{
                ElMessage.error(res.msg);
            }
        })
    }
}
const cancelAddOrUpdate = () => {
  addProductdialogVisible.value = false
    workflowProductForm.id = ''
    workflowProductForm.workflowId = ''
    workflowProductForm.productCode = ''
    workflowProductForm.remarks = ''
    workflowProductForm.product = {unit:{}}
}

const handlerAdd = () => {
    getDictDataList({dictType: 'process_next_relation', pageNum: 1, pageSize: 1000})
        .then(res=>{
            relationNextList.value = res.data.list;
            relationNextContent.value = [];
            res.data.list.forEach(item=>{
                relationNextContent.value.push(item.dictLabel + ':' + item.remark)
            })
        })
    getProcessList({pageNum: 1, pageSize: 1000})
    .then(res=>{
        processList.value = res.data.list;
    })
  addProductdialogVisible.value = true
  workflowProductForm.workflowId = props.workflowId
}

const getworkflowProductList = () => {
  getWorkflowProductPage(page.value, size.value, {
    workflowId: props.workflowId
  }).then(res => {
    workflowProductList.value = res.data.list
    total.value = res.data.total
  })
}

</script>

<style scoped>

</style>