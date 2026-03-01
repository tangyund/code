import request from '@/util/ProRequest.js'

// 分页查询供应商
export function getWorkflowProductPage(page, size, workflow) {
    return request({
        url: '/workflowProduct/page',
        method: 'get',
        params: {
            page,
            size,
            ...workflow
        }
    })
}

// 根据编码查询供应商
export function getWorkflowProductById(id) {
    return request({
        url: `/workflowProduct/${id}`,
        method: 'get'
    })
}

// 新增供应商
export function addWorkflowProduct(data) {
    return request({
        url: '/workflowProduct/add',
        method: 'post',
        data
    })
}

// 更新供应商
export function updateWorkflowProduct(data) {
    return request({
        url: '/workflowProduct/update',
        method: 'put',
        data
    })
}

// 删除供应商
export function deleteWorkflowProduct(id) {
    return request({
        url: `/workflowProduct/delete/${id}`,
        method: 'delete'
    })
}

// 批量删除供应商
export function batchDeleteWorkflowProduct(ids) {
    return request({
        url: '/workflowProduct/batchDelete?' + ids,
        method: 'delete'
    })
}
