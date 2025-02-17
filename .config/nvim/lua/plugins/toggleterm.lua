return {
	"akinsho/toggleterm.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		cursor_style =
			{
				normal = "line",
				insert = "line",
				terminal = "line"
			}, require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-j>]],
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				persist_size = true,
				direction = "horizontal",
				close_on_exit = true,
				shell = vim.o.shell,
			})
	end,
}
