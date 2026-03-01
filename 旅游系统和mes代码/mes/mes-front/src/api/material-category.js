import request from '@/util/Request'

// 分页查询物料分类
export function getCategoryPage(pageNum, size, category) {
  return request({
    url: '/materialCategory/page',
    method: 'get',
    params: {
      pageNum,
      size,
      ...category
    }
  })
}

// 根据编码查询物料分类
export function getCategoryByCode(code) {
  return request({
    url: `/materialCategory/code/${code}`,
    method: 'get'
  })
}

// 新增物料分类
export function addCategory(data) {
  return request({
    url: '/materialCategory',
    method: 'post',
    data
  })
}

// 更新物料分类
export function updateCategory(data) {
  return request({
    url: '/materialCategory',
    method: 'put',
    data
  })
}

// 删除物料分类
export function deleteCategory(id) {
  return request({
    url: `/materialCategory/${id}`,
    method: 'delete'
  })
}

// 批量删除物料分类
export function batchDeleteCategory(ids) {
  return request({
    url: '/materialCategory/batch',
    method: 'delete',
    data: ids
  })
}

// 修改物料分类状态
export function changeCategoryStatus(id, status) {
  return request({
    url: `/materialCategory/${id}/status`,
    method: 'put',
    params: { status }
  })
}

// 查询物料分类树形结构
export function getCategoryTree(parentId, status) {
  return request({
    url: '/materialCategory/tree',
    method: 'get',
    params: { parentId, status }
  })
}