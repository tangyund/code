package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.qidianit.mes.pojo.*;
import java.util.List;

/**
 * @author 戴着假发的程序员
 * @company 起点编程
 * @date 2025/9/3 19:50
 * @description
 */
public interface DictDataService extends IService<SysDictData> {
    /**
     * 查询字典数据分
     * @param dictData
     * @param pageNum
     * @param size
     * @return
     */
    Result<Page<SysDictData>> selectDictDataPage(SysDictData dictData, int pageNum, int size);
    /**
     * 添加字典数据
     * @param dictData
     * @return
     */
    Result<SysDictData> addDictData(SysDictData dictData);
    /**
     * 删除字典数据
     * @param dictDataId
     * @return
     */
    Result<SysDictData> deleteDictData(Long dictDataId);
    /**
     * 批量删除字典数据
     * @param dictDataIds
     * @return
     */
    Result<SysDictData> batchDeleteDictData(List<Long> dictDataIds);
    /**
     * 修改字典数据
     * @param dictData
     * @return
     */
    Result<SysDictData> updateDictData(SysDictData dictData);

}
