package com.qidian.mespro.service.lmpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidian.mespro.mapper.ProductionOrderMapper;
import com.qidian.mespro.service.ProductionOrderService;
import com.qidian.mespro.vo.ProductionOrderVo;
import com.qidian.mespro.vo.WorkflowProductVo;
import com.qidianit.mes.pojo.Customer;
import com.qidianit.mes.pojo.Material;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.*;
import com.qidianit.mes.pro.pojo.Process;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/20 - 下午2:35
 */
@Service
public class ProductionOrderServicelmpl implements ProductionOrderService {

    @Autowired
    ProductionOrderMapper productionOrderMapper;

    @Override
    public Result<PageInfo<ProductionOrderVo>> selectList(ProductionOrderVo productionOrderVo, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum,pageSize);


        List<ProductionOrderVo> productionOrderVos = productionOrderMapper.selectByProductionOrdrList(productionOrderVo);

        for(ProductionOrderVo productVo : productionOrderVos) {
            // 设置物料信息（必须有）
            Material material = productionOrderMapper.selectByMaterialCode(productVo.getMaterialCode());
            if (material != null) {
                productVo.setMaterialName(material.getName());
                material.setUnit(productionOrderMapper.selectByUnitAndMaterialAndCustomerCode(productVo.getMaterialCode()));
                productVo.setMaterial(material);
            }
            
            // 设置客户信息（可能没有）
            if (productVo.getCustomerCode() != null && !productVo.getCustomerCode().isEmpty()) {
                Customer customer = productionOrderMapper.selectByCustomerCode(productVo.getCustomerCode());
                if (customer != null) {
                    productVo.setCustomerName(customer.getName());
                    productVo.setCustomer(customer);
                }
            }
            
            // 设置字典数据
            productVo.setTypeDictData(productionOrderMapper.selectBytypeDictData(productVo.getProductionOrderType()));
            productVo.setStatusDictData(productionOrderMapper.selectBySysDictData(productVo.getStatus()));
        }

