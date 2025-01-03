1. **psql**
  - ```bash
    docker run -d \
    --name mysql \
    -e MYSQL_ROOT_PASSWORD=admin \
    -e MYSQL_USER=admin \
    -e MYSQL_PASSWORD=admin \
    -e MYSQL_DATABASE=mydb \
    -v /Users/xuehuizzz/db/mysql:/app \
    -p 3306:3306 \
    -w /app \
    --restart always \
    mysql:8.4
    ```
2. **mysql**
  - ```bash
    docker run -d \
    --name psql \
    -e POSTGRES_USER=admin \
    -e POSTGRES_PASSWORD=admin \
    -e POSTGRES_DB=mydb \
    -v /Users/xuehuizzz/db/postgresql:/app \
    -p 5432:5432 \
    -w /app \
    --restart always \
    postgres:15
    ```
3. **jenkins**
  - ```bash
    docker run -d \
    --name jenkins \
    -p 8080:8080 \
    -p 50000:50000 \
    -v /Users/xuehuizzz/jenkins:/var/jenkins_home \
    --restart always \
    jenkins/jenkins:lts
    ```
