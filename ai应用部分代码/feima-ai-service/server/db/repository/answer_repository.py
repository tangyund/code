# -*- coding: utf-8 -*-
"""用户答题记录仓储（调用 Java API）"""
from typing import List, Dict, Any

from server.db.java_api_client import get
from server.db.repository.question_repository import get_enabled_questions


async def get_user_answers(user_id: int, recipe_source_type: str) -> List[Dict[str, Any]]:
    """获取用户答题记录，包含 question_title，并按当前场景过滤。"""
    try:
        questions = await get_enabled_questions(recipe_source_type)
        q_map = {q["tid"]: q["question_title"] for q in questions}
        allowed_ids = set(q_map.keys())
    except Exception:
        q_map = {}
        allowed_ids = set()

    try:
        data = await get(f"/api/fasting/question/answer/user/{user_id}")
    except Exception:
        return []

    raw = data.get("data") or []
    result = []
    for a in raw:
        qid = a.get("questionId")
        if qid not in allowed_ids:
            continue
        result.append({
            "tid": a.get("tid"),
            "question_id": qid,
            "question_title": q_map.get(qid, ""),
            "answer_content": a.get("answerContent", ""),
        })
    return result


async def get_options_by_question_ids(question_ids: List[int]) -> Dict[int, List[Dict[str, Any]]]:
    """根据问题 ID 列表获取选项。"""
    if not question_ids:
        return {}
    result = {}
    for qid in question_ids:
        try:
            data = await get(f"/api/fasting/question/option/question/{qid}")
            opts = data.get("data") or []
            result[qid] = [
                {"option_content": o.get("optionContent", ""), "option_value": o.get("optionValue", "")}
                for o in opts
            ]
        except Exception:
            result[qid] = []
    return result
