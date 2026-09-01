# Nginx 配置工程 · 使用手册

模块化 Nginx 配置，遵循「一个文件只管一件事」。改配置不用再翻 800 行的 `nginx.conf`。

---

## 1. 环境要求

| 项 | 版本 | 说明 |
|---|---|---|
| nginx | >= 1.25.1 | 用到了独立的 `http2 on;` 指令 |
| OpenSSL | >= 1.1.1 | TLSv1.3 与 `ssl_conf_command` 依赖 |

降级方案：
- nginx 1.19.4 ~ 1.25.0：把 `http2 on;` 改回 `listen 443 ssl http2;`
- nginx < 1.19.4：删除 `ssl_reject_handshake on;`，改为给默认 server 配一张自签证书

检查：

```bash
nginx -v
nginx -V 2>&1 | tr ' ' '\n' | grep -i ssl
```

---

## 2. 目录结构

```
/etc/nginx/
├── nginx.conf                      # 入口，只有骨架 + include
│
├── conf.d/                         # http 级全局策略，数字前缀 = 加载顺序
│   ├── 00-performance.conf         #   连接 / IO 调优
│   ├── 10-buffers.conf             #   请求缓冲区、body 大小
│   ├── 20-gzip.conf                #   压缩
│   ├── 30-log.conf                 #   日志格式 log_format main
│   ├── 40-proxy-cache.conf         #   proxy buffer + keys_zone=my_cache
│   ├── 50-ssl.conf                 #   全局 TLS 参数（不含证书）
│   └── 60-limits.conf              #   zone=perip / zone=connperip
│
├── upstreams/
│   └── backend_pool.conf           # 后端集群拓扑
│
├── snippets/                       # 可复用片段
│   ├── proxy_params.conf           #   反代透传头
│   ├── proxy_cache.conf            #   缓存策略
│   ├── security_headers.conf       #   安全响应头
│   ├── acme-challenge.conf         #   证书续签放行
│   └── tls-<domain>.conf           #   证书路径，一域一文件
│
├── sites-available/                # 所有站点定义（仓库）
└── sites-enabled/                  # 软链，控制上下线（生效区）
```

**核心约定**

- `conf.d/` 定义资源（zone、log_format、cache path），`snippets/` 消费资源。
- 依赖顺序由 `nginx.conf` 里 include 三行的先后决定：`conf.d` → `upstreams` → `sites-enabled`。
- 只有 `sites-enabled/` 里的软链会生效，`sites-available/` 是归档。

---

## 3. 初始化部署

```bash
# 1) 创建目录与权限（cache 目录属主必须是 nginx 运行用户）
install -d -o nginx -g nginx /data/nginx/cache
install -d -o nginx -g nginx /var/cache/nginx/client_temp
install -d -o nginx -g nginx /var/www/acme
install -d /etc/nginx/ssl

# 2) 生成 DH 参数（约 1~3 分钟）
openssl dhparam -out /etc/nginx/ssl/dhparam2048.pem 2048

# 3) 放置证书
install -d /etc/nginx/ssl/yourdomain.com
# 将 fullchain.pem / privkey.pem / chain.pem 拷入该目录
chmod 600 /etc/nginx/ssl/yourdomain.com/privkey.pem

# 4) 启用站点
cd /etc/nginx/sites-enabled
ln -sf ../sites-available/00-default-deny.conf     .
ln -sf ../sites-available/yourdomain.com.80.conf   .
ln -sf ../sites-available/yourdomain.com.443.conf  .

# 5) 校验并启动
nginx -t && systemctl reload nginx
```

---

## 4. 日常操作

### 4.1 校验与生效

```bash
nginx -t                    # 语法校验，改完必跑
nginx -T                    # 输出 include 展开后的完整配置（排障第一步）
nginx -T | grep -n my_cache # 确认某指令最终生效在哪一层
systemctl reload nginx      # 热加载，不断连接
```

