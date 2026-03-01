package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.*;
/**
 * 物料管理Service接口
 */
public interface MaterialService extends IService<Material> {

    /**
     * 分页查询物料
     * @param pageNum 页码
     * @param size 每页大小
     * @param material 查询条件
     * @return 物料分页列表
     */
    Result<?> selectMaterialPage(int pageNum, int size, Material material);

    /**
     * 根据编码查询物料
     * @param code 物料编码
     * @return 物料信息
     */
    Result<Material> selectByCode(String code);

    /**
     * 新增物料
     * @param material 物料信息
     * @return 操作结果
     */
    Result<Material> addMaterial(Material material);

    /**
     * 更新物料
     * @param material 物料信息
     * @return 操作结果
     */
    Result<Material> updateMaterial(Material material);

    /**
     * 删除物料
     * @param id 物料ID
     * @return 操作结果
     */
    Result<?> deleteMaterial(Long id);

    /**
     * 批量删除物料
     * @param ids 物料ID列表
     * @return 操作结果
     */
    Result<?> batchDeleteMaterial(List<Long> ids);

    /**
     * 修改物料状态
     * @param id 物料ID
     * @param status 状态：0-禁用，1-启用
     * @return 操作结果
     */
    Result<?> changeStatus(Long id, Integer status);

    /**
     * 根据分类ID查询物料列表
     * @param categoryId 分类ID
     * @return 物料列表
     */
    List<Material> selectByCategoryId(Long categoryId);

    /**
     * 根据是否高价值查询物料列表
     * @param isHighValue 是否高价值(0:否,1:是)
     * @return 物料列表
     */
    List<Material> selectByHighValue(Integer isHighValue);

    public Result<PageInfo<Material>>selectList(Material material, int pageNum, int size);
}