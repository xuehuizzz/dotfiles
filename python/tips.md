## 使用uvicorn/guvicorn部署项目

1. 协议支持
- Gunicorn：
    - 主要用于 WSGI（Web Server Gateway Interface）应用，适合传统的 Python Web 框架，如 Flask 和 Django。
    不支持异步编程。
- Uvicorn：
    - 主要用于 ASGI（Asynchronous Server Gateway Interface）应用，特别适合异步框架，如 FastAPI 和 Starlette。
    支持异步编程，能够处理并发请求。
2. 性能
- Gunicorn：
    通过多进程模型处理并发请求，适合 CPU 密集型任务，但在 I/O 密集型任务中表现不如 Uvicorn。
- Uvicorn：
    基于事件循环，能够高效处理 I/O 密集型任务，如网络请求和数据库操作，提供更好的性能。
3. 使用场景
- Gunicorn：
    - 适合传统的同步 Web 应用，通常与 Flask、Django 等框架搭配使用。适合需要多进程处理的场景。
- Uvicorn：
    - 适合异步 Web 应用，通常与 FastAPI、Starlette 等框架搭配使用。更适合实时应用和高并发场景。
4. 进程管理
- Gunicorn：
    - 使用多进程模型，允许多个工作进程同时运行，以处理多个请求。
- Uvicorn：
    - 支持单线程和异步处理，适合处理大量的并发请求。
5. 集成使用
- Gunicorn：
    - 可以与 Uvicorn 配合使用，作为进程管理器来运行 ASGI 应用。例如，可以通过 gunicorn 配置 UvicornWorker 来运行 FastAPI 应用。
- Uvicorn：
    - 通常单独使用，也可以与其他工具（如 daphne、hypercorn）组合以适应不同的需求。
  
<mark>Gunicorn 适合传统的同步应用，而 Uvicorn 则更适合现代异步应用。在部署时，可以根据项目需求选择合适的服务器，或结合使用以获得最佳性能。</mark>

## 注解

```cmd
# pip install monkeytype mypy
# monkeytype自动生成注解
# mypy是一个流行的Python静态类型检查工具，用于检查类型注解的一致性
# mypy是基于类型注解工作的, 没有注解的代码部分将不会受到严格的类型检查

monkeytype apply your_script.py    # 直接修改 your_script.py, 添加静态类型注解
mypy your_script.py   # 检查单个文件
mypy .  # 检查整个项目, 在项目根目录下执行
```

## 格式化输出数据

```python
json.dumps(data, indent=4, ensure_ascii=False)   # 接收非 ASCII 编码的字符，这样才能使用中文
```

## 使用any代替for循环

```python
found = any(thing == other_thing for thing in things)    # all()同理
```

## 调用类的私有方法/变量

```python
"""
在 Python 中，虽然你可以使用双下划线（__）来表示“私有”方法或属性，但这并不是一种严格的封装方式，
而是通过名称重整（name mangling）来改变方法名，使得外部无法直接访问。
名称重整的机制是将类内部的 __private 改为 _ClassName__private，从而达到一定程度的“隐藏”。
"""
class Kls():
    name = 'xuehui'
    __age = 25
    def public(self):
        print('Hello public world!')

    def __private(self):
        print('Hello private world!')

    def call_private(self):
        self.__private()


ins = Kls()
ins._Kls__private()
res = ins._Kls__age
print(res)
```

## 实现一个异步方法

```python
import asyncio

# 定义一个异步方法
async def fetch_data():
    print("开始获取数据")
    await asyncio.sleep(2)  # 模拟一个耗时的操作，比如网络请求
    print("数据获取完成")
    return {'data': 123}

# 定义一个主异步方法来运行其他异步任务
async def main():
    data = await fetch_data()  # 调用异步方法并等待其完成
    print(data)

# 运行主异步方法
asyncio.run(main())
```

## 元类

```python
# 定义元类
class MetaExample(type):
    def __new__(cls, name, bases, dct):
        # 在创建类之前动态添加类属性
        dct['auto_attribute'] = "This is an auto-generated attribute"
        
        # 定义一个自动生成的类方法
        def auto_method(cls):
            return f"{cls.__name__} says hello!"
        
        dct['auto_method'] = classmethod(auto_method)
        
        # 使用 type 创建类
        return super().__new__(cls, name, bases, dct)
    
    def __init__(cls, name, bases, dct):
        print(f"Class {name} has been created with MetaExample metaclass.")
        super().__init__(name, bases, dct)

# 使用元类创建类
class ExampleClass(metaclass=MetaExample):
    def normal_method(self):
        return "This is a normal method."

# 实例化和使用 ExampleClass
example = ExampleClass()

# 访问自动生成的类属性
print(ExampleClass.auto_attribute)  # 输出: This is an auto-generated attribute

# 调用自动生成的类方法
print(ExampleClass.auto_method())  # 输出: ExampleClass says hello!

# 调用普通方法
print(example.normal_method())  # 输出: This is a normal method.

# 检查 ExampleClass 的元类
print(type(ExampleClass))  # 输出: <class '__main__.MetaExample'>
```

## ISO 8601格式化

- %Y-%m-%dT%H:%M:%S%Z
  - 这个格式表示日期时间并包含时区的名称（如 "UTC"、"CST" 等）。
  - 例如：2024-12-17T14:30:00UTC
- %Y-%m-%dT%H:%M:%S%z
  - 这个格式表示日期时间，并包含时区的偏移量，通常以 +hhmm 或 -hhmm 形式表示，表示相对于UTC的时差。
  - 例如：2024-12-17T14:30:00+0200（表示UTC时间+2小时）
- %Y-%m-%dT%H:%M:%SZ
  - 这个格式表示日期时间，并以 "Z"（表示零时区，即UTC时间）为时区标识。
  - 例如：2024-12-17T14:30:00Z（表示UTC时间）
 
简而言之：
- `%Z` 显示时区名称（如 UTC、CST 等）。
- `%z` 显示时区的偏移量（如 +0200，表示UTC+2小时）。
- `%Z` 中的 "Z" 直接表示 UTC 时区，等同于 `%z` 中的 `+0000`
