<div align="center">
    <h2><img src="https://readme-typing-svg.herokuapp.com?font=Optima&size=35&duration=6000&color=FF5733&center=true&vCenter=true&width=800&lines=代码是写给人看的,+顺便能在机器上运行" alt="Typing SVG"/></h2>
</div>

###  Google开源项目风格指南
```bash
https://zh-google-styleguide.readthedocs.io/en/latest/google-python-styleguide/contents/#
https://www.runoob.com/w3cnote/google-python-styleguide.html
```

#### 1.格式化导包顺序 .isort.cfg

`pip install isort`

`新建 .isort.cfg 配置文件, 位于项目根目录, 内容如下:`

```bash
[tool.isort]
line_length = 100    # 指定每行代码的最大字符数
multi_line_output = 3   # 定义多行导入的格式
include_trailing_comma = True   # 在多行导入的最后一个模块后添加尾随逗号
force_grid_wrap = 0    # 定义何时使用网格格式
use_parentheses = True   # 使用圆括号而不是反斜杠
ensure_newline_before_comments = True    # 在导入语句上方的注释之前确保有一个新行
known_first_party = ['my_module', 'my_other_module']   # import my_module, from my_other_module import xxx
default_section = 'THIRDPARTY'     # 为未分类模块设置默认第三方库
sections = ['FUTURE', 'STDLIB', 'THIRDPARTY', 'FIRSTPARTY', 'LOCALFOLDER']     # 定义导入语句的排序顺序

```

使用:

```bash
isort your_script.py    # 格式化单个文件
isort .    # 格式化整个项目目录
```

#### 2.代码风格和格式保持一致 .editorconfig
`用于在多个开发者和不同编辑器或IDE之间保持一致的代码风格和格式`

`新建 .editorconfig 配置文件, 位于项目根目录, 内容如下:`

```bash
# top-most EditorConfig file
root = true  # 表示该文件是项目的根配置文件，编辑器在查找配置时会从当前文件夹开始逐级向上查找，直到找到该文件为止

[*]
end_of_line = lf   # 设置换行符的类型,lf（Unix 风格）、cr（Mac 风格）或 crlf（Windows 风格）
insert_final_newline = true  # 设置是否在文件末尾插入一个空行
charset = utf-8
trim_trailing_whitespace = true  #删除行尾空白字符
max_line_length = 100  

[*.py]
indent_style = space  # 设置缩进风格。可选值为 tab（制表符）或 space（空格）
indent_size = 4  # 设置每个缩进级别的空格数
insert_final_newline = true

[*.{py,js}]
indent_style = space
indent_size = 4

[*.go]
indent_style = tab
indent_size = 4
tab_width = 4

[Makefile]
indent_style = tab
```

#### 3.使用环境文件 .env

`.env 文件（全称为“环境文件”）通常用于存储项目的配置信息，如数据库连接字符串、API密钥等`

`一般位于项目根目录, 亦可以自定义位置, 通常建议将其添加到 .gitignore 或类似的版本控制忽略文件中`

e.g. 有如下 .env 文件

```bash
DB_HOST=127.0.0.1
DB_USER=root
DB_PORT=3306
```

```python
# pip install python-dotenv
import os
from dotenv import load_dotenv
load_dotenv()    # 从项目根目录加载.env文件
# 或者从指定路径加载 .env 文件
from pathlib import Path
dotenv_path = Path('path/to/.env')
load_dotenv(dotenv_path=dotenv_path)  
-----------------------------------------
# 使用环境变量
db_host = os.getenv("DB_HOST")   # 输出为: "127.0.0.1"
db_port = os.getenv("DB_PORT")   # 输出为: "3306"
db_pwd = os.getenv("DB_PWD")     # 输出为: None, 不存在返回None
```

#### 4.编码建议

*   <font color="red">掌握函数式编程</font>

    *
        ```python
        """
        functools：这个库是 Python 函数式编程的核心，提供了一系列帮助函数来处理其他函数。
        itertools：这个库提供了一系列用于构造和操作迭代对象的工具
        operator：这个库提供了一系列对应于 Python 的内置操作符的函数，比如加法、乘法、索引操作等
        toolz：pip install toolz 提供了一系列函数式编程工具，以便于创建纯函数式的数据流。它扩展了内置的函数式编程功能
        fn.py：另一个第三方库，专注于提供严格的函数式编程方法，包括无状态的函数和不可变数据类型
        """
        ```

