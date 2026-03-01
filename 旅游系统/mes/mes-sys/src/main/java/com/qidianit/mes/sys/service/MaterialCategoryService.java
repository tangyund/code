package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 物料分类管理Service接口
 */
public interface MaterialCategoryService extends IService<MaterialCategory> {

    /**
     * 分页查询物料分类
     * @param pageNum 页码
     * @param size 每页大小
     * @param category 查询条件
     * @return 物料分类分页列表
     */
    Result<?> selectCategoryPage(int pageNum, int size, MaterialCategory category);

    /**
     * 根据编码查询物料分类
     * @param code 物料分类编码
     * @return 物料分类信息
     */
    Result<MaterialCategory> selectByCode(String code);

    /**
     * 新增物料分类
     * @param category 物料分类信息
     * @return 操作结果
     */
    Result<MaterialCategory> addCategory(MaterialCategory category);

    /**
     * 更新物料分类
     * @param category 物料分类信息
     * @return 操作结果
     */
    Result<MaterialCategory> updateCategory(MaterialCategory category);

    /**
     * 删除物料分类
     * @param id 物料分类ID
     * @return 操作结果
     */
    Result<?> deleteCategory(Long id);

    /**
     * 批量删除物料分类
     * @param ids 物料分类ID列表
     * @return 操作结果
     */
    Result<?> batchDeleteCategory(List<Long> ids);

    /**
     * 修改物料分类状态
     * @param id 物料分类ID
     * @param status 状态：0-禁用，1-启用
     * @return 操作结果
     */
    Result<?> changeStatus(Long id, Integer status);

    /**
     * 查询物料分类树形结构
     * @param parentId 父分类ID
     * @param status 状态：0-禁用，1-启用（null表示查询所有）
     * @return 物料分类树形结构列表
     */
    List<MaterialCategory> selectCategoryTree(Long parentId, Integer status);
}