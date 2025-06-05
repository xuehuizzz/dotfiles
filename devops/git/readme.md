## cmd
```bash
git config --global -e    # 打开全局gitconfig配置文件

git config --global pull.rebase true   # 全局配置, 这样，当你运行 git pull 时，Git 会自动使用 --rebase
git pull --rebase  # 获取远程分支的最新更新。 将你的本地提交从远程分支的最新状态“重放”到当前分支之上，而不是直接合并
git pull 等同于 (git fetch git marge)
git push -u origin HEAD  # 把本地分支提交的内容推送到远程同名分支上, 初次这么操作, 之后直接 git push 即可
git push origin <banchName>  # 指定推送到远程分支上
git config --list   # 查看已有的配置信息
git config --global user.name "your name"  # 设置用户
git config --global user.email "your email"  # 设置邮箱
git status    # 查看当前文件状态
git clone xxx   # 从现有仓库克隆
git add xxx  # 跟踪新文件
git restore --staged xxx   # 取消单个文件的git add
git branch name  # 新建分支
git branch -d name  # 删除分支
git checkout branch_name  # 切换分支, git checkout -b name 新建并切换分支
git merge branch_name  # 把指定分支合并到当前分支
git remote rename old_name new_name  # 远程仓库重命名
git remote rm name  # 删除远程仓库

```

## 停止追踪log文件
```bash
# 如果 .gitignore中已经添加 *.log 配置了, 但是还会追踪log文件,
# 原因是: .gitignore 只能忽略那些之前没有被 git 追踪的文件。如果某个文件已经被添加到 git 的版本控制中（即已经 commit 过），那么即使你后来在 .gitignore 中添加了相应的规则，该文件仍然会继续被追踪

# 在项目根目录, 查看具体哪些log文件被git追踪
git ls-files | grep '\.log$'
# 然后针对具体的文件路径进行移除
git rm --cached path/to/specific.log    # 或 git rm --cached -f "*.log"   移除所有被追踪的log文件
# 接着commit 和 push
```
