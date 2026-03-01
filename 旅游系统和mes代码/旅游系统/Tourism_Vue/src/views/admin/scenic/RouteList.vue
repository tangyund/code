<template>
  <div class="route-container">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-form :inline="true" :model="searchForm">
        <el-form-item label="路线名称">
          <el-input v-model="searchForm.routeName" placeholder="请输入路线名称" clearable />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="resetSearch">重置</el-button>
          <el-button type="success" @click="handleAdd">新增路线</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- 数据表格 -->
    <el-table
      v-loading="loading"
      :data="tableData.data?.records || []"
      border
      style="width: 100%"
    >
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="routeName" label="路线名称" min-width="120" />
      <el-table-column prop="description" label="描述" min-width="180" />
      <el-table-column label="包含景点" min-width="200">
        <template #default="{ row }">
          <el-tag 
            v-for="spot in row.spots" 
            :key="spot.spotId"
            class="mx-1"
          >
            {{ spot.scenicSpot?.name }}
          </el-tag>
          <span v-if="!row.spots?.length">暂无景点</span>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180">
        <template #default="{ row }">
          {{ formatDate(row.createTime) }}
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div style="margin-top: 20px; text-align: right">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="tableData.data?.total || 0"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增路线' : '编辑路线'"
      width="70%"
    >
      <el-form
        ref="formRef"
        :model="formData"
        :rules="formRules"
        label-width="100px"
      >
        <el-form-item label="路线名称" prop="routeName">
          <el-input v-model="formData.routeName" placeholder="请输入路线名称" />
        </el-form-item>
        <el-form-item label="路线描述" prop="description">
          <el-input
            v-model="formData.description"
            type="textarea"
            :rows="3"
            placeholder="请输入路线描述"
          />
        </el-form-item>
        <el-form-item label="选择景点">
  <div class="main-container">
    <!-- 左侧景点列表 -->
    <div class="spot-list">
      <el-table
        :data="spotList"
        height="300"
        style="width: 100%"
        v-loading="!spotList.length"
      >
        <el-table-column type="index" label="序号" width="60" />
        <el-table-column prop="name" label="景点名称" min-width="120" />
        <el-table-column prop="location" label="位置" min-width="120" />
        <el-table-column prop="ticketPrice" label="门票价格" width="100">
          <template #default="{ row }">
            {{ row.ticketPrice }}元
          </template>
        </el-table-column>
        <el-table-column prop="openingHours" label="开放时间" min-width="120" />
        <el-table-column label="操作" width="80" fixed="right">
          <template #default="{ row }">
            <el-button 
              type="primary" 
              link
              @click="addSpotToRoute(row)"
              :disabled="isSpotSelected(row.id)"
            >
              添加
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 右侧已选景点列表 -->
  <div class="selected-spots" style="width: 100%;">
    <h4>已选景点</h4>
    <el-empty v-if="!formData.spots.length" description="暂无选择景点" />
    <el-table
      v-else
      :data="formData.spots"
      class="spot-list"
      height="300"
      style="width: 100%"
    >
      <el-table-column type="index" label="序号"  />
      <el-table-column label="景点名称" >
        <template #default="{ row }">
          {{ row.scenicSpot?.name }}
        </template>
      </el-table-column>
      <el-table-column label="游玩时长" >
        <template #default="{ row }">
          <el-input-number
            v-model="row.visitDuration"
            :min="0.5"
            :max="24"
            :step="0.5"
            size="small"
            controls-position="right"
          />
        </template>
      </el-table-column>
      <el-table-column label="操作"  fixed="right">
        <template #default="{ row, $index }">
          <el-button-group>
            <el-button 
              type="primary" 
              :icon="ArrowUp"
              size="small"
              @click="moveSpot($index, -1)"
              :disabled="$index === 0"
            />
            <el-button 
              type="primary" 
              :icon="ArrowDown"
              size="small"
              @click="moveSpot($index, 1)"
              :disabled="$index === formData.spots.length - 1"
            />
            <el-button
              type="danger"
              size="small"
              @click="removeSpot(row)"
            >
              移除
            </el-button>
          </el-button-group>
        </template>
      </el-table-column>
    </el-table>
  </div>
  </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { ArrowUp, ArrowDown } from '@element-plus/icons-vue'
import { get, post, put, del } from '@/api/api'

// 状态定义
const loading = ref(false)
const tableData = ref({
  code: null,
  msg: null,
  data: {
    countId: null,
    current: 1,
    maxLimit: null,
    optimizeCountSql: true,
    orders: [],
    pages: 0,
    records: [],
    searchCount: true,
    size: 10,
    total: 0
  }
})
const currentPage = ref(1)
const pageSize = ref(10)
const dialogVisible = ref(false)
const dialogType = ref('add')
const spotList = ref([])

// 搜索表单
const searchForm = ref({
  routeName: ''
})

// 表单数据
const formData = ref({
  id: null,
  routeName: '',
  description: '',
  spots: []
})

