## 安装配置<sub>推荐官方脚本安装</sub>

```bash
sudo curl -fsSL https://get.docker.com | sudo sh  # 官方安装脚本
sudo systemctl start docker   # 开启docker服务
sudo systemctl enable docker  # 设置开机自启
sudo systemctl stop docker   # 停止docker服务
sudo systemctl restart docker   # 重启docker服务
```

<mark>常用命令</mark>
```cmd
# 在构建镜像的时候, 如果这个镜像需要上传到镜像仓库, 那么名称应该为: 仓库地址/项目名称/镜像名称:tag
docker build \    # 构建镜像文件
  --build-arg http_proxy=http://你的代理地址:端口 \
  --build-arg https_proxy=http://你的代理地址:端口 \
  --build-arg no_proxy=localhost,127.0.0.1 \
  -t your-image-name:tag .     # 应与Dockerfile同一目录, 或使用 -f 指定dockerfile文件

docker run \
  -itd \  # 以交互式后台运行容器
  --name my_container \  # 指定容器名称
  --restart unless-stopped \  # 只有容器被手动停止,容器才不会尝试重启
  --network bridge \  # docker的默认网络模式, 不需要显式指定, 这里的bridge指的是 `docker network ls`中的NAME, 而不是DRIVER
  -p 8080:80 \  # 映射主机的端口8080到容器的端口80
  -v /host/data:/container/data \  # 挂载主机的目录到容器的目录
  -w /container/data \  # 设置工作路径,即进入容器内部默认路径
  --health-cmd="curl --fail http://localhost:8080 || exit 1" \
  --health-interval=30s \   # 两次健康检查之间的时间间隔（默认30秒）
  --health-timeout=5s \   # 健康检查命令的超时时间。如果超过这个时间，健康检查视为失败（默认30秒）
  --health-retries=3 \   # 如果连续多少次健康检查失败，认为容器处于不健康状态（默认3次）
  --health-start-period=30s \   # 容器启动后多长时间开始执行健康检查（默认0秒）。这可以为应用程序预留启动时间
  --device-read-bps /dev/sda:10mb --device-write-bps /dev/sda:10mb \   # 限制容器对特定设备的读写速率(每秒字节数): 10mb, 防止某个容器过度占用IO资源，影响到宿主机或其他容器的正常运行
  --device-read-iops /dev/sda:1000 --device-write-iops /dev/sda:1000 \   # 限制每秒的IO操作数为1000
  my_image:latest  # 使用的镜像

getent group docker  # 检查docker组是否存在
sudo groupadd docker  # 创建docker组
sudo usermod -aG docker $USER && exec su - $USER   # 将当前用户添加到docker组并使其生效, 或修改当前会话组(newgrp docker)立即应用使其生效
docker -v  # 列出docker客户端版本信息
docker version  # 详细列出客户端和服务端的版本信息
docker info  # 列出docker环境详细信息
docker stats 容器ID/名称   # 查看容器状态
docker plugin ls  # 列出已安装的插件
docker diff 容器ID/名称  # 查看容器文件系统的自创建以来的变化(A: 新增, C: 修改过, D: 已删除)
docker rename 容器ID/名称 new_container_name  # 重命名容器
docker ps -a  # 查看所有容器(等于: docker container ls -a), --no-trunc 显示完整的命令
docker ps -q  # 列出所有运行中容器的ID,  -aq: 列出所有容器id
docker volume ls  # 列出容器卷
docker volume create colume_name  # 创建容器卷
docker volume rm colume_name  # 删除容器卷(慎用)
docker ps --format "{{.Names}}\t{{.ID}}"    # 仅列出容器名称和容器ID
docker stop/start 容器ID/名称    # 停止/启动容器
docker restart 容器ID/名称    # 重启容器
docker restart $(docker ps -aq)   # 重启所有容器
docker logs -f --tail num 容器ID/名称   # 查看docker日志最新xxx条
docker inspect 容器ID/名称(镜像ID/镜像名称)   # 查看容器/镜像的详细信息
docker exec -it 容器ID/名称 bash   # 交互式进入容器内部
docker iamges   # 查看所有镜像(docker image ls)
docker cp <容器名称或ID>:<容器内路径> <宿主机路径>  # 从容器复制到宿主机
docker cp <宿主机路径> <容器名称或ID>:<容器内路径>  # 从宿主机复制到容器
docker rm 容器ID/名称  # 删除已停止的容器, -f:强制删除运行中的容器, 谨慎使用
docker rmi 镜像ID  # 删除指定镜像, -f:强制删除镜像, 谨慎使用
docker rmi 镜像名称:tag  # 删除镜像文件(只有这一个标签的话), 如果一个镜像文件有多个标签, 则只会删除这一个标签
docker tag old_image_name:old_tag new_image_name:new_tag  # 镜像别名, docker tag imageID new_image_name:new_tag

docker network ls   # 列出当前docker环境中所有网络, 一个docker容器可以连接多个网络
docker network inspect 网络ID/名称   # 查看某个网络的详细信息
docker network create --driver bridge my-custom-network   # 创建一个新的自定义网络, 指定类型为 bridge, docker network create -d xxx xxx
docker network connect 网络ID/名称 容器ID/名称    # 将一个容器连接到一个指定的网络(一个容器可以连接多个网络, bridge、overlay、macvlan)
docker network disconnect 网络ID/名称 容器ID/名称   # 断开连接网络
docker network rm 网络ID/名称   # 删除网络

# 若使用 -f 指定配置文件, 则如下操作: docker compose -f xxx.yaml xxx
docker compose config # 检查docker-compose.yml文件是否有语法错误,  -f <file_path> 指定检查文件, --format=json 以json格式输出
docker compose up -d  # 后台创建并运行容器(在docker-compose.yml同一目录下), 可指定文件, docker compose -f file_path up -d
docker compose down   # 停止并删除容器(在docker-compose.yml同一目录下), 同上 docker compose -f file_path down,  --volumes  保留数据卷
docker compose ls  # 列出所有运行中的 Compose 项目, --all 列出所有  --format json
docker compose ps   # 列出当前compose项目的容器
docker compose restart  # 重启当前compose项目所有服务,  <service_name> 重启特定服务
docker compose stop  # 停止所有服务
docker compose start # 启动已停止的服务

docker history 镜像ID/名称  # 查看镜像的构建信息,
  --no-trunc：显示完整的输出信息（默认会截断过长的内容）。
  -q 或 --quiet：只显示镜像层的 ID。
  -h 或 --human：以人类可读的格式显示镜像大小（默认启用）。

# 常用prune命令(不可逆操作, 慎用)
docker container prune  # 清理未使用的容器
docker image prune   # 清理所有无用的悬空镜像（dangling images），即没有被任何容器使用的镜像, -a 删除所有未使用的镜像
docker network prune  # 清理未使用的网络(默认网络除外)
docker volume prune  # 清理未使用的卷
docker system prune  # 清理所有停止的容器、无用的镜像(dangling images）、未使用的网络、未使用的卷（添加 --volumes 参数时）
```

