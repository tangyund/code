import request from '@/util/Request'

// 分页查询工作站
export function getWorkstationPage(pageNum, size, workstation) {
  return request({
    url: '/workstation/page',
    method: 'get',
    params: {
      pageNum,
      size,
      ...workstation
    }
  })
}

// 根据编码查询工作站
export function getWorkstationByCode(code) {
  return request({
    url: `/workstation/code/${code}`,
    method: 'get'
  })
}

// 新增工作站
export function addWorkstation(data) {
  return request({
    url: '/workstation',
    method: 'post',
    data
  })
}

// 更新工作站
export function updateWorkstation(data) {
  return request({
    url: '/workstation',
    method: 'put',
    data
  })
}

// 删除工作站
export function deleteWorkstation(id) {
  return request({
    url: `/workstation/${id}`,
    method: 'delete'
  })
}

// 批量删除工作站
export function batchDeleteWorkstation(ids) {
  return request({
    url: '/workstation/batch',
    method: 'delete',
    data: ids
  })
}

// 修改工作站状态
export function changeWorkstationStatus(id, status) {
  return request({
    url: `/workstation/${id}/status`,
    method: 'put',
    params: { status }
  })
}

// 根据车间ID查询工作站列表
export function getWorkstationByWorkshopId(workshopId) {
  return request({
    url: `/workstation/workshop/${workshopId}`,
    method: 'get'
  })
}