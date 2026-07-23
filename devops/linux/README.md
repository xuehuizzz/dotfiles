## 创建管理员用户
```bash
sudo adduser adminuser
sudo usermod -aG sudo adminuser  # Ubuntu
sudo usermod -aG wheel adminuser  # Red Hat
```
## 禁用直接 root SSH 访问
```bash
sudo nano /etc/ssh/sshd_config
# Set:
PermitRootLogin no
```
```bash
usermod -aG sudo username   # Ubuntu/Debian 将username添加到sudo组
usermod -aG wheel username  # RHEL/CentOS  将username添加到wheel组
```
## 自动禁止暴力破解 IP
```bash
sudo apt install fail2ban         # Ubuntu
sudo dnf install fail2ban         # Red Hat
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```
## <mark>dig域名解析</mark>
DNS 是树形结构，按域名从右向左解析
```bash
dig example.com  # 解析域名信息
dig +short example.com   # 仅输出IP
dig +short -x xxx.xxx.xxx.xxx  # 仅输出域名
dig example.com A  # 查询A记录, ipv4
dig example.com AAAA  # 查询AAAA记录, ipv6
dig example.com MX  # 查询 MX
dig example.com NS  # 查询 NS
dig example.com TXT  # 查询 TXT
dig example.com CNAME  # 查询 CNAME
dig example.com  # 查看完整解析
dig @8.8.8.8 example.com  # 使用指定 DNS
dig +trace example.com  # 查看解析链
```
> 常见DNS记录类型:
  - A	IPv4地址, Address Record（IPv4, 32 位 = 4 字节）
  - AAAA	IPv6地址, IPv6地址是128位 = 16 字节, 正好是IPv4的4倍, 所以命名为AAAA
  - CNAME	别名, CNAME 不能和其他记录共存
  - MX	邮件服务器, 存在优先级, 数字越小, 优先级越高
  - NS	域名服务器
  - TXT	文本记录（SPF、DKIM 等）
  - SOA	域名授权信息
  - PTR	反向解析, 倒序IP.in-addr.arpa    通过ip查域名, 跟A记录相反

## <mark>tcpdump抓包</mark>
```bash
tcpdump -i interface_name -nn -w test.pcap  # 把抓包结果保存成pcap文件
tcpdump -C 100 -W 10 -w test.pcap   # 自动滚动文件, 每个100M, 最多10个
tcpdump -D   # 查看网卡, 或 tcpdump --list-interfaces
tcpdump -A   # 查看 ASCII（HTTP 很有用）
tcpdump -vv  # 查看详细信息, -vvv 更详细
tcpdump -c 100  # 限制抓包数量, 只抓100个包
timeout 30 tcpdump -i interface_name -w test.pcap  # 用仅抓30s包
tcpdump -i interface_name  # 抓指定网卡
tcpdump -i interface_name  -X  # 显示包内容, HEX ASCII
tcpdump -i interface_name  -xx  # 显示包内容, 只显示HEX
tcpdump -i any  # 抓所有网卡
tcpdump -i interface_name -nn  # 不解析域名,默认 tcpdump 会解析 DNS, 两个n分别作用于ip和端口
tcpdump -i eth0 -nn -s 0  # 查看完整数据包, 默认会截断
tcpdump -i interface_name host xxx.xxx.xxx.xxx  # 抓指定主机, 双向, A->B, B->A都会抓
tcpdump src host xxx.xxx.xxx.xxx  # 只抓源ip, 由这个IP发出去的流量包
tcpdump dst host xxx.xxx.xxx.xxx  # 只抓目的ip, 由这个IP发进来的流量包
tcpdump -nn port 80  # 抓指定端口的流量, 443, 22, 53, 3306, 6379, ...
tcpdump protocol_name  # 抓指定协议, tcp, udp, icmp, arp, ...
tcpdump -nn host 10.0.0.8 and port 3306  # 同时指定IP和端口
tcpdump port 80 or port 443  # 多条件, tcpdump host 10.0.0.1 or host 10.0.0.2
tcpdump -nn not port 22  # 抓取除了指定的端口之外的端口流量, 双向
tcpdump not host 192.168.1.1  # 排除某个IP的流量, 双向
tcpdump 'tcp[tcpflags] & tcp-syn != 0'  # 查看 SYN 包（排查三次握手）   或  tcpdump 'tcp[13] == 2'
tcpdump 'tcp[13] == 18'  # 查看 SYN ACK
tcpdump 'tcp[tcpflags] & tcp-rst != 0'   # BPF（Berkeley Packet Filter）过滤表达式, 只抓RST（Reset）数据包, 常用于分析Connection refused
tcpdump 'tcp[tcpflags] & tcp-fin != 0'   # 查看FIN, 排查连接关闭
tcpdump 'tcp[tcpflags] & tcp-push != 0'  # 查看PSH, 查看真正的数据发送
tcpdump -nn "tcp[tcpflags] & (tcp-syn|tcp-ack) != 0"  # 查前三次握手, 分析为什么连不上
```

