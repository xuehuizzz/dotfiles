## 安装go
```bash
# 官方下载地址: https://go.dev/dl 

go version  # 验证安装

# Linux/Mac  配置环境变量
export GOPATH=$HOME/go   # Go 工作空间
export GOROOT=/usr/local/go  # Go 安装路径
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GOSUMDB="sum.golang.org"
export GOPROXY=https://goproxy.cn,direct
```

## 项目结构建议
```plaintext
myproject/
├── cmd/                # 主程序入口
│   └── main.go
├── internal/           # 私有应用程序代码
├── pkg/               # 可以被外部应用程序使用的库代码
├── api/               # API 协议定义
├── configs/           # 配置文件
├── docs/              # 文档
├── deploy               # 部署配置文件
│   ├── Dockerfile
│   └── docker-compose.yaml
├── test/              # 测试文件
└── go.mod             # 依赖管理文件
```
## go版本管理工具`gvm`
```bash
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source ~/.zshrc

# 使用
gvm install go1.17.8
gvm use go1.17.8
```

## <font color=red>**项目基本配置**</font>
```bash
同一个包（package）下的所有文件可以直接互相访问其中的函数、变量、类型等，不需要 import.
go mod init myproject  # 新建go.mod文件, 这个文件是Go 模块管理系统的核心文件(只需在项目初始化时执行一次)
# go mod tidy  # 推荐使用, 下载并整理依赖(会自动移除未使用的依赖)

# 配置国内代理加速下载
go env -w GOPROXY=https://goproxy.cn,direct
go env -w GOSUMDB="sum.golang.google.cn"

# 安装常用开发工具
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/air-verse/air@latest  # 项目热重载, 方便调试接口
go install golang.org/x/tools/cmd/goimports@latest    # 自动合并和排序 import 语句
    # goimports -w xxx.go  # 单个文件
    # goimports -w .  # 当前目录下所有go文件
go install github.com/daixiang0/gci@latest    # 另一个排序合并 import 语句的模块
    # gci write -s standard -s blank -s default -s blank -s "prefix(projectName)" -s blank xxx.go   # 单个文件
    # gci write -s standard -s blank -s default -s blank -s "prefix(projectName)" .         # 当前目录下

# 下载项目依赖
go get xxx  # 例如: go get github.com/gin-gonic/gin

# 运行go文件
go run main.go  # 这里假设 main.go 为项目入口文件
```

## 配置参数分离
```golang
// go get github.com/spf13/viper  go语言管理配置文件的依赖
package initiallize

import (
    "github.com/spf13/viper"
    "kubeimooc/global"
)

func Viper() {
    v := viper.New()
    v.SetConfigName("config.yml")
    v.SetConfigType("yml")
    v.AddConfigPath(".") // 配置指定路径下搜索配置文件, .表示当前路径
    err := v.ReadInConfig()
    if err != nil {
        panic(err.Error())
    }
    err = v.Unmarshal(&global.CONF)
    if err != nil {
        panic(err.Error())
    }
}
```
## <font color=red>**集成k8s**</font>
```bash
go get k8s.io/client-go  
```
## 项目热重载
```bash
# 主要用于开发环境
# 安装
go install github.com/air-verse/air@latest

# 使用
air init  # 在项目根目录创建配置文件 .air.toml
air  # 然后直接运行, 当你修改代码时，Air 会自动检测变化并重新编译运行，不需要手动重启服务器, 也不需要执行 go run main.go来启动项目了
```
## 使用 .env 文件
```go
// go get github.com/joho/godotenv

import (
    "fmt"
    "log"
    "os"
    "github.com/joho/godotenv"
)

func main() {
    // 加载 .env 文件
    err := godotenv.Load()
    if err != nil {
        log.Fatal("Error loading .env file")
    }

    // 使用 os.Getenv 获取环境变量
    dbHost := os.Getenv("DB_HOST")
    dbUser := os.Getenv("DB_USER")
    apiKey := os.Getenv("API_KEY")

    fmt.Printf("DB Host: %s\n", dbHost)
    fmt.Printf("DB User: %s\n", dbUser)
    fmt.Printf("API Key: %s\n", apiKey)
}
```
