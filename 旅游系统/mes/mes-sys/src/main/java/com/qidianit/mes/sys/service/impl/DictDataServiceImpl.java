package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qidianit.mes.sys.mapper.DictDataMapper;
import com.qidianit.mes.sys.service.DictDataService;
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
public class DictDataServiceImpl extends ServiceImpl<DictDataMapper, SysDictData> implements DictDataService {
    @Override
    public Result<Page<SysDictData>> selectDictDataPage(SysDictData dictData, int pageNum, int size) {
        Page<SysDictData> page = new Page<>(pageNum, size);
        dictData.setDeleteFlag(0);
        return Result.success(baseMapper.selectDictDataPage(page, dictData));
    }

    @Override
    public Result<SysDictData> addDictData(SysDictData dictData) {
        if (save(dictData)) {
            return Result.success(dictData);
        }
        return Result.error("添加字典数据失败");
    }

    @Override
    public Result<SysDictData> deleteDictData(Long dictDataId) {
        UpdateWrapper<SysDictData> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("id", dictDataId);
        updateWrapper.set("delete_flag", 1);
        return update(updateWrapper) ? Result.success() : Result.error("删除字典数据失败");
    }

    @Override
    public Result<SysDictData> batchDeleteDictData(List<Long> dictDataIds) {
        UpdateWrapper<SysDictData> updateWrapper = new UpdateWrapper<>();
        updateWrapper.in(dictDataIds != null && dictDataIds.size() > 0, "id", dictDataIds);
        updateWrapper.set("delete_flag", 1);
        return update(updateWrapper) ? Result.success() : Result.error("批量删除字典数据失败");
    }

    @Override
    public Result<SysDictData> updateDictData(SysDictData dictData) {
        if (updateById(dictData)) {
            return Result.success(dictData);
        }
        return Result.error("修改字典数据失败");
    }
}
