## 配置免密登录认证(使用 SSH 密钥认证)

##### 1).生成 SSH 密钥

- 打开终端并运行以下命令（按提示操作）：
  ```cmd
  ssh-keygen -t ed25519 -C "your_email@example.com"

  " -t 参数指定生成的密钥类型。未指定的话, 默认是 rsa 算法
  " ed25519 是一种现代的加密算法，基于椭圆曲线 EdDSA，具有以下优点：
  "        安全性更高。
  "        性能更优（生成速度和验证速度都比传统算法快）。
  "        密钥文件更小。
  " -C 参数为生成的公钥添加注释, 一般是电子邮件地址
  ```
- 将生成的公钥保存到默认路径（通常是 ~/.ssh/id_ed25519）。会有询问, 直接回车即可
- 运行后发生的事情:
  - 会有询问选择保存生成密钥对的位置, 默认路径为 `~/.ssh/id_ed25519` 和 `~/.ssh/id_ed25519.pub`, 你可以按 Enter 使用默认路径，也可以指定一个自定义路径
  - 询问是否设置密码：设置密码可以为私钥增加一层保护。如果私钥被盗但有密码，攻击者仍需解锁私钥。如果不需要密码保护，可以直接按 Enter。
  - 生成密钥对:
     - 私钥文件（默认 id_ed25519）：存储你的私钥，仅你自己拥有，绝对不能泄露。
     - 公钥文件（默认 id_ed25519.pub）：存储你的公钥，用于共享给服务器或协作方。

##### 2).添加 SSH 密钥到 GitHub：

- 复制公钥
  ```cmd
  cat ~/.ssh/id_ed25519.pub
  ```
- 打开 GitHub SSH 设置页面，点击 "New SSH key"。粘贴公钥内容并保存。

##### 3).验证 SSH 配置：

- 验证 SSH 配置：
  ```cmd
  ssh -T git@github.com
  ```
- 如果配置正确，会看到类似以下内容：
  ```bash
  Hi xuehuizzz! You've successfully authenticated, but GitHub does not provide shell access.
  ```

##### 4).更新 Git 仓库 URL：

- 切换到 SSH URL：
  ```cmd
  git remote set-url origin git@github.com:xuehuizzz/dotfiles.git
  ```
- 然后再试 git push, 会将本地当前分支的提交推送到远程仓库中与其 关联的分支, 也可指定: git push origin branch_name
