package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidianit.mes.sys.mapper.MaterialMapper;
import com.qidianit.mes.sys.service.MaterialService;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 物料管理Service实现类
 */
@Service
public class MaterialServiceImpl extends ServiceImpl<MaterialMapper, Material> implements MaterialService {

    @Autowired
    MaterialMapper materialMapper;
    @Override
    public Result<PageInfo<Material>> selectList(Material material, int pageNum, int size) {
        // 防止material为null导致MyBatis无法找到参数的问题
        if (material == null) {
            material = new Material();
        }
        PageHelper.startPage(pageNum,size);
        List<Material>materials =materialMapper.selectList(material);
        return Result.success(new PageInfo<>(materials));
    }
    @Override
    public Result<?> selectMaterialPage(int pageNum, int size, Material material) {
        Page<Material> page = new Page<>(pageNum, size);
        QueryWrapper<Material> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(material != null && material.getCode() != null, "code", material.getCode());
        queryWrapper.like(material != null && material.getName() != null, "name", material.getName());
        queryWrapper.ne(material != null && material.getDeleteFlag() != null, "delete_flag", 1);
        Page<Material> result = getBaseMapper().selectPage(page, queryWrapper);
        return Result.success(result);
    }

    @Override
    public Result<Material> selectByCode(String code) {
       return Result.success(materialMapper.selectByCode(code));
    }

    @Override
    public Result<Material> addMaterial(Material material) {
        getBaseMapper().insert(material);
        return Result.success(material);
    }

    @Override
    public Result<Material> updateMaterial(Material material) {
        getBaseMapper().updateById(material);
        return Result.success(material);
    }

    @Override
    public Result<?> deleteMaterial(Long id) {
        UpdateWrapper<Material> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("id", id);
        updateWrapper.set("delete_flag", 1);
        return getBaseMapper().update(updateWrapper) > 0 ? Result.success() : Result.error("删除失败");
    }

    @Override
    public Result<?> batchDeleteMaterial(List<Long> ids) {
        UpdateWrapper<Material> updateWrapper = new UpdateWrapper<>();
        updateWrapper.in(ids != null && ids.size() > 0, "id", ids);
        updateWrapper.set("delete_flag", 1);
        return getBaseMapper().update(updateWrapper) > 0 ? Result.success() : Result.error("批量删除失败");
    }

    @Override
    public Result<?> changeStatus(Long id, Integer status) {
        Material material = getBaseMapper().selectById(id);
        if (material != null) {
            material.setStatus(status);
            getBaseMapper().updateById(material);
        }
        return Result.success();
    }

    @Override
    public List<Material> selectByCategoryId(Long categoryId) {
        QueryWrapper<Material> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(categoryId != null, "category_id", categoryId);
        return getBaseMapper().selectList(queryWrapper);
    }

    @Override
    public List<Material> selectByHighValue(Integer isHighValue) {
        QueryWrapper<Material> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(isHighValue != null, "is_high_value", isHighValue);
        return getBaseMapper().selectList(queryWrapper);
    }


}