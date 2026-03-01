import request from '@/util/ProRequest'

// 获取权限列表
export function getProcessList(params) {
    return request({
        url: '/process/page',
        method: 'get',
        params
    })
}

export function addProcess(data) {
    return request({
        url: '/process/add',
        method: 'post',
        data
    })
}

export function updateProcess(data) {
    return request({
        url: '/process/update',
        method: 'put',
        data
    })
}

export function queryByCode(code) {
    return request({
        url: '/process/code/' + code,
        method: 'get'
    })
}

export function deleteProcess(id) {
    return request({
        url: '/process/delete/' + id,
        method: 'delete'
    })
}

export function batchDeleteProcess(ids) {
    return request({
        url: '/process/batchDelete?'+ids,
        method: 'delete',
    })
}
// 获取自动生成的编号
export function getAutoCode() {
    return request({
        url: '/process/autoCode',
        method: 'get'
    })
}