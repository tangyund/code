package com.qidianit.mes.sys.controller;

import com.qidianit.mes.sys.service.DictTypeService;
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
@RequestMapping("/dictType")
public class DictTypeController {

    @Autowired
    private DictTypeService dictTypeService;

    @RequestMapping("/listByPage")
    public Result<?> listByPage(SysDictType dictType, @RequestParam(defaultValue = "1") int pageNum,@RequestParam (defaultValue = "10") int size) {
        return dictTypeService.selectDictTypePage(dictType, pageNum, size);
    }
    @RequestMapping("/addDictType")
    public Result<?> addDictType(@RequestBody SysDictType dictType) {
        return dictTypeService.addDictType(dictType);
    }

    @RequestMapping("/updateDictType")
    public Result<?> updateDictType(@RequestBody SysDictType dictType) {
        return dictTypeService.updateDictType(dictType);
    }
    @RequestMapping("/deleteDictType")
    public Result<?> deleteDictType(@RequestParam Long dictTypeId) {
        return dictTypeService.deleteDictType(dictTypeId);
    }
    @RequestMapping("/batchDeleteDictType")
    public Result<?> batchDeleteDictType(@RequestBody List<Long> dictTypeIds) {
        return dictTypeService.batchDeleteDictType(dictTypeIds);
    }
    @RequestMapping("/getDictTypeById")
    public Result<?> getDictTypeById(@RequestParam Long dictTypeId) {
        return dictTypeService.getDictType(dictTypeId);
    }
}
