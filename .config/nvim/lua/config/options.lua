vim.opt.guifont = "JetBrainsMono Nerd Font:h12"
vim.opt.number = true -- 显示行号
-- vim.opt.relativenumber = true        -- 显示相对行号
vim.opt.guicursor = "n-v-c-sm-i-ci-ve-r-cr-o:ver25" -- 设置任何模式下都使用竖线光标
vim.opt.expandtab = true -- 将制表符展开为空格
vim.opt.tabstop = 4 -- 制表符等于4个空格
vim.opt.shiftwidth = 4 -- 缩进宽度为4个空格
vim.opt.autoindent = true -- 自动缩进
vim.opt.cursorline = true -- 高亮当前行
vim.opt.mouse = "a" -- 启用鼠标支持
vim.opt.lazyredraw = true -- 关闭显示重绘
vim.opt.ttyfast = true -- 提高性能
vim.opt.compatible = false -- 关闭 vi 兼容模式
vim.opt.syntax = "on" -- 语法高亮
vim.opt.ruler = true -- 显示状态栏标尺
vim.opt.cmdheight = 1 -- 命令行高度
vim.opt.laststatus = 2 -- 显示状态栏
vim.opt.softtabstop = 4 -- 退格键一次删除4个空格
vim.opt.smartindent = true -- 智能自动缩进
vim.opt.backup = false -- 不创建备份文件
vim.opt.autochdir = true -- 自动切换工作目录
vim.opt.backupcopy = "yes" -- 备份时的行为为覆盖
vim.opt.hidden = true -- 允许在有未保存的修改时切换缓冲区
vim.opt.ignorecase = true -- 搜索时忽略大小写
vim.opt.smartcase = true -- 有大写字母时保持对大小写敏感
vim.opt.wrapscan = false -- 禁止循环搜索
vim.opt.incsearch = true -- 即时搜索
vim.opt.hlsearch = true -- 搜索高亮
vim.opt.errorbells = false -- 关闭错误提示音
vim.opt.visualbell = false -- 关闭可视响铃
vim.opt.magic = true -- 设置魔术
vim.opt.backspace = "indent,eol,start" -- 设置退格键行为
vim.opt.foldenable = true -- 开启折叠
vim.opt.foldmethod = "syntax" -- 语法折叠
vim.opt.foldcolumn = "0" -- 折叠区域宽度
vim.opt.foldlevel = 1 -- 折叠层数
vim.opt.termguicolors = true -- 启用终端真彩色支持
vim.opt.background = "dark" -- 设置深色背景主题
vim.opt.signcolumn = "yes" -- 始终显示标记列, (用于显示 git 状态、错误提示等), 防止文本左右移动
vim.opt.clipboard:append("unnamedplus") -- 将系统剪贴板设置为默认寄存器
vim.opt.splitright = true -- 垂直分割窗口时，新窗口在右边打开
vim.opt.splitbelow = true -- 水平分割窗口时，新窗口在下方打开
vim.opt.backup = false -- 不创建备份文件
vim.opt.swapfile = false -- 禁用交换文件（swap file）的创建，这些文件通常用于在编辑时进行备份
vim.opt.writebackup = false -- 不允许其他程序同时编辑同一文件
vim.opt.conceallevel = 0 -- 不隐藏任何语法标记(如 Markdown 中的 `` )
vim.opt.cmdheight = 1 -- 命令行高度为1行
vim.opt.wrap = true -- 启用自动换行
vim.opt.linebreak = true -- 在单词之间换行
vim.opt.breakindent = true -- 保持换行后的缩进
vim.opt.showbreak = "↪ " -- 显示换行符号
vim.opt.laststatus = 3  -- 使用全局状态栏
vim.opt.cmdheight = 0   -- 将命令行高度设为 0，即隐藏命令行
vim.opt.filetype = "on"        -- 启用文件类型检测
vim.opt.syntax = "enable"      -- 启用语法高亮

vim.cmd('language en_US.UTF-8')
