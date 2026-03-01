<template>
  <!-- 搜索栏 -->
  <el-card class="search-card">
    <el-form :model="searchForm" label-width="120px" inline>
      <el-form-item label="缺陷描述">
        <el-input v-model="searchForm.defectDescription" placeholder="缺陷描述" clearable />
      </el-form-item>
      <el-form-item label="检测项类型">
        <el-select style="width:150px" v-model="searchForm.detectionItemType" placeholder="检测项类型" clearable>
          <el-option
            v-for="dictData in defectTypeDictList"
            :value="dictData.id"
            :key="dictData.id"
            :label="dictData.dictLabel"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="缺陷等级">
        <el-select style="width: 120px" clearable v-model="searchForm.defectLevel" placeholder="缺陷等级">
          <el-option label="轻微缺陷" :value="1"/>
          <el-option label="严重缺陷" :value="2"/>
          <el-option label="致命缺陷" :value="3"/>
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
    <el-button type="primary" @click="handleAdd">新增常见缺陷</el-button>
    <el-button type="danger" :disabled="!isDeleteEnable" >删除</el-button>
  </div>
  <!-- 列表 -->
  <el-card class="table-card">
    <el-table
        :data="defectList"
      stripe
      border
      @selection-change="handleSelectionChange"
    >
      <el-table-column type="selection" width="55" />
      <el-table-column prop="defectDescription" label="缺陷描述"/>
      <el-table-column prop="detectionItemType" label="缺陷类型"/>
      <el-table-column prop="defectLevel" label="缺陷级别">
        <!-- 插槽 -->
        <template #default="scope">
          {{scope.row.defectLevel == 1?'轻微缺陷' : scope.row.defectLevel == 2?'严重缺陷':'致命缺陷'}}
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template #default="scope">
          <el-button @click="handleEdit(scope.row)" size="small">编辑</el-button>
          <el-button @click="handleDelete(scope.row)" type="danger" size="small">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </el-card>
<!--  &lt;!&ndash; 分页栏 &ndash;&gt;-->
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
  <el-dialog v-model="dialogFormVisible" @close="dialogClose" :title="dialogTitle" width="800">
    <!-- 使用组件 -->
    <add-or-update
    @cancel="cancleAddOrUpdate"
    :defectId="editDefectId"
    @defectSubmit="handlerSubmit"
    />
  </el-dialog>

</template>

<script setup>
// 导入必须的内容
import {ref,onMounted} from "vue";
import {ElMessage,ElMessageBox} from "element-plus";
// 导入我们编写的common-defect.js对应的API
import {
  getCommonDefectPage,
  addCommonDefect,
  getCommonDefectById,
  updateCommonDefect,
  deleteCommonDefect,
  batchDeleteWorkflow
} from "@/api/common-defect.js";
// 导入字典相关的API
import {getDictDataList} from "@/api/dictData.js";
// 导入子组件
// 组件名可以自己定义
import addOrUpdate from '@/views/qc/common-defect/add-or-update.vue';
// ----- 属性声明 ↓
// 绑定搜索表单的数据
const searchForm = ref({
  defectDescription:'',
  detectionItemType:'',
  defectLevel:''
})
// 保存缺陷类型字典的列表
const defectTypeDictList = ref([]);
// 保存查询的列表数据
const defectList = ref([]);
// 分页数据
const pagination = ref({
  pageSize:10,
  currentPage:1,
  total:0
})
//  弹窗标题
const dialogTitle = ref("新增缺陷");
// 弹窗标记
const dialogFormVisible = ref(false);


// 编辑标记
const isEdit = ref(false);
// 保存选中的行
const selectedRows = ref([]);
// 删除按钮是否可以用
const isDeleteEnable = ref(false);
// 要编辑的对象的id
const editDefectId = ref(undefined);

// 表格的选择事件
const handleSelectionChange=(newSelection)=>{
  // 这里就是选中 行
  console.log(newSelection)
  selectedRows.value = newSelection;
  if(selectedRows.value.length > 0){
    isDeleteEnable.value = true;
  }else{
    isDeleteEnable.value = false;
  }

}
// 取消按钮事件
const cancleAddOrUpdate = ()=>{
  dialogFormVisible.value = false;
  // defectForm.value = {};
}
// 提交按钮事件
const handlerSubmit = (defectForm)=>{
  //判断是否是新增
  if(isEdit.value){
    // 编辑
    updateCommonDefect(defectForm.value).then(res=>{
      if (res.code == 200){
        ElMessage.success("编辑成功");
        cancleAddOrUpdate();
        // 刷新列表
        loadDefectList();
      }else{
        ElMessage.error(res.msg);
      }
    })
  }else{
    // 新增
    addCommonDefect(defectForm.value).then(res=>{
      if (res.code == 200){
        ElMessage.success("新增成功");
        cancleAddOrUpdate();
        // 刷新列表
        loadDefectList();
      }else{
        ElMessage.error(res.msg);
      }
    })
  }
}
// 关闭窗体的事件
const dialogClose = ()=>{
  // defectForm.value={};
}
// 工具栏新增按钮事件
const handleAdd = ()=>{
  dialogTitle.value="新增缺陷"
  dialogFormVisible.value = true;
  isEdit.value = false;
}
// 改变每页大小的事件
const handleSizeChange=(newSize)=>{
  pagination.value.pageSize = newSize;
  //重新加载数据
  loadDefectList();
}
// 改变当前页面的事件
const handleCurrentChange=(newPage)=>{
  pagination.value.currentPage = newPage;
  //重新加载数据
  loadDefectList();
}

// 行级别的编辑按钮事件
const handleEdit = (defect)=>{
  dialogTitle.value="编辑缺陷"
  isEdit.value = true;
  dialogFormVisible.value = true;
  // 给要编辑的数据的id赋值
  editDefectId.value = defect.id;
}
// 行级别的删除按钮事件
const handleDelete = (defect)=>{
    deleteCommonDefect(defect.id).then(res=>{
      loadDefectList();
    })
}

// 加载常见缺陷列表
const loadDefectList = ()=>{
  // 调用我们申明的API
  getCommonDefectPage(pagination.value.currentPage,pagination.value.pageSize,searchForm.value).then(res=>{
    defectList.value = res.data.list;
    pagination.value.total = res.data.total;
  })
}
// 加载陷类型字典的列表
const loadDefectTypeDictList=()=>{
  getDictDataList({"dictType":'DEFECT_TYPE'}).then(res=>{
    defectTypeDictList.value = res.data.records;
  });
}
// -- 函数声明 ↑
onMounted(()=>{
  loadDefectTypeDictList();
  loadDefectList();
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