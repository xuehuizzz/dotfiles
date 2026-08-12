```bash
# ==========================================================
# Elasticsearch 常用操作 · Kibana Dev Tools 版
# 用法：整段粘贴进 Dev Tools，光标放到某条请求上 Ctrl/Cmd + Enter 执行
# ==========================================================


# ========== 一、集群 / 节点状态 ==========

# 基本信息（版本号等）
GET /

# 集群健康（green/yellow/red）
GET _cluster/health

GET _cat/health?v

# 按索引查看健康
GET _cluster/health?level=indices

# 节点列表（CPU、内存、磁盘、角色、master标记*）
GET _cat/nodes?v&h=ip,name,node.role,master,cpu,heap.percent,ram.percent,disk.used_percent,load_1m

# 主节点
GET _cat/master?v

# 磁盘分配情况
GET _cat/allocation?v

# 集群/索引级设置
GET _cluster/settings?include_defaults=false&flat_settings=true

# 节点详细统计（线程池、JVM、fs 等）
GET _nodes/stats

GET _cat/thread_pool?v

# 所有 _cat 接口列表
GET _cat


# ========== 二、索引管理 ==========

# 查看所有索引（按大小排序）
GET _cat/indices?v&s=store.size:desc

GET _cat/indices/my-index-*?v&h=index,health,docs.count,store.size

# 查看索引结构（settings + mappings）
GET my-index

GET my-index/_mapping

GET my-index/_settings

# 创建索引
PUT my-index
{
  "settings": {
    "number_of_shards": 3,
    "number_of_replicas": 1
  },
  "mappings": {
    "properties": {
      "title":      { "type": "text" },
      "status":     { "type": "keyword" },
      "created_at": { "type": "date" },
      "count":      { "type": "long" }
    }
  }
}

# 删除索引
DELETE my-index

# 新增字段（mapping 只能加不能改）
PUT my-index/_mapping
{
  "properties": {
    "new_field": { "type": "keyword" }
  }
}

# 修改动态设置（如副本数、刷新间隔）
PUT my-index/_settings
{
  "index": {
    "number_of_replicas": 0,
    "refresh_interval": "30s"
  }
}

# 关闭 / 打开索引
POST my-index/_close

POST my-index/_open

# 刷新 / 段合并（force merge 很重，低峰期做）
POST my-index/_refresh

POST my-index/_flush

POST my-index/_forcemerge?max_num_segments=1

# 统计
GET my-index/_count

GET my-index/_stats

# 分片分布 / 未分配原因
GET _cat/shards/my-index?v&h=index,shard,prirep,state,docs,store,node,unassigned.reason

GET _cluster/allocation/explain


# ========== 三、文档 CRUD ==========

# 写入（指定 id，幂等）
PUT my-index/_doc/1
{
  "title": "hello",
  "status": "ok",
  "created_at": "2024-01-01"
}

# 写入（自动生成 id）
POST my-index/_doc
{
  "title": "world"
}

# 只在不存在时创建
PUT my-index/_create/1
{
  "title": "a"
}

# 查询单条 / 只看 _source
GET my-index/_doc/1

GET my-index/_source/1

# 判断存在（返回 200 / 404）
HEAD my-index/_doc/1

# 局部更新
POST my-index/_update/1
{
  "doc": { "status": "fail" }
}

# 脚本更新
POST my-index/_update/1
{
  "script": {
    "source": "ctx._source.count += params.n",
    "params": { "n": 1 }
  }
}

# 删除
DELETE my-index/_doc/1

# 批量 bulk（每行一个 JSON，不能美化换行，最后留一个空行）
POST _bulk
{"index":{"_index":"my-index","_id":"1"}}
{"title":"a"}
{"update":{"_index":"my-index","_id":"1"}}
{"doc":{"title":"b"}}
{"delete":{"_index":"my-index","_id":"2"}}

# 注意：Dev Tools 无法读取本地文件（等价于 --data-binary @data.json），
#       大批量导入请用 curl / Filebeat / Logstash / File Data Visualizer

# 批量查询
GET _mget
{
  "docs": [
    { "_index": "my-index", "_id": "1" },
    { "_index": "my-index", "_id": "2" }
  ]
}


# ========== 四、查询检索 ==========

# 查全部（默认返回 10 条）
GET my-index/_search?size=5

# URI 简易查询
GET my-index/_search?q=status:ok&size=2&sort=created_at:desc

# DSL：bool + 分页 + 排序 + 字段裁剪
POST my-index/_search
{
  "from": 0,
  "size": 20,
  "track_total_hits": true,
  "_source": ["title", "status"],
  "query": {
    "bool": {
      "must": [
        { "match": { "title": "hello" } }
      ],
      "filter": [
        { "term": { "status": "ok" } },
        { "range": { "created_at": { "gte": "now-7d/d", "lte": "now" } } }
      ],
      "must_not": [
        { "term": { "deleted": true } }
      ]
    }
  },
  "sort": [
    { "created_at": { "order": "desc" } }
  ]
}

# 聚合
POST my-index/_search
{
  "size": 0,
  "aggs": {
    "by_status": {
      "terms": { "field": "status", "size": 10 },
      "aggs": {
        "avg_count": { "avg": { "field": "count" } }
      }
    },
    "per_day": {
      "date_histogram": {
        "field": "created_at",
        "calendar_interval": "day"
      }
    }
  }
}

# 深分页：search_after（推荐）
POST my-index/_search
{
  "size": 1000,
  "query": { "match_all": {} },
  "sort": [
    { "created_at": "desc" },
    { "_shard_doc": "asc" }
  ]
}

# 下一页：把上一页最后一条的 sort 值填进 search_after
POST my-index/_search
{
  "size": 1000,
  "query": { "match_all": {} },
  "search_after": ["2024-01-01T00:00:00.000Z", 12345],
  "sort": [
    { "created_at": "desc" },
    { "_shard_doc": "asc" }
  ]
}

# 深分页：scroll（老方式）
POST my-index/_search?scroll=2m
{
  "size": 1000,
  "query": { "match_all": {} }
}

POST _search/scroll
{
  "scroll": "2m",
  "scroll_id": "<scroll_id>"
}

DELETE _search/scroll
{
  "scroll_id": "<scroll_id>"
}

# SQL 查询（x-pack）
POST _sql?format=txt
{
  "query": "SELECT status, count(*) FROM \"my-index\" GROUP BY status"
}

# 条件删除
POST my-index/_delete_by_query?conflicts=proceed
{
  "query": {
    "range": { "created_at": { "lt": "now-30d" } }
  }
}

# 条件更新（异步任务）
POST my-index/_update_by_query?conflicts=proceed&wait_for_completion=false
{
  "script": {
    "source": "ctx._source.status = 'ok'"
  },
  "query": {
    "term": { "status": "unknown" }
  }
}

# 分词测试
POST _analyze
{
  "analyzer": "standard",
  "text": "Hello Elasticsearch"
}

POST my-index/_analyze
{
  "field": "title",
  "text": "中文分词测试"
}

# 查询性能分析
POST my-index/_search
{
  "profile": true,
  "query": { "match_all": {} }
}

# 校验 DSL 语法
POST my-index/_validate/query?explain=true
{
  "query": { "match": { "title": "a" } }
}


# ========== 五、别名 / reindex / 模板 / ILM / 快照 ==========

# 别名
GET _cat/aliases?v

POST _aliases
{
  "actions": [
    { "remove": { "index": "my-index-v1", "alias": "my-index" } },
    { "add":    { "index": "my-index-v2", "alias": "my-index" } }
  ]
}

# reindex（改 mapping/分片数时用；大数据量加 wait_for_completion=false 走任务）
POST _reindex?wait_for_completion=false
{
  "source": { "index": "my-index-v1", "size": 5000 },
  "dest":   { "index": "my-index-v2" }
}

# 索引模板（ES 7.8+ 可组合模板）
PUT _index_template/my-tpl
{
  "index_patterns": ["my-log-*"],
  "template": {
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 1
    },
    "mappings": {
      "properties": {
        "@timestamp": { "type": "date" }
      }
    }
  }
}

GET _index_template/my-tpl

GET _cat/templates?v

# ILM
GET _ilm/policy

GET my-index/_ilm/explain

# 快照（先注册仓库，location 必须在 path.repo 白名单内）
PUT _snapshot/my_repo
{
  "type": "fs",
  "settings": { "location": "/mnt/es_backup" }
}

PUT _snapshot/my_repo/snap1?wait_for_completion=true
{
  "indices": "my-index"
}

GET _cat/snapshots/my_repo?v

POST _snapshot/my_repo/snap1/_restore
{
  "indices": "my-index"
}


# ========== 六、任务 / 慢查询排查 ==========

# 正在执行的任务
GET _cat/tasks?v&detailed=true

GET _tasks?actions=*search&detailed=true

# 查 reindex / update_by_query 进度
GET _tasks/<task_id>

POST _tasks/<task_id>/_cancel

# 热点线程（返回纯文本）
GET _nodes/hot_threads

# 慢日志阈值
PUT my-index/_settings
{
  "index.search.slowlog.threshold.query.warn": "2s",
  "index.indexing.slowlog.threshold.index.warn": "1s"
}

# pending tasks（集群卡住时看）
GET _cluster/pending_tasks


# ========== 七、用户与权限（x-pack） ==========

# 修改 elastic 密码
POST _security/user/elastic/_password
{
  "password": "newpass123"
}

# 用户 / 角色
GET _security/user

GET _security/role

POST _security/user/app_ro
{
  "password": "app123456",
  "roles": ["viewer"],
  "full_name": "readonly app"
}

# 查看当前认证身份 / 许可证
GET _security/_authenticate

GET _license


# ==========================================================
# 快捷键：Ctrl/Cmd + Enter 执行 | Ctrl/Cmd + I 补全
#         Ctrl/Cmd + / 注释    | Ctrl/Cmd + Alt + L 格式化
# 说明：无需 ?pretty，Console 自动格式化；布尔参数写成 =true 更稳妥
#       右上角扳手图标可 Copy as cURL 反向转回 curl 命令
# ==========================================================
```
