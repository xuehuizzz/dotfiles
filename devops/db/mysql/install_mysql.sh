#!/bin/bash

# 通用 MySQL 安装脚本
# 适用于各种 Linux 发行版

# 输出彩色文本的函数
print_info() {
    echo -e "\e[1;34m[INFO]\e[0m $1"
}

print_success() {
    echo -e "\e[1;32m[SUCCESS]\e[0m $1"
}

print_error() {
    echo -e "\e[1;31m[ERROR]\e[0m $1"
}

print_warning() {
    echo -e "\e[1;33m[WARNING]\e[0m $1"
}

# 检查是否以 root 权限运行
if [ "$(id -u)" != "0" ]; then
   print_error "此脚本需要 root 权限运行"
   print_info "请使用 sudo 或以 root 用户身份运行此脚本"
   exit 1
fi

# 检测 Linux 发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
    print_info "检测到操作系统: $OS $VERSION"
else
    print_error "无法检测操作系统类型"
    exit 1
fi

# 设置默认 MySQL 密码
MYSQL_ROOT_PASSWORD=""
read -p "请设置 MySQL root 用户密码 [默认为空:]: " USER_INPUT
if [ -n "$USER_INPUT" ]; then
    MYSQL_ROOT_PASSWORD=$USER_INPUT
fi

# 根据不同的发行版安装 MySQL
case $OS in
    debian|ubuntu)
        print_info "在 Debian/Ubuntu 上安装 MySQL..."
        apt-get update
        DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-server
        
        # 检查安装是否成功
        if [ $? -eq 0 ]; then
            print_success "MySQL 安装成功"
            
            # 设置 root 密码
            mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';"
            mysql -e "FLUSH PRIVILEGES;"
            
            # 启用远程访问
            sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
            
            # 重启 MySQL 服务
            systemctl restart mysql
        else
            print_error "MySQL 安装失败"
            exit 1
        fi
        ;;
        
    centos|rhel|fedora|rocky|almalinux)
        print_info "在 CentOS/RHEL/Fedora 上安装 MySQL..."
        
        # 对于 CentOS/RHEL 8+，使用 dnf
        if [ "$OS" = "centos" ] && [ "$VERSION" -ge 8 ] || [ "$OS" = "rhel" ] && [ "$VERSION" -ge 8 ] || [ "$OS" = "rocky" ] || [ "$OS" = "almalinux" ]; then
            dnf -y install mysql-server
        # 对于 Fedora，使用 dnf
        elif [ "$OS" = "fedora" ]; then
            dnf -y install mysql-server
        # 对于 CentOS/RHEL 7，使用 yum
        else
            yum -y install mysql-server
        fi
        
        # 检查安装是否成功
        if [ $? -eq 0 ]; then
            print_success "MySQL 安装成功"
            
            # 启动 MySQL 服务
            systemctl start mysqld
            systemctl enable mysqld
            
            # 设置 root 密码
            # 对于 CentOS/RHEL 7，可能需要初始化 MySQL
            if [ "$OS" = "centos" ] && [ "$VERSION" = "7" ] || [ "$OS" = "rhel" ] && [ "$VERSION" = "7" ]; then
                mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
            else
                # 对于 CentOS/RHEL 8+，使用 mysql_secure_installation
                mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
                mysql -e "FLUSH PRIVILEGES;"
            fi
            
            # 启用远程访问
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
            
            # 配置防火墙
            if command -v firewall-cmd &> /dev/null; then
                firewall-cmd --permanent --add-port=3306/tcp
                firewall-cmd --reload
                print_info "已开放防火墙端口 3306"
            fi
        else
            print_error "MySQL 安装失败"
            exit 1
        fi
        ;;
        
    opensuse*|suse)
        print_info "在 openSUSE/SUSE 上安装 MySQL..."
        zypper -n install mysql mysql-server mysql-client
        
        # 检查安装是否成功
        if [ $? -eq 0 ]; then
            print_success "MySQL 安装成功"
            
            # 启动 MySQL 服务
            systemctl start mysql
            systemctl enable mysql
            
            # 设置 root 密码
            mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
            
            # 启用远程访问
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
        else
            print_error "MySQL 安装失败"
            exit 1
        fi
        ;;
        
    arch|manjaro)
        print_info "在 Arch Linux/Manjaro 上安装 MySQL..."
        pacman -Sy --noconfirm mysql
        
        # 检查安装是否成功
        if [ $? -eq 0 ]; then
            print_success "MySQL 安装成功"
            
            # 初始化 MySQL 数据目录
            mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
            
            # 启动 MySQL 服务
            systemctl start mysqld
            systemctl enable mysqld
            
            # 设置 root 密码
            mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
            
            # 启用远程访问
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
            mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;"
        else
            print_error "MySQL 安装失败"
            exit 1
        fi
        ;;
        
    *)
        print_error "不支持的操作系统: $OS"
        exit 1
        ;;
esac

# 验证 MySQL 是否正常运行
if systemctl is-active --quiet mysql || systemctl is-active --quiet mysqld; then
    print_success "MySQL 服务正在运行"
    print_info "MySQL 版本信息:"
    mysql --version
    
    print_info "MySQL 连接信息:"
    print_info "主机: localhost"
    print_info "端口: 3306"
    print_info "用户: root"
    print_info "密码: $MYSQL_ROOT_PASSWORD"

else
    print_error "MySQL 服务未能正常启动"
    print_info "请检查系统日志以获取更多信息"
    exit 1
fi

print_info "MySQL 安装和配置完成"
