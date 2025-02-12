return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- 设置配色方案
		vim.cmd([[colorscheme tokyonight]])
	end,
}
