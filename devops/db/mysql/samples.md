## 创建一张标准的数据表
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
    tuition DECIMAL(5, 2) NOT NULL DEFAULT '0' COMMENT '小数类型',
    
    -- UNIQUE KEY `idx_username` (`username`),  -- 唯一索引
    -- KEY `idx_email` (`email`)    -- 普通索引
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT '一张相对规范的表结构';
```

## 用户管理
```sql
-- 创建用户
CREATE USER 'admin'@'%' IDENTIFIED BY 'admin_pwd';

-- 修改用户密码
ALTER USER 'username'@'hostname' IDENTIFIED BY 'new_password';  -- MySQL5.7及以上版本(最推荐使用)
SET PASSWORD FOR 'username'@'hostname' = 'new_password';  -- MySQL8.0及以上版本
SET PASSWORD FOR 'username'@'hostname' = PASSWORD('new_password');  -- MySQL5.7及以下版本

-- 授予权限
GRANT ALL PRIVILEGES ON *.* TO 'username'@'host' WITH GRANT OPTION;  -- 授予用户管理员权限
    -- `WITH GRANT OPTION`表示权限传递能力, 允许该用户将自己拥有的权限授予其他用户
GRANT privilege1, privilege2 ON database_name.table_name TO 'username'@'host';  -- 授予特定权限
FLUSH PRIVILEGES;   -- 授予权限后刷新

-- 删除用户
DROP USER IF EXISTS 'username'@'hostname';
```

## 常用查询
```sql
SELECT user();  -- 当前连接用户
SELECT version();  -- 查询数据库版本
SELECT CURTIME();  -- 当前时间
SELECT CURDATE();  -- 当前日期
```
