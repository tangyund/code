import request from '@/util/ProRequest'

// 查询生产工单列表
export function getProductionOrderList(query) {
  return request({
    url: '/productionOrder/list',
    method: 'get',
    params: query
  })
}

// 查询生产工单详细
export function getProductionOrder(id) {
  return request({
    url: '/productionOrder/' + id,
    method: 'get'
  })
}

// 新增生产工单
export function addProductionOrder(data) {
  return request({
    url: '/productionOrder/add',
    method: 'post',
    data: data
  })
}

// 修改生产工单
export function updateProductionOrder(data) {
  return request({
    url: '/productionOrder/update',
    method: 'put',
    data: data
  })
}

// 删除生产工单
export function deleteProductionOrder(id) {
  return request({
    url: '/productionOrder/delete/' + id,
    method: 'delete'
  })
}

// 确认生产工单
export function confirmProductionOrder(id) {
  return request({
    url: '/productionOrder/confirm/' + id,
    method: 'put'
  })
}

// 审核生产工单
export function auditProductionOrder(id, data) {
  return request({
    url: '/productionOrder/audit/' + id,
    method: 'put',
    data: data
  })
}
//打会
export function cancleProductionOrder(id) {
  return request({
    url: '/productionOrder/cancle/' + id,
    method: 'put',
  })
}

// 获取工单BOM组成
export function getProductionOrderBom(id) {
  return request({
    url: '/productionOrder/bom/' + id,
    method: 'get'
  })
}

// 自动生成工单编号
export function generateProductionOrderCode() {
  return request({
    url: '/productionOrder/generateCode',
    method: 'get'
  })
}

// 导出生产工单
export function exportProductionOrder(query) {
  return request({
    url: '/productionOrder/export',
    method: 'get',
    params: query,
    responseType: 'blob'
  })
}
//查询物料组成
export function getMaterialBom(code,pageNum, pageSize,) {
  return request({
    url: '/productionOrder/bomlist',
    method: 'get',
    params: {
      code,
      pageNum,
      pageSize,
    }
  })
}