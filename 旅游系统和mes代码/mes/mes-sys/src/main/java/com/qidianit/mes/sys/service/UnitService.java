package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 计量单位管理Service接口
 */
public interface UnitService extends IService<Unit> {

    /**
     * 分页查询计量单位
     * @param pageNum 页码
     * @param size 每页大小
     * @param unit 查询条件
     * @return 计量单位分页列表
     */
    Result<?> selectUnitPage(int pageNum, int size, Unit unit);

    /**
     * 根据编码查询计量单位
     * @param code 计量单位编码
     * @return 计量单位信息
     */
    Result<Unit> selectByCode(String code);

    /**
     * 新增计量单位
     * @param unit 计量单位信息
     * @return 操作结果
     */
    Result<Unit> addUnit(Unit unit);

    /**
     * 更新计量单位
     * @param unit 计量单位信息
     * @return 操作结果
     */
    Result<Unit> updateUnit(Unit unit);

    /**
     * 删除计量单位
     * @param id 计量单位ID
     * @return 操作结果
     */
    Result<?> deleteUnit(Long id);

    /**
     * 批量删除计量单位
     * @param ids 计量单位ID列表
     * @return 操作结果
     */
    Result<?> batchDeleteUnit(List<Long> ids);

    /**
     * 修改计量单位状态
     * @param id 计量单位ID
     * @param status 状态：0-禁用，1-启用
     * @return 操作结果
     */
    Result<?> changeStatus(Long id, Integer status);

    /**
     * 查询计量单位树形结构（主单位及其对应的辅单位）
     * @param isMainUnit 是否主单位(null表示查询所有)
     * @return 计量单位树形结构列表
     */
    List<Unit> selectUnitTree(Integer isMainUnit);
}