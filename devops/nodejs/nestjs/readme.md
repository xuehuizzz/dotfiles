
## cli工具
```bash
npm install -g @nestjs/cli  # 全局安装cli工具
nest --version
nest new my-nest-app  # 创建项目, 交互式选择包管理器
nest new my-nest-app --package-manager pnpm    # 直接指定, 若指定为pnpm或yarn的话, 应提前安装依赖
cd my-nest-app
pnpm run start  # 启动项目, 生产模式启动
pnpm run start:dev  # 启动项目, 开发模式启动, 会开启热重载
```
> npx @nestjs/cli new my-nest-app   # 不安装cli工具, 临时使用
