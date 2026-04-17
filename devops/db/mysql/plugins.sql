-- ============================================================
-- 查看 / 管理插件
-- ============================================================
SHOW PLUGINS;
SHOW VARIABLES LIKE 'plugin_dir';  -- 查看插件库路径

-- INSTALL PLUGIN plugin_name SONAME 'plugin_library.so';
-- UNINSTALL PLUGIN plugin_name;


-- 推荐安装插件如下:
INSTALL PLUGIN group_replication SONAME 'group_replication.so';   -- MGR组复制插件
INSTALL PLUGIN clone SONAME 'mysql_clone.so';                     -- 克隆MySQL实例



-- 密码验证(推荐以组件方式安装)
INSTALL COMPONENT 'file://component_validate_password';  -- 以组件方式安装
SELECT * FROM mysql.component;  -- 查看组件
UNINSTALL COMPONENT 'file://component_validate_password';   -- 写在组件


-- 半同步复制插件
INSTALL PLUGIN rpl_semi_sync_source SONAME 'semisync_source.so';    -- Source 端
INSTALL PLUGIN rpl_semi_sync_replica SONAME 'semisync_replica.so';   -- Replica 端


-- 连接控制：防暴力破解，登录连续失败后自动延迟响应
INSTALL PLUGIN connection_control SONAME 'connection_control.so';
INSTALL PLUGIN connection_control_failed_login_attempts SONAME 'connection_control.so';

-- 密钥环（TDE 透明数据加密，按需）
-- INSTALL PLUGIN keyring_file SONAME 'keyring_file.so';
