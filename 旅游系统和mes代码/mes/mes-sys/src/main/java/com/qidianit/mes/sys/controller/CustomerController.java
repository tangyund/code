package com.qidianit.mes.sys.controller;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.Customer;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.sys.mapper.CustomerMapper;
import com.qidianit.mes.sys.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * @ Description:
 * @ Author: 戴着假发的程序员
 * @ Date: 2025/9/16 - 17:08
 */
@RestController
@RequestMapping("/customer")
public class CustomerController {
    @Autowired
    private CustomerService customerService;

    @DeleteMapping("/batchDelete")
    public Result batchDelete(Long [] id){
        return customerService.batchDelete(id);
    };

    @DeleteMapping("/delete/{id}")
    public Result deleteById(@PathVariable Long id){
        return customerService.deleteById(id);
    }

    @PutMapping("/update")
    public Result update(@RequestBody Customer customer){
        return customerService.updateById(customer);
    };

    @PostMapping("/add")
    public Result<Customer> save(@RequestBody Customer customer){
        return customerService.saveCustomer(customer);
    };

    @GetMapping("/code/{code}")
    public Result<Customer> getByCode(@PathVariable("code") String code){
        return customerService.selectByCode(code);
    }

    @GetMapping("page")
    public Result<PageInfo<Customer>> list(Customer customer, @RequestParam(defaultValue = "1")int pageNum,@RequestParam(defaultValue = "10")int size){
        return customerService.selectList(customer,pageNum,size);
    };
}
