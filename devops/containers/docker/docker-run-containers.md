1. **mysql**
  - ```bash
    docker run -d \
    --name mysql \
    -e MYSQL_ROOT_PASSWORD=admin \
    -e MYSQL_USER=admin \
    -e MYSQL_PASSWORD=admin \
    -e MYSQL_DATABASE=mydb \
    -v /Users/xuehuizzz/db/mysql:/var/lib/mysql \
    -p 127.0.0.1:3306:3306 \
    --restart always \
    mysql:8.4
    ```
2. **postgresql**
  - ```bash
    docker run -d \
    --name psql \
    -e POSTGRES_USER=admin \
    -e POSTGRES_PASSWORD=admin \
    -e POSTGRES_DB=mydb \
    -v /Users/xuehuizzz/db/postgresql:/var/lib/postgresql \
    -p 127.0.0.1:5432:5432 \
    --restart always \
    postgres:18
    ```
3. **jenkins**
  - ```bash
    docker run -d \
    --name jenkins \
    -p 127.0.0.1:8080:8080 \
    -p 127.0.0.1:50000:50000 \
    -v /Users/xuehuizzz/jenkins:/var/jenkins_home \
    --restart always \
    jenkins/jenkins:lts
    ```
4. **arangodb**
  - ```bash
    docker run -e ARANGO_ROOT_PASSWORD=admin \
    -d --name arangodb \
    -p 127.0.0.1:8529:8529 \
    -v /Users/xuehuizzz/db/arango/data:/var/lib/arangodb3 \
    -v /Users/xuehuizzz/db/arango/apps:/var/lib/arangodb3-apps \
    --restart always \
    arangodb:latest
    ```
