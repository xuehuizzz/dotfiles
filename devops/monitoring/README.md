## 架构说明

监控服务器运行 Prometheus + Grafana + Alertmanager，通过网络抓取各远程服务器上的 exporter 指标。

```
监控服务器 (本机 docker-compose)
├── Prometheus        :9090
├── Grafana           :3000
└── Alertmanager      :9093

被监控服务器 (各自部署 exporter):
├── web-1, web-2           → node_exporter(:9100)
├── db-1, db-2             → node_exporter(:9100) + mysqld_exporter(:9104)
├── worker-1, worker-2, worker-3  → node_exporter(:9100)
└── middleware-1, middleware-2     → node_exporter(:9100) + redis_exporter(:9121) + kafka_exporter(:9308)
```

## 快速部署

### 1. 启动监控栈

```bash
docker compose up -d
```

### 2. 在被监控服务器上部署 exporter

每台服务器都需要运行 node_exporter：

```bash
# 所有服务器通用
docker run -d --name node-exporter --net host --pid host \
  -v /proc:/host/proc:ro -v /sys:/host/sys:ro -v /:/rootfs:ro \
  prom/node-exporter \
  --path.procfs=/host/proc --path.sysfs=/host/sys --path.rootfs=/rootfs
```

DB 服务器额外运行 mysqld_exporter：

```bash
docker run -d --name mysqld-exporter -p 9104:9104 \
  -e DATA_SOURCE_NAME="exporter:password@(localhost:3306)/" \
  prom/mysqld-exporter
```

中间件服务器额外运行 redis_exporter 和 kafka_exporter：

```bash
# Redis exporter
docker run -d --name redis-exporter -p 9121:9121 \
  oliver006/redis_exporter --redis.addr=redis://localhost:6379

# Kafka exporter
docker run -d --name kafka-exporter -p 9308:9308 \
  danielqsj/kafka-exporter --kafka.server=localhost:9092
```

### 3. 修改 targets 配置

编辑 `prometheus/targets/` 下的文件，将示例 IP 替换为实际服务器 IP：

```
prometheus/targets/
├── web.yml          # Web 服务器 IP
├── db.yml           # DB 服务器 IP
├── worker.yml       # Worker 服务器 IP
└── middleware.yml   # 中间件服务器 IP
```

修改后 Prometheus 会自动加载，**无需重启**。

### 4. 配置告警

编辑 `alertmanager/config.yml`，替换以下占位符：
- `your@email.com` → 实际收件邮箱
- `smtp.example.com:587` → 实际 SMTP 服务器
- `yourpassword` → SMTP 密码
- `http://YOUR_WEBHOOK_URL` → 企业微信/钉钉/飞书的 Webhook 地址

## Web 访问

| 服务 | 地址 | 账号 |
|------|------|------|
| Grafana | http://localhost:3000 | admin / admin |
| Prometheus | http://localhost:9090 | - |
| Alertmanager | http://localhost:9093 | - |

## 新增/删除服务器

只需编辑 `prometheus/targets/` 下对应角色的 yml 文件，添加或删除 target 条目即可。Prometheus 每 30 秒自动刷新。

## 告警规则

| 文件 | 覆盖范围 |
|------|----------|
| `alert.rules.yml` | 通用: CPU、内存、磁盘、宕机 |
| `alert.rules.db.yml` | MySQL: 宕机、连接数、慢查询、主从复制 |
| `alert.rules.middleware.yml` | Redis: 宕机、内存、连接 / Kafka: 宕机、消费延迟、副本 |

## Grafana 模版推荐

| 监控对象 | Dashboard ID |
|----------|-------------|
| 服务器 | 11074, 1860 |
| MySQL | 7362 |
| Redis | 763 |
| Kafka | 7589 |
