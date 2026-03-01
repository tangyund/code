package com.qidian.mespro.service;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageInfo;
import com.qidian.mespro.vo.WorkflowProcessVo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Workflow;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午11:12
 */
public interface WorkflowService {

    Result<PageInfo<Workflow>> selectList(Workflow workflow,int page,int size );

    Result selectByCode(String code);

    Result addwork(Workflow workflow);

    Result update(Workflow workflow);

    Result deleteWorkflow(Long id);

    Result batchDelete(Long [] ids);

    Result deleteWorkflowproduct(Long id);

}
