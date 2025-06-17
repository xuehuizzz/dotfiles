# pip install hvac
import hvac
from typing import Optional


class VaultClient:
    def __init__(
        self,
        url: str,
        token: str,
        mount_point: str = "secret",
    ):
        self.client = hvac.Client(url=url, token=token)
        self.mount_point = mount_point

        if not self.client.is_authenticated():
            raise ConnectionError("Vault authentication failed")

    def get_kv_v2_secret(
        self,
        path: str,
        field: Optional[str] = None,
        raise_on_deleted_version: bool = True,
    ) -> Optional[str | dict]:
        """
        读取 KV v2 类型的 secret。

        :param path: 密文路径，如 'mysql/admin'
        :param field: 可选，指定要返回的字段，如 'username'，否则返回整个 data dict
        :param raise_on_deleted_version: 是否在已删除的版本上抛出异常(默认 True)
        :return: 字段值 或 所有字段 dict, 找不到则返回 None
        """
        try:
            secret = self.client.secrets.kv.v2.read_secret_version(
                path=path,
                mount_point=self.mount_point,
                raise_on_deleted_version=raise_on_deleted_version,
            )
            data = secret["data"]["data"]
            return data.get(field) if field else data
        except hvac.exceptions.InvalidPath:
            return None
        except Exception as e:
            raise RuntimeError(f"Failed to read secret: {e}")


if __name__ == "__main__":
    # 替换为你自己的 Vault 地址和 token
    vault = VaultClient(
        url="http://127.0.0.1:8200",
        token="",  # dev 模式下可复制 root token
    )

    # 获取整个密文
    creds = vault.get_kv_v2_secret("mysql/admin")
    print("所有字段:", creds)

    # 获取单个字段
    username = vault.get_kv_v2_secret("mysql/admin", field="username")
    print("用户名:", username)

    password = vault.get_kv_v2_secret("mysql/admin", field="password")
    print("密码:", password)
