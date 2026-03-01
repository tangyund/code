package com.qidian.mespro.service.lmpl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidian.mespro.mapper.WorkflowProcessMapper;
import com.qidian.mespro.service.WorkflowProcessService;
import com.qidian.mespro.vo.WorkflowProcessVo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pojo.SysDictType;
import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.pro.pojo.WorkflowProcess;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/18 - 下午4:28
 */
@Service
public class WorkflowProcessServicelmpl implements WorkflowProcessService {

    @Autowired
    WorkflowProcessMapper workflowProcessMapper;

    @Override
    public Result<PageInfo<WorkflowProcessVo>> selectList(WorkflowProcessVo workflowProcessVo, int page, int size) {

        PageHelper.startPage(page,size);
        // 检查参数是否为空
        if (workflowProcessVo == null || workflowProcessVo.getWorkflowId() == null) {
            return Result.error("请提供有效的工艺流程ID");
        }

        // 先查询当前工艺流程ID下的所有工序
        List<WorkflowProcessVo> allProcessVos = new ArrayList<>();
        int stepId = 1;
        WorkflowProcessVo processVo = workflowProcessMapper.selectList(workflowProcessVo.getWorkflowId(), stepId);
        while (processVo != null) {
            // 设置关联信息
            processVo.setProcess(workflowProcessMapper.selectProcess(workflowProcessVo.getWorkflowId(), stepId));
            processVo.setNextProcess(workflowProcessMapper.selectNextProcess(workflowProcessVo.getWorkflowId(), stepId));
            processVo.setRelationNextDict(workflowProcessMapper.selectrelationNextDict(workflowProcessVo.getWorkflowId(), stepId));
            allProcessVos.add(processVo);
            
            stepId++;
            processVo = workflowProcessMapper.selectList(workflowProcessVo.getWorkflowId(), stepId);
        }
        return Result.success(new PageInfo<>(allProcessVos));
    }

    @Override
    public Result addWorkflowProcess(WorkflowProcess workflowProcess) {
        // 检查步骤序号是否已存在（针对当前工艺）
        List<WorkflowProcessVo> existingProcesses = new ArrayList<>();
        int stepId = 1;
        WorkflowProcessVo processVo = workflowProcessMapper.selectList(workflowProcess.getWorkflowId(), stepId);
        while (processVo != null) {
            existingProcesses.add(processVo);
            stepId++;
            processVo = workflowProcessMapper.selectList(workflowProcess.getWorkflowId(), stepId);
        }
        
        // 检查指定的步骤序号是否已存在
        for (WorkflowProcessVo existing : existingProcesses) {
            if (existing.getStepOrder() == workflowProcess.getStepOrder()) {
                return Result.error(500, "工序[" + workflowProcess.getStepOrder() + "]已经存在");
            }
        }
        
        // 检查工序是否已存在（针对当前工艺）
        for (WorkflowProcessVo existing : existingProcesses) {
            if (existing.getProcessId().equals(workflowProcess.getProcessId())) {
                Process process = workflowProcessMapper.selectByProcessId(workflowProcess.getProcessId());
                return Result.error(500, "工序" + process.getProcessName() + "已存在");
            }
        }
        if (workflowProcess.getStepOrder()!=stepId)
            return Result.error(500, "请先添加工序"+stepId);
        
        if (workflowProcessMapper.addWorkflowProcess(workflowProcess) == 1) {
            return Result.success("200", "操作成功");
        } else {
            return Result.error(500, "编辑失败");
        }
    }

    @Override
    public Result selectByworkflowProcessId(Long id) {
        WorkflowProcessVo workflowProcessVo = workflowProcessMapper.selectByworkflowProcessId(id);
        workflowProcessVo.setProcess(workflowProcessMapper.selectProcess(workflowProcessVo.getProcessId(),workflowProcessVo.getStepOrder()));
        return Result.success(workflowProcessVo);
    }

    @Override
    public Result updateworkflowprocess(WorkflowProcess workflowProcess) {

        WorkflowProcess existingRecord = workflowProcessMapper.selectByworkflowProcessId(workflowProcess.getId());
        if (existingRecord == null) {
            return Result.error(500, "工序不存在");
        }

        // 获取当前工艺下的所有工序
        List<WorkflowProcessVo> existingProcesses = new ArrayList<>();
        int stepId = 1;
        WorkflowProcessVo processVo = workflowProcessMapper.selectList(existingRecord.getWorkflowId(), stepId);
        while (processVo != null) {
            existingProcesses.add(processVo);
            stepId++;
            processVo = workflowProcessMapper.selectList(existingRecord.getWorkflowId(), stepId);
        }

        // 检查工序序号是否重复（排除当前记录）
        if (workflowProcess.getStepOrder() != null) {
            // 如果要修改的工序序号与原序号不同
            if (!workflowProcess.getStepOrder().equals(existingRecord.getStepOrder())) {
                for (WorkflowProcessVo existing : existingProcesses) {
                    if (existing.getStepOrder() == workflowProcess.getStepOrder() && !existing.getId().equals(workflowProcess.getId())) {
                        return Result.error(500, "工序序号[" + workflowProcess.getStepOrder() + "]已经存在");
                    }
                }
            }
        }

        // 检查工序是否重复（排除当前记录）
        if (workflowProcess.getProcessId() != null) {
            // 如果要修改的工序ID与原工序ID不同
            if (!workflowProcess.getProcessId().equals(existingRecord.getProcessId())) {
                for (WorkflowProcessVo existing : existingProcesses) {
                    if (existing.getProcessId().equals(workflowProcess.getProcessId()) && !existing.getId().equals(workflowProcess.getId())) {
                        Process process = workflowProcessMapper.selectByProcessId(workflowProcess.getProcessId());
                        return Result.error(500, "工序\"" + process.getProcessName() + "\"已存在");
                    }
                }
            }
        }

        if (workflowProcessMapper.updateworkflowprocess(workflowProcess) == 1) {
            return Result.success("200", "操作成功");
        } else {
            return Result.error(500, "操作失败");
        }
    }

    @Override
    public Result deleteWorkflowprocesss(Long id) {
        return workflowProcessMapper.deleteWorkflowprocess(id) == 1 ? Result.success("200","操作成功"):Result.error(500,"编辑失败");
    }

    @Override
    public Result batchDelete(Long[] ids) {
        return workflowProcessMapper.batchDelete(ids) >0 ? Result.success("200","操作成功"):Result.error(500,"编辑失败");
    }
}
