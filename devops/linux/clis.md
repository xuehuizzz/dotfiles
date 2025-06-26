# rsync
```bash
# 支持远程增量大文件同步, 基本语法如下:
rsync [options] source user@remote_host:/path/to/destination
rsync [options] user@remote_host:/path/to/source /local/destination
```
> rsync -avz ./project/ user@192.168.1.100:/home/user/backup/
- a：归档模式，保持文件权限、符号链接等
- v：显示详细信息
- z：压缩数据（提高网络传输效率）
