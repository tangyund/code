import { createRouter, createWebHistory } from 'vue-router'
import Layout from '../layout/index.vue'
import Layout1 from '../layout/UserLayout.vue'
import Layout2 from '../layout/vendormenu.vue' 

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
	{
		path: '/login',
		name: 'login',
		component: () => import('@/views/login/login.vue')
	},
    {
      path: '/admin',
      component: Layout,
      redirect: '/ScenicSpotList',
      children: [
        {
          path: '/ScenicSpotList',
          name: 'ScenicSpotList',
          component: () => import('@/views/admin/scenic/ScenicSpotList.vue'),
          meta: { title: '景点管理' }
        },
        {
          path: '/ScenicRatingList',
          name: 'ScenicRatingList',
          component: () => import('@/views/admin/scenic/ScenicRatingList.vue'),
          meta: { title: '评价管理' }
        },
		
		{
		  path: '/ScenicNewsList',
		  name: 'ScenicNewsList',
		  component: () => import('@/views/admin/scenic/ScenicNewsList.vue'),
		  meta: { title: '新闻管理' }
		},
		
		{
		  path: '/RespondConsultation',
		  name: 'RespondConsultation',
		  component: () => import('@/views/admin/scenic/RespondConsultation.vue'),
		  meta: { title: '咨询回复' }
		},
		
        {
          path: '/UserList',
          name: 'UserList',
          component: () => import('@/views/admin/User/UserList.vue'),
          meta: { title: '用户信息' }
        },
		{
		  path: '/RouteList',
		  name: 'RouteList',
		  component: () => import('@/views/admin/scenic/RouteList.vue'),
		  meta: { title: '用户信息' }
		},
		{
		  path: '/LodgingInfoList',
		  name: 'LodgingInfoList',
		  component: () => import('@/views/admin/scenic/LodgingInfoList.vue'),
		  meta: { title: '民宿信息' }
		},
		{
			path: '/FoodVendor',
			name: 'FoodVendor',
			component: () => import('@/views/admin/scenic/FoodVendor.vue'),
			meta: { title: '商家管理' }
		},
		{
			path: '/FoodOrder',
			name: 'FoodOrder',
			component: () => import('@/views/admin/scenic/FoodOrder.vue'),
			meta: { title: '订单管理' }
		},
		{
			path: '/ActivityList',
			name: 'ActivityList',
			component: () => import('@/views/admin/scenic/ActivityList.vue'),
			meta: { title: '活动管理' }
		},
		{
			path: '/ActivityBookingList',
			name: 'ActivityBookingList',
			component: () => import('@/views/admin/scenic/ActivityBookingList.vue'),
			meta: { title: '预约管理' }
		},
		{
			path: '/ScenicSpotShare',
			name: 'ScenicSpotShare',
			component: () => import('@/views/admin/scenic/ScenicSpotShare.vue'),
			meta: { title: '景点分享' }
		},
		{
			path: '/FoodRecommend',
			name: 'FoodRecommend',
			component: () => import('@/views/admin/scenic/FoodRecommend.vue'),
			meta: { title: '美食推荐 ' }
		}
      ]
    },
	{
	  path: '/',
	  component: Layout1,
	  redirect: '/Home',
	  children: [
		  {
		    path: '/home',
		    name: 'home',
		    component: () => import('@/views/User/scenic/home.vue'),
		    meta: { title: '景点信息' }
		  },
	    {
	      path: '/ScenicSpot',
	      name: 'ScenicSpot',
	      component: () => import('@/views/User/scenic/ScenicSpot.vue'),
	      meta: { title: '景点信息' }
	    },
		
		{
		  path: '/Food',
		  name: 'Food',
		  component: () => import('@/views/User/scenic/Food.vue'),
		  meta: { title: '美食信息' }
		},
		
		{
		  path: '/ScenicNews',
		  name: 'ScenicNews',
		  component: () => import('@/views/User/scenic/ScenicNews.vue'),
		  meta: { title: '景点新闻' }
		},
		
		{
		  path: '/TouristConsultation',
		  name: 'TouristConsultation',
		  component: () => import('@/views/User/scenic/TouristConsultation.vue'),
		  meta: { title: '游客咨询' }
		},
		
      {
	      path: '/Routeselection',
	      name: 'Routeselection',
	      component: () => import('@/views/User/scenic/Routeselection.vue'),
	      meta: { title: '旅游信息' }
	    },
		{
		    path: '/LodgingInfo',
		    name: 'LodgingInfo',
		    component: () => import('@/views/User/scenic/LodgingInfo.vue'),
		    meta: { title: '民宿信息' }
		  },
		  {
		      path: '/Activity',
		      name: 'Activity',
		      component: () => import('@/views/User/scenic/Activity.vue'),
		      meta: { title: '民宿信息' }
		    },
			{
			    path: '/MeOrder',
			    name: 'MeOrder',
			    component: () => import('@/views/User/scenic/MeOrder.vue'),
			    meta: { title: '下单' }
		    },
			{
				path: '/ScenicShare',
			    name: 'ScenicShare',
			    component: () => import('@/views/User/scenic/ScenicShare.vue'),
			    meta: { title: '景点分享' }
			},
			{
				path: '/Order',
				name: 'Order',
				component: () => import('@/views/User/scenic/Order.vue'),
				meta: { title: '下单' }
			}
	  ]
	},
	{
	  path: '/vendor',
	  component: Layout2,
	  redirect: '/VScenicSpotList',
	  children: [
	    {
	      path: '/VScenicSpotList',
	      name: 'VScenicSpotList',
	      component: () => import('@/views/vendor/scenic/VScenicSpotList.vue'),
	      meta: { title: '景点管理' }
	    },
	    {
	      path: '/VScenicRatingList',
	      name: 'VScenicRatingList',
	      component: () => import('@/views/vendor/scenic/VScenicRatingList.vue'),
	      meta: { title: '评价管理' }
	    },

		{
			path: '/VFoodOrder',
			name: 'VFoodOrder',
			component: () => import('@/views/vendor/scenic/VFoodOrder.vue'),
			meta: { title: '订单管理' }
		},
		{
			path: '/VMenu',
			name: 'VMenu',
			component: () => import('@/views/vendor/scenic/VMenu.vue'),
			meta: { title: '菜单管理' }
		}
	  ]
	},
	
  ]
})

export default router
