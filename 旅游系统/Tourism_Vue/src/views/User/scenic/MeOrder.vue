<template>
  <div class="menu-list">
    <!-- 搜索表单 -->
    <div class="search-form">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="菜品名称">
          <el-input v-model="searchForm.name" placeholder="请输入菜品名称" />
        </el-form-item>
        <el-form-item label="描述">
          <el-input v-model="searchForm.description" placeholder="请输入描述" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 操作按钮 (移除添加按钮)-->
    <!-- <div class="operation-bar">
      <el-button type="primary" @click="handleAdd">添加菜单</el-button>
    </div> -->

    <!-- 菜单列表表格 -->
    <div class="table-container">
      <el-table :data="menuList" v-loading="loading" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="name" label="菜品名称" />
        <el-table-column prop="description" label="描述" />
        <el-table-column prop="price" label="价格" />
        <el-table-column label="操作" width="100">
          <template #default="scope">
            <!-- 移除编辑按钮 -->
            <!-- <el-button type="primary" link @click="handleEdit(scope.row)"
              >编辑</el-button
            > -->
            <el-button type="success" link @click="handleOrder(scope.row)"
              >下单</el-button
            >
          </template>
        </el-table-column>
      </el-table>
    </div>

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

    <!-- 添加/编辑对话框 (移除)-->
    <!-- <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '添加菜单' : '编辑菜单'"
      width="500px"
    >
      <el-form
        ref="menuFormRef"
        :model="menuForm"
        :rules="rules"
        label-width="80px"
      >
        <el-form-item label="菜单名称" prop="name">
          <el-input v-model="menuForm.name" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="menuForm.description" />
        </el-form-item>
        <el-form-item label="价格" prop="price">
          <el-input-number v-model="menuForm.price" :min="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="submitForm">确定</el-button>
      </template>
    </el-dialog> -->

    <!-- 下单对话框 -->
    <el-dialog v-model="orderDialogVisible" title="下单" width="40%">
      <div class="order-dialog-content">
        <el-form :model="orderForm" label-width="100px">
          <el-form-item label="用户名称">
            <el-input v-model="orderForm.userName" :disabled="true" />
          </el-form-item>

          <el-form-item label="菜单名称">
            <el-input v-model="orderForm.foodName" :disabled="true" />
          </el-form-item>

          <el-form-item label="数量">
            <el-input-number v-model="orderForm.quantity" :min="1" />
          </el-form-item>

          <el-form-item label="总价">
            <el-input v-model="orderForm.totalPrice" :disabled="true" />
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="orderDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="submitOrder">确认下单</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted, computed, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import api from '@/api/api'

// 数据定义
const loading = ref(false)
const menuList = ref([])
const total = ref(0)
const currentPage = ref(1)
const pageSize = ref(10)
// const dialogVisible = ref(false) // 移除
// const dialogType = ref('add') // 移除
// const menuFormRef = ref(null) // 移除
const orderDialogVisible = ref(false)
const orderForm = ref({
  userName: '',
  foodName: '',
  quantity: 1,
  totalPrice: 0,
})

// 获取用户信息
const userInfo = computed(() => {
  const storedUser = localStorage.getItem('userInfo')
  return storedUser ? JSON.parse(storedUser) : null
})

// 搜索表单
const searchForm = ref({
  name: '',
  description: '',
})

// 菜单表单 (移除)
// const menuForm = ref({
//   name: '',
//   description: '',
//   price: 0,
// })

// 表单验证规则 (移除)
// const rules = {
//   name: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
//   price: [{ required: true, message: '请输入价格', trigger: 'blur' }],
// }

// 获取菜单列表
const getMenuList = async () => {
  loading.value = true
  try {
    const params = {
      page: currentPage.value,
      pageSize: pageSize.value,
      ...searchForm.value,
    }
    const res = await api.get('/api/admin/menu/list', params)
    menuList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('获取菜单列表失败:', error)
    ElMessage.error('获取菜单列表失败')
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  getMenuList()
}

// 重置搜索
const resetSearch = () => {
  searchForm.value = {
    name: '',
    description: '',
  }
  handleSearch()
}

// 添加菜单 (移除)
// const handleAdd = () => {
//   dialogType.value = 'add'
//   menuForm.value = {
//     name: '',
//     description: '',
//     price: 0,
//   }
//   dialogVisible.value = true
// }

// 编辑菜单 (移除)
// const handleEdit = (row) => {
//   dialogType.value = 'edit'
//   menuForm.value = { ...row }
//   dialogVisible.value = true
// }

// 提交表单 (移除)
// const submitForm = async () => {
//   if (!menuFormRef.value) return

//   await menuFormRef.value.validate(async (valid) => {
//     if (valid) {
//       try {
//         const payload = {
//           ...menuForm.value,
//         }
//         if (dialogType.value === 'add') {
//           await api.post('/api/admin/menu/add', payload)
//           ElMessage.success('添加成功')
//         } else {
//           await api.put('/api/admin/menu/update', payload)
//           ElMessage.success('更新成功')
//         }
//         dialogVisible.value = false
//         getMenuList()
//       } catch (error) {
//         console.error('操作失败:', error)
//         ElMessage.error('操作失败')
//       }
//     }
//   })
// }

// 分页大小改变
const handleSizeChange = (val) => {
  pageSize.value = val
  getMenuList()
}

// 页码改变
const handleCurrentChange = (val) => {
  currentPage.value = val
  getMenuList()
}

// 显示下单对话框
const handleOrder = (row) => {
  if (!userInfo.value) {
    ElMessage.warning('请先登录后再下单')
    return
  }

  const selectedMenu = menuList.value.find((item) => item.id === row.id)
  orderForm.value = {
    userName: userInfo.value.username,
    foodName: selectedMenu?.name || '',
    quantity: 1,
    totalPrice: selectedMenu?.price || 0,
  }
  orderDialogVisible.value = true
}

// 监听数量变化，动态计算总价
watch(
  () => orderForm.value.quantity,
  (newQuantity) => {
    const selectedMenu = menuList.value.find(
      (item) => item.name === orderForm.value.foodName
    )
    orderForm.value.totalPrice = (selectedMenu?.price || 0) * newQuantity
  }
)

// 提交订单
const submitOrder = async () => {
  try {
    const orderData = {
      userName: orderForm.value.userName,
      foodName: orderForm.value.foodName,
      quantity: orderForm.value.quantity,
      totalPrice: orderForm.value.totalPrice,
    };
    const res = await api.post('/api/admin/foodOrder/add', orderData);
    console.log('下单接口返回数据:', res);
    if (res && res.data === true) {
      ElMessage.success('下单成功');
      orderDialogVisible.value = false;
    } else {
      ElMessage.error('下单失败');
    }
  } catch (error) {
    console.error('下单失败:', error);
    ElMessage.error('下单失败，请重试');
  }
};

// 初始化
onMounted(() => {
  getMenuList()
})
</script>

<style scoped>
.menu-list {
  padding: 20px;
  height: 100vh; /* 设置高度为视口高度，使滚动条生效 */
  overflow-y: auto; /* 允许垂直滚动 */
}

.search-form {
  margin-bottom: 20px;
}

.operation-bar {
  margin-bottom: 20px;
}

.table-container {
  overflow-x: auto; /* 允许表格横向滚动，如果需要 */
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
