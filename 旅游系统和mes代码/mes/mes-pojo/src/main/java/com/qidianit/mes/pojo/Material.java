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
@TableName("material")
public class Material {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String code;
    
    private String name;
    
    private String specification;
    
    @TableField("unit_id")
    private Long unitId;
    
    @TableField("category_id")
    private Long categoryId;
    
    @TableField("is_high_value")
    private Integer isHighValue;
    
    @TableField("has_safety_stock")
    private Integer hasSafetyStock;
    
    @TableField("min_stock")
    private BigDecimal minStock;
    
    @TableField("max_stock")
    private BigDecimal maxStock;
    
    @TableField("safety_stock")
    private BigDecimal safetyStock;
    
    @TableField("image_url")
    private String imageUrl;
    
    private String description;
    
    private Integer status;
    
    @TableField("create_time")
    private LocalDateTime createTime;
    
    @TableField("update_time")
    private LocalDateTime updateTime;

    @TableField("delete_flag")
    private Integer deleteFlag;
    @TableField(exist = false)
    private Unit unit;
    @TableField(exist = false)
    private MaterialCategory category;
    @TableField(exist = false)
    private BigDecimal quantity;
}