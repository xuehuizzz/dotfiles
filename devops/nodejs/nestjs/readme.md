
## cli工具
```bash
npm install -g @nestjs/cli  # 全局安装cli工具
nest --version
nest new my-nest-app  # 创建项目, 交互式选择包管理器
nest new my-nest-app --package-manager pnpm    # 直接指定
cd my-nest-app && pnpm start:dev  # 启动项目
```
> npx @nestjs/cli new my-nest-app   # 不安装cli工具, 临时使用
