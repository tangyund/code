<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h2>旅游景点管理系统</h2>
        <div class="tab-switch">
          <span 
            :class="{ active: !isRegister }" 
            @click="isRegister = false"
          >登录</span>
          <span 
            :class="{ active: isRegister }" 
            @click="isRegister = true"
          >注册</span>
        </div>
      </div>

      <!-- 登录表单 -->
      <el-form
        v-if="!isRegister"
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
      >
        <el-form-item prop="username">
          <el-input 
            v-model="loginForm.username"
            placeholder="请输入用户名"
          >
            <template #prefix>
              <el-icon><User /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            show-password
            @keyup.enter="handleLogin"
          >
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item>
          <el-button 
            type="primary" 
            :loading="loading"
            class="submit-btn"
            @click="handleLogin"
          >
            登录
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 注册表单 -->
      <el-form
        v-else
        ref="registerFormRef"
        :model="registerForm"
        :rules="registerRules"
      >
        <el-form-item prop="username">
          <el-input 
            v-model="registerForm.username"
            placeholder="请输入用户名"
          >
            <template #prefix>
              <el-icon><User /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="password">
          <el-input
            v-model="registerForm.password"
            type="password"
            placeholder="请输入密码"
            show-password
          >
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="confirmPassword">
          <el-input
            v-model="registerForm.confirmPassword"
            type="password"
            placeholder="请确认密码"
            show-password
          >
            <template #prefix>
              <el-icon><Lock /></el-icon>
            </template>
          </el-input>
        </el-form-item>

        <el-form-item prop="role">
          <el-select 
            v-model="registerForm.role"
            placeholder="请选择角色"
            class="role-select"
          >
            <el-option label="管理员" :value="1" />
            <el-option label="景点管理员" :value="2" />
            <el-option label="商家" :value="3" />
          </el-select>
        </el-form-item>

        <el-form-item>
          <el-button 
            type="primary" 
            :loading="registerLoading"
            class="submit-btn"
            @click="handleRegister"
          >
            注册
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, Lock } from '@element-plus/icons-vue'
import api from '@/api/api'

const router = useRouter()
const isRegister = ref(false)
const loading = ref(false)
const registerLoading = ref(false)
const loginFormRef = ref(null)
const registerFormRef = ref(null)

// 登录表单数据
const loginForm = ref({
  username: '',
  password: ''
})

// 注册表单数据
const registerForm = ref({
  username: '',
  password: '',
  confirmPassword: '',
  role: ''
})



// 处理登录
const handleLogin = async () => {
  if (!loginFormRef.value) return
  
  try {
    await loginFormRef.value.validate()
    loading.value = true
    
    const res = await api.post('/api/admin/user/login', loginForm.value)
    if (res.data) {
      localStorage.setItem('userInfo', JSON.stringify(res.data))
      localStorage.setItem('token', 'Bearer ' + res.data.id)
      ElMessage.success('登录成功')
      
      switch (res.data.role) {
        case 1:
          router.push('/ScenicSpotList')
          break
        case 2:
          router.push('/home')
          break
        case 3:
          router.push('/vendor')
          break
        default:
          ElMessage.error('角色异常，登录失败')
      }
    } else {
      ElMessage.error(res.msg || '登录失败')
    }
  } catch (error) {
    console.error('登录失败:', error)
    ElMessage.error(error.response?.data?.msg || '登录失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 处理注册
const handleRegister = async () => {
  if (!registerFormRef.value) return
  
  try {
    await registerFormRef.value.validate()
    registerLoading.value = true
    console.log(registerForm.value.role);
    const res = await api.post('/api/admin/user/register', {
      username: registerForm.value.username,
      password: registerForm.value.password,
      role: registerForm.value.role
    })
    console.log(res);
    if (res.data) {
      ElMessage.success('注册成功')
      isRegister.value = false
      loginForm.value.username = registerForm.value.username
      loginForm.value.password = registerForm.value.password
	  
    } else {
      ElMessage.error(res.msg || '注册失败')
    }
  } catch (error) {
    console.error('注册失败:', error)
    ElMessage.error(error.response?.data?.msg || '注册失败，请稍后重试')
  } finally {
    registerLoading.value = false
  }
}
</script>

<style scoped>
.login-container {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: #f0f2f5;
}

.login-box {
  width: 400px;
  padding: 30px;
  background: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.login-header h2 {
  margin-bottom: 20px;
  color: #303133;
}

.tab-switch {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
  border-bottom: 1px solid #eee;
}

.tab-switch span {
  padding: 10px 20px;
  cursor: pointer;
  color: #606266;
  position: relative;
}

.tab-switch span.active {
  color: #409EFF;
}

.tab-switch span.active::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  width: 100%;
  height: 2px;
  background: #409EFF;
}

.submit-btn {
  width: 100%;
  height: 40px;
}

.role-select {
  width: 100%;
}

:deep(.el-input__wrapper) {
  padding-left: 5px;
}

:deep(.el-input__prefix) {
  margin-left: 5px;
  color: #909399;
}

@media screen and (max-width: 576px) {
  .login-box {
    width: 90%;
    margin: 0 20px;
  }
}
</style>