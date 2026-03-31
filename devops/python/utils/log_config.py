"""
A log config file. Use lazy % formatting in logging functions.
Example:
    logger.info("User %s logged in, took %d ms", username, elapsed)
"""

import atexit
import json
import logging
import sys
import threading
import warnings
from datetime import UTC, datetime
from logging.handlers import RotatingFileHandler
from pathlib import Path
from typing import Any, ClassVar, Optional

# -------- 从 settings 读取配置 --------
# get_settings实际上读取的 .env  使用前按需修改
from manus.config.settings import get_settings

# 不需要序列化到 JSON 的 LogRecord 内置属性
_BUILTIN_ATTRS = frozenset(
    {
        "args", "asctime", "created", "exc_info", "exc_text", "filename",
        "funcName", "levelname", "levelno", "lineno", "message", "module",
        "msecs", "msg", "name", "pathname", "process", "processName",
        "relativeCreated", "stack_info", "taskName", "thread", "threadName",
    }
)


class SimpleJsonFormatter(logging.Formatter):
    """输出单行 JSON 格式的日志，支持 extra 字段。"""

    def format(self, record: logging.LogRecord) -> str:
        log_record: dict[str, Any] = {
            "level": record.levelname,
            "ts": datetime.fromtimestamp(record.created, tz=UTC).isoformat(timespec="milliseconds"),
            "msg": record.getMessage(),
            "caller": f"{record.filename}:{record.lineno}",
            "func": record.funcName,
            "name": record.name,
        }

        # 收集 extra 中的自定义字段
        for key, value in record.__dict__.items():
            if key not in _BUILTIN_ATTRS and key not in log_record:
                try:
                    json.dumps(value, ensure_ascii=False)
                    log_record[key] = value
                except (TypeError, ValueError):
                    log_record[key] = repr(value)

        if record.exc_info and not record.exc_text:
            record.exc_text = self.formatException(record.exc_info)
        if record.exc_text:
            log_record["exception"] = record.exc_text
        if record.stack_info:
            log_record["stack"] = record.stack_info

        return json.dumps(log_record, ensure_ascii=False)


def _find_project_root() -> Path:
    """
    从当前文件向上查找包含 pyproject.toml 的目录作为项目根。
    找不到则退回到当前工作目录。
    """
    current = Path(__file__).resolve().parent
    for parent in (current, *current.parents):
        if (parent / "pyproject.toml").exists():
            return parent
    return Path.cwd()


