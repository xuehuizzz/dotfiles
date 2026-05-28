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
_autosuggest="$_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [[ -r "$_autosuggest" ]]; then
    source "$_autosuggest"
    bindkey '^F' autosuggest-accept   # Ctrl+F 接受建议 (→ 键默认也可用)
fi

# ---- syntax-highlighting 加载 (必须最后) ----
_syntax_hl="$_plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$_syntax_hl" ]] && source "$_syntax_hl"

unset _plugin_dir _autosuggest _syntax_hl
