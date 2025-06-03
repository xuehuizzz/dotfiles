#!/bin/bash
set -euo pipefail

# 配置日志
RESET=$(tput sgr0)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)

# 仅标签是彩色, 内容是白色
info() {
  printf "%s[INFO]%s %s\n" "$BLUE" "$RESET" "$*"
}

success() {
  printf "%s[SUCCESS]%s %s\n" "$GREEN" "$RESET" "$*"
}

warn() {
  printf "%s[WARN]%s %s\n" "$YELLOW" "$RESET" "$*" >&2
}

error() {
  printf "%s[ERROR]%s %s\n" "$RED" "$RESET" "$*" >&2
  exit 1
}

# 设置变量
DB_USER="xxx"        # MySQL 用户
DB_PASS="xxx"        # MySQL 密码
BACKUP_ROOT="xxx"    # 备份根目录
DATE_DIR=$(date +%Y%m%d)
DATE=$(date +%Y%m%d_%H%M%S)

# 设置字符集
export MYSQL_PWD="$DB_PASS"
MYSQL_CHARSET_OPTS="--default-character-set=utf8mb4"

# 公共 mysqldump 参数
DUMP_COMMON="--single-transaction --set-gtid-purged=OFF $MYSQL_CHARSET_OPTS -u$DB_USER"

# 使用说明
show_usage() {
    echo "用法: $0 [选项]"
    echo "选项:"
    echo "  无参数     - 备份所有数据库"
    echo "  -d 数据库  - 备份指定数据库"
    echo "  -d 数据库 -t 表 - 备份指定数据库的指定表"
    exit 1
}

# 备份表
backup_table() {
    local DB_NAME=$1
    local TABLE=$2
    info "开始备份表: $DB_NAME.$TABLE"

    if ! mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "SHOW TABLES LIKE '$TABLE'" "$DB_NAME" | grep -q "$TABLE"; then
        error "表 $DB_NAME.$TABLE 不存在"
        exit 1
    fi

    local IS_VIEW=$(mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "
        SELECT COUNT(*) FROM information_schema.VIEWS
        WHERE TABLE_SCHEMA='$DB_NAME' AND TABLE_NAME='$TABLE'")

    local BACKUP_DIR="${BACKUP_ROOT}/${DATE_DIR}/${DB_NAME}.${TABLE}_${DATE}"
    mkdir -p "$BACKUP_DIR"/{structure,data,triggers}

    if [ "$IS_VIEW" -eq 1 ]; then
        info "正在备份视图: $TABLE"
        mysqldump $DUMP_COMMON \
            --no-data --skip-triggers --skip-add-drop-table \
            "$DB_NAME" "$TABLE" > "${BACKUP_DIR}/structure/${TABLE}.sql"
    else
        mysqldump $DUMP_COMMON --no-data --skip-triggers "$DB_NAME" "$TABLE" > "${BACKUP_DIR}/structure/${TABLE}.sql"
        mysqldump $DUMP_COMMON --no-create-info --skip-triggers "$DB_NAME" "$TABLE" > "${BACKUP_DIR}/data/${TABLE}.sql"

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
                    ) ORDER BY TRIGGER_NAME SEPARATOR '\n'
                ),
                '\nDELIMITER ;'
            )
            FROM information_schema.TRIGGERS
            WHERE EVENT_OBJECT_SCHEMA='$DB_NAME' AND EVENT_OBJECT_TABLE='$TABLE'
            GROUP BY EVENT_OBJECT_TABLE" | sed 's/\\n/\n/g' > "${BACKUP_DIR}/triggers/${TABLE}.sql"
    fi

    (cd "${BACKUP_ROOT}/${DATE_DIR}" && tar -czf "${DB_NAME}.${TABLE}_${DATE}.tar.gz" "$(basename "$BACKUP_DIR")")
    rm -rf "$BACKUP_DIR"
    success "表 $DB_NAME.$TABLE 备份完成"
}

