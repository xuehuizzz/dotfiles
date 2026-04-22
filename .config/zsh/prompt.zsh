# 图标 + Git 状态 + 执行时间 + 错误码
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

# Git 格式化（显示分支 + 脏状态）
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '%F{yellow}●%f'
zstyle ':vcs_info:git:*' unstagedstr '%F{red}●%f'
zstyle ':vcs_info:git:*' formats ' %F{magenta} %b%f%c%u'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta} %b%f (%a)%c%u'

# 命令执行时间
_cmd_timer_preexec() { _cmd_start=$EPOCHREALTIME }
_cmd_timer_precmd() {
  if [[ -n "$_cmd_start" ]]; then
    local elapsed=$(( EPOCHREALTIME - _cmd_start ))
    if (( elapsed >= 3 )); then
      _cmd_duration=" %F{yellow}⏱ $(printf '%.1f' $elapsed)s%f"
    else
      _cmd_duration=""
    fi
    unset _cmd_start
  else
    _cmd_duration=""
  fi
}
preexec_functions+=( _cmd_timer_preexec )
precmd_functions+=( _cmd_timer_precmd )

# 主 PROMPT
PROMPT='%F{blue}╭─%f %F{cyan}%~%f${vcs_info_msg_0_}${_cmd_duration}
%F{blue}╰─%f %(?.%F{green}❯%f.%F{red}❯ %?%f) '
RPROMPT='%F{240}%T%f'
