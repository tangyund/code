import request from '@/util/ProRequest'

// 查询生产工单列表
export function getProductionOrderList(query) {
    return request({
        url: '/productionOrder/allRealist',
        method: 'get',
        params: query
    })
}

// 查询生产工单详细
export function getProductionOrder(id) {
    return request({
        url: '/productionOrder/get/' + id,
        method: 'get'
    })
}
export function getProcesslist(code) {
    return request({
        url: '/productionOrder/code/' + code,
        method: 'get'
    })
}
export function calculateCompletionTime(startTime, productionDuration) {
    // 构建表单数据
    const formData = new FormData();
    formData.append('startTime', startTime);
    formData.append('productionDuration', productionDuration);
    return request({
        url: '/productionOrder/calculateCompletionTime',
        method: 'post',
        headers: {
            'Content-Type': 'multipart/form-data' // 使用FormData对应的Content-Type
        },
        data: formData // 使用data而不是params传递参数
    })
}


// 新增生产工单
export function addProductionOrder(data) {
    return request({
        url: '/productionOrder/add',
        method: 'post',
        data: data
    })
}
export function addTask(data) {
    return request({
        url: '/productionOrder/addtask',
        method: 'post',
        data: data
    })
}
export function getTaskList(workflowId, processId,code) {
    return request({
        url: `/productionOrder/tasklist/${workflowId}/${processId}/${code}`,
        method: 'get'
    })
}

export function getTask(id) {
    return request({
        url: `/productionOrder/task/${id}`,
        method: 'get'
    })
}

// 修改生产工单
export function updateProductionOrder(data) {
    return request({
        url: '/productionOrder/update',
        method: 'put',
        data: data
    })
}

export function updateTaskList(data) {
    return request({
        url: '/productionOrder/updatetasklist',
        method: 'put',
        data: data
    })
}

// 删除生产工单
export function deleteProductionOrder(id) {
    return request({
        url: '/productionOrder/delete/' + id,
        method: 'delete'
    })
}

export function deleteTaskList(id) {
    return request({
        url: '/productionOrder/deletetask/' + id,
        method: 'delete'
    })
}
export function batchDeleteProcess(ids) {
    return request({
        url: '/productionOrder/batchDelete?ids=' + ids.join(','),
        method: 'delete',
    })
}
// 确认生产工单
export function confirmProductionOrder(id) {
    return request({
        url: '/productionOrder/confirm/' + id,
        method: 'put'
    })
}

// 审核生产工单
export function auditProductionOrder(id, data) {
    return request({
        url: '/productionOrder/audit/' + id,
        method: 'put',
        data: data
    })
}
//打会
export function cancleProductionOrder(id) {
    return request({
        url: '/productionOrder/cancle/' + id,
        method: 'put',
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