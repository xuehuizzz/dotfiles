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


```bash
curl -s --head www.baidu.com | head -n 1    # 检测网站是否可访问, 200或301表示可以访问

scp xxx.file user@ip:path  # 推送文件到远程
scp user@ip:file path  # 获取文件到本地

# 拆分文件 
split -b 100M large_file.txt part_    # 按文件大小
split -l 10000 large_file.txt part_   # 按行数
# 合并
cat part_* > merged_file.txt

# 清空文件, 同时保留句柄
cat /dev/null > file
```
