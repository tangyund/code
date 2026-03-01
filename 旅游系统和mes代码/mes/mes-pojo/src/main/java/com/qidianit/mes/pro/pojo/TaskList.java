package com.qidianit.mes.pro.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/24 - 下午3:22
 */
@Data
public class TaskList {

    private Long id;
    private String taskCode;
    private String taskName;
    private String workstationCode;
    private String workstationName;
    private Long workflowId;
    private Long processId;
    private String productionOrderCode;
    private Integer scheduledQuantity;
    private Integer producedQuantity = 0;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime startTime;
    private Integer productionDuration;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime estimatedCompletionTime;
    private String displayColor;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonIgnore
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    @JsonIgnore
    private LocalDateTime updateTime;
    private Integer deleteFlag ;
}