package com.qidianit.mes.pro.pojo;

import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/17 - 下午4:12
 */
@Data
@TableName("processStep")
public class ProcessStep {


    private Long id;
    private Long processId;
    private Long stepOrder;
    private String materialUrl;
    private String auxiliaryEquipment;
    private String auxiliaryMaterials;
    private String stepDescription;
    private String remarks;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    private String modifierId;
    private Integer isDeleted;
}
