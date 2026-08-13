## <center>ES|QL：像 SQL 一样从左到右写数据处理流水线</center>
#### Query DSL 是“告诉 ES 怎么执行查询”，而 ES|QL 是“像写 SQL 一样描述我要什么数据，以及怎么一步步处理它”。
ES|QL 本身从 Elasticsearch 8.11 开始可用，8.14 开始 GA（正式可用）。但具体语法/函数/能力又有各自的最低版本。
### 基本语法结构
```bash
FROM index
| WHERE 条件
| KEEP 字段1, 字段2
| SORT 字段 DESC
| LIMIT 100
```
例如: 
```bash
FROM logs-*
| WHERE status_code >= 500
| KEEP @timestamp, service.name, status_code, message
| SORT @timestamp DESC
| LIMIT 100
```
> - FROM       → 从哪里查
> - WHERE      → 过滤
> - KEEP       → 保留哪些字段
> - EVAL       → 计算新字段
> - SORT       → 排序
> - LIMIT      → 限制数量
> - STATS      → 聚合
> - RENAME     → 重命名
> - DISSECT    → 字符串解析
> - GROK       → 日志解析
> - LOOKUP     → 关联数据

```bash
# where条件
FROM logs | WHERE status == 200   # 等于
FROM logs | WHERE status != 200   # 不等于
FROM logs | WHERE status >= 400 AND status < 500   # AND
FROM logs | WHERE status == 404 OR status == 500   # OR
FROM logs | WHERE status IN (400, 401, 403, 404)   # IN

# 字符串匹配, `*` 任意多个字符, `?` 任意一个字符
FROM logs | WHERE message LIKE "*timeout*"  # 包含
FROM logs | WHERE message RLIKE "timeout|connection.*failed"   # 正则匹配

# KEEP / DROP
FROM logs-* | KEEP @timestamp, message, status, host.name    # 只保留需要的字段
FROM logs-* | DROP message, user.password    # 删除这些字段

# EVAL —— 计算字段
FROM logs
| EVAL total = price * quantity
| KEEP product, price, quantity, total

# SORT
FROM logs | SORT @timestamp ASC   # ASC 升序, DESC 降序
FROM logs | SORT status DESC, @timestamp DESC

# LIMIT
FROM logs | LIMIT 100  # 查最近 100 条

# STATS —— 聚合
FROM logs | STATS count = COUNT(*)   # 计数
FROM logs | STATS count = COUNT(*) BY status   # 按字段 GROUP BY

# 多个聚合
FROM logs
| STATS
    total = COUNT(*),
    avg_duration = AVG(duration),
    max_duration = MAX(duration),
    min_duration = MIN(duration)

# 时间范围
FROM logs | WHERE @timestamp >= NOW() - 1 hour   # 最近1小时
FROM logs | WHERE @timestamp >= NOW() - 1 day    # 最近1天
FROM logs | WHERE @timestamp >= NOW() - 15 minutes  # 最近15分钟

# CASE条件
FROM logs
| EVAL level =
    CASE(
      status >= 500, "ERROR",
      status >= 400, "WARN",
      "OK"
    )

# COALESCE
FROM logs | EVAL username = COALESCE(user.name, "anonymous")    # 字段为空的时候给个默认值

```





