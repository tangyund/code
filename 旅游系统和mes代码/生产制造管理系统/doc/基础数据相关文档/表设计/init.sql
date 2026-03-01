-- 插入用户表数据
INSERT INTO `sys_user` (`username`, `password`, `full_name`, `email`, `phone`, `status`, `avatar`, `last_login_time`, `created_by`, `created_time`, `updated_by`, `updated_time`, `remark`) VALUES
                                                                                                                                                                                                ('admin', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '系统管理员', 'admin@example.com', '13800138000', 1, '/avatars/admin.jpg', '2023-11-15 09:30:00', NULL, '2023-01-10 00:00:00', NULL, '2023-11-10 15:20:30', '系统超级管理员'),
                                                                                                                                                                                                ('zhangsan', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '张三', 'zhangsan@example.com', '13800138001', 1, '/avatars/zhangsan.jpg', '2023-11-14 14:20:15', 1, '2023-02-15 10:30:00', 1, '2023-11-05 11:25:40', '人力资源部经理'),
                                                                                                                                                                                                ('lisi', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '李四', 'lisi@example.com', '13800138002', 1, '/avatars/lisi.jpg', '2023-11-15 10:15:30', 1, '2023-02-16 09:15:00', 1, '2023-11-08 09:45:10', '财务部经理'),
                                                                                                                                                                                                ('wangwu', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '王五', 'wangwu@example.com', '13800138003', 1, '/avatars/wangwu.jpg', '2023-11-13 16:40:20', 1, '2023-03-05 14:20:00', 2, '2023-11-12 16:30:25', '人力资源部专员'),
                                                                                                                                                                                                ('zhaoliu', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '赵六', 'zhaoliu@example.com', '13800138004', 1, '/avatars/zhaoliu.jpg', '2023-11-15 08:50:10', 1, '2023-03-10 11:05:00', 3, '2023-11-09 10:15:30', '财务部专员'),
                                                                                                                                                                                                ('sunqi', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '孙七', 'sunqi@example.com', '13800138005', 1, '/avatars/sunqi.jpg', '2023-11-14 13:25:45', 1, '2023-04-02 15:40:00', 1, '2023-11-11 14:20:15', '技术部经理'),
                                                                                                                                                                                                ('zhouba', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '周八', 'zhouba@example.com', '13800138006', 1, '/avatars/zhouba.jpg', '2023-11-12 10:30:20', 7, '2023-04-15 09:25:00', 7, '2023-11-07 11:30:40', '前端开发工程师'),
                                                                                                                                                                                                ('wujiu', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '吴九', 'wujiu@example.com', '13800138007', 1, '/avatars/wujiu.jpg', '2023-11-15 11:45:30', 7, '2023-05-08 13:10:00', 7, '2023-11-10 13:50:20', '后端开发工程师'),
                                                                                                                                                                                                ('zhengshi', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '郑十', 'zhengshi@example.com', '13800138008', 0, '/avatars/zhengshi.jpg', NULL, 7, '2023-05-12 16:30:00', 1, '2023-11-01 09:15:00', '测试工程师，已离职'),
                                                                                                                                                                                                ('chener', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '陈二', 'chener@example.com', '13800138009', 1, '/avatars/chener.jpg', '2023-11-13 15:20:10', 1, '2023-06-05 10:15:00', 1, '2023-11-06 14:30:15', '市场部经理');

