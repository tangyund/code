package com.qidian.mespro.service.lmpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidian.mespro.mapper.WorkflowProductMapper;
import com.qidian.mespro.service.WorkflowProductService;
import com.qidian.mespro.vo.WorkflowProductVo;
import com.qidianit.mes.pojo.Material;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.WorkflowProcess;
import com.qidianit.mes.pro.pojo.WorkflowProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/19 - 下午4:17
 */
@Service
public class WorkflowProductServicelmpl implements WorkflowProductService {

    @Autowired
    WorkflowProductMapper workflowProductMapper;

    @Override
    public Result<PageInfo<WorkflowProductVo>> selectList(Long workflowId, int page, int size) {
        PageHelper.startPage(page, size);
        List<WorkflowProductVo> workflowProductVos = workflowProductMapper.selectList(workflowId);
        for (WorkflowProductVo productVo : workflowProductVos) {

            Material product = workflowProductMapper.selectByProductAndProductCode(productVo.getProductCode(), productVo.getWorkflowId());
            product.setUnit(workflowProductMapper.selectByProductUnit(productVo.getProductCode(), productVo.getWorkflowId()));
            productVo.setProduct(product);

        }
        return Result.success(new PageInfo<>(workflowProductVos));
    }

    @Override
    public Result addproduct(WorkflowProduct workflowProduct) {
        if (workflowProductMapper.selectByProductCodeandWork(workflowProduct.getProductCode(), workflowProduct.getWorkflowId()) != null)
            return Result.error(500, "该产品/物料已经添加");
        else if (workflowProductMapper.addproduct(workflowProduct) == 1)
            return Result.success("200", "操作成功");
        else return Result.error(500,"编辑失败");


    }

    @Override
    public Result selectByIdWorkflowProductVo(Long id) {
        WorkflowProductVo workflowProductVo = workflowProductMapper.selectByIdWorkflowProductVo(id);
        System.out.println(workflowProductVo.toString());
        Material material = workflowProductMapper.selectByProductMaterial(workflowProductVo.getProductCode());
        material.setCategory(workflowProductMapper.selectCategory(material.getCategoryId(), material.getId()));
        material.setUnit(workflowProductMapper.selectUnitByProduct(material.getUnitId(), material.getId()));
        workflowProductVo.setProduct(material);


        return Result.success(workflowProductVo);
    }

    @Override
    public Result updateworkflowprduct(WorkflowProduct workflowProduct) {
        WorkflowProduct existingRecord = workflowProductMapper.selectByIdWorkflowProductVo(workflowProduct.getId());
        if (workflowProductMapper.selectByProductCodeandWork(workflowProduct.getProductCode(), workflowProduct.getWorkflowId()) != null
                &&existingRecord.getId()!=workflowProduct.getId()) {
              return Result.error(500,"该产品/物料已经天际");
        }
        if (workflowProductMapper.updateworkflowprduct(workflowProduct) == 1) {

            return Result.success("200", "操作成功");
        } else {
            return Result.error(500, "操作失败");
        }


    }

    @Override
    public Result deleteWorkflowproduct(Long id) {
        return workflowProductMapper.deleteWorkflowproduct(id) == 1 ? Result.success("200","操作成功"):Result.error(500,"编辑失败");
    }

    @Override
    public Result batchDelete(Long[] ids) {
        return workflowProductMapper.batchDelete(ids) >0 ? Result.success("200","操作成功"):Result.error(500,"编辑失败");
    }

}
