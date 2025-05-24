-- 安装 lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- 使用 vim.fn.glob 和 vim.fn.empty 检查文件是否存在
if vim.fn.empty(vim.fn.glob(lazypath)) > 0 then
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

require("lazy").setup({ -- 加载插件
  require("plugins.colortheme"),
  require("plugins.autocompletion"),
  require("plugins.nvimtree"),
  require("plugins.indent-blankline"),
  require("plugins.treesitter"),
  require("plugins.lualine"),
  require("plugins.comment"),
  require("plugins.toggleterm"),
  require("plugins.mason"),
  require("plugins.lsp"),
  require("plugins.telescope"),
  require("plugins.alpha"),
})
