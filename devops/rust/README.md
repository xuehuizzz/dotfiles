# 安装
```bash
# 官方安装命令
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# 验证
rustc --version
cargo --version
rustup --version

# 卸载
rustup self uninstall
```
# rustup<sub>工具链管理器</sub>
```bash
rustup component add rustfmt  # 官方格式化工具, 使用: cargo fmt
rustup component add clippy  # 官方代码检查工具, 使用: cargo clippy
```

# Cargo <sub>包管理器 + 构建系统 + 任务执行器 + 项目生成器</sub>
```bash
cargo new my_project  # 创建项目
cargo run  # 下载依赖编译优化并跑程序
cargo build --release  # 发布
cargo add xxx  # 安装依赖
cargo fmt  # 自动格式化代码
cargo clippy  # 静态检查
```
