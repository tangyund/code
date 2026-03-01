package com.qidian.mespro.service;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import com.qidian.mespro.vo.ProductionOrderVo;
import com.qidian.mespro.vo.WorkflowProcessVo;
import com.qidianit.mes.pojo.Material;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.pro.pojo.ProductionOrder;
import com.qidianit.mes.pro.pojo.TaskList;
import com.qidianit.mes.pro.pojo.Workflow;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/20 - 下午2:35
 */
public interface ProductionOrderService {

    Result<PageInfo<ProductionOrderVo>> selectList(ProductionOrderVo productionOrderVo, int pageNum, int pageSize );

    Result selectByIdProductionOrderVo(Long id);

    Result insertProdcutionOrder(ProductionOrder productionOrder);

    Result updateProductionOrder(ProductionOrder productionOrder);

    Result deleteProductionOrder(Long  id);

    Result auditProductionOrder(Long id);

    Result cancleProductionOrder(Long id);

    Result confirmProductionOrder(Long id);

    Result<PageInfo<Material>> selectByParentIdMaterials(String code, int pageNum, int pageSize );

    Result<PageInfo<ProductionOrderVo>> selectAllReadyByProductionOrderList(ProductionOrderVo productionOrderVo,int pageNum, int pageSize);

    Result<ProductionOrderVo> selectByIdProductVoAndMaterialAndUnit(Long id);

    Result<List<Workflow> > selectProcessByMatericalCode(String code);

    Result<List<TaskList>> selectTaskListByworkflowIdandProcessId(Long workflowId,Long processId,String code);

    Result<TaskList> addTaskList(TaskList taskList);

    Result<TaskList> selectTaskListById(Long id);

    Result<TaskList> updateTasklist(TaskList taskList);

    Result deleteById(Long id);

    Result deleteByIdList(Long [] ids);
}
