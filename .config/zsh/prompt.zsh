# 基础
setopt PROMPT_SUBST
autoload -Uz vcs_info add-zsh-hook
autoload -U colors && colors

# Git（极简 + 快）
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes false
zstyle ':vcs_info:git:*' formats ' %F{magenta} %b%f'

add-zsh-hook precmd vcs_info

# 智能路径（最多显示最后3段）
_prompt_path() {
  local p=${PWD/#$HOME/~}
  echo ${(j:/:)${(s:/:)p}[-3,-1]}
}

# PROMPT
PROMPT='%F{cyan}$(_prompt_path)%f${vcs_info_msg_0_}
%F{green}❯%f '
