#!/bin/bash
# sh arestore.sh -d <fireDir> --all  恢复所有
# sh arestore.sh -d <fireDir> -c <collectionName>  恢复单个集合
# 默认参数
DB_NAME="cmdb"
DB_USER="root"
DB_PASS="admin"
SERVER_ENDPOINT="tcp://127.0.0.1:8529"

# 参数
ALL_MODE=false
COLLECTION_NAME=""
TIMESTAMP_DIR=""

# 解析参数
while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--collection)
      COLLECTION_NAME="$2"
      shift 2
      ;;
    --all)
      ALL_MODE=true
      shift
      ;;
    -d|--dir)
      TIMESTAMP_DIR="$2"
      shift 2
      ;;
    *)
      echo "Usage: $0 [--all | -c <collection_name>] -d <timestamp_dir>"
      exit 1
      ;;
  esac
done

# 检查时间戳参数
if [ -z "$TIMESTAMP_DIR" ]; then
  echo "Error: timestamp directory is required."
  echo "Usage: $0 [--all | -c <collection_name>] -d <timestamp_dir>"
  exit 1
fi

DUMP_DIR="$TIMESTAMP_DIR"

# 检查路径是否存在
if [ ! -d "$DUMP_DIR" ]; then
  echo "Error: dump directory '$DUMP_DIR' does not exist."
  exit 1
fi

# 执行恢复
if [ "$ALL_MODE" = true ]; then
  echo "🌀 Restoring entire database '$DB_NAME' from $DUMP_DIR..."
  arangorestore \
    --server.endpoint "$SERVER_ENDPOINT" \
    --server.database "$DB_NAME" \
    --server.username "$DB_USER" \
    --server.password "$DB_PASS" \
    --input-directory "$DUMP_DIR" \
    --create-database true \
    --include-system-collections false \
    --overwrite true \
    --batch-size 5000 \
    --threads 4

elif [ -n "$COLLECTION_NAME" ]; then
  echo "🔹 Restoring collection '$COLLECTION_NAME' in database '$DB_NAME' from $DUMP_DIR..."
  arangorestore \
    --server.endpoint "$SERVER_ENDPOINT" \
    --server.database "$DB_NAME" \
    --server.username "$DB_USER" \
    --server.password "$DB_PASS" \
    --input-directory "$DUMP_DIR" \
    --collection "$COLLECTION_NAME" \
    --create-collection true \
    --include-system-collections false \
    --overwrite true \
    --batch-size 5000 \
    --threads 4
else
  echo "Error: Please specify either --all or -c <collection_name>"
  echo "Usage: $0 [--all | -c <collection_name>] -d <timestamp_dir>"
  exit 1
fi
