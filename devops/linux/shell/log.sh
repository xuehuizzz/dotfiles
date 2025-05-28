#! /bin/bash

# 颜色变量（用 tput）
RESET=$(tput sgr0)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)

# 日志函数：标签和内容都带颜色
# info() {
#   printf "%s[INFO] %s%s\n" "$BLUE" "$*" "$RESET"
# }
#
# succ() {
#   printf "%s[SUCCESS] %s%s\n" "$GREEN" "$*" "$RESET"
# }
#
# warn() {
#   printf "%s[WARN] %s%s\n" "$YELLOW" "$*" "$RESET" >&2
# }
#
# err() {
#   printf "%s[ERROR] %s%s\n" "$RED" "$*" "$RESET" >&2
#   exit 1
# }


# 仅标签是彩色, 内容是白色
info() {
  printf "%s[INFO]%s %s\n" "$BLUE" "$RESET" "$*"
}

succ() {
  printf "%s[SUCCESS]%s %s\n" "$GREEN" "$RESET" "$*"
}

warn() {
  printf "%s[WARN]%s %s\n" "$YELLOW" "$RESET" "$*" >&2
}

err() {
  printf "%s[ERROR]%s %s\n" "$RED" "$RESET" "$*" >&2
  exit 1
}


# 测试调用
info "这是蓝色信息内容"
succ "这是绿色成功内容"
warn "这是黄色警告内容"
# err "这是红色错误内容，脚本退出"

