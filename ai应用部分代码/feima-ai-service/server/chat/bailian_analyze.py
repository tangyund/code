# -*- coding: utf-8 -*-
"""智能分析（问卷 → 计划/餐谱）"""
from typing import Optional

from fastapi import Body, HTTPException
from pydantic import BaseModel

from configs.model_config import LLM_MODELS, TEMPERATURE
from server.utils import get_ChatOpenAI, get_prompt_template
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser

from server.services.analyze_service import (
    build_question_config,
    build_user_answers_text,
    extract_custom_days,
)
from server.services.ai_result_parser import parse_ai_result
from server.services.ai_recipe_import import import_recipe


class BailianAnalyzeRequest(BaseModel):
    """智能分析请求"""
    user_id: int
    session_id: Optional[str] = ""
    recipe_source_type: Optional[str] = ""


async def bailian_analyze(
    user_id: int = Body(..., description="用户ID"),
    session_id: str = Body("", description="会话ID"),
    recipe_source_type: str = Body("", description="食谱来源类型，如 User_Sel_Recipe、AI_CUSTOM_RECIPE"),
):

    try:
        # 1. 从 DB 获取问题、用户答案
        question_config = await build_question_config(user_id, recipe_source_type)
        user_answers = await build_user_answers_text(user_id, recipe_source_type)
        custom_days = await extract_custom_days(user_id) or 3

        if "(暂无问题配置)" in question_config:
            raise HTTPException(status_code=400, detail="系统中没有启用的问题配置")
        if "(用户尚未回答任何问题)" in user_answers:
            raise HTTPException(status_code=400, detail="用户尚未回答任何问题，无法进行分析")

        # 2. 选模板
        is_custom_recipe = recipe_source_type in ("User_Sel_Recipe", "AI_CUSTOM_RECIPE")
        tpl_type = "bailian_analyze_recipe" if is_custom_recipe else "bailian_analyze_plan"
        prompt_str = get_prompt_template(tpl_type, "default")
        prompt = PromptTemplate.from_template(prompt_str)

        # 3. 调用链
        model = get_ChatOpenAI(
            model_name=LLM_MODELS[0],
            temperature=TEMPERATURE,
            max_tokens=4000,
        )
        chain = prompt | model | StrOutputParser()
        result = await chain.ainvoke({
            "question_config": question_config,
            "user_answers": user_answers,
            "custom_days": custom_days,
        })

        analysis_text = str(result)

        # 4. 解析并导入
        recipe_data = parse_ai_result(analysis_text, custom_days)
        recipe_id = await import_recipe(recipe_data, user_id, recipe_source_type)

        return {
            "code": 200,
            "msg": "success",
            "data": {
                "session_id": session_id or f"session_{user_id}",
                "user_id": user_id,
                "answer_count": len(user_answers.split("\n")) if user_answers else 0,
                "analysis_result": analysis_text,
                "generated_recipe_id": recipe_id,
                "generated_plan_id": None,
            },
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
