#!/usr/bin/env bash
# =============================================================================
# 终端 ANSI 颜色/特效演示 & 实用工具库
# =============================================================================
# 转义序列格式: \033[<参数>m
# 多个参数用 ";" 分隔，例如: \033[1;31;42m = 粗体+红色前景+绿色背景
#
# ---- SGR (Select Graphic Rendition) 参数速查 ----
#
#  0   重置所有       1   粗体        2   弱化
#  3   斜体           4   下划线      5   慢闪烁
#  7   反显           8   隐藏        9   删除线
#
#  22  关闭粗体/弱化  23  关闭斜体    24  关闭下划线
#  25  关闭闪烁       27  关闭反显    28  关闭隐藏
#  29  关闭删除线
#
#  前景: 30-37 / 90-97(亮色) / 38;5;n(256色) / 38;2;r;g;b(真彩色)
#  背景: 40-47 / 100-107(亮色) / 48;5;n(256色) / 48;2;r;g;b(真彩色)
#  39 恢复默认前景    49 恢复默认背景
# =============================================================================

# ---- 终端能力检测 ----
detect_color_support() {
    # 如果不是终端（比如管道），禁用颜色
    if [[ ! -t 1 ]]; then
        NO_COLOR=1
        return
    fi

    # 尊重 NO_COLOR 环境变量 (https://no-color.org/)
    if [[ -n "${NO_COLOR:-}" ]]; then
        return
    fi

    # 检测真彩色支持
    if [[ "${COLORTERM:-}" == "truecolor" || "${COLORTERM:-}" == "24bit" ]]; then
        TRUECOLOR_SUPPORT=1
    else
        TRUECOLOR_SUPPORT=0
    fi

    # 检测 256 色支持
    local colors
    colors=$(tput colors 2>/dev/null || echo 0)
    if (( colors >= 256 )); then
        COLOR256_SUPPORT=1
    else
        COLOR256_SUPPORT=0
    fi
}

detect_color_support

# =============================================================================
# 1️⃣  基础颜色定义：颜色与样式分离
# =============================================================================
if [[ -z "${NO_COLOR:-}" ]]; then
    # -- 样式 --
    BOLD="\033[1m"
    DIM="\033[2m"
    ITALIC="\033[3m"
    UNDERLINE="\033[4m"
    BLINK="\033[5m"
    REVERSE="\033[7m"
    STRIKETHROUGH="\033[9m"
    RESET="\033[0m"

    # -- 前景色（普通）--
    BLACK="\033[30m"
    RED="\033[31m"
    GREEN="\033[32m"
    YELLOW="\033[33m"
    BLUE="\033[34m"
    PURPLE="\033[35m"
    CYAN="\033[36m"
    WHITE="\033[37m"

    # -- 前景色（亮色）--
    BRIGHT_BLACK="\033[90m"
    BRIGHT_RED="\033[91m"
    BRIGHT_GREEN="\033[92m"
    BRIGHT_YELLOW="\033[93m"
    BRIGHT_BLUE="\033[94m"
    BRIGHT_PURPLE="\033[95m"
    BRIGHT_CYAN="\033[96m"
    BRIGHT_WHITE="\033[97m"

    # -- 背景色 --
    BG_BLACK="\033[40m"
    BG_RED="\033[41m"
    BG_GREEN="\033[42m"
    BG_YELLOW="\033[43m"
    BG_BLUE="\033[44m"
    BG_PURPLE="\033[45m"
    BG_CYAN="\033[46m"
    BG_WHITE="\033[47m"

    # -- 256 色常用命名 --
    ORANGE_256="\033[38;5;214m"
    LIGHT_BLUE_256="\033[38;5;45m"
    LIME_256="\033[38;5;82m"
    PINK_256="\033[38;5;206m"
    GRAY_256="\033[38;5;245m"

    BG_ORANGE_256="\033[48;5;214m"
    BG_LIGHT_BLUE_256="\033[48;5;45m"
