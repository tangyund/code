package com.qidianit.mes.pojo;

import com.baomidou.mybatisplus.annotation.*;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
/**
 * 登录日志表实体类
 */
@Data
@TableName("sys_login_log")
public class SysLoginLog {
    /**
     * 日志ID
     */
    @TableId(type = IdType.AUTO)
    private Long id;

    /**
     * 用户ID
     */
    @TableField("user_id")
    private Long userId;

    /**
     * 用户名
     */
    @TableField("username")
    private String username;

    /**
     * 登录IP地址
     */
    @TableField("ip_address")
    private String ipAddress;

    /**
     * 登录地点
     */
    @TableField("login_location")
    private String loginLocation;

    /**
     * 浏览器
     */
    private String browser;

    /**
     * 操作系统
     */
    private String os;

    /**
     * 登录时间
     */
    @TableField(value = "login_time", fill = FieldFill.INSERT)
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private Date loginTime;

    /**
     * 登录状态：0-失败，1-成功
     */
    @TableField("login_status")
    private Integer loginStatus;

    /**
     * 登录信息
     */
    private String msg;

    @TableField("delete_flag")
    private Integer deleteFlag;
}
    