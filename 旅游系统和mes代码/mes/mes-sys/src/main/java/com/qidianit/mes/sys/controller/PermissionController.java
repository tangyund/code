package com.qidianit.mes.sys.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.qidianit.mes.sys.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * @author
 * @time 2025/9/2 10:26
 * @description
 */
@RestController
@RequestMapping("/permission")
public class PermissionController {
    @Autowired
    private PermissionService permissionService;

    @RequestMapping("/addPermission")
    public Result<?> addPermission(@RequestBody  SysPermission permission){
        return permissionService.addPermission(permission);
    }
    @RequestMapping("/updatePermission")
    public Result<?> updatePermission(SysPermission permission){
        return permissionService.updatePermission(permission);
    }
    @RequestMapping("/deletePermission")
    public Result<?> deletePermission(Long permissionId){
        return permissionService.deletePermission(permissionId);
    }
    @RequestMapping("/batchDeletePermission")
    public Result<?> batchDeletePermission(List<Long> permissionIds){
        return permissionService.batchDeletePermission(permissionIds);
    }
    @RequestMapping("/changeStatus")
    public Result<?> changeStatus(Long permissionId, Integer status){
        return permissionService.changeStatus(permissionId, status);
    }
    @RequestMapping("/selectPermissionPage")
    public PageResult<?> selectPermissionPage(SysPermission permission, int pageNum, int  size){
        Page<SysPermission> page = new Page<>(pageNum, size);
        return permissionService.selectPermissionPage(page, permission);
    }
    @RequestMapping("/selectPermissionTree")
    public List<SysPermission> selectPermissionTree(Long parentId, Integer status){
        return permissionService.selectPermissionTree(parentId, status);
    }
    @RequestMapping("/selectPermissionsByRoleId")
    public Result<?> selectPermissionsByRoleId(Long roleId){
        return Result.success(permissionService.selectPermissionsByRoleId(roleId));
    }
    @RequestMapping("/selectPermissionsByUserId")
    public List<SysPermission> selectPermissionsByUserId(Long userId){
        return permissionService.selectPermissionsByUserId(userId);
    }
    @RequestMapping("/selectPermissionCodesByUserId")
    public List<String> selectPermissionCodesByUserId(Long userId){
        return permissionService.selectPermissionCodesByUserId(userId);
    }
    @RequestMapping("/hasPermission")
    public boolean hasPermission(Long userId, String permissionCode){
        return permissionService.hasPermission(userId, permissionCode);
    }

    @RequestMapping("/get")
    public Result<?> get(Long permissionId){
        return Result.success(permissionService.getById(permissionId));
    }

}
