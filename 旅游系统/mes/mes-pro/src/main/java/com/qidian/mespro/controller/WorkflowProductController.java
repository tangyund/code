package com.qidian.mespro.controller;

import com.github.pagehelper.PageInfo;
import com.qidian.mespro.service.WorkflowProductService;
import com.qidian.mespro.vo.WorkflowProcessVo;
import com.qidian.mespro.vo.WorkflowProductVo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.WorkflowProcess;
import com.qidianit.mes.pro.pojo.WorkflowProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/19 - 下午4:17
 */
@RestController
@RequestMapping("/workflowProduct")
public class WorkflowProductController {

    @Autowired
    WorkflowProductService workflowProductService;
    @GetMapping("/page")
    public Result<PageInfo<WorkflowProductVo>> list(@RequestParam(value = "workflowId", required = false) Long workflowId,
                                                    @RequestParam(defaultValue = "1")int page,
                                                    @RequestParam(defaultValue = "10")int size){
        return workflowProductService.selectList(workflowId,page,size);
    }
    @PostMapping("/add")
    public Result addWorkflowProduct(@RequestBody WorkflowProduct workflowProduct){
        return workflowProductService.addproduct(workflowProduct);
    }
    @GetMapping("/{id}")
    public Result selectByIdWorkflowProductVo(@PathVariable("id") Long id){
        return workflowProductService.selectByIdWorkflowProductVo(id);
    }
    @PutMapping("/update")
    public Result update(@RequestBody WorkflowProduct workflowProduct){
        return workflowProductService.updateworkflowprduct(workflowProduct);
    }
    @DeleteMapping("/delete/{id}")
    public Result deleteWorkflow(@PathVariable Long id){
        return workflowProductService.deleteWorkflowproduct(id);
    }
    @DeleteMapping("/batchDelete")
    public Result batchDelete(Long [] id){
        return workflowProductService.batchDelete(id);
    };
}
