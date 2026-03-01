package com.qidianit.mes.sys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 角色Mapper接口
 */
public interface RoleMapper extends BaseMapper<SysRole> {

    /**
     * 分页查询角色
     */
    IPage<SysRole> selectRolePage(Page<SysRole> page, @Param("role") SysRole role);

    /**
     * 根据角色编码查询角色
     */
    SysRole selectByRoleCode(@Param("roleCode") String roleCode);

    /**
     * 根据用户ID查询角色列表
     */
    List<SysRole> selectRolesByUserId(@Param("userId") Long userId);

    /**
     * 根据角色ID查询权限ID列表
     */
    List<Long> selectPermissionIdsByRoleId(@Param("roleId") Long roleId);

    /**
     * 根据角色ID查询用户ID列表
     */
    List<Long> selectUserIdsByRoleId(@Param("roleId") Long roleId);

    /**
     * 插入角色-权限关联
     */
    void insertRolePermissions(@Param("roleId") Long roleId, @Param("permissionIds") List<Long> permissionIds);

    /**
     * 删除角色-权限关联
     */
    void deleteRolePermissions(@Param("roleId") Long roleId);
}
    