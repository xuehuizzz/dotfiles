# MongoDB
MongoDB 是一个用类似 JSON 的文档来存数据、结构灵活、无需固定表结构的非关系型数据库。

### docker安装
```bash
docker run -d \
  --name mongodb \
  -p 27017:27017 \
  -v /Users/xuehuizzz/db/mongodb/data:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=123456 \
  --restart always \
  mongo:8
```

### cli常用命令
```bash
mongosh -u admin -p 123456   # 进入 MongoDB shell, 无认证的话可直接mongosh
show dbs  # 查看所有数据库
use mydb  # 切换数据库, 没有的话会自动创建
db  # 查看当前数据库

show collections  # 查看集合
db.dropDatabase()  # 删除当前数据库
```
