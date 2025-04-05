#!/bin/bash

# 设置变量
DB_USER="admin"   # MySQL登录用户名
DB_PASS="admin"   # MySQL登录用户密码
BACKUP_ROOT="/app"   # MySQL备份路径
DATE=$(date +%Y%m%d_%H%M%S)

# 设置字符集
export MYSQL_PWD="$DB_PASS"
MYSQL_CHARSET_OPTS="--default-character-set=utf8mb4"

# 函数：备份单个数据库
backup_database() {
    local DB_NAME=$1
    echo "开始备份数据库: $DB_NAME"

    # 创建备份目录结构
    local BACKUP_DIR="${BACKUP_ROOT}/${DB_NAME}_${DATE}"
    local STRUCTURE_DIR="${BACKUP_DIR}/structure"
    local DATA_DIR="${BACKUP_DIR}/data"
    local TRIGGER_DIR="${BACKUP_DIR}/triggers"

    mkdir -p "$STRUCTURE_DIR"
    mkdir -p "$DATA_DIR"
    mkdir -p "$TRIGGER_DIR"

    # 获取所有表名
    local TABLES=$(mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "SHOW TABLES" $DB_NAME)

    # 备份数据库整体结构（不包含表和触发器）
    mysqldump $MYSQL_CHARSET_OPTS -u$DB_USER \
        --no-data \
        --no-create-info \
        --routines \
        --events \
        --skip-triggers \
        $DB_NAME > "${BACKUP_DIR}/database_objects.sql"

    # 逐表备份
    for TABLE in $TABLES
    do
        echo "正在备份表: $TABLE"

        # 备份表结构
        mysqldump $MYSQL_CHARSET_OPTS -u$DB_USER \
            --no-data \
            --skip-triggers \
            $DB_NAME $TABLE > "${STRUCTURE_DIR}/${TABLE}.sql"

        # 备份表数据
        mysqldump $MYSQL_CHARSET_OPTS -u$DB_USER \
            --no-create-info \
            --skip-triggers \
            $DB_NAME $TABLE > "${DATA_DIR}/${TABLE}.sql"

        # 备份表的所有触发器
        mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "
            SET group_concat_max_len = 102400;
            SELECT CONCAT(
                'DELIMITER //\n\n',
                GROUP_CONCAT(
                    CONCAT(
                        '/* Trigger: ', TRIGGER_NAME, ' */\n',
                        'DROP TRIGGER IF EXISTS \`', TRIGGER_NAME, '\`//\n',
                        'CREATE TRIGGER \`', TRIGGER_NAME, '\` ',
                        ACTION_TIMING, ' ', EVENT_MANIPULATION, ' ON \`', 
                        EVENT_OBJECT_TABLE, '\`\n',
                        'FOR EACH ROW\n',
                        REPLACE(ACTION_STATEMENT, '\n', '\n'),
                        '\n//\n\n'
                    )
                    ORDER BY TRIGGER_NAME
                    SEPARATOR '\n'
                ),
                '\nDELIMITER ;'
            )
            FROM information_schema.TRIGGERS 
            WHERE EVENT_OBJECT_SCHEMA = '$DB_NAME' 
            AND EVENT_OBJECT_TABLE = '$TABLE'
            GROUP BY EVENT_OBJECT_TABLE" | sed 's/\\n/\n/g' > "${TRIGGER_DIR}/${TABLE}.sql"
    done

    # 压缩备份
    cd "${BACKUP_ROOT}"
    tar -czf "${DB_NAME}_${DATE}.tar.gz" "${DB_NAME}_${DATE}"
    rm -rf "${BACKUP_DIR}"

    echo "数据库 $DB_NAME 备份完成"
}

# 主程序
if [ $# -eq 0 ]; then
    echo "未指定数据库，将备份所有数据库"
    DATABASES=$(mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "SHOW DATABASES" | grep -Ev "^(information_schema|performance_schema|mysql|sys)$")

    for DB in $DATABASES
    do
        backup_database $DB
    done
else
    backup_database $1
fi
