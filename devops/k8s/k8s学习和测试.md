## <mark>本地创建和管理k8s集群(使用minikube)</mark> 
1. **安装minikube**
    ```bash
    # https://minikube.sigs.k8s.io/docs/start  (官方文档)
    # ubuntu/debian(arm)
    sudo apt update && sudo apt install -y apt-transport-https curl
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
    sudo install minikube-linux-arm64 /usr/local/bin/minikube && rm minikube-linux-arm64

    minikube version  # 验证安装
    minikube start  # 启动minikube集群(下载并启动一个本地k8s集群)
    minikube kubectl version  # 显示kubectl客户端的版本和k8s集群的版本(即Server Version)
    minikube kubectl cluster-info  # 查看k8s集群的状态
    minikube kubectl cluster-info dump  # 查看k8s集群的详细信息
    ```
    - <font color=red>**root用户启动minikube集群失败解决方案**</font>
        1. 避免使用root用户运行minikube
            ```bash
            sudo usermod -aG docker $USER  # 切换到非root用户并将其添加到docker组
            newgrp docker  # 退出并重新登录，使组更改生效，或者运行以下命令来使更改立即生效
            minikube start  # 重新启动minikube
            ```
        2. 使用`--force`参数(如果一定要用root权限)
            ```bash
            # 如果你确实需要以 root 权限运行 Minikube，可以使用 --force 参数来强制启动 Minikube（尽管这并不推荐）
            sudo minikube start --force
            ```
        3. 使用`--driver=none`
            ```bash
            # 如果你正在使用虚拟机或者是 LXC 容器，你可以使用 --driver=none 来启动 Minikube，这样就不需要 Docker 驱动了
            sudo minikube start --driver=none
            ```
        4. 切换到docker desktop(如果适用)
            ```bash
            # 如果你使用的是 Ubuntu 作为主机并且可以使用 Docker Desktop，可以尝试切换到 Docker Desktop 驱动，并避免使用 root 权限
            minikube start --driver=docker
            ```
            
2. **安装kubectl<sub>(可选安装, minikube kubectl xxx用法一致)</sub>**
    ```bash
    # kubectl 是 Kubernetes 的命令行工具，用于与 Kubernetes 集群进行交互
    sudo apt update && apt install -y apt-transport-https curl
    wget -q https://packages.cloud.google.com/apt/doc/apt-key.gpg -O kubernetes.asc
    sudo mv kubernetes.asc /etc/apt/trusted.gpg.d/kubernetes.asc
    sudo apt-add-repository "deb https://apt.kubernetes.io/ kubernetes-$(lsb_release -c | awk '{print $2}') main"
    sudo apt update && apt install -y kubectl
    ```
    
3. **minikube 和 minikube kubectl常用命令<sub>(同kubectl用法一致)</sub>**
    `minikube kubectl -- xxx  等于  kubectl xxx`
    ```bash
    minikube start  # 启动minikube集群(即创建一个名为: minikube 的docker容器)
    minikube stop  # 停止minikube集群
    minikube delete  # 删除minikube集群
    minikube status  # 查看minikube集群状态
    minikube profile list  # # 列出所有可用的minikube配置
    minikube start -p <profile_name>  # 启动指定的配置
    minikube ip  # 获取minikube集群的ip地址
    minikube service list  # 列出minikube集群中所有可用的服务
    minikube service --all  # 列出所以服务的url,可以直接访问这些服务的外部地址
    minikube service <service_name> --url  # 查看k8s集群中指定服务的url
    
    # minikube kubectl -- get -o wide type/name  # `-o wide` 扩展输出资源的简要信息, -o 表示output, 还可以是`-o yaml`以yaml文件格式输出详细信息, `-o json`以json形式输出
    # minikube kubectl -- get type name  # type/name 都可以, 例如: kubectl get po/my-nginx, 也就是 kubectl get all 中的NAME列
    # minikube kubectl --get -w type name  # 实时监控资源状态变化
    minikube kubectl -- api-resources  # 显示所有资源的完整信息(复数形式/单数形式/缩写形式), 但首选复数形式 
    minikube kubectl -- version  # 查看kubectl客户端版本和k8s集群版本
    minikube kubectl -- get all  # 查看所以pod和服务
    minikube kubectl -- get namespaces  # 列出所有命名空间
    minikube kubectl -- cluster-info  # 查看本地k8s集群信息, 输出k8s control plane和CoreDNS地址, 其中ip为minukube容器的网络地址
    minikube kubectl -- cluster-info dump  # 查看集群详细信息
    minikube kubectl -- config use-context minikube  # 将kubectl的上下文切换到minikube集群
    minikube kubectl -- get nodes  # 获取minikube集群的k8s配置信息
    minikube kubectl -- run <pod_name> --image=nginx --restart=Never  # 创建pod, 名称必须以字母或数字开头和结尾, 且只能包含小写字母(a-z),数字(0-9)和短横线(-)
    minikube kubectl -- get replicasets  # 列出所有控制器对象
    minikube kubectl -- get pods  # 列出所有pod
    minikube kubectl -- get pods -A  # 列出所有命名空间下的pod, 等于 --all-namespaces
    minikube kubectl -- get pods -n <namespace>  # 指定查看, kubectl get pods -n <namespace>
    minikube kubectl -- get services --all-namespaces  # 查看所有命令空间下的服务
    minikube kubectl -- get services  # 查看当前命名空间下的服务, minikube kubectl get svc(简写)
    minikube kubectl -- delete all --all   # 删除当前命名空间内所有资源
    minikube kubectl -- delete all --all -n <namespace-name> # 删除指定命名空间下的所有资源
    minikube kubectl -- describe type name  # 查看特定k8s资源的详细信息
    minikube kubectl -- get events --watch-only  # 实时观察 Kubernetes 集群中事件流, --watch-only：开启“观察模式”，显示实时新增的事件，而不会列出已有事件


    # 查看日志, type/name, 仅支持这种写法, 不能用空格, 
    # kubectl logs只针对pod, 只有pod会产生日志, 
    # 所以尽管查看的是deploy/my-nginx, 实际上输出的也是my-nginx这个deployment管理的pod的日志
    minikube kubectl -- logs type/name   # 查看k8s资源对象的日志, 只能用/分隔开, 不能用空格
    minikube kubectl -- logs type/name -f --tail 1  # 实时查看日志, 并只显示最近1条, -1 显示所有
    minikube kubectl -- logs pod/pod-name -c container-name  # 查看pod中的容器的日志
    minikube kubectl --logs pot/pod-name --all-containers=true  # 查看pod中所有容器日志
    minikube kubectl -- logs -l app=<pod-label>   # 指定pod label查看日志
    ```
