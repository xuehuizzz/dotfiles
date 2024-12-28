## 配置静态IP  <sub>网络配置文件一般位于`/etc/systemd/network/`目录下, 配置文件可能是`eth0.network`或类似名称的文件</sub>

```ini
[Match]
# 注释数据必须另起一行, 否则语法错误
# 替换为实际需要修改的网口
Name=eth0   

[Network]
# DHCP=true
# 替换为静态 IP 和子网掩码
Address=192.168.1.100/24
# 替换为网关
Gateway=192.168.1.1
# 替换为首选 DNS   
DNS=8.8.8.8
# 可选，替换为备用 DNS             
DNS=8.8.4.4               

# [DHCPv4]
# UseDomains=true

# [DHCP]
# ClientIdentifier=mac
```

```bash
# 验证配置文件语法是否有误
sudo networkctl reload
sudo networkctl status

sudo systemctl restart systemd-networkd   # 保存修改后，重启 systemd-networkd 服务
```
