# 介绍
MySQL Shell 是一个高级的命令行工具, 专门用于与 MySQL 数据库进行交互. 它支持 SQL、JavaScript 和 Python 三种脚本语言, 提供了比传统 MySQL 命令行客户端更强大的功能. 
MySQL Shell 可以用于数据库管理、数据迁移、自动化任务以及与 MySQL InnoDB Cluster 的交互

```bash
# 安装
brew install mysql-shell
sudo apt-get install mysql-shell
sudo yum install mysql-shell

# 连接数据库
mysqlsh --uri user@host:port  # 在启动 MySQL Shell 时使用
或者
mysqlsh
\connect user@host:port    # 在MySQL shell内部使用

# 使用不同的脚本语言
\sql  // 切换到 SQL 模式
\js   // 切换到 JavaScript 模式
\py   // 切换到 Python 模式
```
