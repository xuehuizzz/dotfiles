git config --global pull.rebase true   # 全局配置, 这样，当你运行 git pull 时，Git 会自动使用 --rebase
git pull --rebase  # 获取远程分支的最新更新。 将你的本地提交从远程分支的最新状态“重放”到当前分支之上，而不是直接合并
git pull 等同于 (git fetch git marge)

git config --list   # 查看已有的配置信息
git config --global user.name "your name"  # 设置用户
git config --global user.email "your email"  # 设置邮箱
git status    # 查看当前文件状态
git clone xxx   # 从现有仓库克隆
git add xxx  # 跟踪新文件
git branch name  # 新建分支
git branch -d name  # 删除分支
git checkout branch_name  # 切换分支, git checkout -b name 新建并切换分支
git merge branch_name  # 把指定分支合并到当前分支
git remote rename old_name new_name  # 远程仓库重命名
git remote rm name  # 删除远程仓库



git命令别名
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status”
git config --global alias.hist 'log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short'   # 查看日志, git hist
