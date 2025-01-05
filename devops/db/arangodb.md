## 插入数据
```aql
// 单条数据插入
INSERT { name: "Alice", age: 30, city: "New York" } INTO users

// 使用单个 AQL 查询插入多个文档
FOR doc IN [
  { name: "Alice", age: 30, city: "New York" },
  { name: "Bob", age: 25, city: "Los Angeles" },
  { name: "Charlie", age: 35, city: "Chicago" }
]
INSERT doc INTO users
```

## 修改数据
```aql
// 单条数据修改
UPDATE { _key: "12345", age: 31 } IN users

// 使用单个AQL修改多个文档
FOR doc IN [
  { _key: "12345", age: 31 },
  { _key: "67890", age: 26 },
  { _key: "11223", age: 36 }
]
UPDATE doc._key WITH { age: doc.age } IN users

// 使用过滤条件修改
FOR u IN users
  FILTER u.city == "New York"
  UPDATE u WITH { age: u.age + 1 } IN users     # 所有 city 为 "New York" 的用户的 age 增加 1
```

## 查询数据
```aql
// 查询用户表中city="New York"的记录并按照age顺序查询
FOR doc IN users
   FILTER doc.city == "New York"
   // CONTAINS(doc.name, "A")    name包含`A`, 文档区分大小写
   // STARTS_WITH(doc.name, "A")   name以`A`开头的
   // LIKE(doc.name, "%A")  name以`A`结尾
   // REGEX(doc.name, "A$")  支持正则表达式, name以`A`结尾,  A$ 表示以 "A" 结尾的字符串
   SORT doc.age ASC
   LIMIT 0, 2   // 分页查询, 每页2条数据, 从第0条数据开始
   RETURN doc

// 查询集合有多少行记录
return length(users)

// 分组查询, 统计集合users中每个城市有多少个
FOR doc IN users
   COLLECT city = doc.city WITH COUNT INTO count
   RETURN { city, count }
```

## 删除数据
```aql
// 单条记录删除
REMOVE { _key: "123456" } IN users   // 删除集合users中key等于123456的文档

// 删除符合条件的文档
FOR doc IN users
  FILTER doc.age > 30
  REMOVE doc IN users

// 清空集合数据, 或者使用web ui的truncate
FOR doc IN users
  REMOVE doc IN users

```
