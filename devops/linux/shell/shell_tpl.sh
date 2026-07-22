#!/usr/bin/env bash
set -eEuo pipefail

# =========== 脚本说明 ===========
# 请修改工作目录 WORK_DIR 和日志文件 LOG_FILE
# 使用方式: ./template.sh 
# 参数: 
#  -v: 开启 debug 日志
#

# =========== 配置区域 ===========
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
readonly WORK_DIR="$SCRIPT_DIR"       # 工作目录
readonly LOG_FILE="$WORK_DIR/script.log"  # 日志文件


# =========== 主函数 ===========
function main() {
  # 切换到工作目录  
  cd "$WORK_DIR" || die "无法进入目录: $WORK_DIR"
  
  # 业务逻辑  
  log "业务逻辑开始"
  ls
  log -s "业务逻辑结束"
}

# =========== 清理函数 ===========
function cleanup() {
  # 清理临时文件、释放资源等  
  # rm -f "$TEMP_FILE" 2>/dev/null || true  
  if [[ ! -v ARGS_MAP["help"] ]]; then
    log "执行清理操作\n"
  fi
}

# =========== 工具函数 ===========
function die() {
  log -e "$1"  
  exit "${2:-1}"
}

# =========== 解析参数 ===========
function parse_args(){
  # 参数列表MAP, 形如 [d] = "/path/dir"  
  declare -gA ARGS_MAP  
  while getopts ":vh" opt; do
    case "$opt" in 
      h) ARGS_MAP["help"]="true" ;; 
      v) ARGS_MAP["debug"]="true" ;;  
      \?) die "无效选项：$OPTARG" ;;  
      :) die "选项 $OPTARG 缺少参数" ;; 
    esac
  done
}

# =========== 打印帮助 ===========
function print_help_info(){  
  echo "Usage: $0 [OPTIONS] [ARGS]"  
  echo "Options:"  
  echo " -h  显示帮助信息"  
  echo " -v  显示脚本执行过程详细信息"  
  echo " ...   其他待补充帮助信息"
}

# =========== 日志函数 ===========
# 使用方式：log -d "xxx"
function log() {
  if [[ "$#" -eq 0 ]]; then
    return 0  
  fi
  
  local level="${1#-}"  
  # 检测 LEVEL_MAP 是否存在键 level  
  if [[ -v "LEVEL_MAP[$level]" ]]; then 
    shift  
  else 
    level='i'   # 默认 INFO 级别 
  fi
  
  # DEBUG 级别未开启  
  if [[ "$level" == 'd' && ! -v "ARGS_MAP["debug"]" ]] ; then 
    return 0  
  fi  
  # 构建日志行  
  local log_line="[$(date '+%F %T.%3N')] [${LEVEL_MAP[$level]}] $*"
  
  # 只有 SUCCESS 作为输出，其他写入 stderr  
  if [[ "$level" == 's' ]]; then   
    echo -e "${COLOR_MAP[$level]}$log_line${COLOR_MAP['n']}"  
  elif [[ -t 2 ]]; then    
    echo -e "${COLOR_MAP[$level]}$log_line${COLOR_MAP['n']}" >&2  
  else    
    echo -e "$log_line" >&2  
  fi
  
  # 写入日志文件  
  echo -e "$log_line" >> "$LOG_FILE"
}

# ========= 初始化设置 =========
function init() {  
  # 颜色数组  
  declare -gA COLOR_MAP  
  if [[ -t 1 ]]; then 
    COLOR_MAP=(
      [e]='\033[0;31m'   # Red    
      [w]='\033[1;33m'   # Yellow    
      [i]='\033[0m'    # No color   
      [d]='\033[34m'   # Blue     
      [s]='\033[0;32m'   # Green   
      [n]='\033[0m'    # No color   
    ) 
  fi
  
  # 日志级别 
  declare -gA LEVEL_MAP=( 
    [e]='ERROR'   
    [w]='WARN'   
    [i]='INFO'   
    [d]='DEBUG'  
    [s]='SUCCESS'  
  )
  
  # 解析参数  
  parse_args "$@"
  
  # 打印帮助信息  
  if [[ -v ARGS_MAP["help"] ]]; then  
    print_help_info   
    exit 0  
  fi
  
  log -d "检查工作目录"  
  if [[ ! -d "$WORK_DIR" ]]; then  
    die "工作目录不存在: $WORK_DIR" 
  fi
  
  log -d "检查日志文件"
  if [[ ! -e "$LOG_FILE" ]]; then  
    log -w "新建日志文件$LOG_FILE"   
    touch "$LOG_FILE"  
  fi
}

# =========== 信号处理 ===========
function handle_signal() {  
  errorcode="$?"
  
  if [[ $errorcode -ne 0 ]]; then  
    log -e "脚本非正常退出: 错误码: $errorcode, 行号: $LINENO, 命令: $BASH_COMMAND"  
  elif [[ ! -v ARGS_MAP["help"] ]]; then  
    log "脚本执行结束"
  fi
  
  # 执行清理 
  cleanup
}

# =========== 信号捕获 ===========
trap 'handle_signal $? $LINENO $BASH_COMMAND' EXIT

# =========== 初始化  ===========
init "$@"
log -d "脚本初始化完成"
# ========= 执行主函数 ==========
main "$@"
