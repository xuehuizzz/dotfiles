# <mark>SonarQube: 开源的代码质量管理平台, 主要用于持续代码质量检测</mark>
## 安装并运行 SonarQube 服务器
```bash
# 使用 Docker 运行 SonarQube(推荐方式), 社区版, 个人使用
docker run -d --name sonarqube -p 9000:9000 sonarqube:9.9-community  # lts的稳定版本
```
## 安装 SonarScanner cli工具
```bash
brew install sonar-scanner  # macOS
sudo apt-get install sonar-scanner  # Ubuntu/Debian
sudo yum install sonar-scanner  # CentOS/RHEL
```
## 在项目根目录创建 sonar-project.properties 配置文件
```properties
# 项目的唯一标识符，在 SonarQube 服务器上用于区分不同项目
sonar.projectKey=projectName
# 项目在 SonarQube UI 界面上显示的名称, 可以使用更友好的可读名称
sonar.projectName=projectName
# 项目的版本号, 用于追踪不同版本的代码质量变化
sonar.projectVersion=1.0
# 指定要分析的源代码目录, . 表示当前目录下的所有源代码
sonar.sources=.
# 源代码文件的字符编码, 确保 SonarQube 正确读取源文件
sonar.sourceEncoding=UTF-8
# Java 编译后的字节码文件位置, SonarQube 需要这些文件来进行更准确的分析
sonar.java.binaries=target/classes
# SonarQube 服务器的地址
sonar.host.url=http://localhost:9000
# 指定要分析的代码分支(社区版不支持指定),不指定分支则默认扫描当前分支的代码, 也就是说在扫描代码前, 先git checkout branchName上
# sonar.branch.name=branchName
# SonarQube 的认证令牌, 出于安全考虑，建议通过命令行参数传入而不是直接写在配置文件中
sonar.login=your-token-here
```
## 获取token
```bash
https://localhost:9000  # 默认user/pwd都是: admin
# 点击头像 --> My Account --> Security --> Generate Token
``
## 执行代码分析
```bash
# 分析完成后，可以在 SonarQube 的 Web 界面上看到结果, 所有的分析结果都会被存储在默认的主干（main）中
sonar-scanner  #  -X 启用调试模式
# sonar-scanner -Dsonar.login=your-token-here     
```
