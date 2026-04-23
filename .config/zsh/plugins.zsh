# 插件安装 (首次使用需执行):
# mkdir -p ~/.config/zsh/plugins
# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting

_plugin_dir="$HOME/.config/zsh/.plugins"

# autosuggestions
[[ -f "$_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
    source "$_plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"

# syntax highlighting (必须放在最后加载, 否则高亮失效)
[[ -f "$_plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && \
    source "$_plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

unset _plugin_dir
