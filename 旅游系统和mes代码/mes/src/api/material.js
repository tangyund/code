import request from '@/util/Request'

// 分页查询物料
export function getMaterialPage(pageNum, size, material) {
  return request({
    url: '/material/list',
    method: 'get',
    params: {
      pageNum,
      size,
      ...material
    }
  })
}

// 根据编码查询物料
export function getMaterialByCode(code) {
  return request({
    url: `/material/code/${code}`,
    method: 'get'
  })
}

// 新增物料
export function addMaterial(data) {
  return request({
    url: '/material',
    method: 'post',
    data
  })
}

// 更新物料
export function updateMaterial(data) {
  return request({
    url: '/material',
    method: 'put',
    data
  })
}

// 删除物料
export function deleteMaterial(id) {
  return request({
    url: `/material/${id}`,
    method: 'delete'
  })
}

// 批量删除物料
export function batchDeleteMaterial(ids) {
  return request({
    url: '/material/batch',
    method: 'delete',
    data: ids
  })
}

// 修改物料状态
export function changeMaterialStatus(id, status) {
  return request({
    url: `/material/${id}/status`,
    method: 'put',
    params: { status }
  })
}

// 根据分类ID查询物料列表
export function getMaterialByCategoryId(categoryId) {
  return request({
    url: `/material/category/${categoryId}`,
    method: 'get'
  })
}

// 根据是否高价值查询物料列表
export function getMaterialByHighValue(isHighValue) {
  return request({
    url: `/material/highValue/${isHighValue}`,
    method: 'get'
  })
}