package com.qidianit.mes.sys.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.qidianit.mes.sys.mapper.RoleMapper;
import com.qidianit.mes.sys.mapper.UserMapper;
import com.qidianit.mes.sys.service.RoleService;
import com.qidianit.mes.sys.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;
import org.springframework.util.StringUtils;

import java.util.*;
import com.qidianit.mes.pojo.*;
/**
 * 用户Service实现类
 */
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, SysUser> implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private RoleService roleService;
    @Autowired
    private RoleMapper roleMapper;


    @Override
    public PageResult<SysUser> selectUserPage(Page<SysUser> page, SysUser user) {
        IPage<SysUser> iPage = userMapper.selectUserPage(page, user);
        iPage.getRecords().forEach(u -> {
            u.setRoles(roleMapper.selectRolesByUserId(u.getId()));
        });
        return PageResult.success(
            iPage.getRecords(),
            iPage.getTotal(),
            iPage.getPages(),
            iPage.getCurrent(),
            iPage.getSize()
        );
    }

    @Override
    public SysUser selectByUsername(String username) {
        return userMapper.selectByUsername(username);
    }

    @Override
    public Result<?> addUser(SysUser user, List<Long> roleIds) {
        if (user == null) {
            return Result.error("用户信息不能为空");
        }
        if (StringUtils.isEmpty(user.getUsername())) {
            return Result.error("用户名不能为空");
        }
        if (StringUtils.isEmpty(user.getPassword())) {
            return Result.error("密码不能为空");
        }
        int result = userMapper.insert(user);
        if(result == 1){
            userMapper.batchInsertUserRoles(user.getId(), roleIds,1L);
        }
        return Result.success("用户添加成功");
    }


    @Override
    public List<String> selectRoleCodesByUserId(Long userId) {
        return userMapper.selectRoleCodesByUserId(userId);
    }

    @Override
    public Result<?> login(String username, String password, String ipAddress) {
        SysUser user = selectByUsername(username);
        if (user != null) {
            if (user.getPassword().equals(DigestUtils.md5DigestAsHex(password.getBytes()))) {
                // 登录成功
                return Result.success("登录成功");
            } else {
                // 密码错误
                return Result.error("密码错误");
            }
        }
        return Result.error("用户不存在");
    }

    @Override
    public Result<?> logout(String token) {
        // 删除用户登录信息
        return null;
    }


    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> updateUser(SysUser user, List<Long> roleIds) {
        // 验证用户是否存在
        SysUser existingUser = getById(user.getId());
        if (existingUser == null) {
            return Result.error("用户不存在");
        }
        
        // 不允许修改用户名
        user.setUsername(null);
        // 不允许直接修改密码
        user.setPassword(null);
        
        user.setUpdatedTime(new Date());
        
        // 更新用户信息
        updateById(user);
        
        // 更新角色关联
        if (roleIds != null) {
            // 先删除原有角色关联
            userMapper.deleteUserRolesByUserId(user.getId());
            
            // 再添加新的角色关联
            if (!roleIds.isEmpty()) {
                userMapper.batchInsertUserRoles(user.getId(), roleIds,1L);
            }
        }
        
        return Result.success("用户更新成功");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result<?> deleteUser(Long userId) {
        // 验证用户是否存在
        SysUser user = getById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        // 删除用户角色关联
        userMapper.deleteUserRolesByUserId(userId);
        
        // 删除用户
        removeById(userId);
        
        return Result.success("用户删除成功");
    }


    @Override
    public Result<?> resetPassword(Long userId, String newPassword) {
        SysUser user = getById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        // 密码加密
        user.setPassword(DigestUtils.md5DigestAsHex(newPassword.getBytes()));
        user.setUpdatedTime(new Date());
        
        updateById(user);
        
        return Result.success("密码重置成功");
    }

    @Override
    public Result<?> changeStatus(Long userId, Integer status) {
        if (status == null || (status != 0 && status != 1)) {
            return Result.error("状态值无效");
        }
        
        SysUser user = getById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        user.setStatus(status);
        user.setUpdatedTime(new Date());
        
        updateById(user);
        
        return Result.success(status == 1 ? "用户启用成功" : "用户禁用成功");
    }

    @Override
    public List<Long> selectRoleIdsByUserId(Long userId) {
        return null;
    }
}
