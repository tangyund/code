package com.qidian.mespro.mapper;

import com.qidianit.mes.pro.pojo.ProductionReporting;
import com.qidianit.mes.pro.pojo.TaskList;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/26 - 上午9:44
 */
public interface ProductionReportingMapper {

    List<ProductionReporting> selectProductionList(ProductionReporting productionReporting);

    int addReport(ProductionReporting productionReporting);

    ProductionReporting selectReportById(Long id);

    int updateReport(ProductionReporting productionReporting);

    int deletReportById(Long id);

    int confirmReport(Long id);

    int auditReport(Long id);

    int cancelRoport(Long id);

    int deleteByIdList(@Param("ids") Long[] ids);

    List<TaskList> selectTask(TaskList taskList);
}
