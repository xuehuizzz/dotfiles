#!/bin/bash
# 会备份除系统库外所有库的非系统集合
ARANGO_HOST="127.0.0.1"
ARANGO_PORT="8529"
ARANGO_USER="root"
ARANGO_PASS="admin"
BACKUP_ROOT="./backups"

db_list=$(arangosh \
  --server.endpoint "tcp://${ARANGO_HOST}:${ARANGO_PORT}" \
  --server.username "${ARANGO_USER}" \
  --server.password "${ARANGO_PASS}" \
  --javascript.execute-string "db._databases().forEach(function(n){ if(n !== '_system') print(n); })" \
  --quiet)

for db_name in $db_list; do
  echo "开始备份数据库: $db_name"
  timestamp=$(date +%Y%m%d-%H%M%S)
  target_dir="${BACKUP_ROOT}/${db_name}/${timestamp}"
  mkdir -p "$target_dir"

  # 获取非系统集合（集合名不以 _ 开头）
  collections=$(arangosh \
    --server.endpoint "tcp://${ARANGO_HOST}:${ARANGO_PORT}" \
    --server.username "${ARANGO_USER}" \
    --server.password "${ARANGO_PASS}" \
    --server.database "$db_name" \
    --javascript.execute-string "db._collections().forEach(function(c){ if(!c.name().startsWith('_')) print(c.name()); })" \
    --quiet)

  # 如果有非系统集合，批量备份
  if [ -n "$collections" ]; then
    arangodump \
      --server.endpoint "tcp://${ARANGO_HOST}:${ARANGO_PORT}" \
      --server.username "${ARANGO_USER}" \
      --server.password "${ARANGO_PASS}" \
      --server.database "$db_name" \
      --output-directory "$target_dir" \
      --compress-output true \
      --overwrite true \
      $(for coll in $collections; do echo "--collection $coll"; done)
  fi

  echo "✅ 数据库 $db_name 用户集合备份完成: $target_dir"
done
