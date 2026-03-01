package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qidianit.mes.sys.mapper.WorkshopMapper;
import com.qidianit.mes.sys.service.WorkshopService;
import org.springframework.stereotype.Service;
import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 车间管理Service实现类
 */
@Service
public class WorkshopServiceImpl extends ServiceImpl<WorkshopMapper, Workshop> implements WorkshopService {

    @Override
    public Result<?> selectWorkshopPage(int pageNum, int size, Workshop workshop) {
        Page<Workshop> page = new Page<>(pageNum, size);
        QueryWrapper<Workshop> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(workshop != null && workshop.getCode() != null, "code", workshop.getCode());
        queryWrapper.like(workshop != null && workshop.getName() != null, "name", workshop.getName());
        Page<Workshop> result = getBaseMapper().selectPage(page, queryWrapper);
        return Result.success(result);
    }

    @Override
    public Result<Workshop> selectByCode(String code) {
        QueryWrapper<Workshop> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(code != null, "code", code);
        Workshop workshop = getBaseMapper().selectOne(queryWrapper);
        return Result.success(workshop);
    }

    @Override
    public Result<Workshop> addWorkshop(Workshop workshop) {
        getBaseMapper().insert(workshop);
        return Result.success(workshop);
    }

    @Override
    public Result<Workshop> updateWorkshop(Workshop workshop) {
        getBaseMapper().updateById(workshop);
        return Result.success(workshop);
    }

    @Override
    public Result<?> deleteWorkshop(Long id) {
        getBaseMapper().deleteById(id);
        return Result.success();
    }

    @Override
    public Result<?> batchDeleteWorkshop(List<Long> ids) {
        getBaseMapper().deleteBatchIds(ids);
        return Result.success();
    }

    @Override
    public Result<?> changeStatus(Long id, Integer status) {
        Workshop workshop = getBaseMapper().selectById(id);
        if (workshop != null) {
            workshop.setStatus(status);
            getBaseMapper().updateById(workshop);
        }
        return Result.success();
    }
}