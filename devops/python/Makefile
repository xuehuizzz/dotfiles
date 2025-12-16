# settings.py  读取环境变量（这是唯一的接口）
# =================================================
# import os
# from pydantic_settings import BaseSettings

# ENV_FILE = os.getenv("ENV_FILE", ".env.local")

# class Settings(BaseSettings):
#     app_env: str = "local"
#     web_url: str
#     db_url: str

#     class Config:
#         env_file = ENV_FILE

# settings = Settings()
# =================================================


# 只需记住如下命令即可
make run-local
make test
# ====



.PHONY: run-local run-test run-prod test lint

run-local:
	ENV_FILE=.env.local python app.py

run-test:
	ENV_FILE=.env.test python app.py

run-prod:
	APP_ENV=prod CONFIRM_PROD=YES python app.py

test:
	ENV_FILE=.env.test pytest -q

lint:
	ruff check .
