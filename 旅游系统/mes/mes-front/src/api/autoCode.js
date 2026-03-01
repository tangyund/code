import request from '@/util/ProRequest'

// 将函数名改为 generateAutoCode 以匹配导入需求
export function generateAutoCode() {
    return request({
        url: '/productionOrder/autoCode',
        method: 'get'
    })
}