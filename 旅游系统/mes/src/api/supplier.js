import request from '@/util/Request'

// 分页查询供应商
export function getSupplierPage(pageNum, size, supplier) {
  return request({
    url: '/supplier/page',
    method: 'get',
    params: {
      pageNum,
      size,
      ...supplier
    }
  })
}

// 根据编码查询供应商
export function getSupplierByCode(code) {
  return request({
    url: `/supplier/code/${code}`,
    method: 'get'
  })
}

// 新增供应商
export function addSupplier(data) {
  return request({
    url: '/supplier/add',
    method: 'post',
    data
  })
}

// 更新供应商
export function updateSupplier(data) {
  return request({
    url: '/supplier/update',
    method: 'put',
    data
  })
}

// 删除供应商
export function deleteSupplier(id) {
  return request({
    url: `/supplier/delete/${id}`,
    method: 'delete'
  })
}

// 批量删除供应商
export function batchDeleteSupplier(ids) {
  return request({
    url: '/supplier/batchDelete?' + ids,
    method: 'delete'
  })
}
