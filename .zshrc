# 设置中文
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8

# omz setup
ZSH_DISABLE_COMPFIX=true
export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
# DISABLE_AUTO_UPDATE="true"  # 禁用自动更新
DISABLE_UPDATE_PROMPT="true"  # 自动更新时无需确认
export UPDATE_ZSH_DAYS=15     # 自动更新频率
# DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_AUTO_TITLE="true"   # 禁用动态标题
ENABLE_CORRECTION="true"  # 启用自动纠正功能
DISABLE_UNTRACKED_FILES_DIRTY="true" 
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# cus setup
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export PATH="/usr/local/opt/apr-util/bin:$PATH"
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=/opt/theos/bin:$PATH
export THEOS=/opt/theos
source $ZSH/oh-my-zsh.sh
source ~/.bash_profile

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
alias mac="neofetch --off --colors 3 4 5 6 2 2"
#alias opena="open -a TextEdit"
alias ca="conda activate"
alias tarc="tar -czvf"  # 压缩文件   tarc xxx.tar.gz file1 file2 folder1  # 可以同时归档文件和目录并压缩
alias tarx="tar -xzvf"  # 解压文件   tarx xxx.tar.gz
alias ffmpeg="docker run --rm -v $(pwd):/home/ffmpeg ffmpeg:v1"
