import request from '@/util/ProRequest'

// 获取权限列表
export function getProcessStepList(params) {
    return request({
        url: '/processStep/page',
        method: 'get',
        params
    })
}

export function addProcessStep(data) {
    return request({
        url: '/processStep/add',
        method: 'post',
        data
    })
}

export function updateProcessStep(data) {
    return request({
        url: '/processStep/update',
        method: 'put',
        data
    })
}

export function getProcessStepById(id) {
    return request({
        url: '/processStep/get/' + id,
        method: 'get'
    })
}

export function deleteProcessStep(id) {
    return request({
        url: '/processStep/delete/' + id,
        method: 'delete'
    })
}
