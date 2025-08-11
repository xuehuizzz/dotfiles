import duckdb

class DuckDBReader:
    def __init__(self):
        self.con = duckdb.connect()
        # 安装和加载 excel 插件（只需执行一次）
        self.con.execute("INSTALL excel;")
        self.con.execute("LOAD excel;")

    def read_csv(self, file_path):
        return self.con.execute(f"SELECT * FROM read_csv_auto('{file_path}')").df()

    def read_xlsx(self, file_path, sheet_name=None):
        if sheet_name:
            query = f"SELECT * FROM read_xlsx('{file_path}', sheet='{sheet_name}')"
        else:
            query = f"SELECT * FROM read_xlsx('{file_path}')"
        return self.con.execute(query).df()

    def close(self):
        self.con.close()


if __name__ == "__main__":
    reader = DuckDBReader()

    csv_df = reader.read_csv('data.csv')
    print("CSV data:")
    print(csv_df.head())

    xlsx_df = reader.read_xlsx('data.xlsx', sheet_name='Sheet1')
    print("\nXLSX data:")
    print(xlsx_df.head())

    reader.close()
