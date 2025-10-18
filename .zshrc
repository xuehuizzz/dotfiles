export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
source ~/.bash_profile

HISTSIZE=100000                 # 内存中最大历史记录数
SAVEHIST=100000                 # 保存到文件的最大记录数
HISTFILE=~/.zsh_history         # 历史文件路径

setopt INC_APPEND_HISTORY       # 命令执行后立刻追加到历史
setopt SHARE_HISTORY            # 多个 shell 会话共享历史
setopt HIST_IGNORE_SPACE        # 以空格开头的命令不记录（适合临时命令）
setopt HIST_IGNORE_DUPS         # 忽略重复命令
setopt HIST_REDUCE_BLANKS       # 去掉多余空格
setopt HIST_VERIFY              # 在执行历史命令前先在命令行显示，防止误操作
setopt AUTO_CD
setopt AUTO_PUSHD         # 自动把 `cd` 的目录也推入栈
setopt PUSHD_SILENT       # 不在每次 pushd/popd 时打印栈
setopt PUSHD_IGNORE_DUPS  # 不允许重复目录

alias ls="ls -G"
alias ll="ls -lhSr"  # h 人性化显示, S 文件大小排序, r 倒序
alias rsync="rsync -avz --progress" # 适合大文件传输, 支持断点续传
alias cp="cp -rv"  # copy file recursively and explain
alias mv="mv -v"   # move file and explain
alias mkdir="mkdir -pv"  # mkdir folder recursively and explain
alias cat="bat"
alias c="clear"
alias sudo="sudo "
alias reload="exec ${SHELL} -l"
alias purge="sudo purge"
alias hist="history -i"
alias jupyter="nohup jupyter notebook --allow-root > jupyter.log 2>&1 &"  #后台启动jupyter notebook
alias tarc="tar -czvf"  # 压缩文件   tarc xxx.tar.gz file1 file2 folder1  # 可以同时归档文件和目录并压缩
alias tarx="tar -xzvf"  # 解压文件   tarx xxx.tar.gz
alias ffmpeg="docker run --rm -v \$(pwd):/home/ffmpeg ffmpeg:v1 -y"
alias dsm="docker-slim build --http-probe=false --continue-after=exec"  # dsm imageName:tag   # 镜像瘦身
alias ql="qlmanage -p"  # quick look
alias vim="nvim"

custom_open() {    # for macOS
    if [[ -f "$1" ]]; then
        # 如果是文件，直接用 TextEdit 打开
        command open -a TextEdit "$1"
    elif [[ -d "$1" ]]; then
        # 如果是目录，直接用 Finder 打开
        command open "$1"
    else
        command open "$@"
    fi
}
alias open="custom_open"


# 配置zsh插件
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# 自定义PROMPT
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

