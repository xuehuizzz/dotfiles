#!/bin/bash

set -euo pipefail

# 颜色变量（用 tput），非终端环境下自动降级
if [[ -t 1 ]] && tput colors &>/dev/null; then
  RESET=$(tput sgr0)
  RED=$(tput setaf 1)
  YELLOW=$(tput setaf 3)
  GREEN=$(tput setaf 2)
  BLUE=$(tput setaf 4)
else
  RESET=""
  RED=""
  YELLOW=""
  GREEN=""
  BLUE=""
fi

# 日志函数：仅标签彩色，内容白色
info() {
  printf "%s[INFO]%s %s\n" "$BLUE" "$RESET" "$*"
}

success() {
  printf "%s[SUCCESS]%s %s\n" "$GREEN" "$RESET" "$*"
}

warn() {
  >&2 printf "%s[WARN]%s %s\n" "$YELLOW" "$RESET" "$*"
}

error() {
  >&2 printf "%s[ERROR]%s %s\n" "$RED" "$RESET" "$*"
  kill -s TERM "$$"
  exit 1
}

# 仅直接执行时运行测试，source 引用时不触发
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  info "这是蓝色信息内容"
  success "这是绿色成功内容"
  warn "这是黄色警告内容"
  error "这是红色错误内容，脚本退出"
fi
