/*
 Navicat Premium Dump SQL

 Source Server         : hjj
 Source Server Type    : MySQL
 Source Server Version : 80400 (8.4.0)
 Source Host           : localhost:3306
 Source Schema         : tourism

 Target Server Type    : MySQL
 Target Server Version : 80400 (8.4.0)
 File Encoding         : 65001

 Date: 02/01/2025 16:30:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity
-- ----------------------------
DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `activity_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` enum('进行中','已结束') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '进行中',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `pic` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of activity
-- ----------------------------
INSERT INTO `activity` VALUES (1, '夏季读书会', '11111111', '2024-11-27 02:02:00', '2024-12-21 02:02:00', '云龙湖', '进行中', '2024-12-08 02:04:24', 'dc6e108f-3744-46db-97fd-0e93d8e6ce42.png');
INSERT INTO `activity` VALUES (2, '云龙湖摄影', '邀请所有书籍爱好者参加的读书分享活动。', '2024-11-27 02:02:00', '2024-12-21 02:02:00', '市图书馆会议室', '进行中', '2024-12-08 02:04:24', '514e71b2-4cbd-49c6-80a5-3a4d657cbe2b.png');
INSERT INTO `activity` VALUES (3, '健康跑步活动', '每周六早上组织的社区跑步活动，鼓励居民锻炼身体。', '2024-11-27 02:02:00', '2024-12-21 02:02:00', '社区公园', '进行中', '2024-12-08 02:04:24', 'a7a28308-d6f9-41f5-9714-1059176ea03a.png');
INSERT INTO `activity` VALUES (4, '青少年编程工作坊', '为青少年提供的编程基础课程，帮助他们入门计算机科学。', '2024-11-27 02:02:00', '2024-12-21 02:02:00', '青少年活动中心', '进行中', '2024-12-08 02:04:24', '400e28d5-fa9a-4290-b884-b8e705826c94.png');
INSERT INTO `activity` VALUES (5, '夏季音乐节', '一个为期三天的音乐节，汇聚了国内外多位知名音乐人。', '2024-11-27 02:02:00', '2024-12-21 02:02:00', '市中心公园', '进行中', '2024-12-08 02:04:24', 'd2ee353a-1f23-458e-91e3-2e2d00766925.png');

-- ----------------------------
-- Table structure for activity_booking
-- ----------------------------
DROP TABLE IF EXISTS `activity_booking`;
CREATE TABLE `activity_booking`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户姓名',
  `activity_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '活动名称',
  `booking_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '预约时间',
  `status` enum('未确认','已确认','已取消') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '预约状态',
  `activity_id` int NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_activity`(`activity_id` ASC) USING BTREE,
  CONSTRAINT `fk_activity` FOREIGN KEY (`activity_id`) REFERENCES `activity` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of activity_booking
-- ----------------------------
INSERT INTO `activity_booking` VALUES (17, 2, 'zs', '云龙湖摄影', '2024-12-08 02:41:46', '已确认', 1);
INSERT INTO `activity_booking` VALUES (20, 10, 'zs', '夏季读书会', '2024-12-17 13:12:25', '未确认', 1);

-- ----------------------------
-- Table structure for food_order
-- ----------------------------
DROP TABLE IF EXISTS `food_order`;
CREATE TABLE `food_order`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户姓名',
  `food_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '美食名称',
  `quantity` int NULL DEFAULT NULL COMMENT '数量',
  `total_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '总价',
  `order_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '订单时间',
  `status` enum('待处理','已处理','已取消') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '订单状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of food_order
-- ----------------------------
INSERT INTO `food_order` VALUES (1, 1, 'john_doe', '把子肉', 1, 298.00, '2024-12-05 20:12:26', '待处理');
INSERT INTO `food_order` VALUES (2, 2, 'jane_smith', '蛙鱼', 2, 120.00, '2024-12-05 20:12:26', '已处理');
INSERT INTO `food_order` VALUES (3, 3, 'alice_wang', '米线', 3, 45.00, '2024-12-05 20:12:26', '待处理');
INSERT INTO `food_order` VALUES (4, 4, 'bob_zhang', '把子肉', 5, 25.00, '2024-12-05 20:12:26', '已处理');
INSERT INTO `food_order` VALUES (5, 5, 'charlie_li', '蛙鱼', 10, 100.00, '2024-12-05 20:12:26', '已取消');
INSERT INTO `food_order` VALUES (7, NULL, 'zs', '徐州地锅鸡123', 10, 10.00, '2024-12-07 23:22:42', '待处理');
INSERT INTO `food_order` VALUES (28, NULL, 'vendor', '麻婆豆腐', 1, 28.00, '2024-12-30 14:55:38', NULL);
INSERT INTO `food_order` VALUES (31, NULL, 'vendor', '宫保鸡丁', 1, 38.00, '2024-12-30 15:01:09', NULL);
INSERT INTO `food_order` VALUES (32, NULL, 'vendor', '宫保鸡丁', 1, 38.00, '2024-12-30 15:02:39', NULL);
INSERT INTO `food_order` VALUES (33, NULL, 'vendor', '宫保鸡丁', 3, 114.00, '2024-12-30 15:09:49', NULL);
INSERT INTO `food_order` VALUES (34, NULL, '2', '宫保鸡丁', 1, 38.00, '2024-12-31 19:07:00', NULL);
INSERT INTO `food_order` VALUES (35, NULL, '2', '宫保鸡丁', 1, 38.00, '2024-12-31 19:07:23', NULL);
INSERT INTO `food_order` VALUES (36, NULL, 'admin', '宫保鸡丁', 1, 38.00, '2024-12-31 19:28:12', NULL);

-- ----------------------------
-- Table structure for food_rating
-- ----------------------------
DROP TABLE IF EXISTS `food_rating`;
CREATE TABLE `food_rating`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评分ID',
  `food_id` int NOT NULL COMMENT '美食ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `rating` decimal(2, 1) NOT NULL COMMENT '评分(1-5分)',
  `review` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评价内容',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评分时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_food_id`(`food_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `fk_food_rating_food` FOREIGN KEY (`food_id`) REFERENCES `food_recommendation` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '美食评分表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of food_rating
-- ----------------------------
INSERT INTO `food_rating` VALUES (1, 2, 1, 1.0, 'dwdsd', '2025-01-01 20:05:05');
INSERT INTO `food_rating` VALUES (2, 3, 2, 3.0, 'adadad', '2025-01-01 20:05:28');
INSERT INTO `food_rating` VALUES (3, 4, 3, 4.0, 'dsffs', '2025-01-01 20:05:44');
INSERT INTO `food_rating` VALUES (26, 2, 1, 1.5, '', '2025-01-01 21:10:44');
INSERT INTO `food_rating` VALUES (27, 2, 1, 4.0, '', '2025-01-01 21:10:52');
INSERT INTO `food_rating` VALUES (28, 4, 1, 3.5, '', '2025-01-01 21:10:58');
INSERT INTO `food_rating` VALUES (29, 22, 1, 4.0, '', '2025-01-02 16:27:24');

-- ----------------------------
-- Table structure for food_recommendation
-- ----------------------------
DROP TABLE IF EXISTS `food_recommendation`;
CREATE TABLE `food_recommendation`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '推荐ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '美食名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '美食描述',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '推荐时间',
  `pic` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  `avg_rating` decimal(2, 1) NULL DEFAULT 0.0 COMMENT '平均评分',
  `rating_count` int NULL DEFAULT 0 COMMENT '评分次数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of food_recommendation
-- ----------------------------
INSERT INTO `food_recommendation` VALUES (2, '把子肉', '徐州把子肉是中华名小吃之一，是徐州极具特色的小吃。徐州地处苏、鲁、豫、皖四省交界，五省通衢。川、鲁、粤、湘、淮扬等五大主力菜系南北口味在这里水乳交融。形成了特有的饮食文化氛围。是根据孔子\"肉切方正\"的方法烹制，且以无酱不食的古训，把五花猪肉切成正方形。大致到了魏晋南北朝时期，正方形块变成了长方形，至明清时，这种长方形肉块又被扎缚上青蒲草或马蔺草，而形成\"扎把肉\"形式，故称为把子肉。', '2024-12-05 20:12:26', '81763579-02ba-4961-8820-b7a6ab4b2528.jpg', 2.2, 3);
INSERT INTO `food_recommendation` VALUES (3, '蛙鱼', '蛙鱼是徐州的特色小吃。名字虽然叫鱼，但是这里面和鱼没有半毛钱关系，这是一种用山芋淀粉为主料，配上榨菜和花生米等食材一起制作出来的形似蝌蚪的美食，所以取名蛙鱼。吃起来酸辣爽口，夏天可以冷吃，冬天可以热吃，在徐州很受欢迎。', '2024-12-05 20:12:26', '7b7351a5-508b-41cd-a815-594e44a61bfb.jpg', 0.0, 0);
INSERT INTO `food_recommendation` VALUES (4, '米线', '美食特色', '2024-12-05 20:12:26', '920344e6-13fd-4f6f-aa7f-174662e3e245.jpg', 3.8, 2);
INSERT INTO `food_recommendation` VALUES (22, '地锅鸡', '徐州地锅鸡，一道散发着浓郁苏北风情的传统名菜。\n从外观上看，厚实的铸铁锅里，鸡肉块堆得满满当当，色泽诱人，表皮被炖煮至微微金黄，裹着醇厚的酱汁，在锅中滋滋作响。搭配的面饼沿着锅边贴得整整齐齐，一半浸在鲜美的汤汁里，吸饱了鸡肉的鲜香与香料的馥郁，另一半则烤得酥脆，带着淡淡的焦香。', '2025-01-02 16:23:20', 'ea240165-88e5-4fa8-b6a9-4167dc811e7a.jpg', 4.0, 1);
INSERT INTO `food_recommendation` VALUES (23, '烧烤', '徐州烧烤，堪称烧烤江湖中的传奇存在，独具一番令人难以抗拒的魅力。当夜幕降临，街头巷尾的烧烤摊烟火升腾，热闹非凡。烤架上，各类食材琳琅满目，尤以羊肉最为出彩。新鲜的羊肉串在钎子上，肥瘦相间，在炭火的舔舐下，油脂滋滋外冒，瞬间香气四溢，那股子焦香直钻鼻腔，勾得人馋虫大动。', '2025-01-02 16:26:37', 'b58435ea-8ee1-4cd5-b11c-4bb6d3790e4e.jpg', 0.0, 0);

-- ----------------------------
-- Table structure for food_vendor
-- ----------------------------
DROP TABLE IF EXISTS `food_vendor`;
CREATE TABLE `food_vendor`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '商家ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '商家名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '商家描述',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '商家地址',
  `contact_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of food_vendor
-- ----------------------------
INSERT INTO `food_vendor` VALUES (1, '徐州地锅鸡', '徐州地锅鸡是一道江苏徐州的传统名菜，地锅菜起源于苏北和鲁南交界处的微山湖地区。以前，在微山湖上作息的渔民，因船上条件所限，往往取一小泥炉，炉上坐一口铁锅，下面支几块干柴生火，然后按家常的做法煮上一锅菜，锅边还要贴满面饼，于是便产生了这种饭菜合一的烹调方法。地锅菜的汤汁较少，口味鲜醇，饼借菜味，菜借饼香，具有软滑与干香并存的特点。如今，有厨师将传统地锅菜的制法加以改良，从而推出了地锅鸡、地锅鱼、地锅牛肉、地锅三鲜、地锅豆腐、地锅龙虾等地锅佳肴。 按家常的做法煮上一锅菜，然后在锅边贴满面饼，饼借菜味，菜借饼香，具有软滑与干香并存的特点。', '徐州市云龙区', '12345611');
INSERT INTO `food_vendor` VALUES (2, '把子肉', '徐州把子肉是中华名小吃之一，是徐州极具特色的小吃。徐州地处苏、鲁、豫、皖四省交界，五省通衢。川、鲁、粤、湘、淮扬等五大主力菜系南北口味在这里水乳交融。形成了特有的饮食文化氛围。是根据孔子\"肉切方正\"的方法烹制，且以无酱不食的古训，把五花猪肉切成正方形。大致到了魏晋南北朝时期，正方形块变成了长方形，至明清时，这种长方形肉块又被扎缚上青蒲草或马蔺草，而形成\"扎把肉\"形式，故称为把子肉。', '徐州市云龙区美的广场', '987654321');
INSERT INTO `food_vendor` VALUES (3, '蛙鱼', '蛙鱼是徐州的特色小吃。名字虽然叫鱼，但是这里面和鱼没有半毛钱关系，这是一种用山芋淀粉为主料，配上榨菜和花生米等食材一起制作出来的形似蝌蚪的美食，所以取名蛙鱼。吃起来酸辣爽口，夏天可以冷吃，冬天可以热吃，在徐州很受欢迎', '徐州市云龙区77', '456456456');
INSERT INTO `food_vendor` VALUES (4, '米线', '美食特色', '彭城广场', '321321321');
INSERT INTO `food_vendor` VALUES (5, '烧饼鸡', '回龙窝特色美食', '回龙窝', '789789789');

-- ----------------------------
-- Table structure for lodging_info
-- ----------------------------
DROP TABLE IF EXISTS `lodging_info`;
CREATE TABLE `lodging_info`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '民宿ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '民宿名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '民宿描述',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '民宿地址',
  `contact_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `price` decimal(10, 2) NULL DEFAULT NULL COMMENT '价格',
  `pic` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of lodging_info
-- ----------------------------
INSERT INTO `lodging_info` VALUES (1, '栖见∙云湖里', '位于市中心及云龙湖、回龙窝、戏马台、徐州博物馆等主要景区附近，出门不远处就是地铁一号线，交通十分便捷', '徐州市中心', '111222333', 300.00, '9f034700-fde4-4d45-afce-b5c919cd2c8b.png');
INSERT INTO `lodging_info` VALUES (2, '徐州茱萸养生谷度假木屋别墅', '徐州市贾汪区山水大道 8 号，建议自驾前往', '徐州市贾汪区山水大道 8 号', '222333444', 400.00, '86d22371-337e-48a0-ab9d-ffcb0ed947fd.png');
INSERT INTO `lodging_info` VALUES (3, '丰储街民宿', '位于丰储街，下楼就有共享电动车，离户部山地铁站 500 米左右，周边美食众多，临近苏宁广场、户部山等', '丰储街', '333444555', 500.00, '081b867d-43b6-467d-a784-6ff6696802fc.png');
INSERT INTO `lodging_info` VALUES (4, '回龙窝花间府・伴云亭民宿', '坐落于市中心的回龙窝历史文化街区，紧邻户部山、快哉亭公园及苏宁广场', '市中心的回龙窝历史文化街区', '444555666', 350.00, '552d791b-1905-4b22-bc81-87e12ffdc774.png');
INSERT INTO `lodging_info` VALUES (5, '一支百合智慧民宿（徐州铜山万达店）', '房间较大，都是智能家电，科技感满满，装修风格简约温馨。屋内空调、吹风机、24 小时热水等设施一应俱全，床品柔软舒适', '位于铜山区北京北路铜山万达广场 SOHO1 号楼', '555666777', 250.00, '0a409926-b22b-44f8-9d63-78af9abdb185.png');
INSERT INTO `lodging_info` VALUES (8, '陌上云居民宿', '白墙瓦黛的徽宿建筑风格，院内绿植茂密，繁花锦簇。有舒适大床房、标间、庭院套房、山景亲子房等多种房型可供选择，每个房间都是独立卫生间，24 小时热水供应，洗漱用品齐全，并配有新颖自助餐厅', '位于铜山区汉王镇紫山村竹坡故里 2 号，坐落在拔剑泉景区旁边', '555666777', 250.00, '72b0c84c-7e67-4da3-8cc0-e2c0c200d78f.png');

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `description` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL,
  `price` decimal(10, 2) NOT NULL,
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES (1, '宫保鸡丁', '经典川菜，香辣可口', 38.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (2, '鱼香肉丝', '酸甜适口，下饭神器', 32.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (3, '麻婆豆腐', '麻辣鲜香，回味无穷', 28.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (4, '清蒸鲈鱼', '鲜嫩美味，营养丰富', 68.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (5, '西红柿炒鸡蛋', '家常菜，老少皆宜', 20.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (6, '可乐鸡翅', '甜咸适中，老少皆宜', 35.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (7, '水煮牛肉', '麻辣鲜香，肉质嫩滑', 58.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (8, '蒜蓉西兰花', '清淡爽口，健康之选', 25.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (9, '红烧肉', '肥而不腻，入口即化', 45.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (10, '回锅肉', '川味经典，香气扑鼻', 40.00, '2024-12-30 14:20:11');
INSERT INTO `menu` VALUES (11, '香辣小龙虾', '麻辣鲜香，肉质Q弹', 88.00, '2024-12-30 15:08:06');
INSERT INTO `menu` VALUES (12, '清炒时蔬', '清淡爽口，时令蔬菜', 22.00, '2024-12-30 15:08:06');
INSERT INTO `menu` VALUES (13, '酸菜鱼', '酸辣开胃，鱼肉鲜嫩', 55.00, '2024-12-30 15:08:06');
INSERT INTO `menu` VALUES (14, '地三鲜', '东北家常菜，营养丰富', 30.00, '2024-12-30 15:08:06');
INSERT INTO `menu` VALUES (15, '糖醋里脊', '酸甜可口，外酥里嫩', 42.00, '2024-12-30 15:08:06');
INSERT INTO `menu` VALUES (16, '啤酒鸭', '香气扑鼻，肉质鲜美', 50.00, '2024-12-30 15:08:06');
INSERT INTO `menu` VALUES (17, '手撕包菜', '香辣爽脆，下饭神器', 26.00, '2024-12-30 15:08:06');
INSERT INTO `menu` VALUES (18, '干锅花菜', '香辣入味，口感丰富', 33.00, '2024-12-30 15:08:06');
INSERT INTO `menu` VALUES (19, '小炒黄牛肉', '香辣可口，牛肉嫩滑', 60.00, '2024-12-30 15:08:06');
INSERT INTO `menu` VALUES (20, '老鸭汤', '滋补养生，汤鲜味美', 48.00, '2024-12-30 15:08:06');

-- ----------------------------
-- Table structure for record
-- ----------------------------
DROP TABLE IF EXISTS `record`;
CREATE TABLE `record`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `scenicname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cretime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of record
-- ----------------------------
INSERT INTO `record` VALUES (60, 'admin', '云龙湖', '2024-12-07 13:33:00');
INSERT INTO `record` VALUES (61, 'admin', '徐州博物馆', '2024-12-07 13:33:02');
INSERT INTO `record` VALUES (62, 'admin', '徐州九顶山野生动物园', '2024-12-07 13:33:05');
INSERT INTO `record` VALUES (63, 'admin', '云龙湖', '2024-12-07 14:09:21');
INSERT INTO `record` VALUES (64, 'admin', '徐州博物馆', '2024-12-07 14:09:29');
INSERT INTO `record` VALUES (65, 'admin', '云龙湖', '2024-12-07 14:26:44');
INSERT INTO `record` VALUES (66, 'zs', '云龙湖', '2024-12-07 23:39:36');
INSERT INTO `record` VALUES (67, 'zs', '云龙湖', '2024-12-07 23:39:46');
INSERT INTO `record` VALUES (68, 'zs', '云龙湖', '2024-12-07 23:40:49');
INSERT INTO `record` VALUES (69, 'zs', '云龙湖', '2024-12-07 23:41:50');
INSERT INTO `record` VALUES (70, 'zs', '云龙湖', '2024-12-07 23:41:53');
INSERT INTO `record` VALUES (71, 'zs', '云龙湖', '2024-12-07 23:41:55');
INSERT INTO `record` VALUES (72, 'zs', '云龙湖', '2024-12-07 23:54:24');
INSERT INTO `record` VALUES (73, 'zs', '徐州汉文化景区', '2024-12-07 23:54:27');
INSERT INTO `record` VALUES (74, 'zs', '徐州博物馆', '2024-12-07 23:54:30');
INSERT INTO `record` VALUES (75, 'zs', '徐州九顶山野生动物园', '2024-12-07 23:57:00');
INSERT INTO `record` VALUES (76, 'zs', '云龙湖', '2024-12-08 01:45:52');
INSERT INTO `record` VALUES (77, 'admin', '云龙湖', '2024-12-08 04:22:29');
INSERT INTO `record` VALUES (78, 'zs', '云龙湖', '2024-12-08 04:38:51');
INSERT INTO `record` VALUES (79, 'zs', '云龙湖', '2024-12-08 04:40:14');
INSERT INTO `record` VALUES (80, 'zs', '云龙湖', '2024-12-08 04:40:16');
INSERT INTO `record` VALUES (81, 'zs', '云龙湖', '2024-12-08 04:40:59');
INSERT INTO `record` VALUES (82, 'zs', '云龙湖', '2024-12-08 04:41:53');
INSERT INTO `record` VALUES (83, 'zs', '云龙湖', '2024-12-08 04:42:43');
INSERT INTO `record` VALUES (84, 'zs', '云龙湖', '2024-12-08 04:42:49');
INSERT INTO `record` VALUES (85, 'zs', '云龙湖', '2024-12-08 04:42:53');
INSERT INTO `record` VALUES (86, 'zs', '云龙湖', '2024-12-08 04:43:09');
INSERT INTO `record` VALUES (87, 'zs', '云龙湖', '2024-12-08 04:44:21');
INSERT INTO `record` VALUES (88, 'zs', '云龙湖', '2024-12-08 04:44:26');
INSERT INTO `record` VALUES (89, 'zs', '云龙湖', '2024-12-08 04:45:25');
INSERT INTO `record` VALUES (90, 'zs', '云龙湖', '2024-12-08 04:46:23');
INSERT INTO `record` VALUES (91, 'zs', '云龙湖', '2024-12-08 04:51:47');
INSERT INTO `record` VALUES (92, 'zs', '徐州九顶山野生动物园', '2024-12-08 04:51:53');
INSERT INTO `record` VALUES (93, 'zs', '徐州九顶山野生动物园', '2024-12-08 04:51:57');
INSERT INTO `record` VALUES (94, 'zs', '徐州云龙湖苏轼纪念馆', '2024-12-08 04:51:59');
INSERT INTO `record` VALUES (95, 'zs', '云龙湖', '2024-12-10 17:38:11');
INSERT INTO `record` VALUES (96, 'admin', '徐州博物馆', '2024-12-10 18:15:00');
INSERT INTO `record` VALUES (97, 'zs', '云龙湖', '2024-12-17 10:08:47');
INSERT INTO `record` VALUES (98, 'zs', '云龙湖', '2024-12-17 10:09:51');
INSERT INTO `record` VALUES (99, 'zs', '云龙湖', '2024-12-17 10:16:07');
INSERT INTO `record` VALUES (100, 'zs', '云龙湖', '2024-12-17 10:24:05');
INSERT INTO `record` VALUES (101, 'zs', '云龙湖', '2024-12-17 10:35:32');
INSERT INTO `record` VALUES (102, 'zs', '徐州博物馆', '2024-12-17 10:50:50');
INSERT INTO `record` VALUES (103, 'zs', '徐州博物馆', '2024-12-17 10:51:01');
INSERT INTO `record` VALUES (104, 'zs', '云龙湖', '2024-12-17 10:51:35');
INSERT INTO `record` VALUES (105, 'zs', '徐州九顶山野生动物园', '2024-12-17 12:27:49');
INSERT INTO `record` VALUES (106, 'zs', '云龙湖', '2024-12-17 12:48:53');
INSERT INTO `record` VALUES (107, 'zs', '云龙湖', '2024-12-17 12:52:29');
INSERT INTO `record` VALUES (108, 'zs', '徐州汉文化景区', '2024-12-17 12:54:06');
INSERT INTO `record` VALUES (109, 'zs', '云龙湖', '2024-12-17 13:17:20');
INSERT INTO `record` VALUES (110, 'zs', '云龙湖', '2024-12-17 13:17:34');
INSERT INTO `record` VALUES (111, 'admin', '云龙湖', '2024-12-17 13:22:54');
INSERT INTO `record` VALUES (112, 'admin', '云龙湖', '2024-12-17 13:23:01');

-- ----------------------------
-- Table structure for scenic_news
-- ----------------------------
DROP TABLE IF EXISTS `scenic_news`;
CREATE TABLE `scenic_news`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '新闻ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '新闻标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '新闻内容',
  `pic` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of scenic_news
-- ----------------------------
INSERT INTO `scenic_news` VALUES (1, '云龙湖111', '徐州市云龙湖风景名胜区管理委员会为市政府派出机构，对云龙湖景区统一行使规划、建设、保护和管理职能。云龙湖旅游景区位于徐州市区西南部，距离市中心3公里，是以云龙山水自然景观为特色，以两汉文化、名士文化、宗教文化、军事文化为主要内容，集科普、观光、游览、休闲、生态等综合功能为一体的城市型旅游景区。', '10ae3b34-62a5-47e0-a41b-b7e0a67246be.png');
INSERT INTO `scenic_news` VALUES (2, '徐州市云龙湖风景区苏公岛', '漫步在纪念馆中，心底涌起对苏轼的思念与敬仰之情。在这里，你能感受到苏轼的才情与担当；在这里，可以触摸到历史的温度，领略古人的智慧。', '0bd95205-208b-477d-b772-fd801540a1d7.png');
INSERT INTO `scenic_news` VALUES (8, '1', '11111', '2f070724-f884-4607-8234-130a319f3c79.png');

-- ----------------------------
-- Table structure for scenic_rating
-- ----------------------------
DROP TABLE IF EXISTS `scenic_rating`;
CREATE TABLE `scenic_rating`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '评分ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户姓名',
  `spot_id` int NULL DEFAULT NULL COMMENT '景点ID',
  `spot_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '景点名称',
  `rating` int NULL DEFAULT NULL COMMENT '评分（1-5）',
  `review` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '评论内容',
  `rating_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '评分时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of scenic_rating
-- ----------------------------
INSERT INTO `scenic_rating` VALUES (1, 1, 'john_doe', 1, '彭城风华', 5, '非常壮观，值得一去！', '2024-12-05 20:12:26');
INSERT INTO `scenic_rating` VALUES (2, 2, 'jane_smith', 2, '云龙山', 4, '景色不错，但爬山有点累。', '2024-12-05 20:12:26');
INSERT INTO `scenic_rating` VALUES (3, 3, 'alice_wang', 3, '徐州博物院', 5, '文化气息浓厚，非常喜欢。', '2024-12-05 20:12:26');
INSERT INTO `scenic_rating` VALUES (4, 4, 'bob_zhang', 4, '云龙湖', 5, '云龙湖的景色如诗如画。', '2024-12-05 20:12:26');
INSERT INTO `scenic_rating` VALUES (5, 5, 'charlie_li', 5, '龟山汉墓', 5, '文化气息浓厚', '2024-12-05 20:12:26');
INSERT INTO `scenic_rating` VALUES (7, 1, 'admin', 1, '徐州海洋馆', 4, '我来评分啦', '2024-12-06 16:20:13');
INSERT INTO `scenic_rating` VALUES (8, 2, 'zs', 1, '徐州乐园', 5, '张三的评分', '2024-12-06 16:20:47');
INSERT INTO `scenic_rating` VALUES (9, 1, 'admin', 3, '徐州博物院', 4, '好耍', '2024-12-07 12:25:16');
INSERT INTO `scenic_rating` VALUES (10, 2, 'zs', 1, '云龙湖', 5, '真好看\r\n', '2024-12-07 23:39:46');
INSERT INTO `scenic_rating` VALUES (11, 10, 'zs', 3, '徐州博物馆', 5, '42\r\n', '2024-12-17 10:51:01');
INSERT INTO `scenic_rating` VALUES (13, 10, 'zs', 1, '云龙湖', 3, '12', '2024-12-28 16:55:39');
INSERT INTO `scenic_rating` VALUES (14, 10, 'zs', 2, '徐州汉文化景区', 3, '12', '2024-12-28 16:55:49');

-- ----------------------------
-- Table structure for scenic_share
-- ----------------------------
DROP TABLE IF EXISTS `scenic_share`;
CREATE TABLE `scenic_share`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '分享ID',
  `user_id` int NULL DEFAULT NULL COMMENT '用户ID',
  `user_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户姓名',
  `spot_id` int NULL DEFAULT NULL COMMENT '景点ID',
  `spot_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '景点名称',
  `share_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '分享内容',
  `share_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '分享时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of scenic_share
-- ----------------------------
INSERT INTO `scenic_share` VALUES (1, 1, 'john_doe', 1, '彭城风华', '喷泉很壮观', '2024-12-05 20:12:20');
INSERT INTO `scenic_share` VALUES (2, 2, 'jane_smith', 2, '云龙山', '景色不错，但爬山有点累。', '2024-12-05 20:12:20');
INSERT INTO `scenic_share` VALUES (3, 3, 'alice_wang', 3, '徐州博物院', '文化气息浓厚，非常喜欢。', '2024-12-05 20:12:20');
INSERT INTO `scenic_share` VALUES (4, 4, 'bob_zhang', 4, '云龙湖', '云龙湖的风景如画，尤其适合拍照。', '2024-12-05 20:12:20');
INSERT INTO `scenic_share` VALUES (5, 5, 'charlie_li', 5, '龟山汉墓', '文化气息浓厚，强烈推荐！', '2024-12-05 20:12:20');
INSERT INTO `scenic_share` VALUES (9, 1, 'admin', 1, '徐州乐园', '333', '2024-12-06 16:13:24');
INSERT INTO `scenic_share` VALUES (11, 1, 'admin', 3, '徐州海洋馆', '我喜欢来这里，欢迎到来', '2024-12-07 12:24:48');
INSERT INTO `scenic_share` VALUES (12, 2, 'zs', 1, '徐州乐园', '11111', '2024-12-07 13:06:15');
INSERT INTO `scenic_share` VALUES (13, 2, 'zs', 1, '云龙湖', '1111', '2024-12-07 23:41:53');
INSERT INTO `scenic_share` VALUES (14, NULL, 'add', NULL, 'adda', 'dada', '2024-12-31 10:46:11');
INSERT INTO `scenic_share` VALUES (15, NULL, 'hnbn', NULL, 'jkhkj', 'hjkk', '2024-12-31 10:50:59');
INSERT INTO `scenic_share` VALUES (19, NULL, 'AX', NULL, 'ax', 'adxs', '2025-01-01 03:36:26');
INSERT INTO `scenic_share` VALUES (20, NULL, 'ad', NULL, 'add', 'ad', '2025-01-01 03:44:28');
INSERT INTO `scenic_share` VALUES (22, 10, 'zs', NULL, NULL, NULL, '2025-01-01 16:11:36');

-- ----------------------------
-- Table structure for scenic_spot
-- ----------------------------
DROP TABLE IF EXISTS `scenic_spot`;
CREATE TABLE `scenic_spot`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '景点ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '景点名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '景点描述',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '景点位置',
  `opening_hours` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '开放时间',
  `ticket_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '门票价格',
  `contact_info` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `pic` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图片',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of scenic_spot
-- ----------------------------
INSERT INTO `scenic_spot` VALUES (1, '云龙湖', '景区景点与人文景观：原名“石狗湖” ，最早形成于北宋。云龙湖东靠云龙山，西依韩山、天齐山。南偎泉山、珠山。三面环山，一面临城。是徐州市区内的一个大型湖泊，湖水清澈，周围有许多公园和游乐设施，适合休闲和娱乐。', '江苏省徐州市云龙湖湖中路1号', '08:00-20:00', 0.00, '123456789', '2024-12-05 20:12:20', '05845755-265d-4f18-abc1-a44653459125.png');
INSERT INTO `scenic_spot` VALUES (2, '徐州汉文化景区', '整个景区东起三环路，南至陇海线，西接京沪线，北迄骆驼山，是集历史博览、园林景观、旅游休闲于一体的汉文化保护基地和精品旅游景区。徐州汉文化景区占地面积1400亩，徐州汉文化景区呈现为一部立体的汉代史，成为集“两汉三绝”为一体、国内最大的汉文化主题公园和国家4A级精品文化旅游区。', '徐州市云龙区东三环兵马俑路1号', '07:00-19:00', 40.00, '987654321', '2024-12-05 20:12:20', '4f01a61e-6ee8-471e-adf5-09783cdb1e0e.png');
INSERT INTO `scenic_spot` VALUES (3, '徐州博物馆', '景区景点与人文景观：坐落在云龙山北麓，历经三次改扩建，由陈列主楼、土山东汉彭城王墓、汉代采石场遗址、乾隆行宫及碑园四个展区组成。占地面积33000平方米，建筑面积12000平方米，展厅面积3000余平方米。并配有书吧、咖啡吧、纪念品商店等休闲服务区。', '江苏省徐州市云龙区和平路101号', '09:00-17:00', 60.00, '123123123', '2024-12-05 20:12:20', 'd11c22cb-e59b-482e-a602-458364e93625.png');
INSERT INTO `scenic_spot` VALUES (4, ' 九里山', '景区景点与人文景观：九里山又名九凝山，海拔134米，面积百余公顷，因东西长九里而得名。九里山每座山头随物象形，自西向东依次为象山、宝峰山等，支麓有大孤山、小孤山、沙孤山、虎山、小龟山、看花山、杨家山、江家山和琵琶山等。以东端的琵琶山景色最佳，因山形酷似琵琶而得名。', '中国江苏省徐州市鼓楼区', '全天开放', 0.00, '456456456', '2024-12-05 20:12:20', 'd84c8574-0554-4ae5-adef-bb8b64283fe1.png');
INSERT INTO `scenic_spot` VALUES (5, '徐州九顶山野生动物园', '景区景点与人文景观：园区总投资20亿元，占地3400亩，计划展出世界各地濒危珍稀野生动物近两万头（只）。作为淮海经济区内最大的动物主题文旅项目，徐州九顶山野生动物园依托丰富的山水资源规划建设，打造出集野生动物观赏、国际马戏演艺、亲子游乐互动、主题酒店体验、休闲观光度假、科普研学教育为一体的沉浸式综合度假区。', '徐州市睢宁县岚山镇陈集村', '全天开放', 100.00, '789789789', '2024-12-05 20:12:20', 'c91f43f9-ea85-4f58-8ebe-483076e15b01.png');
INSERT INTO `scenic_spot` VALUES (6, '徐州云龙湖苏轼纪念馆', '苏轼纪念馆坐落在徐州市云龙湖风景区苏公岛上，主体为仿宋建筑，苏轼纪念馆以苏轼任徐州知州期间(1077年4月—1079年3月)理政业绩、文化业绩为主要内容，揭示了“清官苏轼”、“文豪苏轼”的精神特质，充分展示出苏轼忠君爱民的“为官一任、造福一方”的历史功绩，进而唤起思念、敬仰、见贤思齐之情。', '徐州市云龙湖风景区苏公岛', '08:00-20:00', 20.00, '12134', '2024-12-07 13:31:19', '30f134d7-6696-4a6a-9762-7a5e91a91e0a.png');
INSERT INTO `scenic_spot` VALUES (11, '龟山汉墓', '龟山汉墓为两座并列相通的夫妻合葬墓，其中南为楚王襄王刘注墓，北为其夫人墓，两墓均为横穴崖洞式。墓葬开口处于龟山西麓，呈喇叭形状，有南北两墓道，墓室由人工开凿而成。', '江苏省徐州市鼓楼区襄王北路3号', '08：00-19：00', 80.00, '852662', '2024-12-30 17:05:19', 'f8f9c49d-3fae-4fd9-b2bd-b8520bb27363.png');

-- ----------------------------
-- Table structure for tour_route
-- ----------------------------
DROP TABLE IF EXISTS `tour_route`;
CREATE TABLE `tour_route`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '路线ID',
  `route_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路线名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '路线描述',
  `total_duration` decimal(5, 2) NULL DEFAULT NULL COMMENT '总时长(小时)',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '旅游路线表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tour_route
-- ----------------------------
INSERT INTO `tour_route` VALUES (1, '自然与人文融合游', '第一天\n上午：徐州九顶山野生动物园，与可爱的动物们来一场亲密接触，观看动物表演。\n下午：云龙湖，沿着湖岸线散步，欣赏湖光山色，可在湖边的草地上野餐。\n第二天\n上午：九里山，探寻古战场遗迹，想象楚汉相争时的激烈场景，感受历史的沧桑。\n下午：继续在九里山附近的山林中漫步，呼吸新鲜空气，感受大自然的宁静。', NULL, '2024-12-28 21:58:48', '2024-12-31 09:40:33');
INSERT INTO `tour_route` VALUES (2, '历史文化深度游', '第一天\n上午：徐州汉文化景区，参观楚王陵、汉兵马俑等，感受汉代帝王陵墓的壮观和汉代军事文化。\n下午：徐州博物馆，观赏金缕玉衣、汉代玉器、陶俑等珍贵文物，全面了解徐州的历史。\n第二天\n上午：龟山汉墓，探究独特的墓葬结构和精妙的排水系统，领略汉代的建筑智慧。\n下午：徐州云龙湖苏轼纪念馆，了解苏轼在徐州抗洪、筑堤等政绩，欣赏苏轼的诗词书法。', NULL, '2024-12-28 22:02:47', '2024-12-31 09:39:30');
INSERT INTO `tour_route` VALUES (3, '文化艺术鉴赏游', '第一天\n上午：徐州云龙湖苏轼纪念馆，沉浸在苏轼的文学艺术世界里，欣赏苏轼相关的书画作品。\n下午：徐州博物馆，重点参观书画展厅，欣赏徐州地区出土和收藏的古代书画。\n第二天\n上午：徐州汉文化景区，欣赏汉画像石上精美的雕刻艺术，了解汉代的社会生活和信仰。\n下午：在云龙湖附近的艺术街区逛逛，看看当地艺术家的作品，感受艺术氛围。', NULL, '2024-12-31 09:41:24', '2024-12-31 09:41:24');
INSERT INTO `tour_route` VALUES (4, '亲子欢乐游', '第一天\n上午：徐州九顶山野生动物园，带着孩子认识各种动物，体验亲子互动项目。\n下午：云龙湖沙滩浴场，让孩子在沙滩上玩耍，在湖边浅水区嬉戏。\n第二天\n上午：徐州汉文化景区，通过参观汉兵马俑等，让孩子了解历史文化，有儿童导览服务。\n下午：在云龙湖周边的儿童游乐区，如小型游乐场等，让孩子尽情玩耍。', NULL, '2024-12-31 09:42:45', '2024-12-31 09:42:45');
INSERT INTO `tour_route` VALUES (5, '休闲养生游', '第一天\n上午：云龙湖，选择在湖边的茶馆或咖啡馆，享受悠闲的上午时光，欣赏湖景。\n下午：沿着云龙湖的健身步道散步或慢跑，呼吸清新空气，锻炼身体。\n第二天\n上午：九里山，在山中的林间小道漫步，感受大自然的宁静，可进行简单的瑜伽或冥想。\n下午：在九里山附近的温泉浴场泡温泉，放松身心，缓解疲劳。', NULL, '2024-12-31 09:43:17', '2024-12-31 09:43:17');
INSERT INTO `tour_route` VALUES (6, '民俗风情游', '第一天\n上午：徐州汉文化景区，了解汉代的民俗文化，如祭祀、服饰等。\n下午：在徐州老城区寻找传统的徐州美食，如徐州地锅鸡、饣它（shá）汤等，感受徐州的饮食文化。\n第二天\n上午：云龙湖周边的民俗文化村（如果有），体验徐州本地的手工艺品制作，如剪纸、陶艺等。\n下午：在云龙湖附近的传统集市逛逛，购买一些具有徐州特色的纪念品。', NULL, '2024-12-31 09:44:02', '2024-12-31 09:44:02');
INSERT INTO `tour_route` VALUES (7, '古迹探秘游', '第一天\n上午：龟山汉墓，深入研究墓葬的建筑结构、石刻铭文等，探寻汉代贵族的丧葬文化。\n下午：徐州汉文化景区，对比不同汉代陵墓的特点，寻找更多关于汉代古迹的线索。\n第二天\n上午：九里山古战场遗址，寻找古代战争留下的遗迹，如烽火台、堡垒等。\n下午：在云龙湖周边的古籍书店或文化研究机构，查阅与徐州古迹相关的资料，深入了解徐州的历史古迹。', NULL, '2024-12-31 09:44:42', '2024-12-31 09:44:42');

-- ----------------------------
-- Table structure for tour_route_spot
-- ----------------------------
DROP TABLE IF EXISTS `tour_route_spot`;
CREATE TABLE `tour_route_spot`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `route_id` int NOT NULL COMMENT '路线ID',
  `spot_id` int NOT NULL COMMENT '景点ID',
  `order_num` int NOT NULL COMMENT '排序号',
  `visit_duration` decimal(4, 1) NULL DEFAULT 2.0 COMMENT '建议游玩时长(小时)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注说明',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_route_id`(`route_id` ASC) USING BTREE,
  INDEX `idx_spot_id`(`spot_id` ASC) USING BTREE,
  CONSTRAINT `fk_route_spot_route` FOREIGN KEY (`route_id`) REFERENCES `tour_route` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_route_spot_scenic` FOREIGN KEY (`spot_id`) REFERENCES `scenic_spot` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '路线景点关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tour_route_spot
-- ----------------------------
INSERT INTO `tour_route_spot` VALUES (4, 2, 2, 1, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (5, 2, 3, 2, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (6, 2, 11, 3, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (7, 2, 6, 4, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (8, 1, 5, 1, 2.0, NULL);
INSERT INTO `tour_route_spot` VALUES (9, 1, 1, 2, 2.0, NULL);
INSERT INTO `tour_route_spot` VALUES (10, 1, 4, 3, 3.0, NULL);
INSERT INTO `tour_route_spot` VALUES (11, 3, 6, 1, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (12, 3, 3, 2, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (13, 3, 2, 3, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (14, 3, 1, 4, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (15, 4, 5, 1, 2.0, NULL);
INSERT INTO `tour_route_spot` VALUES (16, 4, 1, 2, 2.0, NULL);
INSERT INTO `tour_route_spot` VALUES (17, 4, 2, 3, 2.0, NULL);
INSERT INTO `tour_route_spot` VALUES (18, 5, 1, 1, 2.0, NULL);
INSERT INTO `tour_route_spot` VALUES (19, 5, 4, 2, 2.0, NULL);
INSERT INTO `tour_route_spot` VALUES (20, 6, 2, 1, 2.0, NULL);
INSERT INTO `tour_route_spot` VALUES (21, 6, 1, 2, 2.0, NULL);
INSERT INTO `tour_route_spot` VALUES (22, 7, 11, 1, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (23, 7, 2, 2, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (24, 7, 4, 3, 1.5, NULL);
INSERT INTO `tour_route_spot` VALUES (25, 7, 1, 4, 1.5, NULL);

-- ----------------------------
-- Table structure for tourist_consultation
-- ----------------------------
DROP TABLE IF EXISTS `tourist_consultation`;
CREATE TABLE `tourist_consultation`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '咨询ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '咨询内容',
  `response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '回复内容',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tourist_consultation
-- ----------------------------
INSERT INTO `tourist_consultation` VALUES (1, '请问徐州博物馆的开放时间是什么？', '开放时间为08:00-20:00。');
INSERT INTO `tourist_consultation` VALUES (2, '徐州博物迎附近有什么好吃的？', '有很多地道的餐馆，推荐烧烤。');
INSERT INTO `tourist_consultation` VALUES (4, '云龙湖的游船有没有推荐？', '建议选择游船公司，服务很好。');
INSERT INTO `tourist_consultation` VALUES (5, '九里山的最佳登山时间是什么？', '建议春秋季节，气候适宜。');
INSERT INTO `tourist_consultation` VALUES (7, '124233121321321', NULL);

-- ----------------------------
-- Table structure for tourist_route
-- ----------------------------
DROP TABLE IF EXISTS `tourist_route`;
CREATE TABLE `tourist_route`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '路线ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路线名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '路线描述',
  `spots` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '途经景点（景点ID数组）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tourist_route
-- ----------------------------
INSERT INTO `tourist_route` VALUES (1, '历史文化探索之旅', '从徐州汉文化景区出发，感受汉代文化的博大精深，接着前往徐州博物馆，深入了解徐州的历史变迁，最后来到徐州云龙湖苏轼纪念馆，体会苏轼与徐州的渊源。', '2,3,6');
INSERT INTO `tourist_route` VALUES (2, '自然风光赏玩之旅', '先前往九里山，感受其壮丽的山川景色，随后前往云龙湖，欣赏湖光山色。', '4,1');
INSERT INTO `tourist_route` VALUES (3, '亲子欢乐游', '以徐州九顶山野生动物园为核心，让孩子们近距离接触各类野生动物，感受大自然的魅力。', '5');
INSERT INTO `tourist_route` VALUES (4, '文化与自然结合之旅', '从徐州汉文化景区开始，领略汉代文化，之后前往云龙湖，在自然风光中放松身心。', '2,1');
INSERT INTO `tourist_route` VALUES (5, '全方位徐州游', '依次游览徐州汉文化景区、徐州博物馆、九里山、徐州九顶山野生动物园和徐州云龙湖苏轼纪念馆，全面感受徐州的历史、文化和自然风貌。', '1,2,3,4,5,6');
INSERT INTO `tourist_route` VALUES (7, '123', '123', '2.3');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `role` int NOT NULL COMMENT '用户角色（1为游客，2为管理员,3为商家）',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', '$2a$10$2.6maXsi.fjOSGaMLOjXuOmxjvuKPPU7mvkwjYjJGB/eRScrHGPtC', 1, 'admin@example.com', '12345');
INSERT INTO `user` VALUES (2, 'vendor', '$2a$10$2.6maXsi.fjOSGaMLOjXuOmxjvuKPPU7mvkwjYjJGB/eRScrHGPtC', 3, 'admin@example.com', '12345');
INSERT INTO `user` VALUES (6, 'ls', '$2a$10$oEwiL1GdHoO8/8qd86ecPemMfAfTxagFUH/J/z6rDVPCEEMu8Miby', 3, '22@qq.com', '22');
INSERT INTO `user` VALUES (9, 'zx', '123', 2, '142@qq.com', '1223');
INSERT INTO `user` VALUES (10, 'zs', '$2a$10$NL7kTGBzn/AH2lLQ0sWF/uwULZYsC1fE0Yp/cDbeffIVqVSvCicge', 2, '123@qq.com', '12451111');
INSERT INTO `user` VALUES (11, 'ljj', '$2a$10$MXqZYPFvQzu3aLvHuXQhV.e8I0nb1nD.bzNxYcEQUdi3BIb9dUqBm', 1, '123@123', '123');
INSERT INTO `user` VALUES (12, 'as', '123', 2, NULL, NULL);
INSERT INTO `user` VALUES (16, '666', '$2a$10$BZ3.K9JAfkB79UpX/NZb3eD81l3ATphfpJoMUDUWSKlFAbgrt2Zgy', 1, '666', '666');
INSERT INTO `user` VALUES (17, 'Julie Daniels', 'x2VEeAbpko', 999, 'dj15@yahoo.com', '28-355-2367');
INSERT INTO `user` VALUES (18, 'Saito Yuto', 'jka3mvOOLJ', 358, 'yutosaito@gmail.com', '760-9006-8193');
INSERT INTO `user` VALUES (19, 'Jacob Hamilton', 'KFDWGcB4pT', 305, 'hamjaco@outlook.com', '312-577-9859');
INSERT INTO `user` VALUES (20, 'Helen Silva', 'xhSU1Ae8qz', 341, 'helen89@icloud.com', '160-8763-4409');
INSERT INTO `user` VALUES (21, 'Chiang Ka Man', 'O8izIAXUht', 450, 'kaman4@hotmail.com', '10-779-6576');
INSERT INTO `user` VALUES (22, 'Jeremy Gray', 'qB3XQaTqFs', 255, 'jeremygr1982@icloud.com', '718-250-4329');
INSERT INTO `user` VALUES (23, 'Liu Jiehong', '40kFPTqfR5', 777, 'jli@outlook.com', '140-2444-4992');
INSERT INTO `user` VALUES (24, 'Lo Fu Shing', 'zcnnwC90EZ', 973, 'fushingl41@gmail.com', '755-601-3208');
INSERT INTO `user` VALUES (25, 'James Romero', '4HF9IQJDg1', 625, 'romejame@yahoo.com', '(1223) 36 6270');
INSERT INTO `user` VALUES (26, 'Che Ting Fung', '5e66FFlLhw', 142, 'chtingfung07@icloud.com', '769-9998-7990');
INSERT INTO `user` VALUES (27, '111', '$2a$10$qv2Nd0LA37VM2tmTzVuxJOwjsQ14tIjqJrcCQSZ24DX9A.NsQYy6u', 3, '111', '111');
INSERT INTO `user` VALUES (28, '1', '$2a$10$u4/7Em6txHwo6bLmzII7G.U8dD/gJdJytxiqoMnTW64ImZYsEUQGK', 1, '1@666', '123');
INSERT INTO `user` VALUES (29, '2', '$2a$10$xT4wO9KOXeZHxUrDIPFur.1ADu071PUVX5x5OLMXKyy8EeTdL/uKa', 2, '2@555', '123');
INSERT INTO `user` VALUES (30, '3', '$2a$10$WNR3Th8Yvz3D/NDOoNa9geFz4QvektWvuqS9LgK8/kBb5kJAr73LW', 3, '3@777', '123');
INSERT INTO `user` VALUES (31, 'wh', '$2a$10$AkRuMaC7rPsd/8EcwAu0vulKVWETeKgFBqFkplG5r1FdtKn53YvCy', 2, '111@qq.com', '111');
INSERT INTO `user` VALUES (32, 'wh1', '$2a$10$A/7JEyWUdSlgyvYOh2MHc.rlW6NWksGELprYsyIHXmZpNig5sRp0.', 1, '111@qq.com', '111');
INSERT INTO `user` VALUES (33, 'whdsb', '$2a$10$or81P/tkrDk.L5gWjDrOyePUVYio0QF/zCvO1AN7SuElDpiRl3eDu', 3, NULL, NULL);

-- ----------------------------
-- Table structure for user_route
-- ----------------------------
DROP TABLE IF EXISTS `user_route`;
CREATE TABLE `user_route`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `user_id` int NOT NULL COMMENT '用户ID',
  `route_id` int NOT NULL COMMENT '路线ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_id`(`user_id` ASC) USING BTREE COMMENT '用户ID唯一索引',
  INDEX `idx_route_id`(`route_id` ASC) USING BTREE COMMENT '路线ID索引'
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户路线选择表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_route
-- ----------------------------
INSERT INTO `user_route` VALUES (1, 10, 2, '2024-12-29 00:50:22', '2024-12-29 00:51:55');
INSERT INTO `user_route` VALUES (2, 29, 5, '2024-12-31 10:07:08', '2024-12-31 10:09:53');

SET FOREIGN_KEY_CHECKS = 1;
