"""密码哈希工具模块
使用 Argon2id + HMAC-SHA-256 pepper 提供安全的密码哈希与验证功能

pip install argon2-cffi
"""

import os
import hmac
import hashlib
import logging
from dataclasses import dataclass
from argon2 import PasswordHasher, Type
from argon2.exceptions import (
    VerifyMismatchError,
    VerificationError,
    InvalidHashError,
)

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class Argon2Config:
    """Argon2 参数配置"""
    time_cost: int = 3          # 迭代次数
    memory_cost: int = 65536    # 内存开销 KB (64MB)
    parallelism: int = 4        # 并行线程数
    hash_len: int = 32          # 输出哈希长度（字节）
    type: Type = Type.ID        # Argon2id，兼顾抗侧信道和抗 GPU


class PasswordService:
    """
    密码哈希服务

    使用示例:
        # 基本用法
        svc = PasswordService(pepper=b"my-secret-key")

        hashed = svc.hash("mypassword")
        assert svc.verify("mypassword", hashed) is True
        assert svc.verify("wrong", hashed) is False

        # 从环境变量读取 pepper
        svc = PasswordService.from_env()

        # 自定义 Argon2 参数
        config = Argon2Config(time_cost=4, memory_cost=131072)
        svc = PasswordService(pepper=b"my-secret-key", config=config)
    """

    def __init__(self, pepper: bytes, config: Argon2Config | None = None):
        if not pepper:
            raise ValueError("Pepper cannot be empty")

        self._pepper = pepper
        self._config = config or Argon2Config()
        self._hasher = PasswordHasher(
            time_cost=self._config.time_cost,
            memory_cost=self._config.memory_cost,
            parallelism=self._config.parallelism,
            hash_len=self._config.hash_len,
            type=self._config.type,
        )

    @classmethod
    def from_env(
        cls,
        env_key: str = "PASSWORD_PEPPER",
        config: Argon2Config | None = None,
    ) -> "PasswordService":
        """
        从环境变量创建实例

        Args:
            env_key: 存储 pepper 的环境变量名
            config: 可选的 Argon2 参数配置

        Raises:
            RuntimeError: 环境变量未设置
        """
        pepper = os.environ.get(env_key)
        if not pepper:
            raise RuntimeError(
                f"Environment variable '{env_key}' is not set. "
                f"Generate one with: python -c \"import os; print(os.urandom(32).hex())\""
            )
        return cls(pepper=pepper.encode("utf-8"), config=config)

    def _normalize(self, password: str) -> str:
        """HMAC-SHA-256 预处理，引入 pepper 提供额外安全层"""
        return hmac.new(
            self._pepper,
            password.encode("utf-8"),
            hashlib.sha256,
        ).hexdigest()

    @staticmethod
    def _validate(password: str) -> None:
        """密码基础校验"""
        if not password or not password.strip():
            raise ValueError("Password cannot be empty or blank")

    def hash(self, password: str) -> str:
        """
        对明文密码进行哈希

        Args:
            password: 明文密码

        Returns:
            Argon2 哈希字符串，格式: $argon2id$v=19$m=65536,t=3,p=4$salt$hash

        Raises:
            ValueError: 密码为空
        """
        self._validate(password)
        return self._hasher.hash(self._normalize(password))

    def verify(self, password: str, hashed_password: str) -> bool:
        """
        验证明文密码是否与哈希匹配

        Args:
            password: 用户输入的明文密码
            hashed_password: 数据库中存储的哈希值

        Returns:
            True 匹配 / False 不匹配
        """
        if not password or not hashed_password:
            return False

        try:
            return self._hasher.verify(hashed_password, self._normalize(password))
        except VerifyMismatchError:
            return False
        except (VerificationError, InvalidHashError) as e:
            logger.error("Password verification error: %s", e)
            return False

    def needs_rehash(self, hashed_password: str) -> bool:
        """
        检查哈希是否需要重新生成（参数升级后旧哈希需要更新）

        用法: 登录成功后调用，若返回 True 则用新参数重新 hash 并更新数据库
        """
        return self._hasher.check_needs_rehash(hashed_password)


# ---------------------------------------------------------------------------
# 便捷的模块级单例，适合大多数项目直接使用
# ---------------------------------------------------------------------------
_default_service: PasswordService | None = None


def get_password_service() -> PasswordService:
    """
    获取全局单例，首次调用时从环境变量初始化

    在应用启动时确保 PASSWORD_PEPPER 环境变量已设置
    """
    global _default_service
    if _default_service is None:
        _default_service = PasswordService.from_env()
    return _default_service


def init_password_service(pepper: bytes, config: Argon2Config | None = None) -> None:
    """
    手动初始化全局单例（用于测试或不使用环境变量的场景）
    """
    global _default_service
    _default_service = PasswordService(pepper=pepper, config=config)


# ---------------------------------------------------------------------------
# 测试
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    # 直接实例化（开发/测试用）
    svc = PasswordService(pepper=b"test-pepper-do-not-use-in-production")

    pwd = "12345678"

    # 哈希
    hashed = svc.hash(pwd)
    print("Hashed Password:", hashed)

    # 验证 —— 正确密码
    print("Password Verified:", svc.verify(pwd, hashed))

    # 验证 —— 错误密码
    print("Wrong Password Verified:", svc.verify("wrong_password", hashed))

    # 检查是否需要 rehash
    print("Needs Rehash:", svc.needs_rehash(hashed))

    # 超长密码
    long_pwd = "a" * 1000
    hashed_long = svc.hash(long_pwd)
    print("Long Password Verified:", svc.verify(long_pwd, hashed_long))

    # 边界情况
    for invalid in ("", "   ", None):
        try:
            svc.hash(invalid)
        except (ValueError, TypeError) as e:
            print(f"Invalid password {invalid!r} caught: {e}")

    # 自定义参数
    custom_config = Argon2Config(time_cost=4, memory_cost=131072)
    svc_custom = PasswordService(pepper=b"another-pepper", config=custom_config)
    hashed_custom = svc_custom.hash(pwd)
    print("\nCustom config hash:", hashed_custom)
    print("Custom config verified:", svc_custom.verify(pwd, hashed_custom))

    # 旧参数的哈希在新实例中会被标记为 needs_rehash
    print("Old hash needs rehash (new config):", svc_custom.needs_rehash(hashed))
