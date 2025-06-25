// package main

// import (
// 	"fmt"
// 	"github.com/sirupsen/logrus"
// 	"io"
// 	"os"
// 	"path/filepath"
// )

// // CustomFormatter 自定义格式化器
// type CustomFormatter struct {
// 	TimestampFormat string
// }

// func (f *CustomFormatter) Format(entry *logrus.Entry) ([]byte, error) {
// 	// 获取调用信息
// 	var file, function string
// 	if entry.HasCaller() {
// 		file = filepath.Base(entry.Caller.File)
// 		function = filepath.Base(entry.Caller.Function)
// 	}

// 	// 格式化输出
// 	timestamp := entry.Time.Format(f.TimestampFormat)
// 	level := fmt.Sprintf("%-5s", entry.Level.String())

// 	// 组装最终的日志字符串
// 	msg := fmt.Sprintf("[%s] | %s | %s:%d [%s] | %s\n",
// 		timestamp,
// 		level,
// 		file,
// 		entry.Caller.Line,
// 		function,
// 		entry.Message,
// 	)

// 	return []byte(msg), nil
// }

// func InitLogger() *logrus.Logger {
// 	logger := logrus.New()

// 	logPath := "app.log"

// 	logFile, err := os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0644)
// 	if err != nil {
// 		logger.Fatal("创建日志文件失败：", err)
// 	}

// 	// 设置自定义格式化器
// 	logger.SetFormatter(&CustomFormatter{
// 		TimestampFormat: "2006-01-02 15:04:05",
// 	})

// 	// 启用调用者信息
// 	logger.SetReportCaller(true)

// 	// 同时输出到文件和终端
// 	writers := []io.Writer{
// 		logFile,
// 		os.Stdout,
// 	}
// 	logger.SetOutput(io.MultiWriter(writers...))

// 	logger.SetLevel(logrus.DebugLevel)

// 	return logger
// }

// func main() {
// 	logger := InitLogger()
// 	logger.Info("Hello, world!")
// }



package main

import (
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"os"
	"path/filepath"
	"runtime"
	"time"
)

// CustomEncoder 返回一个自定义的 zapcore.Encoder（类似自定义 Formatter）
func CustomEncoder() zapcore.Encoder {
	return zapcore.NewConsoleEncoder(zapcore.EncoderConfig{
		TimeKey:        "T",
		LevelKey:       "L",
		NameKey:        "N",
		CallerKey:      "C",
		MessageKey:     "M",
		EncodeTime:     zapcore.TimeEncoderOfLayout("2006-01-02 15:04:05"),
		EncodeLevel:    zapcore.CapitalColorLevelEncoder,
		EncodeCaller:   shortCallerEncoder,
		LineEnding:     zapcore.DefaultLineEnding,
	})
}

// shortCallerEncoder 截断调用路径并附带函数名
func shortCallerEncoder(caller zapcore.EntryCaller, enc zapcore.PrimitiveArrayEncoder) {
	// 文件名
	file := filepath.Base(caller.File)
	line := caller.Line

	// 获取函数名
	fn := "unknown"
	if pc, _, _, ok := runtime.Caller(8); ok {
		fn = filepath.Base(runtime.FuncForPC(pc).Name())
	}

	enc.AppendString(file + ":" + itoa(line) + " [" + fn + "]")
}

// 快速 int 转 string（避免 fmt）
func itoa(i int) string {
	return strconv.Itoa(i)
}

func InitLogger() *zap.Logger {
	logPath := "app.log"
	logFile, err := os.OpenFile(logPath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		panic("打开日志文件失败: " + err.Error())
	}

	// 设置日志级别
	level := zapcore.DebugLevel

	// 输出目标（文件 + stdout）
	fileWriter := zapcore.AddSync(logFile)
	consoleWriter := zapcore.AddSync(os.Stdout)

	core := zapcore.NewTee(
		zapcore.NewCore(CustomEncoder(), fileWriter, level),
		zapcore.NewCore(CustomEncoder(), consoleWriter, level),
	)

	// 返回带调用信息的 logger
	logger := zap.New(core, zap.AddCaller(), zap.AddCallerSkip(1))
	return logger
}

func main() {
	logger := InitLogger()
	defer logger.Sync()

	logger.Info("Hello, world!")
}
