## <font color=red>Dockerfile</font>
```dockerfile
# 基于一个基础镜像
FROM ubuntu:22.04  

# 使用 LABEL 添加镜像的元信息，例如作者、版本和描述
LABEL maintainer="xuehui <xuehuizzz103@gmail.com>"
LABEL version="1.0"
LABEL description="A brief description of the image"

# 环境变量
ENV TZ=Asia/Shanghai

# 指定工作路径, 如果该路径不存在, WORKDIR会自动递归创建
WORKDIR /home/app

# 复制文件/目录, 主机路径 容器路径
# . 表示复制到容器当前工作路径, 如果未使用WORKDIR指定工作路径的话, 则会复制到容器的根目录下
COPY test.txt .

# 在构建镜像时执行命令, 默认用户是root, 因此不用加 sudo
# 在命令末尾清理apt缓存, 避免缓存文件占用额外空间
RUN apt-get update && apt-get install -y build-essential \
    && make install \
    && apt-get purge -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


# 在容器启动时执行的命令, 推荐使用Exec形式执行命令, 而不是Shell形式
ENTRYPOINT ["executable", "arg1", "arg2"]
CMD ["executable", "arg1", "arg2"]

# 健康检查
# 每30s进行一次健康检查, 如果命令在10s中未完成,则认为超时,连续3次检查失败后, 容器被标记为不健康
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    cmd curl -f http://localhost/ || exit 1
```

## <font color=red>注意事项</font>
1. 基础镜像
   - 使用尽量小且合适的基础镜像，例如 `alpine` 或特定版本的镜像（如 `python:3.9-slim`）。
   - 指定镜像的标签版本，避免使用 latest，以确保可重复性
2. 维护者信息
   - 使用 `LABEL` 添加镜像的元信息，例如作者、版本和描述
3. 最小化镜像层
   - 将相关指令（如 `RUN`）合并到单个层中，减少镜像层数
4. 指定工作目录
   - 使用 `WORKDIR` 指定工作目录，避免使用绝对路径
5. 减少缓存无效化
   - 把频繁变化的指令放在 `Dockerfile` 的后面，例如 `COPY` 或 `ADD`
6. 使用多阶段构建
   - 构建复杂镜像时，使用多阶段构建减少最终镜像的体积
7. 非 Root 用户
   - 避免以 `root` 用户运行容器，创建一个普通用户
8. 健康检查
   - 添加 `HEALTHCHECK` 来监控容器状态
9. 清理临时文件
   - 删除构建过程中的临时文件，保持镜像干净(`RUN rm -rf /tmp/* /var/tmp/*`)
10. 最小化运行时工具
    - 避免在生产镜像中保留开发工具，例如编译器、调试工具(`RUN apt-get install -y build-essential && make install && apt-get purge -y build-essential
`)

## COPY和APP
- **COPY(优先使用)**: 
    - 功能: 只负责将文件或目录从构建上下文复制到镜像中
    - 语法: `COPY <源路径> <目标路径>`
- **ADD**:
    - 功能: 除了复制文件，还可以自动解压归档文件，甚至可以从 URL 下载文件
    - 语法: `ADD <源路径或URL> <目标路径>`

## CMD和ENTRYPOINT
- **CMD指令**:
  - 用途: 为容器指定默认的命令或参数. 如果用户在启动容器时提供了命令, 该命令会覆盖 `CMD `指令
  - 格式:
    - Shell 格式: `CMD <command>`
    - Exec 格式: `CMD ["executable", "param1", "param2"]`
    - 参数形式: `CMD ["param1", "param2"]` (通常与ENTRYPOINT``配合使用)
  - **特点**:
    1). **可被覆盖**: 用户在运行容器时可以通过命令行参数覆盖 `CMD` 指令
    2). 只允许一个 `CMD`: 如果 `Dockerfile` 中有多个 `CMD`, 只有最后一个会生效
    ```dockerfile
    # Shell 格式
    CMD echo "Hello, World!"
    # Exec 格式
    CMD ["echo", "Hello, World!"]
    ```
    ```bash
    docker run myimage          # 输出 "Hello, World!"
    docker run myimage ls -l    # 覆盖 CMD，执行 "ls -l"
    ```
- **ENTRYPOINT指令**:
  - 用途: 定义容器启动时的主命令, 通常用于固定的任务. 即使用户提供了参数, `ENTRYPOINT` 指令不会被覆盖, 而是将用户提供的参数作为 `ENTRYPOINT` 的附加参数
  - 格式:
    - Shell 格式: `ENTRYPOINT <command>`
    - Exec 格式: `ENTRYPOINT ["executable", "param1", "param2"]`
  - **特点**:
    1). **不可完全覆盖**: 除非使用 `--entrypoint` 参数显式覆盖
    2). **优先级更高**: `ENTRYPOINT` 的定义优先于 `CMD`
    3). **灵活性**: 结合 `CMD`, 可以为 `ENTRYPOINT` 提供默认参数
    ```dockerfile
    # Exec 格式
    ENTRYPOINT ["ping"]
    # 默认参数由 CMD 提供
    CMD ["localhost"]
    ```
    ```bash
    docker run myimage           # 执行 "ping localhost"
    docker run myimage google.com # 执行 "ping google.com"
    ```
- **CMD 和 ENTRYPOINT 结合使用**
  - **最佳实践**: 将 `ENTRYPOINT` 用于定义主要命令，将 `CMD` 用于提供默认参数
    ```dockerfile
    ENTRYPOINT ["python", "app.py"]
    CMD ["--help"]
    ```
    ```bash
    docker run myimage            # 执行 "python app.py --help"
    docker run myimage --version  # 执行 "python app.py --version"
    ```
