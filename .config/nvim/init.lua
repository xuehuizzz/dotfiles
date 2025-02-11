-- 安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 设置 leader 键，建议在初始化 lazy 之前设置
vim.g.mapleader = " "  -- 设置全局 leader 键为空格键
vim.g.maplocalleader = " "   -- 设置局部 leader 键为空格键

-- 初始化 lazy.nvim
require("lazy").setup(require("plugins"))


-- 基础设置
vim.opt.number = true                -- 显示行号
-- vim.opt.relativenumber = true        -- 显示相对行号
vim.opt.guicursor = "n-v-c-sm-i-ci-ve-r-cr-o:ver25"  -- 设置任何模式下都使用竖线光标
vim.opt.expandtab = true            -- 将制表符展开为空格
vim.opt.tabstop = 4                 -- 制表符等于4个空格
vim.opt.shiftwidth = 4              -- 缩进宽度为4个空格
vim.opt.autoindent = true           -- 自动缩进
vim.opt.cursorline = true           -- 高亮当前行
vim.opt.mouse = 'a'                 -- 启用鼠标支持
vim.opt.lazyredraw = true                 -- 关闭显示重绘
vim.opt.ttyfast = true                    -- 提高性能
vim.opt.compatible = false                -- 关闭 vi 兼容模式
vim.opt.syntax = 'on'                     -- 语法高亮
vim.opt.ruler = true                     -- 显示状态栏标尺
vim.opt.cmdheight = 1                    -- 命令行高度
vim.opt.laststatus = 2                   -- 显示状态栏
vim.opt.shiftwidth = 4                   -- 设定 << 和 >> 命令移动时的宽度
vim.opt.softtabstop = 4                  -- 退格键一次删除4个空格
vim.opt.smartindent = true               -- 智能自动缩进
vim.opt.backup = false                   -- 不创建备份文件
vim.opt.autochdir = true                -- 自动切换工作目录
vim.opt.backupcopy = 'yes'              -- 备份时的行为为覆盖
vim.opt.hidden = true                   -- 允许在有未保存的修改时切换缓冲区
vim.opt.ignorecase = true               -- 搜索时忽略大小写
vim.opt.smartcase = true                -- 有大写字母时保持对大小写敏感
vim.opt.wrapscan = false                -- 禁止循环搜索
vim.opt.incsearch = true                -- 即时搜索
vim.opt.hlsearch = true                 -- 搜索高亮
vim.opt.errorbells = false              -- 关闭错误提示音
vim.opt.visualbell = false              -- 关闭可视响铃
vim.opt.magic = true                    -- 设置魔术
vim.opt.backspace = 'indent,eol,start'  -- 设置退格键行为
vim.opt.statusline = ' %<%F[%1*%M%*%n%R%H]%= %y %0(%{&fileformat} %{&encoding} %c:%l/%L%) ' -- 自定义状态栏
vim.opt.foldenable = true               -- 开启折叠
vim.opt.foldmethod = 'syntax'           -- 语法折叠
vim.opt.foldcolumn = '0'                -- 折叠区域宽度
vim.opt.foldlevel = 1                   -- 折叠层数

vim.cmd('filetype plugin indent on')   -- 启用文件类型检测
-- vim.cmd('colorscheme tokyonight')         -- 配置主题
