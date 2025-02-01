## 安装go
```bash
# 官方下载地址: https://go.dev/dl 

go version  # 验证安装

# Linux/Mac  配置环境变量
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
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
├── test/              # 测试文件
└── go.mod             # 依赖管理文件
```

## <font color=red>**创建一个简单的项目**</font>
1. 新建项目
    ```bash
    mkdir myproject
    cd myproject
    ```
2. 初始化
    ```bash
    go mod init myproject  # 新建go.mod文件, 这个文件是Go 模块管理系统的核心文件(只需在项目初始化时执行一次)
    # go mod tidy  # 推荐使用, 下载并整理依赖(会自动移除未使用的依赖)
    
    # 配置国内代理加速下载
    go env -w GOPROXY=https://goproxy.cn,direct
    go env -w GOSUMDB="sum.golang.google.cn"
    ```
3. 安装常用开发工具
    ```bash
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    
    # 自动合并和排序 import 语句
    go install golang.org/x/tools/cmd/goimports@latest   
        # goimports -w your_file.go  # 单个文件
        # goimports -w .  # 当前目录下所以go文件
    ```
4. 下载项目依赖
    ```bash
    // 使用 go get 下载项目依赖
    go get github.com/gin-gonic/gin  # 下载gin框架(假设项目框架为gin)
    ```
5. 配置参数分离
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
6. 运行项目
    ```bash
    go run cmd/main.go   # 假设项目入口文件为cmd/main.go
    ```
## <font color=red>**集成k8s**</font>
    ```bash
    go get k8s.io/client-go  
    ```

