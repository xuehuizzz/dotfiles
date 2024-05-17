# pip install pymysql pymysql-pool python-dotenv
"""
This file is used to connect to MySQL and perform basic operations
"""
import os

import pymysql
from dotenv import load_dotenv
from pymysqlpool import ConnectionPool

load_dotenv()


class MySQLHelper:
    _pool = None

    def __init__(self):
        self.conn = None
        self.cursor = None

    def __enter__(self):
        self.conn = self._pool.get_connection()
        self.cursor = self.conn.cursor()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self.conn.close()

    @classmethod
    def initialize_pool(cls):
        """初始化连接池"""
        if not cls._pool:
            config = cls.load_db_config()
            cls._pool = ConnectionPool(**config)

    @classmethod
    def load_db_config(cls):
        """加载数据库配置信息"""
        config = {
            "host": os.getenv("MY_HOST"),
            "user": os.getenv("MY_USER"),
            "password": os.getenv("MY_PWD"),
            "database": os.getenv("MY_DB"),
            "port": int(os.getenv("MY_PORT")) if os.getenv("MY_PORT") else 3306
        }
        if not all(config.values()):
            raise ValueError("Missing required environment variables for database connection.")
        return config

    def execute_query(self, query, params=None):
        try:
            self.conn.ping(reconnect=True)  # Reconnect if connection is lost
            self.cursor.execute(query, params)
            self.conn.commit()
            return self.cursor.rowcount
        except Exception as query_err:
            self.conn.rollback()
            raise RuntimeError(f"Failed to execute query: {query_err!r}") from query_err

    def execute_many_queries(self, query, params_list):
        try:
            self.conn.ping(reconnect=True)  # Reconnect if connection is lost
            self.cursor.executemany(query, params_list)
            self.conn.commit()
            return self.cursor.rowcount
        except Exception as query_err:
            self.conn.rollback()
            raise RuntimeError(f"Failed to execute queries: {query_err!r}") from query_err

    def fetch_all(self, query, params=None):
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchall()
        except Exception as fetch_err:
            raise RuntimeError(
                f"Failed to fetch data: {fetch_err!r}, sql: {query, params}"
            ) from fetch_err


if __name__ == "__main__":
    """使用classmethod是保证在程序启动前及创建实例前就加载数据"""
    MySQLHelper.initialize_pool()
    try:
        with MySQLHelper() as db:
            results = db.fetch_all("SELECT count(id) FROM video;")
        print(results)
    except pymysql.MySQLError as e:
        raise pymysql.MySQLError(f"An error occurred: {e!r}") from e
