package com.qidianit.mes.pojo;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;
@Data
@TableName("sys_dict_type")
public class SysDictType {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String dictName;
    private String dictType;
    private Integer status;
    private Long createdBy;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime createdTime;
    private Long updatedBy;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    private LocalDateTime updatedTime;
    private String remark;
    @TableField("delete_flag")
    private Integer deleteFlag;
}