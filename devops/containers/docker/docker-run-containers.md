- Portainer
    - Portainer 是一个用于管理 Docker 环境的图形化工具。它可以帮助用户轻松管理和监控 Docker 容器、镜像、网络等资源。用户可以随时通过 Portainer 部署新发现的容器和应用，提供了直观的 Web 界面。
- Nginx-UI
    - Nginx-UI 是一个用于管理 Nginx 配置的图形化界面工具。它使得用户能够快速配置反向代理、负载均衡和其他 Nginx 功能，而不需要手动编辑配置文件。适合快速反向代理的需求，简化了配置过程。
- Backrest
    - Backrest 是一个高效的备份工具，通常用于 PostgreSQL 数据库的备份。它支持将数据备份到不同的存储目标（如 OSS、S3等），确保数据的安全性和可恢复性。
- Certd
    - Certd 是一个自动化证书管理工具，它可以通过 pipeline 形式自动申请和管理 SSL 证书。通常用于自动化 DevOps 环境中的证书更新和管理，减少人工操作的错误和复杂性。
- Ztnet (ZeroTier Controller Panel)
    - Ztnet 是一个开源的 ZeroTier 控制器面板，用于管理和监控 ZeroTier 网络。ZeroTier 是一个用于创建虚拟局域网（VPN）的工具，Ztnet 提供了一个易用的界面来管理网络设备和配置，操作简单，界面友好。
- Gotify
    - Gotify 是一个用于消息推送的开源工具，提供实时通知功能。它支持将通知推送到 Web 界面或移动设备上，适用于需要实时消息的场景，如系统监控和报警通知。
- Alist
    - Alist 是一个文件管理工具，支持将文件存储在云端，并提供 Web 界面进行访问和管理。它支持多种存储后端，用户可以方便地浏览和管理云端文件，类似于 Google Drive 或 OneDrive。
- Uptime
    - Uptime 是一个监控和报告网站运行状态的工具。它可以定期检查指定网站的健康状态，并通过电子邮件或其他方式报告任何中断或故障，适用于网站和应用的实时监控。

1. **mysql**
  - ```bash
    docker run -d \
    --name mysql \
    -e MYSQL_ROOT_PASSWORD=admin \
    -e MYSQL_USER=admin \
    -e MYSQL_PASSWORD=admin \
    -e MYSQL_DATABASE=mydb \
    -v /Users/xuehuizzz/db/mysql:/app \
    -p 3306:3306 \
    -w /app \
    --restart always \
    mysql:8.4
    ```
2. **postgresql**
  - ```bash
    docker run -d \
    --name psql \
    -e POSTGRES_USER=admin \
    -e POSTGRES_PASSWORD=admin \
    -e POSTGRES_DB=mydb \
    -v /Users/xuehuizzz/db/postgresql:/app \
    -p 5432:5432 \
    -w /app \
    --restart always \
    postgres:15
    ```
3. **jenkins**
  - ```bash
    docker run -d \
    --name jenkins \
    -p 8080:8080 \
    -p 50000:50000 \
    -v /Users/xuehuizzz/jenkins:/var/jenkins_home \
    --restart always \
    jenkins/jenkins:lts
    ```
4. **arangodb**
  - ```bash
    docker run -e ARANGO_ROOT_PASSWORD=admin \
    -d --name arangodb \
    -p 8529:8529 \
    -v /Users/xuehuizzz/db/arango/data:/var/lib/arangodb3 \
    -v /Users/xuehuizzz/db/arango/apps:/var/lib/arangodb3-apps \
    --restart always \
    arangodb:latest
    ```