-- 插入角色表数据
INSERT INTO `sys_role` (`role_name`, `role_code`, `status`, `created_by`, `created_time`, `updated_by`, `updated_time`, `remark`) VALUES
                                                                                                                                      ('超级管理员', 'SUPER_ADMIN', 1, NULL, '2023-01-10 00:00:00', NULL, '2023-10-20 14:30:00', '系统最高权限角色'),
                                                                                                                                      ('系统管理员', 'SYS_ADMIN', 1, 1, '2023-01-15 09:30:00', 1, '2023-10-15 11:20:00', '系统管理角色，拥有大部分管理权限'),
                                                                                                                                      ('人力资源经理', 'HR_MANAGER', 1, 1, '2023-02-10 10:15:00', 1, '2023-10-25 15:40:00', '人力资源部门经理角色'),
                                                                                                                                      ('人力资源专员', 'HR_STAFF', 1, 1, '2023-02-10 10:20:00', 2, '2023-10-30 16:10:00', '人力资源部门专员角色'),
                                                                                                                                      ('财务经理', 'FINANCE_MANAGER', 1, 1, '2023-02-10 10:25:00', 1, '2023-10-22 13:30:00', '财务部门经理角色'),
                                                                                                                                      ('财务专员', 'FINANCE_STAFF', 1, 1, '2023-02-10 10:30:00', 3, '2023-10-28 10:15:00', '财务部门专员角色'),
                                                                                                                                      ('技术经理', 'TECH_MANAGER', 1, 1, '2023-03-05 14:00:00', 1, '2023-10-18 09:45:00', '技术部门经理角色'),
                                                                                                                                      ('前端开发', 'FRONTEND_DEV', 1, 1, '2023-03-05 14:05:00', 7, '2023-10-26 11:30:00', '前端开发工程师角色'),
                                                                                                                                      ('后端开发', 'BACKEND_DEV', 1, 1, '2023-03-05 14:10:00', 7, '2023-10-24 14:20:00', '后端开发工程师角色'),
                                                                                                                                      ('测试工程师', 'TEST_ENGINEER', 1, 1, '2023-03-05 14:15:00', 7, '2023-10-21 15:50:00', '测试工程师角色'),
                                                                                                                                      ('市场经理', 'MARKET_MANAGER', 1, 1, '2023-04-10 11:00:00', 1, '2023-10-29 10:45:00', '市场部门经理角色');

