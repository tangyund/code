# -*- coding: utf-8 -*-
"""问题配置仓储（调用 Java API）"""
from typing import List, Dict, Any

from server.db.java_api_client import get


# 问题类型映射
QUESTION_TYPE_MAP = {
    1: "单选",
    2: "多选",
    3: "数值",
    4: "时间",
    5: "文本",
}


async def get_enabled_questions(recipe_source_type: str) -> List[Dict[str, Any]]:
    """获取启用的问题列表（按 sort_order 排序）。按 recipe_source_type 过滤场景。"""
    try:
        data = await get("/api/fasting/question/enabled")
    except Exception:
        return []

    raw = data.get("data") or []
    if not raw:
        return []

    # 按 Java BailianAnalyzeServiceImpl 逻辑过滤场景
    is_custom = recipe_source_type in ("User_Sel_Recipe", "AI_CUSTOM_RECIPE")
    if is_custom:
        filtered = [
            q for q in raw
            if q.get("questionScene") in ("RECIPE", "INITIAL")
        ]
    else:
        filtered = [
            q for q in raw
            if q.get("questionScene") in (None, "", "INITIAL")
        ]

    result = []
    for q in filtered:
        opts = q.get("options") or []
        result.append({
            "tid": q.get("tid"),
            "question_title": q.get("questionTitle", ""),
            "question_type": q.get("questionType"),
            "question_type_name": QUESTION_TYPE_MAP.get(q.get("questionType"), "文本"),
            "options": [
                {
                    "tid": o.get("tid"),
                    "option_content": o.get("optionContent", ""),
                    "option_value": o.get("optionValue", ""),
                }
                for o in opts
            ],
        })
    return result
