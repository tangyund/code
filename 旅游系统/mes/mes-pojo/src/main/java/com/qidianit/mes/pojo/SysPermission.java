package com.qidianit.mes.pojo;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.util.Date;
import java.util.List;

/**
 * 权限表实体类
 */
@Data
@TableName("sys_permission")
public class SysPermission {
    /**
     * 权限ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 父权限ID
     */
    @TableField("parent_id")
    private Long parentId;

    /**
     * 权限名称
     */
    @TableField("permission_name")
    private String permissionName;

    /**
     * 权限编码
     */
    @TableField(value = "permission_code")
    private String permissionCode;

    /**
     * 权限类型：1-菜单，2-按钮，3-接口
     */
    @TableField("permission_type")
    private Integer permissionType;

    /**
     * 资源路径
     */
    private String path;

    /**
     * 组件路径
     */
    private String component;

    /**
     * 图标
     */
    private String icon;

    /**
     * 排序
     */
    private Integer sort;

    /**
     * 状态：0-禁用，1-启用
     */
    @TableField("status")
    private Integer status;

    /**
     * 创建人ID
     */
    @TableField(value = "created_by", fill = FieldFill.INSERT)
    private Long createdBy;

    /**
     * 创建时间
     */
    @TableField(value = "created_time", fill = FieldFill.INSERT)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date createdTime;

    /**
     * 更新人ID
     */
    @TableField(value = "updated_by", fill = FieldFill.INSERT_UPDATE)
    private Long updatedBy;

    /**
     * 更新时间
     */
    @TableField(value = "updated_time", fill = FieldFill.INSERT_UPDATE)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date updatedTime;

    /**
     * 备注
     */
    private String remark;
    /**
     * 子权限
     */
    @TableField(exist = false)
    private List<SysPermission> children;

    @TableField(exist = false)
    private Boolean hasChildren;

    @TableField("delete_flag")
    private Integer deleteFlag;
}
    