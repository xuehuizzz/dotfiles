"""AES-GCM 对称加密工具(工程化版本).
pip install cryptography


本模块用于对敏感配置(如数据库密码、API Token 等)进行
安全、可验证、可扩展的对称加密与解密。

核心设计目标
-----------
1. 使用 AES-256-GCM
   - 提供机密性(Confidentiality)
   - 提供完整性与篡改检测(Authenticated Encryption)
   - 解密失败即意味着密钥错误或数据被修改

2. 主密钥不直接用于加密
   - 通过 HKDF(SHA-256) 从主密钥派生实际 AES 密钥
   - 不同用途通过不同 context / AAD 实现密钥隔离

3. 支持附加认证数据(AAD)
   - AAD 不加密，但参与认证
   - 可用于绑定用途、业务类型或数据版本
   - 防止密文被复制到错误场景中仍然可解密

4. 内置版本号
   - 密文格式包含版本前缀
   - 便于未来算法、参数或格式升级

密文格式
--------
Base64(urlsafe) 编码后的二进制数据，结构如下：

    +---------+---------+--------------------+
    | Version |  Nonce  |   Ciphertext+Tag   |
    +---------+---------+--------------------+
      1 byte   12 bytes       variable

- Version: 当前实现固定为 0x01
- Nonce: 随机生成,AES-GCM 推荐 12 字节
- Ciphertext+Tag: AES-GCM 输出（含认证标签）

安全注意事项
-----------
- 主密钥(master_key)必须妥善保管, 推荐来源：
  - 环境变量
  - KMS(AWS KMS / GCP KMS / Azure Key Vault)
  - HashiCorp Vault
- 严禁将主密钥硬编码到仓库中
- 不要复用同一 nonce (本实现每次随机生成)
- AAD 必须在加密和解密时完全一致，否则解密会失败

适用场景
--------
- 数据库连接密码加密存储
- 配置文件中的敏感字段保护
- 内部系统的密钥托管与透明解密

不适用场景
----------
- 用户密码存储（应使用 bcrypt / argon2 等慢哈希）
- 大文件流式加密（需分块处理）

示例
----
    encrypted = aes_encrypt(
        "SuperSecretPassword!",
        MASTER_KEY,
        aad=b"db-password"
    )

    plaintext = aes_decrypt(
        encrypted,
        MASTER_KEY,
        aad=b"db-password"
    )
"""


import base64
import os
from typing import Final

from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.hazmat.primitives.kdf.hkdf import HKDF

NONCE_LEN: Final = 12
VERSION: Final = b"\x01"  # 版本号，未来可扩展


def derive_key(master_key: bytes, *, context: bytes) -> bytes:
    """
    使用 HKDF 从主密钥派生 AES-256 密钥
    """
    if len(master_key) < 32:
        raise ValueError("Master key too short")

    hkdf = HKDF(
        algorithm=hashes.SHA256(),
        length=32,
        salt=None,
        info=context,
    )
    return hkdf.derive(master_key)


def aes_encrypt(
    plaintext: str,
    master_key: bytes,
    *,
    aad: bytes = b"db-password",
) -> str:
    aes_key = derive_key(master_key, context=aad)

    aesgcm = AESGCM(aes_key)
    nonce = os.urandom(NONCE_LEN)

    ciphertext = aesgcm.encrypt(
        nonce,
        plaintext.encode("utf-8"),
        aad,
    )

    payload = VERSION + nonce + ciphertext
    return base64.urlsafe_b64encode(payload).decode("ascii")


def aes_decrypt(
    ciphertext_b64: str,
    master_key: bytes,
    *,
    aad: bytes = b"db-password",
) -> str:
    try:
        payload = base64.urlsafe_b64decode(ciphertext_b64)
        version = payload[0:1]

        if version != VERSION:
            raise ValueError("Unsupported ciphertext version")

        nonce = payload[1 : 1 + NONCE_LEN]
        ciphertext = payload[1 + NONCE_LEN :]

        aes_key = derive_key(master_key, context=aad)
        aesgcm = AESGCM(aes_key)

        plaintext = aesgcm.decrypt(nonce, ciphertext, aad)
        return plaintext.decode("utf-8")

    except Exception as e:
        raise ValueError("Decrypt failed: invalid key or corrupted data") from e


if __name__ == "__main__":
    MASTER_KEY = b"0123456789abcdef0123456789abcdef"
    password = "xuehui"

    enc = aes_encrypt(password, MASTER_KEY)
    print("Encrypted:", enc)

    dec = aes_decrypt(enc, MASTER_KEY)
    print("Decrypted:", dec)
