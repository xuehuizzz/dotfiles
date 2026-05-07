setopt PROMPT_SUBST

autoload -U colors && colors
autoload -Uz add-zsh-hook

# async git
typeset -g _git_branch=""
typeset -g _git_async_fd=""
typeset -g _git_last_pwd=""

_git_async_start() {
  # 目录没变化直接跳过
  [[ "$PWD" == "$_git_last_pwd" ]] && return
  _git_last_pwd="$PWD"

  _git_branch=""

  # 清理旧 fd
  if [[ -n "$_git_async_fd" ]]; then
    zle -F $_git_async_fd 2>/dev/null
    exec {_git_async_fd}<&- 2>/dev/null
  fi

  # 非 git 目录直接返回
  git rev-parse --is-inside-work-tree &>/dev/null || return

  # 异步获取 branch
  exec {_git_async_fd}< <(
    git symbolic-ref --short HEAD 2>/dev/null \
      || git rev-parse --short HEAD 2>/dev/null
  )

  zle -F $_git_async_fd _git_async_done
}

_git_async_done() {
  local fd=$1

  IFS= read -r _git_branch <&$fd

  zle -F $fd
  exec {fd}<&-

  _git_async_fd=""

  zle reset-prompt
}

add-zsh-hook precmd _git_async_start

# colors (Tokyo Night style)
typeset -g PATH_BG=236
typeset -g PATH_FG=110

typeset -g GIT_BG=238
typeset -g GIT_FG=183

typeset -g SEP_FG=238

# segments
_path_seg() {
  print -rn -- "%K{$PATH_BG}%F{$PATH_FG} %(4~|.../%3~|%~) "
}

_git_seg() {
  [[ -z "$_git_branch" ]] && return

  print -rn -- \
    "%F{$GIT_BG}%K{$PATH_BG}"\
    "%K{$GIT_BG}%F{$GIT_FG} ${_git_branch} "
}

_end_seg() {
  [[ -n "$_git_branch" ]] && {
    print -rn -- "%F{default}%K{$GIT_BG}"
    return
  }
  print -rn -- "%f%K{$PATH_BG}"
}


PROMPT='$(_path_seg)$(_git_seg)$(_end_seg)%k
%F{110}›%f '
