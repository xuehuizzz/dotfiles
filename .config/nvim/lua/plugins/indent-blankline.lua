return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPre", "BufNewFile" }, -- 懒加载，提升启动速度
	config = function()
		-- ── 彩虹缩进颜色（柔和低饱和度，不抢眼） ──────────
		local hooks = require("ibl.hooks")

		local highlight = {
			"IndentRainbow1",
			"IndentRainbow2",
			"IndentRainbow3",
			"IndentRainbow4",
			"IndentRainbow5",
			"IndentRainbow6",
		}

		local scope_highlight = {
			"IndentScope",
		}

		-- 注册颜色
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			-- 缩进线：用低透明度的柔和色
			vim.api.nvim_set_hl(0, "IndentRainbow1", { fg = "#3b3f51" })
			vim.api.nvim_set_hl(0, "IndentRainbow2", { fg = "#3d4250" })
			vim.api.nvim_set_hl(0, "IndentRainbow3", { fg = "#3f444f" })
			vim.api.nvim_set_hl(0, "IndentRainbow4", { fg = "#3b3f51" })
			vim.api.nvim_set_hl(0, "IndentRainbow5", { fg = "#3d4250" })
			vim.api.nvim_set_hl(0, "IndentRainbow6", { fg = "#3f444f" })
			-- scope 高亮：当前作用域用亮色突出
			vim.api.nvim_set_hl(0, "IndentScope", { fg = "#bd93f9" })
		end)

		require("ibl").setup({
			indent = {
				char = "│", -- 更连贯的竖线，视觉更整洁
				highlight = highlight,
				-- tab_char = "│",
			},
			scope = {
				enabled = true,
				char = "│",
				highlight = scope_highlight,
				show_start = false, -- 不在作用域起始行加下划线
				show_end = false,
				show_exact_scope = true,
				include = {
					node_type = {
						["*"] = {
							"class",
							"function",
							"method",
							"block",
							"list_literal",
							"selector",
							"if_statement",
							"else_clause",
							"for_statement",
							"while_statement",
							"try_statement",
							"catch_clause",
							"return_statement",
							"table_constructor",
							"arguments",
						},
					},
				},
			},
			exclude = {
				filetypes = {
					"help",
					"startify",
					"dashboard",
					"alpha",
					"packer",
					"lazy",
					"neogitstatus",
					"NvimTree",
					"neo-tree",
					"Trouble",
					"mason",
					"notify",
					"toggleterm",
					"lspinfo",
					"checkhealth",
					"man",
					"gitcommit",
					"TelescopePrompt",
					"TelescopeResults",
					"",
				},
				buftypes = {
					"terminal",
					"nofile",
					"quickfix",
					"prompt",
				},
			},
		})

		-- 隐藏第一层缩进线，减少视觉噪音
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
	end,
}
