return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        -- Lua
        "lua_ls",
        -- Python
        "ruff",
        "pyright",
        -- Go
        "gopls",
        -- TypeScript / JavaScript
        "ts_ls",
        -- Deno (可选，通常系统全局安装 deno 即可)
        -- "denols",
        -- Emmet
        "emmet_language_server",
      },
      -- mason-lspconfig v2: 自动通过 vim.lsp.enable 启用已安装的 server
      -- (lsp.lua 中也手动 enable 了一遍，二者不冲突)
      automatic_enable = true,
    })
  end,
}
