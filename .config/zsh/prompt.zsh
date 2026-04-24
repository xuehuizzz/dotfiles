# 基础设置
setopt PROMPT_SUBST
zmodload zsh/datetime          # 提供 $EPOCHREALTIME
autoload -Uz vcs_info add-zsh-hook
autoload -U colors && colors

# Git 信息 (关闭 dirty check 以加速 prompt)
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes false
zstyle ':vcs_info:git:*' formats ' %F{magenta} %b%f'

# add-zsh-hook 自动去重, 比手动维护数组更健壮
add-zsh-hook precmd vcs_info

# PROMPT
PROMPT='%F{cyan}%3~%f${vcs_info_msg_0_}${_cmd_duration}
%F{green}❯%f '
