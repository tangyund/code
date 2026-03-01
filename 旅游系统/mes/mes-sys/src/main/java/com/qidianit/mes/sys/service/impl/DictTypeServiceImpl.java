package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qidianit.mes.sys.mapper.DictTypeMapper;
import com.qidianit.mes.sys.service.DictTypeService;
import org.springframework.stereotype.Service;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * @author 戴着假发的程序员
 * @company 起点编程
 * @date 2025/9/3 19:50
 * @description
 */
@Service
public class DictTypeServiceImpl extends ServiceImpl<DictTypeMapper, SysDictType> implements DictTypeService {
    @Override
    public Result<Page<SysDictType>> selectDictTypePage(SysDictType dictType, int pageNum, int size) {
        Page<SysDictType> page = new Page<>(pageNum, size);
        dictType.setDeleteFlag(0);
        return Result.success(baseMapper.selectDictTypePage(page, dictType));
    }

    @Override
    public Result<SysDictType> getDictType(Long dictTypeId) {
        SysDictType dictType = baseMapper.selectById(dictTypeId);
        if (dictType != null) {
            return Result.success(dictType);
        }
        return Result.error("未查询到数据");
    }

    @Override
    public Result<SysDictType> addDictType(SysDictType dictType) {
        if (baseMapper.insert(dictType) > 0) {
            return Result.success(dictType);
        }
        return Result.error("添加失败");
    }

    @Override
    public Result<SysDictType> updateDictType(SysDictType dictType) {
        if (baseMapper.updateById(dictType) > 0) {
            return Result.success(dictType);
        }
        return Result.error("更新失败");
    }

    @Override
    public Result<SysDictType> deleteDictType(Long dictTypeId) {
        UpdateWrapper<SysDictType> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("id", dictTypeId);
        updateWrapper.set("delete_flag", 1);
        return update(updateWrapper) ? Result.success() : Result.error("删除字典类型失败");
    }

    @Override
    public Result<SysDictType> batchDeleteDictType(List<Long> dictTypeIds) {
        UpdateWrapper<SysDictType> updateWrapper = new UpdateWrapper<>();
        updateWrapper.in("id", dictTypeIds);
        updateWrapper.set("delete_flag", 1);
        return update(updateWrapper) ? Result.success() : Result.error("批量删除字典类型失败");
    }
}
