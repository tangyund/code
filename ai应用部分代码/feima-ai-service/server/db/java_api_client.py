# -*- coding: utf-8 -*-
"""Java API HTTP 客户端（调用 feima-cloud fasting 服务）"""
import httpx
from typing import Optional

from configs.model_config import JAVA_API_BASE_URL, JAVA_API_TIMEOUT, JAVA_API_TOKEN


def _headers() -> dict:
    h = {"Content-Type": "application/json"}
    if JAVA_API_TOKEN:
        h["Authorization"] = f"Bearer {JAVA_API_TOKEN}"
    return h


async def _request(
    method: str,
    path: str,
    *,
    params: Optional[dict] = None,
    json: Optional[dict] = None,
) -> dict:
    """发送请求，解析 Result 结构。code!=0 时抛出异常。"""
    url = f"{JAVA_API_BASE_URL.rstrip('/')}{path}"
    async with httpx.AsyncClient(timeout=JAVA_API_TIMEOUT) as client:
        resp = await client.request(method, url, params=params, json=json, headers=_headers())
        resp.raise_for_status()
        data = resp.json()
    if isinstance(data, dict) and data.get("code", 0) != 0:
        raise RuntimeError(data.get("msg", "Java API 返回错误"))
    return data


async def get(path: str, params: Optional[dict] = None) -> dict:
    return await _request("GET", path, params=params)


async def post(path: str, json: Optional[dict] = None) -> dict:
    return await _request("POST", path, json=json)


async def put(path: str, json: Optional[dict] = None) -> dict:
    return await _request("PUT", path, json=json)