-- 插入权限表数据
INSERT INTO `sys_permission` (`parent_id`, `permission_name`, `permission_code`, `permission_type`, `path`, `component`, `icon`, `sort`, `status`, `created_by`, `created_time`, `updated_by`, `updated_time`, `remark`) VALUES
                                                                                                                                                                                                                             (0, '系统管理', 'sys:manage', 1, '/system', 'system/index', 'system', 1, 1, 1, '2023-01-15 00:00:00', 1, '2023-10-10 14:30:00', '系统管理主菜单'),
                                                                                                                                                                                                                             (1, '用户管理', 'sys:user:manage', 1, '/system/user', 'system/user/index', 'user', 1, 1, 1, '2023-01-15 00:05:00', 1, '2023-10-12 10:15:00', '用户管理菜单'),
                                                                                                                                                                                                                             (2, '用户查询', 'sys:user:query', 2, NULL, NULL, NULL, 1, 1, 1, '2023-01-15 00:10:00', 1, '2023-10-15 09:30:00', '用户查询按钮'),
                                                                                                                                                                                                                             (2, '用户新增', 'sys:user:add', 2, NULL, NULL, NULL, 2, 1, 1, '2023-01-15 00:15:00', 1, '2023-10-16 11:20:00', '用户新增按钮'),
                                                                                                                                                                                                                             (2, '用户修改', 'sys:user:edit', 2, NULL, NULL, NULL, 3, 1, 1, '2023-01-15 00:20:00', 1, '2023-10-18 14:40:00', '用户修改按钮'),
                                                                                                                                                                                                                             (2, '用户删除', 'sys:user:delete', 2, NULL, NULL, NULL, 4, 1, 1, '2023-01-15 00:25:00', 1, '2023-10-20 15:10:00', '用户删除按钮'),
                                                                                                                                                                                                                             (2, '用户导入', 'sys:user:import', 2, NULL, NULL, NULL, 5, 1, 1, '2023-01-15 00:30:00', 1, '2023-10-22 10:30:00', '用户导入按钮'),
                                                                                                                                                                                                                             (2, '用户导出', 'sys:user:export', 2, NULL, NULL, NULL, 6, 1, 1, '2023-01-15 00:35:00', 1, '2023-10-25 13:20:00', '用户导出按钮'),
                                                                                                                                                                                                                             (1, '角色管理', 'sys:role:manage', 1, '/system/role', 'system/role/index', 'role', 2, 1, 1, '2023-01-15 00:40:00', 1, '2023-10-26 16:40:00', '角色管理菜单'),
                                                                                                                                                                                                                             (9, '角色查询', 'sys:role:query', 2, NULL, NULL, NULL, 1, 1, 1, '2023-01-15 00:45:00', 1, '2023-10-28 09:15:00', '角色查询按钮'),
                                                                                                                                                                                                                             (9, '角色新增', 'sys:role:add', 2, NULL, NULL, NULL, 2, 1, 1, '2023-01-15 00:50:00', 1, '2023-10-30 11:30:00', '角色新增按钮'),
                                                                                                                                                                                                                             (9, '角色修改', 'sys:role:edit', 2, NULL, NULL, NULL, 3, 1, 1, '2023-01-15 00:55:00', 1, '2023-11-01 14:20:00', '角色修改按钮'),
                                                                                                                                                                                                                             (9, '角色删除', 'sys:role:delete', 2, NULL, NULL, NULL, 4, 1, 1, '2023-01-15 01:00:00', 1, '2023-11-03 15:50:00', '角色删除按钮'),
                                                                                                                                                                                                                             (9, '角色授权', 'sys:role:auth', 2, NULL, NULL, NULL, 5, 1, 1, '2023-01-15 01:05:00', 1, '2023-11-05 10:40:00', '角色授权按钮'),
                                                                                                                                                                                                                             (1, '权限管理', 'sys:permission:manage', 1, '/system/permission', 'system/permission/index', 'permission', 3, 1, 1, '2023-01-15 01:10:00', 1, '2023-11-06 13:20:00', '权限管理菜单'),
                                                                                                                                                                                                                             (15, '权限查询', 'sys:permission:query', 2, NULL, NULL, NULL, 1, 1, 1, '2023-01-15 01:15:00', 1, '2023-11-08 09:30:00', '权限查询按钮'),
                                                                                                                                                                                                                             (15, '权限新增', 'sys:permission:add', 2, NULL, NULL, NULL, 2, 1, 1, '2023-01-15 01:20:00', 1, '2023-11-10 11:15:00', '权限新增按钮'),
                                                                                                                                                                                                                             (15, '权限修改', 'sys:permission:edit', 2, NULL, NULL, NULL, 3, 1, 1, '2023-01-15 01:25:00', 1, '2023-11-12 14:30:00', '权限修改按钮'),
                                                                                                                                                                                                                             (15, '权限删除', 'sys:permission:delete', 2, NULL, NULL, NULL, 4, 1, 1, '2023-01-15 01:30:00', 1, '2023-11-14 16:20:00', '权限删除按钮'),
                                                                                                                                                                                                                             (0, '人力资源', 'hr:manage', 1, '/hr', 'hr/index', 'hr', 2, 1, 1, '2023-02-10 09:00:00', 1, '2023-10-15 10:45:00', '人力资源主菜单'),
                                                                                                                                                                                                                             (20, '员工管理', 'hr:employee:manage', 1, '/hr/employee', 'hr/employee/index', 'employee', 1, 1, 1, '2023-02-10 09:05:00', 2, '2023-10-20 13:30:00', '员工管理菜单'),
                                                                                                                                                                                                                             (20, '招聘管理', 'hr:recruit:manage', 1, '/hr/recruit', 'hr/recruit/index', 'recruit', 2, 1, 1, '2023-02-10 09:10:00', 2, '2023-10-25 15:20:00', '招聘管理菜单'),
                                                                                                                                                                                                                             (20, '考勤管理', 'hr:attendance:manage', 1, '/hr/attendance', 'hr/attendance/index', 'attendance', 3, 1, 1, '2023-02-10 09:15:00', 2, '2023-10-30 10:15:00', '考勤管理菜单'),
                                                                                                                                                                                                                             (0, '财务管理', 'finance:manage', 1, '/finance', 'finance/index', 'finance', 3, 1, 1, '2023-02-15 14:00:00', 1, '2023-10-18 14:45:00', '财务管理主菜单'),
                                                                                                                                                                                                                             (24, '账目管理', 'finance:account:manage', 1, '/finance/account', 'finance/account/index', 'account', 1, 1, 1, '2023-02-15 14:05:00', 3, '2023-10-22 11:30:00', '账目管理菜单'),
                                                                                                                                                                                                                             (24, '报销管理', 'finance:reimburse:manage', 1, '/finance/reimburse', 'finance/reimburse/index', 'reimburse', 2, 1, 1, '2023-02-15 14:10:00', 3, '2023-10-26 16:20:00', '报销管理菜单'),
                                                                                                                                                                                                                             (24, '工资管理', 'finance:salary:manage', 1, '/finance/salary', 'finance/salary/index', 'salary', 3, 1, 1, '2023-02-15 14:15:00', 3, '2023-10-28 09:45:00', '工资管理菜单');

