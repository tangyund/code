package com.qidianit.mes.sys.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.qidianit.mes.sys.service.UserService;
import com.qidianit.mes.sys.vo.UserRoleVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import com.qidianit.mes.pojo.*;
/**
 * @author
 * @time 2025/9/2 10:22
 * @description
 */
@RestController
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;
    @RequestMapping("/addUser")
    public Result<?> addUser(@RequestBody UserRoleVo vo) {
        return userService.addUser(vo, vo.getRoleIds());
    }
    @RequestMapping("/updateUser")
    public Result<?> updateUser(SysUser user, List<Long> roleIds) {
        return userService.updateUser(user, roleIds);
    }
    @RequestMapping("/deleteUser")
    public Result<?> deleteUser(Long userId) {
        return userService.deleteUser(userId);
    }
    @RequestMapping("/resetPassword")
    public Result<?> resetPassword(Long userId, String newPassword) {
        return userService.resetPassword(userId, newPassword);
    }
    @RequestMapping("/changeStatus")
    public Result<?> changeStatus(Long userId, Integer status) {
        return userService.changeStatus(userId, status);
    }
    @RequestMapping("/selectUserPage")
    public PageResult<?> selectUserPage(SysUser user, int pageNum, int  size) {
        Page<SysUser> page = new Page<>(pageNum, size);
        return userService.selectUserPage(page, user);
    }
    @RequestMapping("/selectRoleCodesByUserId")
    public List<String> selectRoleCodesByUserId(Long userId) {
        return userService.selectRoleCodesByUserId(userId);
    }
    @RequestMapping("/selectRoleIdsByUserId")
    public List<Long> selectRoleIdsByUserId(Long userId) {
        return userService.selectRoleIdsByUserId(userId);
    }
    @RequestMapping("/login")
    public Result<?> login(String username, String password, String ipAddress) {
        return userService.login(username, password, ipAddress);
    }
    @RequestMapping("/logout")
    public Result<?> logout(String token) {
        return userService.logout(token);
    }

}
