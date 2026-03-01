package com.qidianit.mes.pro.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午10:26
 */
@Data
public class Workflow {
    private Long id;
    private String workflowCode;
    private String workflowName;
    private Integer status;
    private String workflowDescription;
    private String remarks;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    private String createBy;
    @JsonFormat(pattern = "yyyy-MM-dd  HH:mm:ss",timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    private String updateBy;
    private Integer deleteFlag;
    private List<Process> process;
}
