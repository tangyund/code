package com.qidian.mespro.service.lmpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidian.mespro.mapper.ProductionOrderMapper;
import com.qidian.mespro.mapper.ProductionReportingMapper;
import com.qidian.mespro.service.ProductionReportingService;
import com.qidianit.mes.pojo.Material;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.ProductionOrder;
import com.qidianit.mes.pro.pojo.ProductionReporting;
import com.qidianit.mes.pro.pojo.TaskList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/26 - 上午9:44
 */
@Service
public class ProductionReportingServicelmpl implements ProductionReportingService {

    @Autowired
    ProductionReportingMapper productionReportingMapper;

    @Autowired
    ProductionOrderMapper productionOrderMapper;
    @Override
    public Result<PageInfo<ProductionReporting>> selectProductionList(ProductionReporting productionReporting, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum,pageSize);
        List<ProductionReporting> productionReportings = productionReportingMapper.selectProductionList(productionReporting);
        for (ProductionReporting reporting : productionReportings) {
            Material material = productionOrderMapper.selectByMaterialCode(reporting.getMaterialCode());
            if (material!=null)
            material.setUnit(productionOrderMapper.selectByUnitAndMaterialAndCustomerCode(reporting.getMaterialCode()));
            reporting.setMaterial(material);

        }
        return Result.success(new PageInfo<>(productionReportings));

    }

    @Override
    public Result<ProductionReporting> addReport(ProductionReporting productionReporting) {

        return productionReportingMapper.addReport(productionReporting) == 1 ? Result.success():Result.error("新增失败");
    }

    @Override
    public Result<ProductionReporting> selectReportById(Long id) {

        ProductionReporting productionReporting = productionReportingMapper.selectReportById(id);
        Material material = productionOrderMapper.selectByMaterialCode(productionReporting.getMaterialCode());
        if (material!=null)
            material.setUnit(productionOrderMapper.selectByUnitAndMaterialAndCustomerCode(productionReporting.getMaterialCode()));
        productionReporting.setMaterial(material);
        return Result.success(productionReporting);
    }

    @Override
    public Result<ProductionReporting> updateReport(ProductionReporting productionReporting) {

        return productionReportingMapper.updateReport(productionReporting) == 1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result deleteById(Long id) {
        return productionReportingMapper.deletReportById(id)== 1 ? Result.success():Result.error("删除失败");
    }

    @Override
    public Result confirmReport(Long id) {
        return productionReportingMapper.confirmReport(id)==1? Result.success():Result.error("确认失败");
    }

    @Override
    public Result auditReport(Long id) {
        return productionReportingMapper.auditReport(id)==1? Result.success():Result.error("审核失败");
    }

    @Override
    public Result cancelReport(Long id) {
        return productionReportingMapper.cancelRoport(id)==1? Result.success():Result.error("取消失败");
    }

    @Override
    public Result deleteByIdList(Long[] ids) {
        return productionReportingMapper.deleteByIdList(ids)>0 ? Result.success():Result.error("删除失败");
    }

    @Override
    public Result<PageInfo<TaskList>> selectTask(TaskList taskList, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum,pageSize);
        List<TaskList> taskLists = productionReportingMapper.selectTask(taskList);
        return Result.success(new PageInfo<>(taskLists));
    }


}
