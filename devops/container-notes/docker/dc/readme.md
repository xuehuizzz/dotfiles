## docker-compose.yml
```yml
# 如果有敏感信息存于 .env 文件当中, 使用如下命令运行容器
# docker-compose --env-file envFilePath -f custom.yml up -d
#    --env-file指定了 .env 文件的路径, 不指定这个参数的话, 会默认加载当前目录下的 .env 文件
#    -f指定了自定义的yml文件, 不指定的话, 默认使用 docker-compose.yml文件
# 同理, 如果使用了自定义文件启动, 那么在downd的时候也应指定该文件,否则默认 docker-compose.yml
#     docker-compose -f custom.yml down

# 文件中的value值若包含空格/特殊字符, 或者是以数字开头, 应当用引号引起来
# 使用 volumes 映射路径时, 容器内的目录会如果不存在则自动创建, 宿主机的话, 如果使用绝对路径且不存在则不会自动创建, 相对路径可以


x-environment: &default-environment # 定义一个全局环境变量配置块
  TZ: Asia/Shanghai # 统一设置所有容器的时区为亚洲/上海
  
services: # 定义服务部分，每个服务对应一个容器
  web: # Web 服务
    image: nginx:alpine # 使用官方的 Nginx 镜像（基于 Alpine Linux）
    container_name: container_name  # 指定生成的容器名称
    ports: 
      - "80:80" # 将主机的 80 端口映射到容器的 80 端口
    deploy:  # 用于配置服务在集群模式下（如 Docker Swarm）部署的详细信息。它提供了控制服务如何分布、扩展、以及服务的更新策略等功能。deploy 配置通常在生产环境中使用，而在单机开发环境中，Docker Compose 不支持 deploy 部分的配置
      replicas: 3 # 指定该服务的副本数量，在集群中会运行 3 个相同的容器
      update_config: # 配置滚动更新策略
        parallelism: 2 # 每次更新 2 个容器
        delay: 10s # 每批次更新之间的延迟时间
        failure_action: rollback # 如果更新失败，回滚到之前的版本
        monitor: 60s # 更新过程中监控失败的时间长度
        max_failure_ratio: 0.1 # 允许最大失败率，超过则视为更新失败
        order: start-first # 容器更新顺序，先启动新容器再停止旧容器
      resources: # 资源限制和预留
        limits:
          cpus: '0.5' # 限制 CPU 使用量，最多 0.5 个 CPU
          memory: 512M # 限制内存使用量，最多 512MB
        reservations:
          cpus: '0.25' # 预留 CPU 资源，至少 0.25 个 CPU
          memory: 256M # 预留内存资源，至少 256MB
      restart_policy: # 定义容器的重启策略
        condition: on-failure # 仅在容器失败时重启
        delay: 5s # 重启前的延迟时间
        max_attempts: 3 # 最大重启尝试次数
        window: 120s # 重启尝试次数的时间窗口
      placement: # 控制服务的调度
        constraints: [node.role == manager] # 限制服务仅在管理节点上运行
        preferences: # 服务调度优先级设置
          - spread: node.labels.zone # 根据节点标签进行分布式调度
      endpoint_mode: vip # 配置服务的端点模式，可以是 `vip` 或 `dnsrr`  
    depends_on: 
      - db # 依赖于数据库服务，在 web 服务启动前需要确保 db 服务已启动
    networks: 
      - front-end # 将 web 服务连接到 front-end 网络
    volumes: 
      - web_data:/usr/share/nginx/html # 挂载卷，将数据持久化到宿主机
      # - /etc/timezone:/etc/timezone   # 也可通过这种方式配置容器内时间(当TZ不适用时)
      # - /etc/localtime:/etc/localtime
    working_dir: container_path  # 指定工作目录
    environment: 
      <<: *default-environment # 引用全局环境变量配置
      - NGINX_HOST=${NGINX_HOST} # 从 .env 文件中读取 NGINX_HOST 变量, 设置环境变量 NGINX_HOST 为 localhost
    restart: always # 重启策略，服务总是重新启动
             or    no：不自动重启。
                   on-failure：仅在失败时重启，可附加最大重启次数限制。例如 on-failure:3
                   unless-stopped：除非手动停止，否则始终重启。
    healthcheck: # 定义健康检查配置
      test: ["CMD", "curl", "-f", "http://localhost"] # 检查容器内的 localhost 服务是否可访问
      interval: 1m30s # 健康检查之间的时间间隔（每 1 分 30 秒执行一次）
      timeout: 10s # 健康检查的超时时间
      retries: 3 # 尝试次数，如果连续三次失败则认为容器不健康
      start_period: 40s # 容器启动后的宽限期，期间失败不计入重试
    labels: 
      com.example.description: "My web service" # 为服务添加自定义标签信息
  
  db: # 数据库服务
    image: postgres:latest # 使用官方的 PostgreSQL 最新镜像
    environment: 
      <<: *default-environment # 引用全局环境变量配置
      POSTGRES_USER: ${POSTGRES_USER} # 从 .env 文件中读取 POSTGRES_USER 变量, 设置 PostgreSQL 的用户为 user
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD} # 从 .env 文件中读取 POSTGRES_PASSWORD 变量, 设置 PostgreSQL 的密码为 password
    volumes: 
      - db_data:/var/lib/postgresql/data # 持久化数据库数据到宿主机
    networks: 
      - back-end # 将 db 服务连接到 back-end 网络

volumes: # 定义数据卷，用于持久化数据
  web_data: # 用于 web 服务的卷
  db_data: # 用于数据库服务的卷

networks: # 定义自定义网络
  front-end: # 前端网络，供 web 服务使用
  back-end: # 后端网络，供 db 服务使用
```
