import request from '@/util/Request'

// 分页查询车间
export function getWorkshopPage(pageNum, size, workshop) {
  return request({
    url: '/workshop/page',
    method: 'get',
    params: {
      pageNum,
      size,
      ...workshop
    }
  })
}

// 根据编码查询车间
export function getWorkshopByCode(code) {
  return request({
    url: `/workshop/code/${code}`,
    method: 'get'
  })
}

// 新增车间
export function addWorkshop(data) {
  return request({
    url: '/workshop',
    method: 'post',
    data
  })
}

// 更新车间
export function updateWorkshop(data) {
  return request({
    url: '/workshop',
    method: 'put',
    data
  })
}

// 删除车间
export function deleteWorkshop(id) {
  return request({
    url: `/workshop/${id}`,
    method: 'delete'
  })
}

// 批量删除车间
export function batchDeleteWorkshop(ids) {
  return request({
    url: '/workshop/batch',
    method: 'delete',
    data: ids
  })
}

// 修改车间状态
export function changeWorkshopStatus(id, status) {
  return request({
    url: `/workshop/${id}/status`,
    method: 'put',
    params: { status }
  })
}