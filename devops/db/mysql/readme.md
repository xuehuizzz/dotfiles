<mark>**注意**</mark>:
> 分页查询必须使用**ORDER BY**, 这是确保分页结果一致性的唯一可靠方法

## 备份与恢复
```bash
# 备份脚本见: mysql_backup.sh,  恢复脚本见: mysql_restore.sh

# 备份
bash mysql_backup.sh    # 备份所有数据库信息
bash mysql_backup.sh -d dbname  # 指定备份数据库信息
bash mysql_backup.sh -d dbname -t tablename  # 指定备份单张表所有信息, 结构,数据,触发器

# 恢复, 直接指定文件
# mydb_20250405_150344.tar.gz  即恢复 mydb 数据库的所有信息
# mydb.students_20250405_142438.tar.gz  即恢复数据库 mydb 下的表 students 的信息
# -s xxx.tar.gz 只恢复结构,  -d xxx.tar.gz 只恢复数据
bash mysql_restore.sh xxx.tar.gz  
```

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
  -v /Users/xuehuizzz/db/mysql/data/:/var/lib/mysql/ \
  -v /Users/xuehuizzz/db/mysql/conf/my.cnf:/etc/my.cnf \
  -v /Users/xuehuizzz/db/mysql/logs/:/var/log/mysql/ \
  -p 3306:3306 \
  --restart always \
  mysql:8.4.3
```

## <mark>实用触发器推荐</mark><sub>只能对单表配置</sub>
```sql
-- 修改数据时自动更新时间戳(没有显式修改updated_at时才会触发), 以显式声明的优先
-- 任何方式更新都会生效(直接执行SQL语句、通过orm框架、通过数据库管理工具修改)
DELIMITER //
CREATE TRIGGER before_update_timestamp
BEFORE UPDATE ON students
FOR EACH ROW
BEGIN
    IF NEW.updated_at = OLD.updated_at THEN 
        SET NEW.updated_at = CURRENT_TIMESTAMP;
    END IF;
END;//
DELIMITER ;

-- 级联删除, 无需外键约束
DELIMITER //
CREATE TRIGGER cascade_delete_order
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    DELETE FROM order_details WHERE order_id = OLD.id;
END;//
DELIMITER ;
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

