return {
	"folke/tokyonight.nvim",
	priority = 1000,
	config = function()
		local transparent = false -- set to true if you would like to enable transparency

		local bg = "#101115"
		local bg_dark = "#101115"
		local bg_highlight = "#143652"
		local bg_search = "#0A64AC"
		local bg_visual = "#275378"
		local fg = "#CBE0F0"
		local fg_dark = "#B4D0E9"
		local fg_gutter = "#627E97"
		local border = "#547998"

		require("tokyonight").setup({
			style = "Storm", -- 主题样式 Storm, Night, Moon, Day
			transparent = transparent,
			terminal_colors = true, -- 使终端颜色更鲜艳
			lazy = false,
			styles = {
				sidebars = transparent and "transparent" or "dark",
				floats = transparent and "transparent" or "dark",
				comments = { italic = true },
				keywords = { italic = true },
				functions = { bold = true },
				variables = {},
			},
			on_colors = function(colors)
				colors.bg = bg
				colors.bg_dark = transparent and colors.none or bg_dark
				colors.bg_float = transparent and colors.none or bg_dark
				colors.bg_highlight = bg_highlight
				colors.bg_popup = bg_dark
				colors.bg_search = bg_search
				colors.bg_sidebar = transparent and colors.none or bg_dark
				colors.bg_statusline = transparent and colors.none or bg_dark
				colors.bg_visual = bg_visual
				colors.border = border
				colors.fg = fg
				colors.fg_dark = fg_dark
				colors.fg_float = fg
				colors.fg_gutter = fg_gutter
				colors.fg_sidebar = fg_dark
			end,
			sidebars = {  -- 侧边栏设置
				"qf",
				"vista_kind",
				"terminal",
				"packer",
				"spectre_panel",
				"help",
			},
      border = "rounded",  -- 边框样式 "none", "single", "double", "rounded"
			day_brightness = 0.3, -- 日间模式的亮度
			dim_inactive = false, -- 降低不活动窗口的亮度
			lualine_bold = false, -- 使用 lualine 主题
		})

		vim.cmd("colorscheme tokyonight")
	end,
}
