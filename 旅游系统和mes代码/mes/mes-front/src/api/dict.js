import request from '@/util/Request'

// 获取权限列表
export function getDictTypeList(params) {
    return request({
        url: '/dictType/listByPage',
        method: 'get',
        params
    })
}

export function addDictType(data) {
    return request({
        url: '/dictType/addDictType',
        method: 'post',
        data
    })
}

export function updateDictType(data) {
    return request({
        url: '/dictType/updateDictType',
        method: 'post',
        data
    })
}

export function getDictTypeById(id) {
    return request({
        url: '/dictType/getDictTypeById?dictTypeId='+id,
        method: 'get'
    })
}