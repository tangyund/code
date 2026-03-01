<template>
  <div class="log-container">
    <!-- 工具栏部分 -->
    <div class="toolbar">
        <el-button type="primary" @click="handlerToAddDictData" >新增字典数据</el-button>
      <el-button type="danger" @click="handleBatchDelete" :disabled="selectedDictDatas.length === 0">批量删除</el-button>
    </div>

    <!-- 列表 -->
    <el-card class="table-card">
      <el-table
        :data="dictDataList"
        border
        stripe
        @selection-change="handleSelectionChange"
      >
        <el-table-column type="selection" width="55" />
        <el-table-column prop="id" label="ID" width="80" />
          <el-table-column prop="dictType" label="字典类型" />
          <el-table-column prop="dictLabel" label="字典标签" />
          <el-table-column prop="dictValue" label="字典数值" />
          <el-table-column prop="isDefault" label="是否默认" >
              <template #default="scope">
                  <el-tag :type="scope.row.isDefault == '1' ? 'success' : 'danger'">
                      {{ scope.row.isDefault == '1' ? '是' : '否' }}
                  </el-tag>
              </template>
          </el-table-column>
          <el-table-column prop="sort" label="排序" />
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
      title="新增字典数据"
      v-model="addDictDataDialogVisible"
      width="600px"
    >
      <el-form 
        :model="dictDataForm"
        label-width="100px"
      >
        <el-form-item label="字典标签">
          <el-input v-model="dictDataForm.dictLabel" />
        </el-form-item>
        <el-form-item label="字典数值">
          <el-input v-model="dictDataForm.dictValue" />
        </el-form-item>
          <el-form-item label="排序">
              <el-input v-model="dictDataForm.sort" />
          </el-form-item>
          <el-form-item label="是否默认" prop="isDefault">
              <el-radio-group v-model="dictDataForm.isDefault">
                  <el-radio :label="1">默认</el-radio>
                  <el-radio :label="0">非默认</el-radio>
              </el-radio-group>
          </el-form-item>
        <el-form-item label="备注">
          <el-input type="textarea" v-model="dictDataForm.remark" />
        </el-form-item>
          <el-form-item label="状态" prop="status">
              <el-radio-group v-model="dictDataForm.status">
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
</template>

<script setup>
import {ref, reactive, onMounted, watch} from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {getDictDataList,addDictData,updateDictData,getDictDataById} from "@/api/dictData.js";


const props = defineProps({
    dictType: {
        type: String,
        required: true
    }
})

// 分页信息
const pagination = reactive({
    currentPage: 1,
    pageSize: 10,
    total: 0
})
// 新增字典类别对话框可见性
const addDictDataDialogVisible = ref(false)
// 新增、编辑字典类别表单
const dictDataForm = reactive({
    id: '',
    dictLabel:'',
    dictValue:'',
    sort: '',
    dictType:'',
    status:'',
    remark:''
})
// 列表数据
const dictDataList = ref([]);
// 已选择的字典类别ID列表
const selectedDictDatas = ref([])
// 当前页码变更
const handleCurrentChange = (current) => {
    pagination.currentPage = current
    loaddictDataList()
}
// 当前页码大小变更s
const handleSizeChange = (size) => {
    pagination.pageSize = size
    loaddictDataList()
}
// 加载列表
const loadDictDataList = () => {
    console.log(props)
  getDictDataList({dictType: props.dictType, pageNum: pagination.currentPage, pageSize: pagination.pageSize}).then(res=>{
      dictDataList.value = res.data.records;
      pagination.total = res.data.total;
  })
}
// 重置表单
const reseatDictDataForm = () => {
    Object.assign(dictDataForm, {
        id: '',
        dictLabel:'',
        dictValue:'',
        sort: '',
        dictType:'',
        status:'',
        remark:''
    })
}
// 新增字典类别
const handlerToAddDictData = () => {
    addDictDataDialogVisible.value = true
    dictDataForm.dictType = props.dictType
}
// 处理取消按钮
const handlerCancel = () => {
    reseatDictDataForm()
    addDictDataDialogVisible.value = false
}
// 处理提交
const hadlerSubmitAddOrUpldate = () => {
    if (dictDataForm.id){
        updateDictData(dictDataForm).then((res)=>{
            if (res.code == 200){
                ElMessage.success('更新成功')
                handlerCancel();
                loadDictDataList();
            }else{
                ElMessage.error(res.message)
            }
        })
    }else{
        addDictData(dictDataForm).then((res)=>{
          if (res.code == 200){
              ElMessage.success('新增成功')
              handlerCancel();
              loadDictDataList();
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
    getDictDataById(row.id).then(res=>{
        dictDataForm.id = res.data.id;
        dictDataForm.dictLabel = res.data.dictLabel;
        dictDataForm.dictValue = res.data.dictValue;
        dictDataForm.sort = res.data.sort;
        dictDataForm.dictType = res.data.dictType;
        dictDataForm.status = res.data.status;
        dictDataForm.remark = res.data.remark;
        addDictDataDialogVisible.value = true;
    })
}
// 监听 dictType 变化，重新加载数据
watch(() => props.dictType, (newDictType) => {
    if (newDictType) {
        // 重置分页到第一页
        pagination.currentPage = 1;
        loadDictDataList();
    }
});
onMounted(()=>{
    console.log(1)
    loadDictDataList();
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