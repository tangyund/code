package com.qidianit.mes.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
@Data
@TableName("unit")
public class Unit {
    
    @TableId(type = IdType.NONE)
    private Long id;
    
    private String code;
    
    private String name;
    
    private String description;
    
    @TableField("is_main_unit")
    private Integer isMainUnit;
    
    @TableField("main_unit_id")
    private Long mainUnitId;
    
    @TableField("conversion_ratio")
    private BigDecimal conversionRatio;
    
    private Integer status;
    
    @TableField("create_time")
    private LocalDateTime createTime;
    
    @TableField("update_time")
    private LocalDateTime updateTime;
    @TableField("delete_flag")
    private Integer deleteFlag;
}