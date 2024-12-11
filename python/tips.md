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
