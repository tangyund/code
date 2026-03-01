package com.qidianit.mes.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.Date;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/19 - 下午2:09
 */
@Data
public class CodeAutoInfo {
    private Long id;
    private String type;
    private String pre;
    private Integer sequence;
    private Date createTime;
    private Integer deleteFlag;
}