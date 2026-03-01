package com.qidianit.mes.sys.controller;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.Customer;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pojo.Supplier;
import com.qidianit.mes.sys.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/16 - 下午8:01
 */
@RequestMapping("/supplier")
@RestController
public class SupperlierController {

    @Autowired
    SupplierService supplierService;
    @GetMapping("page")
    public Result<PageInfo<Supplier>> list(Supplier supplier, @RequestParam(defaultValue = "1")int pageNum, @RequestParam(defaultValue = "10")int size){
        return supplierService.selectList(supplier,pageNum,size);
    };

    @GetMapping("/code/{code}")
    public Result<Supplier> getByCode(@PathVariable("code") String code){
        return supplierService.selectByCode(code);
    }
    @PostMapping("/add")
    public Result<Supplier>addSupplier(@RequestBody Supplier supplier){
        return supplierService.saveSupplier(supplier);
    }
    @PutMapping("/update")
    public Result<Supplier>updateSupplier(@RequestBody Supplier supplier){
        return supplierService.updateSupplier(supplier);
    }
    @DeleteMapping("/delete/{id}")
    public Result deleteSupplier(@PathVariable long id){
        return supplierService.deleteById(id);
    }
    @DeleteMapping("/batchDelete")
    public Result batchDelete(Long [] id){
        return supplierService.batchDelete(id);
    }
}
