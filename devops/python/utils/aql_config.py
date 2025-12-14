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

    def insert_data(self, data):
        # data格式为:  list[dic1, dic2, dic3, ...]
        # 已存在的文档不会插入
        if not data:
            logger.warning("数据异常, 无需插入")
        logger.info("插入数据开始")
        try:
            # 已存在的文档不会插入
            collection = self.db.collections['xxx']
            batch_size = 10000
            for i in range(0, len(data), batch_size):
                batch = data[i:i + batch_size]
                docs = [collection.createDocument(item) for item in batch]
                collection.bulkSave(docs)
                logger.info("已插入: %r 条数据", i + len(batch))

            logger.info("插入数据成功")
        except Exception as e:
            logger.error("插入数据失败: %r", e)

    def run(self):
        try:
            update_aql = f"""xxx"""
            res = self.db.AQLQuery(update_attr_aql, rawResults=True)    # 返回的是可迭代对象

        except Exception as e:
            logger.error("修改数据时发生错误: %r", str(e))
            raise

if __name__ == "__main__":
    AQLConfig().run()
