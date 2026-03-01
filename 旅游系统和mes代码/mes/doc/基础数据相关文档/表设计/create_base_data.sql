-- 1. 计量单位表
CREATE TABLE unit (
  id BIGINT NOT NULL PRIMARY KEY COMMENT '单位编号',
  code VARCHAR(50) NOT NULL UNIQUE COMMENT '单位编码',
  name VARCHAR(100) NOT NULL COMMENT '单位名称',
  description TEXT COMMENT '单位描述',
  is_main_unit TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否主单位(0:否,1:是)',
  main_unit_id BIGINT COMMENT '主单位编号',
  conversion_ratio DECIMAL(10,4) COMMENT '换算比例',
  status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int default '0' comment'删除标记'
) COMMENT='计量单位表';

-- 计量单位表模拟数据
INSERT INTO unit (id, code, name, description, is_main_unit, main_unit_id, conversion_ratio, status) VALUES
(1, 'UNIT001', '件', '基本单位-件', 1, NULL, 1.0000, 1),
(2, 'UNIT002', '箱', '箱装单位', 0, 1, 12.0000, 1),
(3, 'UNIT003', '包', '包装单位', 0, 1, 24.0000, 1),
(4, 'UNIT004', '千克', '重量单位', 1, NULL, 1.0000, 1),
(5, 'UNIT005', '克', '小重量单位', 0, 4, 0.0010, 1),
(6, 'UNIT006', '吨', '大重量单位', 0, 4, 1000.0000, 1),
(7, 'UNIT007', '米', '长度单位', 1, NULL, 1.0000, 1),
(8, 'UNIT008', '厘米', '小长度单位', 0, 7, 0.0100, 1),
(9, 'UNIT009', '毫米', '微长度单位', 0, 7, 0.0010, 1),
(10, 'UNIT010', '升', '容积单位', 1, NULL, 1.0000, 1),
(11, 'UNIT011', '毫升', '小容积单位', 0, 10, 0.0010, 1),
(12, 'UNIT012', '打', '打装单位', 0, 1, 12.0000, 1);

-- 2. 物料分类表
CREATE TABLE material_category (
  id BIGINT NOT NULL PRIMARY KEY COMMENT '分类编号',
  code VARCHAR(50) NOT NULL UNIQUE COMMENT '分类编码',
  name VARCHAR(100) NOT NULL COMMENT '分类名称',
  parent_id BIGINT COMMENT '上级分类编号',
  description TEXT COMMENT '分类描述',
  status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int default '0' comment'删除标记'
) COMMENT='物料分类表';

-- 物料分类表模拟数据
INSERT INTO material_category (id, code, name, parent_id, description, status) VALUES
(1, 'CAT001', '原材料', NULL, '生产所需原材料', 1),
(2, 'CAT002', '半成品', NULL, '加工中的半成品', 1),
(3, 'CAT003', '成品', NULL, '已完成的成品', 1),
(4, 'CAT004', '电子元件', 1, '电子类原材料', 1),
(5, 'CAT005', '机械零件', 1, '机械类原材料', 1),
(6, 'CAT006', '化工原料', 1, '化工类原材料', 1),
(7, 'CAT007', '包装材料', 1, '包装类材料', 1),
(8, 'CAT008', '加工半成品', 2, '正在加工的半成品', 1),
(9, 'CAT009', '组装半成品', 2, '正在组装的半成品', 1),
(10, 'CAT010', '消费类产品', 3, '面向消费者的产品', 1),
(11, 'CAT011', '工业产品', 3, '面向工业客户的产品', 1),
(12, 'CAT012', '配件', 1, '各种配件', 1);

-- 3. 客户表
CREATE TABLE customer (
  id BIGINT NOT NULL PRIMARY KEY COMMENT '客户编号',
  code VARCHAR(50) NOT NULL UNIQUE COMMENT '客户编码',
  name VARCHAR(100) NOT NULL COMMENT '客户名称',
  address VARCHAR(200) COMMENT '客户地址',
  contact_person VARCHAR(50) COMMENT '客户联系人',
  phone VARCHAR(20) COMMENT '客户电话',
  fax VARCHAR(20) COMMENT '客户传真',
  email VARCHAR(100) COMMENT '客户邮箱',
  description TEXT COMMENT '客户描述',
  status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int default '0' comment'删除标记'
) COMMENT='客户表';

