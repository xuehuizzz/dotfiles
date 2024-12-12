`在 Docker 中，每个 RUN 命令都会创建一个新的镜像层，而 Docker 的存储是分层的，每个层都保留了前一个命令执行的结果。
如果你在 Dockerfile 中使用多个 RUN 指令，即使最终删除了某些文件或清理了缓存，这些删除操作的历史层仍然存在，因此会占用空间。`

### 为保持构建镜像精简可以合并RUN命令和多阶段构建

- 合并 RUN 命令（使用 && 连接）： 
   -
  ```Dcokerfile
  # 最简单和直接的方法就是将多个 RUN 命令合并成一个命令，使用 && 将它们连接起来。这样，所有操作都在同一个层中执行，删除的文件和中间产物不会被保留为独立的层，从而减小镜像大小。
  RUN apt-get update && apt-get install -y build-essential && \
  make /app && \
  rm -rf /tmp/* && \
  apt-get clean &&
  hash -r   # 清除内存中存储的可执行文件路径缓存
  ```

- 多阶段构建(multi-stage)
  -
  ```Dockerfile
  # 第一阶段：构建阶段
  FROM ubuntu:22.04 AS build
  RUN apt-get update && apt-get install -y build-essential git
  WORKDIR /app
  RUN git clone https://github.com/example/repo.git .
  RUN make
  
  # 第二阶段：最终镜像
  FROM ubuntu:22.04
  COPY --from=build /app/bin/myapp /usr/local/bin/myapp
  RUN apt-get update && apt-get install -y libssl1.1
  CMD ["myapp"]
  ```

## 解释：为什么多阶段构建是有效的
- 避免冗余层：每个 RUN 命令都会创建一个新的镜像层。如果每个 RUN 命令都产生中间文件（比如安装了构建工具但在后续步骤中删除了它们），这些中间层仍然存在并占用空间。多阶段构建通过分离不同的构建任务，确保最终镜像只包含需要的文件，删除中间步骤中的所有不必要内容。

- 减少最终镜像大小：在多阶段构建中，只将需要的文件（如编译好的二进制文件）从构建阶段复制到最终镜像。这意味着不再需要担心临时文件和构建工具被包含在最终镜像中，减少了最终镜像的体积。

- 优化 Docker 构建历史：通过将构建过程拆分成多个阶段，并只将最终需要的内容复制到最终镜像中，历史层中的中间产物被丢弃，不会在最终镜像中占用空间。
