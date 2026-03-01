package com.qidian.mespro.vo;

import com.qidianit.mes.pojo.SysUser;

import java.util.List;

/**
 * @ Description:
 * @ Author: ZhangLi
 * @ Date: 2025/9/2 - 19:56
 */
public class UserRoleVo extends SysUser {
    private List<Long> roleIds;

    public List<Long> getRoleIds() {
        return roleIds;
    }

    public void setRoleIds(List<Long> roleIds) {
        this.roleIds = roleIds;
    }
}
