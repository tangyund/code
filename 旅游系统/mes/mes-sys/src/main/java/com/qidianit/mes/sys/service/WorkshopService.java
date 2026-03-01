package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 车间管理Service接口
 */
public interface WorkshopService extends IService<Workshop> {

    /**
     * 分页查询车间
     * @param pageNum 页码
     * @param size 每页大小
     * @param workshop 查询条件
     * @return 车间分页列表
     */
    Result<?> selectWorkshopPage(int pageNum, int size, Workshop workshop);

    /**
     * 根据编码查询车间
     * @param code 车间编码
     * @return 车间信息
     */
    Result<Workshop> selectByCode(String code);

    /**
     * 新增车间
     * @param workshop 车间信息
     * @return 操作结果
     */
    Result<Workshop> addWorkshop(Workshop workshop);

    /**
     * 更新车间
     * @param workshop 车间信息
     * @return 操作结果
     */
    Result<Workshop> updateWorkshop(Workshop workshop);

    /**
     * 删除车间
     * @param id 车间ID
     * @return 操作结果
     */
    Result<?> deleteWorkshop(Long id);

    /**
     * 批量删除车间
     * @param ids 车间ID列表
     * @return 操作结果
     */
    Result<?> batchDeleteWorkshop(List<Long> ids);

    /**
     * 修改车间状态
     * @param id 车间ID
     * @param status 状态：0-禁用，1-启用
     * @return 操作结果
     */
    Result<?> changeStatus(Long id, Integer status);
}