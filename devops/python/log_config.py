"""A log config file, Use lazy % formatting in logging functions.
from loguru import logger  # Third-party library, used directly

"""
__all__ = ["logger"]

import atexit
import json
import logging
import sys
from datetime import datetime
from pathlib import Path
from logging.handlers import RotatingFileHandler


class SimpleJsonFormatter(logging.Formatter):
    def format(self, record):
        log_record = {
            "level": record.levelname,
            "ts": datetime.fromtimestamp(record.created)
            .astimezone()
            .isoformat(timespec="milliseconds"),
            "msg": record.getMessage(),
            "caller": record.filename,
            "func": record.funcName,
            "lineno": record.lineno,
            "name": record.name,
            # "thread": record.threadName,
            # "process": record.process,
        }
        if hasattr(record, "extra_data"):
            log_record["extra"] = record.extra_data
        if record.exc_info:
            log_record["exc_info"] = self.formatException(record.exc_info)
        return json.dumps(log_record, ensure_ascii=False)


_LOGGERS = {}  # 缓存 logger


def get_logger(
    name="project", log_dir=None, max_bytes=10 * 1024 * 1024, backup_count=5
):
    if name in _LOGGERS:
        return _LOGGERS[name]

    if log_dir is None:
        log_dir = Path(__file__).resolve().parent / "logs"
    log_dir.mkdir(parents=True, exist_ok=True, mode=0o755)
    log_file = log_dir / f"{name}.log"

    logger = logging.getLogger(name)
    logger.setLevel(logging.DEBUG)

    # 文件日志（JSON + 轮转）
    file_handler = RotatingFileHandler(
        log_file, maxBytes=max_bytes, backupCount=backup_count, encoding="utf-8"
    )
    file_handler.setFormatter(SimpleJsonFormatter())
    logger.addHandler(file_handler)

    # 控制台日志（彩色可选）
    console_handler = logging.StreamHandler(sys.stdout)
    console_formatter = logging.Formatter(
        "%(asctime)s - %(levelname)-8s | %(filename)s [%(funcName)s:%(lineno)3d] - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )
    console_handler.setFormatter(console_formatter)
    logger.addHandler(console_handler)

    # 自动关闭
    atexit.register(lambda: [h.flush() or h.close() for h in logger.handlers])

    _LOGGERS[name] = logger
    return logger


logger = get_logger("my_project")


if __name__ == "__main__":
    """
    logger = get_logger("my_project")
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
