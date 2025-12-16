"""A log config file, Use lazy % formatting in logging functions.
from loguru import logger  # Third-party library, used directly

"""
__all__ = ["LoggerManager"]

import atexit
import json
import logging
import sys
import threading
from datetime import datetime, timezone
from logging.handlers import RotatingFileHandler
from pathlib import Path
from typing import Any, Dict


class SimpleJsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        log_record: Dict[str, Any] = {
            "level": record.levelname,
            "ts": datetime.fromtimestamp(record.created, tz=timezone.utc).isoformat(
                timespec="milliseconds"
            ),
            "msg": record.getMessage(),
            "caller": record.filename,
            "func": record.funcName,
            "lineno": record.lineno,
            "name": record.name,
        }
        if record.exc_info:
            log_record["exc_info"] = self.formatException(record.exc_info)
        return json.dumps(log_record, ensure_ascii=False)


class LoggerManager:
    _loggers: Dict[str, logging.Logger] = {}
    _lock = threading.Lock()

    def __init__(self, log_dir=None, max_bytes=10 * 1024 * 1024, backup_count=5):
        if log_dir is None:
            log_dir = Path(__file__).resolve().parent / "logs"
        self.log_dir = Path(log_dir)
        self.log_dir.mkdir(parents=True, exist_ok=True, mode=0o755)
        self.max_bytes = max_bytes
        self.backup_count = backup_count
        atexit.register(self._close_all)

    def _close_all(self):
        with self._lock:
            for logger in self._loggers.values():
                for handler in logger.handlers:
                    try:
                        handler.flush()
                        handler.close()
                    except Exception as e:
                        print(
                            f"Failed to close log handler {handler}: {e}",
                            file=sys.stderr,
                        )

    def get_logger(
        self,
        name: str = "project",
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

            if json_file:
                log_file = self.log_dir / f"{name}.log"
                file_handler = RotatingFileHandler(
                    log_file,
                    maxBytes=self.max_bytes,
                    backupCount=self.backup_count,
                    encoding="utf-8",
                    delay=True,
                )
                file_handler.setFormatter(SimpleJsonFormatter())
                logger.addHandler(file_handler)

            if console:
                console_handler = logging.StreamHandler(sys.stdout)
                console_formatter = logging.Formatter(
                    "%(asctime)s - %(levelname)-8s | %(filename)s [%(funcName)s:%(lineno)3d] - %(message)s",
                    datefmt="%Y-%m-%d %H:%M:%S",
                )
                console_handler.setFormatter(console_formatter)
                logger.addHandler(console_handler)

            self._loggers[name] = logger
            return logger


if __name__ == "__main__":
    """
    log_mgr = LoggerManager()
    logger = log_mgr.get_logger("my_project")
    logger.debug("调试日志")
    logger.info("任务开始")
    logger.warning("警告信息")
    logger.error("出错啦")
    try:
        1 / 0
    except ZeroDivisionError:
        logger.exception("捕获异常示例")
    logger.critical("严重错误！")
    """
