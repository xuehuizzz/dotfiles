### install for mac

```bash
brew install postgresql    # 安装
brew services start postgresql   # 启动服务
createdb db_name  # 新建数据库
psql db_name   # 连接到已存在的数据库
CREATE USER myuser WITH PASSWORD 'mypassword';    # 连接到数据库后创建用户
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;   # 为新用户授予访问特定数据库的权限
```
