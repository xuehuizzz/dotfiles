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


