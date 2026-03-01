<template>
    <div class="home-layout">
        <!-- Sidebar -->
        <div :class="['sidebar', { collapsed: isSidebarCollapsed }]">
            <div class="sidebar-header">
                <h2 v-if="!isSidebarCollapsed">管理系统</h2>
                <el-button
                        class="toggle-button"
                        @click="toggleSidebar"
                        :icon="isSidebarCollapsed ? 'Expand' : 'Fold'"
                        circle
                />
            </div>
            <el-menu
                    :default-active="activeMenu"
                    :collapse="isSidebarCollapsed"
                    @select="handleMenuSelect"
                    router
            >
                <!-- 修改: 使用递归方式渲染菜单项，支持子菜单 -->
                <template v-for="item in menuItems" :key="item.index">
                    <el-menu-item
                            v-if="!item.children || item.children.length === 0"
                            :index="item.index"
                    >
                        <el-icon><component :is="item.icon" /></el-icon>
                        <template #title>{{ item.title }}</template>
                    </el-menu-item>

                    <el-sub-menu
                            v-else
                            :index="item.index"
                    >
                        <template #title>
                            <el-icon><component :is="item.icon" /></el-icon>
                            <span>{{ item.title }}</span>
                        </template>
                        <el-menu-item
                                v-for="child in item.children"
                                :key="child.index"
                                :index="child.index"
                        >
                            <el-icon><component :is="child.icon" /></el-icon>
                            <template #title>{{ child.title }}</template>
                        </el-menu-item>
                    </el-sub-menu>
                </template>
            </el-menu>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Tabs -->
            <div class="tabs-container">
                <el-tabs
                        v-model="activeTab"
                        type="card"
                        closable
                        @tab-remove="removeTab"
                        @tab-click="handleTabClick"
                >
                    <el-tab-pane
                            v-for="tab in openedTabs"
                            :key="tab.name"
                            :label="tab.title"
                            :name="tab.name">
                    </el-tab-pane>
                </el-tabs>
                <div class="tab-content">
                    <router-view/>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, reactive, watch } from 'vue'
import { HomeFilled, Document, Setting, User, Memo,Folder,Unlock,Avatar, Files, Edit, InfoFilled } from '@element-plus/icons-vue'
import { useRoute,useRouter } from 'vue-router'

// State
const route = useRoute()
const router = useRouter()
const isSidebarCollapsed = ref(false)
const activeMenu = ref('home')
const activeTab = ref('home')
const openedTabs = ref([
    {
        name: 'welcome',
        title: '首页',
        component: 'div' // Placeholder component
    }
])

// 修改: 创建包含子菜单的菜单数据结构
const menuItems = reactive([
    {
        index: 'welcome',
        title: '首页',
        icon: HomeFilled
    },
    {
        index: 'settings',
        title: '系统管理',
        icon: Setting,
        children: [
            { index: 'permission', title: '权限管理', icon: Unlock },
            { index: 'role', title: '角色管理', icon: Avatar },
            { index: 'user', title: '用户管理', icon: User },
            { index: 'dict', title: '字典管理', icon: Memo },
            { index: 'logs', title: '日志管理', icon: Document }
        ]
    },
    {
        index: 'base-data',
        title: '基础数据',
        icon: Folder,
        children: [
            { index: 'workshop', title: '车间管理', icon: Folder },
            { index: 'workstation', title: '工作站管理', icon: Folder },
            { index: 'material-category', title: '物料分类', icon: Folder },
            { index: 'material', title: '物料管理', icon: Folder },
            { index: 'unit', title: '计量单位', icon: Folder },
            { index: 'supplier', title: '供应商管理', icon: Folder },
            { index: 'customer', title: '客户管理', icon: Folder }
        ]
    },
    {
        index: 'pro',
        title: '生产管理',
        icon: Folder,
        children: [
            { index: 'process', title: '工序管理', icon: Folder },
            { index: 'proroute', title: '工艺管理', icon: Folder },
            { index: 'production-order', title: '生产工单', icon: Folder },
            { index: 'proschedule', title: '生产排产', icon: Folder },
            { index: 'feedback', title: '生产报工', icon: Folder }
        ]
    },
    {
        index: 'equipment',
        title: '设备管理',
        icon: Folder,
        children: [
            { index: 'equipment-type', title: '设备类型设置', icon: Folder },
            { index: 'equipment-ledger', title: '设备台帐', icon: Folder },
            { index: 'maintenance-check-items', title: '点检保养项目', icon: Folder },
            { index: 'maintenance-check-plan', title: '点检保养计划', icon: Folder },
            { index: 'check-records', title: '点检记录', icon: Folder },
            { index: 'maintenance-records', title: '保养记录', icon: Folder },
            { index: 'repair-order', title: '维修单', icon: Folder }
        ]
    },
    {
        index: 'jig-fixture',
        title: '工装夹具管理',
        icon: Folder,
        children: [
            { index: 'jig-fixture-type', title: '类型设置', icon: Folder },
            { index: 'jig-fixture-ledger', title: '工装夹具台帐', icon: Folder }
        ]
    },
    {
      index: 'qc',
      title: '质量管理',
      icon: Folder,
      children: [
        { index: 'qc-common-bug', title: '常见缺陷', icon: Folder },
        { index: 'qc-wait-task', title: '待检任务', icon: Folder }
      ]
    }
])

// Toggle sidebar
const toggleSidebar = () => {
    isSidebarCollapsed.value = !isSidebarCollapsed.value
}

// Handle tab click
const handleTabClick = (tag) => {
    console.log(tag.props.name);
    router.push(tag.props.name)
}
// Handle menu selection
const handleMenuSelect = (index) => {
    activeMenu.value = index
    activeTab.value = index

    // Check if tab already exists
    const existingTab = openedTabs.value.find(tab => tab.name === index)
    if (!existingTab) {
        // 查找菜单项，包括子菜单项
        let menuItem = null;
        for (const item of menuItems) {
            if (item.index === index) {
                menuItem = item;
                break;
            }
            if (item.children) {
                const child = item.children.find(child => child.index === index);
                if (child) {
                    menuItem = child;
                    break;
                }
            }
        }
        openedTabs.value.push({
            name: index,
            title: menuItem.title,
            component: 'div' // Placeholder component
        })
    }
}

// Remove tab
const removeTab = (targetName) => {
    const tabs = openedTabs.value
    let activeName = activeTab.value
    if (activeName === targetName) {
        tabs.forEach((tab, index) => {
            if (tab.name === targetName) {
                const nextTab = tabs[index + 1] || tabs[index - 1]
                if (nextTab) {
                    activeName = nextTab.name
                }
            }
        })
    }

    activeTab.value = activeName
    activeMenu.value = activeName
    openedTabs.value = tabs.filter(tab => tab.name !== targetName)
    router.go(-1);
}

// Watch active tab to sync with menu
watch(activeTab, (newVal) => {
    activeMenu.value = newVal
})
</script>

<style scoped>
.home-layout {
    display: flex;
    height: 100vh;
}

.sidebar {
    width: 200px;
    height: 100%;
    background-color: #f5f5f5;
    border-right: 1px solid #e6e6e6;
    transition: width 0.3s;
}

.sidebar.collapsed {
    width: 64px;
}

.sidebar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px;
    border-bottom: 1px solid #e6e6e6;
}

.main-content {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.tabs-container {
    flex: 1;
    overflow: hidden;
}

.tab-content {
    padding: 20px;
    height: calc(100vh - 100px);
    overflow-y: auto;
}
</style>