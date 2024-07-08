#!/bin/bash

# 加载 .env 文件中的变量
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo ".env 文件不存在，请创建 .env 文件并添加必要的变量。"
  exit 1
fi

# 检查本地目录是否存在，不存在则创建
if [ ! -d "$LOCAL_PATH" ]; then
  mkdir -p "$LOCAL_PATH"
fi

# 检查是否能够登录到远程服务器
ssh -q -o BatchMode=yes -o ConnectTimeout=5 "$REMOTE_USER@$REMOTE_HOST" "exit"
if [ $? -ne 0 ]; then
  echo "无法连接到远程服务器 $REMOTE_HOST，请检查网络连接或服务器状态。"
  exit 1
fi

# 使用 scp 从远程服务器获取文件
# scp "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH" "$LOCAL_PATH"

# 使用 scp 从远程服务器获取整个目录
scp -r "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"/* "$LOCAL_PATH"

# 检查 scp 命令是否成功
if [ $? -eq 0 ]; then
  echo "文件已成功下载到 $LOCAL_PATH"
else
  echo "文件下载失败"
fi
