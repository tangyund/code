# -*- coding: utf-8 -*-
"""get_ChatOpenAI、get_prompt_template、wrap_done"""
import asyncio
import logging
from typing import List, Optional, Any

from langchain_openai import ChatOpenAI

from configs.model_config import ONLINE_LLM_MODEL, LLM_MODELS

logger = logging.getLogger(__name__)


def get_ChatOpenAI(
    model_name: str = None,
    temperature: float = 0.7,
    max_tokens: Optional[int] = None,
    streaming: bool = True,
    callbacks: Optional[List] = None,
    **kwargs: Any,
) -> ChatOpenAI:
    """创建 ChatOpenAI 实例，对接 DashScope OpenAI 兼容接口"""
    if model_name is None:
        model_name = LLM_MODELS[0]
    config = ONLINE_LLM_MODEL.get(model_name, {})
    return ChatOpenAI(
        streaming=streaming,
        callbacks=callbacks or [],
        openai_api_key=config.get("api_key", "EMPTY"),
        openai_api_base=config.get("api_base_url"),
        model_name=config.get("model_name", model_name),
        temperature=temperature,
        max_tokens=max_tokens,
        **kwargs,
    )


def get_prompt_template(template_type: str, name: str) -> str:
    """从 prompt_config 加载模板内容"""
    from configs import prompt_config
    return prompt_config.PROMPT_TEMPLATES.get(template_type, {}).get(name, "")


async def wrap_done(fn, event: asyncio.Event) -> None:
    """包装 awaitable，完成后设置 event"""
    try:
        await fn
    except Exception as e:
        logger.exception(e)
    finally:
        event.set()
