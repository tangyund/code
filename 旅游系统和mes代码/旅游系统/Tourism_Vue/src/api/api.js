import axios from 'axios';

// 创建一个简单的axios实例
const apiClient = axios.create({
  baseURL: 'http://localhost:8081',
  timeout: 5000
});

// 简单的响应拦截器
apiClient.interceptors.response.use(
  response => response,
  error => Promise.reject(error)
);

// 基础的GET请求
export const get = async (url, params = {}) => {
  try {
    const response = await apiClient.get(url, { params });
    return response.data;
  } catch (error) {
    console.error('请求失败:', error);
    throw error;
  }
};

// 基础的POST请求
export const post = async (url, data) => {
  try {
    const response = await apiClient.post(url, data);
    return response.data;
  } catch (error) {
    console.error('请求失败:', error);
    throw error;
  }
};

// 基础的PUT请求
export const put = async (url, data) => {
  try {
    const response = await apiClient.put(url, data);
    return response.data;
  } catch (error) {
    console.error('请求失败:', error);
    throw error;
  }
};

// 基础的DELETE请求
export const del = async (url) => {
  try {
    const response = await apiClient.delete(url);
    return response.data;
  } catch (error) {
    console.error('请求失败:', error);
    throw error;
  }
};

export default {
  get,
  post,
  put,
  del
};