package com.qidianit.mes.sys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;
import com.qidianit.mes.pojo.*;
/**
 * @author 戴着假发的程序员
 * @company 起点编程
 * @date 2025/9/3 19:48
 * @description
 */
public interface DictDataMapper extends BaseMapper<SysDictData> {
    /**
     * 分页查询字典数据
     * @param page
     * @param dictData
     * @return
     */
    Page<SysDictData> selectDictDataPage(Page<SysDictData> page, @Param("dictData") SysDictData dictData);
}
