# Percona Toolkit 使用笔记

> 安装：`brew/apt/yum install percona-toolkit`

---

## pt-osc 无锁修改表结构

`pt-online-schema-change`（简称 pt-osc）是 Percona Toolkit 提供的，主要用于 **MySQL 或 MariaDB 中无锁地修改表结构**（ALTER TABLE），避免长时间锁表而影响线上业务，非常适合用于生产环境表结构变更。

### 为什么要用 pt-osc

**直接 ALTER 大表时：**
- 会锁表，特别是 InnoDB
- 会阻塞读写
- 表越大越危险（几分钟甚至几小时）

**而 pt-osc 会：**
- 创建一个影子表，在影子表上执行 ALTER
- 用触发器实时复制原表的数据变更
- 最终切换（rename）表，几乎瞬时完成

```bash
pt-online-schema-change \
  --user=root \
  --password=123456 \
  --host=127.0.0.1 \
  --port=3306 \
  --alter "ADD COLUMN age INT" \
  D=mydb,t=users \
  --alter-foreign-keys-method=auto \
  --charset=utf8mb4 \
  --execute
```

### 常用参数说明
- `--alter-foreign-keys-method`: 解决外键引用问题(auto / rebuild_constraints / drop_swap)
- `--dry-run`：预演变更，不真正执行
- `--execute`：执行变更，和 --dry-run 互斥，选其一即可
- `--no-check-replication-filters`：忽略复制过滤器检查（主从场景有用）
- `--chunk-size`：每次复制多少行（默认 1000）
- `--max-lag`：设置最大复制延迟阈值（默认 1s）
- `--max-load Threads_running=25`：控制并发负载上限
- `--critical-load Threads_running=50`：超过则中止执行
- `--set-vars innodb_lock_wait_timeout=60`：修改 session 级别参数
- `--nocheck-unique-key-change`：不检查唯一索引变更

### 注意事项
- **表必须有主键**：pt-osc 依赖主键来同步数据
- **会创建触发器**：insert/update/delete 会复制到新表
- **最后阶段为 rename**：rename 操作几乎瞬时完成
- **会有额外磁盘 I/O**：因为复制了整张表的一份
- **备份数据前用 --dry-run**：安全起见先模拟一次
- **默认单线程复制**：大表可用 --chunk-size 调优
- 如果原表上已经有触发器，pt-osc 在旧版本会直接报错（因为 MySQL 5.7 前一张表不能有多个同类型触发器）

---

## pt-query-digest 分析慢查询日志

`pt-query-digest` 是 Percona Toolkit 提供的一个非常强大的工具，用于分析 MySQL 的慢查询日志（slow query log）、通用查询日志（general log）、binlog 文件或 tcpdump 数据包，帮助你识别那些 SQL 查询最耗资源。

```sql
SHOW VARIABLES LIKE '%slow_query_log%';  -- 查看慢查询文件位置

-- 临时开启慢查询日志，重启后失效，要永久配置，应写入配置文件
SET GLOBAL slow_query_log = 'ON';  -- 开启慢查询日志
SET GLOBAL long_query_time = 1;    -- 定义多少秒算慢查询
```

### 用法

```bash
# 分析慢查询日志
pt-query-digest /var/log/mysql/mysql-slow.log

# 指定输出报告
pt-query-digest --output=slowlog /var/log/mysql/mysql-slow.log > report.txt

# 输出报告中显示前 10 个查询类别(按耗时排名),    百分比写法(--limit 95%:20)
pt-query-digest --limit 10 /var/log/mysql/mysql-slow.log

# 只分析某个时间段
pt-query-digest --since '2025-04-13 10:00:00' --until '2025-04-13 12:00:00' /var/log/mysql/mysql-slow.log

# 只分析某个数据库的 SQL
pt-query-digest --filter '$event->{db} eq "your_database"' /var/log/mysql/mysql-slow.log

# 只分析 SELECT 查询
pt-query-digest --filter '$event->{arg} =~ m/^select/i' /var/log/mysql/mysql-slow.log
```

### 输出说明

```
# 解析文件: /var/log/mysql/mysql-slow.log
# Rank Query ID        Response time Calls R/Call  V/M  Item
# ==== =============== ============= ===== ======= ==== ============
#  1  0xA23F...        5.0123s       10    0.501s  0.90 SELECT users
```

- **Rank**：查询耗时排名
- **Query ID**：查询的唯一标识（根据 fingerprint 计算的哈希）
- **Response time**：总响应时间
- **Calls**：出现次数
- **R/Call**：平均响应时间
- **Item**：访问的表名

---

## pt-kill 杀掉查询/连接

`pt-kill` 是 Percona Toolkit 中的一个命令行工具，用于根据规则自动杀掉 MySQL 中的某些查询或连接。它特别适合用于清理慢查询、阻塞的语句、无用连接等，从而提高数据库的稳定性和性能。

**常用功能包括：**
- 杀掉运行时间超过指定秒数的查询
- 杀掉某些特定用户、库、命令类型的查询
- 每隔一段时间检查一次查询列表

### 用法

