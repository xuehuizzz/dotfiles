1. ## 环境准备
    ```bash
    # 需要安装如下依赖: Docker Engine、Docker Compose 和 Openssl(用于生成证书)
    curl -fsSL https://get.docker.com | sudo sh  # 安装Docker, docker compose已经内置于docker engine中,因此不需额外安装
    sudo apt install openssl  # 大多数 Linux 发行版都自带 OpenSSL
    sudo systemctl enable docker && sudo systemctl start docker  # 启动docker服务并设置开机自启
    ```
2. ## 下载Harbor离线安装包
    ```bash
    wget -c https://github.com/goharbor/harbor/releases/download/v2.12.2/harbor-offline-installer-v2.12.2.tgz  # 可自行选择版本
    tar -zxvf harbor-offline-installer-v2.12.2.tgz   # 解压安装包
    ```
3. ## 配置Harbor
    - 复制配置文件模板
      ```bash
      cd harbor
      cp harbor.yml.tmpl harbor.yml
      ```
    - 编辑配置文件<sub>`vim harbor.yml`</sub>
      ```yaml
        hostname: your-domain.com  # 改为您的域名或IP地址
        https:
          port: 443
          certificate: /your/certificate/path
          private_key: /your/private/key/path
        harbor_admin_password: Harbor12345  # 修改管理员密码
        database:
          password: root123    # 修改数据库密码
      ```
4. ## 生成HTTPS证书(如果需要)
    ```bash
    mkdir -p /data/cert  # harbor证书位置
    cd /data/cert
    
    # 生成证书
    openssl genrsa -out ca.key 4096
    openssl req -x509 -new -nodes -sha512 -days 3650 \
     -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=your-domain.com" \
     -key ca.key \
     -out ca.crt
    ```
5. ## 安装Harbor
    ```bash
    ./install.sh
    ```
6. ## 验证安装
    安装完成后, 可以通过浏览器访问配置的域名或IP地址. 默认用户名为 `admin` , 密码为您在 `harbor.yml` 中设置的 `harbor_admin_password`.
7. ## 配置Docker客户端使用Harbor
    在需要使用 Harbor 的客户端机器上，编辑 Docker 配置文件：
    ```bash
    vim /etc/docker/daemon.json
    ```
    添加以下内容:
    ```json
    {
      "insecure-registries" : ["your-domain.com"]
    }
    ```
    重启Docker服务:
    ```bash
    systemctl restart docker
    ```
8. ## 登录测试
    ```bash
    docker login your-domain.com/ip

    # web端访问
    http://ip
    user: admin
    pwd: Harbor12345   # 见harbor.yml
    ```
    
## <mark>常见问题:</mark>
```bash
# 如果遇到证书问题，可以将证书复制到 Docker 的证书目录
mkdir -p /etc/docker/certs.d/your-domain.com
cp ca.crt /etc/docker/certs.d/your-domain.com/

# 如果需要停止 Harbor, 当前路径一定在Harbor目录中,或指定这个目录中的文件
docker compose down

# 如果需要启动 Harbor, 当前路径一定在Harbor目录中,或指定这个目录中的文件
docker compose up -d
```
