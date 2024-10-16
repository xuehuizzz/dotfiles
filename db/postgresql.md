### install for mac

```bash
brew install postgresql    # 安装
brew services start postgresql   # 启动服务
createdb db_name  # 新建数据库
psql db_name   # 连接到已存在的数据库
CREATE USER myuser WITH PASSWORD 'mypassword';    # 连接到数据库后创建用户
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;   # 为新用户授予访问特定数据库的权限
```

### 使用

```sql
SELECT * FROM your_table WHERE name !~ 'xx|xxx|xxxx';   # 查询name不包含多个条件

-- CTE
WITH cte AS (
  SELECT column_name FROM table_name WHERE condition
)
SELECT * FROM cte WHERE other_condition;
    
-- DISTINCT ON 是 PostgreSQL 提供的一个强大的语法特性，它允许你在查询结果中按指定的列去重，并返回每组中的第一条记录。
-- 这个功能在需要从每组数据中选出一条特定记录时非常有用
SELECT DISTINCT ON (column1) column1, column2, column3
FROM table_name
ORDER BY column1, column4 DESC;
-- 通常是替代 DISTINCT ON() 的最佳选择，因为它们提供了更多的灵活性和更好的性能
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY column1 ORDER BY column2) as rn
    FROM your_table
) subquery
WHERE rn = 1;


-- 条件表达式
SELECT COALESCE(NULL, 'default', 'fallback');  -- 返回第一个非 NULL 的值
SELECT NULLIF(10, 10);  -- 如果两个参数相等，返回 NULL，否则返回第一个参数

-- 数据类型转换
SELECT CAST('123' AS INTEGER);  -- 将一种数据类型转换为另一种数据类型
SELECT '123'::INTEGER;  -- 类型转化的快捷方式

-- 字符串函数
SELECT CONCAT('Hello', ' ', 'World');   -- 将多个字符串拼接在一起, str||str1 也可
SELECT LENGTH('Hello World');    -- 返回字符串长度
SELECT SPLIT_PART('name(18)', '(', 1); -- 拆分字符串, name

-- 日期和时间函数
SELECT AGE(NOW(), '2000-01-01');  -- 返回两个日期之间的差异

-- 窗口函数
SELECT column_name, ROW_NUMBER() OVER (ORDER BY column_name) FROM table_name;   -- 为结果集的行分配唯一的连续编号
SELECT column_name, RANK() OVER (ORDER BY column_name) FROM table_name; -- 为结果集的行分配排名，允许并列排名


```