// 表单规则
const formRules = {
  routeName: [
    { required: true, message: '请输入路线名称', trigger: 'blur' },
    { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  description: [
    { required: true, message: '请输入路线描述', trigger: 'blur' }
  ]
}

// 获取路线列表
const getRouteList = async () => {
  loading.value = true
  try {
    const params = {
      current: currentPage.value,
      size: pageSize.value,
      routeName: searchForm.value.routeName
    }
    console.log('请求参数:', params)
    const res = await get('/api/admin/route/list', params)
    console.log('响应数据:', res)
    
    // 直接赋值整个响应对象
    tableData.value = res
    console.log('处理后的数据:', tableData.value)
  } catch (error) {
    console.error('获取路线列表失败:', error)
    ElMessage.error('获取路线列表失败')
  } finally {
    loading.value = false
  }
}

// 获取景点列表
const getSpotList = async () => {
  try {
    const res = await get('/api/admin/scenicSpot/list', {
      current: 1,
      size: 1000
    })
    console.log('景点列表响应:', res)

    if (res && res.data && Array.isArray(res.data.records)) {

      spotList.value = res.data.records.map(spot => ({
        id: spot.id,
        name: spot.name,
        location: spot.location || '暂无位置信息',
        ticketPrice: spot.ticketPrice || 0,
        openingHours: spot.openingHours || '暂无开放时间',
        description: spot.description || '暂无描述'
      }))
      console.log('处理后的景点列表:', spotList.value)
    } else {
      console.error('景点数据格式不正确:', res)
      ElMessage.warning('获取景点数据格式不正确')
    }
  } catch (error) {
    console.error('获取景点列表失败:', error)
    ElMessage.error('获取景点列表失败')
  }
}

// 处理搜索
const handleSearch = () => {
  currentPage.value = 1
  getRouteList()
}

// 重置搜索
const resetSearch = () => {
  searchForm.value = {
    routeName: ''
  }
  handleSearch()
}

// 处理新增
const handleAdd = () => {
  dialogType.value = 'add'
  formData.value = {
    routeName: '',
    description: '',
    spots: []
  }
  dialogVisible.value = true
  getSpotList()
}

// 处理编辑
const handleEdit = async (row) => {
  dialogType.value = 'edit'
  await getSpotList()
  formData.value = {
    ...row,
    spots: row.spots || []
  }
  dialogVisible.value = true
}

// 处理查看
const handleView = (row) => {
  ElMessageBox.alert(row.description, row.routeName, {
    confirmButtonText: '确定'
  })
}

// 处理删除
const handleDelete = (row) => {
  ElMessageBox.confirm('确定要删除该路线吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      const res = await del(`/api/admin/route/delete/${row.id}`)
      if (res.code === 200) {
        ElMessage.success('删除成功')
        getRouteList()
      }
    } catch (error) {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  })
}

// 添加景点到路线
const addSpotToRoute = (spot) => {
  if (isSpotSelected(spot.id)) {
    ElMessage.warning('该景点已添加')
    return
  }
  
  formData.value.spots.push({
    spotId: spot.id,
    scenicSpot: {
      id: spot.id,
      name: spot.name,
      location: spot.location,
      ticketPrice: spot.ticketPrice
    },
    visitDuration: 2.0,
    orderNum: formData.value.spots.length + 1
  })
}

// 移除景点
const removeSpot = (spot) => {
  const index = formData.value.spots.findIndex(s => 
    s.spotId === spot.spotId || s.scenicSpot?.id === spot.id
  )
  if (index > -1) {
    formData.value.spots.splice(index, 1)
    // 重新计算序号
    formData.value.spots.forEach((s, i) => {
      s.orderNum = i + 1
    })
  }
}

// 移动景点位置
const moveSpot = (index, direction) => {
  const newIndex = index + direction
  if (newIndex < 0 || newIndex >= formData.value.spots.length) return
  
  const spots = formData.value.spots
  const temp = spots[index]
  spots[index] = spots[newIndex]
  spots[newIndex] = temp
}

// 判断景点是否已选
const isSpotSelected = (spotId) => {
  return formData.value.spots.some(s => s.spotId === spotId || s.scenicSpot?.id === spotId)
}

// 处理提交
const handleSubmit = async () => {
  if (!formData.value.spots.length) {
    ElMessage.warning('请至少选择一个景点')
    return
  }

  try {
    const url = dialogType.value === 'add' 
      ? '/api/admin/route/save'
      : '/api/admin/route/update'
    const method = dialogType.value === 'add' ? post : put
    
    const res = await method(url, formData.value)
    if (res.code === 200) {
      ElMessage.success(dialogType.value === 'add' ? '添加成功' : '更新成功')
      dialogVisible.value = false
      getRouteList()
    }
  } catch (error) {
    console.error('保存失败:', error)
    ElMessage.error('保存失败')
  }
}

// 分页处理
const handleSizeChange = (val) => {
  pageSize.value = val
  getRouteList()
}

const handleCurrentChange = (val) => {
  currentPage.value = val
  getRouteList()
}

// 格式化日期
const formatDate = (date) => {
  if (!date) return ''
  return new Date(date).toLocaleString()
}

onMounted(() => {
  getRouteList()
  getSpotList()
})

// 将 handleAdd 添加到导出的方法中
defineExpose({
  handleAdd
})
</script>

<style scoped>
.route-container {
  padding: 20px;
}

.search-bar {
  margin-bottom: 20px;
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.spot-selector {
  display: flex;
  gap: 20px;
  margin-top: 10px;
}

.spot-list {
  flex: 1;
  max-height: 400px;
  overflow-y: auto;
}

.selected-spots {
  width: 100%;
}

.selected-spots h4 {
  margin: 0 0 10px;
  padding-left: 10px;
  border-left: 3px solid #409EFF;
}

.spot-tag {
  margin: 2px 4px;
}

.pagination {
  margin-top: 20px;
  padding: 10px;
  background: #fff;
  border-radius: 4px;
  display: flex;
  justify-content: flex-end;
}

.dialog-footer {
  padding-top: 20px;
  text-align: right;
}

.el-tag {
  margin-right: 5px;
  margin-bottom: 5px;
}
</style>