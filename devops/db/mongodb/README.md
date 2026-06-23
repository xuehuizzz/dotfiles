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
