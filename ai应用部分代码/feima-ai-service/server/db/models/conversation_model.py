# -*- coding: utf-8 -*-
"""Conversation ORM model"""
import uuid
from sqlalchemy import Column, String, DateTime, ForeignKey
from sqlalchemy.dialects.mysql import CHAR
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship

from server.db.session import Base


class ConversationModel(Base):
    """会话模型"""

    __tablename__ = "conversation"

    id = Column(
        CHAR(36),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        comment="会话ID",
    )
    user_id = Column(String(32), comment="用户ID")
    name = Column(String(50), comment="对话框名称")
    chat_type = Column(String(50), comment="聊天类型")
    create_time = Column(DateTime, default=func.now(), comment="创建时间")

    messages = relationship(
        "MessageModel",
        back_populates="conversation",
        cascade="all, delete-orphan",
    )

    def __repr__(self) -> str:
        return f"<Conversation(id='{self.id}', name='{self.name}', chat_type='{self.chat_type}')>"
