# pip install duckdb
import duckdb

class DuckDBReader:
    def __init__(self):
        self.conn = None

    def __enter__(self):
        self.conn = duckdb.connect()
        self.conn.execute("INSTALL excel;")
        self.conn.execute("LOAD excel;")
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.conn:
            self.conn.close()

    def read_csv(self, file_path):
        return self.conn.execute(f"SELECT * FROM read_csv_auto('{file_path}')").df()

    def read_xlsx(self, file_path, sheet_name=None):
        if sheet_name:
            query = f"SELECT * FROM read_xlsx('{file_path}', sheet='{sheet_name}')"
        else:
            query = f"SELECT * FROM read_xlsx('{file_path}')"
        return self.conn.execute(query).df()


if __name__ == "__main__":
    with DuckDBReader() as reader:
        csv_df = reader.read_csv('data.csv')
        print("CSV data:")
        print(csv_df.head())

        xlsx_df = reader.read_xlsx('data.xlsx', sheet_name='Sheet1')
        print("\nXLSX data:")
        print(xlsx_df.head())
