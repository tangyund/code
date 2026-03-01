package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.qidianit.mes.pojo.*;
/**
 * 登录日志Service接口
 */
public interface LoginLogService extends IService<SysLoginLog> {

    /**
     * 分页查询登录日志
     * @param page 分页参数
     * @param loginLog 查询条件
     * @return 分页登录日志列表
     */
    PageResult<SysLoginLog> selectLoginLogPage(Page<SysLoginLog> page, SysLoginLog loginLog);

    /**
     * 根据用户ID查询登录日志
     * @param page 分页参数
     * @param userId 用户ID
     * @return 分页登录日志列表
     */
    PageResult<SysLoginLog> selectLoginLogByUserId(Page<SysLoginLog> page, Long userId);

    /**
     * 记录登录日志
     * @param username 用户名
     * @param userId 用户ID
     * @param ipAddress IP地址
     * @param loginStatus 登录状态：0-失败，1-成功
     * @param msg 登录信息
     */
    void recordLoginLog(String username, Long userId, String ipAddress, Integer loginStatus, String msg);
}
    