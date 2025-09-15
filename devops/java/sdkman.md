# SDKMAN 是一个专门为 `管理多个软件开发工具版本` 而设计的工具
```bash
# 安装
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"

# 安装JDK
sdk list java    # 查看可用版本
sdk install java  # 安装sdkman推荐的默认版本
sdk install java 21.0.8-jbr  # 安装指定版本
sdk default java 21.0.8-jbr  # 设为默认

# 安装Maven / Gradle (按需)
sdk install maven
sdk install gradle

# 验证
java -version
javac -version
mvn -v
gradle -v
```
