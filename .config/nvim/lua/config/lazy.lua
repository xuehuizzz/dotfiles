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

require("lazy").setup({ -- 加载插件
  require("plugins.colortheme"),
  require("plugins.autocompletion"),
  require("plugins.neotree"),
  require("plugins.indent-blankline"),
  require("plugins.treesitter"),
  require("plugins.lualine"),
  require("plugins.comment"),
  require("plugins.toggleterm"),
  require("plugins.mason"),
  require("plugins.lsp"),
})
