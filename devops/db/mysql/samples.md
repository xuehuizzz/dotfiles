## MySQL8 创建一张标准的数据表
```sql
CREATE TABLE xxx (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',  -- 自增id
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME NULL DEFAULT NULL COMMENT '删除时间(软删除)',
    -- expired_at DATETIME NULL DEFAULT NULL COMMENT '过期时间',
    created_by INT NOT NULL COMMENT '创建者ID',
    updated_by INT NOT NULL COMMENT '更新者ID',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '是否删除：0-否，1-是',
    version INT NOT NULL DEFAULT 1 COMMENT '版本号',
    remark VARCHAR(255) DEFAULT NULL COMMENT '备注',
    tuition DECIMAL(5, 2) NOT NULL DEFAULT 0 COMMENT '小数类型',
    
    -- UNIQUE KEY idx_username (username),  -- 唯一索引
    -- KEY idx_email (email),   -- 普通索引
    -- KEY idx_name_email (name, email),  -- 联合索引
    -- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE  -- 物理外键,级联删除
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT '一张相对规范的表结构';
```
> utf8mb4_0900_ai_ci 是 MySQL 8.0 中引入的一种字符集排序规则（collation），它由几个部分组成:
   - utf8mb4 : 字符集，支持完整的 Unicode 字符集，包括 emoji 表情符号和其他特殊字符（最多可存储 4 字节的 UTF-8 字符）
   - 0900 : 表示基于 Unicode 9.0.0 标准, 比旧版本的排序规则更加完善
   - ai : 代表 accent-insensitive (不区分重音), 例如 'a', 'á', 'à', 'ä' 在排序和比较时被视为相同字符
   - ci : 代表 case-insensitive (不区分大小写), 例如 'A' 和 'a' 在排序和比较时被视为相同字符

## 用户管理
```sql
-- 创建用户
CREATE USER 'admin'@'%' IDENTIFIED BY 'admin_pwd';

-- 修改用户密码
ALTER USER 'username'@'hostname' IDENTIFIED BY 'new_password';  -- MySQL5.7及以上版本(最推荐使用)
SET PASSWORD FOR 'username'@'hostname' = 'new_password';  -- MySQL8.0及以上版本
SET PASSWORD FOR 'username'@'hostname' = PASSWORD('new_password');  -- MySQL5.7及以下版本

-- 授予权限, 只授予必要权限、禁止使用 GRANT ALL
GRANT ALL PRIVILEGES ON *.* TO 'username'@'host' WITH GRANT OPTION;  -- 授予用户管理员权限
GRANT privilege1, privilege2 ON database_name.table_name TO 'username'@'host';  -- 授予特定权限
FLUSH PRIVILEGES;   -- 授予权限后刷新

-- 删除用户
DROP USER IF EXISTS 'username'@'hostname';
```
> `GRANT ALL PRIVILEGES`: 授予所有权, 等价于`GRANT ALL`, 遵循最小权限原则,禁止grant all
>
> `WITH GRANT OPTION` 表示该用户还能将**自己拥有的权限**授予给其他用户


## 常用查询
```sql
SELECT user();  -- 当前连接用户
SELECT version();  -- 查询数据库版本
SELECT CURTIME();  -- 当前时间
SELECT CURDATE();  -- 当前日期
```

## <mark>实用触发器推荐</mark><sub>只能对单表配置</sub>
```sql
-- 修改数据时自动更新时间戳(没有显式修改updated_at时才会触发), 以显式声明的优先
-- 任何方式更新都会生效(直接执行SQL语句、通过orm框架、通过数据库管理工具修改)
DELIMITER //
CREATE TRIGGER before_update_timestamp
BEFORE UPDATE ON students
FOR EACH ROW
BEGIN
    IF NEW.updated_at = OLD.updated_at THEN 
        SET NEW.updated_at = CURRENT_TIMESTAMP;
    END IF;
END;//
DELIMITER ;

-- 级联删除, 无需外键约束
DELIMITER //
CREATE TRIGGER cascade_delete_order
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    DELETE FROM order_details WHERE order_id = OLD.id;
END;//
DELIMITER ;
```

## <mark>权限释义</mark>
| 权限名称                              | 权限作用描述                       | 适用范围 / 备注 |
| --------------------------------- | ---------------------------- | --------- |
| **CLONE\_ADMIN**                  | 管理克隆操作，复制数据库实例数据             | 服务器管理权限   |
| **CONNECTION\_ADMIN**             | 管理客户端连接（查看、终止连接）             | 服务器管理权限   |
| **CREATE USER**                   | 创建、修改、删除MySQL用户账户            | 用户管理权限    |
| **EXECUTE**                       | 执行存储过程和函数                    | 数据库操作权限   |
| **FILE**                          | 读写服务器文件系统（如LOAD DATA INFILE） | 文件操作权限    |
| **GROUP\_REPLICATION\_ADMIN**     | 管理组复制功能                      | 复制管理权限    |
| **PERSIST\_RO\_VARIABLES\_ADMIN** | 管理持久化只读系统变量                  | 系统变量管理    |
| **PROCESS**                       | 查看正在运行的线程和状态                 | 服务器管理权限   |
| **RELOAD**                        | 刷新日志、权限缓存等操作                 | 服务器管理权限   |
| **REPLICATION CLIENT**            | 查询复制状态                       | 复制权限      |
| **REPLICATION SLAVE**             | 从服务器读取二进制日志                  | 复制权限      |
| **REPLICATION\_APPLIER**          | 应用复制事件                       | 复制权限      |
| **REPLICATION\_SLAVE\_ADMIN**     | 复制从服务器管理权限                   | 复制权限      |
| **ROLE\_ADMIN**                   | 管理角色（创建、赋予、撤销）               | 角色管理      |
| **SELECT**                        | 读取数据                         | 数据库操作权限   |
| **SHUTDOWN**                      | 关闭MySQL服务器                   | 服务器管理权限   |
| **SYSTEM\_VARIABLES\_ADMIN**      | 修改系统变量                       | 系统变量管理    |
| **DELETE**                        | 删除表中的数据                      | 数据库操作权限   |
| **INSERT**                        | 插入数据                         | 数据库操作权限   |
| **UPDATE**                        | 更新数据                         | 数据库操作权限   |
| **ALTER**                         | 修改表结构（增加列、修改类型等）             | 数据库结构操作权限 |
| **ALTER ROUTINE**                 | 修改存储过程和函数                    | 数据库操作权限   |
| **CREATE**                        | 创建数据库对象（表、数据库等）              | 数据库操作权限   |
| **CREATE ROUTINE**                | 创建存储过程和函数                    | 数据库操作权限   |
| **CREATE TEMPORARY TABLES**       | 创建临时表                        | 数据库操作权限   |
| **CREATE VIEW**                   | 创建视图                         | 数据库操作权限   |
| **DROP**                          | 删除数据库对象（表、视图等）               | 数据库操作权限   |
| **EVENT**                         | 创建、修改、删除事件（定时任务）             | 事件调度权限    |
| **INDEX**                         | 创建和删除索引                      | 数据库性能优化权限 |
| **LOCK TABLES**                   | 锁定表，防止其他会话访问                 | 数据库操作权限   |
| **REFERENCES**                    | 创建外键约束                       | 数据库结构操作权限 |
| **SHOW VIEW**                     | 查看视图定义                       | 数据库操作权限   |
| **TRIGGER**                       | 创建和删除触发器                     | 数据库操作权限   |
