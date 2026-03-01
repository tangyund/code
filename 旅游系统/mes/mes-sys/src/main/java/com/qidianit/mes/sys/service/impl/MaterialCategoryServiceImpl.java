package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qidianit.mes.sys.mapper.MaterialCategoryMapper;
import com.qidianit.mes.sys.service.MaterialCategoryService;
import org.springframework.stereotype.Service;
import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 物料分类管理Service实现类
 */
@Service
public class MaterialCategoryServiceImpl extends ServiceImpl<MaterialCategoryMapper, MaterialCategory> implements MaterialCategoryService {

    @Override
    public Result<?> selectCategoryPage(int pageNum, int size, MaterialCategory category) {
        Page<MaterialCategory> page = new Page<>(pageNum, size);
        QueryWrapper<MaterialCategory> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(category != null && category.getCode() != null, "code", category.getCode());
        queryWrapper.like(category != null && category.getName() != null, "name", category.getName());
        queryWrapper.ne(category != null && category.getDeleteFlag() != null, "delete_flag", 1);// != null, "delete_", category.getStatus())
        Page<MaterialCategory> result = getBaseMapper().selectPage(page, queryWrapper);
        return Result.success(result);
    }

    @Override
    public Result<MaterialCategory> selectByCode(String code) {
        QueryWrapper<MaterialCategory> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(code != null, "code", code);
        MaterialCategory materialCategory = getBaseMapper().selectOne(queryWrapper);
        return Result.success(materialCategory);
    }

    @Override
    public Result<MaterialCategory> addCategory(MaterialCategory category) {
        getBaseMapper().insert(category);
        return Result.success(category);
    }

    @Override
    public Result<MaterialCategory> updateCategory(MaterialCategory category) {
        getBaseMapper().updateById(category);
        return Result.success(category);
    }

    @Override
    public Result<?> deleteCategory(Long id) {
        UpdateWrapper<MaterialCategory> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("id", id);
        updateWrapper.set("delete_flag", 1);
        return getBaseMapper().update(updateWrapper) > 0 ? Result.success() : Result.error("删除失败");
    }

    @Override
    public Result<?> batchDeleteCategory(List<Long> ids) {
        UpdateWrapper<MaterialCategory> updateWrapper = new UpdateWrapper<>();
        updateWrapper.in(ids != null && ids.size() > 0, "id", ids);
        updateWrapper.set("delete_flag", 1);
        return getBaseMapper().update(updateWrapper) > 0 ? Result.success() : Result.error("批量删除失败");
    }

    @Override
    public Result<?> changeStatus(Long id, Integer status) {
        MaterialCategory category = getBaseMapper().selectById(id);
        if (category != null) {
            category.setStatus(status);
            getBaseMapper().updateById(category);
        }
        return Result.success();
    }

    @Override
    public List<MaterialCategory> selectCategoryTree(Long parentId, Integer status) {
        // 实现查询树形结构逻辑
        QueryWrapper<MaterialCategory> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(parentId != null, "parent_id", parentId);
        queryWrapper.eq(status != null, "status", status);
        queryWrapper.orderByAsc("sort");
        List<MaterialCategory> materialCategories = getBaseMapper().selectList(queryWrapper);
        for (MaterialCategory materialCategory : materialCategories) {
            List<MaterialCategory> children = getBaseMapper().selectList(new QueryWrapper<MaterialCategory>().eq("parent_id", materialCategory.getId()));
            if (children != null && !children.isEmpty()){
                materialCategory.setChildren(children);
                materialCategory.setHasChildren(true);
            }else{
                materialCategory.setHasChildren(false);
            }
        }
        return materialCategories;
    }
}