package com.qidianit.mes.sys.mapper;

import com.qidianit.mes.pojo.Customer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @ Description:
 * @ Author: 戴着假发的程序员
 * @ Date: 2025/9/16 - 16:58
 */
public interface CustomerMapper {
    /**
     *
     * @param ids
     * @return
     */
    int batchDelete(@Param("ids") Long [] ids);

    /**
     *
     * @param customer
     * @return
     */
    List<Customer> selectList(Customer customer);

    /**
     *
     * @param code
     * @return
     */
    Customer selectByCode(String code);

    /**
     *
     * @param customer
     * @return
     */
    int saveCustomer(Customer customer);

    /**
     *
     * @param customer
     * @return
     */
    int updateById(Customer customer);

    /**
     *
     * @param id
     * @return
     */
    int deleteById(Long id);
}
