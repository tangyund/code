package com.qidianit.mes.sys.mapper;

import com.qidianit.mes.pojo.Customer;
import com.qidianit.mes.pojo.Result;
import com.qidianit.mes.pojo.Supplier;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/16 - 下午7:47
 */
@Mapper
public interface SupplierMapper {

    /**
     * @Author tangyuguo
     * @Description 多条件分页查询供应商列表
     * @Param Supplier
     * @Date 2025/9/16 下午7:53
     * @return
     */
    List<Supplier> selectList(Supplier supplier);
    /**
     * @Author tangyuguo
     * @Description根据供应商编号查询单个供应商信息
     * @Param code
     * @Date 2025/9/16 下午8:08
     * @return 
     */
    Supplier selectByCode(String code);

    /**
     * @Author tangyuguo
     * @Description 新增供应商
     * @Param 
     * @Date 2025/9/16 下午8:20
     * @return 
     */
    int saveSupplier(Supplier supplier);
    /**
     * @Author tangyuguo
     * @Description 根据id编辑供应商信息
     * @Param
     * @Date 2025/9/16 下午10:57
     * @return
     */
    int updateById(Supplier supplier);

    /**
     * @Author tangyuguo
     * @Description 删除供应商根据id
     * @Param
     * @Date 2025/9/16 下午11:09
     * @return
     */
    int deleteById(Long id);

    /**
     * @Author tangyuguo
     * @Description 批量删除
     * @Param
     * @Date 2025/9/16 下午11:23
     * @return
     */
    int batchDelete(@Param("ids") Long [] ids);

}
