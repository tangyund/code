package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.qidianit.mes.sys.mapper.WorkstationMapper;
import com.qidianit.mes.sys.service.WorkstationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 工作站管理Service实现类
 */
@Service
public class WorkstationServiceImpl extends ServiceImpl<WorkstationMapper, Workstation> implements WorkstationService {

    @Autowired
    WorkstationMapper workstationMapper;
    @Override
    public Result<?> selectWorkstationPage(int pageNum, int size, Workstation workstation) {
        Page<Workstation> page = new Page<>(pageNum, size);
        QueryWrapper<Workstation> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(workstation != null && workstation.getCode() != null, "code", workstation.getCode());
        queryWrapper.like(workstation != null && workstation.getName() != null, "name", workstation.getName());
        Page<Workstation> result = getBaseMapper().selectPage(page, queryWrapper);
        return Result.success(result);
    }

    @Override
    public Result<Workstation> selectByCode(String code) {
        QueryWrapper<Workstation> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(code != null, "code", code);
        Workstation workstation = getBaseMapper().selectOne(queryWrapper);
        return Result.success(workstation);
    }

    @Override
    public Result<Workstation> addWorkstation(Workstation workstation) {
        getBaseMapper().insert(workstation);
        return Result.success(workstation);
    }

    @Override
    public Result<Workstation> updateWorkstation(Workstation workstation) {
        getBaseMapper().updateById(workstation);
        return Result.success(workstation);
    }

    @Override
    public Result<?> deleteWorkstation(Long id) {
        getBaseMapper().deleteById(id);
        return Result.success();
    }

    @Override
    public Result<?> batchDeleteWorkstation(List<Long> ids) {
        getBaseMapper().deleteBatchIds(ids);
        return Result.success();
    }

    @Override
    public Result<?> changeStatus(Long id, Integer status) {
        Workstation workstation = getBaseMapper().selectById(id);
        if (workstation != null) {
            workstation.setStatus(status);
            getBaseMapper().updateById(workstation);
        }
        return Result.success();
    }

    @Override
    public List<Workstation> selectByWorkshopId(Long workshopId) {
        QueryWrapper<Workstation> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(workshopId != null, "workshop_id", workshopId);
        return getBaseMapper().selectList(queryWrapper);
    }

    @Override
    public Result<PageInfo<Workstation>> selectProcessAndWorkshopByProcessId(int pageNum, int size, Workstation workstation) {
        PageHelper.startPage(pageNum,size);
        List<Workstation> workstations = workstationMapper.selectProcessAndWorkshopByProcessId(workstation);
        return Result.success(new PageInfo<>(workstations));

    }

    @Override
    public Result<PageInfo<Workstation>> selectAllStaion(int pageNum, int size, Workstation workstation) {
        PageHelper.startPage(pageNum,size);
        List<Workstation> workstations = workstationMapper.selectALLStation(workstation);
        return Result.success(new PageInfo<>(workstations));
    }


}