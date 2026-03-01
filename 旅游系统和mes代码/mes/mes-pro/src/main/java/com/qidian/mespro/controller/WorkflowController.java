package com.qidian.mespro.controller;

import com.github.pagehelper.PageInfo;
import com.qidian.mespro.service.WorkflowService;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.pro.pojo.Workflow;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/18 - 下午1:49
 */
@RestController
@RequestMapping("/workflow")
public class WorkflowController {

    @Autowired
    WorkflowService workflowService;

    @GetMapping("/page")
    public Result<PageInfo<Workflow>> list(Workflow workflow, @RequestParam(defaultValue = "1")int page, @RequestParam(defaultValue = "10")int size){
       return workflowService.selectList(workflow,page,size);
    }

    @GetMapping("/code/{code}")
    public Result selectByCode(@PathVariable("code") String code){
        return workflowService.selectByCode(code);
    }
    @PostMapping("/add")
    public Result save(@RequestBody Workflow workflow){
        return workflowService.addwork(workflow);
    }
    @PutMapping("/update")
    public Result update(@RequestBody Workflow workflow){
        return workflowService.update(workflow);
    }

    @DeleteMapping("/delete/{id}")
    public Result deleteWorkflow(@PathVariable Long id) {
        return workflowService.deleteWorkflow(id);
    }
    @DeleteMapping("/batchDelete")
    public Result batchDelete(Long [] id){
        return workflowService.batchDelete(id);
    };

}
