package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qidianit.mes.sys.mapper.PermissionMapper;
import com.qidianit.mes.sys.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.Date;
import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * 权限Service实现类
 */
@Service
public class PermissionServiceImpl extends ServiceImpl<PermissionMapper, SysPermission> implements PermissionService {

    @Autowired
    private PermissionMapper permissionMapper;

    @Override
    public PageResult<SysPermission> selectPermissionPage(Page<SysPermission> page, SysPermission permission) {
        permission.setDeleteFlag(0);
        IPage<SysPermission> iPage = permissionMapper.selectPermissionPage(page, permission);
        List<SysPermission> records = iPage.getRecords();
        for (SysPermission p : records){
            List<SysPermission> sysPermissions = permissionMapper.selectPermissionTree(p.getId(), 1);
            p.setHasChildren(sysPermissions != null && !sysPermissions.isEmpty());
        }
        return PageResult.success(
            iPage.getRecords(),
            iPage.getTotal(),
            iPage.getPages(),
            iPage.getCurrent(),
            iPage.getSize()
        );
    }

    @Override
    public SysPermission selectByPermissionCode(String permissionCode) {
        return permissionMapper.selectByPermissionCode(permissionCode);
    }

    @Override
    public List<SysPermission> selectPermissionTree(Long parentId, Integer status) {
        return permissionMapper.selectPermissionTree(parentId, status);
    }


    @Override
    public List<SysPermission> selectPermissionsByUserId(Long userId) {
        return permissionMapper.selectPermissionsByUserId(userId);
    }

    @Override
    public List<String> selectPermissionCodesByUserId(Long userId) {
        return permissionMapper.selectPermissionCodesByUserId(userId);
    }

    @Override
    public List<SysPermission> selectPermissionsByRoleId(Long roleId) {
        if (roleId == null) {
            return null;
        }
        return permissionMapper.selectPermissionsByRoleId(roleId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<SysPermission> addPermission(SysPermission permission) {
        return createPermission(permission);
    }

    @Transactional(rollbackFor = Exception.class)
    public Result<SysPermission> createPermission(SysPermission permission) {
        // 验证权限编码是否已存在
        if (!StringUtils.isEmpty(permission.getPermissionCode())) {
            SysPermission existingPermission = selectByPermissionCode(permission.getPermissionCode());
            if (existingPermission != null) {
                return Result.error("权限编码已存在");
            }
        }
        
        // 设置默认值
        if (permission.getParentId() == null) {
            permission.setParentId(0L); // 默认为顶级权限
        }
        if (permission.getSort() == null) {
            permission.setSort(0); // 默认排序
        }
        permission.setStatus(1); // 默认启用
        permission.setCreatedTime(new Date());
        
        // 保存权限
        save(permission);
        
        return Result.success("权限创建成功", permission);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> updatePermission(SysPermission permission) {
        // 验证权限是否存在
        SysPermission existingPermission = getById(permission.getId());
        if (existingPermission == null) {
            return Result.error("权限不存在");
        }
        
        // 验证权限编码是否已被其他权限使用
        if (!StringUtils.isEmpty(permission.getPermissionCode()) && 
            !permission.getPermissionCode().equals(existingPermission.getPermissionCode())) {
            SysPermission codePermission = selectByPermissionCode(permission.getPermissionCode());
            if (codePermission != null) {
                return Result.error("权限编码已存在");
            }
        }
        
        // 不能将自己设置为父权限
        if (permission.getParentId() != null && permission.getParentId().equals(permission.getId())) {
            return Result.error("不能将自己设置为父权限");
        }
        
        permission.setUpdatedTime(new Date());
        
        // 更新权限信息
        updateById(permission);
        
        return Result.success("权限更新成功");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> deletePermission(Long permissionId) {
        // 验证权限是否存在
        SysPermission permission = getById(permissionId);
        if (permission == null) {
            return Result.error("权限不存在");
        }
        
        // 检查是否有子权限
        List<SysPermission> children = permissionMapper.selectPermissionTree(permissionId, null);
        if (children != null && !children.isEmpty()) {
            return Result.error("该权限存在子权限，无法删除");
        }
        
        // 检查是否有关联的角色
        List<Long> roleIds = permissionMapper.selectRoleIdsByPermissionId(permissionId);
        if (roleIds != null && !roleIds.isEmpty()) {
            return Result.error("该权限已关联角色，无法删除");
        }
        
        // 删除权限
        UpdateWrapper<SysPermission> updateWrapper = new UpdateWrapper<>();
        updateWrapper.eq("id", permissionId);
        updateWrapper.set("delete_flag", 1);
        return getBaseMapper().update(updateWrapper) > 0 ? Result.success() : Result.error("删除失败");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> batchDeletePermission(List<Long> permissionIds) {
        if (permissionIds == null || permissionIds.isEmpty()) {
            return Result.error("请选择要删除的权限");
        }
        
        // 批量校验权限状态
        for (Long permissionId : permissionIds) {
            // 验证权限是否存在
            SysPermission permission = getById(permissionId);
            if (permission == null) {
                return Result.error("权限ID为" + permissionId + "的权限不存在");
            }
            
            // 检查是否有子权限
            List<SysPermission> children = permissionMapper.selectPermissionTree(permissionId, null);
            if (children != null && !children.isEmpty()) {
                return Result.error("权限ID为" + permissionId + "存在子权限，无法删除");
            }
            
            // 检查是否有关联的角色
            List<Long> roleIds = permissionMapper.selectRoleIdsByPermissionId(permissionId);
            if (roleIds != null && !roleIds.isEmpty()) {
                return Result.error("权限ID为" + permissionId + "已关联角色，无法删除");
            }
        }
        
        // 执行批量删除
        removeByIds(permissionIds);
        
        return Result.success("成功删除" + permissionIds.size() + "个权限");
    }

    @Override
    public Result<?> changeStatus(Long permissionId, Integer status) {
        if (status == null || (status != 0 && status != 1)) {
            return Result.error("状态值无效");
        }
        
        SysPermission permission = getById(permissionId);
        if (permission == null) {
            return Result.error("权限不存在");
        }
        
        permission.setStatus(status);
        permission.setUpdatedTime(new Date());
        
        updateById(permission);
        
        return Result.success(status == 1 ? "权限启用成功" : "权限禁用成功");
    }

    @Override
    public boolean hasPermission(Long userId, String permissionCode) {
        // 超级管理员拥有所有权限
        List<String> roleCodes = permissionMapper.selectRoleCodesByUserId(userId);
        if (roleCodes != null && roleCodes.contains("SUPER_ADMIN")) {
            return true;
        }
        
        // 检查用户是否拥有该权限
        List<String> permissionCodes = selectPermissionCodesByUserId(userId);
        return permissionCodes != null && permissionCodes.contains(permissionCode);
    }
}
    