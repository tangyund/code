# -*- coding: utf-8 -*-
"""FastAPI 入口"""
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from configs.server_config import HOST, PORT, CORS_ORIGINS
from server.api_router import mount_app_routes


def create_app() -> FastAPI:
    app = FastAPI(title="Feima AI Service", version="0.1.0")

    app.add_middleware(
        CORSMiddleware,
        allow_origins=CORS_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    mount_app_routes(app)
    return app


app = create_app()
