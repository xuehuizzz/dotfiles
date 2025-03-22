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

require("config.options")  -- 基础配置
require("config.keymaps")  -- 快捷键
require("lazy").setup{     -- 加载插件
	require "plugins.colortheme",
	require 'plugins.autocompletion',
	require 'plugins.neotree',
	require 'plugins.indent-blankline',
	require 'plugins.treesitter',
	require 'plugins.lualine',
	require 'plugins.comment',
	require 'plugins.toggleterm', -- 打开终端, Ctrl+ j
}

vim.cmd('language en_US.UTF-8')


-- 记住上次编辑位置
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})