*   在进行日志记录和抛出异常时, 使用懒惰的 `%` 格式化（也就是延迟格式化）

    *
        ```python
        # 在日志记录和抛出异常的时候建议使用 `%r` 来进行字符串占位, 而不是 `%s`
        import logging
        logging.debug("Some debug info: %r", value)
        ```

*   在同一个文件中，保持使用字符串引号的一致性, 如果要引用的字符串为多行时，需要使用双引号引用字符串,文档字符串（docstring）必须使用三重双引号`"""` 

*   **TODO** 注释需要加上名字 / email / 或其它标识符, 然后是一个可选的冒号。 接着必须有一行注释，解释要做什么。 主要目的是为了有一个统一的 TODO 格式，这样添加注释的人就可以搜索到 (并可以按需提供更多细节)

*   多行的表达式, 应该用括号括起来, 而不要用反斜杠续行

*   列表推导式 禁止超过 1 个 for 语句或过滤器表达式，否则使用传统 for 循环语句替代

*   使用双下划线 __ 来代表不需要的变量，单下划线 _ 容易与 gettext() 函数的别名冲突

*   避免`from xxx import *`, 因为可能会造成命名空间的污染. 禁止导入了模块却不使用它

*   程序的main文件应该以 #!/usr/bin/python2或者 #!/usr/bin/python3开始, 大部分.py文件不必以#!作为文件的开始

*   尽量减少try/except块中的代码量, 避免使用全局变量, 用类变量来代替

*   不要在函数或方法定义中使用可变对象作为默认值

*   使用 `f-string` 格式化字符串, 使用`.join()`拼接字符串

*   使用`enumerate()`同时遍历索引和值, 使用`isinstance()`进行类型检查

*   避免`import *`, 建议用`__all__`来定义模块中可被导出的变量名

*   **处理网络设备的命令输出用: textfsm**

