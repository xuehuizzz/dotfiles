/*
  获取项目根目录, 推荐使用如下方式
  建议放在global包下, 配置全局变量使用

    // projectName/global/global.go
	package global
	var ProjectPath   string
*/ 
package global

import (
	"fmt"
	"os"
	"path/filepath"
	"runtime"
)

func findProjectRoot(startPath string) (string, error) {
	dir := startPath
	for {
		// 检查多个可能的项目标识文件
		projectFiles := []string{"go.mod", "Makefile", ".gitignore"}
		for _, file := range projectFiles {
			if _, err := os.Stat(filepath.Join(dir, file)); err == nil {
				return dir, nil
			}
		}

		// 获取父目录
		parent := filepath.Dir(dir)
		// 如果已经到达根目录，则停止
		if parent == dir {
			return "", fmt.Errorf("找不到项目根目录")
		}
		dir = parent
	}
}

func init() {
	_, currentFile, _, _ := runtime.Caller(0)
	root, err := findProjectRoot(filepath.Dir(currentFile))
	if err != nil {
		panic(err)
	}
	ProjectPath = root
}
