# -*- coding: utf-8 -*-
"""餐品识别（火山引擎豆包视觉模型）"""
import asyncio
from typing import List, Dict, Any

from fastapi import Body, HTTPException

from server.services.doubao_vision_service import recognize_dish_by_vision


async def dish_recognize(
    image: str = Body(..., description="图片 base64 编码"),
    top_num: int = Body(5, description="返回前 N 个识别结果", ge=1, le=10),
):
    """
    使用豆包视觉模型识别餐品。返回与 Java 端一致的格式：
    { "code": 0, "msg": "success", "data": { "result": [...] } }
    """
    try:
        # 豆包客户端为同步接口，放到线程池避免阻塞事件循环
        results: List[Dict[str, Any]] = await asyncio.to_thread(
            recognize_dish_by_vision, image_base64=image, top_num=top_num
        )
        return {
            "code": 0,
            "msg": "success",
            "data": {
                "result": results,
            },
        }
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
