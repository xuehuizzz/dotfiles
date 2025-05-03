## <mark>生成SSH秘钥对</mark>
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"    # ED25519（推荐，更安全）
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"   # RSA（广泛支持）

# 设置免密登录, 将你的 SSH 公钥复制到远程服务器的授权密钥文件中, 就可以使用 SSH 密钥进行身份验证，而不需要每次登录时输入密码
ssh-copy-id 用户名@远程主机

# 为别的用户创建公钥, 该用户没有ssh协议的话
# sudo ssh-keygen -t rsa -b 4096 -C "b_sftp@hostname" -f /home/b/.ssh/sftp_key
```

## <mark>使用openssl生成HTTPS自签名证书</mark>
```bash
openssl genrsa -out server.key 4096    # 首先生成私钥（RSA 4096位）
openssl req -new -key server.key -out server.csr -subj "/C=CN/ST=State/L=City/O=Organization/OU=Unit/CN=localhost"   # 生成证书签名请求（CSR）
openssl x509 -req -days 36500 -in server.csr -signkey server.key -out server.crt   # 生成一个长期有效的自签名证书（这里设置有效期为36500天，约100年）
```
完成后你会得到以下文件：

- server.key ：私钥文件
- server.crt ：证书文件
- server.csr ：证书签名请求文件（生成证书后可以删除）
注意事项：

1. 请妥善保管私钥文件（server.key）
2. 自签名证书在浏览器中会显示不受信任的警告，这是正常的
3. 如果需要在生产环境使用，建议购买受信任的CA机构颁发的证书
4. 生成证书时的CN（Common Name）要匹配你的域名，上面例子中使用的是localhost
如果你需要修改证书的信息（比如域名），可以在生成CSR时修改-subj参数中的值。


## <mark>journalctl</mark>
```bash
# journalctl 是 Linux 系统中用来查看和管理系统日志的工具。它是 systemd 系统日志管理器的一部分，用于访问由 journald 守护进程记录的日志信息
# 查看日志
journalctl  # 查看所有日志
journalctl -f  # 实时查看日志
journalctl --since "YYYY-MM-DD"  # 查看某一天的日志
journalctl --since "YYYY-MM-DD HH:MM:SS" --until "YYYY-MM-DD HH:MM:SS"  # 查看特定时间段的日志
journalctl -xeu 服务名.service  # 查看某个服务的日志, e.g. sudo journalctl -u snap.kubelet.daemon -n 50  
journalctl -k  # 查看内核日志
journalctl -b  # 查看当前启动的日志
    journalctl -b -1  # 查看上一次启动的日志
    journalctl -b -2  # 查看两次前启动的日志

# 清理日志
journalctl --vacuum-size=500M  # 按大小清理, e.g. 仅保留500MB的日志, 其余清除
journalctl --vacuum-time=2weeks  # 仅保留过去2周的日志
```

## <mark>systemctl</mark>
```bash
systemctl list-units --type=service  # 查看所有已启动的服务, --all 查看所有服务
systemctl list-unit-files --type=service  # 查看所有已知服务及其启用状态

systemctl start xxx  # 启动xxx服务
systemctl stop xxx  # 停止xxx服务
systemctl restart xxx  # 重启xxx服务
systemctl enable xxx  # 设置xxx服务开机自启
systemctl disable xxx  # 禁用xxx服务的开机自启
systemctl is-enabled xxx  # 查看xxx服务是否开机自启
systemctl mask xxx  # 屏蔽xxx服务, 以防止它被启动，无论是手动启动还是自动启动
systemctl unmask xxx  # 取消屏蔽xxx服务
systemctl reboot  # 重启系统(推荐使用)
systemctl poweroff  # 关机系统
systemctl suspend  # 挂起系统
```

## <mark>snap</mark>
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
## cmds
```bash
echo xxx >> file   # 将内容追加到文件末尾, 文件不存在会创建,  > 是覆盖, 含有空格或特殊字符或多行用引号引起来
```
