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
db.dropDatabase()  # 删除当前数据库
db.stats()  # 查看当前数据库状态

show collections  # 查看集合
db.createCollection('xxx')  # 创建集合
db.xxx.drop()  # 删除集合
db.xxx.renameCollection("new_xxx")  # 重命名集合


```

### 新增数据
```javascript
// 插入单条文档
db.users.insertOne({ name: "Tom", age: 25 })

// 插入多条文档
db.users.insertMany([
  { name: "Jerry", age: 30 },
  { name: "Spike", age: 35 }
])
```

### 查询数据
```javascript
// 查询所有文档
db.users.find()

// 格式化输出
db.users.find().pretty()

// 条件查询
db.users.find({ age: 25 })

// 比较运算符：$gt $gte $lt $lte $ne
db.users.find({ age: { $gt: 25 } })

// 逻辑运算符：$and $or $not
db.users.find({ $or: [{ age: 25 }, { name: "Spike" }] })

// 查询单条
db.users.findOne({ name: "Tom" })

// 投影（只返回指定字段，1 显示 0 隐藏）
db.users.find({}, { name: 1, _id: 0 })

// 排序（1 升序，-1 降序）
db.users.find().sort({ age: -1 })

// 分页：跳过 + 限制
db.users.find().skip(10).limit(5)

// 统计数量
db.users.countDocuments({ age: { $gt: 25 } })

// 去重
db.users.distinct("age")
```