4. **Pod**
    定义: `pod是k8s部署和管理容器化应用的最小单位. 是一个或多个容器的集合, 共享一个网络命名空间(IP地址和端口空间)以及存储卷(Volumes)`
    命名规范:
    - 仅允许使用小写字母(`a-z`)、数字(`0-9`)和短横线(`-`)
    - 不能以短横线开头或结尾, 最大长度为**253个字符**, 必须是有效的DNS子域名称
    - 名称唯一, 不能重复
    ```bash
    # 使用kubectl创建Pod
    kubectl run my-nginx --image nginx  # 或者 --image=nginx, 创建一个名为my-nginx的pod, 并使用nginx镜像
    kubectl apply -f pod.yaml  # 基于yaml文件创建或更新pod
    
    # 删除pod
    kubectl delete pod <pod-name>  # 删除pod, 支持多个删除, --grace-period=0 --force 强制删除
    kubectl delete pod --all  # 删除所有pod
    kubectl delete pod --all -n <namespace>  # 删除指定命名空间下的所有pod
    kubectl ddelete -f <file-name>.yaml  # 删除通过yaml文件创建的pod
    
    # 查看pod的信息
    kubectl describe pod  # 查看所有pod及其容器的详情, 加上 <pod-name> 则指定查看
    
    # 查看日志
    kubectl logs <pod-name>  # 查看pod的容器日志
    kubectl logs <pod-name> -c <container-name>  # 查看指定容器的日志（如果 Pod 有多个容器）
    
    # 进入pod内部
    kubectl exec -it <pod-name> -- bash
    ```
5. **Deployment**
    Deployment是一种k8s资源类型,用于管理和部署应用程序的容器化实例. 
    它主要用于：
    - 声明式管理容器应用程序: 定义应用程序应该运行的容器映像、实例数量、副本数量等。
    - 自动化部署与回滚: 支持版本更新、回滚到以前的版本，保证服务的高可用性。
    - 水平扩展: 根据需求调整Pod 副本的数量来满足负载需求。
    - 自愈能力: 如果某些 Pod 异常退出或不可用，Deployment 会自动重新创建它们。
    - 命名规范同pod
    ```bash
    # 创建deployment, 当创建一个 Deployment 时，它会自动创建关联的 Pod 和 ReplicaSet
    # pod的数量默认为1(未指定deploy副本数的话), replicaset也是1个
    # 名称为deploymentname-hash值
    kubectl create deployment my-nginx --image nginx  # 执行该命令后, k8s会创建一个deployment, 并启动一个nginx容器(使用nginx镜像). 默认情况下, deployment会创建一个pod, 并将其副本数设置为1, 除非在命令中显示指定副本数
    # kubectl create deployment my-apache --image httpd --replicas 5  # --replicas 是指定副本数, 也就是说会启动 5 个, 名为my-apache的pod
    
    # 修改deployment的副本数(pod数量)
    kubectl scale deploy my-apache --replicas 2  # 将名为 my-apache 的deploy的副本数设置为2(不管原来是多少)
    
    # 删除deploy
    kubectl delete deployment <deployment-name>  # 删除一个deployment(同时把附带的pod也会删除掉)
    ```
6. **exposing k8s ports**
    ```bash
    # 将名为my-nginx的k8s部署(deploy)暴露为一个服务(service),并通过指定的端口(8888)对外提供访问
    kubectl expose deployment/my-nginx --port 8888 
    
    # 在k8s集群中创建并启动一个名为tmp-shell的pod, 使用bretfisher/netshoot镜像,并在该容器中启动一个 Bash shell 供用户进行操作。容器终止后会自动删除
    kubectl run tmp-shell --rm -it --image bretfisher/netshoot -- bash 
    
    # create d nodeport service
    kubectl expose deployment/httpenv --port 8888 --name httpenv-np --type NodePort
    
    # 删除服务
    kubectl delete type/name  # 可同时删除多个, kubectl delete type/name type/name
    
    ```
