# <mark>homebrew</mark>
Homebrew 是 macOS 上流行的开源包管理器，可以通过命令行快速安装、更新和卸载软件、开发工具及系统依赖。
### [安装](https://brew.sh/)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 常用命令
```bash
# 搜索与软件信息
brew commands                 # 查看所有 brew 命令
brew help                     # 查看帮助
brew help install             # 查看指定命令的帮助
brew search /xxx/             # 使用正则表达式搜索
brew desc xxx                 # 查看软件简介
brew deps xxx                 # 查看软件依赖
brew deps --tree xxx          # 树形显示依赖关系
brew uses xxx                 # 查看哪些软件依赖它
brew leaves                   # 查看非其他包依赖的顶层软件
brew list --formula           # 只查看 CLI 软件包
brew list --cask              # 只查看 GUI 应用
brew list --versions          # 查看已安装软件及版本
brew info --json=v2 xxx       # 以 JSON 格式查看软件信息

# 升级与软件管理
brew pin xxx                  # 锁定软件版本，避免常规升级
brew unpin xxx                # 解除版本锁定
brew upgrade --greedy         # 同时升级有更新的 Cask 应用
brew upgrade --dry-run        # 预览升级操作，不实际执行
brew reinstall xxx            # 重新安装软件
brew reinstall --cask xxx     # 重新安装 GUI 应用
brew link xxx                 # 建立软件的符号链接
brew unlink xxx               # 移除软件的符号链接
brew link --overwrite xxx     # 覆盖冲突文件并建立链接
brew doctor                   # 检查 Homebrew 环境问题

# 清理与磁盘空间
brew cleanup                   # 清理旧版本和过期缓存
brew cleanup -n                # 预览清理内容，不实际执行
brew autoremove                # 卸载不再需要的依赖包
brew autoremove --dry-run      # 预览可卸载的依赖
brew --cache                   # 查看缓存目录
brew --cache xxx               # 查看指定软件的缓存目录
brew --cellar                  # 查看 Formula 安装目录
brew --repository              # 查看 Homebrew 仓库目录
brew list --unbrewed           # 查看安装目录中非 Brew 管理的文件

# Brewfile
brew bundle dump --force       # 覆盖现有 Brewfile
brew bundle list               # 查看 Brewfile 中的依赖
brew bundle list --all         # 查看所有类型的依赖
brew bundle install            # 安装并同步 Brewfile 中的依赖
brew bundle upgrade            # 升级 Brewfile 中的依赖
brew bundle exec xxx           # 在 Brewfile 定义的环境中运行命令
brew bundle add xxx            # 将软件添加到 Brewfile
brew bundle add --cask xxx     # 添加 GUI 应用
brew bundle remove xxx         # 从 Brewfile 移除条目
brew bundle cleanup --dry-run  # 检查 Brewfile 之外的软件

# 服务管理
brew services run xxx          # 运行服务，不注册开机启动
brew services info xxx         # 查看指定服务信息
brew services restart --all    # 重启所有托管服务
brew services stop --all       # 停止所有托管服务
brew services cleanup          # 清理无用的服务配置

# 软件源与仓库扩展
brew tap                       # 查看已添加的第三方仓库
brew tap user/repo             # 添加第三方仓库
brew untap user/repo           # 移除第三方仓库
brew tap-info user/repo        # 查看仓库信息
brew update-reset              # 重置 Homebrew 仓库状态
brew fetch xxx                 # 下载软件安装文件
brew fetch --force xxx         # 强制重新下载
brew missing                   # 检查缺失的依赖
brew log xxx                   # 查看软件版本变更历史
brew cat xxx                   # 查看软件安装定义

# Shell环境与诊断
brew shellenv                  # 输出 Shell 环境配置
brew --prefix                  # 查看 Homebrew 根路径
brew --prefix xxx              # 查看指定软件的安装前缀
brew doctor                    # 诊断环境问题
brew config                    # 查看系统和编译环境
brew analytics off             # 关闭 Homebrew 数据分析
brew analytics                 # 查看数据分析状态

# 日常维护推荐组合
# 更新索引并升级软件
brew update
brew outdated
brew upgrade

# 清理旧版本及无用依赖
brew cleanup -n
brew autoremove --dry-run

# 检查环境
brew doctor

# 备份当前软件清单
brew bundle dump --force
```
