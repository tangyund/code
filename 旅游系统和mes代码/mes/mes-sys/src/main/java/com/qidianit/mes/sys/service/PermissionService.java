package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 权限管理Service接口
 */
public interface PermissionService extends IService<SysPermission> {

    /**
     * 分页查询权限
     * @param page 分页参数
     * @param permission 查询条件
     * @return 分页权限列表
     */
    PageResult<SysPermission> selectPermissionPage(Page<SysPermission> page, SysPermission permission);

    /**
     * 根据权限编码查询权限
     * @param permissionCode 权限编码
     * @return 权限信息
     */
    SysPermission selectByPermissionCode(String permissionCode);

    /**
     * 新增权限
     * @param permission 权限信息
     * @return 操作结果
     */
    Result<?> addPermission(SysPermission permission);

    /**
     * 更新权限
     * @param permission 权限信息
     * @return 操作结果
     */
    Result<?> updatePermission(SysPermission permission);

    /**
     * 删除权限
     * @param permissionId 权限ID
     * @return 操作结果
     */
    Result<?> deletePermission(Long permissionId);

    /**
     * 批量删除权限
     * @param permissionIds 权限ID列表
     * @return 操作结果
     */
    Result<?> batchDeletePermission(List<Long> permissionIds);

    /**
     * 修改权限状态
     * @param permissionId 权限ID
     * @param status 状态：0-禁用，1-启用
     * @return 操作结果
     */
    Result<?> changeStatus(Long permissionId, Integer status);

    /**
     * 查询权限树形结构
     * @param parentId 父权限ID
     * @param status 状态：0-禁用，1-启用（null表示查询所有）
     * @return 权限树形结构列表
     */
    List<SysPermission> selectPermissionTree(Long parentId, Integer status);

    /**
     * 根据角色ID查询权限列表
     * @param roleId 角色ID
     * @return 权限列表
     */
    List<SysPermission> selectPermissionsByRoleId(Long roleId);

    /**
     * 根据用户ID查询权限列表
     * @param userId 用户ID
     * @return 权限列表
     */
    List<SysPermission> selectPermissionsByUserId(Long userId);

    /**
     * 根据用户ID查询权限编码列表
     * @param userId 用户ID
     * @return 权限编码列表
     */
    List<String> selectPermissionCodesByUserId(Long userId);

    /**
     * 检查用户是否有指定权限
     * @param userId 用户ID
     * @param permissionCode 权限编码
     * @return 是否有权限
     */
    boolean hasPermission(Long userId, String permissionCode);
}
    