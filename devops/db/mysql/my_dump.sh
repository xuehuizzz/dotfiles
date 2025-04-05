#!/bin/bash

# 设置变量
DB_USER="xxx"   # MySQL登录用户名
DB_PASS="xxx"   # MySQL登录用户密码
BACKUP_ROOT="xxx"   # MySQL备份路径
DATE_DIR=$(date +%Y%m%d)  # 用于目录名的日期格式
DATE=$(date +%Y%m%d_%H%M%S)  # 用于文件名的日期时间格式

# 设置字符集
export MYSQL_PWD="$DB_PASS"
MYSQL_CHARSET_OPTS="--default-character-set=utf8mb4"

# 函数：显示使用说明
show_usage() {
    echo "用法: $0 [选项]"
    echo "选项:"
    echo "  无参数     - 备份所有数据库"
    echo "  -d 数据库名 - 备份指定数据库"
    echo "  -d 数据库名 -t 表名 - 备份指定数据库的指定表"
    exit 1
}

# 函数：备份单个表
backup_table() {
    local DB_NAME=$1
    local TABLE=$2
    echo "开始备份表: $DB_NAME.$TABLE"

    # 检查表是否存在
    if ! mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "SHOW TABLES LIKE '$TABLE'" $DB_NAME | grep -q "$TABLE"; then
        echo "错误: 表 $TABLE 在数据库 $DB_NAME 中不存在"
        exit 1
    fi

    # 检查是否为视图
    local IS_VIEW=$(mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "
        SELECT COUNT(*) 
        FROM information_schema.VIEWS 
        WHERE TABLE_SCHEMA = '$DB_NAME' 
        AND TABLE_NAME = '$TABLE'")

    # 创建备份目录结构
    local BACKUP_DIR="${BACKUP_ROOT}/${DATE_DIR}/${DB_NAME}_${TABLE}_${DATE}"
    local STRUCTURE_DIR="${BACKUP_DIR}/structure"
    local DATA_DIR="${BACKUP_DIR}/data"
    local TRIGGER_DIR="${BACKUP_DIR}/triggers"

    mkdir -p "$STRUCTURE_DIR"
    mkdir -p "$DATA_DIR"
    mkdir -p "$TRIGGER_DIR"

    if [ "$IS_VIEW" -eq 1 ]; then
        echo "正在备份视图: $TABLE"
        mysqldump $MYSQL_CHARSET_OPTS -u$DB_USER \
            --no-data \
            --skip-triggers \
            --skip-add-drop-table \
            $DB_NAME "$TABLE" > "${STRUCTURE_DIR}/${TABLE}.sql"
    else
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
                        'DROP TRIGGER IF EXISTS \`', TRIGGER_NAME, '\` //\n',
                        'CREATE TRIGGER \`', TRIGGER_NAME, '\` ',
                        ACTION_TIMING, ' ', EVENT_MANIPULATION, ' ON \`', 
                        EVENT_OBJECT_TABLE, '\`\n',
                        'FOR EACH ROW\n',
                        REPLACE(ACTION_STATEMENT, '\n', '\n'),
                        '\n //\n\n'
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
    fi

    # 压缩备份
    cd "${BACKUP_ROOT}/${DATE_DIR}"
    tar -czf "${DB_NAME}_${TABLE}_${DATE}.tar.gz" "${DB_NAME}_${TABLE}_${DATE}"
    rm -rf "${BACKUP_DIR}"

    echo "表/视图 $DB_NAME.$TABLE 备份完成"
}

# 函数：备份单个数据库
backup_database() {
    local DB_NAME=$1
    echo "开始备份数据库: $DB_NAME"

    # 检查数据库是否存在
    if ! mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "SHOW DATABASES LIKE '$DB_NAME'" | grep -q "$DB_NAME"; then
        echo "错误: 数据库 $DB_NAME 不存在"
        exit 1
    fi

    # 创建备份目录结构
    local BACKUP_DIR="${BACKUP_ROOT}/${DATE_DIR}/${DB_NAME}_${DATE}"
    local STRUCTURE_DIR="${BACKUP_DIR}/structure"
    local DATA_DIR="${BACKUP_DIR}/data"
    local TRIGGER_DIR="${BACKUP_DIR}/triggers"
    local VIEW_DIR="${BACKUP_DIR}/views"

    mkdir -p "$STRUCTURE_DIR"
    mkdir -p "$DATA_DIR"
    mkdir -p "$TRIGGER_DIR"
    mkdir -p "$VIEW_DIR"

    # 备份数据库整体结构（不包含表和触发器）
    mysqldump $MYSQL_CHARSET_OPTS -u$DB_USER \
        --no-data \
        --no-create-info \
        --routines \
        --events \
        --skip-triggers \
        $DB_NAME > "${BACKUP_DIR}/database_objects.sql"

    # 备份所有视图
    echo "正在备份视图..."
    mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "
        SELECT TABLE_NAME 
        FROM information_schema.VIEWS 
        WHERE TABLE_SCHEMA = '$DB_NAME'" | while read VIEW_NAME; do
        if [ ! -z "$VIEW_NAME" ]; then
            echo "正在备份视图: $VIEW_NAME"
            mysqldump $MYSQL_CHARSET_OPTS -u$DB_USER \
                --no-data \
                --skip-triggers \
                --skip-add-drop-table \
                $DB_NAME "$VIEW_NAME" > "${VIEW_DIR}/${VIEW_NAME}.sql"
        fi
    done

    # 获取所有表名（不包括视图）
    local TABLES=$(mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "
        SELECT TABLE_NAME 
        FROM information_schema.TABLES 
        WHERE TABLE_SCHEMA = '$DB_NAME' 
        AND TABLE_TYPE = 'BASE TABLE'")

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
                        'DROP TRIGGER IF EXISTS \`', TRIGGER_NAME, '\` //\n',
                        'CREATE TRIGGER \`', TRIGGER_NAME, '\` ',
                        ACTION_TIMING, ' ', EVENT_MANIPULATION, ' ON \`', 
                        EVENT_OBJECT_TABLE, '\`\n',
                        'FOR EACH ROW\n',
                        REPLACE(ACTION_STATEMENT, '\n', '\n'),
                        '\n //\n\n'
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
    cd "${BACKUP_ROOT}/${DATE_DIR}"
    tar -czf "${DB_NAME}_${DATE}.tar.gz" "${DB_NAME}_${DATE}"
    rm -rf "${BACKUP_DIR}"

    echo "数据库 $DB_NAME 备份完成"
}

# 主程序
DB_NAME=""
TABLE_NAME=""

# 创建日期目录
mkdir -p "${BACKUP_ROOT}/${DATE_DIR}"

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -d)
            if [[ -n "$2" ]]; then
                DB_NAME="$2"
                shift 2
            else
                echo "错误: -d 参数需要指定数据库名"
                show_usage
            fi
            ;;
        -t)
            if [[ -n "$2" ]]; then
                TABLE_NAME="$2"
                shift 2
            else
                echo "错误: -t 参数需要指定表名"
                show_usage
            fi
            ;;
        *)
            show_usage
            ;;
    esac
done

# 根据参数执行相应的备份操作
if [[ -z "$DB_NAME" && -z "$TABLE_NAME" ]]; then
    # 无参数：备份所有数据库
    echo "未指定数据库，将备份所有数据库"
    DATABASES=$(mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "SHOW DATABASES" | grep -Ev "^(information_schema|performance_schema|mysql|sys)$")
    for DB in $DATABASES
    do
        backup_database $DB
    done
elif [[ -n "$DB_NAME" && -z "$TABLE_NAME" ]]; then
    # 只有数据库参数：备份指定数据库
    backup_database "$DB_NAME"
elif [[ -n "$DB_NAME" && -n "$TABLE_NAME" ]]; then
    # 同时指定数据库和表：备份指定表
    backup_table "$DB_NAME" "$TABLE_NAME"
else
    # 参数错误
    echo "错误: 必须先指定数据库(-d)才能指定表(-t)"
    show_usage
fi
