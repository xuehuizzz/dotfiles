# 常用命令
```bash
# -----------------------------------key--------------------------------
KEYS *                    # 查看所有 key（生产环境慎用，会阻塞）
KEYS xxx*               # 查找以 xxx 开头的key

EXISTS key                # 判断 key 是否存在，存在返回 1，不存在返回 0
DEL key1 key2             # 删除一个或多个 key
UNLINK key                # 异步删除 key（推荐用于大 key 删除）

EXPIRE key 60             # 设置 key 的过期时间为 60 秒
PEXPIRE key 60000         # 设置 key 的过期时间为 60000 毫秒
EXPIREAT key 1735689600   # 设置 key 在某个时间戳过期
TTL key                   # 查看 key 剩余生存时间（秒），-1 永久，-2 不存在
PTTL key                  # 查看 key 剩余生存时间（毫秒）
PERSIST key               # 移除 key 的过期时间，使其永久有效

TYPE key                  # 查看 key 的数据类型
RENAME oldkey newkey      # 重命名 key
RENAMENX oldkey newkey    # 仅当 newkey 不存在时重命名

SCAN 0 MATCH user:* COUNT 100   # 渐进式遍历 key（推荐替代 KEYS）

DBSIZE                    # 当前数据库 key 数量
FLUSHDB                   # 清空当前数据库（危险）
FLUSHALL                  # 清空所有数据库（危险）

# -----------------------------字符串-------------------------------------
SET key value             # 设置 key 的值
SET key value EX 60       # 设置 key 并指定 60 秒过期
SET key value NX          # 仅当 key 不存在时设置（常用于分布式锁）
SET key value XX          # 仅当 key 存在时设置

GET key                   # 获取 key 的值
GETSET key newvalue       # 设置新值并返回旧值
MSET k1 v1 k2 v2          # 同时设置多个 key
MGET k1 k2 k3             # 同时获取多个 key 的值

SETEX key 60 value        # 设置 key 的值并指定过期时间（秒）
PSETEX key 60000 value    # 设置 key 的值并指定过期时间（毫秒）
SETNX key value           # 仅当 key 不存在时设置

STRLEN key                # 获取字符串长度
```
