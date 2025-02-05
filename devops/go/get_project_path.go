// 获取项目根目录, 推荐使用如下方式
package main

import (
	"fmt"
	"os"
	"path/filepath"
	"runtime"
)

var ProjectRoot string

func findProjectRoot(startPath string) (string, error) {
	dir := startPath
	for {
		// 检查是否存在 go.mod 文件
		if _, err := os.Stat(filepath.Join(dir, "go.mod")); err == nil {
			return dir, nil
		}

		// 获取父目录
		parent := filepath.Dir(dir)
		fmt.Println(parent)
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
	ProjectRoot = root
}

// GetProjectRoot 添加一个导出函数来获取项目根目录
func GetProjectRoot() string {
	return ProjectRoot
}
