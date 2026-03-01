package com.qidianit.mes.sys.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 用户Mapper接口
 */
public interface UserMapper extends BaseMapper<SysUser> {

    /**
     * 分页查询用户
     */
    IPage<SysUser> selectUserPage(Page<SysUser> page, @Param("user") SysUser user);

    /**
     * 根据用户名查询用户
     */
    SysUser selectByUsername(@Param("username") String username);

    /**
     * 根据用户ID查询角色ID列表
     */
    List<Long> selectRoleIdsByUserId(@Param("userId") Long userId);

    /**
     * 根据用户ID查询角色编码列表
     */
    List<String> selectRoleCodesByUserId(@Param("userId") Long userId);

    /**
     * 批量为用户分配角色
     */
    int batchInsertUserRoles(@Param("userId") Long userId, @Param("roleIds") List<Long> roleIds, @Param("operatorId") Long operatorId);

    /**
     * 根据用户ID删除用户与角色的关联
     */
    int deleteUserRolesByUserId(@Param("userId") Long userId);


}
    