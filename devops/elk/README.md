## <mark>常用命令</mark>
```bash
curl -u elastic:password http://localhost:9200/?pretty    # 查看es基本信息
curl -u elastic:password http://localhost:9200/_cluster/health?pretty   # 查看集群健康状态
curl -u elastic:password http://localhost:9200/_cat/nodes?v   # 查看节点列表
curl -u elastic:password http://localhost:9200/_cluster/settings?pretty  # 查看集群设置
curl -u elastic:password http://localhost:9200/_cat/indices?v  # 查看所有索引

```
> 如果 ES 开启了认证（比如 Elasticsearch 8.x 默认安全开启）, 才需要加 -u
