#!/bin/bash

# 获取项目名称作为参数, e.g.  ./create_project.sh your_project_name
if [ $# -eq 0 ]; then
    echo "请提供项目名称作为参数"
    echo "使用方法: $0 project_name"
    exit 1
fi

PROJECT_NAME=$1

# 创建主要目录结构
mkdir -p $PROJECT_NAME/{docs,deploy,tests,samples,scripts,$PROJECT_NAME/{core,utils,config}}

# 创建文件
touch $PROJECT_NAME/.gitignore
touch $PROJECT_NAME/.env
touch $PROJECT_NAME/.editorconfig
touch $PROJECT_NAME/README.md
touch $PROJECT_NAME/requirements.txt
touch $PROJECT_NAME/setup.py
touch $PROJECT_NAME/pyproject.toml
touch $PROJECT_NAME/Makefile

# 创建 docs 目录下的文件
touch $PROJECT_NAME/docs/conf.py
touch $PROJECT_NAME/docs/index.rst

# 创建 deploy 目录下的文件
touch $PROJECT_NAME/deploy/Dockerfile
touch $PROJECT_NAME/deploy/docker-compose.yaml

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

# 添加基本的 requirements-dev.txt 内容
cat > $PROJECT_NAME/requirements-dev.txt << EOF
# 开发依赖
pytest>=6.2.0
pytest-cov>=2.10.1
black>=20.8b1
ruff>=0.0.270
mypy>=0.800
sphinx>=3.4.0
pre-commit>=2.9.3
python-dotenv>=0.15.0
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

[tool.ruff]
# 启用 isort 规则
select = ["E", "F", "I"]
line-length = 88
target-version = "py37"
# 排序导入
fix = true
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

# 添加基本的 editorconfig 文件内容
cat > $PROJECT_NAME/.editorconfig << EOF
root = true 

[*]
indent_style = space   # tab or space
end_of_line = lf   # 设置换行符的类型,lf（Unix 风格）、cr（Mac 风格）或 crlf（Windows 风格）
insert_final_newline = true  # 设置是否在文件末尾插入一个空行
charset = utf-8  # 设置文件编码
trim_trailing_whitespace = true  # 设置是否删除行尾空白字符
max_line_length = 100  # 设置每行的最大字符数 

[*.py]
indent_size = 4  # 设置每个缩进级别的空格数

[*.go]
indent_style = tab
indent_size = 4
tab_width = 4

[Makefile]
indent_style = tab

[*.{css,html,js,json,jsx,scss,ts,tsx,yaml,yml}]
indent_size = 2

[**.{md,rst}]
trim_trailing_whitespace = false

[.git*]
indent_size = tab
indent_style = tab

[{**.*sh,test/run,**.bats}]
indent_size = tab
indent_style = tab

shell_variant      = bash
binary_next_line   = true  # like -bn
switch_case_indent = true  # like -ci
space_redirects    = true  # like -sr
keep_padding       = false # like -kp
end_of_line        = lf
charset            = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[**.bats]
indent_size = tab
indent_style = tab
shell_variant	= bats
EOF
echo "项目 $PROJECT_NAME 创建完成！"
