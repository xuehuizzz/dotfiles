## 配置静态IP <sub>`nmcli`是CentOS 的命令行网络管理工具，可以直接用来配置静态IP</sub>

```bash
# 1. 检查当前连接名称
sudo nmcli connection show

# 2. 修改连接为静态ip(假设要修改的网络接口的名称为: Wired connection 1), 网络接口的名称若包含特殊字符或空格, 需添加引号
sudo nmcli con mod "Wired connection 1" ipv4.addresses 198.19.249.100/24
sudo nmcli con mod "Wired connection 1" ipv4.gateway 198.19.249.1
sudo nmcli con mod "Wired connection 1" ipv4.dns "8.8.8.8 8.8.4.4"
sudo nmcli con mod "Wired connection 1" ipv4.method manual

# 3. 激活连接
sudo nmcli con up "Wired connection 1"

# ip a 或 ping 8.8.8.8  验证其是否生效
```

## <mark>开启防火墙及SSH服务</mark>
```bash
sudo yum install -y epel-release openssh-server ufw  
sudo systemctl start sshd  # 开启ssh服务
sudo systemctl enable sshd  # 设置开机自启
sudo systemctl start ufw  # 开启防火墙
sudo systemctl enable ufw  # 设置开机自启
sudo ufw allow ssh   # 允许 SSH 连接
sudo ufw enable      # 启用防火墙
sudo ufw status      # 查看防火墙状态
```
