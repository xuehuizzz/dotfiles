# pip install cryptography

"""
AES-GCM 对称加密工具模块

AES-256-GCM 提供认证加密 (Authenticated Encryption), 同时保证:
  - 机密性 (Confidentiality): 数据被加密, 无法被窃听
  - 完整性 (Integrity): 数据被篡改后解密会失败
  - 真实性 (Authenticity): 可验证数据确实来自持有密钥的一方
"""

import base64
import logging
import os
from dataclasses import dataclass
from typing import Optional

from cryptography.exceptions import InvalidTag
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

logger = logging.getLogger(__name__)


# 常量
KEY_SIZE_128 = 16  # 128-bit
KEY_SIZE_192 = 24  # 192-bit
KEY_SIZE_256 = 32  # 256-bit (推荐)

NONCE_SIZE = 12  # 96-bit, GCM 推荐长度


@dataclass(frozen=True)
class AESGCMConfig:
    """AES-GCM 参数配置"""

    key_size: int = KEY_SIZE_256  # 密钥长度(字节)
    nonce_size: int = NONCE_SIZE  # nonce 长度(字节)

    def __post_init__(self):
        if self.key_size not in (KEY_SIZE_128, KEY_SIZE_192, KEY_SIZE_256):
            raise ValueError(
                f"Invalid key size: {self.key_size}. "
                f"Must be {KEY_SIZE_128}, {KEY_SIZE_192}, or {KEY_SIZE_256}"
            )
        if self.nonce_size < 12:
            raise ValueError("Nonce size must be at least 12 bytes")


class CryptoService:
    """
    AES-GCM 对称加密服务

    使用示例:
        # 生成密钥
        key = CryptoService.generate_key()

        # 创建实例
        svc = CryptoService(key=key)

        # 加密
        ciphertext = svc.encrypt("Hello, World!")

        # 解密
        plaintext = svc.decrypt(ciphertext)
        assert plaintext == "Hello, World!"

        # 带附加认证数据(AAD)
        ciphertext = svc.encrypt("secret", aad=b"user_id=123")
        plaintext = svc.decrypt(ciphertext, aad=b"user_id=123")

        # Base64 编码(适合存数据库或传输)
        token = svc.encrypt_to_base64("secret")
        plaintext = svc.decrypt_from_base64(token)

        # 从环境变量读取密钥
        svc = CryptoService.from_env()
    """

    def __init__(self, key: bytes, config: Optional[AESGCMConfig] = None):
        """
        Args:
            key: AES 密钥, 长度必须与 config.key_size 匹配
            config: 可选的配置
        """
        self._config = config or AESGCMConfig()

        if len(key) != self._config.key_size:
            raise ValueError(
                f"Key must be {self._config.key_size} bytes, got {len(key)}"
            )

        self._key = key
        self._aesgcm = AESGCM(self._key)

    @classmethod
    def generate_key(cls, key_size: int = KEY_SIZE_256) -> bytes:
        """
        生成密码学安全的随机密钥

        Args:
            key_size: 密钥长度 (字节), 默认 32(256-bit)

        Returns:
            随机密钥 bytes
        """
        return AESGCM.generate_key(bit_length=key_size * 8)

    @classmethod
    def from_env(
        cls,
        env_key: str = "AES_GCM_KEY",
        config: Optional[AESGCMConfig] = None,
    ) -> "CryptoService":
        """
        从环境变量创建实例, 密钥以 hex 编码存储

        Raises:
            RuntimeError: 环境变量未设置
        """
        key_hex = os.environ.get(env_key)
        if not key_hex:
            raise RuntimeError(
                f"Environment variable '{env_key}' is not set. "
                f'Generate one with: python -c "from cryptography.hazmat.primitives.ciphers.aead import AESGCM; print(AESGCM.generate_key(256).hex())"'
            )
        try:
            key = bytes.fromhex(key_hex)
        except ValueError:
            raise RuntimeError(f"Environment variable '{env_key}' is not valid hex") from None
        return cls(key=key, config=config)

    def _generate_nonce(self) -> bytes:
        """生成随机 nonce"""
        return os.urandom(self._config.nonce_size)

    # 核心加解密(bytes 级别)
    def encrypt_bytes(
        self,
        plaintext: bytes,
        aad: Optional[bytes] = None,
    ) -> bytes:
        """
        加密原始字节

        返回格式: nonce (12B) || ciphertext || tag (16B)
        nonce 前置拼接, 解密时自动拆分

        Args:
            plaintext: 待加密数据
            aad: 附加认证数据, 不会被加密但会被认证(篡改后解密失败)

        Returns:
            nonce + 密文 + tag 的拼接
        """
        if plaintext is None:
            raise ValueError("Plaintext cannot be None")

        nonce = self._generate_nonce()
        ciphertext = self._aesgcm.encrypt(nonce, plaintext, aad)
        # ciphertext 已包含 16 字节 GCM tag
        return nonce + ciphertext

    def decrypt_bytes(
        self,
        data: bytes,
        aad: Optional[bytes] = None,
    ) -> bytes:
        """
        解密原始字节

        Args:
            data: encrypt_bytes 的输出(nonce + ciphertext + tag)
            aad: 加密时使用的附加认证数据, 必须与加密时一致

        Returns:
            明文 bytes

        Raises:
            ValueError: 数据太短或格式错误
            InvalidTag: 密钥错误、数据被篡改、或 AAD 不匹配
        """
        if data is None or len(data) < self._config.nonce_size + 16:
            raise ValueError(
                f"Encrypted data too short. "
                f"Minimum length: {self._config.nonce_size + 16} bytes"
            )

        nonce = data[: self._config.nonce_size]
        ciphertext = data[self._config.nonce_size :]
        return self._aesgcm.decrypt(nonce, ciphertext, aad)

    def encrypt(
        self,
        plaintext: str,
        aad: Optional[bytes] = None,
        encoding: str = "utf-8",
    ) -> bytes:
        """加密字符串, 返回 bytes"""
        return self.encrypt_bytes(plaintext.encode(encoding), aad)

    def decrypt(
        self,
        data: bytes,
        aad: Optional[bytes] = None,
        encoding: str = "utf-8",
    ) -> str:
        """解密为字符串"""
        return self.decrypt_bytes(data, aad).decode(encoding)

    def encrypt_to_base64(
        self,
        plaintext: str,
        aad: Optional[bytes] = None,
        encoding: str = "utf-8",
        urlsafe: bool = True,
    ) -> str:
        """
        加密字符串, 返回 Base64 编码的密文

        Args:
            plaintext: 待加密字符串
            aad: 附加认证数据
            encoding: 字符串编码
            urlsafe: 是否使用 URL 安全的 Base64(默认 True)

        Returns:
            Base64 编码的密文字符串
        """
        raw = self.encrypt(plaintext, aad, encoding)
        if urlsafe:
            return base64.urlsafe_b64encode(raw).decode("ascii")
        return base64.b64encode(raw).decode("ascii")

    def decrypt_from_base64(
        self,
        token: str,
        aad: Optional[bytes] = None,
        encoding: str = "utf-8",
        urlsafe: bool = True,
    ) -> str:
        """
        解密 Base64 编码的密文, 返回明文字符串

        Args:
            token: Base64 编码的密文
            aad: 加密时使用的附加认证数据
            encoding: 字符串编码
            urlsafe: 是否使用 URL 安全的 Base64(默认 True)

        Returns:
            明文字符串
        """
        try:
            raw = base64.urlsafe_b64decode(token) if urlsafe else base64.b64decode(token)
        except Exception as e:
            raise ValueError(f"Invalid Base64 input: {e}")
        return self.decrypt(raw, aad, encoding)


