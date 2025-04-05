#!/bin/bash

# 设置变量
DB_USER="admin"    # MySQL 数据库用户名
DB_PASS="admin"    # MySQL 数据库用户密码
MYSQL_CHARSET_OPTS="--default-character-set=utf8mb4"

# 函数：显示使用说明
show_usage() {
    echo "用法: $0 [备份文件]"
    echo "示例: $0 mydb_20250405_132729.tar.gz"
    echo "备份文件必须是 .tar.gz 格式"
    exit 1
}

# 函数：恢复数据
restore_backup() {
    local BACKUP_FILE=$1
    
    # 检查文件是否存在
    if [ ! -f "$BACKUP_FILE" ]; then
        echo "错误: 备份文件 $BACKUP_FILE 不存在"
        exit 1
    fi
    
    # 从文件名提取数据库名称和时间戳
    local DB_NAME=$(echo "$BACKUP_FILE" | sed -E 's/(.+)_[0-9]{8}_[0-9]{6}\.tar\.gz/\1/')
    local TEMP_DIR="/tmp/restore_${DB_NAME}_$(date +%s)"
    
    echo "开始恢复数据库: $DB_NAME"
    
    # 创建临时目录
    mkdir -p "$TEMP_DIR"
    
    # 解压备份文件
    tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"
    
    # 检查是否存在结构文件
    if [ -f "$TEMP_DIR/structure.sql" ]; then
        echo "正在恢复数据库结构..."
        mysql $MYSQL_CHARSET_OPTS -u$DB_USER -p$DB_PASS "$DB_NAME" < "$TEMP_DIR/structure.sql"
    fi
    
    # 检查是否存在数据文件
    if [ -f "$TEMP_DIR/data.sql" ]; then
        echo "正在恢复数据..."
        mysql $MYSQL_CHARSET_OPTS -u$DB_USER -p$DB_PASS "$DB_NAME" < "$TEMP_DIR/data.sql"
    fi
    
    # 检查是否存在触发器文件
    if [ -f "$TEMP_DIR/triggers.sql" ]; then
        echo "正在恢复触发器..."
        mysql $MYSQL_CHARSET_OPTS -u$DB_USER -p$DB_PASS "$DB_NAME" < "$TEMP_DIR/triggers.sql"
    fi
    
    # 检查是否存在视图文件
    if [ -f "$TEMP_DIR/views.sql" ]; then
        echo "正在恢复视图..."
        mysql $MYSQL_CHARSET_OPTS -u$DB_USER -p$DB_PASS "$DB_NAME" < "$TEMP_DIR/views.sql"
    fi
    
    # 清理临时文件
    rm -rf "$TEMP_DIR"
    
    echo "数据库 $DB_NAME 恢复完成"
}

# 主程序
if [ $# -ne 1 ]; then
    show_usage
fi

restore_backup "$1"
