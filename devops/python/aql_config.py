from pyArango.connection import Connection


class AQLConfig:
    def __init__(self, collection=None):
        self.database = "cmdb"
        self.collection = collection or "IPAddress"
        arangodb_dic = {"arangoURL": arango_url, "username": arango_username, "password": arango_password}

        try:
            self.ar_conn = Connection(**arangodb_dic)
            self.db = self.ar_conn.databases[self.database]
        except Exception as e:
            logger.error("数据库连接失败: %s", str(e))
            raise

    def run(self):
        try:
            update_aql = f"""xxx"""
            res = self.db.AQLQuery(update_attr_aql, rawResults=True)    # 返回的是可迭代对象

        except Exception as e:
            logger.error("修改数据时发生错误: %r", str(e))
            raise

if __name__ == "__main__":
    AQLConfig().run()
