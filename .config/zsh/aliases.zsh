# rsync -avz file.txt user@yourserver.com:/home/user/  # 从本地传输到远程服务器
# rsync -avz user@yourserver.com:/home/user/file.txt file.txt  # 从远程服务器下载文件到本地
alias ls="ls -G"
alias ll="ls -lhSr"  # h 人性化显示, S 文件大小排序, r 倒序
alias rsync="rsync -avz --progress" # 适合大文件传输, 支持断点续传
alias cp="cp -rv"  # copy file recursively and explain
alias mv="mv -v"   # move file and explain
alias mkdir="mkdir -pv"  # mkdir folder recursively and explain
alias c="clear"
alias sudo="sudo "
alias reload="exec ${SHELL} -l"
alias hist="history -i"
alias jupyter="nohup jupyter notebook --allow-root > jupyter.log 2>&1 &"  #后台启动jupyter notebook
alias tarc="tar -czvf"  # 压缩文件   tarc xxx.tar.gz file1 file2 folder1  # 可以同时归档文件和目录并压缩
alias tarx="tar -xzvf"  # 解压文件   tarx xxx.tar.gz
alias curl="curl --compressed"
alias wget="wget -c"
alias nc="nc -zv"  # 现代化测试主机端口连通性工具, nc -zv myserver.com 22
alias gitconf="git config --global -e"
# alias jupyter="nohup jupyter notebook --allow-root > jupyter.log 2>&1 &"  #后台启动jupyter notebook
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


ffmpeg() {
  docker run --rm -v "$(pwd):/home/ffmpeg" ffmpeg:v1 -y "$@"
}

# linux...............
alias jal="journalctl -xeu"
alias ps="ps aux --sort=-%cpu"  # 按CPU使用率排序
# .tar.gz(带-z参数)    .tar.bz2(带-j参数)
alias tarc="tar -czvf"  # 压缩文件   tarc xxx.tar.gz file1 file2 folder1  # 可以同时归档文件和目录并压缩
alias tarx="tar -xzvf"  # 解压文件   tarx xxx.tar.gz
# alias dsm="docker-slim build --http-probe=false --continue-after=exec"  # --host 指定docker socket文件

# macOS......................................................
# alias ty="sudo spctl --master-disable"  #同意安装任意来源 for mac, 版本需低于macOS15.0
alias dsm="docker-slim build --http-probe=false --continue-after=exec"  # dsm imageName:tag   # 镜像瘦身
alias ql="qlmanage -p"  # quick look

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




