import request from '@/util/ProRequest'

// 查询生产工单列表
export function getList(query) {
    return request({
        url: '/productionReporting/list',
        method: 'get',
        params: query
    })
}
export function getTaskList(query) {
    return request({
        url: '/productionReporting/page',
        method: 'get',
        params: query
    })
}

// 查询生产工单详细
export function getReport(id) {
    return request({
        url: '/productionReporting/' + id,
        method: 'get'
    })
}

// 新增生产工单
export function addReport(data) {
    return request({
        url: '/productionReporting/add',
        method: 'post',
        data: data
    })
}

// 修改生产工单
export function updateReport(data) {
    return request({
        url: '/productionReporting/update',
        method: 'put',
        data: data
    })
}

// 删除生产工单
export function deleteReport(id) {
    return request({
        url: '/productionReporting/delete/' + id,
        method: 'delete'
    })
}

// 确认生产工单
export function confirmReport(id) {
    return request({
        url: '/productionReporting/confirm/' + id,
        method: 'put'
    })
}

// 审核生产工单
export function auditReport(id, data) {
    return request({
        url: '/productionReporting/audit/' + id,
        method: 'put',
        data: data
    })
}
//打会
export function cancleReport(id) {
    return request({
        url: '/productionReporting/cancle/' + id,
        method: 'put',
    })
}

export function batchDelete(ids) {
    return request({
        url: '/productionReporting/batchDelete?ids=' + ids.join(','),
        method: 'delete',
    })
}

// 获取工单BOM组成
export function getProductionOrderBom(id) {
    return request({
        url: '/productionOrder/bom/' + id,
        method: 'get'
    })
}

// 自动生成工单编号
export function generateProductionOrderCode() {
    return request({
        url: '/productionOrder/generateCode',
        method: 'get'
    })
}

// 导出生产工单
export function exportProductionOrder(query) {
    return request({
        url: '/productionOrder/export',
        method: 'get',
        params: query,
        responseType: 'blob'
    })
}
//查询物料组成
export function getMaterialBom(code,pageNum, pageSize,) {
    return request({
        url: '/productionOrder/bomlist',
        method: 'get',
        params: {
            code,
            pageNum,
            pageSize,
        }
    })
}