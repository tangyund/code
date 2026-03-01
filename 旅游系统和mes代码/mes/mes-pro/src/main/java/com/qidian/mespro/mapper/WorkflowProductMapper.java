package com.qidian.mespro.mapper;

import com.qidian.mespro.vo.WorkflowProcessVo;
import com.qidian.mespro.vo.WorkflowProductVo;
import com.qidianit.mes.pojo.Material;
import com.qidianit.mes.pojo.MaterialCategory;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pojo.Unit;
import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.pro.pojo.WorkflowProcess;
import com.qidianit.mes.pro.pojo.WorkflowProduct;
import org.apache.ibatis.annotations.Param;

import java.rmi.MarshalException;
import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/19 - 下午4:15
 */
public interface WorkflowProductMapper {

    List<WorkflowProductVo> selectList(Long workflowId);

    Material selectByProductAndProductCode(String code,Long workflowId);

    Unit selectByProductUnit(String code,Long workflowId);

    /**
     * @Author tangyuguo
     * @Description
     * @Param 新增工艺流程接口
     * @Date 2025/9/19 下午5:25
     * @return
     */
    int addproduct(WorkflowProduct workflowProduct);

    WorkflowProduct selectByProductCodeandWork(String code,Long workflowId);

    WorkflowProductVo selectByIdWorkflowProductVo(Long id);

    Material selectByProductMaterial(String code);
    MaterialCategory selectCategory(Long cateId ,Long mId);
    Unit selectUnitByProduct(Long unId,Long mId);
    /**
     * @Author tangyuguo
     * @Description
     * @Param 更新
     * @Date 2025/9/19 下午9:14
     * @return
     */
    int updateworkflowprduct(WorkflowProduct workflowProduct);
   /**
    * @Author tangyuguo
    * @Description 删除一个
    * @Param
    * @Date 2025/9/19 下午9:39
    * @return
    */
   int deleteWorkflowproduct(Long id);
/**
 * @Author tangyuguo
 * @Description 批量删除
 * @Param
 * @Date 2025/9/19 下午9:58
 * @return
 */
    int batchDelete(@Param("ids") Long [] ids);


}