> **任何情况下不要跳过 `nginx -t` 直接 reload。**

### 4.2 新增一个站点

```bash
D=example.com

# 证书路径单独成文件
cat > /etc/nginx/snippets/tls-$D.conf <<EOF
ssl_certificate         /etc/nginx/ssl/$D/fullchain.pem;
ssl_certificate_key     /etc/nginx/ssl/$D/privkey.pem;
ssl_trusted_certificate /etc/nginx/ssl/$D/chain.pem;
EOF

# 复制模板改 server_name 和 tls include
cp /etc/nginx/sites-available/yourdomain.com.80.conf  /etc/nginx/sites-available/$D.80.conf
cp /etc/nginx/sites-available/yourdomain.com.443.conf /etc/nginx/sites-available/$D.443.conf
sed -i "s/yourdomain\.com/$D/g" /etc/nginx/sites-available/$D.*.conf

ln -sf ../sites-available/$D.80.conf  /etc/nginx/sites-enabled/
ln -sf ../sites-available/$D.443.conf /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
```

### 4.3 下线一个站点

```bash
rm /etc/nginx/sites-enabled/example.com.443.conf
nginx -t && systemctl reload nginx
# sites-available 里的原文件保留
```

### 4.4 摘除 / 加回后端节点

编辑 `upstreams/backend_pool.conf`：

```nginx
# 临时摘除
server backend2.local:8080 down;

# 只兜底，正常不接流量
server backend2.local:8080 backup;
```

```bash
nginx -t && systemctl reload nginx
```

### 4.5 清理缓存

```bash
# 全清
find /data/nginx/cache -type f -delete && systemctl reload nginx

# 按 URL 精确清（proxy_cache_key = $scheme$proxy_host$request_uri）
KEY="httpsbackend_pool/path/to/page"
H=$(printf '%s' "$KEY" | md5sum | cut -d' ' -f1)
rm -f /data/nginx/cache/${H: -1}/${H: -3:2}/$H
```

---

## 5. 常见修改速查

| 需求 | 改哪个文件 | 改什么 |
|---|---|---|
| 上传文件变大 | `conf.d/10-buffers.conf` | `client_max_body_size` |
| 后端慢，网关 504 | `conf.d/40-proxy-cache.conf` | `proxy_read_timeout` |
| 加后端节点 / 调权重 | `upstreams/backend_pool.conf` | `server ...` |
| 换负载算法 | `upstreams/backend_pool.conf` | `least_conn` / `ip_hash` |
| 加压缩类型 | `conf.d/20-gzip.conf` | `gzip_types` |
| 调限流阈值 | `conf.d/60-limits.conf` | `rate=20r/s` |
| 某接口不限流 | 对应 `sites-available/*.conf` | 该 location 删掉 `limit_req` |
| 加安全响应头 | `snippets/security_headers.conf` | `add_header` |
| 换证书 | `snippets/tls-<domain>.conf` | 路径 |
| 调 TLS 版本/套件 | `conf.d/50-ssl.conf` | `ssl_protocols` |
| 加日志字段 | `conf.d/30-log.conf` | `log_format main` |
| 某路径不缓存 | 对应 location | `proxy_cache off;` |

---

## 6. 排障

### 6.1 缓存是否命中

响应头 `X-Cache-Status`：

| 值 | 含义 |
|---|---|
| `HIT` | 命中 |
| `MISS` | 未命中，已回源并写入 |
| `EXPIRED` | 过期，已回源 |
| `STALE` | 后端异常，返回了过期副本（降级生效） |
| `UPDATING` | 正在后台更新，返回旧副本 |
| `BYPASS` | 命中 `proxy_cache_bypass` 规则 |

```bash
curl -sI https://yourdomain.com/ | grep -i x-cache
awk '{for(i=1;i<=NF;i++) if($i~/^cache=/) print $i}' /var/log/nginx/access.log | sort | uniq -c
```

