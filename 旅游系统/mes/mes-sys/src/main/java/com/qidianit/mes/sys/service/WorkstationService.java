package com.qidianit.mes.sys.service;

import com.baomidou.mybatisplus.extension.service.IService;

import java.util.List;

import com.github.pagehelper.PageInfo;
import com.qidianit.mes.pojo.*;
/**
 * 工作站管理Service接口
 */
public interface WorkstationService extends IService<Workstation> {

    /**
     * 分页查询工作站
     * @param pageNum 页码
     * @param size 每页大小
     * @param workstation 查询条件
     * @return 工作站分页列表
     */
    Result<?> selectWorkstationPage(int pageNum, int size, Workstation workstation);

    /**
     * 根据编码查询工作站
     * @param code 工作站编码
     * @return 工作站信息
     */
    Result<Workstation> selectByCode(String code);

    /**
     * 新增工作站
     * @param workstation 工作站信息
     * @return 操作结果
     */
    Result<Workstation> addWorkstation(Workstation workstation);

    /**
     * 更新工作站
     * @param workstation 工作站信息
     * @return 操作结果
     */
    Result<Workstation> updateWorkstation(Workstation workstation);

    /**
     * 删除工作站
     * @param id 工作站ID
     * @return 操作结果
     */
    Result<?> deleteWorkstation(Long id);

    /**
     * 批量删除工作站
     * @param ids 工作站ID列表
     * @return 操作结果
     */
    Result<?> batchDeleteWorkstation(List<Long> ids);

    /**
     * 修改工作站状态
     * @param id 工作站ID
     * @param status 状态：0-禁用，1-启用
     * @return 操作结果
     */
    Result<?> changeStatus(Long id, Integer status);

    /**
     * 根据车间ID查询工作站列表
     * @param workshopId 车间ID
     * @return 工作站列表
     */
    List<Workstation> selectByWorkshopId(Long workshopId);


    Result<PageInfo<Workstation>>selectProcessAndWorkshopByProcessId(int pageNum, int size,Workstation workstation);
    Result<PageInfo<Workstation>>selectAllStaion(int pageNum, int size,Workstation workstation);
}