<template>
  <!-- 搜索栏 -->
  <el-card class="search-card">
    <el-form :model="searchForm" label-width="100px" inline>
      <el-form-item label="工作站编号">
        <el-input v-model="searchForm.workstationCode" placeholder="工作站编号" clearable />
      </el-form-item>
      <el-form-item label="所属工序">
        <el-input v-model="searchForm.processName" placeholder="所属工序" clearable />
      </el-form-item>
      <el-form-item label="工作站名称">
        <el-input v-model="searchForm.workshopName" placeholder="工作站名称" clearable />
      </el-form-item>
      <el-form-item>
        <el-button  type="primary" @click="handleSearch">搜索</el-button>
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
        :data="workstationList"
        border
        stripe
        @selection-change="handleSelectionChange"
        :row-key="row => row.id"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column prop="id" label="工作站序号"/>
      <el-table-column prop="code" label="工作站编号"/>
      <el-table-column prop="name" label="工作站名称"/>
      <el-table-column prop="location" label="工作站地点"/>
      <el-table-column prop="workshopName" label="所在车间名称"/>
      <el-table-column prop="processName" label="所属工序"/>

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
import {getWorkstationAndprocessPage, getWorkstationPage} from "@/api/workstation.js";

import { defineProps } from 'vue';

const props = defineProps({
  // 基础类型（数字）
  itemId: {
    type: Number,
    required: true // 必传参数
  }
});
// 加载状态
const loading = ref(false);
// 用来向父组件传递东西
const emit = defineEmits(['select', 'cancel'])
// 工单列表数据
const workstationList = ref([]);
const selectedworkstation = ref([])

const searchForm = ref({
  workstationCode:"",
  processName:"",
  processId:"",
  workshopName:"",
})
const pagination = ref({
  currentPage: 1,
  pageSize: 10,
  total: 0
});
const resetSearch = () => {
  searchForm.value = {
    workstationCode:"",
    processName:"",
    processId:"",
    workshopName:"",
  };
  pagination.value.currentPage = 1;
  handleSearch();
};
const handleSelect = () => {
  if (selectedworkstation.value.length !== 1) {
    ElMessage.warning('请选择一个供应商')
    return
  }
  const selected = selectedworkstation.value[0]
  // 向父组件发送选择的供应商信息，包含编号
  emit('select', {
    name: selected.name,
    code: selected.code,
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
    selectedworkstation.value = [selection.pop()]
  } else {
    selectedworkstation.value = selection
  }
}
const handleSearch = () => {
  loading.value = true;
  // 搜索时重置到第一页
  pagination.value.currentPage = 1;

  const pageNum = pagination.value.currentPage;
  const size = pagination.value.pageSize;
  // 组织查询参数
  const workstation = {
    code: searchForm.value.workstationCode,
    workshopName: searchForm.value.workshopName,
    processId:props.itemId,
    processName:searchForm.value.processName,
  };

  // 调用实际API（确保接口定义时已添加正确前缀）
  getWorkstationAndprocessPage(pageNum, size, workstation).then(res => {

    workstationList.value = res.data.list || [];
    pagination.value.total = res.data.total || 0;
    loading.value = false;
  }).catch(error => {
    console.error('查询列表失败：', error); // 提示信息也建议从"工单"改为"物料"
    ElMessage.error('查询列表失败');
    workstationList.value = []; // 修复变量名拼写错误
    pagination.value.total = 0;
    loading.value = false;
  });
};


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


onMounted(() => {

  handleSearch();
});


</script>