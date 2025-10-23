-- 设置 leader 键，建议在初始化 lazy 之前设置
vim.g.mapleader = " " -- 设置全局 leader 键为空格键
vim.g.maplocalleader = " " -- 设置局部 leader 键为空格键

vim.opt.guifont = "Maple Mono NF CN:h12"
vim.opt.number = true -- 显示行号
-- vim.opt.relativenumber = true        -- 显示相对行号
-- vim.opt.title = true  -- 显示文件标题
vim.opt.guicursor = "n-v-c-sm-i-ci-ve-r-cr-o:ver25" -- 设置任何模式下都使用竖线光标
vim.opt.expandtab = true -- 将制表符展开为空格
vim.opt.tabstop = 4 -- 制表符等于4个空格
vim.opt.shiftwidth = 4 -- 缩进宽度为4个空格
vim.opt.autoindent = true -- 自动缩进
vim.opt.cursorline = true -- 高亮当前行
vim.opt.mouse = "a" -- 启用鼠标支持
vim.opt.lazyredraw = true -- 关闭显示重绘
vim.opt.ttyfast = true -- 提高性能
vim.opt.syntax = "on" -- 语法高亮
vim.opt.ruler = true -- 显示状态栏标尺
vim.opt.cmdheight = 0 -- 命令行高度
vim.opt.laststatus = 2 -- 显示状态栏
vim.opt.softtabstop = 4 -- 退格键一次删除4个空格
vim.opt.smartindent = true -- 智能自动缩进
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
vim.opt.foldmethod = "expr" -- 折叠方式
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- 使用 treesitter 提供的折叠
vim.opt.foldcolumn = "0" -- 折叠区域宽度
vim.opt.foldlevel = 99 -- 折叠层数
vim.opt.foldlevelstart = 99 -- 默认展开所有折叠
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
vim.opt.wrap = true -- 启用自动换行
vim.opt.linebreak = true -- 在单词之间换行
vim.opt.breakindent = true -- 保持换行后的缩进
vim.opt.showbreak = "↪ " -- 显示换行符号
vim.opt.filetype = "on" -- 启用文件类型检测
vim.opt.syntax = "enable" -- 启用语法高亮
vim.opt.encoding = "utf-8" -- 设置编码为 UTF-8
vim.opt.fileencoding = "utf-8" -- 设置文件编码为 UTF-8
vim.opt.langremap = false -- 禁用语言映射
vim.opt.virtualedit = "onemore" -- 允许光标移动到最后一个字符之后
vim.opt.scroll = 10 -- 设置 Ctrl-U 和 Ctrl-D 滚动的行数
vim.opt.scrolljump = 1 -- 当光标移出屏幕时滚动的行数
vim.opt.scrolloff = 8 -- 保持光标上下文可见行数，让滚动更平滑
vim.cmd("language en_US.UTF-8")

-- 完全禁用诊断图标和符号
-- TODO: 过滤 #501, #402 告警
vim.diagnostic.config({
	virtual_text = {
		prefix = "", -- 设置虚拟文本的前缀为空
		spacing = 4, -- 设置间距
		source = true,
		severity = {
			min = vim.diagnostic.severity.INFO,
		},
	},
	signs = false, -- 禁用行号列的图标
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
	},
})

-- 禁用一些不需要的内置插件
local disabled_built_ins = {
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
	vim.g["loaded_" .. plugin] = 1
end
