import request from '@/util/Request'

// 获取权限列表
export function getPermissionList(params) {
  return request({
    url: '/permission/selectPermissionPage',
    method: 'get',
    params
  })
}

// 获取权限详情
export function getPermissionById(id) {
  return request({
    url: `/permission/get?permissionId=` + id,
    method: 'get'
  })
}

export function getPermissionByRoleId(id){
  return request({
    url: '/permission/selectPermissionsByRoleId?roleId=' + id,
    method: 'get'
  })
}

// 新增权限
export function addPermission(data) {
  console.log(data)
  return request({
    url: '/permission/addPermission',
    method: 'post',
    data
  })
}

// 更新权限
export function updatePermission(id, data) {
  return request({
    url: `/permissions/${id}`,
    method: 'put',
    data
  })
}

// 删除权限
export function deletePermission(id) {
  return request({
    url: `/permissions/${id}`,
    method: 'delete'
  })
}

// 批量删除权限
export function batchDeletePermissions(ids) {
  return request({
    url: '/permissions/batch',
    method: 'delete',
    data: ids
  })
}