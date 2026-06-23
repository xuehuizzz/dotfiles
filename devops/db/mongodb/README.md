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

### 修改数据
```javascript
// 更新单条（$set 修改字段）
db.users.updateOne(
  { name: "Tom" },
  { $set: { age: 26 } }
)

// 更新多条
db.users.updateMany(
  { age: { $lt: 30 } },
  { $set: { status: "young" } }
)

// 替换整个文档
db.users.replaceOne(
  { name: "Tom" },
  { name: "Tom", age: 27, city: "NY" }
)

// 自增字段
db.users.updateOne({ name: "Tom" }, { $inc: { age: 1 } })

// upsert（不存在则插入）
db.users.updateOne(
  { name: "Lucy" },
  { $set: { age: 20 } },
  { upsert: true }
)
```

### 删除数据
```javascript
// 删除单条
db.users.deleteOne({ name: "Tom" })

// 删除多条
db.users.deleteMany({ age: { $gt: 30 } })

// 删除所有文档
db.users.deleteMany({})
```

### 索引
```javascript
// 创建索引（1 升序，-1 降序）
db.users.createIndex({ name: 1 })

// 创建唯一索引
db.users.createIndex({ email: 1 }, { unique: true })

// 查看索引
db.users.getIndexes()

// 删除索引
db.users.dropIndex({ name: 1 })
```

### 用户与权限
```javascript
// 创建用户
db.createUser({
  user: "admin",
  pwd: "password",
  roles: [{ role: "readWrite", db: "mydb" }]
})

// 查看用户
show users

// 删除用户
db.dropUser("admin")
```