*   批量插入数据库, 更简洁, 易维护

    *
        ```sql
            -- 不建议使用 单条插入
            INSERT INTO table (column1, column2) VALUES (value1, value2);
            INSERT INTO table (column1, column2) VALUES (value3, value4);

            -- 批量插入
            -- 可以在一次事务中插入多行数据，这减少了事务的开销和网络通信的次数，提高了插入效率
            INSERT INTO table (column1, column2) VALUES (value1, value2), (value3, value4);

        ````

*   **使用参数化SQL语句，强制区分数据和命令，避免产生SQL注入漏洞。**

    *
        ```python
            # 1. execute, 以元组形式传参
            import sqlite3
            connection = sqlite3.connect('example.db')
            cursor = connection.cursor()
            # 参数化查询, 将元组以参数形式传入
            cursor.execute("SELECT * FROM users WHERE username = %s", (username,))

            # 2.executemany, 直接传参
            import psycopg2
            conn = psycopg2.connect(
                dbname="your_dbname",
                user="your_username",
                password="your_password",
                host="your_host",
                port="your_port"
            )
            
            cur = conn.cursor()
            data_to_insert = [
                (1, 'Alice', '2024-07-01'),
                (2, 'Bob', '2024-07-02'),
                (3, 'Charlie', '2024-07-03')
            ]
            
            insert_query = """
            INSERT INTO your_table (id, name, date)  LUES (%s, %s, %s)
            """
            cur.executemany(insert_query, data_to_insert)
            conn.commit()
            cur.close()
            conn.close()

        ```

*   两种方式命名入口文件

    *
        ```bash
        # main.py, 
            这是最常见的方式。通常，main.py 是项目的入口点，它包含了启动程序的主要代码。你可以通过直接运行 python main.py 来启动程序。
        # __main__.py
            这种命名方式用于创建可执行的Python包。如果你的项目是一个包，并且你希望它能够通过 python -m package_name 的方式运行，那么你应该在包的目录下创建一个名为 __main__.py 的文件。当执行这种命令时，Python会寻找并执行该包中的 __main__.py 文件。
        ```

*   使用生成器节省内存

    *
        ```python
        import sys
        my_list = [i for i in range(10000)]
        print(sum(my_list)) # 49995000

        my_gen = (i for i in range(10000))
        print(sum(my_gen)) # 49995000

        my_list = [i for i in range(10000)]
        print(sys.getsizeof(my_list), 'bytes') # 85176 bytes

        my_gen = (i for i in range(10000))
        print(sys.getsizeof(my_gen), 'bytes') # 112 bytes
        ```

*   使用**pathlib**操作文件系统

    *
        ```python
        import sys
        from pathlib import Path

        current_dir = Path(__file__).resolve()   # 当前文件绝对路径,而不是工作目录中文件路径
        # parent_dir = current_dir.parent  # 当前文件的父级目录
        project_path = current_dir.parent.parent   # 获取项目的根路径, current_dir.parents[3] 也可以
        sys.path.append(str(project_path))    # 将项目根路径加入到sys.path, 便于导入项目内的模块

        new_dir = parent_dir / "test/test_dir"
        new_dir.mkdir(parents=True, exist_ok=True)   # 创建文件夹, 若不存在的话

        file_path = Path("a.txt")
        with open(file_path, 'w') as file:
            file.write("Hello, this is some text.")

        for i in new_dir.glob("*.txt"):   # 获取指定路径下以 .txt 结尾的文件
            print(i.stem, i.name, i.parent)

        print(current_dir)
        print(parent_dir)
        ```

*   使用**passlib**安全存储密码

    *
        ```python
        # pip install bcrypt passlib
        from passlib.hash import bcrypt
        """
        bcrypt算法是单向的,即无法从散列值中恢复或“解密”原始密码,只能重置密码
        """
        def hash_password(password):
            """使用 bcrypt 算法生成密码的哈希"""
            hashed_password = bcrypt.hash(password)
            return hashed_password

        def verify_password(hashed_password, password):
            """检查提供的密码与存储的哈希是否匹配"""
            return bcrypt.verify(password, hashed_password)

        if __name__ == "__main__":
            pwd = '12345678'
            hashed = hash_password(pwd)
            print("Hashed Password:", hashed)

            verification_result = verify_password(hashed, pwd)
            print("Password Verified:", verification_result)
        ```

*   <font color="red">**Code review**</font>

    *
        ```python
        # pip install ruff black pylint wemake-python-styleguide, 优先推荐 ruff
        ruff path/to/your_file.py  # 检查一个文件
        ruff path/to/your_directory  # 检查一个目录
        ruff path/to/your_file.py --fix  # 自动修复问题 

        # 在终端使用black和pylint来规范你的脚本
        black your_script.py  
        pylint your_script.py
        flake8 your_script.py   # 更为严格
        # 在pycharm或者vscode安装插件: sonarlint
        ```

*   使用dataclasses

    *
        ```python
        """
        Python 的 dataclasses 是一个非常方便的模块，它用于创建类似于记录的数据结构。
        这个模块自 Python 3.7 起引入，提供了一种声明式的方法来定义数据封装类。
        使用 @dataclass 装饰器定义类。这个装饰器自动为你的类添加特殊方法，比如 __init__() 和 __repr__()。
        """
        from dataclasses import dataclass

        @dataclass
        class Person:
            name: str
            age: int
            gender: str
            
        p = Person("xuehui", 18, "男")
        print(p.name)

        """
        建议: 如果一个函数需要返回多个值(>3)的时候, 建议返回 使用 dataclass 装饰的强类型对象
            简单的场景则不需要, 例如坐标点, 返回一个元组即可
        """
        ```

*   使用上下文管理器类(`with语句`)

    *
        ```markdown
        资源管理: 
            例如文件、网络连接、数据库连接
        事务管理:
            在处理数据库或者需要原子操作的场景中, 确保事务的正确开启和关闭, 以及在必要时进行回滚
        锁和同步:
            在多线程或多进程编程中, 上下文管理器可以用来管理锁, 从而避免死锁并确保资源在并发环境下的正确使用
        ```

*   写明确的文档注释, 一个函数实现了什么功能, 接收了什么参数, 返回什么结果

    *
        ```python
        def add_numbers(a: int, b: int) -> int:
            """
            将两个整数相加并返回结果。

            参数:
            a (int): 第一个加数。
            b (int): 第二个加数。

            返回:
            int: 两个加数的和。
            """
            return a + b
        ```

*   使用**PrettyErrors**美化错误信息

    *
        ```python
        import pretty_errors

        # 配置 PrettyErrors
        pretty_errors.configure(
            separator_character="",  # 去掉顶部的分隔线, 亦可以自定义: "*" 或者 "=" 或者其它
            line_number_first=True,  # 显示行号在前
            # filename_display=pretty_errors.FILENAME_EXTENDED,  # 显示完整的文件路径
            # display_link=True,  # 显示错误所在的文件链接
            # lines_before=2,  # 错误前显示的代码行数
            # lines_after=2,  # 错误后显示的代码行数
            line_color=pretty_errors.RED + '>  ' + pretty_errors.default_config.line_color,  # 行号颜色
            code_color='  ' + pretty_errors.default_config.code_color,  # 代码颜色
        )
        ```

#### 5.使用类型注解

**<font color="red">0.</font>自动生成静态类型注解**

```python
# pip install monkeytype
# monkeytype生成的类型注解也不一定完全准确, 需再检查完善
monkeytype run your_script.py   # 会生成一个monkeytype.sqlite3的文件
monkeytype stub your_script     # 打印出更改之后的样子
monkeytype apply your_script    # 直接修改 your_script.py, 添加静态类型注解
```

**<font color="red">①</font>基本类型注解**

```python
# 对于简单类型，注解直接使用类型本身。例如，对于整数、浮点数和字符串：
def process_data(number: int, factor: float, name: str) -> str:
    result = number * factor
    return f"{name}: {result}"
  
