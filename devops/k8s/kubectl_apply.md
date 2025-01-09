#### 该笔记记录如何使用文件形式创建/更新k8s资源
## 创建一个Pod(pod.yaml)
```yaml
apiVersion: v1   # 指定核心资源的api版本,k8s中的 API 是按资源和功能模块分组管理的，核心资源(如 Pod、Service)属于核心API组, 其版本为 v1
kind: Pod  # 定义资源的类型, `Pod`表示这是一个Pod配置
metadata:  # 定义资源的元数据, 例如: 名称、标签、注释..
  name: my-pod  # 声明Pod的名称, 该名称在同一个命名空间内唯一
  labels:              # 定义标签，用于组织和筛选资源
    app: my-app        # 标签键值对，表示这个 Pod 属于 "my-app" 应用
    env: production    # 标签键值对，表示这个 Pod 运行在生产环境
  annotations:         # 定义注释，用于存储非标识性、附加的信息
    description: "This is my first nginx pod"  # 注释可以是任何信息
    owner: "team-dev"  # 表示资源所有者的信息
spec:   # 定义资源的规格, 描述资源的具体行为和属性
  containers:  # 定义Pod的容器列表, 一个Pod可以包含一个或多个容器
  - name: nginx   # 声明容器的名称, 在Pod内部也是唯一
    image: nginx  # 指定容器运行的镜像, 默认会从docker hub拉取
```

## 创建一个Deployment(deployment.yaml)
```yaml
# Deployment 用于管理和扩展 Pod 的副本集，保证系统的高可用性。
apiVersion: apps/v1   # 指定该资源的API版本
kind: Deployment  # 定义资源的类型
metadata:  # 定义资源的元数据, 例如: 名称、标签、注释..
  name: nginx-deployment   # 声明deploy的名称, 在同一命名空间内唯一
spec:  # 定义 Deployment 的具体配置，包括副本数量、选择器规则、Pod 模板等
  selector:   # 定义 Pod 的选择器规则，用于匹配 Pod 和 Deployment
    matchLabels:  # 指定要匹配的标签
      app: nginx  # 表示只管理带有 app=nginx 标签的 Pod
  replicas: 2  # 表示在该deploy中有2个pod副本
  template:   # 指定 Pod 的模板，用于定义 Pod 的配置（标签、容器等）
    # 以下配置信息和pod.yaml一样
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

```
