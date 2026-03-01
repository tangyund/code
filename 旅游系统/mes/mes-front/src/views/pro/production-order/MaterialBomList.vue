<template>


  <el-card class="table-card">
    <el-table
        :data="materialList"
        border
        stripe
        :row-key="row => row.id"
    >
      <el-table-column prop="id" label="工单序号" width="250"/>
      <el-table-column prop="code" label="产品编号"width="250"/>
      <el-table-column prop="name" label="产品名称"width="250"/>
      <el-table-column prop="specification" label="产品规格"width="250"/>
      <el-table-column prop="unit.name" label="单位名称"width="250"/>
      <el-table-column prop="quantity" label="预计使用量"width="250"/>
    </el-table>
  </el-card>
  <br/>
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


import { ref, onMounted, watch } from "vue"; // 1. 导入 watch
import { ElMessage } from "element-plus";
import { getMaterialBom } from "@/api/production-order-api.js";

// 定义 props
const props = defineProps({
  materialCode: {
    type: String,
    required: true,
    default: ''
  }
});

// 2. 声明 loading 状态
const loading = ref(false);

// 工单列表数据
const materialList = ref([]);

const pagination = ref({
  currentPage: 1,
  pageSize: 10,
  total: 0
});

const handleSizeChange = (val) => {
  pagination.value.pageSize = val;
  handleSearch();
}

const handleCurrentChange = (val) => {
  pagination.value.currentPage = val;
  handleSearch();
}

const handleSearch = () => {
  if (!props.materialCode) return; // 如果没有code，则不查询

  loading.value = true;

  const pageNum = pagination.value.currentPage;
  const pageSize = pagination.value.pageSize;
  const code = props.materialCode;

  // 3. 修正参数名 size -> pageSize
  getMaterialBom(code,pageNum, pageSize).then(res => {
    materialList.value = res.data.list || [];
    pagination.value.total = res.data.total || 0;
  }).catch(error => {
    console.error('查询物料BOM失败：', error);
    ElMessage.error('查询物料BOM失败');
    materialList.value = [];
    pagination.value.total = 0;
  }).finally(() => {
    loading.value = false;
  });
};

// 监听 materialCode 变化，重新查询
watch(() => props.materialCode, (newCode) => {
  if (newCode) {
    pagination.value.currentPage = 1;
    handleSearch();
  }
});

onMounted(() => {
  handleSearch();
});
</script>