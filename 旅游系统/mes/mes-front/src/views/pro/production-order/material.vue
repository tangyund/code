<template>
  <!-- 搜索栏 -->
  <el-card class="search-card">
    <el-form :model="searchForm" label-width="80px" inline>
      <el-form-item label="工单编号">
        <el-input v-model="searchForm.materialCode" placeholder="物料编号" clearable />
      </el-form-item>
      <el-form-item label="工单名称">
        <el-input v-model="searchForm.materialName" placeholder="物料名称" clearable />
      </el-form-item>
      <el-form-item>
        <el-button x type="primary" @click="handleSearch">搜索</el-button>
        <el-button @click="handleCancel">重置</el-button>
      </el-form-item>
    </el-form>
  </el-card>
  <!-- 工具栏 -->
  <div class="toolbar">
    <el-button type="primary" @click="handleSelect" :disabled="selectedMaterial.length !== 1">选择产品</el-button>
    <el-button @click="handleCancel">取消</el-button>
  </div>
  <!-- 列表 -->
  <el-card class="table-card">
    <el-table
        :data="materialList"
        border
        stripe
        @selection-change="handleSelectionChange"
        :row-key="row => row.id"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column prop="id" label="工单序号"/>
      <el-table-column prop="code" label="产品编号"/>
      <el-table-column prop="name" label="产品名称"/>
      <el-table-column prop="specification" label="产品规格"/>
      <el-table-column prop="status" label="是否启用">
        <template #default="scope">
          {{scope.row.status == 1?'启用':'暂停'}}
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

</template>
<script setup>

import {ref, onMounted, reactive, computed, defineEmits} from "vue";
import {ElMessage, ElMessageBox} from "element-plus";
// 导入物料API
import  {getMaterialPage } from "@/api/material.js";


// 加载状态
const loading = ref(false);
// 用来向父组件传递东西
const emit = defineEmits(['select', 'cancel'])
// 工单列表数据
const materialList = ref([]);
const selectedMaterial = ref([])

const searchForm = ref({
  materialCode:"",
  materialName:""
})
const pagination = ref({
  currentPage: 1,
  pageSize: 10,
  total: 0
});
const resetSearch = () => {
  searchForm.value = {
    materialCode:"",
    materialName:""
  };
  pagination.value.currentPage = 1;
  handleSearch();
};
const handleSelect = () => {
  if (selectedMaterial.value.length !== 1) {
    ElMessage.warning('请选择一个供应商')
    return
  }
  const selected = selectedMaterial.value[0]
  // 向父组件发送选择的供应商信息，包含编号
  emit('select', {
    id: selected.id,
    code: selected.code,
    name: selected.name,
    specification: selected.specification
  })
}

// 处理分页大小变化
const handleSizeChange = (val) => {
  pagination.value.pageSize = val
  handleSearch();
}

// 处理当前页变化
const handleCurrentChange = (val) => {
  pagination.value.currentPage = val
  handleSearch();
}
const handleSelectionChange = (selection) => {
  // 限制只能选择一个
  if (selection.length > 1) {
    // 保留最后一个选中项
    selectedMaterial.value = [selection.pop()]
  } else {
    selectedMaterial.value = selection
  }
}
  const handleSearch = () => {
    loading.value = true;
    // 搜索时重置到第一页
    pagination.value.currentPage = 1;

    const pageNum = pagination.value.currentPage;
    const size = pagination.value.pageSize;
    // 组织查询参数
    const material = {
      materialCode: searchForm.value.materialCode,
      materialName: searchForm.value.materialName
    };

    // 调用实际API（确保接口定义时已添加正确前缀）
    getMaterialPage(pageNum, size, material).then(res => {
      // 修复变量名拼写错误
      materialList.value = res.data.list || [];
      pagination.value.total = res.data.total || 0;
      loading.value = false;
    }).catch(error => {
      console.error('查询物料列表失败：', error); // 提示信息也建议从"工单"改为"物料"
      ElMessage.error('查询物料列表失败');
      materialList.value = []; // 修复变量名拼写错误
      pagination.value.total = 0;
      loading.value = false;
    });
  };


  const handleCancel = () => {
    emit('cancel')
  }


  onMounted(() => {

    handleSearch();
  });


</script>