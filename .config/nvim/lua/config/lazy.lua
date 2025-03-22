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
vim.g.mapleader = " " -- 设置全局 leader 键为空格键
vim.g.maplocalleader = " " -- 设置局部 leader 键为空格键

require("lazy").setup({ -- 加载插件
	require("plugins.colortheme"),
	require("plugins.autocompletion"),
	require("plugins.neotree"),
	require("plugins.indent-blankline"),
	require("plugins.treesitter"),
	require("plugins.lualine"),
	require("plugins.comment"),
	require("plugins.toggleterm"),
})
