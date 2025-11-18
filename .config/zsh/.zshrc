export XDG_CONFIG_HOME="$HOME/.config"  # 配置文件

# brew setup
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export HOMEBREW_AUTO_UPDATE_SECS=1296000  # 15天自动更新一次
export HOMEBREW_NO_ENV_HINTS=1  # 隐藏提示信息
source ~/.bash_profile

# zsh plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh setup
HISTSIZE=100000                 # 内存中最大历史记录数
SAVEHIST=100000                 # 保存到文件的最大记录数
HISTFILE=~/.zsh_history         # 历史文件路径
setopt APPEND_HISTORY           # 退出时追加而不是覆盖
setopt INC_APPEND_HISTORY       # 命令执行后立刻追加到历史
setopt SHARE_HISTORY            # 多个 shell 会话共享历史
setopt HIST_IGNORE_SPACE        # 以空格开头的命令不记录（适合临时命令）
setopt HIST_IGNORE_DUPS         # 忽略重复命令
setopt HIST_REDUCE_BLANKS       # 去掉多余空格
setopt HIST_VERIFY              # 在执行历史命令前先在命令行显示，防止误操作
setopt AUTO_CD
setopt AUTO_PUSHD               # 自动把 `cd` 的目录也推入栈
setopt PUSHD_SILENT             # 不在每次 pushd/popd 时打印栈
setopt PUSHD_IGNORE_DUPS        # 不允许重复目录


duckdb() {
  docker run --rm -it -v "$(pwd):/data" -w /data duckdb-cli:latest "$@"
}

ffmpeg() {
  docker run --rm -v "$(pwd):/home/ffmpeg" ffmpeg:v1 -y "$@"
}

# PROMPT setup
parse_git_branch() {
  git branch --show-current 2>/dev/null
}

set_prompt() {
  local git_branch="$(parse_git_branch)"
  local path="%F{cyan}%~%f"
  if [ -n "$git_branch" ]; then
    PROMPT="${path} %F{green}(${git_branch})%f ➜ "
  else
    PROMPT="${path} ➜ "
  fi
}

precmd_functions+=(set_prompt)
