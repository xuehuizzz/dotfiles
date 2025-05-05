## Web访问
- Grafana:
  - host: http://localhost:3000
  - user: admin
  - pwd: admin
- Prometheus: http://localhost:9090/alerts
- Alertmanager: http://localhost:9093


## Prometheus + Grafana
- 若要新增监控服务, 仅需更新docker-compose.yml 和 prometheus/prometheus.yml即可
- 监控MySQL的话, MySQL需存在my.cnf配置文件

## Grafana模版推荐
- 服务器监控: 11074, 1860
- MySQL监控: 7362
