package com.qidianit.mes.sys.controller;

import com.qidianit.mes.sys.service.WorkshopService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 车间管理Controller
 */
@RestController
@RequestMapping("/workshop")
public class WorkshopController {

    @Autowired
    private WorkshopService workshopService;

    /**
     * 分页查询车间
     */
    @GetMapping("/page")
    // 修改:public PageResult<Workshop> selectWorkshopPage(
    // 修改:        @RequestParam(defaultValue = "1") Long current,
    // 修改:        @RequestParam(defaultValue = "10") Long size,
    public Result<?> selectWorkshopPage(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int size,
            Workshop workshop) {
        return workshopService.selectWorkshopPage(pageNum, size, workshop);
    }

    /**
     * 根据编码查询车间
     */
    @GetMapping("/code/{code}")
    public Result<Workshop> selectByCode(@PathVariable String code) {
        return workshopService.selectByCode(code);
    }

    /**
     * 新增车间
     */
    @PostMapping
    public Result<Workshop> addWorkshop(@RequestBody Workshop workshop) {
        return workshopService.addWorkshop(workshop);
    }

    /**
     * 更新车间
     */
    @PutMapping
    public Result<Workshop> updateWorkshop(@RequestBody Workshop workshop) {
        return workshopService.updateWorkshop(workshop);
    }

    /**
     * 删除车间
     */
    @DeleteMapping("/{id}")
    public Result<?> deleteWorkshop(@PathVariable Long id) {
        return workshopService.deleteWorkshop(id);
    }

    /**
     * 批量删除车间
     */
    @DeleteMapping("/batch")
    public Result<?> batchDeleteWorkshop(@RequestBody List<Long> ids) {
        return workshopService.batchDeleteWorkshop(ids);
    }

    /**
     * 修改车间状态
     */
    @PutMapping("/{id}/status")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        return workshopService.changeStatus(id, status);
    }
}
