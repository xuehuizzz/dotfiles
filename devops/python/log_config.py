"""A log config file, Use lazy % formatting in logging functions.
from loguru import logger  # Third-party library, used directly
"""
import atexit
import sys
import logging
from logging.handlers import RotatingFileHandler
from pathlib import Path


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

    file_handler = RotatingFileHandler(
        log_file, maxBytes=20 * 1024 * 1024, backupCount=7, encoding='utf-8'
    )
    file_handler.setLevel(log_level)

    console_handler = logging.StreamHandler(stream=sys.stdout)
    console_handler.setLevel(console_level)

    formatter = logging.Formatter(
        '%(asctime)s - %(levelname)-8s | %(filename)s [%(funcName)s: %(lineno)3d] - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )

    file_handler.setFormatter(formatter)
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
    """
