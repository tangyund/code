<template>
  <div class="order-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="食品名称">
          <el-input v-model="searchForm.foodName" placeholder="请输入食品名称" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 -->
    <div class="operation-bar">
      <!-- 移除添加订单和批量删除按钮 -->
    </div>

    <!-- 订单列表表格 -->
    <el-table
      :data="filteredOrderList"
      v-loading="loading"
      border
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="foodName" label="食品名称" />
      <el-table-column prop="orderTime" label="下单时间">
        <template #default="scope">
          {{ formatDateTime(scope.row.orderTime) }}
        </template>
      </el-table-column>
      <el-table-column prop="quantity" label="数量" />
      <el-table-column prop="totalPrice" label="总价" />
      <el-table-column label="操作" width="100">
        <template #default="scope">
          <!-- 移除编辑按钮 -->
          <el-button type="danger" link @click="handleDelete(scope.row)"
            >删除</el-button
          >
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="total"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 添加/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加订单' : '编辑订单'"
      width="500px"
    >
      <el-form
        ref="orderFormRef"
        :model="orderForm"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="食品名称" prop="foodName">
          <el-input v-model="orderForm.foodName" />
        </el-form-item>
        <el-form-item label="数量" prop="quantity">
          <el-input-number v-model="orderForm.quantity" :min="1" />
        </el-form-item>
        <el-form-item label="总价" prop="totalPrice">
          <el-input-number v-model="orderForm.totalPrice" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import api from '@/api/api'
import moment from 'moment';

// 数据定义
const loading = ref(false)
const orderList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const orderFormRef = ref(null)
const selectedOrderIds = ref([])

// 搜索表单
const searchForm = ref({
  foodName: '',
})

// 订单表单
const orderForm = ref({
  foodName: '',
  quantity: 1,
  totalPrice: 0,
})

// 表单验证规则
const rules = {
  foodName: [{ required: true, message: '请输入食品名称', trigger: 'blur' }],
  quantity: [{ required: true, message: '请输入数量', trigger: 'blur' }],
  totalPrice: [{ required: true, message: '请输入总价', trigger: 'blur' }],
}

// 获取用户信息
const userInfo = computed(() => {
  const storedUser = localStorage.getItem('userInfo');
  return storedUser ? JSON.parse(storedUser) : null;
});

// 获取订单列表
const getOrderList = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    }
    const res = await api.get('/api/admin/foodOrder/list', params)
    orderList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('获取订单列表失败:', error)
    ElMessage.error('获取订单列表失败')
  } finally {
    loading.value = false
  }
}

// 过滤订单列表，只显示当前用户订单
const filteredOrderList = computed(() => {
  if (!userInfo.value) {
    return []; // 如果没有用户信息，则不显示任何订单
  }
  return orderList.value.filter(order => order.userName === userInfo.value.username);
});

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  getOrderList()
}

// 重置搜索
const resetSearch = () => {
  searchForm.value = {
    foodName: '',
  }
  handleSearch()
}

// 添加订单
const handleAdd = () => {
  dialogType.value = 'add'
  orderForm.value = {
    foodName: '',
    quantity: 1,
    totalPrice: 0,
  }
  dialogVisible.value = true
}

// 编辑订单
const handleEdit = (row) => {
  dialogType.value = 'edit'
  orderForm.value = {
    ...row,
  };
  dialogVisible.value = true
}

// 提交表单
const submitForm = async () => {
  if (!orderFormRef.value) return;

  await orderFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        const payload = {
          ...orderForm.value,
        };
        if (dialogType.value === 'add') {
          // 添加订单时，添加当前用户名
          payload.userName = userInfo.value.username;
          await api.post('/api/admin/foodOrder/add', payload);
          ElMessage.success('添加成功');
        } else {
          await api.put('/api/admin/foodOrder/update', payload);
          ElMessage.success('更新成功');
        }
        dialogVisible.value = false;
        getOrderList();
      } catch (error) {
        console.error('操作失败:', error);
        ElMessage.error('操作失败');
      }
    }
  });
};


// 删除订单
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm('确认删除该订单吗？', '提示', {
      type: 'warning',
    })
    await api.del(`/api/admin/foodOrder/delete/${row.id}`)
    ElMessage.success('删除成功')
    getOrderList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// 批量删除订单
const handleBatchDelete = async () => {
  if (selectedOrderIds.value.length === 0) {
    ElMessage.warning('请选择要删除的订单')
    return
  }
  try {
    await ElMessageBox.confirm('确认批量删除选中的订单吗？', '提示', {
      type: 'warning',
    })
    await api.post('/api/admin/foodOrder/batch', {
      data: selectedOrderIds.value,
    })
    ElMessage.success('批量删除成功')
    selectedOrderIds.value = []
    getOrderList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('批量删除失败')
    }
  }
}

// 分页大小改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getOrderList()
}

// 页码改变
const handleCurrentChange = (val) => {
  currentPage.value = val
  getOrderList()
}

// 表格选择改变
const handleSelectionChange = (val) => {
  selectedOrderIds.value = val.map((item) => item.id)
}

// 格式化日期
const formatDateTime = (dateTimeString) => {
  if (!dateTimeString) return '';
  return moment(dateTimeString).format('YYYY-MM-DD HH:mm:ss');
};

// 初始化
onMounted(() => {
  getOrderList()
})
</script>

<style scoped>
.order-list {
  padding: 20px;
}

.search-form {
  margin-bottom: 20px;
}

.operation-bar {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
