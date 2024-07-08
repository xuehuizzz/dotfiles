#!/bin/bash
# 使用shell脚本将单个文件/整个路径下的所有文件发送到远程服务器

# 加载 .env 文件中的变量
if [ -f .env ]; then
  export $(cat .env | xargs)
else
  echo ".env 文件不存在，请创建 .env 文件并添加必要的变量。"
  exit 1
fi

# 检查本地文件是否存在
if [ ! -f "$LOCAL_FILE" ] && [ ! -d "$LOCAL_PATH" ]; then
  echo "本地文件或目录不存在，请检查 $LOCAL_FILE 或 $LOCAL_PATH 是否正确。"
  exit 1
fi

# 检查是否能够登录到远程服务器
ssh -q -o BatchMode=yes -o ConnectTimeout=5 "$REMOTE_USER@$REMOTE_HOST" "exit"
if [ $? -ne 0 ]; then
  echo "无法连接到远程服务器 $REMOTE_HOST，请检查网络连接或服务器状态。"
  exit 1
fi

# 使用 scp 将单个文件发送到远程服务器
if [ -f "$LOCAL_FILE" ]; then
  scp "$LOCAL_FILE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
  if [ $? -eq 0 ]; then
    echo "文件 $LOCAL_FILE 已成功发送到远程服务器 $REMOTE_HOST:$REMOTE_PATH"
  else
    echo "发送文件 $LOCAL_FILE 到远程服务器失败"
    exit 1
  fi
fi

# 使用 scp 将整个目录发送到远程服务器
if [ -d "$LOCAL_PATH" ]; then
  scp -r "$LOCAL_PATH"/* "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH"
  if [ $? -eq 0 ]; then
    echo "目录 $LOCAL_PATH 中的文件已成功发送到远程服务器 $REMOTE_HOST:$REMOTE_PATH"
  else
    echo "发送目录 $LOCAL_PATH 中的文件到远程服务器失败"
    exit 1
  fi
fi
