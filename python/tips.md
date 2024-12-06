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
