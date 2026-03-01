package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qidianit.mes.sys.mapper.UnitMapper;
import com.qidianit.mes.sys.service.UnitService;
import org.springframework.stereotype.Service;
import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 计量单位管理Service实现类
 */
@Service
public class UnitServiceImpl extends ServiceImpl<UnitMapper, Unit> implements UnitService {

    @Override
    public Result<?> selectUnitPage(int pageNum, int size, Unit unit) {
        Page<Unit> page = new Page<>(pageNum, size);
        QueryWrapper<Unit> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(unit != null && unit.getCode() != null, "code", unit.getCode());
        queryWrapper.like(unit != null && unit.getName() != null, "name", unit.getName());
        Page<Unit> result = getBaseMapper().selectPage(page, queryWrapper);
        return Result.success(result);
    }

    @Override
    public Result<Unit> selectByCode(String code) {
        QueryWrapper<Unit> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(code != null, "code", code);
        Unit unit = getBaseMapper().selectOne(queryWrapper);
        return Result.success(unit);
    }

    @Override
    public Result<Unit> addUnit(Unit unit) {
        getBaseMapper().insert(unit);
        return Result.success(unit);
    }

    @Override
    public Result<Unit> updateUnit(Unit unit) {
        getBaseMapper().updateById(unit);
        return Result.success(unit);
    }

    @Override
    public Result<?> deleteUnit(Long id) {
        getBaseMapper().deleteById(id);
        return Result.success();
    }

    @Override
    public Result<?> batchDeleteUnit(List<Long> ids) {
        getBaseMapper().deleteBatchIds(ids);
        return Result.success();
    }

    @Override
    public Result<?> changeStatus(Long id, Integer status) {
        Unit unit = getBaseMapper().selectById(id);
        if (unit != null) {
            unit.setStatus(status);
            getBaseMapper().updateById(unit);
        }
        return Result.success();
    }

    @Override
    public List<Unit> selectUnitTree(Integer isMainUnit) {
        // 实现查询树形结构逻辑
        return null;
    }
}