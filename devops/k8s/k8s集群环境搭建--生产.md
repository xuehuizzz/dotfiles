1. **环境准备**
    ```bash
    # 关闭交换分区：Kubernetes 要求禁用 swap
    sudo swapoff -a  # 禁用 swap
    sed -i '/ swap / s/^/#/' /etc/fstab  # 确保开机时不启用 swap
    
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
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common  # Ubuntu/Debian
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2  # CentOS
    ```
2. **安装kubeadm、kubelet和kubectl**
    ```bash
    sudo apt update
    sudo apt install -y snapd  # 确保系统安装了snapd
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
