import request from '@/util/Request'

// 获取权限列表
export function getRoleList(params) {
    return request({
        url: '/role/selectRolePage',
        method: 'get',
        params
    })
}

export function addRole(data){
    return request({
        url: '/role/addRole',
        method: 'post',
        data
    })
}

