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
			automatic_installation = true,
		})
	end,
}
