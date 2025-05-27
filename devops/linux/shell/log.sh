#! /bin/bash

# 颜色变量（用 tput）
RESET=$(tput sgr0)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)

# 日志函数：标签和内容都带颜色
# info() {
#   echo -e "${BLUE}[INFO] $*${RESET}"
# }
#
# success() {
#   echo -e "${GREEN}[SUCCESS] $*${RESET}"
# }
#
# warn() {
#   echo -e "${YELLOW}[WARN] $*${RESET}" >&2
# }
#
# error() {
#   echo -e "${RED}[ERROR] $*${RESET}" >&2
#   exit 1
# }



# 仅标签是彩色, 内容是白色
info() {
  echo -e "${BLUE}[INFO]${RESET} $*"
}

success() {
  echo -e "${GREEN}[SUCCESS]${RESET} $*"
}

warn() {
  echo -e "${YELLOW}[WARN]${RESET} $*" >&2
}

error() {
  echo -e "${RED}[ERROR]${RESET} $*" >&2
  exit 1
}


# 测试调用
info "这是蓝色信息内容"
success "这是绿色成功内容"
warn "这是黄色警告内容"
error "这是红色错误内容，脚本退出"
