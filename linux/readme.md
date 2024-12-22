## 开启防火墙及SSH服务

```bash
sudo yum install -y openssh-server ufw
sudo systemctl start sshd  # 开启ssh服务
sudo systemctl enable sshd  # 设置开机自启
sudo systemctl start ufw  # 开启防火墙
sudo systemctl enable ufw  # 设置开机自启
sudo ufw allow ssh   # 允许 SSH 连接
sudo ufw enable      # 启用防火墙
sudo ufw status      # 查看防火墙状态
```
