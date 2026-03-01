import request from '@/util/ProRequest'

// 获取权限列表
export function getProductionOrderList(params) {
    return request({
        url: '/productionOrder/page',
        method: 'get',
        params
    })
}

export function addProductionOrder(data) {
    return request({
        url: '/productionOrder/add',
        method: 'post',
        data
    })
}

export function updateProductionOrder(data) {
    return request({
        url: '/productionOrder/update',
        method: 'put',
        data
    })
}

export function queryByCode(code) {
    return request({
        url: '/productionOrder/code/' + code,
        method: 'get'
    })
}

export function deleteProductionOrder(id) {
    return request({
        url: '/productionOrder/delete/' + id,
        method: 'delete'
    })
}

export function batchDeleteProductionOrder(ids) {
    return request({
        url: '/productionOrder/batchDelete?'+ids,
        method: 'delete',
    })
}
// 获取自动生成的编号
export function getAutoCode() {
    return request({
        url: '/productionOrder/autoCode',
        method: 'get'
    })
}