## <mark>生成SSH秘钥对</mark>
```bash
ssh-keygen -t ed25519 -C "user email"    # ED25519（推荐，更安全）
ssh-keygen -t rsa -b 4096 -C "user email"   # RSA（广泛支持）

# 设置免密登录, 将你的 SSH 公钥复制到远程服务器的授权密钥文件中, 就可以使用 SSH 密钥进行身份验证，而不需要每次登录时输入密码
ssh-copy-id 用户名@远程主机
```
> `-C`选项是在`ssh-keygen`命令中添加一条**注释**到生成的SSH公钥中, 方便人类识别, 不影响SSH功能

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
> 1. 请妥善保管私钥文件（server.key）
> 
> 2. 自签名证书在浏览器中会显示不受信任的警告，这是正常的
> 
> 3. 如果需要在生产环境使用，建议购买受信任的CA机构颁发的证书
> 
> 4. 生成证书时的CN（Common Name）要匹配你的域名，上面例子中使用的是localhost, 如果你需要修改证书的信息（比如域名），可以在生成CSR时修改-subj参数中的值。

## <mark>创建逻辑卷并格式化文件系统</mark>
```bash
# 如何查看 VG（Volume Group）还有多少空闲空间可以用来创建或扩容 LV
vgs
# 创建逻辑卷  卷组名称-逻辑卷名称   vg_data-lv_backup
lvcreate -L 20G -n lv_backup vg_data
# 查看
lvs
# 格式文件系统 xfs
mkfs.xfs /dev/vg_data/lv_backup   # mkfs -t xfs /xxx/xxx 一样
```
>创建逻辑卷会生成两种访问路径, 但指向的是同一块设备
  - /dev/mapper/卷组名称-逻辑卷名称
  - /dev/卷组名称/逻辑卷名称
>常用文件系统:
  - xfs:  大文件性能好，支持在线扩容
  - ext4: 几乎所有 Linux 都支持, 稳定、兼容性最好
  - btrfs: 新一代文件系统, 快照、压缩、校验
  - vfat/FAT32: Windows、U盘兼容
  - exfat: 支持大文件，跨平台, 大容量 U 盘



## <mark>mount目录</mark>
```bash
mount -t nfs xxx.xxx.xxx.xxx:path_b path_a   # 把目录b挂载到a上
umount path_a         # 取消挂载
showmount -e xxx.xxx.xxx.xxx  # 查看服务器的路径支持哪些客户端挂载

设置开机自动挂载, 使用uuid, 比直接写设备路径更稳   /etc/fstab
blkid path_b   # 获取uuid, 输出结果: path_b: UUID="1234-abcd-5678-efgh" TYPE="ext4"
vim /etc/fstab
UUID=1234-abcd-5678-efgh   path_a   ext4   defaults   0 0
```

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


## commands
- `grep "error" file.txt`  # 简单的搜索不用再 cat file.txt | grep "error"
