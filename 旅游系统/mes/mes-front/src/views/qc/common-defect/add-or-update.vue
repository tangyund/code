
<template>
  <el-form label-width="auto" :model="defectForm">
    <el-form-item label="缺陷描述">
      <el-input v-model="defectForm.defectDescription" placeholder="缺陷描述" clearable />
    </el-form-item>
    <el-form-item label="检测项类型">
      <el-select style="width:150px" v-model="defectForm.detectionItemType" placeholder="检测项类型" clearable>
        <el-option
            v-for="dictData in defectTypeDictList"
            :value="dictData.id"
            :key="dictData.id"
            :label="dictData.dictLabel"
        />
      </el-select>
    </el-form-item>
    <el-form-item label="缺陷等级">
      <el-select style="width: 120px" clearable v-model="defectForm.defectLevel" placeholder="缺陷等级">
        <el-option label="轻微缺陷" value="1"/>
        <el-option label="严重缺陷" value="2"/>
        <el-option label="致命缺陷" value="3"/>
      </el-select>
    </el-form-item>
  </el-form>
  <div class="dialog-footer">
    <el-button @click="cancleAddOrUpdate">取消</el-button>
    <el-button type="primary" @click="handlerSubmit">
      提交
    </el-button>
  </div>
</template>

<script setup>
// 导入字典相关的API
import {getDictDataList} from "@/api/dictData.js";
import {onMounted, ref, defineEmits, watch} from "vue";
import {getCommonDefectById} from "@/api/common-defect.js";
// 绑定新增/编辑表单的数据
const defectForm = ref({})
// 保存缺陷类型字典的列表
const defectTypeDictList = ref([]);


// 申明对外的事件
const emit = defineEmits(['cancel','defectSubmit'])
// 申明一个对外的属性
const props = defineProps(['defectId'])
// 提交按钮事件
const handlerSubmit = ()=>{
  // 触发一个事件，通过父组件，并且将表单中的数据发送到父组件中。
  // 第一个参数是要触发的事件的名字，第二个参数要返回给父组件的
  emit('defectSubmit',defectForm);
}

// 加载陷类型字典的列表
const loadDefectTypeDictList=()=>{
  getDictDataList({"dictType":'DEFECT_TYPE'}).then(res=>{
    defectTypeDictList.value = res.data.records;
  });
}

// 取消按钮事件
const cancleAddOrUpdate = ()=>{
  defectForm.value = {};
  // 通知父组件，关闭弹窗
  // 触发对外的事件
  emit("cancel");
}
// 通过id加载对应的数据
const loadCommonDefectById=(id)=>{
  getCommonDefectById(id).then(function(res){
    // 这里的res就是后端响应的结果
    // 接下来就是按照后端的结果处理
    if(res.code == 200){
      defectForm.value = res.data;
    }
  })
}

// 监听props的属性值
watch(()=>props.defectId,(newDefectId,oldValue)=>{
  // 只要属性发生变化，就立刻加载最新的数据
  if(newDefectId){
    loadCommonDefectById(newDefectId);
  }
})

onMounted(()=>{
  loadDefectTypeDictList();
})

</script>

<style scoped>
.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>