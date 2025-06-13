# 安装
```bash
# macos
brew install node
# ubuntu
sudo apt update && sudo apt install nodejs npm

# 验证安装
node -v
npm -v    # npm是 Node.js 的包管理器
npx -v

# 配置国内淘宝镜像
npm config set registry https://registry.npmmirror.com
```
> 优先使用npx创建项目, 例如: npx create-next-app@latest report-system --typescript

# yarn
```bash
# Yarn 和 npm 都是包管理工具, 可以共存, 但在同一个项目中最好只使用其中一个
npm install -g yarn
yarn init  # 初始化项目
yarn add <package>  # 安装依赖
yarn global add <package>  # 全局安装依赖
yarn remove <package>  # 删除依赖
yarn 或 yarn install   # 安装package.json中的所有依赖
yarn upgrade  # 更新所有依赖
yarn upgrade <package>  # 更新指定依赖
yarn list  # 
yarn cache clean  # 清理缓存
yarn start  # 启动项目
```

# nvm
```bash
# 安装
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
exec $SHELL -l  # 加载环境变量, 安装脚本会自动添加到当前shell配置文件中

# 常用命令
nvm install 16  # 安装 Node.js 16.x 版本
nvm use 16  # 切换到 Node.js 16.x
nvm uninstall 16  # 删除指定版本
nvm ls  # 列出已安装的版本
```

# npm ci
npm ci主要用于在自动化环境中安装依赖, 与npm install有以下区别:
1. 严格性:
   - npm ci必须有package.json文件存在
   - package.json和package-lock.json必须匹配, 否则会报错
   - 如果已存在node_modules目录, 会先删除再安装
2. 确定性:
   - 始终按照 package-lock.json 的确切版本安装依赖
   - 不会修改 package.json 和 package-lock.json
   - 安装结果在不同环境中完全一致
3. 速度:
   - 在 CI 环境中通常比 npm install 快
   - 因为跳过了一些不必要的计算和操作
4. 安全性:
   - 不会意外更新依赖版本
   - 能确保团队成员使用完全相同的依赖版本
   - 使用场景: CI/CD流程中, Docker镜像构建过程-
