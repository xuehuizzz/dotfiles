"""A log config file, Use lazy % formatting in logging functions.
"""
import logging
from pathlib import Path


def setup_logger(log_level=logging.INFO, console_level=None, logger_name='custom_logger_name'):
    """Sets up and returns a logger with both file and console handlers.
    """
    log_dir = Path(__file__).parent / "logs"
    log_dir.mkdir(parents=True, exist_ok=True)

    log_file = log_dir / "task.log"
    log_file.touch(exist_ok=True)

    logger = logging.getLogger(logger_name)
    logger.propagate = False
    if logger.hasHandlers():
        logger.handlers.clear()
    logger.setLevel(log_level)

    file_handler = logging.FileHandler(log_file, encoding='utf-8')
    file_handler.setLevel(log_level)

    console_handler = logging.StreamHandler()
    console_handler.setLevel(console_level or log_level)

    formatter = logging.Formatter(
        '%(asctime)s - %(levelname)-8s | %(filename)s [%(funcName)s:%(lineno)d] - %(message)s',
        datefmt='%Y-%m-%d %H:%M:%S'    # '%Y-%m-%dT%H:%M:%S%z'  ISO 8601 格式
    )

    file_handler.setFormatter(formatter)
    console_handler.setFormatter(formatter)

    logger.addHandler(file_handler)
    logger.addHandler(console_handler)

    return logger


if __name__ == '__main__':
    test_logger = setup_logger()
    test_logger.debug('这是一个debug信息')
    test_logger.info('这是一个info信息')
    test_logger.warning('这是一个warning信息')
    test_logger.error('这是一个error信息')
    test_logger.critical('这是一个critical信息')
