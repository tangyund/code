package com.qidian.mespro.service.lmpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidian.mespro.mapper.WorkflowMapper;
import com.qidian.mespro.service.WorkflowService;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Workflow;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午11:12
 */
@Service
public class WorkflowServicelmpl implements WorkflowService {

    @Autowired
    WorkflowMapper workflowMapper;

    @Override
    public Result<PageInfo<Workflow>> selectList(Workflow workflow, int page, int size) {
        PageHelper.startPage(page,size);
        List<Workflow> workflowList= workflowMapper.selectList(workflow);
        return Result.success(new PageInfo<>(workflowList));
    }

    @Override
    public Result selectByCode(String code) {
        return Result.success(workflowMapper.selectByCode(code));
    }

    @Override
    public Result addwork(Workflow workflow) {
        return workflowMapper.addworkflow(workflow) == 1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result update(Workflow workflow) {
        return workflowMapper.updateworkflow(workflow) == 1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result deleteWorkflow(Long id) {
        return workflowMapper.deleteWorkflow(id) == 1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result batchDelete(Long[] ids) {
        return workflowMapper.batchDelete(ids)>0? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result deleteWorkflowproduct(Long id) {
        return null;
    }


}
