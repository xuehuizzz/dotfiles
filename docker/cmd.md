1.<mark>使用save和load导出并导入镜像</mark>

```markdown
# 导出镜像
docker save -o [导出文件名].tar [镜像名称]:[标签]
    docker save -o my_image.tar my_image:latest
# 导入镜像    
docker load -i [导入文件名].tar
    docker load -i my_image.tar
```

2.<mark>使用export和import导出并导入容器文件系统为镜像</mark>

```markdown
# 导出容器文件
docker export -o [导出文件名].tar [容器ID或名称]
    docker export -o my_container.tar my_container
# 导入容器文件为镜像
docker import [导入文件名].tar [新镜像名称]:[标签]
    docker import my_container.tar my_new_image:latest
```

3.<mark>创建并启动容器</mark>

```bash
docker run \
  -it \  #
  --name my_container \  # 指定容器名称
  --restart unless-stopped \  # 只有容器被手动停止,容器才不会尝试重启
  --network bridge \  # docker的默认网络模式, 不需要显式指定
  -p 8080:80 \  # 映射主机的端口8080到容器的端口80
  -v /host/data:/container/data\  # 挂载主机的目录到容器的目录
  my_image:latest  # 使用的镜像
```
4.<mark>docker run参数</mark>

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



