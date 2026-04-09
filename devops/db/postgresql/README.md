### 安装
```bash
# 使用Docker安装
docker run -d \
  --name psql \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin \
  -e POSTGRES_DB=mydb \
  -v /Users/xuehuizzz/db/postgresql:/app \
  -p 5432:5432 \
  --restart always \
  postgres:15

# install by brew for mac
brew install postgresql    # 安装
brew services start postgresql   # 启动服务
createdb db_name  # 新建数据库
psql db_name   # 连接到已存在的数据库
CREATE USER myuser WITH PASSWORD 'mypassword';    # 连接到数据库后创建用户
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;   # 为新用户授予访问特定数据库的权限
```

### 配置用户密码及远程连接
```bash
# 以cli方式连接postgresql
sudo -u postgres psql

# 列出用户信息
postgres=# \du
# 设置用户postgres密码
postgres=# ALTER USER postgres WITH PASSWORD 'your_secure_password';
# 退出psql
postgres=# \q


# 在配置文件 pg_hba.conf 中新增如下配置:
host    all             all             xxx.xxx.xxx.xxx/32           md5
```
> `host`: 表示该规则适用于TCP/IP连接(不是本地socket)
>
> `all(database)`: 允许访问任意数据库
>
> `all(user)`: 允许任意PostgreSQL用户连接
>
> `xxx.xxx.xxx.xxx/32`: 仅允许指定IP地址的主机访问
>
> `md5`: 要求客户端使用**用户名+密码经MD5哈希**方式认证

<mark>注意: </mark> 修改后再 `SELECT pg_reload_conf();` 生效.
