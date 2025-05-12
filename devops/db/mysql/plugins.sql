-- 查看已安装插件
SHOW PLUGINS;

-- 安装插件
INSTALL PLUGIN plugin_name SONAME 'plugin_library.so';

-- 卸载插件
UNINSTALL PLUGIN plugin_name;

-- 查看插件库路径
SHOW VARIABLES LIKE 'plugin_dir';


-- 推荐安装插件如下:
INSTALL PLUGIN validate_password SONAME 'validate_password.so';   -- 验证MySQL密码
INSTALL PLUGIN rpl_semi_sync_source SONAME 'semisync_source.so';  -- 半同步复制插件
INSTALL PLUGIN group_replication SONAME 'group_replication.so';   -- MGR组复制插件
INSTALL PLUGIN clone SONAME 'mysql_clone.so';                     -- 克隆MySQL实例
