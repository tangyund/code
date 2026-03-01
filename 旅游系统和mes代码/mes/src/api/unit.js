import request from '@/util/Request'

// 分页查询计量单位
export function getUnitPage(pageNum, size, unit) {
  return request({
    url: '/unit/page',
    method: 'get',
    params: {
      pageNum,
      size,
      ...unit
    }
  })
}

// 根据编码查询计量单位
export function getUnitByCode(code) {
  return request({
    url: `/unit/code/${code}`,
    method: 'get'
  })
}

// 新增计量单位
export function addUnit(data) {
  return request({
    url: '/unit',
    method: 'post',
    data
  })
}

// 更新计量单位
export function updateUnit(data) {
  return request({
    url: '/unit',
    method: 'put',
    data
  })
}

// 删除计量单位
export function deleteUnit(id) {
  return request({
    url: `/unit/${id}`,
    method: 'delete'
  })
}

// 批量删除计量单位
export function batchDeleteUnit(ids) {
  return request({
    url: '/unit/batch',
    method: 'delete',
    data: ids
  })
}

// 修改计量单位状态
export function changeUnitStatus(id, status) {
  return request({
    url: `/unit/${id}/status`,
    method: 'put',
    params: { status }
  })
}

// 查询计量单位树形结构
export function getUnitTree(isMainUnit) {
  return request({
    url: '/unit/tree',
    method: 'get',
    params: { isMainUnit }
  })
}