package com.qidian.mespro.service;

import com.github.pagehelper.PageInfo;
import com.qidian.mespro.vo.WorkflowProcessVo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Workflow;
import com.qidianit.mes.pro.pojo.WorkflowProcess;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/18 - 下午4:27
 */
public interface WorkflowProcessService {

    Result<PageInfo<WorkflowProcessVo>> selectList(WorkflowProcessVo workflowProcessVo, int page, int size );


    Result addWorkflowProcess(WorkflowProcess workflowProcess);

    Result selectByworkflowProcessId(Long id);

    Result updateworkflowprocess(WorkflowProcess workflowProcess);

    Result deleteWorkflowprocesss(Long id);

    Result batchDelete(Long [] ids);

}
