package com.qidianit.mes.pro.pojo;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/23 - 下午2:55
 */
import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 物料清单BOM实体类
 * 对应数据库表：material_bom
 */
@Data
@TableName("material_bom")
public class MaterialBom {

    /**
     * 主键ID
     */
    private Long id;

    /**
     * 父物料ID (成品/半成品，关联material.id)
     */
    private Long parentMaterialId;

    /**
     * 子物料ID (组件/原料，关联material.id)
     */
    private Long childMaterialId;

    /**
     * 用量 (制造一个单位的父物料所需的子物料数量)
     */
    private BigDecimal quantity;

    /**
     * 备注信息
     */
    private String description;

    /**
     * 创建时间
     */
    private LocalDateTime createTime;

    /**
     * 更新时间
     */
    private LocalDateTime updateTime;

    /**
     * 删除标识 (0-未删除, 1-已删除)
     */
    private Integer deleteFlag;
}
