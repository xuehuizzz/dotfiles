# pip install duckdb
import duckdb
from pathlib import Path
from typing import Optional, Union


class DuckDBReader:
    def __init__(self, database: str = ":memory:"):
        self.database = database
        self.conn: Optional[duckdb.DuckDBPyConnection] = None

    def __enter__(self):
        self.conn = duckdb.connect(self.database)
        # 读取 xlsx 需要 excel 扩展；INSTALL 对已安装扩展是幂等的
        try:
            self.conn.execute("INSTALL excel;")
            self.conn.execute("LOAD excel;")
        except duckdb.Error as e:
            self.conn.close()
            self.conn = None
            raise RuntimeError(f"加载 excel 扩展失败: {e}") from e
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if self.conn:
            self.conn.close()
            self.conn = None
        # 返回 False（None）以不抑制上下文内抛出的异常
        return False

    @staticmethod
    def _check_file(file_path: Union[str, Path]) -> str:
        path = Path(file_path)
        if not path.exists():
            raise FileNotFoundError(f"文件不存在: {path}")
        if not path.is_file():
            raise ValueError(f"路径不是文件: {path}")
        return str(path)

    def read_csv(self, file_path: Union[str, Path], **kwargs):
        """
        读取 CSV 文件并返回 pandas DataFrame。

        额外的关键字参数会作为 read_csv 的选项传入，
        例如: delim=';', header=True, encoding='utf-8'
        """
        path = self._check_file(file_path)

        # 使用参数化查询传递文件路径，避免 SQL 注入
        options = self._build_options(kwargs)
        query = f"SELECT * FROM read_csv($path{options})"
        return self.conn.execute(query, {"path": path, **kwargs}).df()

    def read_xlsx(
        self,
        file_path: Union[str, Path],
        sheet_name: Optional[str] = None,
        **kwargs,
    ):
        """
        读取 XLSX 文件并返回 pandas DataFrame。

        可通过 sheet_name 指定工作表，其余选项通过 kwargs 传入，
        例如: range='A1:C10', header=True
        """
        path = self._check_file(file_path)

        params = {"path": path}
        extra = dict(kwargs)
        if sheet_name is not None:
            extra["sheet"] = sheet_name

        options = self._build_options(extra)
        params.update(extra)

        query = f"SELECT * FROM read_xlsx($path{options})"
        return self.conn.execute(query, params).df()

    @staticmethod
    def _build_options(kwargs: dict) -> str:
        """根据 kwargs 构建命名参数占位符片段，如 ', sheet=$sheet'。"""
        if not kwargs:
            return ""
        return ", " + ", ".join(f"{key}=${key}" for key in kwargs)


if __name__ == "__main__":
    with DuckDBReader() as reader:
        try:
            csv_df = reader.read_csv("data.csv")
            print("CSV data:")
            print(csv_df.head())
        except (FileNotFoundError, duckdb.Error) as e:
            print(f"读取 CSV 失败: {e}")

        try:
            xlsx_df = reader.read_xlsx("data.xlsx", sheet_name="Sheet1")
            print("\nXLSX data:")
            print(xlsx_df.head())
        except (FileNotFoundError, duckdb.Error) as e:
            print(f"读取 XLSX 失败: {e}")