else
    # NO_COLOR 模式：所有变量设为空字符串
    BOLD="" DIM="" ITALIC="" UNDERLINE="" BLINK=""
    REVERSE="" STRIKETHROUGH="" RESET=""
    BLACK="" RED="" GREEN="" YELLOW="" BLUE="" PURPLE="" CYAN="" WHITE=""
    BRIGHT_BLACK="" BRIGHT_RED="" BRIGHT_GREEN="" BRIGHT_YELLOW=""
    BRIGHT_BLUE="" BRIGHT_PURPLE="" BRIGHT_CYAN="" BRIGHT_WHITE=""
    BG_BLACK="" BG_RED="" BG_GREEN="" BG_YELLOW=""
    BG_BLUE="" BG_PURPLE="" BG_CYAN="" BG_WHITE=""
    ORANGE_256="" LIGHT_BLUE_256="" LIME_256="" PINK_256="" GRAY_256=""
    BG_ORANGE_256="" BG_LIGHT_BLUE_256=""
fi

# =============================================================================
# 2️⃣  核心工具函数
# =============================================================================

# 通用彩色输出
# 用法: cecho "\033[1;31m" "这是红色粗体"
cecho() {
    local style="$1"
    shift
    printf "%b%s%b\n" "$style" "$*" "$RESET"
}

# 日志函数 —— 适合 CI / deploy 脚本
log_info()  { printf "%b[INFO]%b %s\n"  "\033[34m"           "\033[0m" "$*"; }
log_ok()    { printf "%b[ OK ]%b %s\n"  "\033[1;32m"         "\033[0m" "$*"; }
log_warn()  { printf "%b[WARN]%b %s\n"  "\033[1;33m"         "\033[0m" "$*"; }
log_error() { printf "%b[ERROR]%b %s\n" "\033[1;31m"         "\033[0m" "$*"; }
log_debug() { printf "%b[DEBUG]%b %s\n" "\033[38;5;245m"     "\033[0m" "$*"; }

# =============================================================================
# 3️⃣  演示开始
# =============================================================================

printf "\n%b===== 1. 样式与颜色自由组合 =====%b\n" "$BOLD$CYAN" "$RESET"

cecho "$BLACK"            "  普通黑色"
cecho "$BOLD$BLACK"       "  粗体黑色（亮灰）"
cecho "$RED"              "  普通红色"
cecho "$BOLD$RED"         "  粗体红色"
cecho "$GREEN"            "  普通绿色"
cecho "$BOLD$UNDERLINE$GREEN" "  粗体+下划线+绿色"
cecho "$YELLOW"           "  普通黄色"
cecho "$ITALIC$YELLOW"    "  斜体黄色"
cecho "$BLUE"             "  普通蓝色"
cecho "$PURPLE"           "  普通紫色"
cecho "$CYAN"             "  普通青色"
cecho "$WHITE"            "  普通白色"

# =============================================================================
printf "\n%b===== 2. 背景色 + 前景色组合 =====%b\n" "$BOLD$CYAN" "$RESET"
# =============================================================================

cecho "$BG_BLACK$WHITE"      " 黑底白字 "
cecho "$BG_RED$BLACK"        " 红底黑字 "
cecho "$BG_GREEN$BLUE"       " 绿底蓝字 "
cecho "$BG_YELLOW$BLUE"      " 黄底蓝字 "
cecho "$BG_BLUE$BLACK"       " 蓝底黑字 "
cecho "$BG_PURPLE$BLACK"     " 紫底黑字 "
cecho "$BG_CYAN$BLACK"       " 青底黑字 "
cecho "$BG_WHITE$BLUE"       " 白底蓝字 "

# =============================================================================
printf "\n%b===== 3. 文字特效 =====%b\n" "$BOLD$CYAN" "$RESET"
# =============================================================================

cecho "$DIM$GREEN"                    "弱化亮度的绿色文字"
cecho "$ITALIC$YELLOW"                "斜体的黄色文字（需终端支持）"
cecho "$UNDERLINE$BLUE"               "带下划线的蓝色文字"
cecho "$BLINK$RED"                    "闪烁的红色文字（部分终端支持）"
cecho "$REVERSE$WHITE"                "反显的白色文字"
cecho "$STRIKETHROUGH$PURPLE"         "删除线的紫色文字（需终端支持）"
cecho "\033[8m"                       "隐藏的文字（看不见是正常的）"

# =============================================================================
printf "\n%b===== 4. 特效叠加 =====%b\n" "$BOLD$CYAN" "$RESET"
# =============================================================================

cecho "$BOLD$UNDERLINE$RED"           "粗体+下划线+红色"
cecho "$BOLD$ITALIC$BLINK$GREEN"      "粗体+斜体+闪烁+绿色"
cecho "$BOLD$UNDERLINE$BG_WHITE$BLACK" "粗体+下划线+白底+黑字"

