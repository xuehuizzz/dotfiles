# [社区扩展列表](https://duckdb.org.cn/community_extensions/list_of_extensions)
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
   
   -- 无表头文件, 自动把列命名为: column0, column1, column2, ...  按列数补零对齐
   -- 防止被 shell 或编辑器吞掉, 显式指定  delim=E'xxx'
   SELECT COUNT(column0) FROM read_csv('data.csv', header=False, delim=E'\x0f') where column00 LIKE '%xxx%';  
   -- read_csv('https://example.com/data.csv')


   -- 读取es, 安装并加载扩展(只需安装一次)
   INSTALL elasticsearch FROM community;
   LOAD elasticsearch;
   
   -- 创建 ES 连接(SECRET)
   CREATE SECRET es_secret (
       TYPE elasticsearch,
       HOST 'localhost',
       PORT 9200,
       USER 'elastic',
       PASSWORD 'your_password'
   );
   
   -- 查询 ES 索引
   SELECT * FROM elastic_search('my_index');
   ```
   > DuckDB 在生成默认列名时，会根据总列数决定补零的位数，让所有列名宽度一致（这样字典序排序时也能保持自然顺序）：
     - 列数 ≤ 9：column0, column1, ..., column8
     - 列数 10~99：column00, column01, ..., column98, column99
     - 列数 100~999：column000, column001, ...


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