-- 插入用户角色关联表数据
INSERT INTO `sys_user_role` (`user_id`, `role_id`, `created_by`, `created_time`) VALUES
                                                                                     (1, 1, NULL, '2023-01-10 00:00:00'),
                                                                                     (1, 2, 1, '2023-01-15 10:00:00'),
                                                                                     (2, 3, 1, '2023-02-15 10:35:00'),
                                                                                     (3, 5, 1, '2023-02-16 09:20:00'),
                                                                                     (4, 4, 2, '2023-03-05 14:25:00'),
                                                                                     (5, 6, 3, '2023-03-10 11:10:00'),
                                                                                     (6, 7, 1, '2023-04-02 15:45:00'),
                                                                                     (7, 8, 7, '2023-04-15 09:30:00'),
                                                                                     (8, 9, 7, '2023-05-08 13:15:00'),
                                                                                     (9, 10, 7, '2023-05-12 16:35:00'),
                                                                                     (10, 11, 1, '2023-06-05 10:20:00'),
                                                                                     (4, 2, 1, '2023-06-10 11:30:00'),
                                                                                     (6, 2, 1, '2023-06-15 14:20:00');

-- 插入角色权限关联表数据
INSERT INTO `sys_role_permission` (`role_id`, `permission_id`, `created_by`, `created_time`) VALUES
                                                                                                 (1, 1, NULL, '2023-01-10 00:00:00'),
                                                                                                 (1, 2, NULL, '2023-01-10 00:05:00'),
                                                                                                 (1, 3, NULL, '2023-01-10 00:10:00'),
                                                                                                 (1, 4, NULL, '2023-01-10 00:15:00'),
                                                                                                 (1, 5, NULL, '2023-01-10 00:20:00'),
                                                                                                 (1, 6, NULL, '2023-01-10 00:25:00'),
                                                                                                 (1, 7, NULL, '2023-01-10 00:30:00'),
                                                                                                 (1, 8, NULL, '2023-01-10 00:35:00'),
                                                                                                 (1, 9, NULL, '2023-01-10 00:40:00'),
                                                                                                 (1, 10, NULL, '2023-01-10 00:45:00'),
                                                                                                 (1, 11, NULL, '2023-01-10 00:50:00'),
                                                                                                 (1, 12, NULL, '2023-01-10 00:55:00'),
                                                                                                 (1, 13, NULL, '2023-01-10 01:00:00'),
                                                                                                 (1, 14, NULL, '2023-01-10 01:05:00'),
                                                                                                 (1, 15, NULL, '2023-01-10 01:10:00'),
                                                                                                 (1, 16, NULL, '2023-01-10 01:15:00'),
                                                                                                 (1, 17, NULL, '2023-01-10 01:20:00'),
                                                                                                 (1, 18, NULL, '2023-01-10 01:25:00'),
                                                                                                 (1, 19, NULL, '2023-01-10 01:30:00'),
                                                                                                 (1, 20, NULL, '2023-01-10 01:35:00'),
                                                                                                 (1, 21, NULL, '2023-01-10 01:40:00'),
                                                                                                 (1, 22, NULL, '2023-01-10 01:45:00'),
                                                                                                 (1, 23, NULL, '2023-01-10 01:50:00'),
                                                                                                 (1, 24, NULL, '2023-01-10 01:55:00'),
                                                                                                 (1, 25, NULL, '2023-01-10 02:00:00'),
                                                                                                 (1, 26, NULL, '2023-01-10 02:05:00'),
                                                                                                 (1, 27, NULL, '2023-01-10 02:10:00'),
                                                                                                 (2, 1, 1, '2023-01-15 10:05:00'),
                                                                                                 (2, 2, 1, '2023-01-15 10:10:00'),
                                                                                                 (2, 3, 1, '2023-01-15 10:15:00'),
                                                                                                 (2, 4, 1, '2023-01-15 10:20:00'),
                                                                                                 (2, 5, 1, '2023-01-15 10:25:00'),
                                                                                                 (2, 6, 1, '2023-01-15 10:30:00'),
                                                                                                 (2, 7, 1, '2023-01-15 10:35:00'),
                                                                                                 (2, 8, 1, '2023-01-15 10:40:00'),
                                                                                                 (2, 9, 1, '2023-01-15 10:45:00'),
                                                                                                 (2, 10, 1, '2023-01-15 10:50:00'),
                                                                                                 (2, 11, 1, '2023-01-15 10:55:00'),
                                                                                                 (2, 12, 1, '2023-01-15 11:00:00'),
                                                                                                 (2, 13, 1, '2023-01-15 11:05:00'),
                                                                                                 (2, 14, 1, '2023-01-15 11:10:00'),
                                                                                                 (3, 20, 1, '2023-02-15 10:40:00'),
                                                                                                 (3, 21, 1, '2023-02-15 10:45:00'),
                                                                                                 (3, 22, 1, '2023-02-15 10:50:00'),
                                                                                                 (3, 23, 1, '2023-02-15 10:55:00'),
                                                                                                 (4, 20, 2, '2023-03-05 14:30:00'),
                                                                                                 (4, 21, 2, '2023-03-05 14:35:00'),
                                                                                                 (4, 22, 2, '2023-03-05 14:40:00'),
                                                                                                 (4, 23, 2, '2023-03-05 14:45:00'),
                                                                                                 (5, 24, 1, '2023-02-16 09:25:00'),
                                                                                                 (5, 25, 1, '2023-02-16 09:30:00'),
                                                                                                 (5, 26, 1, '2023-02-16 09:35:00'),
                                                                                                 (5, 27, 1, '2023-02-16 09:40:00');

