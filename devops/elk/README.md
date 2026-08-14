# ELK Stack 本地开发环境

基于 Docker Compose 的 Elasticsearch + Logstash + Kibana 一键部署方案，版本 **9.4.4**。

## 目录结构

```
elk/
├── docker-compose.yml
├── README.md
├── elasticsearch/
│   ├── config/
│   │   └── elasticsearch.yml     # ES 主配置
│   ├── data/                     # 数据持久化（勿手动改动）
│   ├── logs/                     # ES 运行日志
│   └── plugins/                  # 自定义插件，如 IK 分词器
├── kibana/
│   └── kibana.yml                # Kibana 配置
└── logstash/
    └── logstash.conf             # Logstash pipeline
```

## 环境要求

| 项目 | 要求 |
|---|---|
| Docker | 20.10+ |
| Docker Compose | v2（使用 `docker compose` 而非 `docker-compose`） |
| 可用内存 | ≥ 4GB（三个容器各限制 1g） |
| 端口占用 | 9200、9300、5601、5044 需空闲 |

## 快速开始

### 1. 设置宿主机内核参数

ES 启动强制要求，否则报 `max virtual memory areas vm.max_map_count [65530] is too low`：

```bash
# Linux
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf   # 永久生效

# macOS (Docker Desktop) / Windows (WSL2) 一般无需设置
```

### 2. 创建目录并授权

ES 容器内以 `uid=1000` 运行，宿主机目录属主不对会启动失败报 `AccessDeniedException`：

```bash
mkdir -p elasticsearch/{config,data,logs,plugins}
sudo chown -R 1000:1000 elasticsearch
chmod -R 775 elasticsearch
```

> macOS 上 Docker Desktop 走 gRPC-FUSE，通常可跳过 `chown`。

### 3. 启动

```bash
docker compose up -d
docker compose ps
docker compose logs -f elasticsearch
```

### 4. 设置 kibana_system 密码（首次必做）

compose 里的 `ELASTIC_PASSWORD` **只对 `elastic` 用户生效**，`kibana_system` 密码默认未设置，不设 Kibana 会一直 401 重启。

```bash
# 方式 A：API（推荐，非交互）(现在docker-compose没有把9200对公网开放, 因此用方式 B)
curl -u elastic:123456 -X POST "http://localhost:9200/_security/user/kibana_system/_password" \
  -H 'Content-Type: application/json' -d '{"password":"123456"}'

# 方式 B：官方工具
docker exec -it elasticsearch bin/elasticsearch-reset-password -u kibana_system -i -b
```

验证：

```bash
# 9200未开放, 此方法也无法验证
curl -u kibana_system:123456 "http://localhost:9200/_security/_authenticate?pretty"
```

然后重启 Kibana：

```bash
docker compose restart kibana
docker compose logs -f kibana   # 出现 "Kibana is now available" 即成功
```

### 创建logstash用户<sub>用elastic也可以但不推荐</sub>

```bash
docker exec -it elasticsearch \
  curl -u elastic:123456 \
  -X PUT \
  "http://localhost:9200/_security/role/logstash_writer_role" \
  -H "Content-Type: application/json" \
  -d '{
    "cluster": [],
    "indices": [
      {
        "names": ["logstash-*"],
        "privileges": [
          "auto_configure",
          "create",
          "create_doc",
          "index",
          "write"
        ]
      }
    ]
  }'
docker compose restart logstash
```

## 访问方式

| 服务 | 地址 | 凭证 |
|---|---|---|
| Elasticsearch | http://localhost:9200 | `elastic` / `123456` |
| Kibana | http://localhost:5601 | `elastic` / `123456` |
| Logstash Beats 输入 | `localhost:5044` | — |

## 账号说明（重要）

Kibana 有**两条独立的 ES 连接**，凭证不同，切勿混用：

```
浏览器 ──(elastic 登录)──> Kibana 进程 ──┬──> ES  ① 系统连接：kibana_system
                                         └──> ES  ② 用户连接：elastic
```

| 账号 | 定位 | 配置位置 | 能否登录 Kibana UI |
|---|---|---|---|
| `elastic` | 超级用户，人使用 | 浏览器登录框 / curl `-u` | ✅ |
| `kibana_system` | Kibana 进程内部使用 | `kibana.yml` 的 `elasticsearch.password` | ❌ |
| `logstash_system` | 仅上报 Logstash 自身监控 | — | ❌ |

**常见误区**：用 `kibana_system` 登录 Kibana 会看到「您无权访问请求的页面」。它只有 `.kibana*` 索引权限，没有 UI 权限。点「以其他用户身份登录」或访问 `/logout` 换 `elastic` 即可。

**密码修改规则**：`kibana.yml` 里的密码是"客户端填的答案"，ES 里存的是"标准答案"，两者必须一致。改密码时需同步修改两处并重启 Kibana。

## 常用运维命令

