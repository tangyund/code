package com.qidianit.mes.sys.service;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.Customer;
import com.qidianit.mes.pojo.Result;
import org.springframework.transaction.annotation.Transactional;

/**
 * @ Description:
 * @ Author: 戴着假发的程序员
 * @ Date: 2025/9/16 - 17:05
 */
@Transactional
public interface CustomerService {
    /**
     *
     * @param ids
     * @return
     */
    Result batchDelete(Long[] ids);
    /**
     *
     * @param id
     * @return
     */
    Result deleteById(Long id);

    /**
     *
     * @param customer
     * @return
     */
    Result updateById(Customer customer);

    /**
     *
     * @param customer
     * @param pageNum
     * @param pageSize
     * @return
     */
    Result<PageInfo<Customer>> selectList(Customer customer,int pageNum,int pageSize);

    /**
     *
     * @param code
     * @return
     */
    Result<Customer> selectByCode(String code);

    /**
     *
     * @param customer
     * @return
     */
    Result<Customer> saveCustomer(Customer customer);
}
