### 合并列表
```python
a, b = [1, 2], [2, 3]
c = [*a, *b]   # 使用内存更少, 比起 + , 不需复制2个列表的所有元素
```

### list(dict) 去重
```python
# 原始字典列表
dict_list = [
    {'name': 'Tom', 'age': 20},
    {'name': 'Jerry', 'age': 18},
    {'name': 'Tom', 'age': 20}
]

# 方法1：使用 frozenset 去重
unique_dicts = list({frozenset(d.items()): d for d in dict_list}.values())
```