# 再详细一些如下:
def folder_data(static_folder: str | os.PathLike | None = "static",
                static_host: str | None = None,
                is_delete: bool = False):
  # 函数实现
```

**<font color="red">②</font>容器和复合类型**

```python
# 对于列表、字典、元组等，可以使用typing模块中的泛型类型：
from typing import List, Dict, Tuple
def analyze_data(points: List[float], lookup: Dict[str, int], info: Tuple[int, str]) -> None:
    # 函数实现
```

**<font color="red">③</font>可选类型和联合类型**

```python
# 当一个参数可以有多种类型，或者可以为None时，可以使用Optional和Union：
from typing import Optional, Union
def format_text(value: Optional[str], length: Union[int, float]) -> str:
    # 函数实现
```

**<font color="red">④</font>自定义类型**

```python
# 你可以定义自己的类型（例如类）并在类型注解中使用它们：
class Person:
    def __init__(self, name: str):
        self.name = name

def greet(person: Person) -> str:
    return f"Hello, {person.name}"
```

**<font color="red">⑤</font>类型别名**

```python
# 有时为了简化代码，可以定义类型别名：
from typing import Dict, Union
JSON = Dict[str, Union[str, int, float, bool, None]]
def process_json(data: JSON) -> None:
    # 函数实现
```

**<font color="red">⑥</font>函数类型**

```python
# 如果你需要将函数作为参数传递，可以指定其调用签名：
from typing import Callable
def apply_function(func: Callable[[int, int], int], a: int, b: int) -> int:
    return func(a, b)

def add(x: int, y: int) -> int:
    return x + y

result = apply_function(add, 10, 20)
```

#### 6.静态类型检查

`pip install mypy`

\`\`mypy是一个流行的Python静态类型检查工具，用于检查类型注解的一致性\`

`新建 .mypy.ini 或者 mypy.ini 配置文件, 位于项目根目录`

```ini
[mypy]
; 指定项目的Python版本
python_version = 3.8
; 开启对未注明类型函数定义内部的检查
check_untyped_defs = True   
; 要求所有函数定义都必须有类型注解
disallow_untyped_defs = True 
# 忽略对不存在类型注解的第三方库的检查
ignore_missing_imports = True
# 要求所有函数都有完整的类型注解（参数和返回值）
disallow_incomplete_defs = True
# 不允许在已注明类型的函数中调用未注明类型的函数
disallow_untyped_calls = True
; 严格区分 None 类型和其他类型
strict_optional = True
# 警告不必要的类型转换
warn_redundant_casts = True
; 警告代码中无用的 # type: ignore 注释
warn_unused_ignores = True
# 当函数可能返回 Any 类型时发出警告
warn_return_any = True
```

使用:

```bash
mypy example.py   # 检查单个文件
mypy .  # 检查整个项目, 在项目根目录下执行
```

**注意:** `mypy`是基于类型注解工作的, 没有注解的代码部分将不会受到严格的类型检查
