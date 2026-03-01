package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * @author 戴着假发的程序员
 * @company 起点编程
 * @date 2025/9/3 19:49
 * @description
 */
public interface DictTypeService extends IService<SysDictType> {

    /**
     * 查询字典类型分页
     *
     * @param dictType 字典类型
     * @param pageNum  页码
     * @param size     每页数量
     * @return 字典类型分页
     */
    Result<Page<SysDictType>> selectDictTypePage(SysDictType dictType, int pageNum, int size);
    /**
     * 获取字典类型
     *
     * @param dictTypeId 字典类型ID
     * @return 字典类型
     */
    Result<SysDictType> getDictType(Long dictTypeId);

    /**
     * 添加字典类型
     *
     * @param dictType 字典类型
     * @return 字典类型
     */
    Result<SysDictType> addDictType(SysDictType dictType);
    /**
     * 修改字典类型
     *
     * @param dictType 字典类型
     * @return 字典类型
     */
    Result<SysDictType> updateDictType(SysDictType dictType);
    /**
     * 删除字典类型
     *
     * @param dictTypeId 字典类型ID
     * @return 字典类型
     */
    Result<SysDictType> deleteDictType(Long dictTypeId);
    /**
     * 批量删除字典类型
     *
     * @param dictTypeIds 字典类型ID列表
     * @return 字典类型
     */
    Result<SysDictType> batchDeleteDictType(List<Long> dictTypeIds);

}
