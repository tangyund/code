package com.qidian.mespro.mapper;

import com.qidian.mespro.vo.ProductionOrderVo;
import com.qidian.mespro.vo.WorkflowProductVo;
import com.qidianit.mes.pojo.*;
import com.qidianit.mes.pro.pojo.*;
import com.qidianit.mes.pro.pojo.Process;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/20 - 下午2:06
 */
public interface ProductionOrderMapper {

    List<ProductionOrderVo> selectByProductionOrdrList(ProductionOrder productionOrder);

    // 用来查询订单状态
    SysDictData selectBySysDictData(int status);

    //用来查询生产种类
    SysDictData selectBytypeDictData(int status);

    // 用于寻找customer通过code
    Customer selectByCustomerCode(String code);

    //用来查询material通过code
    Material selectByMaterialCode(String code);

    //查询计量单位通过MaterialCode
    Unit selectByUnitAndMaterialAndCustomerCode(String code);

    //根据工单ID查询单个工单信息
    ProductionOrderVo selectByIdProductionOrderVo(Long id);

    Supplier selectByCodeSupplier(String code);

    //更新工单
    int insertProdcutionOrder(ProductionOrder productionOrder);

    //查重，工单编号
    ProductionOrder selectByIdOrderCode(String code);

    //用于编辑，更新productionOrder
    int updateProductionOrder(ProductionOrder productionOrder);

    //删除指定id
    int deleteProductionOrder(Long  id);

    //审核
    int auditProductionOrder(Long id);
    //打会
    int cancleProductionOrder(Long id);

    //确认
    int confirmProductionOrder(Long id);

    //根据code查询所有的子材料bom表单里面
    List<MaterialBom> selectByParentCodeMaterials(String code);

    Material selectByMaterialId(Long id);

    //排产列表
    List<ProductionOrderVo> selectAllReadyByProductionOrderList(ProductionOrder productionOrder);
    //排产功能获取当前
    ProductionOrderVo selectByIdProductVoAndMaterialAndUnit(Long id);

    //查询所有的工艺
    List<Workflow> selectProcessByMatericalCode(String code);
    //查询该工艺下面的工序
    List<Process> selectProcessByWorkflowID(Long id);

    List<TaskList> selectTaskListByworkflowIdandProcessId(Long workflowId,Long processId,String code);
     //新增TaskList
    int addTaskList(TaskList taskList);

    TaskList selectTaskListById(Long id);

    int updateTasklist(TaskList taskList);

    int deleteById(Long id);

    int deleteByIdList(@Param("ids") Long[] ids);

    TaskList selectByTaskListCode(String code);
}
