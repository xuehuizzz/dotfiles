#  postgresql 

```sql
    -- DISTINCT ON 是 PostgreSQL 提供的一个强大的语法特性，它允许你在查询结果中按指定的列去重，并返回每组中的第一条记录。
    -- 这个功能在需要从每组数据中选出一条特定记录时非常有用
    SELECT DISTINCT ON (column1) column1, column2, column3
    FROM table_name
    ORDER BY column1, column4 DESC;

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
