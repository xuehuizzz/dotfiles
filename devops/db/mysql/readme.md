### docker安装
```bash
# 创建一个名为`mysql`的容器, 并为root用户配置密码: `admin`, 新建用户/密码: admin, 默认host: %
# /Users/xuehuizzz/db/mysql/data:/app/data  数据持久化
# -v /Users/xuehuizzz/db/mysql/conf/my.cnf:/etc/mysql/my.cnf  映射自定义MySQL配置文件
# -v /Users/xuehuizzz/db/mysql/logs:/var/log/mysql 可以在宿主机直接查看日志
# 执行命令前先创建 /Users/xuehuizzz/db/mysql/conf/my.cnf 文件, 因为docker只会自动创建目录而不是文件

docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=admin \
  -e MYSQL_USER=admin \
  -e MYSQL_PASSWORD=admin \
  -e MYSQL_DATABASE=mydb \
  -v /Users/xuehuizzz/db/mysql/data:/app/data \
  -v /Users/xuehuizzz/db/mysql/conf/my.cnf:/etc/mysql/my.cnf \
  -v /Users/xuehuizzz/db/mysql/logs:/var/log/mysql \
  -p 3306:3306 \
  -w /app \
  --restart always \
  mysql:8.4
```

## 常用函数
```mysql
select INET_ATON('192.168.3.100')    -- 将IPv4地址转换为 无符号32位整数
select INET_NTOA(3232236388)      -- 将一个无符号32位整数, 转换回对应的IPv4地址
```

## 命令行工具-mysql
```bash
# `mycli` 第三方命令行工具

# 使用命令行工具访问数据库的时候, 如果不显示中文, 如下操作可解决
mysql -u root -p --default-character-set=utf8mb4  # 在连接的时候指定字符集
set names utf8mb4;  # 在已经连接到会话中修改


```
