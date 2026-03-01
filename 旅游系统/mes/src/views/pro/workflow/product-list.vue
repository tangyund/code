<template>
<el-row style="margin:15px">
    <el-form inline v-model="searchForm">
        <el-form-item label="物料产品编码">
            <el-input v-model="searchForm.code" placeholder="物料产品编码"/>
        </el-form-item>
        <el-form-item label="物料产品名称">
            <el-input v-model="searchForm.name" placeholder="物料产品名称"/>
        </el-form-item>
        <el-form-item>
            <el-button size="small" @click="loadProductList" >搜索</el-button>
        </el-form-item>
    </el-form>
</el-row>
  <el-row style="margin:15px">
      <el-radio-group v-model="selectedProductCode" style="width: 100%">
        <el-table
          :data="productList"
          stripe
          border
          width="100%"
        >
            <el-table-column>
                <template #default="scope">
                  <el-radio :value="scope.row.code"/>
                </template>
            </el-table-column>
            <el-table-column prop="code" label="产品物料编码"/>
            <el-table-column prop="name" label="产品物料编码"/>
            <el-table-column prop="specification" label="产品物料编码"/>
            <el-table-column prop="unit.name" label="单位"/>
            <el-table-column prop="category.name" label="分类"/>
        </el-table>
      </el-radio-group>
  </el-row>
  <el-row>
      <el-button @click="doSelectProduct">确定</el-button>
  </el-row>
</template>

<script setup>
import {ref,watch,onMounted} from "vue";
import {getMaterialPage} from "@/api/material.js";

const searchForm = ref({
    code:'',
    name:''
});
const selectedProductCode = ref(-1);
const productList = ref([]);

const emit = defineEmits(["selectProduct"]);

const loadProductList = ()=>{
    getMaterialPage(1,10000,searchForm.value).then(res=>{
        productList.value = res.data.list;
    })
}
loadProductList();


const doSelectProduct = ()=>{
    emit("selectProduct",selectedProductCode.value);
}


onMounted(()=>{
    loadProductList();
})

</script>

<style scoped>

</style>