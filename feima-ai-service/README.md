# Feima AI Service

Feima-Cloud AI 模块的 Python + LangChain 实现，与原有 Java 实现并存。

## 目录结构

```
feima-ai-service/
├── configs/          # 配置
├── server/           # 服务层
│   ├── chat/         # 对话接口
│   ├── services/     # 业务逻辑
│   ├── db/           # 数据库
│   └── callback_handler/
├── requirements.txt
├── .env.example
└── startup.py
```

## 快速开始

```bash
cd feima-ai-service
python -m venv .venv
# Windows: .venv\Scripts\activate
# Linux/Mac: source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# 编辑 .env 填入 DASHSCOPE_API_KEY 等
python startup.py
```

访问 http://localhost:8000/docs 查看 API 文档。

## 接口

- `POST /api/fasting/question/bailian/chat` - 轻断食问答
- `POST /api/fasting/question/bailian/chat/stream` - 流式问答
- `POST /api/fasting/question/bailian/analyze` - 智能分析
- `POST /api/fasting/dish/recognize` - 餐品识别

## 待完善

- `server/db/repository/` 中 question、answer、recipe 仓储需对接 MySQL 或 Java 接口
- `server/services/ai_result_parser` 正则需按实际 AI 输出格式微调
