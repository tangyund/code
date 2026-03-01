# -*- coding: utf-8 -*-
"""History、辅助函数"""
from pydantic import BaseModel, Field
from typing import List, Union, Dict, Any


class History(BaseModel):
    """对话历史，与 hw-chat 一致的 role/content 结构"""
    role: str = Field(..., description="user 或 assistant")
    content: str = Field(..., description="消息内容")

    @classmethod
    def from_dict(cls, d: Dict[str, Any]) -> "History":
        return cls(role=d.get("role", "user"), content=d.get("content", ""))


def history_to_str(history: List[Union[History, Dict]]) -> str:
    """将历史对话列表转为字符串"""
    if not history:
        return ""
    lines = []
    for h in history:
        if isinstance(h, dict):
            lines.append(f"{h.get('role', 'user')}: {h.get('content', '')}")
        else:
            lines.append(f"{h.role}: {h.content}")
    return "\n".join(lines)


def messages_to_history(messages: List[Any]) -> List[Dict[str, str]]:
    """将数据库消息记录转换为 role/content 列表"""
    history: List[Dict[str, str]] = []
    for message in messages or []:
        query = getattr(message, "query", None)
        response = getattr(message, "response", None)
        if query:
            history.append({"role": "user", "content": query})
        if response:
            history.append({"role": "assistant", "content": response})
    return history
