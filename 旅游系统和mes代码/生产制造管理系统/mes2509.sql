/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80011 (8.0.11)
 Source Host           : localhost:3306
 Source Schema         : mes2509

 Target Server Type    : MySQL
 Target Server Version : 80011 (8.0.11)
 File Encoding         : 65001

 Date: 29/12/2025 22:00:30
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for code_auto_info
-- ----------------------------
DROP TABLE IF EXISTS `code_auto_info`;
CREATE TABLE `code_auto_info`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '信息编号',
  `type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '类型，用来唯一标记，标记是某一个需求的编号自动生成信息',
  `pre` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编号前缀',
  `sequence` int(11) NULL DEFAULT NULL COMMENT '此时序列',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `type`(`type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of code_auto_info
-- ----------------------------
INSERT INTO `code_auto_info` VALUES (1, 'PROCESS_CODE', 'PROC', 3, '2025-09-18 17:16:26', 0);

-- ----------------------------
-- Table structure for customer
-- ----------------------------
DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer`  (
  `id` bigint(20) NOT NULL COMMENT '客户编号',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户编码',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '客户名称',
  `address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户地址',
  `contact_person` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户联系人',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户电话',
  `fax` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户传真',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '客户邮箱',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '客户描述',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '客户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of customer
-- ----------------------------
INSERT INTO `customer` VALUES (1, 'CUST001', '华为技术有限公司', '深圳市龙岗区华为总部', '张经理', '0755-12345678', '0755-87654321', 'zhang@huawei.com', '重要客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (2, 'CUST002', '小米科技有限公司', '北京市海淀区小米科技园', '李经理', '010-23456789', '010-98765432', 'li@xiaomi.com', '长期合作伙伴', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (3, 'CUST003', '阿里巴巴集团', '杭州市西湖区阿里巴巴西溪园区', '王经理', '0571-34567890', '0571-87654321', 'wang@alibaba.com', '电商平台客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (4, 'CUST004', '腾讯科技有限公司', '深圳市南山区腾讯大厦', '赵经理', '0755-45678901', '0755-76543210', 'zhao@tencent.com', '互联网客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (5, 'CUST005', '百度在线网络技术有限公司', '北京市海淀区百度大厦', '陈经理', '010-56789012', '010-65432109', 'chen@baidu.com', '搜索业务客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (6, 'CUST006', '京东集团', '北京市亦庄经济技术开发区京东总部', '刘经理', '010-67890123', '010-54321098', 'liu@jd.com', '电商客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (7, 'CUST007', '字节跳动有限公司', '北京市海淀区字节跳动大厦', '杨经理', '010-78901234', '010-43210987', 'yang@bytedance.com', '新媒体客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (8, 'CUST008', '美团', '北京市朝阳区美团总部', '黄经理', '010-89012345', '010-32109876', 'huang@meituan.com', '生活服务客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (9, 'CUST009', '拼多多', '上海市黄浦区拼多多大厦', '周经理', '021-90123456', '021-21098765', 'zhou@pinduoduo.com', '团购客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (10, 'CUST010', '顺丰速运', '深圳市福田区顺丰总部', '吴经理', '0755-01234567', '0755-10987654', 'wu@sf-express.com', '物流客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (11, 'CUST011', '中国中车集团', '北京市朝阳区中车大厦', '郑经理', '010-12345678', '010-87654321', 'zheng@crrc.com', '轨道交通客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `customer` VALUES (12, 'CUST012', '国家电网公司', '北京市西城区国家电网总部', '孙经理', '010-23456789', '010-76543210', 'sun@sgcc.com', '能源客户', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);

-- ----------------------------
-- Table structure for material
-- ----------------------------
DROP TABLE IF EXISTS `material`;
CREATE TABLE `material`  (
  `id` bigint(20) NOT NULL COMMENT '物料编号',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '物料编码',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '物料名称',
  `specification` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料规格',
  `unit_id` bigint(20) NULL DEFAULT NULL COMMENT '物料单位编号',
  `category_id` bigint(20) NULL DEFAULT NULL COMMENT '物料分类编号',
  `is_high_value` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否高价值物料(0:否,1:是)',
  `has_safety_stock` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否有安全库存(0:否,1:是)',
  `min_stock` decimal(10, 2) NULL DEFAULT NULL COMMENT '最小库存量',
  `max_stock` decimal(10, 2) NULL DEFAULT NULL COMMENT '最大库存量',
  `safety_stock` decimal(10, 2) NULL DEFAULT NULL COMMENT '安全库存量',
  `image_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '物料图片',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '物料描述',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '物料信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of material
-- ----------------------------
INSERT INTO `material` VALUES (1, 'MAT001', '芯片A', 'ARM-Cortex-A53 1.2GHz', 1, 4, 1, 1, 100.00, 1000.00, 300.00, '/images/mat001.jpg', '高性能处理芯片', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (2, 'MAT002', '芯片B', 'ARM-Cortex-M4 200MHz', 1, 4, 1, 1, 200.00, 2000.00, 500.00, '/images/mat002.jpg', '低功耗控制芯片', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (3, 'MAT003', '电阻1KΩ', '1KΩ±1% 1/4W', 3, 4, 0, 1, 1000.00, 10000.00, 2000.00, '/images/mat003.jpg', '贴片电阻', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (4, 'MAT004', '电容100μF', '100μF±20% 25V', 3, 4, 0, 1, 800.00, 8000.00, 1500.00, '/images/mat004.jpg', '电解电容', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (5, 'MAT005', '铝合金外壳', '100*80*50mm', 1, 5, 0, 1, 50.00, 500.00, 100.00, '/images/mat005.jpg', '产品外壳', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (6, 'MAT006', '塑料按键', '12*12*8mm 黑色', 3, 5, 0, 1, 1000.00, 10000.00, 2000.00, '/images/mat006.jpg', '控制面板按键', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (7, 'MAT007', '锂电池', '3.7V 2000mAh', 1, 6, 1, 1, 100.00, 1000.00, 300.00, '/images/mat007.jpg', '可充电锂电池', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (8, 'MAT008', 'PCB主板', '120*80mm 双面板', 1, 2, 1, 1, 50.00, 500.00, 100.00, '/images/mat008.jpg', '印刷电路板', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (9, 'MAT009', '连接器', 'USB Type-C 24针', 3, 4, 0, 1, 300.00, 3000.00, 600.00, '/images/mat009.jpg', '数据连接器', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (10, 'MAT010', '显示屏', '7寸 TFT 800*480', 1, 4, 1, 1, 50.00, 500.00, 100.00, '/images/mat010.jpg', '液晶显示屏', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (11, 'MAT011', '扬声器', '3W 8Ω 圆形', 3, 5, 0, 1, 200.00, 2000.00, 400.00, '/images/mat011.jpg', '音频输出设备', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material` VALUES (12, 'MAT012', '成品设备A', '完整功能版', 1, 3, 1, 1, 10.00, 100.00, 30.00, '/images/mat012.jpg', '完整成品设备', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);

-- ----------------------------
-- Table structure for material_bom
-- ----------------------------
DROP TABLE IF EXISTS `material_bom`;
CREATE TABLE `material_bom`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `parent_material_id` bigint(20) NOT NULL COMMENT '父物料ID (成品/半成品，关联material.id)',
  `child_material_id` bigint(20) NOT NULL COMMENT '子物料ID (组件/原料，关联material.id)',
  `quantity` decimal(10, 4) NOT NULL COMMENT '用量 (制造一个单位的父物料所需的子物料数量)',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注信息',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除标识 (0-未删除, 1-已删除)',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料清单BOM表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of material_bom
-- ----------------------------
INSERT INTO `material_bom` VALUES (1, 8, 1, 1.0000, '主处理器芯片A', '2025-09-23 14:52:10', '2025-09-23 14:52:10', 0);
INSERT INTO `material_bom` VALUES (2, 8, 2, 1.0000, '微控制器芯片B', '2025-09-23 14:52:10', '2025-09-23 14:52:10', 0);
INSERT INTO `material_bom` VALUES (3, 8, 3, 20.0000, '1KΩ贴片电阻', '2025-09-23 14:52:10', '2025-09-23 14:52:10', 0);
INSERT INTO `material_bom` VALUES (4, 8, 4, 15.0000, '100μF贴片电容', '2025-09-23 14:52:10', '2025-09-23 14:52:10', 0);
INSERT INTO `material_bom` VALUES (5, 8, 9, 2.0000, '板载USB Type-C连接器', '2025-09-23 14:52:10', '2025-09-23 14:52:10', 0);
INSERT INTO `material_bom` VALUES (6, 12, 8, 1.0000, 'PCBA主板组件', '2025-09-23 14:52:16', '2025-09-23 14:52:16', 0);
INSERT INTO `material_bom` VALUES (7, 12, 5, 1.0000, '设备外壳', '2025-09-23 14:52:16', '2025-09-23 14:52:16', 0);
INSERT INTO `material_bom` VALUES (8, 12, 10, 1.0000, '7寸显示屏模组', '2025-09-23 14:52:16', '2025-09-23 14:52:16', 0);
INSERT INTO `material_bom` VALUES (9, 12, 7, 1.0000, '内置锂电池', '2025-09-23 14:52:16', '2025-09-23 14:52:16', 0);
INSERT INTO `material_bom` VALUES (10, 12, 6, 4.0000, '功能按键', '2025-09-23 14:52:16', '2025-09-23 14:52:16', 0);
INSERT INTO `material_bom` VALUES (11, 12, 11, 1.0000, '扬声器', '2025-09-23 14:52:16', '2025-09-23 14:52:16', 0);

-- ----------------------------
-- Table structure for material_category
-- ----------------------------
DROP TABLE IF EXISTS `material_category`;
CREATE TABLE `material_category`  (
  `id` bigint(20) NOT NULL COMMENT '分类编号',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类编码',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '分类名称',
  `parent_id` bigint(20) NULL DEFAULT NULL COMMENT '上级分类编号',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '分类描述',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '物料分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of material_category
-- ----------------------------
INSERT INTO `material_category` VALUES (1, 'CAT001', '原材料', NULL, '生产所需原材料', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (2, 'CAT002', '半成品', NULL, '加工中的半成品', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (3, 'CAT003', '成品', NULL, '已完成的成品', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (4, 'CAT004', '电子元件', 1, '电子类原材料', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (5, 'CAT005', '机械零件', 1, '机械类原材料', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (6, 'CAT006', '化工原料', 1, '化工类原材料', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (7, 'CAT007', '包装材料', 1, '包装类材料', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (8, 'CAT008', '加工半成品', 2, '正在加工的半成品', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (9, 'CAT009', '组装半成品', 2, '正在组装的半成品', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (10, 'CAT010', '消费类产品', 3, '面向消费者的产品', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (11, 'CAT011', '工业产品', 3, '面向工业客户的产品', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `material_category` VALUES (12, 'CAT012', '配件', 1, '各种配件', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);

-- ----------------------------
-- Table structure for process
-- ----------------------------
DROP TABLE IF EXISTS `process`;
CREATE TABLE `process`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `process_code` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工序编码',
  `process_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工序名称',
  `process_description` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工序描述',
  `is_active` tinyint(4) NULL DEFAULT 0 COMMENT '是否启用（0-禁用，1-启用）',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `creatorId` bigint(20) NULL DEFAULT 1001 COMMENT '创建人ID',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `modifierId` bigint(20) NULL DEFAULT 1003 COMMENT '修改人ID',
  `is_deleted` tinyint(4) NULL DEFAULT 0 COMMENT '是否删除（0-未删，1-已删）',
  `remarks` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工序备注（如公差、强度要求等）',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `processCode`(`process_code` ASC) USING BTREE,
  UNIQUE INDEX `processName`(`process_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工序表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of process
-- ----------------------------
INSERT INTO `process` VALUES (1, 'PROC-001', '粗加工', '对毛坯进行初步切削', 0, '2025-09-17 16:09:25', 1001, '2025-09-18 15:14:52', 1003, 0, '进给量≤0.3mm/r');
INSERT INTO `process` VALUES (2, 'PROC-002', '热处理', '高温回火消除应力', 1, '2025-09-17 16:09:25', 1001, '2025-09-17 16:10:11', 1003, 0, '温度550±10℃，保温2h');
INSERT INTO `process` VALUES (3, 'PROC-003', '精加工', '精密磨削至尺寸要求', 1, '2025-09-17 16:09:25', 1001, '2025-09-17 16:10:13', 1003, 0, '公差±0.005mm');
INSERT INTO `process` VALUES (4, 'PROC-004', '表面处理', '镀锌防锈处理', 0, '2025-09-17 16:09:25', 1001, '2025-09-17 16:10:14', 1003, 0, '镀层厚度8-12μm（暂不启用）');
INSERT INTO `process` VALUES (5, 'PROC-005', '装配', '部件组合安装', 0, '2025-09-17 16:09:25', 1001, '2025-09-18 15:14:59', 1003, 0, '需使用专用工装');
INSERT INTO `process` VALUES (6, 'PROC-006', '质检', '最终性能检测', 1, '2025-09-17 16:09:25', 1001, '2025-09-18 15:11:55', 1003, 0, '按GB/T 1234-2020执行');

-- ----------------------------
-- Table structure for process_step
-- ----------------------------
DROP TABLE IF EXISTS `process_step`;
CREATE TABLE `process_step`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `processId` bigint(20) NOT NULL,
  `step_order` bigint(20) NOT NULL,
  `material_Url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `auxiliary_materials` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `step_description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `modifier_id` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `is_deleted` int(11) NULL DEFAULT 0,
  `auxiliary_equipment` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '辅助设备',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_processStep_process`(`processId` ASC) USING BTREE,
  CONSTRAINT `fk_processStep_process` FOREIGN KEY (`processId`) REFERENCES `process` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of process_step
-- ----------------------------
INSERT INTO `process_step` VALUES (1, 1, 1, '/materials/raw-1.pdf', '刀具A、冷却液', '粗加工第一道工序', '进给量0.2mm/r', '2025-09-17 16:32:09', '2025-09-17 18:28:34', '1001', 0, '12133');
INSERT INTO `process_step` VALUES (2, 1, 2, '/materials/raw-2.pdf', '刀具B、夹具', '粗加工第二道工序', '主轴转速1500r/min', '2025-09-17 16:32:09', '2025-09-17 17:14:44', '1001', 0, '31234');
INSERT INTO `process_step` VALUES (3, 1, 3, '/materials/raw-3.pdf', '量具A', '尺寸初检', '允许误差±0.1mm', '2025-09-17 16:32:09', '2025-09-17 17:14:45', '1002', 0, '124214');
INSERT INTO `process_step` VALUES (4, 1, 4, '/materials/raw-4.pdf', '砂纸、抛光膏', '表面粗磨', '粗糙度Ra3.2', '2025-09-17 16:32:09', '2025-09-17 17:14:46', '1003', 0, '23124');
INSERT INTO `process_step` VALUES (5, 1, 5, '/materials/raw-5.pdf', '清洁液', '工序清洁', '去除铁屑', '2025-09-17 16:32:09', '2025-09-17 18:32:54', '1003', 1, '244124');
INSERT INTO `process_step` VALUES (6, 2, 1, '/materials/heat-1.pdf', '热电偶', '升温至300℃', '保温30分钟', '2025-09-17 16:32:09', '2025-09-17 17:14:52', '1001', 0, '145314');
INSERT INTO `process_step` VALUES (7, 2, 2, '/materials/heat-2.pdf', '保温棉', '升温至500℃', '保温1小时', '2025-09-17 16:32:09', '2025-09-17 17:14:53', '1001', 0, '1234513');
INSERT INTO `process_step` VALUES (8, 2, 3, '/materials/heat-3.pdf', '温度计', '恒温监测', '每10分钟记录一次', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1002', 0, NULL);
INSERT INTO `process_step` VALUES (9, 2, 4, '/materials/heat-4.pdf', '冷却风扇', '降温至200℃', '自然冷却', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1002', 0, NULL);
INSERT INTO `process_step` VALUES (10, 2, 5, '/materials/heat-5.pdf', '硬度计', '硬度检测', '要求HRC45-50', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1003', 0, NULL);
INSERT INTO `process_step` VALUES (11, 2, 6, '/materials/heat-6.pdf', '记录单', '参数存档', '保存3年', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1003', 0, NULL);
INSERT INTO `process_step` VALUES (12, 3, 1, '/materials/fine-1.pdf', '精密刀具', '精铣平面', '平面度0.01mm', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1001', 0, NULL);
INSERT INTO `process_step` VALUES (13, 3, 2, '/materials/fine-2.pdf', '镗刀', '镗孔加工', '圆度0.005mm', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1001', 0, NULL);
INSERT INTO `process_step` VALUES (14, 3, 3, '/materials/fine-3.pdf', '砂轮', '外圆磨削', '粗糙度Ra0.8', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1002', 0, NULL);
INSERT INTO `process_step` VALUES (15, 3, 4, '/materials/fine-4.pdf', '千分尺', '尺寸精测', '每工件3次测量', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1002', 0, NULL);
INSERT INTO `process_step` VALUES (16, 3, 5, '/materials/fine-5.pdf', '去毛刺工具', '去毛刺', '边缘倒圆0.5mm', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1003', 0, NULL);
INSERT INTO `process_step` VALUES (17, 3, 6, '/materials/fine-6.pdf', '清洗剂', '精密清洗', '无尘环境', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1003', 0, NULL);
INSERT INTO `process_step` VALUES (18, 3, 7, '/materials/fine-7.pdf', '防锈油', '防锈处理', '均匀涂抹', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1004', 0, NULL);
INSERT INTO `process_step` VALUES (19, 4, 1, '/materials/surface-1.pdf', '除油剂', '表面除油', '浸泡10分钟', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1001', 0, NULL);
INSERT INTO `process_step` VALUES (20, 4, 2, '/materials/surface-2.pdf', '砂纸', '表面预处理', '去除氧化层', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1001', 0, NULL);
INSERT INTO `process_step` VALUES (21, 4, 3, '/materials/surface-3.pdf', '电镀液', '镀锌处理', '厚度8-12μm', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1002', 0, NULL);
INSERT INTO `process_step` VALUES (22, 4, 4, '/materials/surface-4.pdf', '钝化剂', '钝化处理', '提高耐腐蚀性', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1002', 0, NULL);
INSERT INTO `process_step` VALUES (23, 4, 5, '/materials/surface-5.pdf', '测厚仪', '镀层检测', '每批次抽测5件', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1003', 0, NULL);
INSERT INTO `process_step` VALUES (24, 4, 6, '/materials/surface-6.pdf', '包装材料', '成品包装', '防潮处理', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1003', 0, NULL);
INSERT INTO `process_step` VALUES (25, 5, 1, '/materials/assemble-1.pdf', '定位销', '部件定位', '确保同轴度', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1001', 0, NULL);
INSERT INTO `process_step` VALUES (26, 5, 2, '/materials/assemble-2.pdf', '螺栓、扳手', '紧固连接', '扭矩15N·m', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1001', 0, NULL);
INSERT INTO `process_step` VALUES (27, 5, 3, '/materials/assemble-3.pdf', '胶水', '密封处理', '固化时间24h', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1002', 0, NULL);
INSERT INTO `process_step` VALUES (28, 5, 4, '/materials/assemble-4.pdf', '润滑剂', '运动部件润滑', '食品级润滑油', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1002', 0, NULL);
INSERT INTO `process_step` VALUES (29, 5, 5, '/materials/assemble-5.pdf', '调试工具', '功能调试', '运行30分钟测试', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1003', 0, NULL);
INSERT INTO `process_step` VALUES (30, 5, 6, '/materials/assemble-6.pdf', '合格证', '贴标入库', '注明批次号', '2025-09-17 16:32:09', '2025-09-17 16:32:09', '1003', 0, NULL);

-- ----------------------------
-- Table structure for production_order
-- ----------------------------
DROP TABLE IF EXISTS `production_order`;
CREATE TABLE `production_order`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `production_order_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工单编号',
  `production_order_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工单名称',
  `production_order_type` int(11) NOT NULL COMMENT '工单类型（1自产，2外协，3外购）',
  `production_order_source` int(11) NOT NULL COMMENT '来源类型（1客户订单，2库存备货）',
  `order_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '订单编号',
  `material_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料编号',
  `production_order_quantity` decimal(15, 2) NOT NULL COMMENT '工单数量',
  `produced_quantity` decimal(15, 2) NULL DEFAULT 0.00 COMMENT '已生产数量',
  `customer_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '客户编号',
  `supplier_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '供应商编号',
  `request_date` date NOT NULL COMMENT '需求日期',
  `status` int(11) NOT NULL DEFAULT 1 COMMENT '状态（1:草稿, 2:已确定, 3:已审核, 4:已完成）',
  `qr_code_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '二维码URL',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父工单ID（0表示无父工单）',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `creator_id` bigint(20) NULL DEFAULT NULL COMMENT '创建人ID',
  `updator_id` bigint(20) NULL DEFAULT NULL COMMENT '更新人ID',
  `delete_flag` int(11) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生产订单表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of production_order
-- ----------------------------
INSERT INTO `production_order` VALUES (1, 'MO20250922001', '华为定制芯片A生产工单', 36, 1, 'SO20250922001', 'MAT001', 2000.00, 500.00, 'CUST001', 'SUPP002', '2025-10-10', 41, 'https://qrcode.example.com/MO20250922001', 0, '华为智能设备专用芯片', '2025-09-20 15:49:59', '2025-09-22 15:10:42', 1, 1, 0);
INSERT INTO `production_order` VALUES (2, 'MO20250922002', '小米PCB主板外协加工单', 37, 1, 'SO20250922002', 'MAT008', 10.00, 0.00, 'CUST002', 'SUPP003', '2025-10-15', 39, '', 0, '委托第三方加工1', '2025-09-20 15:49:59', '2025-09-23 14:26:23', 1, NULL, 1);
INSERT INTO `production_order` VALUES (3, 'MO20250922003', '锂电池库存采购单', 38, 2, NULL, 'MAT007', 10000.00, 3000.00, NULL, 'SUPP001', '2025-10-05', 41, 'https://qrcode.example.com/MO20250922003', 0, 'Q4季度备货', '2025-09-20 15:49:59', '2025-09-21 13:27:47', 2, 2, 0);
INSERT INTO `production_order` VALUES (4, 'MO20250922004', '阿里巴巴7寸显示屏生产单', 36, 1, 'SO20250922004', 'MAT010', 3000.00, 2800.00, 'CUST003', 'SUPP004', '2025-09-30', 41, '', 0, '已完成93%生产', '2025-09-20 15:49:59', '2025-09-21 13:55:51', 3, 3, 0);
INSERT INTO `production_order` VALUES (5, 'MO20250922005', 'USB Type-C连接器外协订单', 37, 2, NULL, 'MAT004', 8000.00, 0.00, NULL, 'SUPP005', '2025-10-20', 41, 'https://qrcode.example.com/MO20250922005', 0, '通用配件备货', '2025-09-20 15:49:59', '2025-09-25 17:19:49', 2, NULL, 0);
INSERT INTO `production_order` VALUES (6, 'MO20250922006', '腾讯成品设备A组装工单', 36, 1, 'SO20250922006', 'MAT012', 500.00, 200.00, 'CUST004', 'SUPP002', '2025-10-25', 41, '', 0, '含包装测试', '2025-09-20 15:49:59', '2025-09-21 13:55:56', 1, 2, 0);
INSERT INTO `production_order` VALUES (7, 'MO20250922007', '百度电阻采购单', 38, 1, 'SO20250922007', 'MAT004', 10.00, 50000.00, 'CUST005', 'SUPP002', '2025-09-25', 41, '', 0, '紧急采购已交付', '2025-09-20 15:49:59', '2025-09-23 23:32:38', 3, 3, 0);
INSERT INTO `production_order` VALUES (8, 'MO20250922008', '通用铝合金外壳生产工单', 36, 2, NULL, 'MAT008', 10.00, 800.00, NULL, 'SUPP004', '2025-11-06', 39, 'https://qrcode.example.com/MO20250922008', 0, '适配多种设备11', '2025-09-20 15:49:59', '2025-09-23 16:17:44', 2, 2, 0);
INSERT INTO `production_order` VALUES (9, 'MO20250922010', '111111', 36, 2, NULL, 'MAT001', 2.00, 0.00, NULL, NULL, '2025-09-04', 39, NULL, 0, '111', '2025-09-21 15:58:16', '2025-09-22 15:01:53', NULL, NULL, 1);
INSERT INTO `production_order` VALUES (10, 'MO20250922011', '1111', 36, 2, NULL, 'MAT003', 2.00, 0.00, NULL, NULL, '2025-09-22', 40, NULL, 0, NULL, '2025-09-22 18:31:54', '2025-09-23 16:17:56', NULL, NULL, 0);
INSERT INTO `production_order` VALUES (11, 'MO20250922012', '11', 36, 2, NULL, 'MAT001', 1.00, 0.00, NULL, NULL, '2025-08-28', 39, NULL, 0, NULL, '2025-09-22 18:32:32', '2025-09-23 13:52:16', NULL, NULL, 0);
INSERT INTO `production_order` VALUES (12, 'MO20250922013', '111', 36, 2, NULL, 'MAT005', 1.00, 0.00, NULL, NULL, '2025-09-18', 39, NULL, 0, NULL, '2025-09-22 18:33:46', '2025-09-23 13:52:19', NULL, NULL, 0);
INSERT INTO `production_order` VALUES (13, 'MO20250922015', '狒狒', 1, 2, NULL, 'MAT004', 1.00, 0.00, NULL, NULL, '2025-09-25', 39, NULL, 0, '111', '2025-09-23 11:04:37', '2025-09-23 16:17:52', NULL, NULL, 1);
INSERT INTO `production_order` VALUES (16, 'MO20250922015', '小米PCB主板外协加工单', 37, 1, 'SO20250922002', 'MAT008', 10.00, 0.00, 'CUST002', 'SUPP003', '2025-10-15', 39, NULL, 0, '委托第三方加工1', '2025-09-23 13:57:03', '2025-09-23 14:01:57', NULL, NULL, 1);

-- ----------------------------
-- Table structure for production_order_bom
-- ----------------------------
DROP TABLE IF EXISTS `production_order_bom`;
CREATE TABLE `production_order_bom`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `production_order_id` bigint(20) NOT NULL COMMENT '生产工单ID',
  `material_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料编号',
  `required_quantity` decimal(15, 2) NOT NULL COMMENT '需求数量',
  `issued_quantity` decimal(15, 2) NULL DEFAULT 0.00 COMMENT '已发料数量',
  `unit_usage` decimal(15, 6) NOT NULL COMMENT '单位用量',
  `sort_order` int(11) NULL DEFAULT 0 COMMENT '排序',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `creator_id` bigint(20) NULL DEFAULT NULL COMMENT '创建者ID',
  `updator_id` bigint(20) NULL DEFAULT NULL COMMENT '更新者ID',
  `delete_flag` tinyint(1) NOT NULL DEFAULT 0 COMMENT '删除标记（0正常，1删除）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '生产工单BOM组成表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of production_order_bom
-- ----------------------------

-- ----------------------------
-- Table structure for production_reporting
-- ----------------------------
DROP TABLE IF EXISTS `production_reporting`;
CREATE TABLE `production_reporting`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `report_code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `type_id` int(11) NOT NULL,
  `task_code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `station_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `process_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `production_order_code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `material_code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `material_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` bigint(200) NULL DEFAULT NULL,
  `report_num` bigint(20) NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `review_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `delete_flag` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of production_reporting
-- ----------------------------
INSERT INTO `production_reporting` VALUES (1, 'REP20250926001', 1, 'T001', '装配工位01', '粗加工', 'MO20250922001', 'MAT001', '芯片A', 39, 200, '2025-09-26 08:30:00', '张三', '李四1', '华为芯片A生产报工，质量合格', '2025-09-26 20:06:24', '张三', 1);
INSERT INTO `production_reporting` VALUES (2, 'REP20250926002', 1, 'T002', '装配工位02', '粗加工', 'MO20250922001', 'MAT001', '芯片A', 40, 150, '2025-09-26 09:15:00', '王五', NULL, '芯片A第二道工序报工', '2025-10-09 16:03:44', '王五', 0);
INSERT INTO `production_reporting` VALUES (3, 'REP20250926003', 2, 'T003', '机加工工位01', '热处理', 'MO20250922004', 'MAT010', '显示屏', 41, 800, '2025-09-26 10:20:00', '赵六', '钱七', '阿里巴巴显示屏包装完成', '2025-09-26 10:12:01', '赵六', 0);
INSERT INTO `production_reporting` VALUES (4, 'REP20250926004', 1, 'T004', '机加工工位02', '精加工', 'MO20250922006', 'MAT012', '成品设备A', 41, 50, '2025-09-26 11:05:00', '孙八', NULL, '腾讯设备A质检中', '2025-09-26 19:29:00', '孙八', 0);
INSERT INTO `production_reporting` VALUES (5, 'REP20250926005', 3, 'T001', '装配工位01', '粗加工', 'MO20250922003', 'MAT007', '锂电池', 40, 1000, '2025-09-26 13:30:00', '周九', '吴十', '锂电池库存生产报工', '2025-09-26 10:12:20', '周九', 0);
INSERT INTO `production_reporting` VALUES (6, 'REP20250926006', 1, 'T007', '机加工工位01', '热处理', 'MO20250922007', 'MAT004', '电容100μF', 39, 50000, '2025-09-26 14:20:00', '郑一', '王二', '百度电阻紧急采购完成', '2025-09-26 10:11:20', '郑一', 0);
INSERT INTO `production_reporting` VALUES (7, 'REP20250926007', 2, 'T012', '装配工位01', '粗加工', 'MO20250922005', 'MAT004', '电容100μF', 40, 3000, '2025-09-26 15:10:00', '陈三', NULL, 'USB连接器外协生产报工', '2025-09-26 10:11:21', '陈三', 0);
INSERT INTO `production_reporting` VALUES (8, 'REP20250926008', 1, 'T014', '装配工位01', '粗加工', 'MO20250922007', 'MAT004', '电容100μF', 39, 2, '2025-09-26 16:00:00', '李四', '张三', '测试任务报工完成', '2025-09-26 18:53:50', '李四', 1);
INSERT INTO `production_reporting` VALUES (9, 'REP20250926009', 1, 'T002', '装配工位02', '粗加工', 'MO20250922001', 'MAT001', '芯片A', 38, 100, '2025-09-26 16:45:00', '王五', '赵六', '芯片A补充生产报工', '2025-09-26 10:11:28', '王五', 0);
INSERT INTO `production_reporting` VALUES (10, 'REP20250926010', 3, 'T003', '机加工工位01', '热处理', 'MO20250922004', 'MAT010', '显示屏', 40, 500, '2025-09-26 17:30:00', '钱七', NULL, '显示屏夜班生产报工', '2025-09-26 10:12:00', '钱七', 0);
INSERT INTO `production_reporting` VALUES (11, 'REP20250926011', 2, 'T001', '装配工位01', '粗加工', 'MO20250922008', 'MAT008', 'PCB主板', 41, 200, '2025-09-26 08:00:00', '孙八', '周九', '通用外壳早班生产完成', '2025-09-26 10:12:19', '孙八', 0);
INSERT INTO `production_reporting` VALUES (12, 'REP20250926012', 1, 'T004', '机加工工位02', '精加工', 'MO20250922006', 'MAT012', '成品设备A', 41, 150, '2025-09-26 09:30:00', '吴十', '郑一', '腾讯设备A质检完成', '2025-09-26 10:11:50', '吴十', 0);
INSERT INTO `production_reporting` VALUES (13, 'REP20250926013', 3, 'T007', '机加工工位01', '热处理', 'MO20250922010', 'MAT003', '电阻1KΩ', 40, 1, '2025-09-26 10:45:00', '王二', NULL, '测试工单报工', '2025-09-26 10:11:41', '王二', 0);
INSERT INTO `production_reporting` VALUES (14, 'REP20250926014', 1, 'T012', '装配工位01', '粗加工', 'MO20250922005', 'MAT004', '电容100μF', 39, 2000, '2025-09-26 11:30:00', '陈三', '李四', 'USB连接器第一批完成', '2025-09-26 10:11:34', '陈三', 0);
INSERT INTO `production_reporting` VALUES (15, 'REP20250926015', 2, 'T001', '装配工位01', '粗加工', 'MO20250922001', 'MAT001', '芯片A', 40, 50, '2025-09-26 14:00:00', '张三', '王五', '芯片A特殊规格生产', '2025-09-26 10:11:19', '张三', 0);
INSERT INTO `production_reporting` VALUES (16, 'REP20250926020', 1, 'REO0123', '装配工位01', '', 'MO20250922001', 'MAT001', '芯片A', NULL, 11, '2025-10-28 00:00:00', '12312', '123', NULL, '2025-10-03 13:43:57', NULL, 0);

-- ----------------------------
-- Table structure for supplier
-- ----------------------------
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '供应商编号',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商编码',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '供应商名称',
  `address` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商地址',
  `contact_person` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商联系人',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商电话',
  `fax` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商传真',
  `email` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '供应商邮箱',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '供应商描述',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '供应商表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of supplier
-- ----------------------------
INSERT INTO `supplier` VALUES (1, 'SUPP001', '富士康科技集团', '深圳市宝安区富士康科技园', '张经理', '0755-11111111', '0755-22222222', 'zhang@foxconn.com', '电子产品代工供应商', 1, '2025-09-16 19:30:56', '2025-09-21 14:30:14', 0);
INSERT INTO `supplier` VALUES (2, 'SUPP002', '比亚迪股份有限公司', '深圳市坪山区比亚迪工业园', '李经理', '0755-33333333', '0755-44444444', 'li@byd.com', '新能源产品供应商', 1, '2025-09-16 19:30:56', '2025-09-21 14:30:11', 0);
INSERT INTO `supplier` VALUES (3, 'SUPP003', '宁德时代新能源科技股份有限公司', '福建省宁德市宁德时代总部', '王经理', '0593-55555555', '0593-66666666', 'wang@catl.com', '电池供应商', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `supplier` VALUES (4, 'SUPP004', '立讯精密工业股份有限公司', '广东省东莞市立讯产业园', '赵经理', '0769-77777777', '0769-88888888', 'zhao@luxshare-ict.com', '连接器供应商', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `supplier` VALUES (5, 'SUPP005', '京东方科技集团股份有限公司', '北京市朝阳区京东方总部', '陈经理', '010-99999999', '010-00000000', 'chen@boe.com', '显示屏供应商', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `supplier` VALUES (6, 'SUPP006', '海康威视数字技术股份有限公司', '杭州市滨江区海康威视总部', '刘经理', '0571-11111111', '0571-22222222', 'liu@hikvision.com', '安防设备供应商', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `supplier` VALUES (7, 'SUPP007', '大疆创新科技有限公司', '深圳市南山区大疆总部', '杨经理', '0755-33334444', '0755-55556666', 'yang@dji.com', '无人机供应商', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `supplier` VALUES (8, 'SUPP008', '格力电器股份有限公司', '珠海市香洲区格力总部', '黄经理', '0756-77778888', '0756-99990000', 'huang@gree.com', '空调设备供应商', 0, '2025-09-16 19:30:56', '2025-09-18 14:43:22', 0);
INSERT INTO `supplier` VALUES (9, 'SUPP009', '美的集团股份有限公司', '佛山市顺德区美的总部', '周经理', '0757-11112222', '0757-33334444', 'zhou@midea.com', '家电供应商', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `supplier` VALUES (10, 'SUPP010', '海尔集团公司', '青岛市崂山区海尔总部', '吴经理', '0532-55556666', '0532-77778888', 'wu@haier.com', '家电供应商', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `supplier` VALUES (11, 'SUPP011', '联想集团有限公司', '北京市海淀区联想总部', '郑经理', '010-11113333', '010-22224444', 'zheng@lenovo.com', '电脑设备供应商', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `supplier` VALUES (12, 'SUPP012', '中芯国际集成电路制造有限公司', '上海市浦东新区中芯国际总部', '孙经理', '021-33335555', '021-44446666', 'sun@smic.com', '芯片供应商', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `supplier` VALUES (13, 'SUP0015', '常州机电', '江苏常州', '费唐松', '12313543513', '12398473', '18923834', '1234', 1, '2025-09-16 22:54:57', '2025-09-21 14:30:17', 0);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典数据ID',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典类型',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典键值',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否默认（1是 0否）',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `created_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人ID',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` bigint(20) NULL DEFAULT NULL COMMENT '更新人ID',
  `updated_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 42 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 'sys_user_sex', '男', '0', '', '', 1, 1, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '性别男', 0);
INSERT INTO `sys_dict_data` VALUES (2, 'sys_user_sex', '女', '1', '', '', 0, 2, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '性别女', 0);
INSERT INTO `sys_dict_data` VALUES (3, 'sys_user_sex', '未知', '2', '', '', 0, 3, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '性别未知', 0);
INSERT INTO `sys_dict_data` VALUES (4, 'sys_show_hide', '显示', '0', '', '', 1, 1, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '显示菜单', 0);
INSERT INTO `sys_dict_data` VALUES (5, 'sys_show_hide', '隐藏', '1', '', '', 0, 2, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '隐藏菜单', 0);
INSERT INTO `sys_dict_data` VALUES (6, 'sys_normal_disable', '正常', '0', '', '', 1, 1, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '正常状态', 0);
INSERT INTO `sys_dict_data` VALUES (7, 'sys_normal_disable', '停用', '1', '', '', 0, 2, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '停用状态', 0);
INSERT INTO `sys_dict_data` VALUES (8, 'sys_job_status', '正常', '0', '', '', 1, 1, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '正常状态', 0);
INSERT INTO `sys_dict_data` VALUES (9, 'sys_job_status', '暂停', '1', '', '', 0, 2, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '停用状态', 0);
INSERT INTO `sys_dict_data` VALUES (10, 'sys_yes_no', '是', 'Y', '', '', 1, 1, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '系统是否是', 0);
INSERT INTO `sys_dict_data` VALUES (11, 'sys_yes_no', '否', 'N', '', '', 0, 2, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '系统是否否', 0);
INSERT INTO `sys_dict_data` VALUES (12, 'sys_notice_type', '通知', '1', '', 'primary', 1, 1, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '通知', 0);
INSERT INTO `sys_dict_data` VALUES (13, 'sys_notice_type', '公告', '2', '', 'success', 0, 2, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '公告', 0);
INSERT INTO `sys_dict_data` VALUES (14, 'sys_notice_status', '正常', '0', '', '', 1, 1, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '正常状态', 0);
INSERT INTO `sys_dict_data` VALUES (15, 'sys_notice_status', '关闭', '1', '', '', 0, 2, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '关闭状态', 0);
INSERT INTO `sys_dict_data` VALUES (16, 'sys_oper_type', '新增', '1', '', 'info', 1, 1, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '新增操作', 0);
INSERT INTO `sys_dict_data` VALUES (17, 'sys_oper_type', '修改', '2', '', 'warning', 0, 2, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '修改操作', 0);
INSERT INTO `sys_dict_data` VALUES (18, 'sys_oper_type', '删除', '3', '', 'danger', 0, 3, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '删除操作', 0);
INSERT INTO `sys_dict_data` VALUES (19, 'sys_oper_type', '查询', '4', '', 'primary', 0, 4, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '查询操作', 0);
INSERT INTO `sys_dict_data` VALUES (20, 'sys_oper_type', '导出', '5', '', 'success', 0, 5, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '导出操作', 0);
INSERT INTO `sys_dict_data` VALUES (21, 'sys_common_status', '成功', '0', '', '', 1, 1, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '正常状态', 0);
INSERT INTO `sys_dict_data` VALUES (22, 'sys_common_status', '失败', '1', '', '', 0, 2, 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '停用状态', 0);
INSERT INTO `sys_dict_data` VALUES (23, 'process_next_relation', 'S-to-S', '1', NULL, NULL, 1, 1, 1, 1, '2025-09-18 15:39:59', NULL, NULL, '当前工序开始生产，下一道工序才可以开始生产', 0);
INSERT INTO `sys_dict_data` VALUES (24, 'process_next_relation', 'F-to-S', '2', NULL, NULL, 0, 2, 1, 1, '2025-09-18 15:39:59', NULL, NULL, '当前工序完成生产，下一道工序才可以开始生产', 0);
INSERT INTO `sys_dict_data` VALUES (25, 'process_next_relation', 'F-to-F', '3', NULL, NULL, 0, 3, 1, 1, '2025-09-18 15:39:59', NULL, NULL, '当前工序完成生产，下一道工序才可以完成生产', 0);
INSERT INTO `sys_dict_data` VALUES (26, 'process_next_relation', 'S-to-F', '4', NULL, NULL, 0, 4, 1, 1, '2025-09-18 15:39:59', NULL, NULL, '当前工序开始生产，下一道工序才可以完成生产', 0);
INSERT INTO `sys_dict_data` VALUES (36, 'PRODUCTION_ORDER_TYPE', '自产', '1', '', 'primary', 1, 1, 1, NULL, '2025-09-20 15:49:32', NULL, NULL, '自主生产', 0);
INSERT INTO `sys_dict_data` VALUES (37, 'PRODUCTION_ORDER_TYPE', '外协', '2', '', 'warning', 0, 2, 1, NULL, '2025-09-20 15:49:32', NULL, NULL, '外协生产', 0);
INSERT INTO `sys_dict_data` VALUES (38, 'PRODUCTION_ORDER_TYPE', '外购', '3', '', 'info', 0, 3, 1, NULL, '2025-09-20 15:49:32', NULL, NULL, '外购采购', 0);
INSERT INTO `sys_dict_data` VALUES (39, 'PRODUCTION_ORDER_STATUS', '草稿', '1', '', 'info', 1, 1, 1, NULL, '2025-09-20 15:49:38', NULL, NULL, '草稿状态', 0);
INSERT INTO `sys_dict_data` VALUES (40, 'PRODUCTION_ORDER_STATUS', '已确认', '2', '', 'warning', 0, 2, 1, NULL, '2025-09-20 15:49:38', NULL, NULL, '已确认状态', 0);
INSERT INTO `sys_dict_data` VALUES (41, 'PRODUCTION_ORDER_STATUS', '已审核', '3', '', 'success', 0, 3, 1, NULL, '2025-09-20 15:49:38', NULL, NULL, '已审核状态', 0);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '字典类型ID',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '字典类型',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `created_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人ID',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` bigint(20) NULL DEFAULT NULL COMMENT '更新人ID',
  `updated_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '用户性别列表', 0);
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '菜单状态列表', 0);
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '系统开关列表', 0);
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '任务状态列表', 0);
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '任务分组列表', 0);
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '系统是否列表', 0);
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '通知类型列表', 0);
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '通知状态列表', 0);
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', 1, NULL, '2025-09-16 19:31:09', NULL, NULL, '操作类型列表', 0);
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', 1, NULL, '2025-09-16 19:31:09', NULL, '2025-09-20 14:22:10', '系统状态列表', 0);
INSERT INTO `sys_dict_type` VALUES (11, '工序关系类型', 'process_next_relation', 1, 1, '2025-09-18 15:39:59', NULL, NULL, '定义工序之间的执行关系', 0);
INSERT INTO `sys_dict_type` VALUES (15, '生产工单类型', 'PRODUCTION_ORDER_TYPE', 1, NULL, '2025-09-20 15:49:28', NULL, NULL, '生产工单类型列表', 0);
INSERT INTO `sys_dict_type` VALUES (16, '生产工单状态', 'PRODUCTION_ORDER_STATUS', 1, NULL, '2025-09-20 15:49:36', NULL, NULL, '生产工单状态列表', 0);

-- ----------------------------
-- Table structure for sys_login_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_login_log`;
CREATE TABLE `sys_login_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `user_id` bigint(20) NULL DEFAULT NULL COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录IP地址',
  `login_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '浏览器',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作系统',
  `login_time` datetime NOT NULL COMMENT '登录时间',
  `login_status` tinyint(4) NOT NULL COMMENT '登录状态：0-失败，1-成功',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '登录信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_login_time`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '登录日志表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_login_log
-- ----------------------------
INSERT INTO `sys_login_log` VALUES (1, 1, 'admin', '192.168.1.1', '北京市 联通', 'Chrome 118.0.5993.118', 'Windows 10', '2023-11-15 09:30:00', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (2, 2, 'zhangsan', '192.168.1.2', '上海市 电信', 'Firefox 119.0', 'Windows 11', '2023-11-14 14:20:15', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (3, 3, 'lisi', '192.168.1.3', '广州市 电信', 'Edge 118.0.2088.76', 'macOS Ventura', '2023-11-15 10:15:30', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (4, 4, 'wangwu', '192.168.1.4', '深圳市 联通', 'Chrome 118.0.5993.118', 'Windows 10', '2023-11-13 16:40:20', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (5, 5, 'zhaoliu', '192.168.1.5', '杭州市 电信', 'Safari 16.5', 'macOS Monterey', '2023-11-15 08:50:10', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (6, 6, 'sunqi', '192.168.1.6', '南京市 移动', 'Chrome 118.0.5993.118', 'Windows 11', '2023-11-14 13:25:45', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (7, 7, 'zhouba', '192.168.1.7', '成都市 电信', 'Firefox 119.0', 'Linux Ubuntu', '2023-11-12 10:30:20', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (8, 8, 'wujiu', '192.168.1.8', '武汉市 联通', 'Chrome 118.0.5993.118', 'macOS Ventura', '2023-11-15 11:45:30', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (9, 10, 'chener', '192.168.1.10', '重庆市 电信', 'Edge 118.0.2088.76', 'Windows 10', '2023-11-13 15:20:10', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (10, 2, 'zhangsan', '192.168.1.2', '上海市 电信', 'Firefox 119.0', 'Windows 11', '2023-11-14 08:10:25', 0, '密码错误');
INSERT INTO `sys_login_log` VALUES (11, 5, 'zhaoliu', '192.168.1.5', '杭州市 电信', 'Safari 16.5', 'macOS Monterey', '2023-11-15 08:45:30', 0, '验证码错误');
INSERT INTO `sys_login_log` VALUES (12, 7, 'zhouba', '192.168.1.7', '成都市 电信', 'Firefox 119.0', 'Linux Ubuntu', '2023-11-12 10:25:10', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (13, 1, 'admin', '113.118.25.67', '北京市 联通', 'Chrome 118.0.5993.118', 'Windows 10', '2023-11-14 18:20:30', 1, '登录成功');
INSERT INTO `sys_login_log` VALUES (14, 9, 'zhengshi', '192.168.1.9', '天津市 电信', 'Chrome 118.0.5993.118', 'Windows 10', '2023-11-10 09:15:00', 0, '用户已禁用');
INSERT INTO `sys_login_log` VALUES (15, 6, 'sunqi', '192.168.1.6', '南京市 移动', 'Chrome 118.0.5993.118', 'Windows 11', '2023-11-14 09:30:15', 1, '登录成功');

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `parent_id` bigint(20) NULL DEFAULT 0 COMMENT '父权限ID',
  `permission_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限名称',
  `permission_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限编码',
  `permission_type` tinyint(4) NOT NULL COMMENT '权限类型：1-菜单，2-按钮，3-接口',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '资源路径',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
  `sort` int(11) NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `created_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人ID',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` bigint(20) NULL DEFAULT NULL COMMENT '更新人ID',
  `updated_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_permission_code`(`permission_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES (1, 0, '系统管理', 'sys:manage', 1, '/system', 'system/index', 'system', 1, 1, 1, '2023-01-15 00:00:00', 1, '2023-10-10 14:30:00', '系统管理主菜单', 0);
INSERT INTO `sys_permission` VALUES (2, 1, '用户管理', 'sys:user:manage', 1, '/system/user', 'system/user/index', 'user', 1, 1, 1, '2023-01-15 00:05:00', 1, '2023-10-12 10:15:00', '用户管理菜单', 0);
INSERT INTO `sys_permission` VALUES (3, 2, '用户查询', 'sys:user:query', 2, NULL, NULL, NULL, 1, 1, 1, '2023-01-15 00:10:00', 1, '2023-10-15 09:30:00', '用户查询按钮', 0);
INSERT INTO `sys_permission` VALUES (4, 2, '用户新增', 'sys:user:add', 2, NULL, NULL, NULL, 2, 1, 1, '2023-01-15 00:15:00', 1, '2023-10-16 11:20:00', '用户新增按钮', 0);
INSERT INTO `sys_permission` VALUES (5, 2, '用户修改', 'sys:user:edit', 2, NULL, NULL, NULL, 3, 1, 1, '2023-01-15 00:20:00', 1, '2023-10-18 14:40:00', '用户修改按钮', 0);
INSERT INTO `sys_permission` VALUES (6, 2, '用户删除', 'sys:user:delete', 2, NULL, NULL, NULL, 4, 1, 1, '2023-01-15 00:25:00', 1, '2023-10-20 15:10:00', '用户删除按钮', 0);
INSERT INTO `sys_permission` VALUES (7, 2, '用户导入', 'sys:user:import', 2, NULL, NULL, NULL, 5, 1, 1, '2023-01-15 00:30:00', 1, '2023-10-22 10:30:00', '用户导入按钮', 0);
INSERT INTO `sys_permission` VALUES (8, 2, '用户导出', 'sys:user:export', 2, NULL, NULL, NULL, 6, 1, 1, '2023-01-15 00:35:00', 1, '2023-10-25 13:20:00', '用户导出按钮', 0);
INSERT INTO `sys_permission` VALUES (9, 1, '角色管理', 'sys:role:manage', 1, '/system/role', 'system/role/index', 'role', 2, 1, 1, '2023-01-15 00:40:00', 1, '2023-10-26 16:40:00', '角色管理菜单', 0);
INSERT INTO `sys_permission` VALUES (10, 9, '角色查询', 'sys:role:query', 2, NULL, NULL, NULL, 1, 1, 1, '2023-01-15 00:45:00', 1, '2023-10-28 09:15:00', '角色查询按钮', 0);
INSERT INTO `sys_permission` VALUES (11, 9, '角色新增', 'sys:role:add', 2, NULL, NULL, NULL, 2, 1, 1, '2023-01-15 00:50:00', 1, '2023-10-30 11:30:00', '角色新增按钮', 0);
INSERT INTO `sys_permission` VALUES (12, 9, '角色修改', 'sys:role:edit', 2, NULL, NULL, NULL, 3, 1, 1, '2023-01-15 00:55:00', 1, '2023-11-01 14:20:00', '角色修改按钮', 0);
INSERT INTO `sys_permission` VALUES (13, 9, '角色删除', 'sys:role:delete', 2, NULL, NULL, NULL, 4, 1, 1, '2023-01-15 01:00:00', 1, '2023-11-03 15:50:00', '角色删除按钮', 0);
INSERT INTO `sys_permission` VALUES (14, 9, '角色授权', 'sys:role:auth', 2, NULL, NULL, NULL, 5, 1, 1, '2023-01-15 01:05:00', 1, '2023-11-05 10:40:00', '角色授权按钮', 0);
INSERT INTO `sys_permission` VALUES (15, 1, '权限管理', 'sys:permission:manage', 1, '/system/permission', 'system/permission/index', 'permission', 3, 1, 1, '2023-01-15 01:10:00', 1, '2023-11-06 13:20:00', '权限管理菜单', 0);
INSERT INTO `sys_permission` VALUES (16, 15, '权限查询', 'sys:permission:query', 2, NULL, NULL, NULL, 1, 1, 1, '2023-01-15 01:15:00', 1, '2023-11-08 09:30:00', '权限查询按钮', 0);
INSERT INTO `sys_permission` VALUES (17, 15, '权限新增', 'sys:permission:add', 2, NULL, NULL, NULL, 2, 1, 1, '2023-01-15 01:20:00', 1, '2023-11-10 11:15:00', '权限新增按钮', 0);
INSERT INTO `sys_permission` VALUES (18, 15, '权限修改', 'sys:permission:edit', 2, NULL, NULL, NULL, 3, 1, 1, '2023-01-15 01:25:00', 1, '2023-11-12 14:30:00', '权限修改按钮', 0);
INSERT INTO `sys_permission` VALUES (19, 15, '权限删除', 'sys:permission:delete', 2, NULL, NULL, NULL, 4, 1, 1, '2023-01-15 01:30:00', 1, '2023-11-14 16:20:00', '权限删除按钮', 0);
INSERT INTO `sys_permission` VALUES (20, 0, '人力资源', 'hr:manage', 1, '/hr', 'hr/index', 'hr', 2, 1, 1, '2023-02-10 09:00:00', 1, '2023-10-15 10:45:00', '人力资源主菜单', 0);
INSERT INTO `sys_permission` VALUES (21, 20, '员工管理', 'hr:employee:manage', 1, '/hr/employee', 'hr/employee/index', 'employee', 1, 1, 1, '2023-02-10 09:05:00', 2, '2023-10-20 13:30:00', '员工管理菜单', 0);
INSERT INTO `sys_permission` VALUES (22, 20, '招聘管理', 'hr:recruit:manage', 1, '/hr/recruit', 'hr/recruit/index', 'recruit', 2, 1, 1, '2023-02-10 09:10:00', 2, '2023-10-25 15:20:00', '招聘管理菜单', 0);
INSERT INTO `sys_permission` VALUES (23, 20, '考勤管理', 'hr:attendance:manage', 1, '/hr/attendance', 'hr/attendance/index', 'attendance', 3, 1, 1, '2023-02-10 09:15:00', 2, '2023-10-30 10:15:00', '考勤管理菜单', 0);
INSERT INTO `sys_permission` VALUES (24, 0, '财务管理', 'finance:manage', 1, '/finance', 'finance/index', 'finance', 3, 1, 1, '2023-02-15 14:00:00', 1, '2023-10-18 14:45:00', '财务管理主菜单', 0);
INSERT INTO `sys_permission` VALUES (25, 24, '账目管理', 'finance:account:manage', 1, '/finance/account', 'finance/account/index', 'account', 1, 1, 1, '2023-02-15 14:05:00', 3, '2023-10-22 11:30:00', '账目管理菜单', 0);
INSERT INTO `sys_permission` VALUES (26, 24, '报销管理', 'finance:reimburse:manage', 1, '/finance/reimburse', 'finance/reimburse/index', 'reimburse', 2, 1, 1, '2023-02-15 14:10:00', 3, '2023-10-26 16:20:00', '报销管理菜单', 0);
INSERT INTO `sys_permission` VALUES (27, 24, '工资管理', 'finance:salary:manage', 1, '/finance/salary', 'finance/salary/index', 'salary', 3, 1, 1, '2023-02-15 14:15:00', 3, '2023-10-28 09:45:00', '工资管理菜单', 0);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色编码',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `created_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人ID',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` bigint(20) NULL DEFAULT NULL COMMENT '更新人ID',
  `updated_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_code`(`role_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'SUPER_ADMIN', 1, NULL, '2023-01-10 00:00:00', NULL, '2023-10-20 14:30:00', '系统最高权限角色', 0);
INSERT INTO `sys_role` VALUES (2, '系统管理员', 'SYS_ADMIN', 1, 1, '2023-01-15 09:30:00', 1, '2023-10-15 11:20:00', '系统管理角色，拥有大部分管理权限', 0);
INSERT INTO `sys_role` VALUES (3, '人力资源经理', 'HR_MANAGER', 1, 1, '2023-02-10 10:15:00', 1, '2023-10-25 15:40:00', '人力资源部门经理角色', 0);
INSERT INTO `sys_role` VALUES (4, '人力资源专员', 'HR_STAFF', 1, 1, '2023-02-10 10:20:00', 2, '2023-10-30 16:10:00', '人力资源部门专员角色', 0);
INSERT INTO `sys_role` VALUES (5, '财务经理', 'FINANCE_MANAGER', 1, 1, '2023-02-10 10:25:00', 1, '2023-10-22 13:30:00', '财务部门经理角色', 0);
INSERT INTO `sys_role` VALUES (6, '财务专员', 'FINANCE_STAFF', 1, 1, '2023-02-10 10:30:00', 3, '2023-10-28 10:15:00', '财务部门专员角色', 0);
INSERT INTO `sys_role` VALUES (7, '技术经理', 'TECH_MANAGER', 1, 1, '2023-03-05 14:00:00', 1, '2023-10-18 09:45:00', '技术部门经理角色', 0);
INSERT INTO `sys_role` VALUES (8, '前端开发', 'FRONTEND_DEV', 1, 1, '2023-03-05 14:05:00', 7, '2023-10-26 11:30:00', '前端开发工程师角色', 0);
INSERT INTO `sys_role` VALUES (9, '后端开发', 'BACKEND_DEV', 1, 1, '2023-03-05 14:10:00', 7, '2023-10-24 14:20:00', '后端开发工程师角色', 0);
INSERT INTO `sys_role` VALUES (10, '测试工程师', 'TEST_ENGINEER', 1, 1, '2023-03-05 14:15:00', 7, '2023-10-21 15:50:00', '测试工程师角色', 0);
INSERT INTO `sys_role` VALUES (11, '市场经理', 'MARKET_MANAGER', 1, 1, '2023-04-10 11:00:00', 1, '2023-10-29 10:45:00', '市场部门经理角色', 0);

-- ----------------------------
-- Table structure for sys_role_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `permission_id` bigint(20) NOT NULL COMMENT '权限ID',
  `created_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人ID',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_permission`(`role_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `idx_permission_id`(`permission_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色权限关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_permission
-- ----------------------------
INSERT INTO `sys_role_permission` VALUES (1, 1, 1, NULL, '2023-01-10 00:00:00');
INSERT INTO `sys_role_permission` VALUES (2, 1, 2, NULL, '2023-01-10 00:05:00');
INSERT INTO `sys_role_permission` VALUES (3, 1, 3, NULL, '2023-01-10 00:10:00');
INSERT INTO `sys_role_permission` VALUES (4, 1, 4, NULL, '2023-01-10 00:15:00');
INSERT INTO `sys_role_permission` VALUES (5, 1, 5, NULL, '2023-01-10 00:20:00');
INSERT INTO `sys_role_permission` VALUES (6, 1, 6, NULL, '2023-01-10 00:25:00');
INSERT INTO `sys_role_permission` VALUES (7, 1, 7, NULL, '2023-01-10 00:30:00');
INSERT INTO `sys_role_permission` VALUES (8, 1, 8, NULL, '2023-01-10 00:35:00');
INSERT INTO `sys_role_permission` VALUES (9, 1, 9, NULL, '2023-01-10 00:40:00');
INSERT INTO `sys_role_permission` VALUES (10, 1, 10, NULL, '2023-01-10 00:45:00');
INSERT INTO `sys_role_permission` VALUES (11, 1, 11, NULL, '2023-01-10 00:50:00');
INSERT INTO `sys_role_permission` VALUES (12, 1, 12, NULL, '2023-01-10 00:55:00');
INSERT INTO `sys_role_permission` VALUES (13, 1, 13, NULL, '2023-01-10 01:00:00');
INSERT INTO `sys_role_permission` VALUES (14, 1, 14, NULL, '2023-01-10 01:05:00');
INSERT INTO `sys_role_permission` VALUES (15, 1, 15, NULL, '2023-01-10 01:10:00');
INSERT INTO `sys_role_permission` VALUES (16, 1, 16, NULL, '2023-01-10 01:15:00');
INSERT INTO `sys_role_permission` VALUES (17, 1, 17, NULL, '2023-01-10 01:20:00');
INSERT INTO `sys_role_permission` VALUES (18, 1, 18, NULL, '2023-01-10 01:25:00');
INSERT INTO `sys_role_permission` VALUES (19, 1, 19, NULL, '2023-01-10 01:30:00');
INSERT INTO `sys_role_permission` VALUES (20, 1, 20, NULL, '2023-01-10 01:35:00');
INSERT INTO `sys_role_permission` VALUES (21, 1, 21, NULL, '2023-01-10 01:40:00');
INSERT INTO `sys_role_permission` VALUES (22, 1, 22, NULL, '2023-01-10 01:45:00');
INSERT INTO `sys_role_permission` VALUES (23, 1, 23, NULL, '2023-01-10 01:50:00');
INSERT INTO `sys_role_permission` VALUES (24, 1, 24, NULL, '2023-01-10 01:55:00');
INSERT INTO `sys_role_permission` VALUES (25, 1, 25, NULL, '2023-01-10 02:00:00');
INSERT INTO `sys_role_permission` VALUES (26, 1, 26, NULL, '2023-01-10 02:05:00');
INSERT INTO `sys_role_permission` VALUES (27, 1, 27, NULL, '2023-01-10 02:10:00');
INSERT INTO `sys_role_permission` VALUES (28, 2, 1, 1, '2023-01-15 10:05:00');
INSERT INTO `sys_role_permission` VALUES (29, 2, 2, 1, '2023-01-15 10:10:00');
INSERT INTO `sys_role_permission` VALUES (30, 2, 3, 1, '2023-01-15 10:15:00');
INSERT INTO `sys_role_permission` VALUES (31, 2, 4, 1, '2023-01-15 10:20:00');
INSERT INTO `sys_role_permission` VALUES (32, 2, 5, 1, '2023-01-15 10:25:00');
INSERT INTO `sys_role_permission` VALUES (33, 2, 6, 1, '2023-01-15 10:30:00');
INSERT INTO `sys_role_permission` VALUES (34, 2, 7, 1, '2023-01-15 10:35:00');
INSERT INTO `sys_role_permission` VALUES (35, 2, 8, 1, '2023-01-15 10:40:00');
INSERT INTO `sys_role_permission` VALUES (36, 2, 9, 1, '2023-01-15 10:45:00');
INSERT INTO `sys_role_permission` VALUES (37, 2, 10, 1, '2023-01-15 10:50:00');
INSERT INTO `sys_role_permission` VALUES (38, 2, 11, 1, '2023-01-15 10:55:00');
INSERT INTO `sys_role_permission` VALUES (39, 2, 12, 1, '2023-01-15 11:00:00');
INSERT INTO `sys_role_permission` VALUES (40, 2, 13, 1, '2023-01-15 11:05:00');
INSERT INTO `sys_role_permission` VALUES (41, 2, 14, 1, '2023-01-15 11:10:00');
INSERT INTO `sys_role_permission` VALUES (42, 3, 20, 1, '2023-02-15 10:40:00');
INSERT INTO `sys_role_permission` VALUES (43, 3, 21, 1, '2023-02-15 10:45:00');
INSERT INTO `sys_role_permission` VALUES (44, 3, 22, 1, '2023-02-15 10:50:00');
INSERT INTO `sys_role_permission` VALUES (45, 3, 23, 1, '2023-02-15 10:55:00');
INSERT INTO `sys_role_permission` VALUES (46, 4, 20, 2, '2023-03-05 14:30:00');
INSERT INTO `sys_role_permission` VALUES (47, 4, 21, 2, '2023-03-05 14:35:00');
INSERT INTO `sys_role_permission` VALUES (48, 4, 22, 2, '2023-03-05 14:40:00');
INSERT INTO `sys_role_permission` VALUES (49, 4, 23, 2, '2023-03-05 14:45:00');
INSERT INTO `sys_role_permission` VALUES (50, 5, 24, 1, '2023-02-16 09:25:00');
INSERT INTO `sys_role_permission` VALUES (51, 5, 25, 1, '2023-02-16 09:30:00');
INSERT INTO `sys_role_permission` VALUES (52, 5, 26, 1, '2023-02-16 09:35:00');
INSERT INTO `sys_role_permission` VALUES (53, 5, 27, 1, '2023-02-16 09:40:00');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户姓名',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电子邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号码',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `created_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人ID',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` bigint(20) NULL DEFAULT NULL COMMENT '更新人ID',
  `updated_time` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '系统管理员', 'admin@example.com', '13800138000', 1, '/avatars/admin.jpg', '2023-11-15 09:30:00', NULL, '2023-01-10 00:00:00', NULL, '2023-11-10 15:20:30', '系统超级管理员', 0);
INSERT INTO `sys_user` VALUES (2, 'zhangsan', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '张三', 'zhangsan@example.com', '13800138001', 1, '/avatars/zhangsan.jpg', '2023-11-14 14:20:15', 1, '2023-02-15 10:30:00', 1, '2023-11-05 11:25:40', '人力资源部经理', 0);
INSERT INTO `sys_user` VALUES (3, 'lisi', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '李四', 'lisi@example.com', '13800138002', 1, '/avatars/lisi.jpg', '2023-11-15 10:15:30', 1, '2023-02-16 09:15:00', 1, '2023-11-08 09:45:10', '财务部经理', 0);
INSERT INTO `sys_user` VALUES (4, 'wangwu', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '王五', 'wangwu@example.com', '13800138003', 1, '/avatars/wangwu.jpg', '2023-11-13 16:40:20', 1, '2023-03-05 14:20:00', 2, '2023-11-12 16:30:25', '人力资源部专员', 0);
INSERT INTO `sys_user` VALUES (5, 'zhaoliu', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '赵六', 'zhaoliu@example.com', '13800138004', 1, '/avatars/zhaoliu.jpg', '2023-11-15 08:50:10', 1, '2023-03-10 11:05:00', 3, '2023-11-09 10:15:30', '财务部专员', 0);
INSERT INTO `sys_user` VALUES (6, 'sunqi', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '孙七', 'sunqi@example.com', '13800138005', 1, '/avatars/sunqi.jpg', '2023-11-14 13:25:45', 1, '2023-04-02 15:40:00', 1, '2023-11-11 14:20:15', '技术部经理', 0);
INSERT INTO `sys_user` VALUES (7, 'zhouba', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '周八', 'zhouba@example.com', '13800138006', 1, '/avatars/zhouba.jpg', '2023-11-12 10:30:20', 7, '2023-04-15 09:25:00', 7, '2023-11-07 11:30:40', '前端开发工程师', 0);
INSERT INTO `sys_user` VALUES (8, 'wujiu', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '吴九', 'wujiu@example.com', '13800138007', 1, '/avatars/wujiu.jpg', '2023-11-15 11:45:30', 7, '2023-05-08 13:10:00', 7, '2023-11-10 13:50:20', '后端开发工程师', 0);
INSERT INTO `sys_user` VALUES (9, 'zhengshi', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '郑十', 'zhengshi@example.com', '13800138008', 0, '/avatars/zhengshi.jpg', NULL, 7, '2023-05-12 16:30:00', 1, '2023-11-01 09:15:00', '测试工程师，已离职', 0);
INSERT INTO `sys_user` VALUES (10, 'chener', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '陈二', 'chener@example.com', '13800138009', 1, '/avatars/chener.jpg', '2023-11-13 15:20:10', 1, '2023-06-05 10:15:00', 1, '2023-11-06 14:30:15', '市场部经理', 0);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `role_id` bigint(20) NOT NULL COMMENT '角色ID',
  `created_by` bigint(20) NULL DEFAULT NULL COMMENT '创建人ID',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_role`(`user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1, 1, NULL, '2023-01-10 00:00:00');
INSERT INTO `sys_user_role` VALUES (2, 1, 2, 1, '2023-01-15 10:00:00');
INSERT INTO `sys_user_role` VALUES (3, 2, 3, 1, '2023-02-15 10:35:00');
INSERT INTO `sys_user_role` VALUES (4, 3, 5, 1, '2023-02-16 09:20:00');
INSERT INTO `sys_user_role` VALUES (5, 4, 4, 2, '2023-03-05 14:25:00');
INSERT INTO `sys_user_role` VALUES (6, 5, 6, 3, '2023-03-10 11:10:00');
INSERT INTO `sys_user_role` VALUES (7, 6, 7, 1, '2023-04-02 15:45:00');
INSERT INTO `sys_user_role` VALUES (8, 7, 8, 7, '2023-04-15 09:30:00');
INSERT INTO `sys_user_role` VALUES (9, 8, 9, 7, '2023-05-08 13:15:00');
INSERT INTO `sys_user_role` VALUES (10, 9, 10, 7, '2023-05-12 16:35:00');
INSERT INTO `sys_user_role` VALUES (11, 10, 11, 1, '2023-06-05 10:20:00');
INSERT INTO `sys_user_role` VALUES (12, 4, 2, 1, '2023-06-10 11:30:00');
INSERT INTO `sys_user_role` VALUES (13, 6, 2, 1, '2023-06-15 14:20:00');

-- ----------------------------
-- Table structure for task_list
-- ----------------------------
DROP TABLE IF EXISTS `task_list`;
CREATE TABLE `task_list`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `task_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务编号',
  `task_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '任务名称',
  `workstation_code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工作站编号',
  `workstation_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工作站名称',
  `workflow_id` bigint(20) NULL DEFAULT NULL COMMENT '工作流ID',
  `process_id` bigint(20) NULL DEFAULT NULL COMMENT '工艺流程ID',
  `production_order_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `scheduled_quantity` int(11) NOT NULL COMMENT '排产数量',
  `produced_quantity` int(11) NULL DEFAULT 0 COMMENT '已生产数量',
  `start_time` datetime NULL DEFAULT NULL COMMENT '开始生产时间',
  `production_duration` int(11) NULL DEFAULT NULL COMMENT '生产时长(分钟)',
  `estimated_completion_time` datetime NULL DEFAULT NULL COMMENT '预计完成时间',
  `display_color` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '显示颜色',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `delete_flag` tinyint(1) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '任务列表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of task_list
-- ----------------------------
INSERT INTO `task_list` VALUES (1, 'T001', 'Assembly Task A211', 'WS001', 'Workstation 1111', 1, 1, 'MO20250922007', 10, 200, '2025-09-01 08:00:00', 10, '2025-09-01 10:00:00', 'yellow', '2025-09-24 15:19:48', '2025-09-26 14:52:47', 1);
INSERT INTO `task_list` VALUES (2, 'T002', 'Assembly Task B', 'WS002', 'Workstation 2', 1, 1, 'MO20250922007', 500, 50, '2025-09-02 09:00:00', 90, '2025-09-02 11:30:00', 'Green', '2025-09-24 15:19:48', '2025-09-26 14:52:47', 1);
INSERT INTO `task_list` VALUES (3, 'T003', 'Packaging Task A', 'WS003', 'Workstation 3', 1, 2, 'MO20250922007', 300, 150, '2025-09-03 10:00:00', 60, '2025-09-03 11:00:00', 'Blue', '2025-09-24 15:19:48', '2025-09-25 18:31:09', 0);
INSERT INTO `task_list` VALUES (4, 'T004', 'Inspection Task', 'WS004', 'Workstation 4', 1, 3, 'MO20250922007', 800, 400, '2025-09-04 11:00:00', 150, '2025-09-04 14:30:00', 'Yellow', '2025-09-24 15:19:48', '2025-09-25 18:31:10', 0);
INSERT INTO `task_list` VALUES (5, 'T015', '11123', 'WT001', '装配工位01', 1, 1, 'MO20250922007', 4, NULL, '2025-09-29 00:00:00', 3, '2025-09-29 03:00:00', '#f64c4c', '2025-09-24 22:43:04', '2025-09-25 18:31:11', 1);
INSERT INTO `task_list` VALUES (6, 'T016', '11', 'WT002', '装配工位02', 1, 1, 'MO20250922007', 2, NULL, '2025-09-30 00:00:00', 2, '2025-09-30 02:00:00', '#e06969', '2025-09-24 22:48:17', '2025-09-25 18:31:12', 1);
INSERT INTO `task_list` VALUES (7, 'T017', '111', 'WT003', '机加工工位01', 1, 2, 'MO20250922007', 2, NULL, '2025-09-30 00:00:00', 3, '2025-09-30 03:00:00', '#c15f5f', '2025-09-24 22:50:18', '2025-09-25 18:31:14', 0);
INSERT INTO `task_list` VALUES (9, 'T0011', '1111', 'WT002', '装配工位02', 1, 1, 'MO20250922007', 3, NULL, '2025-09-16 00:00:00', 3, '2025-09-16 03:00:00', '#020000', '2025-09-25 16:32:25', '2025-09-25 18:31:15', 1);
INSERT INTO `task_list` VALUES (10, 'T0015', '11', 'WT001', '装配工位01', 1, 1, 'MO20250922007', 2, NULL, '2025-09-25 16:54:01', 4, '2025-09-25 20:54:01', '#3c1515', '2025-09-25 16:54:03', '2025-09-25 18:31:15', 1);
INSERT INTO `task_list` VALUES (11, 'T0016', '1111', 'WT001', '装配工位01', 1, 1, 'MO20250922007', 1, NULL, '2025-09-23 00:00:00', 2, '2025-09-23 02:00:00', '#8e1c1c', '2025-09-25 16:54:30', '2025-09-25 18:31:29', 1);
INSERT INTO `task_list` VALUES (12, 'T0018', '1111', 'WT001', '装配工位01', 2, 1, 'MO20250922005', 2, NULL, '2025-09-24 00:00:00', 2, '2025-09-24 02:00:00', '#9b3c3c', '2025-09-25 17:17:43', '2025-09-25 18:31:40', 0);
INSERT INTO `task_list` VALUES (13, 'T0020', '111', 'WT001', '装配工位01', 1, 1, NULL, 2, NULL, '2025-09-09 00:00:00', 3, '2025-09-09 02:00:00', '#ca2222', '2025-09-25 18:45:53', '2025-09-25 18:45:53', 0);
INSERT INTO `task_list` VALUES (14, 'T0020', '狒狒', 'WT001', '装配工位01', 1, 1, 'MO20250922007', 2, NULL, '2025-09-25 18:59:04', 2, '2025-09-25 20:59:04', '#e54646', '2025-09-25 19:00:43', '2025-09-26 14:52:31', 1);

-- ----------------------------
-- Table structure for unit
-- ----------------------------
DROP TABLE IF EXISTS `unit`;
CREATE TABLE `unit`  (
  `id` bigint(20) NOT NULL COMMENT '单位编号',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位编码',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '单位名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '单位描述',
  `is_main_unit` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否主单位(0:否,1:是)',
  `main_unit_id` bigint(20) NULL DEFAULT NULL COMMENT '主单位编号',
  `conversion_ratio` decimal(10, 4) NULL DEFAULT NULL COMMENT '换算比例',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '计量单位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of unit
-- ----------------------------
INSERT INTO `unit` VALUES (1, 'UNIT001', '件', '基本单位-件', 1, NULL, 1.0000, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (2, 'UNIT002', '箱', '箱装单位', 0, 1, 12.0000, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (3, 'UNIT003', '包', '包装单位', 0, 1, 24.0000, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (4, 'UNIT004', '千克', '重量单位', 1, NULL, 1.0000, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (5, 'UNIT005', '克', '小重量单位', 0, 4, 0.0010, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (6, 'UNIT006', '吨', '大重量单位', 0, 4, 1000.0000, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (7, 'UNIT007', '米', '长度单位', 1, NULL, 1.0000, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (8, 'UNIT008', '厘米', '小长度单位', 0, 7, 0.0100, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (9, 'UNIT009', '毫米', '微长度单位', 0, 7, 0.0010, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (10, 'UNIT010', '升', '容积单位', 1, NULL, 1.0000, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (11, 'UNIT011', '毫升', '小容积单位', 0, 10, 0.0010, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `unit` VALUES (12, 'UNIT012', '打', '打装单位', 0, 1, 12.0000, 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);

-- ----------------------------
-- Table structure for work_flow_process
-- ----------------------------
DROP TABLE IF EXISTS `work_flow_process`;
CREATE TABLE `work_flow_process`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `workflow_id` bigint(20) NOT NULL,
  `process_id` bigint(20) NOT NULL,
  `step_order` int(10) NOT NULL,
  `relation_next` bigint(20) NULL DEFAULT NULL,
  `gantt_color` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `is_critical` int(11) NULL DEFAULT 0,
  `need_inspection` int(11) NULL DEFAULT 0,
  `prep_time` int(11) NULL DEFAULT NULL,
  `wait_time` int(11) NULL DEFAULT NULL,
  `remarks` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `delete_flag` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of work_flow_process
-- ----------------------------
INSERT INTO `work_flow_process` VALUES (1, 1, 1, 1, 24, '#3498db', 1, 0, 30, 10, '粗加工是关键工序', '2025-09-18 15:52:48', 'admin', '2025-09-21 16:45:12', 'admin', 0);
INSERT INTO `work_flow_process` VALUES (2, 1, 2, 2, 25, '#e74c3c', 1, 1, 60, 15, '热处理后需质检', '2025-09-18 15:52:48', 'admin', '2025-09-18 18:59:35', 'admin', 0);
INSERT INTO `work_flow_process` VALUES (3, 1, 3, 3, 23, '#2ecc71', 1, 0, 45, 5, '精加工前需校准设备', '2025-09-18 15:52:48', 'admin', '2025-09-18 21:11:06', 'admin', 0);
INSERT INTO `work_flow_process` VALUES (4, 1, 4, 4, 26, '#f39c12', 0, 1, 20, 20, '表面处理后必须质检', '2025-09-18 15:52:48', 'admin', '2025-09-19 11:44:17', 'admin', 0);
INSERT INTO `work_flow_process` VALUES (19, 1, 6, 5, 23, '', 1, NULL, 2, 0, '', '2025-09-19 16:28:30', NULL, '2025-09-20 11:49:40', NULL, 1);
INSERT INTO `work_flow_process` VALUES (20, 2, 1, 1, 23, '#b24949', 1, 1, 1, 1, '', '2025-09-20 09:23:19', NULL, '2025-09-20 09:23:19', NULL, 0);
INSERT INTO `work_flow_process` VALUES (22, 1, 5, 5, 24, '#b95858', 0, 0, 1, 1, '', '2025-09-20 11:49:55', NULL, '2025-09-20 13:25:43', NULL, 1);

-- ----------------------------
-- Table structure for work_flow_product
-- ----------------------------
DROP TABLE IF EXISTS `work_flow_product`;
CREATE TABLE `work_flow_product`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `workflow_id` bigint(20) NOT NULL,
  `product_code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `remarks` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `delete_flag` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of work_flow_product
-- ----------------------------
INSERT INTO `work_flow_product` VALUES (1, 1, 'MAT004', '芯片A入库审批', '2025-09-19 16:11:53', '仓库管理员', '2025-09-20 14:08:52', '仓库管理员', 0);
INSERT INTO `work_flow_product` VALUES (3, 1, 'MAT007', '锂电池入库质检', '2025-09-19 16:11:53', '仓库管理员', '2025-09-19 21:55:24', '质量专员', 0);
INSERT INTO `work_flow_product` VALUES (4, 2, 'MAT003', '电阻1KΩ生产领用', '2025-09-19 16:11:53', '生产组长', '2025-09-19 16:11:53', '生产组长', 0);
INSERT INTO `work_flow_product` VALUES (5, 2, 'MAT004', '电容100μF生产领用', '2025-09-19 16:11:53', '生产组长', '2025-09-23 22:33:38', '生产组长', 1);
INSERT INTO `work_flow_product` VALUES (6, 2, 'MAT008', 'PCB主板生产领用', '2025-09-19 16:11:53', '生产组长', '2025-09-19 16:11:53', '车间主管', 0);
INSERT INTO `work_flow_product` VALUES (7, 3, 'MAT005', '铝合金外壳季度盘点', '2025-09-19 16:11:53', '库存专员', '2025-09-19 16:11:53', '库存专员', 0);
INSERT INTO `work_flow_product` VALUES (8, 3, 'MAT006', '塑料按键季度盘点', '2025-09-19 16:11:53', '库存专员', '2025-09-19 16:11:53', '库存专员', 0);
INSERT INTO `work_flow_product` VALUES (9, 3, 'MAT009', '连接器库存核对', '2025-09-19 16:11:53', '库存专员', '2025-09-19 16:11:53', '仓库经理', 0);
INSERT INTO `work_flow_product` VALUES (10, 4, 'MAT010', '显示屏老化报废', '2025-09-19 16:11:53', '设备管理员', '2025-09-19 16:11:53', '设备主管', 0);
INSERT INTO `work_flow_product` VALUES (11, 4, 'MAT011', '扬声器损坏报废', '2025-09-19 16:11:53', '设备管理员', '2025-09-19 16:11:53', '设备主管', 0);
INSERT INTO `work_flow_product` VALUES (12, 5, 'MAT012', '成品设备A最终检验', '2025-09-19 16:11:53', '质检主管', '2025-09-19 16:11:53', '生产经理', 0);

-- ----------------------------
-- Table structure for workflow
-- ----------------------------
DROP TABLE IF EXISTS `workflow`;
CREATE TABLE `workflow`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `workflow_code` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `workflow_name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `status` int(11) NULL DEFAULT 1,
  `workflow_description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remarks` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `delete_flag` int(11) NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `workflow_code`(`workflow_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of workflow
-- ----------------------------
INSERT INTO `workflow` VALUES (1, 'PROC-MECH-001', '机械零件粗加工流程', 1, '适用于金属零件的初步切削加工', '需配合冷却液使用', '2025-09-17 22:26:15', 'admin', '2025-09-21 16:45:13', 'admin', 0);
INSERT INTO `workflow` VALUES (2, 'PROC-ASSY-002', '电子产品装配流程', 1, '包含元器件焊接、组装、初测', '注意ESD防护', '2025-09-17 22:26:15', 'engineer1', '2025-09-17 22:26:15', 'engineer1', 0);
INSERT INTO `workflow` VALUES (3, 'PROC-OLD-003', '传统热处理流程', 1, '传统淬火工艺，已被新工艺替代', '2025年9月停用', '2025-09-17 22:26:15', 'manager', '2025-09-19 14:35:17', 'manager', 0);
INSERT INTO `workflow` VALUES (4, 'PROC-PREC-004', '精密零件研磨流程', 1, '达到Ra0.8表面粗糙度的研磨工艺', '需恒温车间操作', '2025-09-17 22:26:15', 'technician', '2025-09-18 15:32:24', 'technician', 1);
INSERT INTO `workflow` VALUES (5, 'PROC-NEW-005', '自动化焊接流程', 1, '机器人自动焊接工艺，效率提升30%', '2025年10月正式启用', '2025-09-17 22:26:15', 'admin', '2025-09-18 15:32:24', 'engineer2', 1);
INSERT INTO `workflow` VALUES (6, 'PROC-MECH-006', '飞谭工12', 0, '对工艺流程', '1111', '2025-09-18 14:40:17', NULL, '2025-09-18 15:25:38', NULL, 1);

-- ----------------------------
-- Table structure for workshop
-- ----------------------------
DROP TABLE IF EXISTS `workshop`;
CREATE TABLE `workshop`  (
  `id` bigint(20) NOT NULL COMMENT '车间编号',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '车间编码',
  `area` decimal(10, 2) NULL DEFAULT NULL COMMENT '车间面积',
  `manager` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '车间负责人',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '车间名称',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '车间描述',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '车间信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of workshop
-- ----------------------------
INSERT INTO `workshop` VALUES (1, 'WS001', 1200.50, '张主任', '装配车间A', '主要负责产品装配', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (2, 'WS002', 980.30, '李主任', '机加工车间B', '负责零部件机加工', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (3, 'WS003', 1500.00, '王主任', '焊接车间C', '负责产品焊接工艺', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (4, 'WS004', 800.75, '赵主任', '喷涂车间D', '负责产品表面处理', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (5, 'WS005', 1100.20, '陈主任', '质检车间E', '负责产品质量检测', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (6, 'WS006', 1300.80, '刘主任', '包装车间F', '负责产品包装', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (7, 'WS007', 950.60, '杨主任', '电子车间G', '负责电子产品组装', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (8, 'WS008', 1050.40, '黄主任', '冲压车间H', '负责金属板材冲压', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (9, 'WS009', 1400.90, '周主任', '热处理车间I', '负责材料热处理', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (10, 'WS010', 750.30, '吴主任', '维修车间J', '负责设备维护', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (11, 'WS011', 1250.70, '郑主任', '总装车间K', '负责产品总装', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workshop` VALUES (12, 'WS012', 880.50, '孙主任', '测试车间L', '负责产品功能测试', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);

-- ----------------------------
-- Table structure for workstation
-- ----------------------------
DROP TABLE IF EXISTS `workstation`;
CREATE TABLE `workstation`  (
  `id` bigint(20) NOT NULL COMMENT '工作站编号',
  `code` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工作站编码',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '工作站名称',
  `workshop_id` bigint(20) NULL DEFAULT NULL COMMENT '所属车间编号',
  `location` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工作站地点',
  `process_id` bigint(20) NULL DEFAULT NULL COMMENT '所属工序编号',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '工作站描述',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int(11) NULL DEFAULT 0 COMMENT '删除标记',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '工作站信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of workstation
-- ----------------------------
INSERT INTO `workstation` VALUES (1, 'WT001', '装配工位01', 1, '装配车间A-东侧', 1, '负责产品初步装配', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (2, 'WT002', '装配工位02', 1, '装配车间A-西侧', 1, '负责产品核心部件装配', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (3, 'WT003', '机加工工位01', 2, '机加工车间B-南侧', 2, '负责零部件粗加工', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (4, 'WT004', '机加工工位02', 2, '机加工车间B-北侧', 2, '负责零部件精加工', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (5, 'WT005', '焊接工位01', 3, '焊接车间C-中央区', 3, '负责产品结构焊接', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (6, 'WT006', '喷涂工位01', 4, '喷涂车间D-东侧', 4, '负责产品底漆喷涂', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (7, 'WT007', '喷涂工位02', 4, '喷涂车间D-西侧', 4, '负责产品面漆喷涂', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (8, 'WT008', '质检工位01', 5, '质检车间E-南侧', 5, '负责产品尺寸检测', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (9, 'WT009', '质检工位02', 5, '质检车间E-北侧', 5, '负责产品功能检测', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (10, 'WT010', '包装工位01', 6, '包装车间F-东侧', 6, '负责产品内包装', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (11, 'WT011', '包装工位02', 6, '包装车间F-西侧', 6, '负责产品外包装', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);
INSERT INTO `workstation` VALUES (12, 'WT012', '电子装配工位01', 7, '电子车间G-南侧', 7, '负责电路板装配', 1, '2025-09-16 19:30:56', '2025-09-16 19:30:56', 0);

SET FOREIGN_KEY_CHECKS = 1;
