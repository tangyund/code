package com.qidianit.mes.pro.pojo;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.List;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午2:15
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@TableName("process")  // 指定对应的数据库表名
public class Process {

    private Long id;
    private String processCode;
    private String processName;
    private String processDescription;
    private String remarks;
    private Integer isActive;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    private Long creatorId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    private Long modifierId;
    private Integer isDeleted;
    private List<TaskList> tasklist;
}
