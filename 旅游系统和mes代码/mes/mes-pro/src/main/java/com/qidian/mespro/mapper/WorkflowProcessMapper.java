package com.qidian.mespro.mapper;

import com.qidian.mespro.vo.WorkflowProcessVo;
import com.qidianit.mes.pojo.SysDictData;
import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.pro.pojo.Workflow;
import com.qidianit.mes.pro.pojo.WorkflowProcess;
import lombok.AllArgsConstructor;
import lombok.Data;
import org.apache.ibatis.annotations.Param;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/18 - 下午4:27
 */

public interface WorkflowProcessMapper {

     WorkflowProcessVo selectList(Long workflowId, int stepId);
     Process selectProcess(Long workflowId, int stepId);
     Process selectNextProcess(Long workflowId, int stepId);
     SysDictData selectrelationNextDict(Long workflowId, int stepId);

     /**
      * @Author tangyuguo
      * @Description
      * @Param 添加工序
      * @Date 2025/9/18 下午8:46
      * @return
      */
     int addWorkflowProcess(WorkflowProcess workflowProcess);
 /**
  * @Author tangyuguo
  * @Description 通过id序号进行查重
  * @Date 2025/9/18 下午9:43
  * @return
  */
     WorkflowProcess selectById(Integer id);
     /**
      * @Author tangyuguo
      * @Description通过工艺序号进行查重
      * @Param
      * @Date 2025/9/18 下午9:43
      * @return
      */
     Process selectByProcessId(Long id);
     /**
      * @Author tangyuguo
      * @Description
      * @Param 根据id查询工艺工序组成
      * @Date 2025/9/19 下午2:33
      * @return 
      */
     WorkflowProcessVo selectByworkflowProcessId( Long id);
     /**
      * @Author tangyuguo
      * @Description 编辑工艺的工序组成
      * @Param
      * @Date 2025/9/19 下午2:59
      * @return
      */
     int updateworkflowprocess(WorkflowProcess workflowProcess);
    /**
     * @Author tangyuguo
     * @Description 用于排除自己查重
     * @Param
     * @Date 2025/9/19 下午3:46
     * @return
     */
    WorkflowProcess selectByStepOrderExcludeId(Integer stepOrder, Long excludeId);
    /**
     * @Author tangyuguo
     * @Description 删除工序
     * @Param
     * @Date 2025/9/19 下午3:46
     * @return
     */
    int deleteWorkflowprocess(Long id);
    /**
     * @Author tangyuguo
     * @Description 批量删除
     * @Param
     * @Date 2025/9/19 下午3:55
     * @return
     */
    int batchDelete(@Param("ids") Long [] ids);


}