```bash
# 杀掉运行时间超过 60 秒的查询
pt-kill --match-info "." --busy-time 60 --kill

# 杀掉所有正在执行 SELECT 的连接
pt-kill --match-command "Query" --match-info "^SELECT" --kill

# 每 10 秒检查一次，并杀掉执行时间超过 30 秒的查询
pt-kill --busy-time 30 --kill --interval 10

# 忽略特定用户的连接
pt-kill --busy-time 30 --kill --ignore-user repl_user
```

### 常用参数说明
- `--kill`：执行 kill 操作
- `--print`：打印匹配的语句（建议调试时使用）
- `--busy-time N`：匹配运行超过 N 秒的查询
- `--match-command`：匹配 MySQL 命令的命令类型（Query、Sleep、Connect 等）
- `--match-info`：匹配 SQL 内容（正则）
- `--ignore-command` / `--ignore-info`：忽略某些语句
- `--interval N`：每 N 秒执行一次
- `--host` / `--user` / `--password` / `--port`：MySQL 连接信息

---

## pt-table-checksum 主从复制数据一致性校验
<mark>pt-table-checksum 与 pt-table-sync通常配合使用, 先检查差异, 在做同步</mark>
会在主库执行校验 SQL（通常是对表的 CRC32 校验），并通过复制将这些 SQL 同步到从库，从而检测出主从数据是否一致。

基础命令格式：`pt-table-checksum --host=主库IP --user=用户名 --password=密码`，会校验所有数据库中的所有表

### 常用参数说明
- `--databases=db1,db2`：指定校验哪些数据库
- `--tables=tbl1,tbl2`：指定具体表
- `--host` / `--user` / `--password` / `--port`：主库连接信息
- `--no-check-binlog-format`：如果 binlog_format 不是 ROW，就需要加这个
- `--replicate`：指定校验结果写入的表（默认 percona.checksums）
- `--recursion-method=dsn`：设置如何找从库（默认会尝试自动查找）
- `--chunk-size`：每次校验数据块大小（默认是 1000）

### 用法

```bash
pt-table-checksum \
  --host=192.168.1.10 \
  --user=root \
  --password=123456 \
  --databases=testdb \
  --tables=mytable \
  --no-check-binlog-format \
  --replicate=percona.checksums \
  --recursion-method=dsn \
  --create-replicate-table
```

### 在从库上查看结果

```sql
-- 如果某行的主从 cnt 或 crc 不一致，说明这张表在主从之间的数据不一致
SELECT db, tbl, this_cnt, master_cnt, this_crc, master_crc
FROM percona.checksums
WHERE master_cnt != this_cnt OR master_crc != this_crc;
```

### 注意事项
- binlog_format 推荐设置为 ROW 模式；
- pt-table-checksum 会对表执行读操作（可能加锁），需谨慎在业务高峰期运行；
- 要保证主库能访问所有从库（或使用 dsn 指定）；
- 在某些版本中，从库有延迟会导致误报，可以加 --check-slave-lag 来缓冲。

---

## pt-table-sync 同步数据表的数据，进行主从一致性的修复

```bash
# 检查主从一致性（不会修改任何数据）
pt-table-sync --execute --sync-to-master h=从库IP,u=用户名,p=密码  # --sync-to-master 表示以主库为准，对从库进行同步

# 修改第二个 DSN(目标)使其与第一个 DSN(源)一致, 生产环境建议先 --print 确认
pt-table-sync --execute \
  h=源IP,u=用户名,p=密码,D=数据库名,t=表名 \
  h=源IP,u=用户名,p=密码

# 查看仅会打印同步 SQL（测试用）
pt-table-sync --print --sync-to-master h=从库IP,u=用户名,p=密码

# 忽略某些字段（比如自动更新时间字段）
pt-table-sync --execute --sync-to-master \
  --ignore-columns=update_time \
  h=从库IP,u=用户名,p=密码
```

---

## pt-archiver 数据归档,删除或导出

```bash
# 导出数据到文件
pt-archiver \
  --source h=127.0.0.1,D=test,t=logs,u=root,p=123456 \
  --where "created_at < NOW() - INTERVAL 90 DAY" \
  --file /tmp/old_logs.txt \
  --limit 1000 \
  --commit-each \
  --progress 1000

# 删除 30 天前的日志记录
# --limit 批次处理，--commit-each 每批提交一次，避免长事务，--progress 每处理多少行输出一次进度
pt-archiver \
  --source h=127.0.0.1,D=test,t=logs,u=root,p=123456 \
  --where "created_at < NOW() - INTERVAL 30 DAY" \
  --purge \
  --limit 1000 \
  --commit-each \
  --progress 1000
```

---

## 注意

- 执行前先 `--print` 观察 SQL 语句是否有误，或 `--dry-run` 模拟执行无误后，再 `--execute`
- `--ask-pass`：在执行时交互式提示输入密码，不建议 `--password`
- 建议数据库连接信息写在配置文件

```ini
[client]
user=root
password=MySecretPass
```

```bash
pt-online-schema-change --defaults-file=~/.my.cnf ...
```
