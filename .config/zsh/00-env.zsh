export XDG_CONFIG_HOME="$HOME/.config"  # 配置文件
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# 优先使用 ~/.local/bin 中的用户级工具（如 pip install --user 安装的命令）
export PATH="$HOME/.local/bin:$PATH"

# homebrew conf
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
export HOMEBREW_AUTO_UPDATE_SECS=1296000  # 15天自动更新一次
# export HOMEBREW_NO_ENV_HINTS=1  # 隐藏提示信息

# editor conf
export EDITOR=nvim
export VISUAL=nvim

# language conf
# 不强制设置 TERM, 由终端模拟器决定 (避免 tmux/alacritty/kitty 的 true color 失效)
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# less conf
export LESS="-R -F -X"  # -R 处理颜色 -F 短输出时直接打印 -X 不清屏

