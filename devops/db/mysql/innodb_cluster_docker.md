```bash
# 创建innodb cluster网络
docker network create innodbnet

# 启三个节点
for N in 1 2 3
do docker run -d --name=mysql$N --hostname=mysql$N --net=innodbnet \
  -e MYSQL_ROOT_PASSWORD=root mysql/mysql-server:8.0
done


# 创建复制用户
for N in 1 2 3
do docker exec -it mysql$N mysql -uroot -proot \
  -e "CREATE USER 'mgr'@'%' IDENTIFIED BY 'mgr123';" \
  -e "GRANT ALL PRIVILEGES ON *.* TO 'mgr'@'%' WITH GRANT OPTION;FLUSH PRIVILEGES;" \
  -e "RESET master;"
done


# 查看hostname
for N in 1 2 3
do docker exec -it mysql$N mysql -umgr -pmgr123 \
  -e "SELECT @@hostname;"
done

# 连接MySQL-shell,配置集群
docker exec -it mysql1 mysqlsh -uroot -proot -S/var/run/mysqld/mysqlx.sock
\c mgr@mysql1:3306


# mysql-shell
# 分别检查三个节点的配置
dba.checkInstanceConfiguration('mgr@mysql1:3306')
dba.checkInstanceConfiguration('mgr@mysql2:3306')
dba.checkInstanceConfiguration('mgr@mysql3:3306')

# 如果某个几点是error, 不是ok
# 检查并修复
dba.configureInstance('mgr@mysql1:3306')
dba.configureInstance('mgr@mysql2:3306')
dba.configureInstance('mgr@mysql3:3306')

# 修复后最好重启一下MySQL服务, 再重新进入MySQL-shell配置, 再次检查应该是ok

# 创建集群
var cls = dba.createCluster('myCluster')
# 检查集群状态
cls.status()  
# 添加别的节点
cls.addInstance('mgr@mysql2:3306')
cls.addInstance('mgr@mysql3:3306')






```