# rsync -avz file.txt user@yourserver.com:/home/user/  # 从本地传输到远程服务器
# rsync -avz user@yourserver.com:/home/user/file.txt file.txt  # 从远程服务器下载文件到本地

# 判断命令是否存在
_command_exists() {
    command -v "$1" > /dev/null 2>&1
}

# 通用
alias c="clear"
alias sudo="sudo "                                         # 使 sudo 后面的 alias 也生效
alias reload="exec ${SHELL} -l"
alias hist="history -i"
alias gitconf="git config --global -e"

# 文件操作
alias cp="cp -rv"                                          # 递归 + 详细
alias mv="mv -v"
alias mkdir="mkdir -pv"

# 网络
alias rsync="rsync -avz --progress"                        # 适合大文件, 支持断点续传
alias curl="curl --compressed"
alias wget="wget -c"
# 注意: 覆盖 nc 可能破坏 -l 监听等用法, 若需原始 nc 使用 \nc 或 command nc
alias ncz="nc -zv"                                         # 端口连通性测试: ncz myserver.com 22

# 压缩 (.tar.gz 带 -z;  .tar.bz2 用 -j)
alias tarc="COPYFILE_DISABLE=1 tar -czvf"                  # tarc xxx.tar.gz file1 folder1
alias tarx="tar -xzvf"                                     # tarx xxx.tar.gz

# jupyter
alias jupyter="nohup jupyter notebook --allow-root > jupyter.log 2>&1 &"

# ls 根据平台差异处理
case "$OSTYPE" in
    darwin*)
        alias ls="ls -G"
        alias ll="ls -lhSr"                                # h 人性化 S 按大小 r 倒序
        alias ps="ps aux -r"                               # macOS: -r 按 CPU 排序
        ;;
    linux*)
        alias ls="ls --color=auto"
        alias ll="ls -lhSr"
        alias ps="ps aux --sort=-%cpu"                     # Linux: 按 CPU 排序
        alias jal="journalctl -xeu"
        ;;
esac

# 条件别名: 命令存在才替换
_alias_list=(
    "vim:nvim"
    "vi:nvim"
    "cat:bat"
)
for pair in "${_alias_list[@]}"; do
    alias_cmd=${pair%%:*}
    real_cmd=${pair##*:}
    if _command_exists "${real_cmd%% *}"; then
        alias "$alias_cmd"="$real_cmd"
    fi
done
unset _alias_list pair alias_cmd real_cmd

# ffmpeg docker 包装 (仅在本地镜像存在时生效, 避免污染真实 ffmpeg)
if _command_exists docker && docker image inspect ffmpeg:v1 >/dev/null 2>&1; then
    ffmpeg() {
        docker run --rm -v "$(pwd):/home/ffmpeg" ffmpeg:v1 -y "$@"
    }
fi

# macOS
if [[ "$OSTYPE" == darwin* ]]; then
    _command_exists docker-slim && alias dsm="docker-slim build --http-probe=false --continue-after=exec"
    alias ql="qlmanage -p"                                 # quick look

    custom_open() {
        if [[ -f "$1" ]]; then
            command open -a TextEdit "$1"
        elif [[ -d "$1" ]]; then
            command open "$1"
        else
            command open "$@"
        fi
    }
    alias open="custom_open"
fi
