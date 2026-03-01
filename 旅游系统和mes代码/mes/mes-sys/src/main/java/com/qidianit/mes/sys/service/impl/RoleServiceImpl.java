package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qidianit.mes.sys.mapper.RoleMapper;
import com.qidianit.mes.sys.service.RoleService;
import com.qidianit.mes.sys.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 角色 Service 实现类
 */
@Service
public class RoleServiceImpl extends ServiceImpl<RoleMapper, SysRole> implements RoleService {
    @Autowired
    private RoleMapper roleMapper;
    @Autowired
    private PermissionService permissionService;

    // 1. 分页查询角色
    @Override
    public PageResult<SysRole> selectRolePage(Page<SysRole> page, SysRole role) {
        IPage<SysRole> iPage = roleMapper.selectRolePage(page, role);
        return PageResult.success(
                iPage.getRecords(),
                iPage.getTotal(),
                iPage.getPages(),
                iPage.getCurrent(),
                iPage.getSize()
        );
    }

    // 2. 根据角色编码查询角色
    @Override
    public SysRole selectByRoleCode(String roleCode) {
        return roleMapper.selectByRoleCode(roleCode);
    }

    // 3. 根据用户 ID 查询关联角色
    @Override
    public List<SysRole> selectRolesByUserId(Long userId) {
        if (userId == null) {
            return null;
        }
        return roleMapper.selectRolesByUserId(userId);
    }

    // 4. 根据角色 ID 查询关联权限 ID
    @Override
    public List<Long> selectPermissionIdsByRoleId(Long roleId) {
        if (roleId == null) {
            return null;
        }
        return roleMapper.selectPermissionIdsByRoleId(roleId);
    }

    // 5. 根据角色 ID 查询关联用户 ID
    @Override
    public List<Long> selectUserIdsByRoleId(Long roleId) {
        if (roleId == null) {
            return null;
        }
        return roleMapper.selectUserIdsByRoleId(roleId);
    }

    // 6. 查询所有可用角色（新增：实现 selectAllAvailableRoles 方法）
    @Override
    public List<SysRole> selectAllAvailableRoles() {
// 可用角色定义：状态为 “启用”（status=1），排除系统内置的特殊角色（可选）
        LambdaQueryWrapper<SysRole> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.eq(SysRole::getStatus, 1); // 只查询启用状态的角色
                //.orderByAsc(SysRole::getSort); // 按排序字段升序排列
        return list(queryWrapper);
    }

    // 7. 新增角色（含权限分配）
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<SysRole> addRole(SysRole role, List<Long> permissionIds) {
        return createRole(role, permissionIds);
    }

    // 8. 创建角色（核心逻辑）
    @Transactional(rollbackFor = Exception.class)
    public Result<SysRole> createRole(SysRole role, List<Long> permissionIds) {
// 验证角色编码唯一性
        if (!StringUtils.isEmpty(role.getRoleCode())) {
            SysRole existingRole = selectByRoleCode(role.getRoleCode());
            if (existingRole != null) {
                return Result.error("角色编码已存在");
            }
        }
// 设置默认值
//        if (role.getSort() == null) {
//            role.setSort(0); // 默认排序
//        }
        role.setStatus(1); // 默认启用
        role.setCreatedTime(new Date());
// 保存角色基本信息
        save(role);
// 分配权限（若有）
        if (permissionIds != null && !permissionIds.isEmpty()) {
            roleMapper.insertRolePermissions(role.getId(), permissionIds);
        }
        return Result.success("角色创建成功", role);
    }

