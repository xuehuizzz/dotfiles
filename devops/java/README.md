## <mark>编码配置规范</mark>
1. 工程依赖配置父工程（Parent / BOM 模块）导入依赖库, 子工程（Module）直接引用
2. 日志规范
   ```Java
   // 使用 @Slf4j 注解
   // 延迟拼接
   log.info("userId={} create order success", userId);
   ```
3. 热重载, 修改代码自动重启加载
   ```xml
    <!-- runtime：只在开发环境生效，不打包到生产 -->
    <!-- optional：避免传递给其他模块依赖 -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-devtools</artifactId>
      <scope>runtime</scope>
      <optional>true</optional>
    </dependency>
   ```
