package com.qidian.mespro.vo;

import com.qidian.mespro.service.WorkflowProductService;
import com.qidianit.mes.pojo.Material;
import com.qidianit.mes.pojo.Unit;
import com.qidianit.mes.pro.pojo.WorkflowProduct;
import lombok.Data;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/19 - 下午4:20
 */
@Data
public class WorkflowProductVo extends WorkflowProduct {
    private Material product;


}