-- 插入登录日志表数据
INSERT INTO `sys_login_log` (`user_id`, `username`, `ip_address`, `login_location`, `browser`, `os`, `login_time`, `login_status`, `msg`) VALUES
                                                                                                                                              (1, 'admin', '192.168.1.1', '北京市 联通', 'Chrome 118.0.5993.118', 'Windows 10', '2023-11-15 09:30:00', 1, '登录成功'),
                                                                                                                                              (2, 'zhangsan', '192.168.1.2', '上海市 电信', 'Firefox 119.0', 'Windows 11', '2023-11-14 14:20:15', 1, '登录成功'),
                                                                                                                                              (3, 'lisi', '192.168.1.3', '广州市 电信', 'Edge 118.0.2088.76', 'macOS Ventura', '2023-11-15 10:15:30', 1, '登录成功'),
                                                                                                                                              (4, 'wangwu', '192.168.1.4', '深圳市 联通', 'Chrome 118.0.5993.118', 'Windows 10', '2023-11-13 16:40:20', 1, '登录成功'),
                                                                                                                                              (5, 'zhaoliu', '192.168.1.5', '杭州市 电信', 'Safari 16.5', 'macOS Monterey', '2023-11-15 08:50:10', 1, '登录成功'),
                                                                                                                                              (6, 'sunqi', '192.168.1.6', '南京市 移动', 'Chrome 118.0.5993.118', 'Windows 11', '2023-11-14 13:25:45', 1, '登录成功'),
                                                                                                                                              (7, 'zhouba', '192.168.1.7', '成都市 电信', 'Firefox 119.0', 'Linux Ubuntu', '2023-11-12 10:30:20', 1, '登录成功'),
                                                                                                                                              (8, 'wujiu', '192.168.1.8', '武汉市 联通', 'Chrome 118.0.5993.118', 'macOS Ventura', '2023-11-15 11:45:30', 1, '登录成功'),
                                                                                                                                              (10, 'chener', '192.168.1.10', '重庆市 电信', 'Edge 118.0.2088.76', 'Windows 10', '2023-11-13 15:20:10', 1, '登录成功'),
                                                                                                                                              (2, 'zhangsan', '192.168.1.2', '上海市 电信', 'Firefox 119.0', 'Windows 11', '2023-11-14 08:10:25', 0, '密码错误'),
                                                                                                                                              (5, 'zhaoliu', '192.168.1.5', '杭州市 电信', 'Safari 16.5', 'macOS Monterey', '2023-11-15 08:45:30', 0, '验证码错误'),
                                                                                                                                              (7, 'zhouba', '192.168.1.7', '成都市 电信', 'Firefox 119.0', 'Linux Ubuntu', '2023-11-12 10:25:10', 1, '登录成功'),
                                                                                                                                              (1, 'admin', '113.118.25.67', '北京市 联通', 'Chrome 118.0.5993.118', 'Windows 10', '2023-11-14 18:20:30', 1, '登录成功'),
                                                                                                                                              (9, 'zhengshi', '192.168.1.9', '天津市 电信', 'Chrome 118.0.5993.118', 'Windows 10', '2023-11-10 09:15:00', 0, '用户已禁用'),
                                                                                                                                              (6, 'sunqi', '192.168.1.6', '南京市 移动', 'Chrome 118.0.5993.118', 'Windows 11', '2023-11-14 09:30:15', 1, '登录成功');


