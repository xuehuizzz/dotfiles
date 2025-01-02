## <mark>本地创建和管理k8s集群(使用minikube)</mark> 
<mark>minikube用于在本地环境中学习和测试 Kubernetes，但它并不适合在生产环境中搭建 Kubernetes 集群.</mark>
1. **安装minikube**
    ```bash
    # https://minikube.sigs.k8s.io/docs/start  (官方文档)
    # ubuntu/debian(arm)
    sudo apt update && sudo apt install -y apt-transport-https curl
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-arm64
    sudo install minikube-linux-arm64 /usr/local/bin/minikube && rm minikube-linux-arm64

    minikube version  # 验证安装
    minikube start  # 启动minikube集群(下载并启动一个本地k8s集群)
    minikube kubectl version  # 显示kubectl客户端的版本和k8s集群的版本(用法同kubectl)
    minikube kubectl cluster-info  # 查看k8s集群的状态
    minikube kubectl cluster-info dump  # 查看k8s集群的详细信息
    ```
    - root用户启动minikube集群失败解决方案
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
    # 推荐使用snap安装(它不依赖具体的系统库版本), 
    sudo apt update && apt install -y snapd  # 确保系统安装了snapd
    sudo snap install kubectl --classic    
    kubectl version  # 验证安装
    ```
    
3. **minikube 和 minikube kubectl常用命令<sub>(同kubectl用法一致)</sub>**
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
    
    minikube kubectl version  # 查看kubectl客户端版本和k8s集群版本
    minikube kubectl cluster-info  # 查看本地k8s集群信息, 输出k8s control plane和CoreDNS地址, 其中ip为minukube容器的网络地址
    minikube kubectl cluster-info dump  # 查看集群详细信息
    minikube kubectl config use-context minikube  # 将kubectl的上下文切换到minikube集群
    minikube kubectl get nodes  # 获取minikube集群的k8s配置信息
    minikube kubectl -- run <pod_name> --image=nginx --restart=Never  # 创建pod, 名称必须以字母或数字开头和结尾, 且只能包含小写字母(a-z),数字(0-9)和短横线(-)
    minikube kubectl get pods  # 列出所有pod, 
    minikube kubectl -- get pods -n <namespace>  # 指定查看, kubectl get pods -n <namespace>
    minikube kubectl -- get services --all-namespaces  # 查看所有命令空间下的服务
    minikube kubectl get services  # 查看当前命名空间下的服务, minikube kubectl get svc(简写)
    minikube service <service_name> --url  # 查看k8s集群中指定服务的url
    
    
    ```
