# -*- coding: utf-8 -*-
"""模型、API 地址、超时等配置"""
import os

from dotenv import load_dotenv

load_dotenv()  # 数据库等配置

# 模型相关
LLM_MODELS = ["qwen-turbo"]
TEMPERATURE = 0.7
HISTORY_LEN = 5

# 阿里云 DashScope（与 BailianApiServiceImpl 一致）
DASHSCOPE_API_KEY = "sk-faade1915c8547a4924eb6855d1fda45"
ONLINE_LLM_MODEL = {
    "qwen-turbo": {
        "api_key": DASHSCOPE_API_KEY,
        "api_base_url": "https://dashscope.aliyuncs.com/compatible-mode/v1",
        "model_name": "qwen-turbo",
    },
}

# 百度餐品识别（备用，与 DishRecognizeServiceImpl 一致）
BAIDU_API_KEY = "q7nypORn9HL8x2af6pusaYa1"
BAIDU_SECRET_KEY = "DzjdHrooKzXUECLQX0v0oXmfjZHi3nPW"
DISH_RECOGNIZE_URL = "https://aip.baidubce.com/rest/2.0/image-classify/v2/dish"
TOKEN_URL = "https://aip.baidubce.com/oauth/2.0/token"
DISH_RECOGNIZE_TIMEOUT = 30

# 火山引擎豆包视觉（餐品识别优先使用）
# 配置方法见：https://www.volcengine.com/docs/82379/1399008
ARK_API_KEY = os.getenv("ARK_API_KEY", "ac531a94-7612-4e66-853b-184127052a6e")
ARK_BASE_URL = os.getenv("ARK_BASE_URL", "https://ark.cn-beijing.volces.com/api/v3")
DOUBAO_VISION_MODEL = os.getenv("DOUBAO_VISION_MODEL", "doubao-seed-1-8-251228")

# Java API（调用 feima-cloud 网关）
JAVA_API_BASE_URL = os.getenv("JAVA_API_BASE_URL", "http://127.0.0.1:8080")
JAVA_API_TIMEOUT = int(os.getenv("JAVA_API_TIMEOUT", "30"))
JAVA_API_TOKEN = os.getenv("JAVA_API_TOKEN", "")  # 可选，用于 Bearer 鉴权

# 数据库（固定使用本地 feima_cloud）
MYSQL_HOST = "127.0.0.1"
MYSQL_PORT = 3306
MYSQL_USER = "root"
MYSQL_PASSWORD = ""
MYSQL_DATABASE = "feima_cloud"
MYSQL_DSN = (
    f"mysql+aiomysql://{MYSQL_USER}:{MYSQL_PASSWORD}"
    f"@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DATABASE}?charset=utf8mb4"
)
