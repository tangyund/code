package com.qidian.mespro.mapper;

import com.qidianit.mes.pojo.Customer;
import com.qidianit.mes.pro.pojo.Process;
import org.apache.ibatis.annotations.Param;
import org.apache.tomcat.jni.Proc;

import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午2:18
 */
public interface ProcessMapper {
    /**
     * @Author tangyuguo
     * @Description 多条件查询
     * @Param
     * @Date 2025/9/17 下午2:22
     * @return
     */
    List<Process> selectList(Process process);
    /**
     * @Author tangyuguo
     * @Description
     * @Param 新增工序
     * @Date 2025/9/17 下午2:48
     * @return
     */
    int addProcess(Process process);
    /**
     * @Author tangyuguo
     * @Description
     * @Param 根据工序编号当个工序对象
     * @Date 2025/9/17 下午3:03
     * @return
     */
    int selectByCode(String code);
    /**
     * @Author tangyuguo
     * @Description 编辑process
     * @Param
     * @Date 2025/9/17 下午3:13
     * @return
     */
    int updateById(Process process);
    /**
     * @Author tangyuguo
     * @Description 根据id删除
     * @Param
     * @Date 2025/9/17 下午3:40
     * @return
     */
    int deleteById(Long id);
    /**
     * @Author tangyuguo
     * @Description
     * @Param 根据id批量删除
     * @Date 2025/9/17 下午3:46
     * @return
     */
    int batchDelete(@Param("ids") Long [] ids);
}
