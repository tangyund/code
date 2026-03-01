package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 角色管理Service接口
 */
public interface RoleService extends IService<SysRole> {

    /**
     * 分页查询角色
     * @param page 分页参数
     * @param role 查询条件
     * @return 分页角色列表
     */
    PageResult<SysRole> selectRolePage(Page<SysRole> page, SysRole role);

    /**
     * 根据角色编码查询角色
     * @param roleCode 角色编码
     * @return 角色信息
     */
    SysRole selectByRoleCode(String roleCode);

    /**
     * 新增角色
     * @param role 角色信息
     * @param permissionIds 权限ID列表
     * @return 操作结果
     */
    Result<?> addRole(SysRole role, List<Long> permissionIds);

    /**
     * 更新角色
     * @param role 角色信息
     * @param permissionIds 权限ID列表
     * @return 操作结果
     */
    Result<?> updateRole(SysRole role, List<Long> permissionIds);

    /**
     * 删除角色
     * @param roleId 角色ID
     * @return 操作结果
     */
    Result<?> deleteRole(Long roleId);

    /**
     * 批量删除角色
     * @param roleIds 角色ID列表
     * @return 操作结果
     */
    Result<?> batchDeleteRole(List<Long> roleIds);

    /**
     * 修改角色状态
     * @param roleId 角色ID
     * @param status 状态：0-禁用，1-启用
     * @return 操作结果
     */
    Result<?> changeStatus(Long roleId, Integer status);

    /**
     * 为角色分配权限
     * @param roleId 角色ID
     * @param permissionIds 权限ID列表
     * @return 操作结果
     */
    Result<?> assignPermissions(Long roleId, List<Long> permissionIds);

    /**
     * 根据角色ID查询权限ID列表
     * @param roleId 角色ID
     * @return 权限ID列表
     */
    List<Long> selectPermissionIdsByRoleId(Long roleId);

    /**
     * 根据角色ID查询用户ID列表
     * @param roleId 角色ID
     * @return 用户ID列表
     */
    List<Long> selectUserIdsByRoleId(Long roleId);

    /**
     * 查询所有可用角色
     * @return 角色列表
     */
    List<SysRole> selectAllAvailableRoles();

    List<SysRole> selectRolesByUserId(Long userId);
}
    