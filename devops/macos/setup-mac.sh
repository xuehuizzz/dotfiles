#!/usr/bin/env bash
#
# macOS 新机环境初始化脚本
# 自动安装 Homebrew 及常用软件包
#

set -e  # 遇到错误立即退出
set -u  # 使用未定义变量时报错
set -o pipefail

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[ OK ]${NC} $1"; }
log_warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error()   { echo -e "${RED}[FAIL]${NC} $1"; }

# ---------- 1. 检查系统 ----------
if [[ "$(uname)" != "Darwin" ]]; then
    log_error "此脚本仅支持 macOS"
    exit 1
fi

# ---------- 2. 安装 Xcode Command Line Tools ----------
if ! xcode-select -p &>/dev/null; then
    log_info "安装 Xcode Command Line Tools..."
    xcode-select --install
    log_warn "请在弹出窗口中完成安装,然后重新运行此脚本"
    exit 0
else
    log_success "Xcode Command Line Tools 已安装"
fi

# ---------- 3. 安装 Homebrew ----------
if ! command -v brew &>/dev/null; then
    log_info "安装 Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 配置 brew 到当前会话的 PATH(Apple Silicon 与 Intel 路径不同)
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        BREW_SHELLENV='eval "$(/opt/homebrew/bin/brew shellenv)"'
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
        BREW_SHELLENV='eval "$(/usr/local/bin/brew shellenv)"'
    fi

    # 写入 shell 配置文件
    SHELL_RC="$HOME/.zprofile"
    if ! grep -q "brew shellenv" "$SHELL_RC" 2>/dev/null; then
        echo "$BREW_SHELLENV" >> "$SHELL_RC"
        log_success "已将 brew 写入 $SHELL_RC"
    fi
else
    log_success "Homebrew 已安装"
fi

# ---------- 4. 更新 Homebrew ----------
log_info "更新 Homebrew..."
brew update

# ---------- 5. 定义要安装的软件 ----------
CASKS=(
    visual-studio-code
    iina
    orbstack
    brave-browser
)

FORMULAE=(
    bat
    duckdb
    fd
    neovim
    node
    uv
    openconnect
    ripgrep
)

# ---------- 6. 安装 formulae ----------
log_info "开始安装 CLI 工具..."
for pkg in "${FORMULAE[@]}"; do
    if brew list --formula "$pkg" &>/dev/null; then
        log_success "$pkg 已安装,跳过"
    else
        log_info "安装 $pkg ..."
        if brew install "$pkg"; then
            log_success "$pkg 安装完成"
        else
            log_error "$pkg 安装失败"
        fi
    fi
done

# ---------- 7. 安装 cask ----------
log_info "开始安装 GUI 应用 (cask)..."
for app in "${CASKS[@]}"; do
    if brew list --cask "$app" &>/dev/null; then
        log_success "$app 已安装,跳过"
    else
        log_info "安装 $app ..."
        if brew install --cask "$app"; then
            log_success "$app 安装完成"
        else
            log_error "$app 安装失败"
        fi
    fi
done

# ---------- 8. 清理 ----------
log_info "清理缓存..."
brew cleanup

# ---------- 9. 完成 ----------
echo
log_success "🎉 所有软件安装完成!"
echo
log_info "已安装的 CLI 工具: ${FORMULAE[*]}"
log_info "已安装的 GUI 应用: ${CASKS[*]}"
echo
log_warn "提示:请重新打开终端,或运行 'source ~/.zprofile' 以加载 brew 环境变量"
