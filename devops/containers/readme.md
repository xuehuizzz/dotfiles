# Dockerfile语法检测
```bash
# macos
brew install hadolint

# linux
wget -O /usr/local/bin/hadolint https://github.com/hadolint/hadolint/releases/latest/download/hadolint-$(uname -s)-$(uname -m)
chmod +x /usr/local/bin/hadolint

# use
hadolint Dockerfile
```

# 镜像瘦身
```bash
# 使用Homebrew安装
brew install docker-slim
# 使用curl安装(适用于 MacOS/Linux)
curl -L -O https://downloads.dockerslim.com/releases/1.40.5/dist_mac.tar.gz
tar -xvf dist_mac.tar.gz
mv dist_mac/docker-slim /usr/local/bin/
mv dist_mac/docker-slim-sensor /usr/local/bin/

# 基本使用
docker-slim build --http-probe=false --continue-after=exec 镜像ID or name:tag
```

# 镜像漏洞扫描工具(Trivy)
```bash
# 安装
brew install trivy

# 基于容器镜像扫描
trivy image ffmpeg:v1

# 基于dockerfile扫描
trivy config Dockerfile
```
