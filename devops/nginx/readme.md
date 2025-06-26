```bash
nginx -t    # 测试配置文件是否正确, 检查nginx的默认配置文件
nginx -t -c filr_path  # 指定文件检查
nginx -s reload  # 重新加载配置文件, 无需重启服务
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
