# 基础设置
setopt PROMPT_SUBST
zmodload zsh/datetime          # 提供 $EPOCHREALTIME
autoload -Uz vcs_info add-zsh-hook
autoload -U colors && colors

# Git 信息 (关闭 dirty check 以加速 prompt)
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes false
zstyle ':vcs_info:git:*' formats ' %F{magenta} %b%f'

# 命令执行时间 (>3s 显示), 使用 zsh 原生浮点运算代替 awk
_cmd_timer_preexec() {
    _cmd_start=$EPOCHREALTIME
}

_cmd_timer_precmd() {
    if [[ -n "$_cmd_start" ]]; then
        local -F elapsed=$(( EPOCHREALTIME - _cmd_start ))
        if (( elapsed > 3 )); then
            _cmd_duration=" %F{yellow}⏱ ${$(printf '%.1f' $elapsed)}s%f"
        else
            _cmd_duration=""
        fi
        unset _cmd_start
    else
        _cmd_duration=""
    fi
}

# add-zsh-hook 自动去重, 比手动维护数组更健壮
add-zsh-hook precmd vcs_info
add-zsh-hook precmd _cmd_timer_precmd
add-zsh-hook preexec _cmd_timer_preexec

# PROMPT
PROMPT='%F{cyan}%3~%f${vcs_info_msg_0_}${_cmd_duration}
%F{green}❯%f '
