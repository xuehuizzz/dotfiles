#!/bin/bash

# 获取项目名称作为参数, e.g.  ./create_project.sh your_project_name
if [ $# -eq 0 ]; then
    echo "请提供项目名称作为参数"
    echo "使用方法: $0 project_name"
    exit 1
fi

PROJECT_NAME=$1

# 创建主要目录结构
mkdir -p $PROJECT_NAME/{docs,tests,samples,scripts,$PROJECT_NAME/{core,utils,config}}

# 创建文件
touch $PROJECT_NAME/.gitignore
touch $PROJECT_NAME/.env
touch $PROJECT_NAME/README.md
touch $PROJECT_NAME/requirements.txt
touch $PROJECT_NAME/setup.py
touch $PROJECT_NAME/pyproject.toml
touch $PROJECT_NAME/Makefile

# 创建 docs 目录下的文件
touch $PROJECT_NAME/docs/conf.py
touch $PROJECT_NAME/docs/index.rst

# 创建测试目录下的文件
touch $PROJECT_NAME/tests/__init__.py
touch $PROJECT_NAME/tests/test_example.py

# 创建主源代码目录下的文件
touch $PROJECT_NAME/$PROJECT_NAME/__init__.py
touch $PROJECT_NAME/$PROJECT_NAME/__main__.py
touch $PROJECT_NAME/$PROJECT_NAME/core/__init__.py
touch $PROJECT_NAME/$PROJECT_NAME/utils/__init__.py
touch $PROJECT_NAME/$PROJECT_NAME/config/__init__.py

# 添加基本的 .gitignore 内容
cat > $PROJECT_NAME/.gitignore << EOF
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
.env
.venv
venv/
ENV/
.idea/
.vscode/
EOF

# 添加基本的 README.md 内容
cat > $PROJECT_NAME/README.md << EOF
# $PROJECT_NAME

## 描述
这是 $PROJECT_NAME 项目的简要描述。

## 安装
\`\`\`bash
pip install -e .
\`\`\`

## 使用方法
待补充

## 许可证
待补充
EOF

# 添加基本的 setup.py 内容
cat > $PROJECT_NAME/setup.py << EOF
from setuptools import setup, find_packages

setup(
    name="$PROJECT_NAME",
    version="0.1.0",
    packages=find_packages(),
    install_requires=[
        # 在这里添加项目依赖
    ],
)
EOF

# 添加基本的 pyproject.toml 内容
cat > $PROJECT_NAME/pyproject.toml << EOF
[build-system]
requires = ["setuptools>=42", "wheel"]
build-backend = "setuptools.build_meta"

[tool.black]
line-length = 88
target-version = ['py37']
include = '\.pyi?$'

[tool.isort]
profile = "black"
multi_line_output = 3
EOF

# 添加基本的 Makefile 内容
cat > $PROJECT_NAME/Makefile << EOF
.PHONY: install test clean

install:
	pip install -e .

test:
	pytest tests/

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
EOF

echo "项目 $PROJECT_NAME 创建完成！"