一.<mark>使用save和load导出并导入镜像</mark>

```markdown
# 导出镜像
docker save -o [导出文件名].tar [镜像名称]:[标签]
    docker save -o my_image.tar my_image:latest
# 导入镜像    
docker load -i [导入文件名].tar
    docker load -i my_image.tar
```

二.使用export和import导出并导入容器文件系统为镜像

```markdown
# 导出容器文件
docker export -o [导出文件名].tar [容器ID或名称]
    docker export -o my_container.tar my_container
# 导入容器文件为镜像
docker import [导入文件名].tar [新镜像名称]:[标签]
    docker import my_container.tar my_new_image:latest
```

三:<mark>docker容器重启策略</mark>

- `no`: 默认策略, 不会自动重启容器
- `on-failure`: 仅在容器已非零状态码退出时才会自动重启, 可以指定尝试重启的次数.  --restart=on-failure:5
- `always`: 无论容器如何退出, 总是会自动重启容器
- `unless-stopped`: 类似于`always`, 但当容器被手动停止(例如`docker stop`)时, 则不会自动重启

四.<mark>docker容器网络概述</mark>

- 支持动态多网络连接: bridge、overlay、macvlan、ipvlan(每次只能连接1个,多次完成)
- 不支持动态多网络连接: host、none

