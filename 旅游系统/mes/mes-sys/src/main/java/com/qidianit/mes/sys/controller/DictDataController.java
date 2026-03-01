package com.qidianit.mes.sys.controller;

import com.qidianit.mes.sys.service.DictDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * @author 戴着假发的程序员
 * @company 起点编程
 * @date 2025/9/3 19:51
 * @description
 */
@RestController
@RequestMapping("/dictData")
public class DictDataController {
    @Autowired
    private DictDataService dictDataService;
    @RequestMapping("/listByPage")
    public Result<?> listByPage(SysDictData dictData, @RequestParam(defaultValue = "1") int pageNum, @RequestParam (defaultValue = "10") int size){
        return dictDataService.selectDictDataPage(dictData, pageNum, size);
    }
    @RequestMapping("/getDictDataById")
    public Result<?> getDictDataById(@RequestParam Long dictDataId){
        return Result.success(dictDataService.getById(dictDataId));
    }
    @RequestMapping("/addDictData")
    public Result<?> addDictData(@RequestBody SysDictData dictData){
        return dictDataService.addDictData(dictData);
    }
    @RequestMapping("/updateDictData")
    public Result<?> updateDictData(@RequestBody SysDictData dictData){
        return dictDataService.updateDictData(dictData);
    }
    @RequestMapping("/deleteDictData")
    public Result<?> deleteDictData(@RequestParam Long dictDataId){
        return dictDataService.deleteDictData(dictDataId);
    }
    @RequestMapping("/batchDeleteDictData")
    public Result<?> batchDeleteDictData(@RequestParam List<Long> dictDataIds){
        return dictDataService.batchDeleteDictData(dictDataIds);
    }
}
