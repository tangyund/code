# -*- coding: utf-8 -*-
"""数据库会话（与 Java 共用 MySQL）"""
from typing import AsyncGenerator

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import declarative_base
from configs.model_config import MYSQL_DSN, MYSQL_USER, MYSQL_PASSWORD

# 仅当配置了数据库时创建 engine
engine = None
async_session_factory = None
# 注意：有些环境 MySQL 允许空密码，这里不能简单用 `and MYSQL_PASSWORD` 判断，
# 否则空字符串会被当成「未配置」，导致完全不创建数据库连接。
print("[AI-DB] 初始化配置: MYSQL_DSN=", MYSQL_DSN, "MYSQL_USER=", MYSQL_USER, "MYSQL_PASSWORD(是否为None)=", MYSQL_PASSWORD is None)
if MYSQL_DSN and MYSQL_USER is not None and MYSQL_PASSWORD is not None:
    try:
        print("[AI-DB] 尝试创建异步引擎:", MYSQL_DSN)
        engine = create_async_engine(MYSQL_DSN, echo=False)
        async_session_factory = async_sessionmaker(
            engine, class_=AsyncSession, expire_on_commit=False
        )
        print("[AI-DB] 异步引擎和会话工厂创建成功")
    except Exception as e:
        # 如果创建失败，保持 async_session_factory = None，仓储层会优雅降级为不写库
        print("[AI-DB] 创建异步引擎失败:", repr(e))
        engine = None
        async_session_factory = None

Base = declarative_base()


async def get_async_session() -> AsyncGenerator[AsyncSession, None]:
    """获取异步数据库会话"""
    # 调试日志：观察当前是否已成功创建会话工厂
    print("[AI-DB] get_async_session 调用, async_session_factory 为 None?:", async_session_factory is None)
    if async_session_factory is None:
        print("[AI-DB] async_session_factory 为 None，返回空会话，不进行数据库读写")
        yield None
        return
    async with async_session_factory() as session:
        try:
            yield session
        except GeneratorExit:
            # 调用方提前结束迭代（例如 async for 中提前 return）时也执行一次提交
            try:
                await session.commit()
                print("[AI-DB] 会话提交成功（GeneratorExit 场景）")
            except Exception as e:
                print("[AI-DB] 会话提交失败（GeneratorExit 场景），准备回滚:", repr(e))
                await session.rollback()
                raise
            # 重新抛出以让上层正常结束生成器
            raise
        except Exception as e:
            print("[AI-DB] 会话提交失败，准备回滚:", repr(e))
            await session.rollback()
            raise
        else:
            # 正常完成迭代（无异常），提交事务
            await session.commit()
            print("[AI-DB] 会话提交成功")
        finally:
            await session.close()
            print("[AI-DB] 会话已关闭")
