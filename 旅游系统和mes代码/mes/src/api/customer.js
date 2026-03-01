import request from '@/util/Request'

// 分页查询客户
export function getCustomerPage(pageNum, size, customer) {
  return request({
    url: '/customer/page',
    method: 'get',
    params: {
      pageNum,
      size,
      ...customer
    }
  })
}

// 根据编码查询客户
export function getCustomerByCode(code) {
  return request({
    url: `/customer/code/${code}`,
    method: 'get'
  })
}

// 新增客户
export function addCustomer(data) {
  return request({
    url: '/customer/add',
    method: 'post',
    data
  })
}

// 更新客户
export function updateCustomer(data) {
  return request({
    url: '/customer/update',
    method: 'put',
    data
  })
}

// 删除客户
export function deleteCustomer(id) {
  return request({
    url: `/customer/delete/${id}`,
    method: 'delete'
  })
}

// 批量删除客户
export function batchDeleteCustomer(param) {
  return request({
    url: '/customer/batchDelete?'+param,
    method: 'delete'
  })
}

