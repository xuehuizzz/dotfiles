"""pgsql基础配置信息
pip install sqlalchemy asyncpg
"""

import asyncio
from contextlib import asynccontextmanager

from sqlalchemy import text
from sqlalchemy.ext.asyncio import (
    AsyncEngine,
    AsyncSession,
    async_sessionmaker,
    create_async_engine,
)

from .log_config import get_logger
logger = get_logger()


class Postgres:
    def __init__(self):
        self._engine: AsyncEngine | None = None
        self._session_factory: async_sessionmaker[AsyncSession] | None = None
        self._lock = asyncio.Lock()

    async def init(self) -> None:
        async with self._lock:
            # 1.判断是否已经创建引擎, 连上了则中断程序
            if self._engine is not None:
                logger.warning("Postgres引擎已经初始化, 无需重复操作")
                return

            try:
                # 2.创建异步引擎
                # 参数改为从环境变量获取
                self._engine = create_async_engine(
                    url="postgresql+asyncpg://admin:admin@localhost:5432/manus",
                    echo=self._setting.env == "development",
                    pool_size=20,
                    max_overflow=10,
                    pool_timeout=30,
                    pool_recycle=1800,  # 避免数据库端主动断开长时间空闲连接
                    pool_pre_ping=True,  # 从池中取连接前先 ping 一下，防止拿到已断开的连接
                )
                logger.info("正在初始化Postgres连接...")

                # 3.创建会话工厂
                self._session_factory = async_sessionmaker(
                    autocommit=False,
                    autoflush=False,
                    bind=self._engine,
                    expire_on_commit=False,
                )
                logger.info("会话工厂创建完毕...")

                # 4.连接Postgres并执行预操作
                async with self._engine.begin() as async_conn:
                    # 5.安装uuid扩展
                    await async_conn.execute(text('CREATE EXTENSION IF NOT EXISTS "pgcrypto";'))
                    logger.info("成功连接postgres并启用pgcrypto扩展")
            except Exception as e:
                logger.error("初始化连接失败: %s", e, exc_info=True)

    async def shutdown(self) -> None:
        async with self._lock:
            if self._engine:
                await self._engine.dispose()
                self._engine = None
                self._session_factory = None
                logger.info("Postgres连接关闭成功.")

    @asynccontextmanager
    async def get_session(self):
        session = self.session_factory()
        try:
            yield session
            await session.commit()
        except Exception:
            await session.rollback()
            raise
        finally:
            await session.close()

    @property
    def session_factory(self) -> async_sessionmaker[AsyncSession]:
        """返回已初始化的会话工厂"""
        if self._session_factory is None:
            raise RuntimeError("Postgres未初始化, 请初始化稍后重试")
        return self._session_factory


if __name__ == "__main__":
    """用法示例"""
    from sqlalchemy import text
    from sqlalchemy import select
    from manus.models import User  # 假设你有这个 ORM 模型
    postgres = Postgres()

    # 用法1: 原生sql
    async def get_user():
        async with postgres.get_session() as session:
            result = await session.execute(text("SELECT * FROM users WHERE id=:id"), {"id": 1})
            return result

    # 用法2: orm
    async def get_user_orm():
        async with postgres.get_session() as session:
            # 查询
            result = await session.execute(select(User).where(User.id == 1))
            user = result.scalar_one_or_none()

            # 新增
            new_user = User(name="xuehui")
            session.add(new_user)
