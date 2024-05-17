# pip install psycopg2 python-dotenv
"""
This file is used to connect to PostgreSQL and perform basic operations
"""
import os

from dotenv import load_dotenv
from psycopg2 import pool

load_dotenv()


class PostgreSQLHelper:
    _connection_pool = None

    def __init__(self):
        self.conn = None
        self.cursor = None

    def __enter__(self):
        self.conn = self._connection_pool.getconn()
        self.cursor = self.conn.cursor()
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        if self.cursor:
            self.cursor.close()
        if self.conn:
            self._connection_pool.putconn(self.conn)

    @classmethod
    def initialize_pool(cls):
        if not cls._connection_pool:
            cls._connection_pool = pool.SimpleConnectionPool(
                minconn=1,
                maxconn=10,
                host=os.getenv("PG_HOST"),
                user=os.getenv("PG_USER"),
                password=os.getenv("PG_PASSWORD"),
                database=os.getenv("PG_DB"),
                port=int(os.getenv("PG_PORT")) if os.getenv("PG_PORT") else 5432
            )
            if cls._connection_pool:
                print("Connection pool created successfully")
            else:
                raise ValueError("Error creating connection pool")

    def execute_query(self, query, params=None):
        try:
            self.cursor.execute(query, params)
            self.conn.commit()
            return self.cursor.rowcount
        except Exception as query_err:
            self.conn.rollback()
            raise RuntimeError(f"Failed to execute query: {query_err!r}") from query_err

    def fetch_all(self, query, params=None):
        try:
            self.cursor.execute(query, params)
            return self.cursor.fetchall()
        except Exception as fetch_err:
            raise RuntimeError(f"Failed to fetch data: {fetch_err!r}") from fetch_err


if __name__ == "__main__":
    PostgreSQLHelper.initialize_pool()
    try:
        with PostgreSQLHelper() as db:
            results = db.fetch_all("SELECT * FROM your_table")
        for row in results:
            print(row)
    except Exception as e:
        print(f"An error occurred: {str(e)}")