# 备份数据库
backup_database() {
    local DB_NAME=$1
    info "开始备份数据库: $DB_NAME"

    if ! mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "SHOW DATABASES LIKE '$DB_NAME'" | grep -q "$DB_NAME"; then
        error "数据库 $DB_NAME 不存在"
        exit 1
    fi

    local BACKUP_DIR="${BACKUP_ROOT}/${DATE_DIR}/${DB_NAME}_${DATE}"
    mkdir -p "$BACKUP_DIR"/{structure,data,triggers,views}

    mysqldump $DUMP_COMMON \
        --no-data --no-create-info --routines --events --skip-triggers \
        "$DB_NAME" > "${BACKUP_DIR}/database_objects.sql"

    info "正在备份视图..."
    mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "
        SELECT TABLE_NAME FROM information_schema.VIEWS
        WHERE TABLE_SCHEMA='$DB_NAME'" | while read VIEW_NAME; do
        [ -n "$VIEW_NAME" ] && {
            info "  → 视图: $VIEW_NAME"
            mysqldump $DUMP_COMMON \
                --no-data --skip-triggers --skip-add-drop-table \
                "$DB_NAME" "$VIEW_NAME" > "${BACKUP_DIR}/views/${VIEW_NAME}.sql"
        }
    done

    local TABLES=$(mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "
        SELECT TABLE_NAME FROM information_schema.TABLES
        WHERE TABLE_SCHEMA='$DB_NAME' AND TABLE_TYPE='BASE TABLE'")

    for TABLE in $TABLES; do
        info "正在备份表: $TABLE"
        mysqldump $DUMP_COMMON --no-data --skip-triggers "$DB_NAME" "$TABLE" > "${BACKUP_DIR}/structure/${TABLE}.sql"
        mysqldump $DUMP_COMMON --no-create-info --skip-triggers "$DB_NAME" "$TABLE" > "${BACKUP_DIR}/data/${TABLE}.sql"

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
                    ) ORDER BY TRIGGER_NAME SEPARATOR '\n'
                ),
                '\nDELIMITER ;'
            )
            FROM information_schema.TRIGGERS
            WHERE EVENT_OBJECT_SCHEMA='$DB_NAME' AND EVENT_OBJECT_TABLE='$TABLE'
            GROUP BY EVENT_OBJECT_TABLE" | sed 's/\\n/\n/g' > "${BACKUP_DIR}/triggers/${TABLE}.sql"
    done

    (cd "${BACKUP_ROOT}/${DATE_DIR}" && tar -czf "${DB_NAME}_${DATE}.tar.gz" "$(basename "$BACKUP_DIR")")
    rm -rf "$BACKUP_DIR"
    success "数据库 $DB_NAME 备份完成"
}

# 主逻辑
DB_NAME=""
TABLE_NAME=""

mkdir -p "${BACKUP_ROOT}/${DATE_DIR}"

while [[ $# -gt 0 ]]; do
    case $1 in
        -d)
            DB_NAME=$2
            shift 2
            ;;
        -t)
            TABLE_NAME=$2
            shift 2
            ;;
        *)
            show_usage
            ;;
    esac
done

if [[ -z "$DB_NAME" && -z "$TABLE_NAME" ]]; then
    info "未指定数据库，将备份所有数据库"
    DATABASES=$(mysql $MYSQL_CHARSET_OPTS -u$DB_USER -N -e "SHOW DATABASES" | grep -Ev "^(information_schema|performance_schema|mysql|sys)$")
    for DB in $DATABASES; do
        backup_database "$DB"
    done
elif [[ -n "$DB_NAME" && -z "$TABLE_NAME" ]]; then
    backup_database "$DB_NAME"
elif [[ -n "$DB_NAME" && -n "$TABLE_NAME" ]]; then
    backup_table "$DB_NAME" "$TABLE_NAME"
else
    error "必须先指定数据库(-d)才能指定表(-t)"
    show_usage
fi
