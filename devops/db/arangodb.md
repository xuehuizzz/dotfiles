## AQL注意事项
1. 关键字不区分大小写, 但建议统一大写, 变量、集合名：小写或驼峰风格（如 userData，myCollection）
2. 单行注释使用 `//`, 多行注释使用 `/* */`
3. 条件过滤: 使用 FILTER 时，条件应尽可能具体，以利用索引, 避免在 FILTER 中使用函数操作字段（如 FILTER UPPER(doc.name) == 'JOHN'），因为会导致索引失效
4. 字段名中包含特殊字符、空格或以数字开头时，需要用反引号（`）括起来

## 集合中文档注意事项
1. arangodb文档的默认字段
   - `_id`
     - 类型: 字符串
     - 说明: 文档的全局唯一标识符，由集合名称和文档的 `_key` 组合而成，格式为：`<collection_name>/<document_key>`
     - 示例: `users/12345`
   - `_key`
     - 类型: 字符串
     - 说明: 文档的主键，唯一标识集合中的文档。用户可以手动指定 `_key`，如果未指定，系统会自动生成一个唯一值(**16个字符的字符串**), 创建集合的时候也可以设置`_key`为自增
     - 生成规则: 如果由系统生成，默认是一个基于 Base64 URL 的字符串，最大长度为 254 字节
   - `_rev`
     - 类型: 字符串
     - 说明: 文档的修订版本，用于跟踪文档的更改。每次文档被修改时，`_rev` 的值会更新
     - 示例：`_rev` 值通常是一个短字符串，例如 1234567890
   - (边集合特有）`_from` 和 `_to`
     - 类型: 字符串
     - 说明：对于边集合（Edge Collection），_from 和 _to 字段指定了边的起点和终点
     - 格式：<collection_name>/<document_key>，类似于 _id 的格式
     - 示例：_from: "users/12345", _to: "products/67890"
2. 字段名称的合法字符
   - 用 驼峰命名法（如 userName）或 下划线命名法（如 user_name），但需保持一致性
   - 字段名称是区分大小写的。例如，`userName` 和 `username` 是两个不同的字段
   - 允许的字符: 字段名称可以包含字母、数字、下划线 (`_`) 和其他 Unicode 字符
   - 不推荐的字符: 避免使用特殊字符（如 `$`, `.` 等）和空格，因为可能会导致解析或查询的问题
   - 首字符：字段名称可以以字母或下划线开头，但避免以数字开头，以防产生歧义


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
   // concat(doc.name,'-', doc.age)  字符串拼接用concat
   SORT doc.age ASC
   LIMIT 0, 2   // 分页查询, 每页2条数据, 从第0条数据开始
   RETURN doc

// 查询集合有多少行记录
return length(users)

// 分组查询, 统计集合users中每个城市有多少个
FOR doc IN users
   COLLECT city = doc.city WITH COUNT INTO count
   RETURN { city, count }

// 连表查询
FOR user IN Users
    FOR order IN Orders
        FILTER user._key == order.userKey
        RETURN { user, order }
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