        return Result.success(new PageInfo<>(productionOrderVos));
    }

    @Override
    public Result selectByIdProductionOrderVo(Long id) {

        ProductionOrderVo  productVo= productionOrderMapper.selectByIdProductionOrderVo(id);
        Material material = productionOrderMapper.selectByMaterialCode(productVo.getMaterialCode());
        if (material != null) {
            productVo.setMaterialName(material.getName());
            material.setUnit(productionOrderMapper.selectByUnitAndMaterialAndCustomerCode(productVo.getMaterialCode()));
            productVo.setMaterial(material);
        }

        // 设置客户信息（可能没有）
        if (productVo.getCustomerCode() != null && !productVo.getCustomerCode().isEmpty()) {
            Customer customer = productionOrderMapper.selectByCustomerCode(productVo.getCustomerCode());
            if (customer != null) {
                productVo.setCustomerName(customer.getName());
                productVo.setCustomer(customer);
            }
        }

        // 设置字典数据
        productVo.setTypeDictData(productionOrderMapper.selectBytypeDictData(productVo.getProductionOrderType()));
        productVo.setStatusDictData(productionOrderMapper.selectBySysDictData(productVo.getStatus()));
        productVo.setSupplier(productionOrderMapper.selectByCodeSupplier(productVo.getSupplierCode()));

        return Result.success(productVo);
    }

    public Result insertProdcutionOrder(ProductionOrder productionOrder) {
        // 检查工单编号是否已存在
        ProductionOrder existingOrder = productionOrderMapper.selectByIdOrderCode(productionOrder.getProductionOrderCode());
        if (existingOrder != null) {

            // 如果是新增操作（ID为null），查询到记录说明编号已存在
            if (productionOrder.getId() == null) {
                return Result.error(400, "工单编号重复");
            }
        }

        if (productionOrder.getMaterialCode() == null) {
            return Result.error(400, "参数校验失败：物料编号不能为空");
        }


        productionOrder.setStatus(39);
        if (productionOrderMapper.insertProdcutionOrder(productionOrder) == 1) {
            Map<String, Object> data = new HashMap<>();
            data.put("id", productionOrder.getId());
            return Result.success(200, "新增工单成功", data);
        } else {
            return Result.error(500, "新增工单失败");
        }
    }

    @Override
    public Result updateProductionOrder(ProductionOrder productionOrder) {
        ProductionOrder existingOrder = productionOrderMapper.selectByIdOrderCode(productionOrder.getProductionOrderCode());
        if (existingOrder != null) {

            if (productionOrder.getId() != null && !productionOrder.getId().equals(existingOrder.getId())) {
                return Result.error(400, "工单编号重复"+existingOrder.getId()+productionOrder.getId());
            }
            if (productionOrder.getStatus()!=39){
                return Result.error(400,"只有草稿状态的工单才能编辑"+productionOrder.getStatus());
            }
            if (productionOrderMapper.updateProductionOrder(productionOrder) == 1) {
                return Result.success("200", "编辑工单成功");
            } else {
                return Result.error(500, "编辑工单失败");
            }


        } else  return Result.error(500, "编辑工单失败");




    }

    @Override
    public Result deleteProductionOrder(Long id) {

        return productionOrderMapper.deleteProductionOrder(id) == 1 ? Result.success("200","操作成功"):Result.error(500,"编辑失败");
    }

    @Override
    public Result auditProductionOrder(Long id) {
        return productionOrderMapper.auditProductionOrder(id) == 1 ? Result.success("200","操作成功"):Result.error(500,"编辑失败");
    }

    @Override
    public Result cancleProductionOrder(Long id) {
        return productionOrderMapper.cancleProductionOrder(id)==1? Result.success("200","操作成功"):Result.error(500,"编辑失败");
    }

    @Override
    public Result confirmProductionOrder(Long id) {
        return productionOrderMapper.confirmProductionOrder(id) == 1 ? Result.success("200","操作成功"):Result.error(500,"编辑失败");
    }

    @Override
    public Result<PageInfo<Material>> selectByParentIdMaterials(String code, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum,pageSize);
        List<MaterialBom> materials=productionOrderMapper.selectByParentCodeMaterials(code);
        List<Material> materialList=new ArrayList<>();
        for (MaterialBom mate1 : materials) {
            Material materia =productionOrderMapper.selectByMaterialId(mate1.getChildMaterialId());
            materia.setUnit(productionOrderMapper.selectByUnitAndMaterialAndCustomerCode(materia.getCode()));
            materia.setQuantity(mate1.getQuantity());
            materialList.add(materia);
        }
        return Result.success(new PageInfo<>(materialList));
    }

    @Override
    public Result<PageInfo<ProductionOrderVo>> selectAllReadyByProductionOrderList(ProductionOrderVo productionOrderVo, int pageNum, int pageSize) {

        PageHelper.startPage(pageNum,pageSize);
        List<ProductionOrderVo> productionOrderVos = productionOrderMapper.selectAllReadyByProductionOrderList(productionOrderVo);

        for(ProductionOrderVo productVo : productionOrderVos) {
            // 设置物料信息（必须有）
            Material material = productionOrderMapper.selectByMaterialCode(productVo.getMaterialCode());
            if (material != null) {
                productVo.setMaterialName(material.getName());
                material.setUnit(productionOrderMapper.selectByUnitAndMaterialAndCustomerCode(productVo.getMaterialCode()));
                productVo.setMaterial(material);
            }

            // 设置客户信息（可能没有）
            if (productVo.getCustomerCode() != null && !productVo.getCustomerCode().isEmpty()) {
                Customer customer = productionOrderMapper.selectByCustomerCode(productVo.getCustomerCode());
                if (customer != null) {
                    productVo.setCustomerName(customer.getName());
                    productVo.setCustomer(customer);
                }
            }

            // 设置字典数据
            productVo.setTypeDictData(productionOrderMapper.selectBytypeDictData(productVo.getProductionOrderType()));
            productVo.setStatusDictData(productionOrderMapper.selectBySysDictData(productVo.getStatus()));
        }

        return Result.success(new PageInfo<>(productionOrderVos));
    }

    @Override
    public Result<ProductionOrderVo> selectByIdProductVoAndMaterialAndUnit(Long id) {

        ProductionOrderVo productionOrderVo = productionOrderMapper.selectByIdProductVoAndMaterialAndUnit(id);
        Material material = productionOrderMapper.selectByMaterialCode(productionOrderVo.getMaterialCode());
        material.setUnit(productionOrderMapper.selectByUnitAndMaterialAndCustomerCode(productionOrderVo.getMaterialCode()));
       productionOrderVo.setMaterial(material);
        return Result.success(productionOrderVo);
    }

    @Override
    public Result<List<Workflow>> selectProcessByMatericalCode(String code) {
        List<Workflow> workflows = productionOrderMapper.selectProcessByMatericalCode(code);
        for (Workflow workflow : workflows) {
            List<Process> processes = productionOrderMapper.selectProcessByWorkflowID(workflow.getId());
            workflow.setProcess(processes);
        }
        return Result.success(workflows);
    }

    @Override
    public Result<List<TaskList>> selectTaskListByworkflowIdandProcessId(Long workflowId, Long processId,String code) {
        return Result.success(productionOrderMapper.selectTaskListByworkflowIdandProcessId(workflowId,processId,code));
    }

    @Override
    public Result<TaskList> addTaskList(TaskList taskList) {
        if(productionOrderMapper.selectByTaskListCode(taskList.getTaskCode())!=null)
            return Result.error("新增失败");
        return productionOrderMapper.addTaskList(taskList) == 1 ? Result.success():Result.error("新增失败");
    }

    @Override
    public Result<TaskList> selectTaskListById(Long id) {
         return Result.success(productionOrderMapper.selectTaskListById(id));
    }

    @Override
    public Result<TaskList> updateTasklist(TaskList taskList) {
        TaskList taskList1 = productionOrderMapper.selectTaskListById(taskList.getId());
        TaskList existingTaskList = productionOrderMapper.selectByTaskListCode(taskList.getTaskCode());
        if (existingTaskList != null && !existingTaskList.getId().equals(taskList.getId()))
            return Result.error("编辑失败");
        return productionOrderMapper.updateTasklist(taskList) == 1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result deleteById(Long id) {
        return productionOrderMapper.deleteById(id)==1 ? Result.success():Result.error("删除失败");
    }

    @Override
    public Result deleteByIdList(Long[] ids) {
        return productionOrderMapper.deleteByIdList(ids)>0 ? Result.success():Result.error("删除失败");
    }


}
