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
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg   # 首先添加 Kubernetes GPG 密钥
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list  # 添加 Kubernetes apt 仓库
    sudo apt update && sudo apt install -y kubelet kubeadm kubectl  # 更新apt包索引并安装
    
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
4. **初始化k8s集群**
    ```bash
    kubeadm config print init-defaults > kubeadm-init-temp.yaml  # 生成默认的 Kubernetes 初始化配置文件
    sudo kubeadm init --config kubeadm-init-temp.yaml  # 自定义修改文件后初始化k8s集群
    ```
5. **更新/删除仓库配置**
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
