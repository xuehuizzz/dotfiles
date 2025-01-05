"""arangodb通用脚本
pip install python-arango
"""
from arango import ArangoClient


client = ArangoClient()

# 假设 ArangoDB 在默认地址（localhost:8529）
db = client.db(
    name='cmdb',   # 数据库名称
    username='root',   # 登录用户名
    password='admin'   # 登录用户密码
)


# 查询文档
query = 'FOR doc IN users RETURN doc'
cursor = db.aql.execute(query)  # 返回的是一个可迭代对象
for i in cursor:
    print(i)

