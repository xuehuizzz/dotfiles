1.==使用save和load导出并导入镜像==

```markdown
# 导出镜像
docker save -o [导出文件名].tar [镜像名称]:[标签]
    docker save -o my_image.tar my_image:latest
# 导入镜像    
docker load -i [导入文件名].tar
    docker load -i my_image.tar
```

2.==使用export和import导出并导入容器文件系统为镜像==

```markdown
# 导出容器文件
docker export -o [导出文件名].tar [容器ID或名称]
    docker export -o my_container.tar my_container
# 导入容器文件为镜像
docker import [导入文件名].tar [新镜像名称]:[标签]
    docker import my_container.tar my_new_image:latest
```

