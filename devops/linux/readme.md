## 开启防火墙及SSH服务

```bash
sudo apt/yum install -y openssh-server ufw   # centos 先安装 epel-release, 在安装ufw
sudo systemctl start sshd  # 开启ssh服务
sudo systemctl enable sshd  # 设置开机自启
sudo systemctl start ufw  # 开启防火墙
sudo systemctl enable ufw  # 设置开机自启
sudo ufw allow ssh   # 允许 SSH 连接
sudo ufw enable      # 启用防火墙
sudo ufw status      # 查看防火墙状态
```

## systemctl
```bash
systemctl list-units --type=service  # 查看所有已启动的服务, --all 查看所有服务
systemctl list-unit-files --type=service  # 查看所有已知服务及其启用状态

systemctl start xxx  # 启动xxx服务
systemctl stop xxx  # 停止xxx服务
systemctl restart xxx  # 重启xxx服务
systemctl enable xxx  # 设置xxx服务开机自启
systemctl disable xxx  # 禁用xxx服务的开机自启
systemctl is-enabled xxx  # 查看xxx服务是否开机自启

systemctl reboot  # 重启系统(推荐使用)
systemctl poweroff  # 关机系统
systemctl suspend  # 挂起系统
```

## snap
```bash
# Snap 是一种现代化的包管理和应用分发工具，适合需要快速分发、跨平台兼容性和安全隔离的场景。
# 核心是通过一种称为 Snap 包（snap package）的格式，提供了一种跨平台、独立的方式来分发和管理软件
# 它为开发者提供了便利，为用户带来了简化的安装体验，但可能在资源消耗和启动速度上有所折衷。
sudo apt update && sudo apt install -y snapd
sudo snap install xxx  # 安装xxx包 cannot specify mode for multiple store snaps (only for one store snap or several local ones)
sudo snap remove xxx  # 卸载xxx包
sudo snap list  # 列出已安装的snap包
sudo snap find xxx  # 查找xxx包
sudo snap clean  # 清理缓存
sudo snap refresh  # 更新所有已安装的包, sudo snap refresh xxx 指定更新

sudo snap services  # 列出所有 Snap 管理的服务及其状态
sudo snap services xxx  # 查看xxx的服务状态
sudo snap start xxx  # 启动xxx服务
sudo snap stop xxx  # 停止xxx服务
sudo snap restart xxx  # 重启xxx服务
sudo snap enable xxx  # 设置xxx服务开机自启
sudo snap disable xxx  # 禁用xxx服务开机自启
```

