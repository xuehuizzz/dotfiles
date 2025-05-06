# mysql_config_editor 命令介绍
**`mysql_config_editor`** 是包含在 MySQL 客户端工具 **`mysql-client`** 中的一个实用程序，用来安全地存储和加密 MySQL 客户端连接所需的敏感信息，比如用户名和密码。
它将这些加密后的信息保存在 ~/.mylogin.cnf 文件中，供 mysql、mysqldump 等命令行工具使用，避免明文密码出现在 my.cnf 文件或脚本中

# .mylogin.cnf 文件介绍
.mylogin.cnf 是 MySQL 客户端的登录路径文件，它用于安全地存储 MySQL 连接凭据（如用户名、密码、主机等），这样你就不需要在命令行中明文输入这些敏感信息。

## 主要特点
1. 文件是加密的，提供了比在命令行中输入密码更安全的方式
2. 通常存储在用户的主目录下
3. 可以存储多组连接信息，方便连接不同的 MySQL 服务器


# <mark>如何使用</mark>
```bash
# 初次会生成 .mylogin.cnf 文件, 并存入加密后的登录信息
# 这个命令会提示你输入密码, 这个密码就是指定用户的密码
mysql_config_editor set --login-path=local --host=localhost --user=root --password

# 查看已保存的登录信息
mysql_config_editor print --all

# 使用登录路径连接MySQL
mysql --login-path=local

# 指定删除登录路径
mysql_config_editor remove --login-path=local
```
> 示例: 添加一个开发环境的用户登录信息, 用户名为: dev, 登录路径为: dev_venv
> 
> mysql_config_editor set --login-path=dev_venv --host=xxx.xxx.xxx.xxx --user=dev --password
>
> 用开发环境的用户连接MySQL
>
> mysql --login-path=dev_venv
>
> 删除开发环境的登录信息
>
> mysql_config_editor remove --login-path=dev_venv
