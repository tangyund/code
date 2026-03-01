package com.qidianit.mes.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
@Data
@TableName("material_category")
public class MaterialCategory {
    
    @TableId(type = IdType.NONE)
    private Long id;
    
    private String code;
    
    private String name;
    
    @TableField("parent_id")
    private Long parentId;
    
    private String description;
    
    private Integer status;
    
    @TableField("create_time")
    private LocalDateTime createTime;
    
    @TableField("update_time")
    private LocalDateTime updateTime;

    @TableField(exist = false)
    private List<MaterialCategory> children;

    @TableField(exist = false)
    private Boolean hasChildren;

    @TableField("delete_flag")
    private Integer deleteFlag;
}