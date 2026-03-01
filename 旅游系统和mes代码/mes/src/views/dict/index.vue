<template>
  <div class="log-container">
    <!-- 搜索栏部分 -->
    <el-card class="search-card">
      <el-form :model="searchForm" label-width="80px" inline>
        <el-form-item label="字典名称">
          <el-input v-model="searchForm.dictName" placeholder="请输入字典名称" clearable />
        </el-form-item>
          <el-form-item label="字典类型">
              <el-input v-model="searchForm.dictType" placeholder="请输入字典类型" clearable />
          </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">搜索</el-button>
          <el-button @click="resetSearch">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 工具栏部分 -->
    <div class="toolbar">
        <el-button type="primary" @click="handlerToAddDictType" >新增字典</el-button>
      <el-button type="danger" @click="handleBatchDelete" :disabled="selectedDictTypes.length === 0">批量删除</el-button>
    </div>

    <!-- 列表 -->
    <el-card class="table-card">
      <el-table
        :data="dictTypeList"
        border
        stripe
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="dictName" label="字典名称" />
          <el-table-column prop="dictType" label="字典类型" >
              <template #default="scope">
                  <el-link @click="handlerShowDictData(scope.row)">{{scope.row.dictType}}</el-link>
              </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="80">
              <template #default="scope">
                  <el-tag :type="scope.row.status == '1' ? 'success' : 'danger'">
                      {{ scope.row.status == '1' ? '启用' : '禁用' }}
                  </el-tag>
              </template>
          </el-table-column>
          <el-table-column prop="createdTime" label="创建时间" width="180" />
          <el-table-column label="操作" width="200" fixed="right">
              <template #default="scope">
                  <el-button size="small" @click="handleEdit(scope.row)"><el-icon><EditPen /></el-icon></el-button>
                  <el-button
                          size="small"
                          type="danger"
                          @click="handleDelete(scope.row)"
                  >
                      <el-icon><Delete /></el-icon>
                  </el-button>
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

    <!-- 日志详情对话框 -->
    <el-dialog
      title="新增字典类型"
      v-model="addDictTypeDialogVisible"
      width="600px"
    >
      <el-form 
        :model="dictTypeForm"
        label-width="100px"
      >
        <el-form-item label="字典名称">
          <el-input v-model="dictTypeForm.dictName" />
        </el-form-item>
        <el-form-item label="字典类型">
          <el-input v-model="dictTypeForm.dictType" />
        </el-form-item>
        <el-form-item label="备注">
          <el-input type="textarea" v-model="dictTypeForm.remark" />
        </el-form-item>
          <el-form-item label="状态" prop="status">
              <el-radio-group v-model="dictTypeForm.status">
                  <el-radio :label="1">启用</el-radio>
                  <el-radio :label="0">禁用</el-radio>
              </el-radio-group>
          </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
            <el-button @click="handlerCancel">取消</el-button>
          <el-button type="primary" @click="hadlerSubmitAddOrUpldate">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
    <!-- 字典数据对话框 -->
  <el-dialog v-model="dictDataListDialogVisable" title="字典数据" width="80%">
    <dict_data :dict-type="dictType"/>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {getDictTypeList,addDictType,updateDictType,getDictTypeById} from "@/api/dict.js";
import dictDataCom from './dict_data.vue';
import Dict_data from "@/views/dict/dict_data.vue";

// 当前正在操作的字典类型
const dictType = ref('');
// 字典数据列表对话框可见性
const dictDataListDialogVisable = ref(false);
// 搜索表单
const searchForm = reactive({
  dictName:'',
    dictType:''
})
// 分页信息
const pagination = reactive({
    currentPage: 1,
    pageSize: 10,
    total: 0
})
// 新增字典类别对话框可见性
const addDictTypeDialogVisible = ref(false)
// 新增、编辑字典类别表单
const dictTypeForm = reactive({
    id: '',
    dictName:'',
    dictType:'',
    status:'',
    remark:''
})
// 列表数据
const dictTypeList = ref([]);
// 已选择的字典类别ID列表
const selectedDictTypes = ref([])
// 显示字典数据
const handlerShowDictData = (dtype) => {
    dictDataListDialogVisable.value = true
    dictType.value = dtype.dictType
}

// 当前页码变更
const handleCurrentChange = (current) => {
    pagination.currentPage = current
    loadDictTypeList()
}
// 当前页码大小变更s
const handleSizeChange = (size) => {
    pagination.pageSize = size
    loadDictTypeList()
}
// 加载列表
const loadDictTypeList = () => {
    getDictTypeList({dictName:searchForm.dictName,dictType:searchForm.dictType,pageNum:pagination.currentPage,size:pagination.pageSize}).then(res=>{
        dictTypeList.value = res.data.records;
        pagination.total = res.data.total;
    })
}
// 重置表单
const reseatDictTypeForm = () => {
    dictTypeForm.id = '';
    dictTypeForm.dictName = '';
    dictTypeForm.dictType = '';
    dictTypeForm.status = '';
    dictTypeForm.remark = '';
}
// 新增字典类别
const handlerToAddDictType = () => {
    addDictTypeDialogVisible.value = true
}
// 处理取消按钮
const handlerCancel = () => {
    reseatDictTypeForm()
    addDictTypeDialogVisible.value = false
}
// 处理提交
const hadlerSubmitAddOrUpldate = () => {
    if (dictTypeForm.id){
        updateDictType(dictTypeForm).then((res)=>{
            if (res.code == 200){
                ElMessage.success('更新成功')
                handlerCancel();
                loadDictTypeList();
            }else{
                ElMessage.error(res.message)
            }
        })
    }else{
      addDictType(dictTypeForm).then((res)=>{
          if (res.code == 200){
              ElMessage.success('新增成功')
              handlerCancel();
              loadDictTypeList();
          }else{
              ElMessage.error(res.message)
          }
      })
    }
}
/**
 * 编辑字典类别
 * @param row
 */
const handleEdit = (row) => {
    getDictTypeById(row.id).then(res=>{
        dictTypeForm.id = res.data.id;
        dictTypeForm.dictName = res.data.dictName;
        dictTypeForm.dictType = res.data.dictType;
        dictTypeForm.status = res.data.status;
        dictTypeForm.remark = res.data.remark;
        addDictTypeDialogVisible.value = true
    })
}
onMounted(()=>{
    loadDictTypeList();
})
</script>

<style scoped>
.log-container {
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