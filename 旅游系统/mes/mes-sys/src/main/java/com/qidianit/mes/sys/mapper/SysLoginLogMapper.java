package com.qidianit.mes.sys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.qidianit.mes.pojo.*;
/**
 * 登录日志表Mapper接口
 */
public interface SysLoginLogMapper extends BaseMapper<SysLoginLog> {

    IPage<SysLoginLog> selectLoginLogPage(Page<SysLoginLog> page, SysLoginLog loginLog);

    IPage<SysLoginLog> selectLoginLogByUserId(Page<SysLoginLog> page, Long userId);
}
    