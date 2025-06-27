```bash
sudo nginx -t   # 测试配置是否语法正确
sudo nginx -s reload   # 强制重新加载配置文件
sudo nginx -s stop    # 快速停止
sudo nginx -s quit   # 优雅停止

openssl x509 -in /path/to/server.crt -noout -enddate  # 查看nginx证书过期时间
openssl s_client -connect ip:port -showcerts  # 查看要代理地址的证书过期时间   
```
> Not Before 和 Not After 字段，这些字段表示证书的生效和失效日期
>
> Issuer: 如果 Issuer 和 Subject 是相同的，说明这是一个自签名证书。


# gixy
```bash
# 分析和检测 Nginx 配置文件中潜在安全问题
pip install gixy

gixy /etc/nginx/nginx.conf
```
