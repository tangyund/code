# -*- coding: utf-8 -*-
"""服务端口、CORS 等配置"""

# 服务（固定 9092，用于 Python AI 模块）
HOST = "0.0.0.0"
PORT = 9092

# CORS
CORS_ORIGINS = ["*"]
CORS_ALLOW_CREDENTIALS = True
CORS_ALLOW_METHODS = ["*"]
CORS_ALLOW_HEADERS = ["*"]