    // 9. 更新角色（含权限更新）
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> updateRole(SysRole role, List<Long> permissionIds) {
// 验证角色是否存在
        SysRole existingRole = getById(role.getId());
        if (existingRole == null) {
            return Result.error("角色不存在");
        }
// 验证角色编码唯一性（若编码修改）
        if (!StringUtils.isEmpty(role.getRoleCode()) &&
                !role.getRoleCode().equals(existingRole.getRoleCode())) {
            SysRole codeRole = selectByRoleCode(role.getRoleCode());
            if (codeRole != null) {
                return Result.error("角色编码已存在");
            }
        }
// 设置更新时间
        role.setUpdatedTime(new Date());
// 更新角色基本信息
        updateById(role);
// 先删除原有权限关联
        roleMapper.deleteRolePermissions(role.getId());
// 重新分配新权限（若有）
        if (permissionIds != null && !permissionIds.isEmpty()) {
            roleMapper.insertRolePermissions(role.getId(), permissionIds);
        }
        return Result.success("角色更新成功");
    }

    // 10. 单个删除角色
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> deleteRole(Long roleId) {
// 验证角色是否存在
        SysRole role = getById(roleId);
        if (role == null) {
            return Result.error("角色不存在");
        }
// 系统内置角色（如超级管理员）不允许删除
        if ("SUPER_ADMIN".equals(role.getRoleCode())) {
            return Result.error("系统内置角色不允许删除");
        }
// 验证角色是否关联用户
        List<Long> userIds = selectUserIdsByRoleId(roleId);
        if (userIds != null && !userIds.isEmpty()) {
            return Result.error("该角色已关联用户，需先解除关联再删除");
        }
// 先删除角色与权限的关联
        roleMapper.deleteRolePermissions(roleId);
// 删除角色本身
        removeById(roleId);
        return Result.success("角色删除成功");
    }

    // 11. 批量删除角色
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> batchDeleteRole(List<Long> roleIds) {
        if (roleIds == null || roleIds.isEmpty()) {
            return Result.error("请选择要删除的角色");
        }
// 批量校验角色合法性
        for (Long roleId : roleIds) {
            SysRole role = getById(roleId);
// 验证角色是否存在
            if (role == null) {
                return Result.error("角色 ID：" + roleId + "不存在");
            }
// 系统内置角色不允许删除
            if ("SUPER_ADMIN".equals(role.getRoleCode())) {
                return Result.error("角色 ID：" + roleId + "为系统内置角色，不允许删除");
            }
// 验证角色是否关联用户
            List<Long> userIds = selectUserIdsByRoleId(roleId);
            if (userIds != null && !userIds.isEmpty()) {
                return Result.error("角色 ID：" + roleId + "已关联用户，需先解除关联再删除");
            }
// 删除当前角色与权限的关联
            roleMapper.deleteRolePermissions(roleId);
        }
// 批量删除角色
        removeByIds(roleIds);
        return Result.success("成功删除" + roleIds.size() + "个角色");
    }

    // 12. 角色分配权限
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> assignPermissions(Long roleId, List<Long> permissionIds) {
// 验证角色 ID 合法性
        if (roleId == null) {
            return Result.error("角色 ID 不能为空");
        }
        SysRole role = getById(roleId);
        if (role == null) {
            return Result.error("角色不存在");
        }
// 先删除原有权限关联
        roleMapper.deleteRolePermissions(roleId);
// 分配新权限（若有）
        if (permissionIds != null && !permissionIds.isEmpty()) {
            roleMapper.insertRolePermissions(roleId, permissionIds);
        }
        return Result.success("角色权限分配成功");
    }

    // 13. 变更角色状态（启用 / 禁用）
    @Override
    public Result<?> changeStatus(Long roleId, Integer status) {
// 验证状态值合法性
        if (status == null || (status != 0 && status != 1)) {
            return Result.error("状态值无效，仅支持 0（禁用）或 1（启用）");
        }
// 验证角色是否存在
        SysRole role = getById(roleId);
        if (role == null) {
            return Result.error("角色不存在");
        }
// 系统内置角色不允许禁用
        if (status == 0 && "SUPER_ADMIN".equals(role.getRoleCode())) {
            return Result.error("系统内置角色不允许禁用");
        }
// 更新角色状态
        role.setStatus(status);
        role.setUpdatedTime(new Date());
        updateById(role);
        return Result.success(status == 1 ? "角色启用成功" : "角色禁用成功");
    }

}