# ⚙️ 基础设置
setopt prompt_subst
autoload -Uz vcs_info

typeset -ga precmd_functions preexec_functions

# 防止重复注册
precmd_functions=(${precmd_functions:#precmd_vcs_info})
precmd_functions+=(precmd_vcs_info)

precmd_functions=(${precmd_functions:#_cmd_timer_precmd})
precmd_functions+=(_cmd_timer_precmd)

preexec_functions=(${preexec_functions:#_cmd_timer_preexec})
preexec_functions+=(_cmd_timer_preexec)

# 🧠 Git 信息（轻量）
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes false
zstyle ':vcs_info:git:*' formats ' %F{magenta} %b%f'

# ⏱️ 命令执行时间
_cmd_timer_preexec() {
  _cmd_start=$EPOCHREALTIME
}

_cmd_timer_precmd() {
  if [[ -n "$_cmd_start" ]]; then
    local elapsed=$(awk "BEGIN {print $EPOCHREALTIME - $_cmd_start}")

    if (( $(awk "BEGIN {print ($elapsed > 3)}") )); then
      _cmd_duration=" %F{yellow}⏱ $(printf '%.1f' $elapsed)s%f"
    else
      _cmd_duration=""
    fi

    unset _cmd_start
  else
    _cmd_duration=""
  fi
}

precmd_vcs_info() {
  vcs_info
}

# 🎯 PROMPT（极简版）
PROMPT='%F{cyan}%3~%f${vcs_info_msg_0_}${_cmd_duration}
%F{green}❯%f '

# ✨ 体验优化（可选）
setopt auto_cd
setopt hist_ignore_all_dups
setopt share_history

autoload -U colors && colors
