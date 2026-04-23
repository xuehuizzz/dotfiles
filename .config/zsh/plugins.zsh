# ============================================================
# Zsh Plugins
# ============================================================
# 插件安装 (首次使用需执行):
# mkdir -p ~/.config/zsh/.plugins && cd ~/.config/zsh/.plugins
# git clone https://github.com/zsh-users/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting
# ============================================================

_plugin_dir="$HOME/.config/zsh/.plugins"

# ---- autosuggestions 配置 ----
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ---- autosuggestions 加载 ----
source "$_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null

# Ctrl+F 接受建议(→ 键默认也可用)
bindkey '^F' autosuggest-accept 2>/dev/null

# ---- syntax-highlighting 加载 (必须最后) ----
source "$_plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null

unset _plugin_dir