```bash
# 启停
docker compose up -d
docker compose stop
docker compose restart kibana

# 日志
docker compose logs -f elasticsearch
docker compose logs --tail 100 logstash

# 集群健康（green/yellow 均可用，单节点副本未分配时为 yellow 属正常）
curl -u elastic:123456 "http://localhost:9200/_cluster/health?pretty"

# 索引列表
curl -u elastic:123456 "http://localhost:9200/_cat/indices?v"

# 节点资源占用
curl -u elastic:123456 "http://localhost:9200/_cat/nodes?v&h=name,heap.percent,ram.percent,cpu"

# 删除索引
curl -u elastic:123456 -X DELETE "http://localhost:9200/app-log-2024.01.01"

# 进入容器
docker exec -it elasticsearch bash
```

## 数据管理

数据以**绑定挂载**方式持久化在 `./elasticsearch/data`，`docker compose down` 不会丢数据。

```bash
# 完全清空重建（数据全部丢失）
docker compose down
sudo rm -rf elasticsearch/data/*
docker compose up -d
# 注意：重建后需重新设置 kibana_system 密码

# 备份
tar -czf es-backup-$(date +%F).tar.gz elasticsearch/data
```

## 安装 IK 分词器

```bash
# 版本号必须与 ES 完全一致
docker exec -it elasticsearch bin/elasticsearch-plugin install \
  https://github.com/infinilabs/analysis-ik/releases/download/v9.4.4/elasticsearch-analysis-ik-9.4.4.zip

docker compose restart elasticsearch

# 验证
curl -u elastic:123456 -X POST "http://localhost:9200/_analyze?pretty" \
  -H 'Content-Type: application/json' \
  -d '{"analyzer":"ik_max_word","text":"中华人民共和国"}'
```

> `plugins` 目录已映射到宿主机，插件会落到 `elasticsearch/plugins/`，容器重建后仍保留。若映射后启动报插件缺失，注释掉 compose 里该行挂载即可。

## Logstash 使用

参考 pipeline 配置：

```conf
input {
  beats { port => 5044 }
}

filter {
  # 按需添加 grok / date / mutate
}

output {
  elasticsearch {
    hosts    => ["http://elasticsearch:9200"]
    user     => "elastic"
    password => "123456"
    index    => "app-log-%{+YYYY.MM.dd}"
  }
  stdout { codec => rubydebug }   # 调试用，生产移除
}
```

修改 `logstash.conf` 后重启生效：

```bash
docker compose restart logstash
```

在 Kibana 中查看数据：**Management → Stack Management → Data Views → Create data view**，索引模式填 `app-log-*`，时间字段选 `@timestamp`，然后到 **Discover** 查询。

## 故障排查

| 现象 | 原因 | 解决 |
|---|---|---|
| ES 反复重启，日志 `AccessDeniedException` | 挂载目录权限不对 | `sudo chown -R 1000:1000 elasticsearch` |
| ES 报 `vm.max_map_count too low` | 内核参数未设置 | `sudo sysctl -w vm.max_map_count=262144` |
| ES 报 `Settings must not be specified in both` | 同一配置在 yml 和环境变量中重复 | 删掉 compose 中重复的环境变量 |
| Kibana 打不开，日志 `unable to authenticate user [kibana_system]` | kibana_system 密码未设或不一致 | 执行"设置 kibana_system 密码"步骤 |
| Kibana 显示「您无权访问请求的页面」 | 用 kibana_system 登录了 UI | 访问 `/logout` 换 `elastic` 登录 |
| Kibana 一直 `Kibana server is not ready yet` | ES 未就绪或迁移中 | 等 1-2 分钟，看 ES 健康状态 |
| 容器被 OOM Kill | `mem_limit` 与 JVM heap 不匹配 | heap 应约为 mem_limit 的 50% |
| ES 日志 `Owner of file [users] used to be [root]` | chown 导致的属主变更提示 | 无害警告，可忽略 |

## 生产环境注意事项

当前配置面向**本地开发**，直接上生产存在风险：

- 密码 `123456` 过于简单，改用 `.env` 文件管理：`ELASTIC_PASSWORD=${ES_PASSWORD}`
- `xpack.security.http.ssl.enabled: false` 为明文传输，生产应启用 TLS
- `http.cors.allow-origin: "*"` 允许任意跨域，生产应收窄
- 9200/9300 端口不应直接暴露公网
- JVM heap 512m 仅够测试，生产建议 ≥ 4g 且不超过物理内存 50%、不超过 31g
- 单节点无副本，需配置多节点集群 + 快照仓库（`path.repo`）
- `kibana.yml` 中三个 `encryptionKey` 请替换为自己生成的随机串，且**部署后不要再改**（改了会导致已存的加密对象无法解密）

```bash
# 生成随机 key
openssl rand -hex 32
```

## 版本升级提示

升级 ES 大版本时 Kibana 会执行 saved objects 迁移，**务必先备份** `elasticsearch/data` 和 `.kibana` 索引。三个组件版本号必须保持一致，插件版本也需同步更新。
