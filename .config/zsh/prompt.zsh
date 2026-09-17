setopt PROMPT_SUBST

autoload -U colors && colors
autoload -Uz add-zsh-hook

# ============================================================
#   Colors
# ============================================================

typeset -g PATH_BG=236
typeset -g PATH_FG=110

typeset -g GIT_BG=238
typeset -g GIT_FG=183

typeset -g DIRTY_FG=215

typeset -g OK_FG=110
typeset -g ERR_FG=174


# ============================================================
#   Command status
# ============================================================

typeset -gi _last_status=0
typeset -gi _prompt_initialized=0

typeset -g _arrow_str="%F{$OK_FG}›%f"


_save_status() {
  local st=$?
  if (( !_prompt_initialized )); then
    _last_status=0
    _prompt_initialized=1
  else
    _last_status=$st
  fi
  return $st
}


_update_arrow() {
  if (( _last_status == 0 )); then
    _arrow_str="%F{$OK_FG}›%f"
  else
    _arrow_str="%F{$ERR_FG}›%f"
  fi
  return 0
}

_restore_status() {
  return $_last_status
}

# ============================================================
#   Git state
# ============================================================

typeset -g  _git_branch=""
typeset -g  _git_dirty=""

typeset -gi _git_async_fd=0

typeset -gA _gitdir_cache
typeset -gi _GITDIR_CACHE_MAX=200


# ============================================================
#   Find Git directory
# ============================================================

_git_find_dir() {

  if (( ${+_gitdir_cache[$PWD]} )); then

    local cached="${_gitdir_cache[$PWD]}"

    # Cached negative result.
    if [[ -z "$cached" ]]; then
      if [[ ! -e "$PWD/.git" ]]; then
        return 1
      fi
      unset "_gitdir_cache[$PWD]"

    # Cached valid gitdir.
    elif [[ -e "$cached" ]]; then

      print -r -- "$cached"
      return 0
    # Cached path disappeared.
    else
      unset "_gitdir_cache[$PWD]"
    fi
  fi

  # Keep cache bounded.
  if (( ${#_gitdir_cache} > _GITDIR_CACHE_MAX )); then
    _gitdir_cache=()
  fi

  local dir="$PWD"
  local gitdir
  local c

  while [[ -n "$dir" && "$dir" != "/" ]]; do
    if [[ -e "$dir/.git" ]]; then
      # Normal repository.
      if [[ -d "$dir/.git" ]]; then
        gitdir="$dir/.git"
      # Git worktree / gitfile.
      else
        c=$(<"$dir/.git")
        if [[ "$c" != gitdir:\ * ]]; then
          _gitdir_cache[$PWD]=""
          return 1
        fi

        gitdir="${c#gitdir: }"

        # Resolve relative gitdir paths relative to the
        # directory containing the .git file.
        if [[ "$gitdir" != /* ]]; then
          gitdir="$dir/$gitdir"
        fi
      fi

      if [[ -d "$gitdir" ]]; then
        _gitdir_cache[$PWD]="$gitdir"
        print -r -- "$gitdir"
        return 0
      fi

      _gitdir_cache[$PWD]=""
      return 1
    fi

    dir="${dir:h}"
  done

  _gitdir_cache[$PWD]=""
  return 1
}


# ============================================================
#   Read Git HEAD
# ============================================================

_git_read_head() {
  local gitdir=$1
  local head

  [[ -r "$gitdir/HEAD" ]] || return 1
  head=$(<"$gitdir/HEAD")
  if [[ "$head" == ref:\ * ]]; then
    print -r -- "${head#ref: refs/heads/}"
  else
    # Detached HEAD.
    print -r -- "${head[1,7]}"
  fi
  return 0
}


# ============================================================
#   Async Git cleanup
# ============================================================

_git_async_cleanup() {
  if (( _git_async_fd )); then
    if [[ -o zle ]]; then
      zle -F "$_git_async_fd" 2>/dev/null
    fi
    exec {_git_async_fd}<&- 2>/dev/null
    _git_async_fd=0
  fi

  return 0
}


# ============================================================
#   Async Git update
# ============================================================

_git_update() {
  local st=$?

  # Cancel any previous async job.
  _git_async_cleanup

  local gitdir


  # ----------------------------------------------------------
  # Not inside Git repository.
  # ----------------------------------------------------------

  if ! gitdir=$(_git_find_dir); then
    _git_branch=""
    _git_dirty=""
    return $st
  fi


  # ----------------------------------------------------------
  # Read branch / detached HEAD.
  # ----------------------------------------------------------

  _git_branch=$(_git_read_head "$gitdir")

  # If HEAD cannot be read, hide Git segment.
  if [[ -z "$_git_branch" ]]; then
    _git_dirty=""
    return $st
  fi

  # Clear stale dirty state while new async check runs.
  _git_dirty=""

  # ----------------------------------------------------------
  # No ZLE means no interactive prompt exists.
  # ----------------------------------------------------------

  if [[ ! -o zle ]]; then
    return $st
  fi

  exec {_git_async_fd}< <(
    if git -C "$PWD" \
      status \
      --porcelain=v1 \
      -uno \
      2>/dev/null |
      head -n1 |
      grep -q .; then
      print -n '*'
    fi

  )

  zle -F "$_git_async_fd" _git_async_done
  return $st
}


# ============================================================
#   Async Git callback
# ============================================================

_git_async_done() {

  local fd=$1


  # Read "*" when dirty.
  # Empty output means clean.
  IFS= read -r _git_dirty <&$fd

  zle -F "$fd" 2>/dev/null
  exec {fd}<&- 2>/dev/null

  # Callback owns no active FD anymore.
  _git_async_fd=0

  zle reset-prompt
  return 0
}


# ============================================================
#   Prompt segments
# ============================================================

_path_seg() {
  print -rn -- \
    "%K{$PATH_BG}%F{$PATH_FG} %(4~|.../%3~|%~) "
}


_git_seg() {
  [[ -z "$_git_branch" ]] && return 0
  local mark=""
  if [[ -n "$_git_dirty" ]]; then
    mark=" %F{$DIRTY_FG}${_git_dirty}%F{$GIT_FG}"
  fi

  print -rn -- \
    "%F{$GIT_BG}%K{$PATH_BG}%K{$GIT_BG}%F{$GIT_FG} ${_git_branch}${mark} "
  return 0
}


_end_seg() {
  if [[ -n "$_git_branch" ]]; then
    print -rn -- \
      "%k%F{$GIT_BG}%f"
  else
    print -rn -- \
      "%k%F{$PATH_BG}%f"
  fi
  return 0
}


# ============================================================
#   Prompt strings
# ============================================================

_PROMPT_FULL='$(_path_seg)$(_git_seg)$(_end_seg)
${_arrow_str} '

_PROMPT_MINI='${_arrow_str} '

PROMPT=$_PROMPT_FULL

# ============================================================
#   Transient prompt
# ============================================================

_transient_line_finish() {
  PROMPT=$_PROMPT_MINI
  zle reset-prompt
  return 0
}


_transient_line_init() {
  PROMPT=$_PROMPT_FULL
  return 0
}

zle -N zle-line-finish _transient_line_finish
zle -N zle-line-init   _transient_line_init


# ============================================================
#   Transient prompt restoration
# ============================================================

_transient_restore() {
  PROMPT=$_PROMPT_FULL
  return 0
}

add-zsh-hook precmd _save_status
add-zsh-hook precmd _update_arrow
add-zsh-hook precmd _git_update
add-zsh-hook precmd _transient_restore
add-zsh-hook precmd _restore_status
