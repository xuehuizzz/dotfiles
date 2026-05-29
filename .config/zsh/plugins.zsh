# ============================================================
# Zsh Plugins
# ============================================================
# 插件安装 (首次使用需执行):
# mkdir -p ~/.config/zsh/.plugins && cd ~/.config/zsh/.plugins
# git clone https://github.com/zsh-users/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting
# ============================================================

_plugin_dir="$HOME/.config/zsh/.plugins"

# ---- autosuggestions ----
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

if [[ -r "$_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"

    if (( $+widgets[autosuggest-accept] )); then
        bindkey '^F' autosuggest-accept
    fi
fi

# ---- syntax highlighting (must be last) ----
if [[ -r "$_plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$_plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

unset _plugin_dir
