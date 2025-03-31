### docker安装
```bash
# 默认用户: root, 密码为空, 最高权限
docker run -d \
  --name mysql \
  -e MYSQL_ROOT_PASSWORD=admin \
  -e MYSQL_USER=admin \
  -e MYSQL_PASSWORD=admin \
  -e MYSQL_DATABASE=mydb \
  -v /Users/xuehuizzz/db/mysql:/app \
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
set name utf8mb4;  # 在已经连接到会话中修改


```
