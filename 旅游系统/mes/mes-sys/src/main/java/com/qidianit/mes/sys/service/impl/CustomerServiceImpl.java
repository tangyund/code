package com.qidianit.mes.sys.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.Customer;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.sys.mapper.CustomerMapper;
import com.qidianit.mes.sys.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ Description:
 * @ Author: 戴着假发的程序员
 * @ Date: 2025/9/16 - 17:06
 */
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;

    @Override
    public Result batchDelete(Long[] ids) {
        return customerMapper.batchDelete(ids) > 0?Result.success():Result.error("删除失败");
    }

    @Override
    public Result deleteById(Long id) {
        return customerMapper.deleteById(id) == 1?Result.success():Result.error("删除失败");
    }

    @Override
    public Result updateById(Customer customer) {
        return customerMapper.updateById(customer) == 1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result<PageInfo<Customer>> selectList(Customer customer, int pageNum, int pageSize) {
        // 开启分页
        PageHelper.startPage(pageNum,pageSize);
        List<Customer> customers = customerMapper.selectList(customer);
        // 最终返回的是一个Result，其中的数据是PageInfo
        return Result.success(new PageInfo<>(customers));
    }

    @Override
    public Result<Customer> selectByCode(String code) {
        return Result.success(customerMapper.selectByCode(code));
    }

    @Override
    public Result<Customer> saveCustomer(Customer customer) {
        return customerMapper.saveCustomer(customer) == 1?Result.success(customer):Result.error("保存失败");
    }
}
