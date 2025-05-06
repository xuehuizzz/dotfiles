-- 创建数据表
CREATE TABLE xxx (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',  -- 自增id
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at TIMESTAMP NULL DEFAULT NULL COMMENT '删除时间(软删除)',
    -- expired_at TIMESTAMP NULL DEFAULT NULL COMMENT '过期时间',
    created_by BIGINT NOT NULL COMMENT '创建者ID',
    updated_by BIGINT NOT NULL COMMENT '更新者ID',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    is_deleted TINYINT NOT NULL DEFAULT 0 COMMENT '是否删除：0-否，1-是',
    version INT NOT NULL DEFAULT 1 COMMENT '版本号',
    remark VARCHAR(255) DEFAULT NULL COMMENT '备注',
    
    -- UNIQUE KEY `idx_username` (`username`),  -- 唯一索引
    -- KEY `idx_email` (`email`)    -- 普通索引
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- 创建用户





SELECT user();  -- 当前连接用户
SELECT version();  -- 查询数据库版本
SELECT CURTIME();  -- 当前时间
SELECT CURDATE();  -- 当前日期
