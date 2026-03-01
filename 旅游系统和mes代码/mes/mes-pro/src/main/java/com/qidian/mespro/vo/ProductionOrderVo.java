package com.qidian.mespro.vo;

import com.qidianit.mes.pojo.*;
import com.qidianit.mes.pro.pojo.ProductionOrder;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * @Description:
 * @Author: TangYuguo
 * @Date: 2025/9/20 - 下午2:01
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductionOrderVo extends ProductionOrder {
    private  String materialName;
    private  String customerName;
    private SysDictData typeDictData;
    private SysDictData statusDictData;
    private Customer customer;
    private Material material;
    private Supplier supplier;

}
