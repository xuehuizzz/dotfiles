package main

import (
	"fmt"
	"github.com/sirupsen/logrus"
	"io"
	"os"
	"path/filepath"
)

// CustomFormatter 自定义格式化器
type CustomFormatter struct {
	TimestampFormat string
}

func (f *CustomFormatter) Format(entry *logrus.Entry) ([]byte, error) {
	// 获取调用信息
	var file, function string
	if entry.HasCaller() {
		file = filepath.Base(entry.Caller.File)
		function = filepath.Base(entry.Caller.Function)
	}

	// 格式化输出
	timestamp := entry.Time.Format(f.TimestampFormat)
	level := fmt.Sprintf("%-5s", entry.Level.String())

	// 组装最终的日志字符串
	msg := fmt.Sprintf("[%s] | %s | %s:%d [%s] | %s\n",
		timestamp,
		level,
		file,
		entry.Caller.Line,
		function,
		entry.Message,
	)

	return []byte(msg), nil
}

func InitLogger() *logrus.Logger {
	logger := logrus.New()

	logPath := "app.log"

	logFile, err := os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
	if err != nil {
		logger.Fatal("创建日志文件失败：", err)
	}

	// 设置自定义格式化器
	logger.SetFormatter(&CustomFormatter{
		TimestampFormat: "2006-01-02 15:04:05",
	})

	// 启用调用者信息
	logger.SetReportCaller(true)

	// 同时输出到文件和终端
	writers := []io.Writer{
		logFile,
		os.Stdout,
	}
	logger.SetOutput(io.MultiWriter(writers...))

	logger.SetLevel(logrus.DebugLevel)

	return logger
}

func main() {
	logger := InitLogger()
	logger.Info("Hello, world!")
}