-- 客户表模拟数据
INSERT INTO customer (id, code, name, address, contact_person, phone, fax, email, description, status) VALUES
(1, 'CUST001', '华为技术有限公司', '深圳市龙岗区华为总部', '张经理', '0755-12345678', '0755-87654321', 'zhang@huawei.com', '重要客户', 1),
(2, 'CUST002', '小米科技有限公司', '北京市海淀区小米科技园', '李经理', '010-23456789', '010-98765432', 'li@xiaomi.com', '长期合作伙伴', 1),
(3, 'CUST003', '阿里巴巴集团', '杭州市西湖区阿里巴巴西溪园区', '王经理', '0571-34567890', '0571-87654321', 'wang@alibaba.com', '电商平台客户', 1),
(4, 'CUST004', '腾讯科技有限公司', '深圳市南山区腾讯大厦', '赵经理', '0755-45678901', '0755-76543210', 'zhao@tencent.com', '互联网客户', 1),
(5, 'CUST005', '百度在线网络技术有限公司', '北京市海淀区百度大厦', '陈经理', '010-56789012', '010-65432109', 'chen@baidu.com', '搜索业务客户', 1),
(6, 'CUST006', '京东集团', '北京市亦庄经济技术开发区京东总部', '刘经理', '010-67890123', '010-54321098', 'liu@jd.com', '电商客户', 1),
(7, 'CUST007', '字节跳动有限公司', '北京市海淀区字节跳动大厦', '杨经理', '010-78901234', '010-43210987', 'yang@bytedance.com', '新媒体客户', 1),
(8, 'CUST008', '美团', '北京市朝阳区美团总部', '黄经理', '010-89012345', '010-32109876', 'huang@meituan.com', '生活服务客户', 1),
(9, 'CUST009', '拼多多', '上海市黄浦区拼多多大厦', '周经理', '021-90123456', '021-21098765', 'zhou@pinduoduo.com', '团购客户', 1),
(10, 'CUST010', '顺丰速运', '深圳市福田区顺丰总部', '吴经理', '0755-01234567', '0755-10987654', 'wu@sf-express.com', '物流客户', 1),
(11, 'CUST011', '中国中车集团', '北京市朝阳区中车大厦', '郑经理', '010-12345678', '010-87654321', 'zheng@crrc.com', '轨道交通客户', 1),
(12, 'CUST012', '国家电网公司', '北京市西城区国家电网总部', '孙经理', '010-23456789', '010-76543210', 'sun@sgcc.com', '能源客户', 1);

-- 4. 供应商表
CREATE TABLE supplier (
  id BIGINT NOT NULL PRIMARY KEY COMMENT '供应商编号',
  code VARCHAR(50) NOT NULL UNIQUE COMMENT '供应商编码',
  name VARCHAR(100) NOT NULL COMMENT '供应商名称',
  address VARCHAR(200) COMMENT '供应商地址',
  contact_person VARCHAR(50) COMMENT '供应商联系人',
  phone VARCHAR(20) COMMENT '供应商电话',
  fax VARCHAR(20) COMMENT '供应商传真',
  email VARCHAR(100) COMMENT '供应商邮箱',
  description TEXT COMMENT '供应商描述',
  status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int default '0' comment'删除标记'
) COMMENT='供应商表';

-- 供应商表模拟数据
INSERT INTO supplier (id, code, name, address, contact_person, phone, fax, email, description, status) VALUES
(1, 'SUPP001', '富士康科技集团', '深圳市宝安区富士康科技园', '张经理', '0755-11111111', '0755-22222222', 'zhang@foxconn.com', '电子产品代工供应商', 1),
(2, 'SUPP002', '比亚迪股份有限公司', '深圳市坪山区比亚迪工业园', '李经理', '0755-33333333', '0755-44444444', 'li@byd.com', '新能源产品供应商', 1),
(3, 'SUPP003', '宁德时代新能源科技股份有限公司', '福建省宁德市宁德时代总部', '王经理', '0593-55555555', '0593-66666666', 'wang@catl.com', '电池供应商', 1),
(4, 'SUPP004', '立讯精密工业股份有限公司', '广东省东莞市立讯产业园', '赵经理', '0769-77777777', '0769-88888888', 'zhao@luxshare-ict.com', '连接器供应商', 1),
(5, 'SUPP005', '京东方科技集团股份有限公司', '北京市朝阳区京东方总部', '陈经理', '010-99999999', '010-00000000', 'chen@boe.com', '显示屏供应商', 1),
(6, 'SUPP006', '海康威视数字技术股份有限公司', '杭州市滨江区海康威视总部', '刘经理', '0571-11111111', '0571-22222222', 'liu@hikvision.com', '安防设备供应商', 1),
(7, 'SUPP007', '大疆创新科技有限公司', '深圳市南山区大疆总部', '杨经理', '0755-33334444', '0755-55556666', 'yang@dji.com', '无人机供应商', 1),
(8, 'SUPP008', '格力电器股份有限公司', '珠海市香洲区格力总部', '黄经理', '0756-77778888', '0756-99990000', 'huang@gree.com', '空调设备供应商', 1),
(9, 'SUPP009', '美的集团股份有限公司', '佛山市顺德区美的总部', '周经理', '0757-11112222', '0757-33334444', 'zhou@midea.com', '家电供应商', 1),
(10, 'SUPP010', '海尔集团公司', '青岛市崂山区海尔总部', '吴经理', '0532-55556666', '0532-77778888', 'wu@haier.com', '家电供应商', 1),
(11, 'SUPP011', '联想集团有限公司', '北京市海淀区联想总部', '郑经理', '010-11113333', '010-22224444', 'zheng@lenovo.com', '电脑设备供应商', 1),
(12, 'SUPP012', '中芯国际集成电路制造有限公司', '上海市浦东新区中芯国际总部', '孙经理', '021-33335555', '021-44446666', 'sun@smic.com', '芯片供应商', 1);

