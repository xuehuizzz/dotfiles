setopt PROMPT_SUBST
autoload -U colors && colors
autoload -Uz add-zsh-hook

# ---- git 异步（修正版）----
typeset -g _git_branch=""
typeset -g _git_async_fd=""

_git_async_start() {
  _git_branch=""
  [[ -n $_git_async_fd ]] && {
    zle -F $_git_async_fd 2>/dev/null
    exec {_git_async_fd}<&- 2>/dev/null
  }
  exec {_git_async_fd}< <(
    git symbolic-ref --short HEAD 2>/dev/null \
      || git rev-parse --short HEAD 2>/dev/null
  )
  zle -F $_git_async_fd _git_async_done
}

_git_async_done() {
  local fd=$1
  _git_branch="$(<&$fd)"
  zle -F $fd
  exec {fd}<&-
  _git_async_fd=""
  zle reset-prompt
}

add-zsh-hook precmd _git_async_start

# ---- 颜色 ----
SEG_A_BG=238; SEG_B_BG=240
SEG_A_FG=cyan; SEG_B_FG=205

# ---- prompt ----
_git_seg() {
  [[ -z $_git_branch ]] && return
  print -rn -- "%K{$SEG_B_BG}%F{$SEG_A_BG}%f%F{$SEG_B_FG}  $_git_branch%f "
}

PROMPT='%K{$SEG_A_BG} %F{$SEG_A_FG}%(4~|.../%3~|%~)%f $(_git_seg)%k
%F{green}❯%f '
