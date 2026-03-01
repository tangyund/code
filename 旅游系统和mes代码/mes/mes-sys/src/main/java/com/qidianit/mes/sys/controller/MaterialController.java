package com.qidianit.mes.sys.controller;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pro.pojo.Process;
import com.qidianit.mes.sys.service.MaterialService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 物料管理Controller
 */
@RestController
@RequestMapping("/material")
@CrossOrigin
public class MaterialController {

    @Autowired
    private MaterialService materialService;

    /**
     * 分页查询物料
     */
    @GetMapping("/list")
    public Result<PageInfo<Material>> selectList(Material material, @RequestParam(defaultValue = "1")int pageNum, @RequestParam(defaultValue = "10")int size) {
        return materialService.selectList( material,pageNum, size);
    }



    /**
     * 根据编码查询物料
     */
    @GetMapping("/code/{code}")
    public Result<Material> selectByCode(@PathVariable("code") String code) {
        return materialService.selectByCode(code);
    }

    /**
     * 新增物料
     */
    @PostMapping
    public Result<Material> addMaterial(@RequestBody Material material) {
        return materialService.addMaterial(material);
    }

    /**
     * 更新物料
     */
    @PutMapping
    public Result<Material> updateMaterial(@RequestBody Material material) {
        return materialService.updateMaterial(material);
    }

    /**
     * 删除物料
     */
    @DeleteMapping("/{id}")
    public Result<?> deleteMaterial(@PathVariable Long id) {
        return materialService.deleteMaterial(id);
    }

    /**
     * 批量删除物料
     */
    @DeleteMapping("/batch")
    public Result<?> batchDeleteMaterial(@RequestBody List<Long> ids) {
        return materialService.batchDeleteMaterial(ids);
    }

    /**
     * 修改物料状态
     */
    @PutMapping("/{id}/status")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        return materialService.changeStatus(id, status);
    }

    /**
     * 根据分类ID查询物料列表
     */
    @GetMapping("/category/{categoryId}")
    public Result<List<Material>> selectByCategoryId(@PathVariable Long categoryId) {
        List<Material> list = materialService.selectByCategoryId(categoryId);
        return Result.success(list);
    }

    /**
     * 根据是否高价值查询物料列表
     */
    @GetMapping("/highValue/{isHighValue}")
    public Result<List<Material>> selectByHighValue(@PathVariable Integer isHighValue) {
        List<Material> list = materialService.selectByHighValue(isHighValue);
        return Result.success(list);
    }
}