-- 5. 车间信息表
CREATE TABLE workshop (
  id BIGINT NOT NULL PRIMARY KEY COMMENT '车间编号',
  code VARCHAR(50) NOT NULL UNIQUE COMMENT '车间编码',
  area DECIMAL(10,2) COMMENT '车间面积',
  manager VARCHAR(50) COMMENT '车间负责人',
  name VARCHAR(100) NOT NULL COMMENT '车间名称',
  description TEXT COMMENT '车间描述',
  status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int default '0' comment'删除标记'
) COMMENT='车间信息表';

-- 车间信息表模拟数据
INSERT INTO workshop (id, code, area, manager, name, description, status) VALUES
(1, 'WS001', 1200.50, '张主任', '装配车间A', '主要负责产品装配', 1),
(2, 'WS002', 980.30, '李主任', '机加工车间B', '负责零部件机加工', 1),
(3, 'WS003', 1500.00, '王主任', '焊接车间C', '负责产品焊接工艺', 1),
(4, 'WS004', 800.75, '赵主任', '喷涂车间D', '负责产品表面处理', 1),
(5, 'WS005', 1100.20, '陈主任', '质检车间E', '负责产品质量检测', 1),
(6, 'WS006', 1300.80, '刘主任', '包装车间F', '负责产品包装', 1),
(7, 'WS007', 950.60, '杨主任', '电子车间G', '负责电子产品组装', 1),
(8, 'WS008', 1050.40, '黄主任', '冲压车间H', '负责金属板材冲压', 1),
(9, 'WS009', 1400.90, '周主任', '热处理车间I', '负责材料热处理', 1),
(10, 'WS010', 750.30, '吴主任', '维修车间J', '负责设备维护', 1),
(11, 'WS011', 1250.70, '郑主任', '总装车间K', '负责产品总装', 1),
(12, 'WS012', 880.50, '孙主任', '测试车间L', '负责产品功能测试', 1);

-- 6. 工作站信息表
CREATE TABLE workstation (
  id BIGINT NOT NULL PRIMARY KEY COMMENT '工作站编号',
  code VARCHAR(50) NOT NULL UNIQUE COMMENT '工作站编码',
  name VARCHAR(100) NOT NULL COMMENT '工作站名称',
  workshop_id BIGINT COMMENT '所属车间编号',
  location VARCHAR(200) COMMENT '工作站地点',
  process_id BIGINT COMMENT '所属工序编号',
  description TEXT COMMENT '工作站描述',
  status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int default '0' comment'删除标记'
) COMMENT='工作站信息表';

-- 工作站信息表模拟数据
INSERT INTO workstation (id, code, name, workshop_id, location, process_id, description, status) VALUES
(1, 'WT001', '装配工位01', 1, '装配车间A-东侧', 1, '负责产品初步装配', 1),
(2, 'WT002', '装配工位02', 1, '装配车间A-西侧', 1, '负责产品核心部件装配', 1),
(3, 'WT003', '机加工工位01', 2, '机加工车间B-南侧', 2, '负责零部件粗加工', 1),
(4, 'WT004', '机加工工位02', 2, '机加工车间B-北侧', 2, '负责零部件精加工', 1),
(5, 'WT005', '焊接工位01', 3, '焊接车间C-中央区', 3, '负责产品结构焊接', 1),
(6, 'WT006', '喷涂工位01', 4, '喷涂车间D-东侧', 4, '负责产品底漆喷涂', 1),
(7, 'WT007', '喷涂工位02', 4, '喷涂车间D-西侧', 4, '负责产品面漆喷涂', 1),
(8, 'WT008', '质检工位01', 5, '质检车间E-南侧', 5, '负责产品尺寸检测', 1),
(9, 'WT009', '质检工位02', 5, '质检车间E-北侧', 5, '负责产品功能检测', 1),
(10, 'WT010', '包装工位01', 6, '包装车间F-东侧', 6, '负责产品内包装', 1),
(11, 'WT011', '包装工位02', 6, '包装车间F-西侧', 6, '负责产品外包装', 1),
(12, 'WT012', '电子装配工位01', 7, '电子车间G-南侧', 7, '负责电路板装配', 1);

