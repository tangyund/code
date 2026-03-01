package com.qidianit.mes.pro.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/19 - 下午4:13
 */
@Data
public class WorkflowProduct {
    private Long id;
    private Long workflowId;
    private String productCode;
    private String remarks;
    @JsonFormat(pattern = "yyyy-MM-dd  HH:mm:ss",timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    private String createBy;
    @JsonFormat(pattern = "yyyy-MM-dd  HH:mm:ss",timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    private String updateBy;
    private Integer deleteFlag;


}
