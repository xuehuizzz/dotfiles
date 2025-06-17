**Vault 是由 HashiCorp 开发的一款开源的秘密管理工具（Secret Management Tool），主要用于安全地存储、管理和访问敏感信息，比如 API 密钥、密码、证书、加密密钥等** [官网地址](https://www.vaultproject.io/)

#### <mark>Vault 的主要功能包括:</mark>
- 安全存储秘密: 通过加密的方式保存敏感数据, 确保数据在存储和传输过程中都安全
- 动态生成凭证: 可以按需生成数据库账号、云平台访问令牌等临时凭证, 避免使用静态密码
- 访问控制: 通过策略（Policies）严格控制谁可以访问哪些秘密
- 审计日志: 记录访问和操作行为, 方便安全审计
- 加密即服务: 提供数据加密和解密的 API, 应用程序无需自行管理加密逻辑
- 密钥生命周期管理: 支持密钥的自动轮换和撤销

## 安装
```bash
# macos
brew tap hashicorp/tap
brew install hashicorp/tap/vault

# Ubuntu/Debian
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault

# Centos/RHEL
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install vault
```

# 启动服务
### <mark>开发模式启动</mark>
  ```bash
  # 登录地址为: http://127.0.0.1:8200
  # 登录token为: Root Token: xxxxxxxxxx
  vault server -dev
  ```
### <mark>生产启动</mark>
  1. 准备配置文件, 例如`/etc/vault.hcl`
     ```hcl
     # vault.hcl
     storage "file" {
       path = "/opt/vault/data"
     }
  
     listener "tcp" {
       address     = "0.0.0.0:8200"
       tls_disable = 1  # 设置为 0 表示开启 TLS（生产必须启用）
     }
  
     ui = true
     ```
  2. 启动vault:
     ```bash
     vault server -config=/etc/vault.hcl
     ```
  3. 初始化（只做一次）
     ```bash
     vault operator init
     ```
     输出内容中包含：
     - Unseal Key 1, Unseal Key 2 …（用于解封）
     - Initial Root Token
  4. 解封(至少输入 3 个 Unseal Key)
     ```bash
     vault operator unseal
     vault operator unseal
     vault operator unseal
     ```
  5. 登录
     ```bash
     vault login <initial-root-token>
     ```

### cli用法实例:
```bash
# 如果是以开发模式启动则输入一下命令设置 Vault地址为HTTP(临时解决)
export VAULT_ADDR=http://127.0.0.1:8200   # 或写入 .zshrc或.bashrc 中永久解决

# 登录 Vault（替换成你看到的 root token）
vault login <token>

# 启用 secrets engine 并写入密码
vault secrets enable -path=secret kv
# 写入MySQL用户名和密码
vault kv put secret/mysql/admin username="admin" password="admin"
# 查看写入是否成功
vault kv get secret/mysql/admin
# 获取单个字段
vault kv get -field=username secret/mysql/admin
vault kv get -field=password secret/mysql/admin
```

## 程序中使用(python)
假设已经通过cli写入了MySQL密码信息
```bash
vault kv put secret/mysql/admin username="admin" password="admin"
```
代码实例:
```python
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
```
