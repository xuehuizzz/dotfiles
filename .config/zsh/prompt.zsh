# 自定义PROMPT
parse_git_branch() {
  git branch --show-current 2>/dev/null
}

set_prompt() {
  local git_branch="$(parse_git_branch)"
  local path="%F{cyan}%~%f"
  if [ -n "$git_branch" ]; then
    PROMPT="${path} %F{green}(${git_branch})%f ➜ "
  else
    PROMPT="${path} ➜ "
  fi
}

precmd_functions+=(set_prompt)

