#!/bin/bash

# 数据库连接参数
DB_HOST="localhost"
DB_USER="xxx"
DB_PASS="xxx"
DB_PORT="3306"

# 解析命令行参数
RESTORE_STRUCTURE=1
RESTORE_DATA=1

while getopts "h:u:p:P:sd" opt; do
    case $opt in
        h) DB_HOST="$OPTARG" ;;
        u) DB_USER="$OPTARG" ;;
        p) DB_PASS="$OPTARG" ;;
        P) DB_PORT="$OPTARG" ;;
        s) RESTORE_STRUCTURE=1; RESTORE_DATA=0 ;;
        d) RESTORE_DATA=1; RESTORE_STRUCTURE=0 ;;
    esac
done

shift $((OPTIND-1))

# 检查备份文件参数
if [ $# -ne 1 ]; then
    echo "使用方法: $0 [-h host] [-u user] [-p password] [-P port] [-s] [-d] <备份文件路径>"
    echo "选项:"
    echo "  -s  只恢复表结构"
    echo "  -d  只恢复数据"
    exit 1
fi

BACKUP_FILE=$1

# 构建 MySQL 连接参数
MYSQL_CONN="-h$DB_HOST -P$DB_PORT -u$DB_USER"
if [ ! -z "$DB_PASS" ]; then
    MYSQL_CONN="$MYSQL_CONN -p$DB_PASS"
fi

# 检查文件是否存在
if [ ! -f "$BACKUP_FILE" ]; then
    echo "错误: 备份文件 '$BACKUP_FILE' 不存在"
    exit 1
fi

# 解析文件名
FILENAME=$(basename "$BACKUP_FILE")
TEMP_DIR="/tmp/mysql_restore_$(date +%s)"
FOLDER=${FILENAME%%.tar.gz}

# 创建临时目录
mkdir -p "$TEMP_DIR"

# 解压文件
tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"

PREFIX=${FILENAME%%_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]*} 

# 判断是数据库备份还是表备份
if [[ $PREFIX != *.* ]]; then
    # 数据库备份
    DB_NAME="$PREFIX"
    if [ -d "$TEMP_DIR/$FOLDER" ]; then
        RESTORE_DIR="$TEMP_DIR/$FOLDER"
    else
        RESTORE_DIR="$TEMP_DIR"
    fi

    echo "正在恢复数据库: $DB_NAME"

    mysql $MYSQL_CONN -e "CREATE DATABASE IF NOT EXISTS $DB_NAME"

    # 恢复结构
    if [ $RESTORE_STRUCTURE -eq 1 ] && [ -d "$RESTORE_DIR/structure" ]; then
        if ls "$RESTORE_DIR/structure"/*.sql >/dev/null 2>&1; then
            for f in "$RESTORE_DIR/structure"/*.sql; do
                mysql $MYSQL_CONN "$DB_NAME" < "$f"
            done
        else
            echo "结构目录为空，跳过"
        fi
    fi

    # 恢复数据
    if [ $RESTORE_DATA -eq 1 ] && [ -d "$RESTORE_DIR/data" ]; then
        if ls "$RESTORE_DIR/data"/*.sql >/dev/null 2>&1; then
            for f in "$RESTORE_DIR/data"/*.sql; do
                mysql $MYSQL_CONN "$DB_NAME" < "$f"
            done
        else
            echo "数据目录为空，跳过"
        fi
    fi

    # 恢复触发器和视图只在恢复结构时进行
    if [ $RESTORE_STRUCTURE -eq 1 ]; then
        # 恢复触发器
        if [ -d "$RESTORE_DIR/triggers" ]; then
            if ls "$RESTORE_DIR/triggers"/*.sql >/dev/null 2>&1; then
                for f in "$RESTORE_DIR/triggers"/*.sql; do
                    mysql $MYSQL_CONN "$DB_NAME" < "$f"
                done
            else
                echo "触发器目录为空，跳过"
            fi
        fi

        # 恢复视图
        if [ -d "$RESTORE_DIR/views" ]; then
            if ls "$RESTORE_DIR/views"/*.sql >/dev/null 2>&1; then
                for f in "$RESTORE_DIR/views"/*.sql; do
                    mysql $MYSQL_CONN "$DB_NAME" < "$f"
                done
            else
                echo "视图目录为空，跳过"
            fi
        fi
    fi

else     # 表备份
    DB_NAME=${PREFIX%.*}
    TABLE_NAME=${PREFIX#*.}
    if [ -d "$TEMP_DIR/$FOLDER" ]; then
        RESTORE_DIR="$TEMP_DIR/$FOLDER"
    else
        RESTORE_DIR="$TEMP_DIR"
    fi

    mysql $MYSQL_CONN -e "CREATE DATABASE IF NOT EXISTS $DB_NAME"

    # 恢复结构
    if [ $RESTORE_STRUCTURE -eq 1 ] && [ -f "$RESTORE_DIR/structure/$TABLE_NAME.sql" ]; then
        mysql $MYSQL_CONN "$DB_NAME" < "$RESTORE_DIR/structure/$TABLE_NAME.sql"
    else
        [ $RESTORE_STRUCTURE -eq 1 ] && echo "表结构文件不存在，跳过"
    fi

    # 恢复数据
    if [ $RESTORE_DATA -eq 1 ] && [ -f "$RESTORE_DIR/data/$TABLE_NAME.sql" ]; then
        mysql $MYSQL_CONN "$DB_NAME" < "$RESTORE_DIR/data/$TABLE_NAME.sql"
    else
        [ $RESTORE_DATA -eq 1 ] && echo "表数据文件不存在，跳过"
    fi

    # 恢复触发器（只在恢复结构时）
    if [ $RESTORE_STRUCTURE -eq 1 ] && [ -f "$RESTORE_DIR/triggers/$TABLE_NAME.sql" ]; then
        mysql $MYSQL_CONN "$DB_NAME" < "$RESTORE_DIR/triggers/$TABLE_NAME.sql"
    else
        [ $RESTORE_STRUCTURE -eq 1 ] && echo "表触发器文件不存在，跳过"
    fi
fi

# 清理临时文件
rm -rf "$TEMP_DIR"
echo "恢复完成!"
