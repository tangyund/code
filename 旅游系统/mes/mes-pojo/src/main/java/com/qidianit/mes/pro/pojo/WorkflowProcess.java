package com.qidianit.mes.pro.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.qidianit.mes.pojo.SysDictType;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/18 - 下午3:53
 */
@Data
public class WorkflowProcess {
    private Long id;
    private Long workflowId;
    private Long processId;
    private Integer stepOrder;
    private Long relationNext;
    private String ganttColor;
    private Integer isCritical;
    private Integer needInspection;
    private Integer prepTime;
    private Integer waitTime;
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
