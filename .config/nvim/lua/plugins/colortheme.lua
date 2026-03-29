return {
	{
		"rktjmp/lush.nvim",
		lazy = true,
	},
	{
		"briones-gabriel/darcula-solid.nvim",
		dependencies = { "rktjmp/lush.nvim" },
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme darcula-solid]])

			local transparent_bg = false
			local bg = transparent_bg and "NONE" or "#2B2B2B"
			local bg_dark = transparent_bg and "NONE" or "#242424"
			local bg_light = "#323232"
			local bg_visual = "#2F4F75"
			local bg_search = "#32593D"
			local bg_cursor_line = "#313335"
			local fg_line_nr = "#606366"
			local fg_line_nr_active = "#A4A3A3"
			local fg_comment = "#808080"
			local fg_whitespace = "#3B3B3B"
			local border = "#555555"
			local accent = "#6897BB"

			local hl = function(group, opts)
				vim.api.nvim_set_hl(0, group, opts)
			end

			-- 基础背景
			hl("Normal", { bg = bg })
			hl("NormalFloat", { bg = bg_dark })
			hl("NormalNC", { bg = bg }) -- 非活跃窗口

			-- 编辑区域
			hl("Visual", { bg = bg_visual, fg = "NONE" })
			hl("CursorLine", { bg = bg_cursor_line })
			hl("CursorLineNr", { fg = fg_line_nr_active, bold = true })
			hl("LineNr", { fg = fg_line_nr })
			hl("ColorColumn", { bg = bg_dark })

			-- 搜索高亮
			hl("Search", { bg = bg_search, fg = "NONE" })
			hl("IncSearch", { bg = "#6897BB", fg = "#1E1E1E", bold = true })
			hl("CurSearch", { bg = "#6897BB", fg = "#1E1E1E", bold = true })

			-- 弹窗 / 浮动窗口
			hl("FloatBorder", { fg = border, bg = bg_dark })
			hl("Pmenu", { bg = bg_dark, fg = "#BBBBBB" })
			hl("PmenuSel", { bg = bg_visual, bold = true })
			hl("PmenuSbar", { bg = bg_light })
			hl("PmenuThumb", { bg = accent })

			-- 状态栏 / Tab栏
			hl("StatusLine", { bg = bg_dark, fg = "#BBBBBB" })
			hl("StatusLineNC", { bg = bg_dark, fg = fg_line_nr })
			hl("TabLine", { bg = bg_dark, fg = fg_line_nr })
			hl("TabLineSel", { bg = bg, fg = "#BBBBBB", bold = true })
			hl("TabLineFill", { bg = bg_dark })

			-- 缩进 / 空白字符
			hl("Whitespace", { fg = fg_whitespace })
			hl("NonText", { fg = fg_whitespace })

			-- 注释美化（斜体）
			hl("Comment", { fg = fg_comment, italic = true })

			-- 诊断信息
			hl("DiagnosticVirtualTextError", { fg = "#CF6171", bg = "#3D2020", italic = true })
			hl("DiagnosticVirtualTextWarn", { fg = "#E0AF68", bg = "#3D3520", italic = true })
			hl("DiagnosticVirtualTextInfo", { fg = "#6897BB", bg = "#1E2D3D", italic = true })
			hl("DiagnosticVirtualTextHint", { fg = "#6A9955", bg = "#1E3D20", italic = true })

			-- 匹配括号
			hl("MatchParen", { bg = "#3B514D", bold = true, underline = true })

			-- Git 标记（侧边栏）
			hl("GitSignsAdd", { fg = "#6A9955" })
			hl("GitSignsChange", { fg = "#6897BB" })
			hl("GitSignsDelete", { fg = "#CF6171" })

			-- Snacks Picker
			hl("SnacksPickerBorder", { fg = border, bg = bg_dark })
			hl("SnacksPickerNormal", { bg = bg_dark })
			hl("SnacksPickerSelected", { bg = bg_visual })
			hl("SnacksPickerInputBorder", { fg = border, bg = bg_dark })
			hl("SnacksPickerInputNormal", { bg = bg_dark })
			hl("SnacksPickerPreviewBorder", { fg = border, bg = bg_dark })
		end,
	},
}