# 全局单例
_default_service: Optional[CryptoService] = None


def get_crypto_service() -> CryptoService:
    """获取全局单例，首次调用时从环境变量初始化"""
    global _default_service
    if _default_service is None:
        _default_service = CryptoService.from_env()
    return _default_service


def init_crypto_service(key: bytes, config: Optional[AESGCMConfig] = None) -> None:
    """手动初始化全局单例"""
    global _default_service
    _default_service = CryptoService(key=key, config=config)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)

    # 生成密钥
    key = CryptoService.generate_key()
    print("Generated Key (hex):", key.hex())
    print("Key Length:", len(key), "bytes /", len(key) * 8, "bits")
    print()

    svc = CryptoService(key=key)

    # --- 基本加解密 ---
    msg = "Hello, AES-GCM! 你好世界 🔐"
    encrypted = svc.encrypt(msg)
    decrypted = svc.decrypt(encrypted)
    print("Original: ", msg)
    print("Encrypted:", encrypted.hex())
    print("Decrypted:", decrypted)
    print("Match:    ", msg == decrypted)
    print()

    # --- Base64 加解密 ---
    token = svc.encrypt_to_base64(msg)
    decrypted_b64 = svc.decrypt_from_base64(token)
    print("Base64 Token:", token)
    print("Decrypted:   ", decrypted_b64)
    print("Match:       ", msg == decrypted_b64)
    print()

    # --- 带 AAD ---
    aad = b"user_id=42&action=transfer"
    encrypted_aad = svc.encrypt("sensitive data", aad=aad)
    decrypted_aad = svc.decrypt(encrypted_aad, aad=aad)
    print("With AAD Decrypted:", decrypted_aad)

    # AAD 不匹配 -> 解密失败
    try:
        svc.decrypt(encrypted_aad, aad=b"tampered_aad")
    except InvalidTag:
        print("AAD mismatch caught: InvalidTag ✓")
    print()

    # --- 篡改检测 ---
    tampered = bytearray(encrypted)
    tampered[-1] ^= 0xFF  # 篡改最后一个字节
    try:
        svc.decrypt(bytes(tampered))
    except InvalidTag:
        print("Tamper detected: InvalidTag ✓")

    # --- 错误密钥 ---
    wrong_key = CryptoService.generate_key()
    svc_wrong = CryptoService(key=wrong_key)
    try:
        svc_wrong.decrypt(encrypted)
    except InvalidTag:
        print("Wrong key detected: InvalidTag ✓")
    print()

    # --- 每次加密结果不同（nonce 随机）---
    enc1 = svc.encrypt("same message")
    enc2 = svc.encrypt("same message")
    print("Same plaintext, different ciphertext:", enc1 != enc2, "✓")

    # --- 空字符串 ---
    enc_empty = svc.encrypt("")
    dec_empty = svc.decrypt(enc_empty)
    print("Empty string round-trip:", dec_empty == "", "✓")