①. `桥接网络 bridge`
- 当你创建容器但未指定网络时, 默认使用桥接网络
- 容器之间可以通过容器名互相通信
- 支持端口映射, 使外部访问容器服务成为可能
- ```bash
  # 查看当前网络
  docker network ls
  docker network create network_name  # 默认创建bridge网络
  # 创建自定义桥接网络
  docker network create --driver bridge my-bridge-network
  # 运行容器并连接到自定义桥接网络
  docker run -d --name my-container --network my-bridge-network my-image
  ```

②. `主机网络 host`
- 容器共享主机的网络栈, 没有网络隔离.  提高网络性能, 减少网络开销
- 使用场景: 对网络性能要求高, 或需要容器直接使用主机网络的场景
- ```bash
  # 不能使用docker network create --driver方式创建
  # 所以也不能对一个已存在的容器进行connect或disconnect
  docker run -d --name my-container --network host my-image
  ```

③. `覆盖网络 overlay`
- 跨多个docker主机创建网络, 适用于Swarm集群或Kubernetes集群
- 允许不同主机上的容器像在同一网络中一样通信
- ```bash
  # 创建覆盖网络
  docker swarm init  #  将当前节点初始化为 Swarm 的管理节点
  docker network create -d overlay my-overlay-network
  # 在Swarm服务中使用覆盖网络
  docker service create --name my-service --network my-overlay-network my-image
  ```
  
④. `无网络 none`
- 容器没有网络接口, 完全隔离, 适用于不需要网络通信的特殊场景
- ```bash
  docker run -d --name my-container --network none my-image
  ```

⑤. `macvlan`
- macvlan 是一种将物理网卡虚拟化并分配多个 MAC 地址的网络模式。它允许每个容器表现为网络中的一个独立设备
- 特点
  - 独立 MAC 地址: 每个容器有一个唯一的 MAC 地址，就像一个物理设备。
  - 直接连接到物理网络: 容器通过主机的物理网卡直接与外部网络通信。
  - 隔离性强: 容器与主机在网络上是独立的，主机无法直接访问这些容器（需要额外配置）。
  - 性能高: 类似裸机的网络性能，适用于高吞吐量的场景。
- ```bash
  docker network create --driver macvlan my-macvlan-network
  ```

⑥. `ipvlan`
- ipvlan 是基于 IP 层的虚拟化网络模式，不需要为每个容器分配独立的 MAC 地址，而是使用主机的 MAC 地址。
- 特点:
  - 共享 MAC 地址: 所有容器共享主机的 MAC 地址，减少了 MAC 地址数量的需求。
  - 直接连接到物理网络: 容器通过主机的物理网卡直接与外部网络通信。
  - 模式简单: 提供更简单的网络拓扑结构。
  - 性能稍逊于 macvlan: 因为流量需要更多的处理。
- ```bash
  docker network create -d macvlan my-macvlan-network
  ```


⑦. `其它网络模式`
- 允许一个容器与另一个容器共享网络命名空间, 不需要单独分配IP地址, 使用同一网卡、主机名、IP 地址
- ```bash
  # 运行第一个容器
  docker run -d --name container1 my-image
  # 运行第二个容器，并与第一个容器共享网络
  docker run -d --name container2 --network container:container1 my-image
  ```

五.<mark>docker swarm</mark>

`Docker Swarm 是 Docker 提供的原生容器编排工具，允许用户将多个 Docker 主机集合成一个虚拟的集群，并在该集群上管理和调度容器的部署和运行。`
`它通过简单的配置将 Docker 引擎转变为一个分布式系统，为用户提供了高可用性、负载均衡、容错等特性。`

