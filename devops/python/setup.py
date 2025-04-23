"""     
开发时安装项目
pip install -e .

生产部署项目,以docker部署为例, 在dockerfile中配置, project_name下须有 __main__.py 文件
CMD ["python", "-m", "project_name"]


什么时候需要重新执行?
     当你修改了 setup.py 的配置（比如添加了新的依赖）
     当你修改了 pyproject.toml 的配置
     当你完全删除了之前的安装
"""
from setuptools import setup, find_packages

setup(
    name="project_name",  # 包的名字
    version="0.1",
    packages=find_packages(exclude=["tests*", "samples*"]),  # 排除以 xxx开头的包
    # package_dir={"": "src"},  # 如果是 project_name/src/project_name 结构才需要配置, project_name/project_name则不需要
)
