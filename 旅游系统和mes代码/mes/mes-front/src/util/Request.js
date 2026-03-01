import axios from 'axios'

// 创建axios实例
const request = axios.create({
  baseURL: 'http://localhost:9898',
  timeout: 5000,
  headers: {
    'Content-Type': 'application/json;charset=UTF-8'
  }
})

// 请求拦截器
request.interceptors.request.use(
  config => {
    // 在发送请求之前做些什么
    const token = localStorage.getItem('token')
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`
    }
    return config
  },
  error => {
    // 对请求错误做些什么
    console.error('Request error:', error)
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  response => {
    // 对响应数据做点什么
    const res = response.data
    
    // 根据后端约定的状态码进行处理
    if (res.code === 200) {
      return res
    } else {
      // 统一处理错误
      console.error('Response error:', res.msg)
      return res
    }
  },
  error => {
    // 对响应错误做点什么
    console.error('Response error:', error)
    return Promise.reject(error)
  }
)

export default request