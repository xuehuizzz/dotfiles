## <mark>常用命令</mark>
```bash
curl -u elastic:password http://localhost:9200/?pretty    # 查看es基本信息
curl -u elastic:password http://localhost:9200/_cluster/health?pretty   # 查看集群健康状态
```
> 如果 ES 开启了认证（比如 Elasticsearch 8.x 默认安全开启）, 才需要加 -u
