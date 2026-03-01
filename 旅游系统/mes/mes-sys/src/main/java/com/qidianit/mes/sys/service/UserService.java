package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 用户管理Service接口
 */
public interface UserService extends IService<SysUser> {

    /**
     * 分页查询用户
     * @param page 分页参数
     * @param user 查询条件
     * @return 分页用户列表
     */
    PageResult<SysUser> selectUserPage(Page<SysUser> page, SysUser user);

    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 用户信息
     */
    SysUser selectByUsername(String username);

    /**
     * 新增用户
     * @param user 用户信息
     * @param roleIds 角色ID列表
     * @return 操作结果
     */
    Result<?> addUser(SysUser user, List<Long> roleIds);

    /**
     * 更新用户
     * @param user 用户信息
     * @param roleIds 角色ID列表
     * @return 操作结果
     */
    Result<?> updateUser(SysUser user, List<Long> roleIds);

    /**
     * 删除用户
     * @param userId 用户ID
     * @return 操作结果
     */
    Result<?> deleteUser(Long userId);



    /**
     * 重置用户密码
     * @param userId 用户ID
     * @param newPassword 新密码
     * @return 操作结果
     */
    Result<?> resetPassword(Long userId, String newPassword);

    /**
     * 修改用户状态
     * @param userId 用户ID
     * @param status 状态：0-禁用，1-启用
     * @return 操作结果
     */
    Result<?> changeStatus(Long userId, Integer status);

    /**
     * 根据用户ID查询角色ID列表
     * @param userId 用户ID
     * @return 角色ID列表
     */
    List<Long> selectRoleIdsByUserId(Long userId);

    /**
     * 根据用户ID查询角色编码列表
     * @param userId 用户ID
     * @return 角色编码列表
     */
    List<String> selectRoleCodesByUserId(Long userId);

    /**
     * 用户登录
     * @param username 用户名
     * @param password 密码
     * @param ipAddress IP地址
     * @return 登录结果，包含token和用户信息
     */
    Result<?> login(String username, String password, String ipAddress);

    /**
     * 用户登出
     * @param token 令牌
     * @return 登出结果
     */
    Result<?> logout(String token);
}
    