class LoggerManager:
    """
    线程安全的日志管理器(单例).

    所有配置优先从显式参数读取，其次从 settings (.env)，最后使用默认值.

    用法:
        from xxx import get_logger

        log = get_logger("my_module")
        log.info("hello %s", "world")

    如需自定义初始化参数，可在应用入口处显式实例化一次:
        LoggerManager(log_dir="/var/log/myapp", console_level=logging.DEBUG)
        log = get_logger("my_module")  # 后续照常使用便捷函数
    """

    _instance: ClassVar[Optional["LoggerManager"]] = None
    _init_lock: ClassVar[threading.Lock] = threading.Lock()
    _initialized: bool = False

    # 用于标记自己添加的 handler，避免误清第三方 handler
    _HANDLER_TAG = "_logmgr_managed"

    def __new__(cls, *args: Any, **kwargs: Any) -> "LoggerManager":
        with cls._init_lock:
            if cls._instance is None:
                cls._instance = super().__new__(cls)
            return cls._instance

    def __init__(
        self,
        log_dir: Path | str | None = None,
        max_bytes: int = 10 * 1024 * 1024,
        backup_count: int = 5,
        console_level: int | None = None,
        file_level: int | None = None,
    ) -> None:
        with self._init_lock:
            if self._initialized:
                # 单例已初始化，若调用方传入了不同参数则发出警告
                self._warn_if_different(log_dir, max_bytes, backup_count, console_level, file_level)
                return
            self._initialized = True

        settings = get_settings()

        # ---- 日志路径：显式参数 > settings > 项目根/logs ----
        if log_dir is not None:
            self.log_dir = Path(log_dir)
        elif settings.log_path:
            self.log_dir = Path(settings.log_path)
        else:
            self.log_dir = _find_project_root() / "logs"
        self.log_dir.mkdir(parents=True, exist_ok=True)

        # ---- 日志级别：显式参数 > settings > 默认值 ----
        self.console_level = (
            console_level
            if console_level is not None
            else getattr(settings, "log_console_level", None)
            or logging.INFO
        )
        self.file_level = (
            file_level
            if file_level is not None
            else getattr(settings, "log_file_level", None)
            or logging.DEBUG
        )

        self.max_bytes = max_bytes
        self.backup_count = backup_count

        self._loggers: dict[str, logging.Logger] = {}
        self._lock = threading.Lock()

        atexit.register(self._close_all)

    # ------------------------------------------------------------------ #
    #  内部工具方法
    # ------------------------------------------------------------------ #

    def _warn_if_different(
        self,
        log_dir: Path | str | None,
        max_bytes: int,
        backup_count: int,
        console_level: int | None,
        file_level: int | None,
    ) -> None:
        """单例已存在时，若新参数与已有配置不一致则发出警告。"""
        diffs: list[str] = []
        if log_dir is not None and Path(log_dir) != self.log_dir:
            diffs.append(f"log_dir: {self.log_dir} vs {log_dir}")
        if max_bytes != self.max_bytes:
            diffs.append(f"max_bytes: {self.max_bytes} vs {max_bytes}")
        if backup_count != self.backup_count:
            diffs.append(f"backup_count: {self.backup_count} vs {backup_count}")
        if console_level is not None and console_level != self.console_level:
            diffs.append(f"console_level: {self.console_level} vs {console_level}")
        if file_level is not None and file_level != self.file_level:
            diffs.append(f"file_level: {self.file_level} vs {file_level}")
        if diffs:
            warnings.warn(
                "LoggerManager is a singleton; the following parameters differ "
                f"from the initial configuration and will be ignored: {', '.join(diffs)}",
                UserWarning,
                stacklevel=3,
            )

    @staticmethod
    def _tag_handler(handler: logging.Handler) -> logging.Handler:
        """给 handler 打上标记，以便后续只清理自己创建的。"""
        setattr(handler, LoggerManager._HANDLER_TAG, True)
        return handler

    @staticmethod
    def _is_managed(handler: logging.Handler) -> bool:
        return getattr(handler, LoggerManager._HANDLER_TAG, False)

    # ------------------------------------------------------------------ #
    #  生命周期
    # ------------------------------------------------------------------ #

    def _close_all(self) -> None:
        with self._lock:
            for lg in self._loggers.values():
                for handler in lg.handlers[:]:
                    if not self._is_managed(handler):
                        continue
                    try:
                        handler.flush()
                        handler.close()
                    except Exception as exc:
                        print(
                            f"Failed to close log handler {handler}: {exc}",
                            file=sys.stderr,
                        )
                    lg.removeHandler(handler)
            self._loggers.clear()

    # ------------------------------------------------------------------ #
    #  公共接口
    # ------------------------------------------------------------------ #

    def get_logger(
        self,
        name: str = "manus",
        *,
        console: bool = True,
        json_file: bool = True,
        level: int = logging.DEBUG,
    ) -> logging.Logger:
        with self._lock:
            if name in self._loggers:
                return self._loggers[name]

            logger = logging.getLogger(name)
            logger.setLevel(level)
            logger.propagate = False

            # 只清理由本管理器创建的 handler，保留外部添加的
            for h in logger.handlers[:]:
                if self._is_managed(h):
                    logger.removeHandler(h)

            if json_file:
                log_file = self.log_dir / f"{name}.log"
                fh = RotatingFileHandler(
                    log_file,
                    maxBytes=self.max_bytes,
                    backupCount=self.backup_count,
                    encoding="utf-8",
                    delay=True,
                )
                fh.setLevel(self.file_level)
                fh.setFormatter(SimpleJsonFormatter())
                logger.addHandler(self._tag_handler(fh))

            if console:
                ch = logging.StreamHandler(sys.stdout)
                ch.setLevel(self.console_level)
                ch.setFormatter(
                    logging.Formatter(
                        "%(asctime)s - %(levelname)-8s | "
                        "%(filename)s [%(funcName)s:%(lineno)3d] - %(message)s",
                        datefmt="%Y-%m-%d %H:%M:%S",
                    )
                )
                logger.addHandler(self._tag_handler(ch))

            self._loggers[name] = logger
            return logger


def get_logger(name: str = "manus", **kwargs: Any) -> logging.Logger:
    """便捷入口，省去每次手动实例化 LoggerManager。"""
    return LoggerManager().get_logger(name, **kwargs)


# if __name__ == "__main__":
#     log = get_logger("my_project")
#     log.debug("调试日志 - 只会出现在文件里 (console_level=INFO)")
#     log.info("任务开始: user=%s", "alice")
#     log.warning("警告信息: retry %d/%d", 3, 5)
#     log.error("出错啦")
#     try:
#         1 / 0
#     except ZeroDivisionError:
#         log.exception("捕获异常示例")
#     log.info("带 extra 字段", extra={"request_id": "abc-123", "latency_ms": 42})