### 6.2 定位耗时来源

access_log 中：

- `uct` 大 → 连接后端慢（网络 / 后端 accept 队列满）
- `uht` 大 → 后端处理慢（业务代码 / DB）
- `rt` 远大于 `urt` → 客户端网络慢或 nginx 缓冲写盘

```bash
# 找出最慢的 20 个请求
awk '{for(i=1;i<=NF;i++) if($i~/^rt=/){sub("rt=","",$i); print $i, $7}}' \
  /var/log/nginx/access.log | sort -rn | head -20
```

### 6.3 TLS 检查

```bash
openssl s_client -connect yourdomain.com:443 -tls1_3 </dev/null 2>&1 | grep -E 'Protocol|Cipher'
openssl s_client -connect yourdomain.com:443 -status </dev/null 2>&1 | grep -A2 'OCSP Resp'
openssl x509 -in /etc/nginx/ssl/yourdomain.com/fullchain.pem -noout -dates
```

### 6.4 高频报错对照

| 现象 | 原因 | 处理 |
|---|---|---|
| `upstream sent too big header` | header 超出 proxy_buffer | 调大 `proxy_buffer_size` |
| 大量 `408` | 弱网上传超时 | 调大 `client_body_timeout` |
| `Too many open files` | 句柄不足 | 检查 `worker_rlimit_nofile` 与 systemd `LimitNOFILE` |
| 上游 TIME_WAIT 堆积 | 未启用上游长连接 | 确认 upstream 有 `keepalive`、snippet 里有 `Connection ""` |
| HSTS 头消失 | location 内有其他 `add_header` 覆盖了继承 | 该 location 补 `include snippets/security_headers.conf` |
| `502` 且 `ustatus=-` | 根本没连上后端 | 查 DNS、端口、后端存活 |

---

## 7. 已知陷阱（改配置前必读）

1. **`add_header` 不叠加，只覆盖。** 子层级出现任意一条 `add_header`，父层级的全部失效（`always` 也救不了）。安全头必须在每个 location 重新 include。
2. **`ssl_ciphers` 管不到 TLSv1.3。** TLS1.3 套件写在 `ssl_ciphers` 里会被静默忽略，必须用 `ssl_conf_command Ciphersuites`。
3. **`application/xml+rss` 是错的**，正确写法 `application/rss+xml`。
4. **`proxy_cache_key` 默认不含 scheme**，HTTP/HTTPS 会互相污染，本配置已显式指定。
5. **带 Cookie / Authorization 的响应绝不能进共享缓存**，`snippets/proxy_cache.conf` 已用 `proxy_cache_bypass` + `proxy_no_cache` 拦掉；新增业务时确认会话标识名是否匹配。
6. **`client_body_timeout` 是两次读操作的间隔**，不是总时长；但设太小会让大文件上传在弱网下必然 408。

---

## 8. 变更流程

```bash
# 1) 备份
cp -a /etc/nginx /etc/nginx.bak.$(date +%F-%H%M)

# 2) 修改后校验
nginx -t

# 3) 对照展开结果确认生效层级
nginx -T | grep -n -A3 '关键指令'

# 4) 灰度：先在单节点 reload，观察 5xx 与 rt
systemctl reload nginx
tail -f /var/log/nginx/error.log

# 5) 回滚
rm -rf /etc/nginx && mv /etc/nginx.bak.<ts> /etc/nginx
nginx -t && systemctl reload nginx
```

建议将 `/etc/nginx` 纳入 Git，`sites-enabled/` 软链一并提交，保证生效状态可追溯。

---

## 9. 日志切割

`/etc/logrotate.d/nginx`：

```
/var/log/nginx/*.log {
    daily
    rotate 14
    missingok
    notifempty
    compress
    delaycompress
    sharedscripts
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 $(cat /var/run/nginx.pid)
    endscript
}
```

> 必须用 `USR1`（重开日志文件），不要用 `reload`。
