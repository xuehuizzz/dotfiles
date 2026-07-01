## docker-compose.yml
```yml
# 如果有敏感信息存于 .env 文件当中, 使用如下命令运行容器
# docker-compose --env-file envFilePath -f custom.yml up -d
#    --env-file 指定了 .env 文件的路径, 不指定这个参数的话, 会默认加载当前目录下的 .env 文件
#    -f 指定了自定义的 yml 文件, 不指定的话, 默认使用 docker-compose.yml 文件
# 同理, 如果使用了自定义文件启动, 那么在 down 的时候也应指定该文件, 否则默认 docker-compose.yml
#     docker-compose -f custom.yml down

# 文件中的 value 值若包含空格/特殊字符, 或者是以数字开头, 应当用引号引起来
# 使用 volumes 映射路径时, 容器内的目录如果不存在则自动创建; 宿主机的话, 绝对路径不存在不会自动创建, 相对路径可以
# 如果相对路径只有名称 testPath 而不是 ./testPath, 那么生成的数据卷名称为 项目名_testPath (项目名即 docker-compose 文件所在目录名)
# 数据卷位于:   Linux:  /var/lib/docker/volumes/
#              Mac:   ~/Library/Containers/com.docker.docker/Data/vms/0/data/
#              Windows: C:\ProgramData\Docker\volumes\

x-environment: &default-environment  # 定义一个全局环境变量配置块 (锚点为 map 结构)
  TZ: Asia/Shanghai                  # 统一设置所有容器的时区为亚洲/上海

services:                            # 定义服务部分, 每个服务对应一个容器
  web:                               # Web 服务
    image: nginx:alpine              # 使用官方的 Nginx 镜像 (基于 Alpine Linux)
    # container_name: my_web         # 注意: 若配置了固定容器名, 则不能与 deploy.replicas>1 同时使用 (名称会冲突)
    ports:
      - "80:80"                      # 将主机的 80 端口映射到容器的 80 端口
    deploy:                          # 集群模式 (Docker Swarm) 部署配置
                                     # 注意: docker-compose up 下, 除 resources 在新版会生效外,
                                     #      replicas / placement / update_config / restart_policy 均被忽略
      replicas: 3                    # 指定该服务的副本数量, 在集群中运行 3 个相同的容器
      update_config:                 # 配置滚动更新策略
        parallelism: 2               # 每次更新 2 个容器
        delay: 10s                   # 每批次更新之间的延迟时间
        failure_action: rollback     # 如果更新失败, 回滚到之前的版本
        monitor: 60s                 # 更新过程中监控失败的时间长度
        max_failure_ratio: 0.1       # 允许最大失败率, 超过则视为更新失败
        order: start-first           # 容器更新顺序, 先启动新容器再停止旧容器
      resources:                     # 资源限制和预留
        limits:
          cpus: '0.5'                # 限制 CPU 使用量, 最多 0.5 个 CPU
          memory: 512M               # 限制内存使用量, 最多 512MB
        reservations:
          cpus: '0.25'               # 预留 CPU 资源, 至少 0.25 个 CPU
          memory: 256M               # 预留内存资源, 至少 256MB
      restart_policy:                # 定义容器的重启策略 (Swarm 模式下生效)
        condition: on-failure        # 仅在容器失败时重启
        delay: 5s                    # 重启前的延迟时间
        max_attempts: 3              # 最大重启尝试次数
        window: 120s                 # 重启尝试次数的时间窗口
      placement:                     # 控制服务的调度
        constraints: [node.role == manager]  # 限制服务仅在管理节点上运行
        preferences:                 # 服务调度优先级设置
          - spread: node.labels.zone # 根据节点标签进行分布式调度
      endpoint_mode: vip             # 配置服务的端点模式, 可以是 vip 或 dnsrr
    depends_on:                      # 依赖关系
      db:                            # 使用长格式, 等待 db 通过健康检查后再启动 web
        condition: service_healthy   # depends_on 仅控制顺序, service_healthy 才能保证 db 真正就绪
    networks:
      - front-end                    # 接入前端网络 (对外)
      - back-end                     # 同时接入后端网络, 否则无法与 db 通信 (depends_on 不建立网络连通性)
    volumes:
      - web_data:/usr/share/nginx/html  # 挂载卷, 将数据持久化
      # - /etc/timezone:/etc/timezone     # 也可通过这种方式配置容器内时间 (当 TZ 不适用时)
      # - /etc/localtime:/etc/localtime
    working_dir: /usr/share/nginx/html    # 指定工作目录 (请替换为实际路径)
    environment:
      <<: *default-environment       # 引用全局环境变量配置 (map 结构, 合并后须继续用 map 语法)
      NGINX_HOST: ${NGINX_HOST}      # 从 .env 读取 NGINX_HOST 变量 (map 语法, 不可与 - key=value 混用)
    # 重启策略取值:
    #   no             : 不自动重启
    #   always         : 总是重启
    #   on-failure     : 仅在失败时重启, 可附加最大次数, 如 on-failure:3
    #   unless-stopped : 除非手动停止, 否则始终重启
    restart: always                  # 重启策略, 服务总是重新启动
    healthcheck:                     # 定义健康检查配置
      test: ["CMD", "curl", "-f", "http://localhost"]  # 检查容器内 localhost 服务是否可访问
      interval: 1m30s                # 健康检查之间的时间间隔 (每 1 分 30 秒执行一次)
      timeout: 10s                   # 健康检查的超时时间
      retries: 3                     # 连续三次失败则认为容器不健康
      start_period: 40s              # 容器启动后的宽限期, 期间失败不计入重试
    labels:
      com.example.description: "My web service"  # 为服务添加自定义标签信息

  db:                                # 数据库服务
    image: postgres:latest           # 使用官方的 PostgreSQL 最新镜像
    environment:
      <<: *default-environment       # 引用全局环境变量配置
      POSTGRES_USER: ${POSTGRES_USER}         # 从 .env 读取, 设置 PostgreSQL 用户
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD} # 从 .env 读取, 设置 PostgreSQL 密码
    volumes:
      - db_data:/var/lib/postgresql/data      # 持久化数据库数据
    networks:
      - back-end                     # 接入后端网络, 供 web 访问
    healthcheck:                     # 数据库健康检查, 供 web 的 service_healthy 依赖使用
      test: ["CMD-SHELL", "pg_isready -U ${POSTGRES_USER}"]  # 判断 Postgres 是否已可接受连接
      interval: 10s                  # 检查间隔
      timeout: 5s                    # 超时时间
      retries: 5                     # 重试次数
      start_period: 30s              # 启动宽限期

volumes:                             # 定义数据卷, 用于持久化数据
  web_data:                          # 用于 web 服务的卷
  db_data:                           # 用于数据库服务的卷

networks:                            # 定义自定义网络
  front-end:                         # 前端网络, 供 web 服务对外使用
  back-end:                          # 后端网络, 供 web 与 db 之间通信
```
