# -*- coding: utf-8 -*-
"""餐品识别服务（调用百度 API）"""
import httpx
from typing import List, Dict, Any
from urllib.parse import urlencode

from configs.model_config import (
    BAIDU_API_KEY,
    BAIDU_SECRET_KEY,
    TOKEN_URL,
    DISH_RECOGNIZE_URL,
    DISH_RECOGNIZE_TIMEOUT,
)

_cached_token: str | None = None
_token_expire_time: float = 0


def _get_baidu_token() -> str:
    """获取百度 Access Token（带缓存）"""
    global _cached_token, _token_expire_time
    import time
    now = time.time()
    if _cached_token and now < _token_expire_time:
        return _cached_token

    params = {
        "grant_type": "client_credentials",
        "client_id": BAIDU_API_KEY,
        "client_secret": BAIDU_SECRET_KEY,
    }
    with httpx.Client(timeout=DISH_RECOGNIZE_TIMEOUT) as client:
        resp = client.post(TOKEN_URL, data=params)
        resp.raise_for_status()
        data = resp.json()
        _cached_token = data.get("access_token")
        expires_in = data.get("expires_in", 2592000)
        _token_expire_time = now + expires_in - 300
        return _cached_token


async def recognize_dish(image_base64: str, top_num: int = 5) -> List[Dict[str, Any]]:
    """识别餐品，返回识别结果列表"""
    token = _get_baidu_token()
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    data = {"image": image_base64, "top_num": top_num}

    async with httpx.AsyncClient(timeout=DISH_RECOGNIZE_TIMEOUT) as client:
        resp = await client.post(
            f"{DISH_RECOGNIZE_URL}?access_token={token}",
            headers=headers,
            data=data,
        )
        resp.raise_for_status()
        result = resp.json()

    if "error_code" in result:
        raise ValueError(result.get("error_msg", "百度 API 调用失败"))

    items = result.get("result", [])
    return [
        {
            "name": item.get("name", ""),
            "calorie": item.get("calorie", ""),
            "probability": item.get("probability", 0),
        }
        for item in items
    ]
