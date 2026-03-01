import request from '@/util/ProRequest.js'

// 分页查询供应商
export function getWorkflowPage(page, size, workflow) {
    return request({
        url: '/workflow/page',
        method: 'get',
        params: {
            page,
            size,
            ...workflow
        }
    })
}

// 根据编码查询供应商
export function getWorkflowByCode(code) {
    return request({
        url: `/workflow/code/${code}`,
        method: 'get'
    })
}

// 新增供应商
export function addWorkflow(data) {
    return request({
        url: '/workflow/add',
        method: 'post',
        data
    })
}

// 更新供应商
export function updateWorkflow(data) {
    return request({
        url: '/workflow/update',
        method: 'put',
        data
    })
}

// 删除供应商
export function deleteWorkflow(id) {
    return request({
        url: `/workflow/delete/${id}`,
        method: 'delete'
    })
}

// 批量删除供应商
export function batchDeleteWorkflow(ids) {
    return request({
        url: '/workflow/batchDelete?'+ids,
        method: 'delete'
    })
}
