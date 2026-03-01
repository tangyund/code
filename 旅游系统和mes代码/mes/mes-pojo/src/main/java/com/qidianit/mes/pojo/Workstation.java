package com.qidianit.mes.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.qidianit.mes.pro.pojo.Process;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
@Data
@TableName("workstation")
public class Workstation {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String code;
    
    private String name;
    
    @TableField("workshop_id")
    private Long workshopId;
    
    private String location;
    
    @TableField("process_id")
    private Long processId;
    
    private String description;
    
    private Integer status;
    
    @TableField("create_time")
    private LocalDateTime createTime;
    
    @TableField("update_time")
    private LocalDateTime updateTime;

    @TableField("delete_flag")
    private Integer deleteFlag;

    @TableField(exist = false)
    private String workshopName;
    @TableField(exist = false)
    private String processName;
}