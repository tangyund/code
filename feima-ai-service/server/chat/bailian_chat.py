# -*- coding: utf-8 -*-
"""轻断食问答（对齐 chat.py / knowledge_base_chat）"""
import json
from typing import List, Optional, Any

from fastapi import Body
from sse_starlette.sse import EventSourceResponse
from langchain_core.prompts import PromptTemplate
from langchain_core.output_parsers import StrOutputParser

from configs.model_config import LLM_MODELS, TEMPERATURE
from server.utils import get_ChatOpenAI, get_prompt_template
from server.chat.utils import history_to_str, messages_to_history
from server.db.repository import (
    ensure_conversation,
    create_message,
    update_message,
    list_messages,
)

CHAT_TYPE = "bailian_chat"


async def _build_history_from_db(conversation_id: str, history_len: int) -> List[dict]:
    if not conversation_id or history_len <= 0:
        return []
    messages = await list_messages(conversation_id, history_len)
    return messages_to_history(messages)


async def bailian_chat(
    query: str = Body(..., description="用户问题", examples=["什么是轻断食？"]),
    history: List[dict] = Body(
        [],
        description="历史对话 [{\"role\":\"user\",\"content\":\"...\"}, {\"role\":\"assistant\",\"content\":\"...\"}]",
    ),
    stream: bool = Body(False, description="是否流式输出"),
    model_name: str = Body(LLM_MODELS[0], description="模型名称"),
    temperature: float = Body(TEMPERATURE, description="采样温度"),
    max_tokens: Optional[int] = Body(None, description="最大 token 数"),
    conversation_id: str = Body("", description="会话 ID（为空则创建）"),
    conversation_name: str = Body("默认对话", description="会话名称"),
    user_id: str = Body("", description="用户 ID"),
    history_len: int = Body(0, description="从数据库读取历史的条数"),
):
    async def _iterator():
        conv_id = await ensure_conversation(
            conversation_id.strip() or None,
            user_id=user_id or None,
            conversation_name=conversation_name,
            chat_type=CHAT_TYPE,
        )
        message_id = await create_message(
            conv_id,
            CHAT_TYPE,
            query,
            metadata={"model_name": model_name},
        )

        history_payload: List[Any] = history or []
        if not history_payload and history_len > 0:
            history_payload = await _build_history_from_db(conv_id, history_len)
        history_str = history_to_str(history_payload) if history_payload else "（无历史对话）"

        model = get_ChatOpenAI(
            model_name=model_name,
            temperature=temperature,
            max_tokens=max_tokens,
        )
        prompt_template = get_prompt_template("bailian_chat", "default")
        prompt = PromptTemplate.from_template(prompt_template)

        chain = prompt | model | StrOutputParser()
        inputs = {"input": query, "history": history_str}

        if stream:
            chunks: List[str] = []
            async for chunk in chain.astream(inputs):
                chunks.append(chunk)
                yield json.dumps(
                    {
                        "text": chunk,
                        "conversation_id": conv_id,
                        "message_id": message_id,
                    },
                    ensure_ascii=False,
                )
            await update_message(message_id, response="".join(chunks))
        else:
            answer = await chain.ainvoke(inputs)
            await update_message(message_id, response=answer)
            yield json.dumps(
                {
                    "text": answer,
                    "conversation_id": conv_id,
                    "message_id": message_id,
                },
                ensure_ascii=False,
            )

    return EventSourceResponse(_iterator())


async def bailian_chat_stream(
    query: str = Body(..., description="用户问题"),
    history: List[dict] = Body([], description="历史对话"),
    model_name: str = Body(LLM_MODELS[0]),
    temperature: float = Body(TEMPERATURE),
    max_tokens: Optional[int] = Body(None),
    conversation_id: str = Body("", description="会话 ID"),
    conversation_name: str = Body("默认对话", description="会话名称"),
    user_id: str = Body("", description="用户 ID"),
    history_len: int = Body(0, description="从数据库读取历史条数"),
):
    """流式问答（固定 stream=True）"""
    return await bailian_chat(
        query=query,
        history=history,
        stream=True,
        model_name=model_name,
        temperature=temperature,
        max_tokens=max_tokens,
        conversation_id=conversation_id,
        conversation_name=conversation_name,
        user_id=user_id,
        history_len=history_len,
    )
