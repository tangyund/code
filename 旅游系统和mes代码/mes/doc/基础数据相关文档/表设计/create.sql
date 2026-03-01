-- 创建用户表
CREATE TABLE `sys_user` (
                            `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
                            `username` varchar(50) NOT NULL COMMENT '用户名',
                            `password` varchar(100) NOT NULL COMMENT '密码',
                            `full_name` varchar(100) DEFAULT NULL COMMENT '用户姓名',
                            `email` varchar(100) DEFAULT NULL COMMENT '电子邮箱',
                            `phone` varchar(20) DEFAULT NULL COMMENT '手机号码',
                            `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
                            `avatar` varchar(255) DEFAULT NULL COMMENT '头像URL',
                            `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
                            `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
                            `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `updated_by` bigint DEFAULT NULL COMMENT '更新人ID',
                            `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                            `delete_flag` int default '0' comment'删除标记',
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 创建角色表
CREATE TABLE `sys_role` (
                            `id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
                            `role_name` varchar(50) NOT NULL COMMENT '角色名称',
                            `role_code` varchar(50) NOT NULL COMMENT '角色编码',
                            `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
                            `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
                            `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `updated_by` bigint DEFAULT NULL COMMENT '更新人ID',
                            `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                            `delete_flag` int default '0' comment'删除标记',
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `uk_role_code` (`role_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 创建权限表
CREATE TABLE `sys_permission` (
                                  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '权限ID',
                                  `parent_id` bigint DEFAULT '0' COMMENT '父权限ID',
                                  `permission_name` varchar(100) NOT NULL COMMENT '权限名称',
                                  `permission_code` varchar(100) NOT NULL COMMENT '权限编码',
                                  `permission_type` tinyint NOT NULL COMMENT '权限类型：1-菜单，2-按钮，3-接口',
                                  `path` varchar(255) DEFAULT NULL COMMENT '资源路径',
                                  `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
                                  `icon` varchar(100) DEFAULT NULL COMMENT '图标',
                                  `sort` int DEFAULT 0 COMMENT '排序',
                                  `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
                                  `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
                                  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  `updated_by` bigint DEFAULT NULL COMMENT '更新人ID',
                                  `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                  `delete_flag` int default '0' comment'删除标记',
                                  PRIMARY KEY (`id`),
                                  UNIQUE KEY `uk_permission_code` (`permission_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 创建用户角色关联表
CREATE TABLE `sys_user_role` (
                                 `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
                                 `user_id` bigint NOT NULL COMMENT '用户ID',
                                 `role_id` bigint NOT NULL COMMENT '角色ID',
                                 `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
                                 `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 PRIMARY KEY (`id`),
                                 UNIQUE KEY `uk_user_role` (`user_id`,`role_id`),
                                 KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 创建角色权限关联表
CREATE TABLE `sys_role_permission` (
                                       `id` bigint NOT NULL AUTO_INCREMENT COMMENT '记录ID',
                                       `role_id` bigint NOT NULL COMMENT '角色ID',
                                       `permission_id` bigint NOT NULL COMMENT '权限ID',
                                       `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
                                       `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                       PRIMARY KEY (`id`),
                                       UNIQUE KEY `uk_role_permission` (`role_id`,`permission_id`),
                                       KEY `idx_permission_id` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色权限关联表';

-- 创建登录日志表
CREATE TABLE `sys_login_log` (
                                 `id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志ID',
                                 `user_id` bigint DEFAULT NULL COMMENT '用户ID',
                                 `username` varchar(50) NOT NULL COMMENT '用户名',
                                 `ip_address` varchar(50) DEFAULT NULL COMMENT '登录IP地址',
                                 `login_location` varchar(100) DEFAULT NULL COMMENT '登录地点',
                                 `browser` varchar(50) DEFAULT NULL COMMENT '浏览器',
                                 `os` varchar(50) DEFAULT NULL COMMENT '操作系统',
                                 `login_time` datetime NOT NULL COMMENT '登录时间',
                                 `login_status` tinyint NOT NULL COMMENT '登录状态：0-失败，1-成功',
                                 `msg` varchar(255) DEFAULT NULL COMMENT '登录信息',
                                 PRIMARY KEY (`id`),
                                 KEY `idx_user_id` (`user_id`),
                                 KEY `idx_login_time` (`login_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='登录日志表';

-- 创建字典类型表
CREATE TABLE `sys_dict_type` (
                                 `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典类型ID',
                                 `dict_name` varchar(100) NOT NULL COMMENT '字典名称',
                                 `dict_type` varchar(100) NOT NULL COMMENT '字典类型',
                                 `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
                                 `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
                                 `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 `updated_by` bigint DEFAULT NULL COMMENT '更新人ID',
                                 `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                 `delete_flag` int default '0' comment'删除标记',
                                 PRIMARY KEY (`id`),
                                 UNIQUE KEY `uk_dict_type` (`dict_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典类型表';

-- 创建字典数据表
CREATE TABLE `sys_dict_data` (
                                 `id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典数据ID',
                                 `dict_type` varchar(100) NOT NULL COMMENT '字典类型',
                                 `dict_label` varchar(100) NOT NULL COMMENT '字典标签',
                                 `dict_value` varchar(100) NOT NULL COMMENT '字典键值',
                                 `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
                                 `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
                                 `is_default` tinyint NOT NULL DEFAULT '0' COMMENT '是否默认（1是 0否）',
                                 `sort` int DEFAULT 0 COMMENT '排序',
                                 `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态：0-禁用，1-启用',
                                 `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
                                 `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 `updated_by` bigint DEFAULT NULL COMMENT '更新人ID',
                                 `updated_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                 `delete_flag` int default '0' comment'删除标记',
                                 PRIMARY KEY (`id`),
                                 KEY `idx_dict_type` (`dict_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='字典数据表';

