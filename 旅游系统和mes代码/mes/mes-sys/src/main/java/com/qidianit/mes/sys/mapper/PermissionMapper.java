package com.qidianit.mes.sys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 权限Mapper接口
 */
public interface PermissionMapper extends BaseMapper<SysPermission> {

    /**
     * 分页查询权限
     */
    IPage<SysPermission> selectPermissionPage(Page<SysPermission> page, @Param("permission") SysPermission permission);

    /**
     * 根据权限编码查询权限
     */
    SysPermission selectByPermissionCode(@Param("permissionCode") String permissionCode);

    /**
     * 查询权限树形结构
     */
    List<SysPermission> selectPermissionTree(@Param("parentId") Long parentId, @Param("status") Integer status);

    /**
     * 根据权限ID查询角色ID列表
     */
    List<Long> selectRoleIdsByPermissionId(@Param("permissionId") Long permissionId);

    /**
     * 根据用户ID查询权限列表
     */
    List<SysPermission> selectPermissionsByUserId(@Param("userId") Long userId);

    /**
     * 根据用户ID查询权限编码列表
     */
    List<String> selectPermissionCodesByUserId(@Param("userId") Long userId);

    List<SysPermission> selectPermissionsByRoleId(Long roleId);

    List<String> selectRoleCodesByUserId(Long userId);
}
    