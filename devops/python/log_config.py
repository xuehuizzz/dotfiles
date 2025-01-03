"""A log config file, Use lazy % formatting in logging functions.
from loguru import logger  # Third-party library, used directly
"""
import atexit
import sys
import logging
from pathlib import Path


def setup_logger(log_level=logging.INFO, console_level=logging.INFO,
                 logger_name='custom_logger_name'):
    """Sets up and returns a logger with both file and console handlers.
    """
    if not logger_name:
        logger_name = __name__
    log_dir = Path(__file__).resolve().parent / "logs"  # Modify according to actual situation
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / "task.log"

    logger = logging.getLogger(logger_name)
    logger.propagate = False
    logger.setLevel(log_level)

    if logger.hasHandlers():
        logger.handlers.clear()

    file_handler = logging.FileHandler(log_file, encoding='utf-8')
    file_handler.setLevel(log_level)

    console_handler = logging.StreamHandler(stream=sys.stdout)
    console_handler.setLevel(console_level)

    formatter = logging.Formatter(
        '%(asctime)s - %(levelname)-8s | %(filename)s [%(funcName)s:%(lineno)d] - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'
    )

    file_handler.setFormatter(formatter)
    console_handler.setFormatter(formatter)

    logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    atexit.register(lambda: logger.handlers.clear())
    return logger


logger = setup_logger()


if __name__ == '__main__':
    test_logger = setup_logger()
    test_logger.debug('这是一个%s信息', 'debug')
    test_logger.info('这是一个%s信息', 'info')
    test_logger.warning('这是一个%s信息', 'warning')
    test_logger.error('这是一个%s信息', 'error')
    test_logger.critical('这是一个%s信息', 'critical')
