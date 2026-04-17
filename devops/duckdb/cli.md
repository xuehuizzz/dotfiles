# 常用操作
1. 基础命令
   ```bash
   duckdb  # 默认进入memory数据库, 退出则数据清零
   duckdb xxx.db  # 进入指定数据库, 不存在的话则直接创建
   .maxrows num  # 定义显示最大行数
   .exit  # Ctrl+D 退出
   ```
2. 安装插件(以Excel为例)
   ```bash
   SELECT * FROM duckdb_extensions();  -- 查看可用的扩展(包括已安装和可安装的)
   # 自动安装插件, 1.5+版本后会自动 INSTALL和LOAD
   SELECT * FROM read_xlsx('data.xlsx', sheet='sheet_name');
   
   # 手动安装(一般在内网环境下)
   INSTALL excel;  # 安装excel插件
   -- LOAD excel;  # 加载Excel插件
   ```
3. 查询csv文件
   ```sql
   -- 自动识别格式
   SELECT * FROM read_csv('data.csv', delim=',', header=true);
   
   -- 无表头文件, 自动把列命名为: column0, column1, column2, ...
   SELECT COUNT(*) FROM read_csv('data.csv', header=False) where column0 LIKE '%xxx%';  
   -- read_csv('https://example.com/data.csv')
   ```
   > 查询默认返回头尾几行, 在查询前配置`.maxrows num`可显示完整行记录
4. 查询json文件
   ```sql
   -- 只要文件内容是标准JSON格式, 文件扩展名don't care
   select * from read_json("file");
   ```
5. 建视图, 反复查询CSV
   ```sql
   CREATE VIEW mycsv AS SELECT * FROM read_csv_auto('data.csv');
   SELECT COUNT(*) FROM mycsv;
   SELECT col1, col2 FROM mycsv WHERE col3 > 100;
   ```
6. 导入CSV到duckdb表(持久化)
   ```sql
   CREATE TABLE mytable AS SELECT * FROM read_csv_auto('data.csv');
   SELECT * FROM mytable LIMIT 10;
   ```
7. 导出查询结果
   ```sql
   -- 原数据格式任意
   COPY (SELECT * FROM mytable WHERE age > 30) 
   TO 'output.csv' (HEADER, DELIMITER ',');  -- 导出为csv, 显式指定 (FORMAT csv, DELIMITER ',', HEADER)
   TO 'output.json' (FORMAT JSON);  -- 导出为json
   ```
8. 显示/切换当前工作目录
   ```bash
   .shell ls  -- 列出当前目录
   .shell pwd          -- 显示当前目录  
   .cd /path     -- 切换目录（仅对子 shell 有效）  
   ```
9. 其他常用命令
   ```sql
   SHOW TABLES;  -- 查看数据库里的表
   DROP TABLE mytable;  -- 删除表
   DESCRIBE mytable;   -- 查看表结构
   ```
