"""A log config file, Use lazy % formatting in logging functions.
from loguru import logger  # Third-party library, used directly

pip install python-json-logger
"""
import atexit
import logging
import sys
from logging.handlers import RotatingFileHandler
from pathlib import Path
from pythonjsonlogger.json import JsonFormatter


def setup_logger(log_level=logging.DEBUG, console_level=logging.DEBUG, logger_name='project_name'):
    """Sets up and returns a logger with both file and console handlers.
    """
    if not logger_name:
        logger_name = __name__
    log_dir = Path(__file__).resolve().parent / "logs"  # Modify according to actual situation
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / "task.log"

    _logger = logging.getLogger(logger_name)
    _logger.propagate = False
    _logger.setLevel(log_level)

    if _logger.hasHandlers():
        _logger.handlers.clear()

    # 1. 基于文件大小轮换
    # file_handler = RotatingFileHandler(
    #     log_file, maxBytes=20 * 1024 * 1024, backupCount=7, encoding='utf-8'
    # )
    
    # 2. 基于时间轮换
    # file_handler = TimedRotatingFileHandler(
    #     log_file, when=midnight, backupCount=7, encoding='utf-8'
    # )

    # 3. 文件格式(普通)
    file_handler = logging.FileHandler(log_file, encoding='utf-8')
    file_handler.setLevel(log_level)

    console_handler = logging.StreamHandler(stream=sys.stdout)
    console_handler.setLevel(console_level)

    formatter = logging.Formatter(
        '%(asctime)s - %(levelname)-8s | %(filename)s [%(funcName)s: %(lineno)3d] - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    # 输出JSON格式
    json_formatter = JsonFormatter(
        fmt='%(levelname)s %(asctime)s %(name)s %(message)s %(filename)s %(funcName)s %(lineno)d',
        datefmt='%Y-%m-%dT%H:%M:%S',
        rename_fields={
            'levelname': 'level',
            'asctime': 'ts',
            'message': 'msg',
            'filename': 'caller'
        },
        json_ensure_ascii=False
    )
    
    file_handler.setFormatter(json_formatter)  # or formatter
    console_handler.setFormatter(formatter)

    _logger.addHandler(file_handler)
    _logger.addHandler(console_handler)

    atexit.register(lambda: _logger.handlers.clear())
    return _logger


logger = setup_logger()


if __name__ == '__main__':
    """
    try:
        from loguru import logger
    except ImportError:
        from custom_func import logger
    logger.debug('这是一个%s信息', 'debug')
    logger.info('这是一个%s信息', 'info')
    logger.warning('这是一个%s信息', 'warning')
    logger.error('这是一个%s信息', 'error')
    logger.critical('这是一个%s信息', 'critical')
    logger.exception("自带堆栈信息")
    """
