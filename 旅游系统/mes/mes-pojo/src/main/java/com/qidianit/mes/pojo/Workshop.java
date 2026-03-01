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
@TableName("workshop")
public class Workshop {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String code;
    
    private BigDecimal area;
    
    private String manager;
    
    private String name;
    
    private String description;
    
    private Integer status;
    
    @TableField("create_time")
    private LocalDateTime createTime;
    
    @TableField("update_time")
    private LocalDateTime updateTime;
    @TableField("delete_flag")
    private Integer deleteFlag;
}