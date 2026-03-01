package com.qidianit.mes.sys.controller;

import com.qidianit.mes.sys.service.MaterialCategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 物料分类管理Controller
 */
@RestController
@RequestMapping("/materialCategory")
public class MaterialCategoryController {

    @Autowired
    private MaterialCategoryService materialCategoryService;

    /**
     * 分页查询物料分类
     */
    @GetMapping("/page")
    // 修改:public PageResult<MaterialCategory> selectCategoryPage(
    // 修改:        @RequestParam(defaultValue = "1") Long current,
    // 修改:        @RequestParam(defaultValue = "10") Long size,
    public Result<?> selectCategoryPage(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int size,
            MaterialCategory category) {
        return materialCategoryService.selectCategoryPage(pageNum, size, category);
    }

    /**
     * 根据编码查询物料分类
     */
    @GetMapping("/code/{code}")
    public Result<MaterialCategory> selectByCode(@PathVariable String code) {
        return materialCategoryService.selectByCode(code);
    }

    /**
     * 新增物料分类
     */
    @PostMapping
    public Result<MaterialCategory> addCategory(@RequestBody MaterialCategory category) {
        return materialCategoryService.addCategory(category);
    }

    /**
     * 更新物料分类
     */
    @PutMapping
    public Result<MaterialCategory> updateCategory(@RequestBody MaterialCategory category) {
        return materialCategoryService.updateCategory(category);
    }

    /**
     * 删除物料分类
     */
    @DeleteMapping("/{id}")
    public Result<?> deleteCategory(@PathVariable Long id) {
        return materialCategoryService.deleteCategory(id);
    }

    /**
     * 批量删除物料分类
     */
    @DeleteMapping("/batch")
    public Result<?> batchDeleteCategory(@RequestBody List<Long> ids) {
        return materialCategoryService.batchDeleteCategory(ids);
    }

    /**
     * 修改物料分类状态
     */
    @PutMapping("/{id}/status")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        return materialCategoryService.changeStatus(id, status);
    }

    /**
     * 查询物料分类树形结构
     */
    @GetMapping("/tree")
    public Result<List<MaterialCategory>> selectCategoryTree(
            @RequestParam(required = false) Long parentId,
            @RequestParam(required = false) Integer status) {
        List<MaterialCategory> tree = materialCategoryService.selectCategoryTree(parentId, status);
        return Result.success(tree);
    }
}
