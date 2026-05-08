# ============================================================
#   zsh prompt — async git + transient (Tokyo Night)
# ============================================================

setopt PROMPT_SUBST
autoload -U colors && colors
autoload -Uz add-zsh-hook

# ─── colors ─────────────────────────────────────────────
typeset -g PATH_BG=236
typeset -g PATH_FG=110
typeset -g GIT_BG=238
typeset -g GIT_FG=183
typeset -g DIRTY_FG=215
typeset -g OK_FG=110
typeset -g ERR_FG=174

# ─── last status (immune to precmd pollution) ───────────
typeset -gi _last_status=0
typeset -gi _prompt_initialized=0
typeset -g  _arrow_str="%F{$OK_FG}›%f"

_save_status() {
  local st=$?

  if (( !_prompt_initialized )); then
    _last_status=0
    _prompt_initialized=1
  else
    _last_status=$st
  fi
}
add-zsh-hook precmd _save_status   # MUST be first precmd

_update_arrow() {
  if (( _last_status == 0 )); then
    _arrow_str="%F{$OK_FG}›%f"
  else
    _arrow_str="%F{$ERR_FG}›%f"
  fi
  return 0
}
add-zsh-hook precmd _update_arrow

# ─── git state ──────────────────────────────────────────
typeset -g  _git_branch=""
typeset -g  _git_dirty=""
typeset -gi _git_async_fd=0
typeset -gA _gitdir_cache
typeset -gi _GITDIR_CACHE_MAX=200

_git_find_dir() {
  if (( ${+_gitdir_cache[$PWD]} )); then
    local cached="${_gitdir_cache[$PWD]}"

    if [[ -z "$cached" ]]; then
      [[ ! -e "$PWD/.git" ]] && return 1
      unset "_gitdir_cache[$PWD]"
    elif [[ -e "$cached" ]]; then
      print -r -- "$cached"
      return 0
    else
      unset "_gitdir_cache[$PWD]"
    fi
  fi

  (( ${#_gitdir_cache} > _GITDIR_CACHE_MAX )) && _gitdir_cache=()

  local dir="$PWD"
  local gitdir
  local c

  while [[ -n "$dir" && "$dir" != "/" ]]; do
    if [[ -e "$dir/.git" ]]; then
      if [[ -d "$dir/.git" ]]; then
        gitdir="$dir/.git"
      else
        c=$(<"$dir/.git")
        gitdir="${c#gitdir: }"
      fi

      _gitdir_cache[$PWD]="$gitdir"
      print -r -- "$gitdir"
      return 0
    fi

    dir="${dir:h}"
  done

  _gitdir_cache[$PWD]=""
  return 1
}

_git_read_head() {
  local gitdir=$1
  local head

  [[ -r "$gitdir/HEAD" ]] || return 1

  head=$(<"$gitdir/HEAD")

  if [[ "$head" == ref:* ]]; then
    print -r -- "${head#ref: refs/heads/}"
  else
    print -r -- "${head[1,7]}"
  fi
}

_git_async_cleanup() {
  if (( _git_async_fd )); then
    [[ -o zle ]] && zle -F $_git_async_fd 2>/dev/null
    exec {_git_async_fd}<&- 2>/dev/null
    _git_async_fd=0
  fi

  return 0
}

_git_update() {
  _git_async_cleanup

  local gitdir

  if ! gitdir=$(_git_find_dir); then
    _git_branch=""
    _git_dirty=""
    return 0
  fi

  _git_branch=$(_git_read_head "$gitdir")
  _git_dirty=""

  [[ -o zle ]] || return 0

  exec {_git_async_fd}< <(
    [[ -n "$(git status --porcelain=v1 -uno 2>/dev/null | head -n1)" ]] && print -n '*'
  )

  zle -F $_git_async_fd _git_async_done
  return 0
}

_git_async_done() {
  local fd=$1

  IFS= read -r _git_dirty <&$fd

  zle -F $fd
  exec {fd}<&-

  _git_async_fd=0

  zle reset-prompt
}

add-zsh-hook precmd _git_update

# ─── segments ───────────────────────────────────────────
_path_seg() {
  print -rn -- "%K{$PATH_BG}%F{$PATH_FG} %(4~|.../%3~|%~) "
}

_git_seg() {
  [[ -z "$_git_branch" ]] && return

  local mark=""

  [[ -n "$_git_dirty" ]] && mark=" %F{$DIRTY_FG}${_git_dirty}%F{$GIT_FG}"

  print -rn -- "%F{$GIT_BG}%K{$PATH_BG}%K{$GIT_BG}%F{$GIT_FG} ${_git_branch}${mark} "
}

_end_seg() {
  if [[ -n "$_git_branch" ]]; then
    print -rn -- "%k%F{$GIT_BG}%f"
  else
    print -rn -- "%k%F{$PATH_BG}%f"
  fi
}

# ─── prompt strings ─────────────────────────────────────
_PROMPT_FULL='$(_path_seg)$(_git_seg)$(_end_seg)
${_arrow_str} '

_PROMPT_MINI='${_arrow_str} '

PROMPT=$_PROMPT_FULL

# ─── transient ──────────────────────────────────────────
_transient_line_finish() {
  PROMPT=$_PROMPT_MINI
  zle reset-prompt
}

_transient_line_init() {
  PROMPT=$_PROMPT_FULL
}

zle -N zle-line-finish _transient_line_finish
zle -N zle-line-init   _transient_line_init

_transient_restore() {
  PROMPT=$_PROMPT_FULL
  return 0
}

add-zsh-hook precmd _transient_restore
