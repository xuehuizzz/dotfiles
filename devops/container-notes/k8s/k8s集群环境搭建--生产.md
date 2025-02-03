1. **环境准备**
    ```bash
    # 关闭交换分区：Kubernetes 要求禁用 swap
    sudo swapoff -a && sudo sed -i '/ swap / s/^/#/' /etc/fstab  # 禁用swap并关闭开机自启
    
    #Kubernetes 需要容器运行时，常用 Docker 或 containerd
    # 安装docker
    sudo curl -fsSL https://get.docker.com | sudo sh  # 官方安装脚本
    sudo systemctl start docker   # 开启docker服务
    sudo systemctl enable docker  # 设置开机自启
    sudo usermod -aG $USER  # 将当前用户添加到docker组
    newgrp docker  # 修改当前会话的组为docker
    
    # 更新系统并安装基本依赖
    # 更新系统包
    sudo apt update && sudo apt upgrade -y   # Ubuntu/Debian
    sudo yum update -y                       # CentOS
    
    # 安装基础依赖
    # Ubuntu/Debian
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common conntrack ethtool containerd cgroup-tools 
    # CentOS
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2 conntrack ethtool containerd libcgroup-tools
    ```
2. **安装kubeadm、kubelet和kubectl**
    ```bash
    # 配置官方k8s仓库安装
    # ubuntu
    # 首先添加 Kubernetes GPG 密钥
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    # 添加 Kubernetes apt 仓库
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    # 更新apt包索引并安装
    sudo apt update && sudo apt install -y kubelet kubeadm kubectl  
    
    # centos
    
    
    # 使用snap安装
    sudo apt update && sudo apt install -y snapd  # 确保系统安装了snapd
    sudo snap install kubeadm kubelet kubectl --classic 
    sudo kubeadm version  # 验证安装
    sudo kubelet --version  # 验证安装
    sudo kubectl version  # 验证安装
    
    sudo systemctl enable kubelet  # 设置开机启动
    sudo systemctl start kubelet   # 启动kubelet服务
    ```
3. **安装crictl**
    ```bash
    # https://github.com/kubernetes-sigs/cri-tools/releases/
    # 使用crictl调试k8s节点
    # crictl专门用于与 Kubernetes 集群中运行的容器运行时接口 (CRI, Container Runtime Interface) 交互, 最常用
    wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.32.0/crictl-v1.32.0-linux-arm64.tar.gz
    tar -zxvf crictl-v1.32.0-linux-arm64.tar.gz
    sudo mv crictl /usr/local/bin/
    ```
4. **设置Docker守护进程**
    - 设置 Docker 使用 systemd 作为 cgroup 驱动
        ```jsonc
        {
            /*
            /etc/docker/daemon.json
            在使用 Kubernetes 的环境中，建议将 Docker 的 cgroup 驱动设置为 systemd ，因为：
            1. 如果系统使用 systemd 作为 init 系统，使用 systemd 作为 cgroup 驱动会更加稳定
            2. 这样可以确保 kubelet 和 Docker 使用相同的 cgroup 驱动，避免资源管理冲突
            */
            "exec-opts": ["native.cgroupdriver=systemd"]
        }
        ```
    - 重启服务生效
        ```bash
        sudo systemctl daemon-reload  # 重新加载配置
        sudo systemctl restart docker  # 重启Docker服务
        
        # 验证是否配置成功
        docker info | grep "Cgroup Driver"
        ```
5. **安装containerd**
    ```bash
    # 在使用 kubeadm 搭建 Kubernetes 集群时, 需要安装容器运行时(Container Runtime), 而 containerd是当前推荐的容器运行时之一
    
    sudo apt-get update && apt-get install -y containerd
    mkdir -p /etc/containerd
    containerd config default > /etc/containerd/config.toml
    sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
    systemctl restart containerd
    ```
6. **初始化k8s集群**
    ```bash
    kubeadm config print init-defaults > kubeadm-init-temp.yaml  # 生成默认的 Kubernetes 初始化配置文件
    # 替换kubeadm-init-temp.yaml文件中 advertiseAddress 为 <你的实际 IP>
    sudo kubeadm init --config kubeadm-init-temp.yaml  # 自定义修改文件后初始化k8s集群
    
    # 验证是否成功
    kubectl get pods -n kube-system
    ```
    <mark>报错异常解决: </mark>
    ```bash
    若有以下错误:
    [ERROR FileAvailable--etc-kubernetes-manifests-kube-apiserver.yaml]: /etc/kubernetes/manifests/kube-apiserver.yaml already exists
    [ERROR FileAvailable--etc-kubernetes-manifests-kube-controller-manager.yaml]: /etc/kubernetes/manifests/kube-controller-manager.yaml already exists
    [ERROR FileAvailable--etc-kubernetes-manifests-kube-scheduler.yaml]: /etc/kubernetes/manifests/kube-scheduler.yaml already exists
    [ERROR FileAvailable--etc-kubernetes-manifests-etcd.yaml]: /etc/kubernetes/manifests/etcd.yaml already exists
    [ERROR DirAvailable--var-lib-etcd]: /var/lib/etcd is not empty

    解决方案如下:
    rm -rf /etc/kubernetes/manifests/kube-apiserver.yaml
    rm -rf /etc/kubernetes/manifests/kube-controller-manager.yaml
    rm -rf /etc/kubernetes/manifests/kube-scheduler.yaml
    rm -rf /etc/kubernetes/manifests/etcd.yaml
    rm -rf /var/lib/etcd/*     
    kubeadm reset -f
    sudo kubeadm init --config kubeadm-init-temp.yaml   # 重新初始化即可
    ```
7. **更新/删除仓库配置**
    - 更新仓库版本
    ```bash
    # 首先备份原有的密钥和配置（可选但推荐）
    sudo cp /etc/apt/keyrings/kubernetes-apt-keyring.gpg /etc/apt/keyrings/kubernetes-apt-keyring.gpg.bak
    sudo cp /etc/apt/sources.list.d/kubernetes.list /etc/apt/sources.list.d/kubernetes.list.bak
    # 删除旧的秘钥
    sudo rm /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    # 下载新版本的密钥
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    # 更新仓库配置
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    # 更新包索引
    sudo apt update
    ```
    - 删除仓库配置
    ```bash
    # 删除仓库秘钥
    sudo rm /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    # 删除仓库配置文件
    sudo rm /etc/apt/sources.list.d/kubernetes.list
    # 更新包索引并卸载
    sudo apt update && sudo apt remove kubelet kubeadm kubectl
    ```
8. <font color=red>**加入工作节点到集群**</font>
    命令格式如下: 
    <mark>kubeadm join <ip>:<port> --token <token> --discovery-token-ca-cert-hash sha256:<证书哈希值></mark>
    ```bash
    kubeadm token list  # 在主节点（控制平面）上查看现有的 token
    ```
    - token过期
    ```bash
    # 直接输出一个完整的、可用的 join 命令，包含新的 token 和证书哈希值。你可以直接复制这个命令在新的工作节点上执行
    kubeadm token create --print-join-command
    ```
    - token未过期
    ```bash
    # token未过期的话, 可直接使用
    # 查看证书哈希值
    openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
    
    # 拼接join命令使用即可
    ```
