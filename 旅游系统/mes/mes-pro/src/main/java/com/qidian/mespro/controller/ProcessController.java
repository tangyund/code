package com.qidian.mespro.controller;

import com.github.pagehelper.PageInfo;
import com.qidian.mespro.service.ProcessService;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.Process;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午2:21
 */
@RestController
@RequestMapping("/process")
public class ProcessController {

    @Autowired
    ProcessService processService;

    @GetMapping("/autoCode")

    public Result<String> autoCode(){
        return processService.autoCode();
    }
    @GetMapping("/page")
    public Result<PageInfo<Process>> list(Process process, @RequestParam(defaultValue = "1")int pageNum, @RequestParam(defaultValue = "10")int size){
        return processService.selectList(process,pageNum,size);
    };




    @GetMapping("/code/{code}")
    public Result selectByCode(@PathVariable("code") String code){
        return processService.selectByCode(code);
    }
    @PutMapping("/update")
    public Result updateById(@RequestBody Process process){
        return processService.updateById(process);
    }
    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Long id){
        return processService.deleteById(id);
    }
    @DeleteMapping("/batchDelete")
    public Result batchDelete(Long [] id){
        return processService.batchDelete(id);
    };

}