# =============================================================================
printf "\n%b===== 5. 256 色命名变量 =====%b\n" "$BOLD$CYAN" "$RESET"
# =============================================================================

if (( COLOR256_SUPPORT )); then
    cecho "$LIME_256"                     "前景色 82  (LIME_256)"
    cecho "$ORANGE_256"                   "前景色 214 (ORANGE_256)"
    cecho "$LIGHT_BLUE_256"               "前景色 45  (LIGHT_BLUE_256)"
    cecho "$PINK_256"                     "前景色 206 (PINK_256)"
    cecho "$GRAY_256"                     "前景色 245 (GRAY_256)"
    cecho "$LIME_256$BG_ORANGE_256"       "前景绿 + 背景橙"
    cecho "$ORANGE_256$BG_LIGHT_BLUE_256" "前景橙 + 背景蓝"
else
    log_warn "终端不支持 256 色，跳过"
fi

# =============================================================================
printf "\n%b===== 6. RGB 真彩色 =====%b\n" "$BOLD$CYAN" "$RESET"
# =============================================================================

if (( TRUECOLOR_SUPPORT )); then
    cecho "\033[38;2;255;255;255;48;2;255;0;0m"   "前景白色 + 背景红色 (RGB)"
    cecho "\033[38;2;0;0;0;48;2;0;255;0m"         "前景黑色 + 背景绿色 (RGB)"
    cecho "\033[38;2;255;255;0;48;2;0;0;255m"      "前景黄色 + 背景蓝色 (RGB)"

    # 彩虹渐变
    printf "  "
    for (( i=0; i<80; i++ )); do
        local_r=$(( (i * 255 / 80) ))
        local_g=$(( (80 - i) * 255 / 80 ))
        local_b=128
        printf "\033[48;2;%d;%d;%dm " "$local_r" "$local_g" "$local_b"
    done
    printf "\033[0m\n"
else
    log_warn "终端不支持真彩色 (\$COLORTERM != truecolor)，跳过"
fi

# =============================================================================
printf "\n%b===== 7. 256 色色板预览 =====%b\n" "$BOLD$CYAN" "$RESET"
# =============================================================================

if (( COLOR256_SUPPORT )); then
    # 标准色 0-15
    printf "  标准色 (0-15):\n  "
    for (( i=0; i<=15; i++ )); do
        printf "\033[48;5;%dm %3d \033[0m" "$i" "$i"
        if (( (i + 1) % 8 == 0 )); then
            printf "\n"
            (( i < 15 )) && printf "  "
        fi
    done
    printf "\n"

    # 216 色 16-231
    printf "  216 色 (16-231):\n  "
    for (( i=16; i<=231; i++ )); do
        printf "\033[48;5;%dm %3d \033[0m" "$i" "$i"
        if (( (i - 15) % 12 == 0 )); then
            printf "\n"
            (( i < 231 )) && printf "  "
        fi
    done
    printf "\n"

    # 灰度 232-255
    printf "  灰度 (232-255):\n  "
    for (( i=232; i<=255; i++ )); do
        printf "\033[48;5;%dm %3d \033[0m" "$i" "$i"
    done
    printf "\n"
else
    log_warn "终端不支持 256 色，跳过色板"
fi

# =============================================================================
printf "\n%b===== 8. 日志函数演示 =====%b\n" "$BOLD$CYAN" "$RESET"
# =============================================================================

log_debug "开始部署流程..."
log_info  "正在拉取最新代码"
log_ok    "代码拉取成功"
log_warn  "检测到未提交的更改"
log_error "数据库连接失败"

# =============================================================================
printf "\n%b===== 环境信息 =====%b\n" "$BOLD$CYAN" "$RESET"
# =============================================================================

printf "  TERM:       %s\n" "${TERM:-未设置}"
printf "  COLORTERM:  %s\n" "${COLORTERM:-未设置}"
printf "  tput colors: %s\n" "$(tput colors 2>/dev/null || echo '不可用')"
printf "  256色支持:  %s\n" "$( (( COLOR256_SUPPORT )) && echo '✅ 是' || echo '❌ 否')"
printf "  真彩色支持: %s\n" "$( (( TRUECOLOR_SUPPORT )) && echo '✅ 是' || echo '❌ 否')"
printf "\n"
