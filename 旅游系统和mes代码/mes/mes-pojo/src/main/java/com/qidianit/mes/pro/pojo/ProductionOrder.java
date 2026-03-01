package com.qidianit.mes.pro.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import org.springframework.cglib.core.Local;
import org.springframework.format.annotation.DateTimeFormat;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/20 - 下午1:52
 */

@Data
public class ProductionOrder {
    private Long id;
    private String productionOrderCode;
    private String productionOrderName;
    private Integer productionOrderSource;
    private Integer productionOrderType;
    private String orderCode;
    private String materialCode;
    private BigDecimal productionOrderQuantity;
    private BigDecimal producedQuantity;
    private String customerCode;
    private String supplierCode;
    @JsonFormat(pattern = "yyyy-MM-dd", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private LocalDate requestDate;
    private Integer status;
    private String qrCodeUrl;
    private Long parentId;
    private String remark;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
    private Long creatorId;
    private Long updatorId;
    private Integer deleteFlag;
}
