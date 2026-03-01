package com.qidianit.mes.sys.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.Customer;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pojo.Supplier;
import com.qidianit.mes.sys.mapper.SupplierMapper;
import com.qidianit.mes.sys.service.SupplierService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/16 - 下午7:48
 */
@Service
public class SupplierServicelmpl implements SupplierService {

    @Autowired
    private SupplierMapper supplierMapper;
    @Override
    public Result<PageInfo<Supplier>> selectList(Supplier supplier, int pageNum, int pageSize) {
        PageHelper.startPage(pageNum,pageSize);
        List<Supplier> suppliers = supplierMapper.selectList(supplier);
        // 最终返回的是一个Result，其中的数据是PageInfo
        return Result.success(new PageInfo<>(suppliers));
    }

    @Override
    public Result<Supplier> selectByCode(String code) {
        return Result.success(supplierMapper.selectByCode(code));
    }

    @Override
    public Result<Supplier> saveSupplier(Supplier supplier) {
        return supplierMapper.saveSupplier(supplier) == 1?Result.success(supplier):Result.error("保存失败");
    }

    @Override
    public Result<Supplier> updateSupplier(Supplier supplier) {
        return supplierMapper.updateById(supplier)== 1 ? Result.success():Result.error("编辑失败");
    }

    @Override
    public Result deleteById(Long id) {
        return supplierMapper.deleteById(id) == 1?Result.success():Result.error("删除失败");
    }

    @Override
    public Result batchDelete(Long[] ids) {
        return supplierMapper.batchDelete(ids)>0?Result.success():Result.error("删除失败");
    }
}
