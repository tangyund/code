import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
      {
        path: '/',
        alias: '/welcome',
        name: 'home',
        component: () => import('../views/home.vue'),
          children: [
            {
              path: '',
              name: 'index',
              component: () => import('../views/welcome.vue'),
              meta: {
                title: '首页'
              }
            },
            {
              path: 'user',
              name: 'user',
              component: () => import('../views/user/index.vue'),
              meta: {
                title: '首页'
              }
            },
            {
              path: 'permission',
              name: 'permission',
              component: () => import('../views/permission/index.vue'),
              meta: {
                title: '首页'
              }
            },
              {
                path: 'role',
                name: 'role',
                component: () => import('../views/role/index.vue'),
                meta: {
                  title: '首页'
                }
              },
              {
                path: 'logs',
                name: 'logs',
                component: () => import('../views/log/index.vue'),
                meta: {
                  title: '首页'
                }
              },
            {
              path: 'dict',
              name: 'dict',
              component: () => import('../views/dict/index.vue'),
              meta: {
                title: '字典'
              }
            },
            {
              path: 'workshop',
              name: 'workshop',
              component: () => import('../views/base-data/workshop/index.vue'),
              meta: {
                title: '车间管理'
              }
            },
            {
              path: 'workstation',
              name: 'workstation',
              component: () => import('../views/base-data/workstation/index.vue'),
              meta: {
                title: '工作站管理'
              }
            },
            {
              path: 'material-category',
              name: 'material-category',
              component: () => import('../views/base-data/material-category/index.vue'),
              meta: {
                title: '物料分类'
              }
            },
            {
              path: 'material',
              name: 'material',
              component: () => import('../views/base-data/material/index.vue'),
              meta: {
                title: '物料管理'
              }
            },
            {
              path: 'unit',
              name: 'unit',
              component: () => import('../views/base-data/unit/index.vue'),
              meta: {
                title: '计量单位'
              }
            },
            {
              path: 'supplier',
              name: 'supplier',
              component: () => import('../views/base-data/supplier/index.vue'),
              meta: {
                title: '供应商'
              }
            },
            {
              path: 'customer',
              name: 'customer',
              component: () => import('../views/base-data/customer/index.vue'),
              meta: {
                title: '客户'
              }
            },
            {
              path: 'process',
              name: 'process',
              component: () => import('../views/pro/process/index.vue'),
              meta: {
                title: '工序管理'
              }
            },
            {
              path: 'proroute',
              name: 'proroute',
              component: () => import('@/views/pro/workflow/index.vue'),
              meta: {
                title: '工艺管理'
              }
            },
            {
              path: 'production-order',
              name: 'production-order',
              component: () => import('@/views/pro/production-order/index2.vue'),
              meta: {
                title: '生产工单'
              }
            },
            {
              path: 'proschedule',
              name: 'proschedule',
              component: () => import('../views/pro/proschedule/index.vue'),
              meta: {
                title: '生产排产'
              }
            },
            {
              path: 'feedback',
              name: 'feedback',
              component: () => import('../views/pro/feedback/index.vue'),
              meta: {
                title: '生产报工'
              }
            }
          ]
      },
  ],
})

export default router