- 主要特性:
  1. 集群管理: Docker Swarm 将多台 Docker 主机组织成一个逻辑集群，主机分为管理节点（Manager Node）和工作节点（Worker Node）。
  2. 服务编排: 用户可以定义和部署服务（Service），指定所需的容器数量、副本策略等，Swarm 会自动调度这些容器到集群中的节点。
  3. 高可用性: 通过 Manager 节点的冗余，Swarm 保证了集群的管理能力即使部分节点故障也能正常工作。
  4. 负载均衡: Swarm 会根据服务定义自动在节点间分配任务，并使用内部的负载均衡将流量分发到对应的服务实例。
  5. 滚动更新: 支持滚动更新服务，在更新过程中逐步替换旧的容器，确保服务的不中断。
  6. 服务发现: 内置 DNS 服务，支持服务通过名称解析，节点无需额外配置即可发现和访问其他服务。
  7. 安全通信: Swarm 节点之间通过 TLS 加密通信，保证数据传输安全。

- 关键概念:
  1. 节点(Node): 集群中的一台主机，可以是物理机或虚拟机。节点有两种角色：
     - 管理节点(Manager Node): 负责集群管理、任务调度和状态维护。
     - 工作节点(Worker Node): 运行实际的容器任务。
  2. 服务(Service): 定义任务的运行方式，包括镜像、容器数量、副本策略等。
  3. 任务(Task: Swarm 中的最小工作单元，每个任务对应一个运行中的容器。
  4. 栈(Stack): 类似于 Docker Compose，栈用于定义一组服务的集成部署。

##### 使用步骤:
```bash
docker swarm init  # 初始化swarm集群

```

六.<mark>docker run参数</mark>

①容器命名与标签
- `--name <容器名>`: 为容器指定一个唯一名称, 方便后续管理
- `--label <键=值>`: 为容器添加元数据标签

②后台运行与交互模式
- `-d, --detach`: 让容器在后台运行
- `-it`: 结合 `-i` (保持标准输入打开) 和 `-t` (分配伪终端),用于交互式会话

③端口映射
- `-p <宿主机端口>:<容器端口>`: 将宿主机的端口映射到容器内的端口
- `--publish-all`或`-P`: 随机映射所有容器暴露的端口到宿主机

④环境变量
- `-e, --env <变量名=值>`: 设置环境变量
- `--env_file <文件路径>`: 从文件中读取环境变量

⑤卷挂载与数据管理
- `-v, --volume <宿主机路径>:<容器路径>`: 将宿主机目录或文件挂载到容器中
- `--mount`: 更灵活的挂载选项, 支持多种类型的挂载 (如绑定挂载、卷、tmpfs)

⑥网络配置
- `--network <网络名>`: 指定容器加入的网络
- `--dns <ip地址>`: 为容器指定DNS服务器
- `-h, --hostname <主机名>`: 设置容器的主机名

⑦资源限制
- `--memory, -m <内存>`: 限制容器使用的内存
- `--cpus <数量>`: 限制容器使用的CPU核数
- `--memory-swap`: 设置内存加交换空间的总和
- `--cpuset-cpus`: 指定容器可使用的具体CPU核

⑧重启策略
- `--restart <策略>`: 定义容器的重启策略, 如 `no`、`on-failure`、`always`、`unless-stopped`

⑨用户与权限
- `-u, --user <用户>`: 指定运行容器内进程的用户
- `--privileged`: 给予容器特权权限, 允许访问宿主机的所以设备

⑩日志与输出
- `--log-driver <驱动>`: 指定日志驱动
- `--log-opt <键=值>`: 配置日志驱动的选项

⑩①安全选项
- `--security-opt <选项>`: 配置安全选项，如 AppArmor、SELinux
- `--cap-add`, `--cap-drop`: 添加或移除 Linux 能力

- `--rm`: 创建并运行一个容器，在容器退出后，自动删除该容器及其所有文件和状态数据, 通常用于运行临时容器，比如测试或运行一次性命令



