# SDKMAN 是一个专门为 `管理多个软件开发工具版本` 而设计的工具
```bash
# 安装
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# 安装JDK
sdk list java  # 查看可用版本 sdk list maven
sdk install java  # 安装sdkman推荐的默认版本
sdk install java 21.0.8-jbr  # 安装指定版本
sdk default java 21.0.8-jbr  # 设为默认

# 卸载指定版本jdk
sdk uninstall java 21.0.8-jbr

# 安装Maven / Gradle (按需)
sdk install maven
sdk install gradle

# 查看当前正在使用的版本
sdk current

# 切换Java版本
sdk use java x.x.x
sdk default java x.x.x
sdk current 

# 验证
java -version
javac -version
mvn -v
gradle -v

```
