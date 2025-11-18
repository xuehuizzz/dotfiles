alias ls="ls -G"
alias ll="ls -lhSr"  # h 人性化显示, S 文件大小排序, r 倒序
alias rsync="rsync -avz --progress" # 适合大文件传输, 支持断点续传
alias cp="cp -rv"  # copy file recursively and explain
alias mv="mv -v"   # move file and explain
alias mkdir="mkdir -pv"  # mkdir folder recursively and explain
alias c="clear"
alias sudo="sudo "
alias reload="exec ${SHELL} -l"
alias purge="sudo purge"
alias hist="history -i"
alias jupyter="nohup jupyter notebook --allow-root > jupyter.log 2>&1 &"  #后台启动jupyter notebook
alias tarc="tar -czvf"  # 压缩文件   tarc xxx.tar.gz file1 file2 folder1  # 可以同时归档文件和目录并压缩
alias tarx="tar -xzvf"  # 解压文件   tarx xxx.tar.gz
alias dsm="docker-slim build --http-probe=false --continue-after=exec"  # dsm imageName:tag   # 镜像瘦身
alias ql="qlmanage -p"  # quick look
alias_list=(
    "vim:nvim"
    "vi:nvim"
    "cat:bat"
)

# 判断命令是否存在
_command_exists() {
    command -v "$1" > /dev/null 2>&1
}

for pair in "${alias_list[@]}"; do
    alias_cmd=${pair%%:*}   # alias 名称
    real_cmd=${pair##*:} # 目标命令
    if _command_exists "${real_cmd%% *}"; then  # 如果命令存在（忽略参数部分）
        alias $alias_cmd="$real_cmd"
    fi
done

# custom functions
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
