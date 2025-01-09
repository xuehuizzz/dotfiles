#### <mark>kubectl apply介绍</mark>
k8s中`的kubectl apply -f file`命令用于创建和更新资源, 此命令可保证配置的一致应用, 使其具有幂等性, 这意味着您可以多次运行它而不会造成意外影响.
- **Create**: 如果yaml文件中指定的资源(Pod、Deployment、Service等)不存在, `kubectl apply`将创建它
- **Update**: 如果资源已经存在， kubectl apply将更新它以匹配 YAML 文件中定义的所需状态。它应用更改，无需显式删除现有资源并重新创建它

## 创建一个Pod(pod.yaml)
```yaml
apiVersion: v1   # 指定核心资源的api版本,k8s中的 API 是按资源和功能模块分组管理的，核心资源(如 Pod、Service)属于核心API组, 其版本为 v1
kind: Pod  # 定义资源的类型, `Pod`表示这是一个Pod配置
metadata:  # 定义资源的元数据, 例如: 名称、标签、注释..(only name is required)
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
metadata:  # 定义资源的元数据, 例如: 名称、标签、注释..(only name is required)
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

## 创建一个Service(service.yaml)
```yaml
apiVersion: v1   # 指定资源的API版本
kind: Service    # 资源类型
metadata:        # 资源元数据(only name is required)
  name: my-service   # 同一命名空间名称唯一
spec:
  selector:  # 指定 Service 选择的目标 Pod
    app: my-app  # 匹配所有带有 app: my-app 标签的 Pod。Service 会将流量转发给这些 Pods
  ports:
    - protocol: TCP   # 指定使用的协议
      port: 80        # 声明service暴漏的端口
      targetPort: 8080  # 后端 Pod 上的端口，Service 会将请求从 port 转发到该端口(targetPort可以是数字或容器的端口名称)
  type: ClusterIP   # 定义 Service 的类型，决定如何访问这个 Service
        # ClusterIP: 默认值，提供集群内部的访问
        # NodePort: 在每个节点上暴露一个端口，用于外部访问
        # LoadBalancer: 创建一个外部负载均衡器
        # ExternalName: 通过 DNS 名称代理流量
```

### <font color=red>常用命令</font>
```bash
kubectl apply -f xxx.yaml   # 创建/更新资源

```
