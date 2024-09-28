"""This file is used to connect to MySQL and perform basic operations.
pip install pymysql pymysql-pool python-dotenv
"""
import os
from typing import Optional, List, Tuple, Any

import pymysql
from dotenv import load_dotenv
from pymysqlpool import ConnectionPool

load_dotenv()


class MySQLHelper:
    _connection_pool: Optional[ConnectionPool] = None

    def __init__(self, host: Optional[str] = None,  user: Optional[str] = None,
                 password: Optional[str] = None, database: Optional[str] = None, port: Optional[int] = None,
                 connection_pool_size: int = 10, max_overflow: int = 10, **kwargs) -> None:
        self.conn: Optional[pymysql.connections.Connection] = None
        self.cursor: Optional[pymysql.cursors.Cursor] = None
        self.host = host or os.getenv("MY_HOST")
        self.user = user or os.getenv("MY_USER")
        self.password = password or os.getenv("MY_PWD")
        self.database = database or os.getenv("MY_DB")
        self.port = port or int(os.getenv("MY_PORT")) if os.getenv("MY_PORT") else 3306
        if not MySQLHelper._connection_pool:
            MySQLHelper.initialize_pool(self.host, self.user, self.password, self.database, self.port)

    def __enter__(self) -> 'MySQLHelper':
        self.conn = self._connection_pool.get_connection()
        self.cursor = self.conn.cursor()
        return self

    def __exit__(self, exc_type: Optional[type], exc_value: Optional[Exception], traceback: Optional[Any]) -> None:
        if self.cursor:
            self.cursor.close()
            self.cursor = None
        if self.conn:
            self.conn.close()
            self.conn = None

    @classmethod
    def close_pool(cls) -> None:
        if MySQLHelper._connection_pool:
            MySQLHelper._connection_pool.dispose()
            MySQLHelper._connection_pool = None

    @classmethod
    def initialize_pool(cls, host: str, user: str, password: str, database: str, port: int) -> None:
        """Initialize the connection pool"""
        if not cls._connection_pool:
            config = {
                "host": host,
                "user": user,
                "password": password,
                "database": database,
                "port": port
            }
            if not all(config.values()):
                missing_vars = [key for key, value in config.items() if not value]
                raise ValueError("Missing required environment variables for "
                                 f"database connection: {', '.join(missing_vars)}")

            cls._connection_pool = ConnectionPool(**config)

    def execute_query(self, query: str, params: Optional[Tuple[Any, ...]] = None) -> int:
        try:
            self.conn.ping(reconnect=True)  # Reconnect if connection is lost
            self.cursor.execute(query, params)
            self.conn.commit()
            return self.cursor.rowcount
        except Exception as query_err:
            self.conn.rollback()
            raise RuntimeError(f"Failed to execute query: {query_err!r}") from query_err

    def execute_many_queries(self, query: str, params_list: Optional[List[Tuple[Any, ...]]] = None) -> int:
        try:
            self.conn.ping(reconnect=True)  # Reconnect if connection is lost
            self.cursor.executemany(query, params_list)
            self.conn.commit()
            return self.cursor.rowcount
        except Exception as query_err:
            self.conn.rollback()
            raise RuntimeError(f"Failed to execute queries: {query_err!r}") from query_err

    def fetch_all(self, query: str, params: Optional[Tuple[Any, ...]] = None) -> List[Tuple[Any, ...]]:
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchall()
        except Exception as fetch_err:
            raise RuntimeError(f"Failed to fetch data: {fetch_err!r}, sql: {query, params}") from fetch_err


if __name__ == "__main__":
    """Using classmethod to ensure the data is loaded before program start and instance creation"""
    try:
        with MySQLHelper() as db:
            # Example of batch insert
            insert_query = "INSERT INTO video (title, url) VALUES (%s, %s)"
            insert_data = [
                ("Title1", "http://example.com/1"),
                ("Title2", "http://example.com/2"),
                ("Title3", "http://example.com/3"),
            ]
            rows_inserted = db.execute_many_queries(insert_query, insert_data)
            print(f"{rows_inserted} rows inserted.")

            # Example of batch update
            update_query = "UPDATE video SET title = %s WHERE id = %s"
            update_data = [
                ("New Title1", 1),
                ("New Title2", 2),
                ("New Title3", 3),
            ]
            rows_updated = db.execute_many_queries(update_query, update_data)
            print(f"{rows_updated} rows updated.")

            results = db.fetch_all("SELECT count(id) FROM video;")
            print(results)
    except Exception as err:
        print(f"Error: {err!r}")
    finally:
        MySQLHelper.close_pool()
