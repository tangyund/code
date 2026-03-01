package com.qidian.mespro.controller;

import com.github.pagehelper.PageInfo;
import com.qidian.mespro.service.ProductionOrderService;
import com.qidian.mespro.service.ProductionReportingService;
import com.qidian.mespro.vo.ProductionOrderVo;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.ProductionOrder;
import com.qidianit.mes.pro.pojo.ProductionReporting;
import com.qidianit.mes.pro.pojo.TaskList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/26 - 上午9:44
 */

@RestController
@RequestMapping("/productionReporting")
public class ProductionReportingController {

    @Autowired
    ProductionReportingService productionReportingService;
    @GetMapping("/list")
    public Result<PageInfo<ProductionReporting>> selectList(ProductionReporting productionReporting,
                                                            @RequestParam(defaultValue = "1") int pageNum, @RequestParam(defaultValue = "10") int pageSize) {
        return productionReportingService.selectProductionList(productionReporting,pageNum,pageSize);
    }
    @PostMapping("/add")
    public Result addReprot(@RequestBody ProductionReporting productionReporting){

        return productionReportingService.addReport(productionReporting);
    }
    @GetMapping("/{id}")
    public Result selectById(@PathVariable Long id){
        return  productionReportingService.selectReportById(id);
    }
    @PutMapping("/update")
    public Result updateById(@RequestBody ProductionReporting productionReporting){
        return productionReportingService.updateReport(productionReporting);
    }
    @DeleteMapping("/delete/{id}")
    public Result deleteWorkflow(@PathVariable Long id){
        return productionReportingService.deleteById(id);
    }

    @PutMapping("/audit/{id}")
    public Result audit(@PathVariable Long id){
        return productionReportingService.auditReport(id);
    }
    @PutMapping("/confirm/{id}")
    public Result confirm(@PathVariable Long id){
        return productionReportingService.confirmReport(id);
    }

    @PutMapping("/cancle/{id}")
    public Result cancle(@PathVariable Long id){
        return productionReportingService.cancelReport(id);
    }
    @DeleteMapping("/batchDelete")
    public Result batchDelete(@RequestParam("ids") Long [] ids){
        return productionReportingService.deleteByIdList(ids);
    };
    @GetMapping("/page")
    public Result<PageInfo<TaskList>> selectTaskList(TaskList taskList,
                                                 @RequestParam(defaultValue = "1") int pageNum, @RequestParam(defaultValue = "10") int pageSize) {
        return productionReportingService.selectTask(taskList,pageNum,pageSize);
    }

}
