import request from '@/util/Request'

// 获取权限列表
export function getDictDataList(params) {
    return request({
        url: '/dictData/listByPage',
        method: 'get',
        params
    })
}

export function addDictData(data) {
    return request({
        url: '/dictData/addDictData',
        method: 'post',
        data
    })
}

export function updateDictData(data) {
    return request({
        url: '/dictData/updateDictData',
        method: 'post',
        data
    })
}

export function getDictDataById(id) {
    return request({
        url: '/dictData/getDictDataById?dictDataId='+id,
        method: 'get'
    })
}