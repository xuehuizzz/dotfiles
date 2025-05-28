`logrotate 是一个用于管理日志文件的工具，广泛用于自动化日志文件的轮换、压缩和删除，以确保日志不会占用过多的磁盘空间`
## Logrotate 的主要功能：
  1. 日志轮换：将旧日志文件重命名或归档（例如，将 logfile 重命名为 logfile.1）。
  2. 日志压缩：通过 gzip、bzip2 等工具压缩旧日志文件。
  3. 日志删除：在设定的时间范围内自动删除过期日志文件。
  4. 日志邮件发送：将日志通过邮件发送给管理员。
  5. 自定义脚本：在日志轮换前或后运行自定义命令，如重启服务。
  6. 灵活配置：支持按大小、时间间隔等规则执行轮换操作。

## 安装验证

```cmd
# 在 Linux 系统中，Logrotate 通常默认安装
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
- 全局配置文件示例:
  - ```conf
    weekly              # 日志轮换频率：每周
    rotate 4            # 保留最近的 4 个旧日志
    create              # 轮换后创建新日志文件
    compress            # 压缩旧日志
    dateext             # 使用类似 log.2025-05-28 而不是 log.1 的格式作为备份后缀
    include /etc/logrotate.d  # 包含其他配置文件目录
    ```
- 单独应用配置示例:
  - ```conf
    /var/log/myapp/*.log {
        daily                  # 每天轮换, weekly,monthly, yearly
        rotate 7               # 保留 7 个轮换文件
        compress               # 压缩旧日志, 通常为 .gz 格式, nocompress(不压缩旧日志)
        delaycompress          # 延迟一轮压缩(需配合 compress 使用)
        missingok              # 如果日志丢失，不报错
        notifempty             # 如果日志文件是空的, 则不进行轮转
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
systemctl status logrotate.timer  # 查看定时器状态
systemctl enable --now logrotate.timer  # 启用并立即运行定时器
```
