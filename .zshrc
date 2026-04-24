# ============================================================
# Zsh Config Loader (Ordered & Minimal)
# ============================================================

: "${ZSH_CONFIG_DIR:=${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"

() {
  local config file
  local -a configs=(
    env.zsh
    options.zsh
    aliases.zsh
    plugins.zsh
    prompt.zsh
    sdkman.zsh
  )

  for config in "${configs[@]}"; do
    file="$ZSH_CONFIG_DIR/$config"
    if [[ -r "$file" ]]; then
      source "$file"
    elif [[ -n "$ZSH_DEBUG" ]]; then
      print -u2 "zsh: missing config: $file"
    fi
  done
}
