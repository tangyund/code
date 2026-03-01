package com.qidian.mespro.controller;

import com.github.pagehelper.PageInfo;
import com.qidian.mespro.service.ProcessStepService;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.pro.pojo.ProcessStep;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午4:38
 */
@RestController
@RequestMapping("/processStep")
public class ProcessStepController {

    @Autowired
    ProcessStepService processStepService;

    @GetMapping("/page")
    public Result<PageInfo<ProcessStep>> list(ProcessStep processStep, @RequestParam(defaultValue = "1")int pageNum, @RequestParam(defaultValue = "10")int size){
        return processStepService.selectByProcessId(processStep,pageNum,size);
    };
    @GetMapping("/get/{id}")
    public Result selectById(@PathVariable Long id){
        return  processStepService.selectById(id);
    }
    @PutMapping("/update")
    public Result updateById(@RequestBody ProcessStep processStep){
        return processStepService.updateById(processStep);
    }
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Long id){
        return processStepService.deleteById(id);
    }




}
