Podman 和 Docker 都是容器管理工具，用于创建、运行和管理容器。但它们在架构、功能和设计理念上有一些显著的区别。
### 常用命令
```bash
# cli命令和docker大致相同, 可以直接使用docker的镜像
podman -v  # 查看版本
podman system connection list  # 列出管理连接, 为空的话需要初始化并启动podman虚拟机(只有初始化并启动虚拟机后才能进行对镜像容器文件的拉取和创建)
podman machine init   # 初始化虚拟机
podman machine start  # 启动虚拟机
podman machine list   # 验证虚拟机状态, 确保虚拟机显示为 "Running"

```

以下是两者的主要区别：
1. **架构设计**
   - Docker'
     - Docker 使用了客户端-服务端（Client-Server）架构。
     - Docker Daemon 是核心组件，负责管理容器的创建、运行等操作。客户端通过 Docker CLI 与 Daemon 交互。
     - 需要一个常驻后台运行的 Docker Daemon。
   - Podman
     - Podman 是一个无守护进程的容器管理工具。
     - 它不依赖后台服务，而是通过直接调用底层工具（如 runc）管理容器。
     - 因为没有守护进程，Podman 天生更加安全，也适合无系统守护进程的环境。
2. **安全性**
   - Docker
     - Docker Daemon 通常以 root 权限运行，可能会成为安全风险。如果 Daemon 被攻破，整个系统可能会受到影响。
     - 虽然 Docker 提供了 Rootless 模式，但实现较晚且复杂度较高。
   - Podman
     - Podman 天然支持 Rootless 容器运行模式。用户可以以普通用户权限运行容器，无需担心提升系统权限带来的安全隐患。
     - 每个容器直接由用户的权限管理，因此安全性更高。
3. **Pod 支持**
   - Docker
     - Docker 主要以单个容器为核心管理单元，通常一个服务对应一个容器。
     - 如果需要管理多个容器，可以通过 Docker Compose 实现。
   - Podman
     - Podman 的名字来源于 "Pod"（类似于 Kubernetes 中的 Pod 概念），它可以轻松创建和管理多个容器组成的 Pod。
     - Podman 的 Pod 概念与 Kubernetes 的 Pod 概念一致，便于 Kubernetes 迁移。
4. **兼容性**
   - Docker
     - Docker 使用自己的 CLI 和 API，与 Docker Compose 等工具紧密集成。
     - Docker Hub 是 Docker 官方的镜像存储仓库。
   - Podman
     - Podman 的 CLI 与 Docker CLI 兼容，可以使用类似的命令操作容器（如 podman run 类似于 docker run）。
     - Podman 可以直接使用 Docker 的镜像（例如 Docker Hub），也支持 OCI 镜像。
5. **运行方式**
   - Docker
     - Docker 容器通常依赖 Docker Daemon 运行。
     - 容器运行后，容器的生命周期依赖于 Docker Daemon。
   - Podman
     - 容器运行后是独立的，即使 Podman 的 CLI 停止工作，容器也可以继续运行。
     - 更加符合传统系统服务（如 systemd）的工作方式。
6. **集成性**
   - Docker
     - Docker 提供了一整套容器生态，包括 Docker Compose、Docker Swarm 等工具。
     - 对于小型项目，Docker Swarm 提供了简单的容器编排功能。
   - Podman
     - Podman 专注于容器运行本身，不提供原生编排工具。
     - 可以与 systemd 集成，实现容器的自动化管理。
     - 通常与 Kubernetes 配合使用以实现容器编排。
7. **性能**
   - Docker
     - Docker Daemon 的引入使得性能有额外开销。
     - Docker 的性能在多数场景下表现优秀，但需要考虑 Daemon 的资源消耗。
   - Podman
     - 因为没有 Daemon，Podman 的性能更加轻量。
     - 在 Rootless 模式下，可能会因为用户命名空间的隔离带来少量性能损失。
