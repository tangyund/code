package com.qidianit.mes.sys.service;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.Customer;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pojo.Supplier;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/16 - 下午7:48
 */
public interface SupplierService {

    /**
     * @Author tangyuguo
     * @Description
     * @Param 多条件分页查询供应商列表
     * @Date 2025/9/16 下午7:56
     * @return
     */
    Result<PageInfo<Supplier>> selectList(Supplier supplier, int pageNum, int pageSize);

    /**
     * @Author tangyuguo
     * @Description 根据编号查询供应商
     * @Param code
     * @Date 2025/9/16 下午8:12
     * @return
     */
    Result<Supplier> selectByCode(String code);
    /**
     * @Author tangyuguo
     * @Description 新增供应商
     * @Param
     * @Date 2025/9/16 下午8:27
     * @return
     */
    Result<Supplier> saveSupplier(Supplier supplier);
    
    /**
     * @Author tangyuguo
     * @Description 更新数据
     * @Param supplier
     * @Date 2025/9/16 下午11:02
     * @return 
     */
    Result<Supplier> updateSupplier(Supplier supplier);
    /**
     * @Author tangyuguo
     * @Description 删除供应商根据id
     * @Param id
     * @Date 2025/9/16 下午11:08
     * @return
     */
    Result deleteById(Long id);
    /**
     * @Author tangyuguo
     * @Description 批量删除
     * @Param
     * @Date 2025/9/16 下午11:25
     * @return
     */
    Result batchDelete(Long[] ids);

}
