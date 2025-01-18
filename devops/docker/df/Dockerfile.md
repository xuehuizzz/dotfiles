## Dockerfile编写
```dockerfile
# 基于一个基础镜像
FROM ubuntu:22.04  

# Dockerfile维护者
LABEL maintainer="xuehui <xuehuizzz103@gmail.com>"   

# 环境变量
ENV TZ=Asia/Shanghai

# 指定工作路径, 如果该路径不存在, WORKDIR会自动递归创建
WORKDIR /home/app

# 复制文件/目录, 主机路径 容器路径
# . 表示复制到容器当前工作路径, 如果未使用WORKDIR指定工作路径的话, 则会复制到容器的根目录下
COPY test.txt .

# 在构建镜像时执行命令, 默认用户是root, 因此不用加 sudo
RUN apt update && apt install -y xxx

# 在容器启动时执行的命令, 推荐使用Exec形式执行命令, 而不是Shell形式
CMD ["executable", "arg1", "arg2"]
# ENTRYPOINT ["executable", "arg1", "arg2"]

# 健康检查
# 每30s进行一次健康检查, 如果命令在10s中未完成,则认为超时,连续3次检查失败后, 容器被标记为不健康
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost/ || exit 1
```
