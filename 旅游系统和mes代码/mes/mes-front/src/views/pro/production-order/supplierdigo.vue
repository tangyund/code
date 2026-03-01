<template>
  <div class="customer-container">
    <!-- 搜索栏部分 -->
    <el-card class="search-card">
      <el-form :model="searchForm" label-width="80px" inline>
        <el-form-item label="供应商编码">
          <el-input v-model="searchForm.code" placeholder="供应商编码" clearable />
        </el-form-item>
        <el-form-item label="供应商名">
          <el-input v-model="searchForm.name" placeholder="供应商名" clearable />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" style="width:100px" placeholder="请选择状态" clearable>
            <el-option label="启用" value="1" />
            <el-option label="禁用" value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 工具栏部分 -->
    <div class="toolbar">
      <!-- 修改为选择按钮 -->
      <el-button type="primary" @click="handleSelect" :disabled="selectedCustomers.length !== 1">
        选择此供应商
      </el-button>
      <el-button @click="handleCancel">取消</el-button>
    </div>

    <!-- 列表 -->
    <el-card class="table-card">
      <el-table
          :data="supplierList"
          border
          stripe
          @selection-change="handleSelectionChange"
          :row-key="row => row.id"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="code" label="供应商编号" />
        <el-table-column prop="name" label="供应商名" />
        <el-table-column prop="address" label="供应商地址" />
        <el-table-column prop="contactPerson" label="联系人" />
        <el-table-column prop="phone" label="联系电话" />
        <el-table-column prop="fax" label="传真" />
        <el-table-column prop="email" label="邮箱" />
        <el-table-column prop="createTime" label="创建时间" width="180" />
        <el-table-column prop="status" label="状态" width="80">
          <template #default="scope">
            <el-tag :type="scope.row.status == '1' ? 'success' : 'danger'">
              {{ scope.row.status == '1' ? '启用' : '禁用' }}
            </el-tag>
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

  </div>
</template>

<script setup>
import { ref, reactive, onMounted, defineEmits } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getSupplierPage } from "@/api/supplier.js";

// 定义回调事件，用于向父组件传递选择结果
const emit = defineEmits(['select', 'cancel'])

// 搜索表单
const searchForm = reactive({
  code: '',
  name: '',
  status: ''
})

// 分页信息
const pagination = reactive({
  currentPage: 1,
  pageSize: 10,
  total: 0
})

// 供应商列表数据
const supplierList = ref([])

// 选中的供应商
const selectedCustomers = ref([])

// 处理搜索
const handleSearch = () => {
  getSupplierPage(pagination.currentPage, pagination.pageSize, searchForm).then(res => {
    supplierList.value = res.data.list;
    pagination.total = res.data.total;
  })
}

// 重置搜索
const resetSearch = () => {
  searchForm.code = ''
  searchForm.name = ''
  searchForm.status = ''
  handleSearch()
}

// 处理选择供应商
const handleSelect = () => {
  if (selectedCustomers.value.length !== 1) {
    ElMessage.warning('请选择一个供应商')
    return
  }

  const selected = selectedCustomers.value[0]
  // 向父组件发送选择的供应商信息，包含编号
  emit('select', {
    id: selected.id,
    code: selected.code,
    name: selected.name
  })
}

// 处理取消选择
const handleCancel = () => {
  emit('cancel')
}

// 处理选中项变化
const handleSelectionChange = (selection) => {
  // 限制只能选择一个
  if (selection.length > 1) {
    // 保留最后一个选中项
    selectedCustomers.value = [selection.pop()]
  } else {
    selectedCustomers.value = selection
  }
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

// 初始化数据
onMounted(() => {
  handleSearch();
})

</script>

<style scoped>
.customer-container {
  padding: 20px;
}

.search-card {
  margin-bottom: 20px;
}

.toolbar {
  margin-bottom: 20px;
  display: flex;
  gap: 10px;
}

.table-card {
  margin-bottom: 20px;
}

.pagination-container {
  display: flex;
  justify-content: flex-end;
}
</style>
