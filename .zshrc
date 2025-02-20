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
source $ZSH/oh-my-zsh.sh


source ~/.bash_profile
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export PATH="/usr/local/opt/apr-util/bin:$PATH"

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"


export PATH=/opt/theos/bin:$PATH
export THEOS=/opt/theos

alias cat="bat"
alias bi="brew install"
alias bs="brew services"
alias bui="brew uninstall"
alias bd="brew doctor"
alias c="clear"
alias sudo="sudo "
alias reload="exec ${SHELL} -l"
alias purge="sudo purge"
alias hist="history -i"
alias remysql="sudo /usr/local/mysql/support-files/mysql.server restart"  #重启mysql服务
alias jupyter="nohup jupyter notebook --allow-root > jupyter.log 2>&1 &"  #后台启动jupyter notebook
alias mysql=/usr/local/mysql/bin/mysql
alias mac="neofetch --off --colors 3 4 5 6 2 2"
#alias opena="open -a TextEdit"
alias ca="conda activate"



