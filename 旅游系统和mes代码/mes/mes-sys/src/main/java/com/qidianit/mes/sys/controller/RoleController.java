package com.qidianit.mes.sys.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.qidianit.mes.sys.service.RoleService;
import com.qidianit.mes.sys.vo.RolePermissionVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * @author
 * @time 2025/9/2 10:29
 * @description
 */
@RestController
@RequestMapping("/role")
public class RoleController {
    @Autowired
    private RoleService roleService;
    @RequestMapping("/addRole")
    public Result<?> addRole(@RequestBody RolePermissionVo vo) {
        return roleService.addRole(vo, vo.getPermissionIds());
    }
    @RequestMapping("/updateRole")
    public Result<?> updateRole(SysRole role, List<Long> permissionIds) {
        return roleService.updateRole(role, permissionIds);
    }
    @RequestMapping("/deleteRole")
    public Result<?> deleteRole(Long roleId) {
        return roleService.deleteRole(roleId);
    }
    @RequestMapping("/batchDeleteRole")
    public Result<?> batchDeleteRole(List<Long> roleIds) {
        return roleService.batchDeleteRole(roleIds);
    }
    @RequestMapping("/changeStatus")
    public Result<?> changeStatus(Long roleId, Integer status) {
        return roleService.changeStatus(roleId, status);
    }
    @RequestMapping("/selectRolePage")
    public PageResult<?> selectRolePage(SysRole role, int pageNum, int  size) {
        Page<SysRole> page = new Page<>(pageNum, size);
        return roleService.selectRolePage(page, role);
    }
    @RequestMapping("/selectAllAvailableRoles")
    public List<SysRole> selectAllAvailableRoles() {
        return roleService.selectAllAvailableRoles();
    }
    @RequestMapping("/selectRolesByUserId")
    public List<SysRole> selectRolesByUserId(Long userId) {
        return roleService.selectRolesByUserId(userId);
    }
    @RequestMapping("/selectPermissionIdsByRoleId")
    public List<Long> selectPermissionIdsByRoleId(Long roleId) {
        return roleService.selectPermissionIdsByRoleId(roleId);
    }
}
