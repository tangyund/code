import request from '@/util/ProRequest.js'

// 分页查询供应商
export function getWorkflowProcessPage(page, size, workflow) {
    return request({
        url: '/workflowProcess/page',
        method: 'get',
        params: {
            page,
            size,
            ...workflow
        }
    })
}

// 根据编码查询供应商
export function getWorkflowProcessById(id) {
    return request({
        url: `/workflowProcess/${id}`,
        method: 'get'
    })
}

// 新增供应商
export function addWorkflowProcess(data) {
    return request({
        url: '/workflowProcess/add',
        method: 'post',
        data
    })
}

// 更新供应商
export function updateWorkflowProcess(data) {
    return request({
        url: '/workflowProcess/update',
        method: 'put',
        data
    })
}

// 删除供应商
export function deleteWorkflowProcess(id) {
    return request({
        url: `/workflowProcess/delete/${id}`,
        method: 'delete'
    })
}

// 批量删除供应商
export function batchDeleteWorkflowProcess(ids) {
    return request({
        url: '/workflowProcess/batchDelete?' + ids,
        method: 'delete'
    })
}
