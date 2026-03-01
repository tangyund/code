package com.qidian.mespro.controller;

import com.github.pagehelper.PageInfo;
import com.qidian.mespro.service.WorkflowProcessService;
import com.qidian.mespro.service.WorkflowService;
import com.qidian.mespro.vo.WorkflowProcessVo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Workflow;
import com.qidianit.mes.pro.pojo.WorkflowProcess;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/18 - 下午7:44
 */
@RestController
@RequestMapping("/workflowProcess")
public class WorkflowProcessController {
    @Autowired
    WorkflowProcessService workflowProcessService;

    @GetMapping("/page")
    public Result<PageInfo<WorkflowProcessVo>> list(@RequestParam(value = "workflowId", required = false) Long workflowId,
                                                   @RequestParam(defaultValue = "1")int page,
                                                   @RequestParam(defaultValue = "10")int size){
        // 创建WorkflowProcessVo对象并设置workflowId
        WorkflowProcessVo workflowProcessVo = new WorkflowProcessVo();
        workflowProcessVo.setWorkflowId(workflowId);
        return workflowProcessService.selectList(workflowProcessVo, page, size);
    }
    @PostMapping("/add")
    public Result addWorkflowProcess(@RequestBody WorkflowProcess workflowProcess){
        return workflowProcessService.addWorkflowProcess(workflowProcess);
    }

    @GetMapping("/{id}")
    public Result selectByworkflowProcessId(@PathVariable("id") Long id){
        return workflowProcessService.selectByworkflowProcessId(id);
    }
    @PutMapping("/update")
    public Result update(@RequestBody WorkflowProcess workflowProcess){
        return workflowProcessService.updateworkflowprocess(workflowProcess);
    }
    @DeleteMapping("/delete/{id}")
    public Result deleteWorkflow(@PathVariable Long id){
        return workflowProcessService.deleteWorkflowprocesss(id);
    }
    @DeleteMapping("/batchDelete")
    public Result batchDelete(Long [] id){
        return workflowProcessService.batchDelete(id);
    };


}
