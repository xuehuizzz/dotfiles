# 历史配置
HISTSIZE=100000              # 内存中最大历史记录数
SAVEHIST=100000              # 保存到文件的最大记录数
HISTFILE="$HOME/.config/zsh/.zsh_history"    # 历史文件路径

setopt APPEND_HISTORY           # 退出时追加而不是覆盖
setopt INC_APPEND_HISTORY       # 命令执行后立刻追加到历史
setopt SHARE_HISTORY            # 多个 shell 会话共享历史
setopt HIST_IGNORE_SPACE        # 以空格开头的命令不记录 (适合临时命令)
setopt HIST_IGNORE_ALL_DUPS     # 新命令若与历史重复, 删除旧的
setopt HIST_REDUCE_BLANKS       # 去掉多余空格
setopt HIST_VERIFY              # 执行历史命令前先显示, 防止误操作
setopt EXTENDED_HISTORY         # 记录时间戳

# 目录相关
setopt AUTO_CD
setopt AUTO_PUSHD         # 自动把 `cd` 的目录也推入栈
setopt PUSHD_SILENT       # 不在每次 pushd/popd 时打印栈
setopt PUSHD_IGNORE_DUPS  # 不允许重复目录

# 其他体验
setopt INTERACTIVE_COMMENTS  # 交互式下允许 # 注释
setopt NO_BEEP               # 禁用响铃

# 补全初始化 (缓存 24h 内跳过 compaudit 加速启动)
autoload -Uz compinit
_zcompdump="$HOME/.config/zsh/.zcompdump"
if [[ -n "$_zcompdump"(#qN.mh+24) ]]; then
    compinit -d "$_zcompdump"
else
    compinit -C -d "$_zcompdump"
fi
unset _zcompdump

zstyle ':completion:*' menu select                          # 菜单式选择
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # 大小写不敏感
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # 补全列表上色
