# -*- coding: utf-8 -*-
"""会话与消息仓储"""
from __future__ import annotations

import uuid
from typing import List, Optional

from sqlalchemy import select, desc

from server.db.session import get_async_session
from server.db.models import ConversationModel, MessageModel


async def ensure_conversation(
    conversation_id: Optional[str],
    user_id: Optional[str],
    conversation_name: Optional[str],
    chat_type: str,
) -> str:
    """确保会话存在，返回会话ID"""
    conv_id = conversation_id or str(uuid.uuid4())

    async for session in get_async_session():
        if session is None:
            return conv_id
        conversation = await session.get(ConversationModel, conv_id)
        if conversation is None:
            conversation = ConversationModel(
                id=conv_id,
                user_id=user_id,
                name=conversation_name or "AI 对话",
                chat_type=chat_type,
            )
            session.add(conversation)
        return conv_id


async def create_message(
    conversation_id: str,
    chat_type: str,
    query: str,
    response: str = "",
    metadata: Optional[dict] = None,
) -> str:
    """创建消息记录"""
    msg_id = str(uuid.uuid4())
    async for session in get_async_session():
        if session is None:
            return msg_id
        message = MessageModel(
            id=msg_id,
            conversation_id=conversation_id,
            chat_type=chat_type,
            query=query,
            response=response or "",
            meta_data=metadata or {},
        )
        session.add(message)
        return msg_id


async def update_message(
    message_id: str,
    response: Optional[str] = None,
    metadata: Optional[dict] = None,
) -> None:
    """更新消息内容"""
    async for session in get_async_session():
        if session is None:
            return
        message = await session.get(MessageModel, message_id)
        if message is None:
            return
        if response is not None:
            message.response = response
        if metadata:
            current_meta = message.meta_data or {}
            current_meta.update(metadata)
            message.meta_data = current_meta
        session.add(message)
        return


async def list_messages(conversation_id: str, limit: int = 10) -> List[MessageModel]:
    """获取最近的消息"""
    if not conversation_id:
        return []
    async for session in get_async_session():
        if session is None:
            return []
        stmt = (
            select(MessageModel)
            .where(MessageModel.conversation_id == conversation_id)
            .where(MessageModel.response != "")
            .order_by(desc(MessageModel.create_time))
            .limit(max(limit, 0))
        )
        result = await session.execute(stmt)
        messages = list(result.scalars())
        messages.reverse()
        return messages
    return []
