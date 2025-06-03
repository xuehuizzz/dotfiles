# 介绍
MySQL Shell 是一个高级的命令行工具, 专门用于与 MySQL 数据库进行交互. 它支持 SQL、JavaScript 和 Python 三种脚本语言, 提供了比传统 MySQL 命令行客户端更强大的功能. 
MySQL Shell 可以用于数据库管理、数据迁移、自动化任务以及与 MySQL InnoDB Cluster 的交互

```bash
# 安装   https://dev.mysql.com/downloads/shell/
wget https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell_8.3.0-1ubuntu22.04_amd64.deb
sudo dpkg -i mysql-shell_8.3.0-1ubuntu22.04_amd64.deb
```

### 配置Innodb cluster
```bash
# 连接数据库
mysqlsh --js
\c user@host:port    # 连接一个节点

// 检查实例配置
dba.checkInstanceConfiguration()  // 默认检查当前节点的状态
// dba.checkInstanceConfiguration('mysql_user@node2:3306')  // 指定检查节点

// 如果有配置问题，可以自动修复
dba.configureInstance()  // 默认修复当前节点
// dba.configureInstance('mysql_user@node2:3306')   // 指定修复有问题的节点 

// 创建集群
var cls = dba.createCluster('myCluster')
cls.status()  // 检查集群状态

// 添加节点
cls.addInstance('mgr@node2')
cls.addInstance('mgr@node3')
cls.status()

// 查看已有集群
var cls = dba.getCluster()  // 查看当前节点所属集群
// var cls = dba.getCluster('myCluster')  // 查看指定集群
cls.status()


// 删除指定集群
var cls = dba.getCluster('myCluster')
cls.dissolve()

// 切换主节点
cls.setPrimaryInstance('mgr@node2:3306')  
```
