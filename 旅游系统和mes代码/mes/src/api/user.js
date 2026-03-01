import request from '@/util/Request'

// 获取权限列表
export function getUserList(params) {
    return request({
        url: '/user/selectUserPage',
        method: 'get',
        params
    })
}