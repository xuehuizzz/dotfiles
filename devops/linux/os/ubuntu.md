## 配置静态IP   <sub>网络配置文件一般位于`/etc/netplan/`目录下, 配置文件可能是`10-lxc.yaml`或类似名称的文件</sub>

- ```yaml
  network:
    version: 2
    ethernets:
      eth0:   # eth0是网络接口的名称
        dhcp4: false  # 默认为true, 表示启用DHCP,自动获取IP地址, 这里改为false
        # dhcp-identifier: mac
        # 以下内容为配置静态ip自行添加
        addresses:
          - 198.19.249.76/24  # 设置静态 IP 地址和子网掩码, 可配置多个
        routes:
          - to: default
            via: 198.19.249.1  # 默认网关
        nameservers:
          addresses:
            - 8.8.8.8          # 设置 DNS 服务器
            - 8.8.4.4
  ```

- ```bash
  sudo netplan generate  # 检查文本语法
  sudo netplan try  # 测试配置
  sudo netplan apply  # 应用新的网络配置
  ip a 或者 ping 8.8.8.8  # 检查网络接口的IP地址是否正确
  ```

## <mark>开启防火墙及SSH服务</mark>
```bash
sudo apt-get install -y openssh-server ufw  
sudo systemctl start ssh  # 开启ssh服务
sudo systemctl enable ssh  # 设置开机自启
sudo systemctl start ufw  # 开启防火墙
sudo systemctl enable ufw  # 设置开机自启
sudo ufw allow ssh   # 允许 SSH 连接
sudo ufw enable      # 启用防火墙
sudo ufw status      # 查看防火墙状态
```
