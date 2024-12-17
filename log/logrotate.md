`logrotate 是一个用于管理日志文件的工具，广泛用于自动化日志文件的轮换、压缩和删除，以确保日志不会占用过多的磁盘空间`
## 安装验证

```cmd
sudo apt-get install logrotate   # Debian/Ubuntu
sudo yarn install logrotate    # Red Hat/CentOS

logrotate --version  # 验证是否安装成功
```

## logrotate 的配置文件
- 主配置文件: /etc/logrotate.conf
  - 包含全局设置，可以调用其他子配置文件。
- 子配置文件: /etc/logrotate.d/
  - 每个服务通常会在这个目录下添加自己的配置文件（如 nginx、syslog 等）。
 
## 基本配置格式

```conf
/var/log/myapp/*.log {
    daily                  # 每天轮换, weekly,monthly, yearly
    rotate 7               # 保留 7 个轮换文件
    compress               # 压缩旧日志, 通常为 .gz 格式, nocompress(不压缩旧日志)
    delaycompress          # 延迟到下一次轮换时再压缩
    missingok              # 如果日志丢失，不报错
    notifempty             # 如果日志为空，不进行轮换
    copytruncate           # 复制日志后截断原始日志文件
    postrotate             # 在轮换后执行的命令
        systemctl reload myapp.service
    endscript
}
```

## 手动测试设置
```bash
logrotate -d /etc/logrotate.conf    # -d 参数是 debug 模式，不会实际执行轮换
logrotate -f /etc/logrotate.conf    # 手动强制执行轮换
```

## 自动运行logrotate
logrotate 通常通过 cron 或 systemd 定期执行：
- 在传统的系统中，cron 任务通常会调用 /etc/cron.daily/logrotate。
- 在现代的 systemd 中，logrotate 可能以定时任务的方式运行。
```bash
systemctl status logrotate.timer
```
