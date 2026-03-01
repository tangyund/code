package com.qidian.mespro.controller;

import com.github.pagehelper.PageInfo;
import com.qidian.mespro.service.ProductionOrderService;
import com.qidian.mespro.vo.ProductionOrderVo;
import com.qidian.mespro.vo.WorkflowProductVo;
import com.qidianit.mes.pojo.Material;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pro.pojo.ProcessStep;
import com.qidianit.mes.pro.pojo.ProductionOrder;
import com.qidianit.mes.pro.pojo.TaskList;
import com.qidianit.mes.pro.pojo.WorkflowProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.scheduling.config.Task;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/20 - 下午2:35
 */
@RestController
@RequestMapping("/productionOrder")
public class ProductionOrderController {
    @Autowired
    ProductionOrderService productionOrderService;
    @GetMapping("/list")
    public Result<PageInfo<ProductionOrderVo>> selectList(ProductionOrderVo productionOrderVo,
     @RequestParam(defaultValue = "1") int pageNum,@RequestParam(defaultValue = "10") int pageSize) {
    return productionOrderService.selectList(productionOrderVo,pageNum,pageSize);
    }
    @GetMapping("/{id}")
    public Result selectById(@PathVariable Long id){
        return  productionOrderService.selectByIdProductionOrderVo(id);
    }

    @PostMapping("/add")
    public Result addWorkflowProduct(@RequestBody ProductionOrder productionOrder){

        return productionOrderService.insertProdcutionOrder(productionOrder);
    }
    @PostMapping("/addtask")
    public Result addTask(@RequestBody TaskList taskList){

        return productionOrderService.addTaskList(taskList);
    }
    @PutMapping("/update")
    public Result updateById(@RequestBody ProductionOrder productionOrder){
        return productionOrderService.updateProductionOrder(productionOrder);
    }
    @DeleteMapping("/delete/{id}")
    public Result deleteWorkflow(@PathVariable Long id){
        return productionOrderService.deleteProductionOrder(id);
    }
    @PutMapping("/audit/{id}")
    public Result audit(@PathVariable Long id){
        return productionOrderService.auditProductionOrder(id);
    }
    @PutMapping("/cancle/{id}")
    public Result cancle(@PathVariable Long id){
        return productionOrderService.cancleProductionOrder(id);
    }

    @PutMapping("/confirm/{id}")
    public Result confirm(@PathVariable Long id){
        return productionOrderService.confirmProductionOrder(id);
    }
    @GetMapping("/bomlist")
    public Result<PageInfo<Material>> selectList(String code,
     @RequestParam(defaultValue = "1") int pageNum, @RequestParam(defaultValue = "10") int pageSize) {
        return productionOrderService.selectByParentIdMaterials(code,pageNum,pageSize);
    }
    @GetMapping("/allRealist")
    public Result<PageInfo<ProductionOrderVo>> selectAllReadytList(ProductionOrderVo productionOrderVo,
    @RequestParam(defaultValue = "1") int pageNum,@RequestParam(defaultValue = "10") int pageSize) {
        return productionOrderService.selectAllReadyByProductionOrderList(productionOrderVo,pageNum,pageSize);
    }
    @GetMapping("/get/{id}")
    public Result selectByAllId(@PathVariable Long id){
        return  productionOrderService.selectByIdProductVoAndMaterialAndUnit(id);
    }
    @GetMapping("/code/{code}")
    public Result selectByCode(@PathVariable String code){
        return  productionOrderService.selectProcessByMatericalCode(code);
    }
    @GetMapping("/tasklist/{workflowId}/{processId}/{code}")
    public Result selectTaskList(@PathVariable Long workflowId,@PathVariable Long processId,@PathVariable String code){
        return  productionOrderService.selectTaskListByworkflowIdandProcessId(workflowId,processId,code);
    }
    @PostMapping("/calculateCompletionTime")
    public Map<String, Object> calculateCompletionTime(
            @RequestParam("startTime")
            @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
            LocalDateTime startTime,
            @RequestParam("productionDuration")
            Integer productionDuration) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 验证输入参数
            if (startTime == null) {
                throw new IllegalArgumentException("开始时间不能为空");
            }
            if (productionDuration == null || productionDuration <= 0) {
                throw new IllegalArgumentException("生产时长必须为正数");
            }
            // 计算预计完成时间
            LocalDateTime estimatedCompletionTime = startTime.plusHours(productionDuration);
            // 返回计算结果
            result.put("success", true);
            result.put("estimatedCompletionTime", estimatedCompletionTime);
            result.put("message", "计算成功");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "计算失败: " + e.getMessage());
        }
        return result;
    }

    @GetMapping("/task/{id}")
    public Result<TaskList> selectTaskListByWorkflowIdAndProcessId(@PathVariable Long id){
        return productionOrderService.selectTaskListById(id);
    }

    @PutMapping("/updatetasklist")
    public Result updateById(@RequestBody TaskList taskList){
        return productionOrderService.updateTasklist(taskList);
    }

    @DeleteMapping("/deletetask/{id}")
    public Result deleteTask(@PathVariable Long id){
        return productionOrderService.deleteById(id);
    }
    @DeleteMapping("/batchDelete")
    public Result batchDelete(@RequestParam("ids") Long [] ids){
        return productionOrderService.deleteByIdList(ids);
    };







}
