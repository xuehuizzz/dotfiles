# 按照一定顺序加载配置
typeset -g ZSH_CONFIG_DIR="$HOME/.config/zsh"

for _f in "$ZSH_CONFIG_DIR"/[0-9][0-9]-*.zsh(N); do
  source "$_f"
done

unset _f