-- 插入字典类型模拟数据
INSERT INTO `sys_dict_type` (`dict_name`, `dict_type`, `status`, `remark`) VALUES
                                                                               ('用户性别', 'sys_user_sex', 1, '用户性别列表'),
                                                                               ('菜单状态', 'sys_show_hide', 1, '菜单状态列表'),
                                                                               ('系统开关', 'sys_normal_disable', 1, '系统开关列表'),
                                                                               ('任务状态', 'sys_job_status', 1, '任务状态列表'),
                                                                               ('任务分组', 'sys_job_group', 1, '任务分组列表'),
                                                                               ('系统是否', 'sys_yes_no', 1, '系统是否列表'),
                                                                               ('通知类型', 'sys_notice_type', 1, '通知类型列表'),
                                                                               ('通知状态', 'sys_notice_status', 1, '通知状态列表'),
                                                                               ('操作类型', 'sys_oper_type', 1, '操作类型列表'),
                                                                               ('系统状态', 'sys_common_status', 1, '系统状态列表');

-- 插入字典数据模拟数据
-- 用户性别
INSERT INTO `sys_dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `is_default`, `sort`, `status`, `remark`) VALUES
                                                                                                                                               ('sys_user_sex', '男', '0', '', '', 1, 1, 1, '性别男'),
                                                                                                                                               ('sys_user_sex', '女', '1', '', '', 0, 2, 1, '性别女'),
                                                                                                                                               ('sys_user_sex', '未知', '2', '', '', 0, 3, 1, '性别未知');

-- 菜单状态
INSERT INTO `sys_dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `is_default`, `sort`, `status`, `remark`) VALUES
                                                                                                                                               ('sys_show_hide', '显示', '0', '', '', 1, 1, 1, '显示菜单'),
                                                                                                                                               ('sys_show_hide', '隐藏', '1', '', '', 0, 2, 1, '隐藏菜单');

-- 系统开关
INSERT INTO `sys_dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `is_default`, `sort`, `status`, `remark`) VALUES
                                                                                                                                               ('sys_normal_disable', '正常', '0', '', '', 1, 1, 1, '正常状态'),
                                                                                                                                               ('sys_normal_disable', '停用', '1', '', '', 0, 2, 1, '停用状态');

-- 任务状态
INSERT INTO `sys_dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `is_default`, `sort`, `status`, `remark`) VALUES
                                                                                                                                               ('sys_job_status', '正常', '0', '', '', 1, 1, 1, '正常状态'),
                                                                                                                                               ('sys_job_status', '暂停', '1', '', '', 0, 2, 1, '停用状态');

-- 系统是否
INSERT INTO `sys_dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `is_default`, `sort`, `status`, `remark`) VALUES
                                                                                                                                               ('sys_yes_no', '是', 'Y', '', '', 1, 1, 1, '系统是否是'),
                                                                                                                                               ('sys_yes_no', '否', 'N', '', '', 0, 2, 1, '系统是否否');

-- 通知类型
INSERT INTO `sys_dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `is_default`, `sort`, `status`, `remark`) VALUES
                                                                                                                                               ('sys_notice_type', '通知', '1', '', 'primary', 1, 1, 1, '通知'),
                                                                                                                                               ('sys_notice_type', '公告', '2', '', 'success', 0, 2, 1, '公告');

-- 通知状态
INSERT INTO `sys_dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `is_default`, `sort`, `status`, `remark`) VALUES
                                                                                                                                               ('sys_notice_status', '正常', '0', '', '', 1, 1, 1, '正常状态'),
                                                                                                                                               ('sys_notice_status', '关闭', '1', '', '', 0, 2, 1, '关闭状态');

-- 操作类型
INSERT INTO `sys_dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `is_default`, `sort`, `status`, `remark`) VALUES
                                                                                                                                               ('sys_oper_type', '新增', '1', '', 'info', 1, 1, 1, '新增操作'),
                                                                                                                                               ('sys_oper_type', '修改', '2', '', 'warning', 0, 2, 1, '修改操作'),
                                                                                                                                               ('sys_oper_type', '删除', '3', '', 'danger', 0, 3, 1, '删除操作'),
                                                                                                                                               ('sys_oper_type', '查询', '4', '', 'primary', 0, 4, 1, '查询操作'),
                                                                                                                                               ('sys_oper_type', '导出', '5', '', 'success', 0, 5, 1, '导出操作');

-- 系统状态
INSERT INTO `sys_dict_data` (`dict_type`, `dict_label`, `dict_value`, `css_class`, `list_class`, `is_default`, `sort`, `status`, `remark`) VALUES
                                                                                                                                               ('sys_common_status', '成功', '0', '', '', 1, 1, 1, '正常状态'),
                                                                                                                                               ('sys_common_status', '失败', '1', '', '', 0, 2, 1, '停用状态');