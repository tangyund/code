# -*- coding: utf-8 -*-
"""路由定义（与 hw-chat 风格一致）"""
from fastapi import FastAPI


def mount_app_routes(app: FastAPI) -> None:
    """挂载 Feima AI 相关路由"""
    from server.chat.bailian_chat import bailian_chat, bailian_chat_stream
    from server.chat.bailian_analyze import bailian_analyze
    from server.chat.dish_recognize import dish_recognize

    app.post(
        "/api/fasting/question/bailian/chat",
        tags=["Bailian"],
        summary="轻断食问答",
    )(bailian_chat)

    app.post(
        "/api/fasting/question/bailian/chat/stream",
        tags=["Bailian"],
        summary="流式轻断食问答",
    )(bailian_chat_stream)

    app.post(
        "/api/fasting/question/bailian/analyze",
        tags=["Bailian"],
        summary="智能分析",
    )(bailian_analyze)

    app.post(
        "/api/fasting/dish/recognize",
        tags=["Dish"],
        summary="餐品识别",
    )(dish_recognize)
