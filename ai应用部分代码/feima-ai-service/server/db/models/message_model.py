# -*- coding: utf-8 -*-
"""Message ORM model"""
import uuid
from sqlalchemy import Column, String, DateTime, Integer, JSON, ForeignKey
from sqlalchemy.dialects.mysql import CHAR
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship

from server.db.session import Base


class MessageModel(Base):
    """聊天记录模型"""

    __tablename__ = "message"

    id = Column(
        CHAR(36),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        comment="消息ID",
    )
    conversation_id = Column(
        CHAR(36), ForeignKey("conversation.id"), comment="会话ID"
    )
    chat_type = Column(String(50), comment="聊天类型")
    query = Column(String(4096), comment="用户问题")
    response = Column(String(4096), comment="模型回答")
    meta_data = Column(JSON, default=dict, comment="附加信息")
    feedback_score = Column(Integer, default=-1, comment="用户评分")
    feedback_reason = Column(String(255), default="", comment="评分理由")
    create_time = Column(DateTime, default=func.now(), comment="创建时间")

    conversation = relationship("ConversationModel", back_populates="messages")

    def __repr__(self) -> str:
        return f"<Message(id='{self.id}', conversation_id='{self.conversation_id}')>"
