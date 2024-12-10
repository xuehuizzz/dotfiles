"""This file is used to connect to PostgreSQL and perform basic operations.
pip install psycopg2 python-dotenv
"""
__all__ = ["PostgreSQLContext"]
import os
from typing import List, Optional, Any

from dotenv import load_dotenv
from psycopg2 import pool, Error as psycopg2Error

load_dotenv()


class PostgreSQLExecutionError(Exception):
    """Custom exception to handle PostgreSQL execution errors"""

    def __init__(self, query: str, error: str):
        super().__init__(f"Error executing query: {error}")
        self.query = query
        self.error = error


class PostgreSQLContext:
    _connection_pool: Optional[pool.SimpleConnectionPool] = None
    host: Optional[str] = os.getenv("PG_HOST")
    port: Optional[int] = int(os.getenv("PG_PORT")) if os.getenv("PG_PORT") else 5432
    database: Optional[str] = os.getenv("PG_DB")
    user: Optional[str] = os.getenv("PG_USER")
    password: Optional[str] = os.getenv("PG_PWD")

    def __init__(self):
        self.conn = None
        self.cursor = None
        self.batch_size: int = 50000

    def __enter__(self) -> "PostgreSQLContext":
        self.conn = self._connection_pool.getconn()
        self.cursor = self.conn.cursor()
        self.conn.autocommit = False  # Disable autocommit by default
        return self

    def __exit__(self, exc_type: Optional[type], exc_value: Optional[Exception],
                 traceback: Optional[Any]):
        if exc_type is None:
            self.conn.commit()  # Commit if no exception occurred
        else:
            self.conn.rollback()  # Rollback if exception occurred
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
    def initialize_pool(cls):
        if not cls._connection_pool:
            cls._connection_pool = pool.SimpleConnectionPool(
                minconn=1,
                maxconn=10,
                host=cls.host,
                port=cls.port,
                database=cls.database,
                user=cls.user,
                password=cls.password
            )
            if cls._connection_pool:
                print("Connection pool created successfully")
            else:
                raise ValueError("Error creating connection pool")

    def execute_queries(self, query: str, params: Optional[Any] = None) -> int:
        """Execute a single query or batch queries based on the parameters, with batch processing."""
        # TODO: 待修改, 该方法主要使用insert
        try:
            if not params:
                self.cursor.execute(query)
                self.conn.commit()
            elif isinstance(params, tuple):
                self.cursor.execute(query, params)
                self.conn.commit()
            elif isinstance(params, list) and all(
                    isinstance(item, (tuple, list)) for item in params):
                total_rows = len(params)
                for start in range(0, total_rows, self.batch_size):
                    batch_params = params[start:start + self.batch_size]
                    value_placeholders = ", ".join(
                        [f"({', '.join(['%s'] * len(param))})" for param in batch_params])
                    batch_query = f"{query} VALUES {value_placeholders}"
                    flat_params = [item for param in batch_params for item in param]
                    self.cursor.execute(batch_query, flat_params)
                self.conn.commit()
            else:
                raise ValueError(
                    "For batch execution, params should be a list of tuples or lists, or a single tuple for one query.")
            return self.cursor.rowcount
        except psycopg2Error as query_err:
            self.conn.rollback()
            real_sql = self.real_executed_query(query, params)
            raise PostgreSQLExecutionError(f"Error executing query: {real_sql}", query_err)

    def fetch_all(self, query: str, params: Optional[List[Any]] = None) -> List[Any]:
        """Fetch all rows from a query"""
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchall()
        except psycopg2Error as fetch_err:
            raise PostgreSQLExecutionError(query, fetch_err)

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
    """Using classmethod to ensure the data is loaded before program start and instance creation
    
    In the execute_queries method, you can not pass params, so that a single SQL statement will be executed by default.        
    You can also pass params as a single tuple to execute a single SQL statement.
    You can also pass params as a list, where each element is a tuple or list, so that SQL statements can be executed in batches.
    """
    # PostgreSQLContext.user = "your_user"
    # PostgreSQLContext.password = "your_password"
    # PostgreSQLContext.database = "your_database"
    # PostgreSQLContext.host = "your_host"
    # PostgreSQLContext.port = "your_port"

    PostgreSQLContext.initialize_pool()
    try:
        with PostgreSQLContext() as db:
            single_data_sql = "DELETE FROM your_table WHERE column1 = 'xxx1';"
            db.execute_queries(single_data_sql)   # returns the number of affected rows

            single_data_with_param_sql = "UPDATE your_table SET column1 = %s WHERE column2 = %s;"
            param = ("xxx2", "xxx3")
            db.execute_queries(single_data_with_param_sql, param)  # returns the number of affected rows

            insert_query = "INSERT INTO your_table (column1, column2) VALUES (%s, %s);"
            insert_params = [
                ("value1", "value2"),
                ("value3", "value4"),
                ("value5", "value6")
            ]
            db.execute_queries(insert_query, insert_params)  # returns the number of affected rows

            # Fetch data
            results = db.fetch_all("SELECT count(1) FROM your_table;")
            print(results)
    except Exception as e:
        print(f"An error occurred: {e}")
    # Disconnect the pool at the end of the program
    PostgreSQLContext.close_pool()
