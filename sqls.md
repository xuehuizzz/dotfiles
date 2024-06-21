#  postgresql 

```sql
    -- DISTINCT ON 是 PostgreSQL 提供的一个强大的语法特性，它允许你在查询结果中按指定的列去重，并返回每组中的第一条记录。
    -- 这个功能在需要从每组数据中选出一条特定记录时非常有用
    SELECT DISTINCT ON (column1) column1, column2, column3
    FROM table_name
    ORDER BY column1, column4 DESC;
```
