# -*- coding: utf-8 -*-
"""问卷组装、Prompt 构建、调用链"""
from typing import Optional

# 从 db 或 Java 接口获取问题、答案
# 当前为占位实现，后续对接 MySQL 或 HTTP 调用 feima-cloud
from server.db.repository.question_repository import get_enabled_questions
from server.db.repository.answer_repository import get_user_answers, get_options_by_question_ids


async def build_question_config(user_id: int, recipe_source_type: str) -> str:
    """构建问题配置信息文本"""
    questions = await get_enabled_questions(recipe_source_type)
    if not questions:
        return "（暂无问题配置）"

    lines = ["问题配置信息：\n"]
    for i, q in enumerate(questions, 1):
        lines.append(f"问题{i}：{q.get('question_title', '')}\n")
        lines.append(f"  - 问题类型：{q.get('question_type_name', '文本')}\n")
        if q.get("options"):
            lines.append("  - 选项列表：\n")
            for j, opt in enumerate(q["options"], 1):
                lines.append(f"    {j}. {opt.get('option_content', '')}（存储值：{opt.get('option_value', '')}）\n")
        lines.append("\n")
    return "".join(lines)


async def build_user_answers_text(user_id: int, recipe_source_type: str) -> str:
    """构建用户答案信息文本"""
    answers = await get_user_answers(user_id, recipe_source_type)
    if not answers:
        return "（用户尚未回答任何问题）"

    lines = ["用户答案信息：\n"]
    for a in answers:
        lines.append(f"{a.get('question_title', '')}：{a.get('answer_content', '')}\n")
    return "".join(lines)


async def extract_custom_days(user_id: int) -> Optional[int]:
    """从用户答案中提取「定制几天」"""
    answers = await get_user_answers(user_id, "User_Sel_Recipe")
    for a in answers:
        if "定制几天" in str(a.get("question_title", "")):
            try:
                val = int(str(a.get("answer_content", "1")).strip())
                if 1 <= val <= 7:
                    return val
            except ValueError:
                pass
    return None
