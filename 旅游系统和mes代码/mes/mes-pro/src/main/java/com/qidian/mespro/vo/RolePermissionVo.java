package com.qidian.mespro.vo;

import com.qidianit.mes.pojo.SysRole;

import java.util.List;

/**
 * @author
 * @time 2025/9/2 15:28
 * @description
 */
public class RolePermissionVo extends SysRole {
    private List<Long> permissionIds;

    public List<Long> getPermissionIds() {
        return permissionIds;
    }

    public void setPermissionIds(List<Long> permissionIds) {
        this.permissionIds = permissionIds;
    }
}
