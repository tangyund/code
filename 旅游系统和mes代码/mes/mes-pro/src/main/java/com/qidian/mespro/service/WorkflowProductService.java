package com.qidian.mespro.service;

import com.github.pagehelper.PageInfo;
import com.qidian.mespro.vo.WorkflowProductVo;
import com.qidianit.mes.pojo.Material;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.WorkflowProcess;
import com.qidianit.mes.pro.pojo.WorkflowProduct;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/19 - 下午4:16
 */
public interface WorkflowProductService {
    public Result<PageInfo<WorkflowProductVo>> selectList(Long workflowId, int
            page, int size);

    Result addproduct(WorkflowProduct workflowProduct);

    Result selectByIdWorkflowProductVo(Long id);

    Result updateworkflowprduct(WorkflowProduct workflowProduct);

    Result deleteWorkflowproduct(Long id);

    Result batchDelete(Long [] ids);
}
