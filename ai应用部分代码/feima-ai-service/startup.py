# -*- coding: utf-8 -*-
"""启动入口"""
import argparse
import uvicorn

from configs.server_config import HOST, PORT


def main():
    parser = argparse.ArgumentParser(description="Feima AI Service")
    parser.add_argument("--host", type=str, default=HOST)
    parser.add_argument("--port", type=int, default=PORT)
    args = parser.parse_args()

    uvicorn.run(
        "server.main:app",
        host=args.host,
        port=args.port,
        reload=True,
    )


if __name__ == "__main__":
    main()
