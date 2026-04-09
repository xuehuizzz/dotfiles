"""通用配置信息, 环境变量(安全增强版 v4)"""

import re
from enum import StrEnum
from functools import lru_cache
from pathlib import Path
from typing import Literal
from urllib.parse import quote_plus

from pydantic import BaseModel, SecretStr, ValidationInfo, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

# 弱密码
WEAK_PASSWORDS = frozenset(
    {
        "admin",
        "password",
        "123456",
        "root",
        "test",
        "changeme",
        "default",
        "",
    }
)
SSLMODE = Literal["disable", "require", "verify-ca", "verify-full"]


def is_strong_password(pwd: str) -> bool:
    """生产环境密码强度校验"""
    return (
        len(pwd) >= 8
        and re.search(r"[a-z]", pwd) is not None
        and re.search(r"[A-Z]", pwd) is not None
        and re.search(r"[0-9]", pwd) is not None
        and re.search(r"[^a-zA-Z0-9]", pwd) is not None
    )


# 环境定义
class Env(StrEnum):
    development = "development"
    production = "production"
    testing = "testing"


# Postgres数据库配置
class PostgresSettings(BaseModel):
    host: str = "localhost"
    port: int = 5432
    user: str = "admin"
    password: SecretStr = SecretStr("admin")
    db: str = "manus"
    driver: str = "postgresql+asyncpg"

    pool_size: int = 20
    max_overflow: int = 10
    pool_timeout: int = 30
    pool_recycle: int = 1800

    ssl_mode: SSLMODE = "disable"

    @property
    def uri(self) -> str:
        """安全拼接数据库 URI(自动 URL 编码)"""
        user = quote_plus(self.user)
        pwd = quote_plus(self.password.get_secret_value())
        return f"{self.driver}://{user}:{pwd}@{self.host}:{self.port}/{self.db}"

    @property
    def connect_args(self) -> dict:
        """
        SQLAlchemy create_engine 的 connect_args.
        asyncpg 期望 ssl=True / ssl.SSLContext,
        不能直接传字符串 "require".
        如需更精细的证书校验, 可升级为 ssl.create_default_context().
        """
        if self.ssl_mode == "disable":
            return {}
        return {"ssl": True}


# Redis 配置
class RedisSettings(BaseModel):
    host: str = "localhost"
    port: int = 6379
    db: int = 0
    username: str | None = None  # Redis 6+ ACL
    password: SecretStr | None = None
    max_connections: int = 10
    ssl: bool = False

    @property
    def url(self) -> str:
        """
        安全拼接 Redis URL.
        支持 Redis 6+ ACL: redis://user:password@host
        """
        scheme = "rediss" if self.ssl else "redis"

        if self.password:
            pwd = quote_plus(self.password.get_secret_value())
            user = quote_plus(self.username) if self.username else ""
            auth = f"{user}:{pwd}@"
        else:
            auth = ""

        return f"{scheme}://{auth}{self.host}:{self.port}/{self.db}"


# 主配置
class Settings(BaseSettings):
    """全局配置(frozen 防止运行时篡改)"""

    # ===== 基础配置 =====
    env: Env = Env.development
    log_level: str = "DEBUG"
    log_path: Path = Path("logs/app.log")

    # ===== 子配置 =====
    db: PostgresSettings = PostgresSettings()
    redis: RedisSettings = RedisSettings()

    # ===== 服务配置 =====
    server_host: str = "0.0.0.0"
    server_port: int = 8000

    # ===== Pydantic 配置 =====
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        extra="ignore",
        env_nested_delimiter="__",
        case_sensitive=False,
        frozen=True,  # 防止运行时修改
    )

    # =====================
    # 动态属性
    # =====================
    @property
    def is_dev(self) -> bool:
        return self.env == Env.development

    @property
    def is_prod(self) -> bool:
        return self.env == Env.production

    @property
    def is_testing(self) -> bool:
        return self.env == Env.testing

    @property
    def server_reload(self) -> bool:
        """开发环境自动热加载"""
        return self.is_dev

    @property
    def sqlalchemy_database_uri(self) -> str:
        return self.db.uri

    @property
    def redis_url(self) -> str:
        return self.redis.url

    # =====================
    # 字段校验
    # =====================
    @field_validator("db", mode="after")
    @classmethod
    def validate_db_in_prod(
        cls, v: PostgresSettings, info: ValidationInfo
    ) -> PostgresSettings:
        """生产环境：禁止弱密码 + 强制密码强度"""
        env = info.data.get("env")

        if env == Env.production:
            pwd = v.password.get_secret_value()

            if pwd in WEAK_PASSWORDS:
                raise ValueError(
                    "生产环境禁止使用弱数据库密码, 请通过环境变量 PGSQL__PASSWORD 配置强密码"
                )

            if not is_strong_password(pwd):
                raise ValueError(
                    "生产环境数据库密码强度不足, 要求: ≥8位, 包含大小写字母、数字和特殊字符"
                )

        return v

    # 安全输出
    def safe_dump(self) -> dict:
        """
        脱敏输出配置(用于日志).
        SecretStr 字段由 Pydantic v2 自动输出为 '**********'.
        """
        return self.model_dump()


@lru_cache
def get_settings() -> Settings:
    """获取全局配置单例"""
    return Settings()


def reset_settings() -> None:
    """清除配置缓存(测试用)"""
    get_settings.cache_clear()
