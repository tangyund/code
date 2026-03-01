package com.qidian.mespro.mapper;

import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.pro.pojo.ProcessStep;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午4:36
 */
public interface ProcessStepMapper {
    /**
     * @Author tangyuguo
     * @Description
     * @Param 根据processid查询旗下的步骤
     * @Date 2025/9/17 下午4:39
     * @return
     */
    List<ProcessStep> selectByProcessId(ProcessStep processStep);
    /**
     * @Author tangyuguo
     * @Description 根据id查询工序步骤
     * @Param
     * @Date 2025/9/17 下午5:01
     * @return
     */
    ProcessStep selectById(Long id);
    /**
     * @Author tangyuguo
     * @Description 编辑工序
     * @Param
     * @Date 2025/9/17 下午6:20
     * @return
     */
    int updateById(ProcessStep processStep);
    
    /**
     * @Author tangyuguo
     * @Description
     * @Param 根据工序步骤编号删除工序步骤
     * @Date 2025/9/17 下午6:30
     * @return 
     */
    int deleteById(Long id);
}
