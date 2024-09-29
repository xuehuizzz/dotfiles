"""This file is used to connect to PostgreSQL and perform basic operations.
pip install psycopg2 python-dotenv
"""
import os
from typing import List, Optional, Any

from dotenv import load_dotenv
from psycopg2 import pool

load_dotenv()


class PostgreSQLContext:
    _connection_pool: Optional[pool.SimpleConnectionPool] = None

    def __init__(self, host: Optional[str] = None, port: Optional[int] = None,
                 database: Optional[str] = None, user: Optional[str] = None,
                 password: Optional[str] = None):
        self.conn = None
        self.cursor = None
        self.user = user or os.getenv("PG_USER")
        self.password = password or os.getenv("PG_PASSWORD")
        self.database = database or os.getenv("PG_DB")
        self.host = host or os.getenv("PG_HOST")
        self.port = port or int(os.getenv("PG_PORT")) if os.getenv("PG_PORT") else 5432
        if not self._connection_pool:
            PostgreSQLContext.initialize_pool(self.host, self.port, self.database, self.user, self.password)

    def __enter__(self) -> "PostgreSQLContext":
        self.conn = self._connection_pool.getconn()
        self.cursor = self.conn.cursor()
        return self

    def __exit__(self, exc_type: Optional[type], exc_value: Optional[Exception], traceback: Optional[Any]):
        if self.cursor:
            self.cursor.close()
            self.cursor = None
        if self.conn:
            self._connection_pool.putconn(self.conn)
            self.conn = None

    @classmethod
    def close_pool(cls):
        if cls._connection_pool:
            cls._connection_pool.closeall()
            cls._connection_pool = None

    @classmethod
    def initialize_pool(cls, host: str, port: int, database: str, user: str, password: str):
        if not cls._connection_pool:
            cls._connection_pool = pool.SimpleConnectionPool(
                minconn=1,
                maxconn=10,
                host=host,
                port=port,
                database=database,
                user=user,
                password=password
            )
            if cls._connection_pool:
                print("Connection pool created successfully")
            else:
                raise ValueError("Error creating connection pool")

    def execute_query(self, query: str, params: Optional[List[Any]] = None) -> int:
        """Execute a single SQL query"""
        try:
            self.cursor.execute(query, params)
            self.conn.commit()
            return self.cursor.rowcount
        except Exception as query_err:
            self.conn.rollback()
            raise RuntimeError(f"Failed to execute query: {query_err!r}") from query_err

    def execute_many_queries(self, query: str, params: Optional[List[Any]] = None) -> int:
        """Execute many SQL query"""
        try:
            self.cursor.executemany(query, params)
            self.conn.commit()
            return self.cursor.rowcount
        except Exception as query_err:
            self.conn.rollback()
            raise RuntimeError(f"Failed to execute query: {query_err!r}") from query_err

    def fetch_all(self, query: str, params: Optional[List[Any]] = None) -> List[Any]:
        """Fetch all rows from a query"""
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchall()
        except Exception as fetch_err:
            raise RuntimeError(f"Failed to fetch data: {fetch_err!r}") from fetch_err

    def real_executed_query(self, query: str, params: Optional[List[Any]] = None) -> str:
        """Return the last executed SQL query with parameters interpolated"""
        real_sql = ""
        if params and isinstance(params, (list, tuple)):
            if isinstance(params[0], (list, tuple)):
                real_sql = "\n".join(
                    self.cursor.mogrify(query, param_set).decode('utf-8') for param_set in
                    params
                ) + "\n"
            else:
                real_sql = self.cursor.mogrify(query, params).decode('utf-8') + "\n"
        return real_sql


if __name__ == "__main__":
    """Using classmethod to ensure the data is loaded before program start and instance creation"""
    try:
        with PostgreSQLContext() as db:
            # Batch insert
            insert_query = "INSERT INTO your_table (column1, column2) VALUES (%s, %s)"
            insert_params = [
                ("value1", "value2"),
                ("value3", "value4"),
                ("value5", "value6")
            ]
            db.execute_many_queries(insert_query, insert_params)

            # Batch update
            update_query = "UPDATE your_table SET column1 = %s WHERE column2 = %s"
            update_params = [
                ("new_value1", "value2"),
                ("new_value3", "value4"),
                ("new_value5", "value6")
            ]
            db.execute_many_queries(update_query, update_params)

            # Fetch data
            results = db.fetch_all("SELECT * FROM your_table")
        for row in results:
            print(row)
    except Exception as e:
        print(f"An error occurred: {e}")
    finally:
        # Disconnect the pool at the end of the program
        PostgreSQLContext.close_pool()
