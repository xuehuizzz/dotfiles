# <mark>homebrew</mark>
### [安装](https://brew.sh/)
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 常用命令
```bash
# 查看
brew ls  # 列出已安装服务
brew --version   # 查看 brew 版本
brew config   # 查看 brew 配置和环境
brew --prefix  # 查看安装路径, brew --prefix xxx
brew search xxx   # 搜索软件
brew info xxx   # 查看软件信息（版本、依赖、官网）
brew list/ls  # 查看已安装的软件

# 安装升级卸载
brew install xxx  # 安装cli tool
brew install --cask xxx  # 安装GUI app
brew uninstall xxx  # 卸载cli tool
brew uninstall --cask xxx  # 卸载GUI app
brew update  # 更新 brew 自身和软件源
brew outdated   # 查看哪些包可以升级
brew upgrade   # 升级所有包
brew upgrade xxx  # 升级某个包
brew update && brew upgrade   # 更新并升级

# Brewfile
brew bundle dump   # 生成当前环境 Brewfile
brew bundle   # 从 Brewfile 安装全部依赖
brew bundle --file=./Brewfile   # 指定 Brewfile
brew bundle check   # 检查缺少哪些包
brew bundle cleanup  # 清理 Brewfile 里不存在的软件

# 服务
brew services start xxx   # 启动服务
brew services stop xxx   # 停止服务
brew services restart xxx   # 重启服务
brew services list  # 查看所有服务状态
```