-- 7. 物料信息表
CREATE TABLE material (
  id BIGINT NOT NULL PRIMARY KEY COMMENT '物料编号',
  code VARCHAR(50) NOT NULL UNIQUE COMMENT '物料编码',
  name VARCHAR(100) NOT NULL COMMENT '物料名称',
  specification VARCHAR(200) COMMENT '物料规格',
  unit_id BIGINT COMMENT '物料单位编号',
  category_id BIGINT COMMENT '物料分类编号',
  is_high_value TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否高价值物料(0:否,1:是)',
  has_safety_stock TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否有安全库存(0:否,1:是)',
  min_stock DECIMAL(10,2) COMMENT '最小库存量',
  max_stock DECIMAL(10,2) COMMENT '最大库存量',
  safety_stock DECIMAL(10,2) COMMENT '安全库存量',
  image_url VARCHAR(200) COMMENT '物料图片',
  description TEXT COMMENT '物料描述',
  status TINYINT(1) NOT NULL DEFAULT 1 COMMENT '是否启用(0:禁用,1:启用)',
  create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `delete_flag` int default '0' comment'删除标记'
) COMMENT='物料信息表';

-- 物料信息表模拟数据
INSERT INTO material (id, code, name, specification, unit_id, category_id, is_high_value, has_safety_stock, min_stock, max_stock, safety_stock, image_url, description, status) VALUES
(1, 'MAT001', '芯片A', 'ARM-Cortex-A53 1.2GHz', 1, 4, 1, 1, 100.00, 1000.00, 300.00, '/images/mat001.jpg', '高性能处理芯片', 1),
(2, 'MAT002', '芯片B', 'ARM-Cortex-M4 200MHz', 1, 4, 1, 1, 200.00, 2000.00, 500.00, '/images/mat002.jpg', '低功耗控制芯片', 1),
(3, 'MAT003', '电阻1KΩ', '1KΩ±1% 1/4W', 3, 4, 0, 1, 1000.00, 10000.00, 2000.00, '/images/mat003.jpg', '贴片电阻', 1),
(4, 'MAT004', '电容100μF', '100μF±20% 25V', 3, 4, 0, 1, 800.00, 8000.00, 1500.00, '/images/mat004.jpg', '电解电容', 1),
(5, 'MAT005', '铝合金外壳', '100*80*50mm', 1, 5, 0, 1, 50.00, 500.00, 100.00, '/images/mat005.jpg', '产品外壳', 1),
(6, 'MAT006', '塑料按键', '12*12*8mm 黑色', 3, 5, 0, 1, 1000.00, 10000.00, 2000.00, '/images/mat006.jpg', '控制面板按键', 1),
(7, 'MAT007', '锂电池', '3.7V 2000mAh', 1, 6, 1, 1, 100.00, 1000.00, 300.00, '/images/mat007.jpg', '可充电锂电池', 1),
(8, 'MAT008', 'PCB主板', '120*80mm 双面板', 1, 2, 1, 1, 50.00, 500.00, 100.00, '/images/mat008.jpg', '印刷电路板', 1),
(9, 'MAT009', '连接器', 'USB Type-C 24针', 3, 4, 0, 1, 300.00, 3000.00, 600.00, '/images/mat009.jpg', '数据连接器', 1),
(10, 'MAT010', '显示屏', '7寸 TFT 800*480', 1, 4, 1, 1, 50.00, 500.00, 100.00, '/images/mat010.jpg', '液晶显示屏', 1),
(11, 'MAT011', '扬声器', '3W 8Ω 圆形', 3, 5, 0, 1, 200.00, 2000.00, 400.00, '/images/mat011.jpg', '音频输出设备', 1),
(12, 'MAT012', '成品设备A', '完整功能版', 1, 3, 1, 1, 10.00, 100.00, 30.00, '/images/mat012.jpg', '完整成品设备', 1);