package com.qidianit.mes.sys.controller;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.sys.service.WorkstationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 工作站管理Controller
 */
@RestController
@RequestMapping("/workstation")
public class WorkstationController {

    @Autowired
    private WorkstationService workstationService;

    /**
     * 分页查询工作站
     */
    @GetMapping("/page")
    // 修改:public PageResult<Workstation> selectWorkstationPage(
    // 修改:        @RequestParam(defaultValue = "1") Long current,
    // 修改:        @RequestParam(defaultValue = "10") Long size,
    public Result<?> selectWorkstationPage(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int size,
            Workstation workstation) {
        return workstationService.selectWorkstationPage(pageNum, size, workstation);
    }
    @GetMapping("/total")
    public Result<PageInfo<Workstation>> selectAllTotal(@RequestParam(defaultValue = "1")int pageNum,
                                              @RequestParam(defaultValue = "10")int size,Workstation workstation){
        return workstationService.selectAllStaion(pageNum,size,workstation);
    };
    /**
     * 根据编码查询工作站
     */
    @GetMapping("/code/{code}")
    public Result<Workstation> selectByCode(@PathVariable String code) {
        return workstationService.selectByCode(code);
    }

    /**
     * 新增工作站
     */
    @PostMapping
    public Result<Workstation> addWorkstation(@RequestBody Workstation workstation) {
        return workstationService.addWorkstation(workstation);
    }

    /**
     * 更新工作站
     */
    @PutMapping
    public Result<Workstation> updateWorkstation(@RequestBody Workstation workstation) {
        return workstationService.updateWorkstation(workstation);
    }

    /**
     * 删除工作站
     */
    @DeleteMapping("/{id}")
    public Result<?> deleteWorkstation(@PathVariable Long id) {
        return workstationService.deleteWorkstation(id);
    }

    /**
     * 批量删除工作站
     */
    @DeleteMapping("/batch")
    public Result<?> batchDeleteWorkstation(@RequestBody List<Long> ids) {
        return workstationService.batchDeleteWorkstation(ids);
    }

    /**
     * 修改工作站状态
     */
    @PutMapping("/{id}/status")
    public Result<?> changeStatus(@PathVariable Long id, @RequestParam Integer status) {
        return workstationService.changeStatus(id, status);
    }

    /**
     * 根据车间ID查询工作站列表
     */
    @GetMapping("/workshop/{workshopId}")
    public Result<List<Workstation>> selectByWorkshopId(@PathVariable Long workshopId) {
        List<Workstation> list = workstationService.selectByWorkshopId(workshopId);
        return Result.success(list);
    }

    @GetMapping("/list")
    public Result<PageInfo<Workstation>> list(@RequestParam(defaultValue = "1")int pageNum,
    @RequestParam(defaultValue = "10")int size,Workstation workstation){
        return workstationService.selectProcessAndWorkshopByProcessId(pageNum,size,workstation);
    };
}
