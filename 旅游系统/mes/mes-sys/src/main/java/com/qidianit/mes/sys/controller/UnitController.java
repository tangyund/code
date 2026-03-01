package com.qidianit.mes.sys.controller;

import com.qidianit.mes.sys.service.UnitService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 计量单位管理Controller
 */
@RestController
@RequestMapping("/unit")
public class UnitController {

    @Autowired
    private UnitService unitService;

    /**
     * 分页查询计量单位
     */
    @GetMapping("/page")
    // 修改:public PageResult<Unit> selectUnitPage(
    // 修改:        @RequestParam(defaultValue = "1") Long current,
    // 修改:        @RequestParam(defaultValue = "10") Long size,
    public Result<?> selectUnitPage(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int size,
            Unit unit) {
        return unitService.selectUnitPage(pageNum, size, unit);
    }

    /**
     * 根据编码查询计量单位
     */
    @GetMapping("/code/{code}")
    public Result<Unit> selectByCode(@PathVariable String code) {
        return unitService.selectByCode(code);
    }

    /**
     * 新增计量单位
     */
    @PostMapping
    public Result<Unit> addUnit(@RequestBody Unit unit) {
        return unitService.addUnit(unit);
    }

    /**
     * 更新计量单位
     */
    @PutMapping
    public Result<Unit> updateUnit(@RequestBody Unit unit) {
        return unitService.updateUnit(unit);
    }

    /**
     * 删除计量单位
     */
    @DeleteMapping("/{id}")
    public Result<?> deleteUnit(@PathVariable Long id) {
        return unitService.deleteUnit(id);
    }

    /**
     * 批量删除计量单位
     */
    @DeleteMapping("/batch")
    public Result<?> batchDeleteUnit(@RequestBody List<Long> ids) {
        return unitService.batchDeleteUnit(ids);
    }

    /**
     * 修改计量单位状态
     */
    @PutMapping("/{id}/status")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        return unitService.changeStatus(id, status);
    }

    /**
     * 查询计量单位树形结构
     */
    @GetMapping("/tree")
    public Result<List<Unit>> selectUnitTree(@RequestParam(required = false) Integer isMainUnit) {
        List<Unit> tree = unitService.selectUnitTree(isMainUnit);
        return Result.success(tree);
    }
}
