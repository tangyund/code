package com.qidianit.mes.pro.pojo;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.qidianit.mes.pojo.Material;
import com.qidianit.mes.pojo.Workstation;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/26 - 上午9:36
 */
@Data
public class ProductionReporting {
    /**
     * 主键ID
     */
    private Long id;

    /**
     * 报表编码
     */
    private String reportCode;

    /**
     * 类型ID
     */
    private Integer typeId;

    /**
     * 任务编码
     */
    private String taskCode;

    /**
     * 工位name
     */
    private String stationName;

    /**
     * 工序name
     */
    private String processName;

    /**
     * 生产订单编码
     */
    private String productionOrderCode;

    /**
     * 物料编码
     */
    private String materialCode;

    private String materialName;

    /**
     * 状态
     */
    private Long status;

    /**
     * 报表数量
     */
    private Long reportNum;

    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;

    /**
     * 创建人
     */
    private String createBy;

    /**
     * 审核人
     */
    private String reviewBy;

    /**
     * 备注
     */
    private String remark;

    /**
     * 更新时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;

    /**
     * 更新人
     */
    private String updateBy;

    /**
     * 删除标志（0：未删除，1：已删除）
     */
    private Integer deleteFlag;


    private Material material;
}