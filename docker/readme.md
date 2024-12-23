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
docker build \    # 构建镜像文件
  --build-arg http_proxy=http://你的代理地址:端口 \
  --build-arg https_proxy=http://你的代理地址:端口 \
  --build-arg no_proxy=localhost,127.0.0.1 \
  -t your-image-name:tag .     # 应与Dockerfile同一目录, 或使用 -f 指定dockerfile文件

docker run \
  -it \  #
  --name my_container \  # 指定容器名称
  --restart unless-stopped \  # 只有容器被手动停止,容器才不会尝试重启
  --network bridge \  # docker的默认网络模式, 不需要显式指定, 这里的bridge指的是 `docker network ls`中的NAME, 而不是DRIVER
  -p 8080:80 \  # 映射主机的端口8080到容器的端口80
  -v /host/data:/container/data\  # 挂载主机的目录到容器的目录
  --health-cmd="curl --fail http://localhost:8080 || exit 1" \
  --health-interval=30s \   # 两次健康检查之间的时间间隔（默认30秒）
  --health-timeout=5s \   # 健康检查命令的超时时间。如果超过这个时间，健康检查视为失败（默认30秒）
  --health-retries=3 \   # 如果连续多少次健康检查失败，认为容器处于不健康状态（默认3次）
  --health-start-period=30s \   # 容器启动后多长时间开始执行健康检查（默认0秒）。这可以为应用程序预留启动时间
  --device-read-bps /dev/sda:10mb --device-write-bps /dev/sda:10mb \   # 限制容器对特定设备的读写速率(每秒字节数): 10mb, 防止某个容器过度占用IO资源，影响到宿主机或其他容器的正常运行
  --device-read-iops /dev/sda:1000 --device-write-iops /dev/sda:1000 \   # 限制每秒的IO操作数为1000
  my_image:latest  # 使用的镜像

docker info  # 列出docker环境详细信息
docker stats 容器ID/名称   # 查看容器状态
docker plugin ls  # 列出已安装的插件
docker rename my_comtainer my_new_container  # 重命名容器
docker ps -a  # 查看所以容器(完整写法: docker container ls -a)
docker ps -q  # 列出所以运行中容器的ID,  -aq: 列出所有容器id
docker stop/start 容器ID/名称    # 停止/启动容器
docker restart 容器ID/名称    # 重启容器
docker restart $(docker ps -aq)   # 重启所有容器
docker logs -f --tail num 容器ID/名称   # 查看docker日志最新xxx条
docker inspect 容器ID/名称   # 查看容器的详细信息
docker exec -it 容器ID/名称 bash   # 交互式进入容器内部
docker iamges   # 查看所有镜像(docker image ls)
docker rm 容器ID/名称  # 删除已停止的容器, -f:强制删除运行中的容器, 谨慎使用
docker rmi 镜像ID/名称  # 删除指定镜像, -f:强制删除镜像, 谨慎使用
docker network ls   # 列出当前docker环境中所有网络, 一个docker容器可以连接多个网络
docker network inspect 网络ID/名称   # 查看某个网络的详细信息
docker network create --driver bridge my-custom-network   # 创建一个新的自定义网络, 指定类型为 bridge, docker network create -d xxx xxx
docker network connect 网络ID/名称 容器ID/名称    # 将一个容器连接到一个指定的网络(一个容器可以连接多个网络, bridge、overlay、macvlan)
docker network disconnect 网络ID/名称 容器ID/名称   # 断开连接网络
docker network rm 网络ID/名称   # 删除网络

docker compose config # 检查docker-compose.yml文件是否有语法错误,  -f <file_path> 指定检查文件, --format=json 以json格式输出
docker compose up -d  # 后台创建并运行容器(在docker-compose.yml同一目录下), 可指定文件, docker compose -f file_path up -d
docker compose down   # 停止并删除容器(在docker-compose.yml同一目录下), 同上 docker compose -f file_path down,  --volumes  保留数据卷
docker compose ls  # 列出所有运行中的 Compose 项目, --all 列出所有  --format json
docker compose ps   # 列出当前compose项目的容器
docker compose restart  # 重启当前compose项目所有服务,  <service_name> 重启特定服务
docker compose stop  # 停止所有服务
docker compose start # 启动已停止的服务
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

二.<mark>使用export和import导出并导入容器文件系统为镜像</mark>

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

- 支持动态多网络连接: bridge、overlay、macvlan、ipvlan
- 不支持动态多网络连接: host、none

①. `桥接网络 bridge`
- 当你创建容器但未指定网络时, 默认使用桥接网络
- 容器之间可以通过容器名互相通信
- 支持端口映射, 使外部访问容器服务成为可能
- ```bash
  # 查看当前网络
  docker network ls
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

④. `容器网络 container`
- 允许一个容器与另一个容器共享网络命名空间, 不需要单独分配IP地址, 使用同一网卡、主机名、IP 地址
- ```bash
  # 运行第一个容器
  docker run -d --name container1 my-image
  # 运行第二个容器，并与第一个容器共享网络
  docker run -d --name container2 --network container:container1 my-image
  ```

⑤. `无网络 none`
- 容器没有网络接口, 完全隔离, 适用于不需要网络通信的特殊场景
- ```bash
  docker run -d --name my-container --network none my-image
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



