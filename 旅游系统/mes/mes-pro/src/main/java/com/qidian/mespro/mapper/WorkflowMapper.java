package com.qidian.mespro.mapper;

import com.qidianit.mes.pro.pojo.Workflow;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午11:06
 */
public interface WorkflowMapper{

    /**
     * @Author tangyuguo
     * @Description 多条件查询工艺
     * @Param 
     * @Date 2025/9/18 下午1:49
     * @return 
     */
    List<Workflow> selectList(Workflow workflow);
    /**
     * @Author tangyuguo
     * @Description 查询单个工艺信息
     * @Param code 工艺编码
     * @Date 2025/9/18 下午2:14
     * @return 工艺对象
     */
    Workflow selectByCode(String code);
    /**
     * @Author tangyuguo
     * @Description 新增工艺流程
     * @Param
     * @Date 2025/9/18 下午2:22
     * @return
     */
     int addworkflow(Workflow workflow);
     /**
      * @Author tangyuguo
      * @Description 编辑工艺流程
      * @Param
      * @Date 2025/9/18 下午2:41
      * @return
      */
      int updateworkflow(Workflow workflow);
      /**
       * @Author tangyuguo
       * @Description 删除单个工艺
       * @Param
       * @Date 2025/9/18 下午3:17
       * @return
       */
      int deleteWorkflow(Long id);
      /**
       * @Author tangyuguo
       * @Description 批量删除
       * @Param
       * @Date 2025/9/18 下午3:25
       * @return
       */
      int batchDelete(@Param("ids") Long [] ids);

}
