package com.qidian.mespro.service;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.ProductionReporting;
import com.qidianit.mes.pro.pojo.TaskList;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/26 - 上午9:44
 */
public interface ProductionReportingService {

   Result<PageInfo<ProductionReporting>> selectProductionList(ProductionReporting productionReporting, int pageNum, int pageSize);

   Result<ProductionReporting> addReport(ProductionReporting productionReporting);
   Result<ProductionReporting> selectReportById(Long id);

   Result<ProductionReporting> updateReport(ProductionReporting productionReporting);
   Result deleteById(Long id);
   Result confirmReport(Long id);
   Result auditReport(Long id);
   Result cancelReport(Long id);
   Result deleteByIdList(Long [] ids);
   Result<PageInfo<TaskList>> selectTask(TaskList taskList,int pageNum,int pageSize);
}
