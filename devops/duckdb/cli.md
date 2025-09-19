# 常用操作
1. 启动CLI
   ```bash
   duckdb
   ```
2. 安装插件(以Excel为例)
   ```bash
   INSTALL excel;  # 安装excel插件
   LOAD excel;  # 加载Excel插件

   # 读取Excel, 不指定sheet的话, 默认读取第一个sheet页
   select * from read_xlsx('data.xlsx', sheet='sheet_name');
   ```
3. 查询csv文件
   ```sql
   -- 自动识别格式
   SELECT * FROM read_csv_auto('data.csv') WHERE xxx=xxx;

   -- 手动指定分隔符和表头
   SELECT * FROM read_csv('data.csv', delim=',', header=true);
   ```
4. 建视图, 反复查询CSV
   ```sql
   CREATE VIEW mycsv AS SELECT * FROM read_csv_auto('data.csv');
   SELECT COUNT(*) FROM mycsv;
   SELECT col1, col2 FROM mycsv WHERE col3 > 100;
   ```
5. 导入CSV到duckdb表(持久化)
   ```sql
   CREATE TABLE mytable AS SELECT * FROM read_csv_auto('data.csv');
   SELECT * FROM mytable LIMIT 10;
   ```
6. 导出查询结果为CSV
   ```sql
   COPY (SELECT * FROM mytable WHERE age > 30) 
   TO 'output.csv' (HEADER, DELIMITER ',');
   ```
7. 显示/切换当前工作目录
   ```bash
   .shell pwd          -- 显示当前目录  
   .cd /path     -- 切换目录（仅对子 shell 有效）  
   ```
8. 其他常用命令
   ```sql
   SHOW TABLES;  -- 查看数据库里的表
   DROP TABLE mytable;  -- 删除表
   DESCRIBE mytable;   -- 查看表结构
   ```
9. 退出CLI
   ```bash
    .exit  # Ctrl+D
   ```
