## duckdb
DuckDB 经常被叫作“嵌入式版的OLAP数据库”，它的定位有点像 SQLite 的“分析型表哥”：SQLite 专攻 OLTP（事务处理、小型应用），DuckDB 专攻 OLAP（分析型查询、大数据聚合）。

核心特点可以用一句话概括：**本地文件、单个进程、无服务器、超快的分析查询**

1. 基本定位
- 嵌入式：它不是一个要单独启动的数据库服务，运行时直接嵌入到你的应用或脚本中。
- 列式存储：数据在磁盘上是按列存储的，适合做大规模扫描、聚合、分析。
- 跨平台：支持 Linux、macOS、Windows，可以嵌入 C++、Python、R、Java、Node.js 等。
- 免依赖：一个单独的库文件就能跑，不需要复杂部署。

2. 为什么它快
- 列式存储 + 向量化执行引擎，一次处理一批数据（SIMD加速），对分析型 SQL 特别高效。
- 支持压缩，减少 I/O 量。
- 优化了 JOIN、GROUP BY 等分析常用操作。

3. 数据源灵活
- DuckDB 可以直接查询很多格式，而不用导入到专有数据库表里：
- CSV、Parquet、JSON、Excel（通过插件）
- S3 对象存储（直接查询远程文件）
- 甚至 Pandas DataFrame、Arrow Table

4. 常见使用场景
- 数据科学：本地快速分析百万到亿级数据行
- ETL（Extract-Transform-Load）中间处理
- 嵌入到应用中做数据分析功能
- 替代 Pandas 做更大数据量的处理
- 作为 SQLite 的分析型补充

### <mark>安装</mark>
```bash
brew install duckdb
pip install duckdb
curl https://install.duckdb.org | sh

# 插件手动下载地址
http://extensions.duckdb.org/v1.4.1/linux_amd64/excel.duckdb_extension.gz
```
