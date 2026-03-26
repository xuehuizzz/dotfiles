return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- ══════════════════════════════════════════
		--  标题 (渐变风格 ASCII Art)
		-- ══════════════════════════════════════════
		dashboard.section.header.val = {
			[[                                                    ]],
			[[                                                    ]],
			[[  ██╗  ██╗██╗   ██╗███████╗██╗  ██╗██╗   ██╗██╗   ]],
			[[  ╚██╗██╔╝██║   ██║██╔════╝██║  ██║██║   ██║██║   ]],
			[[   ╚███╔╝ ██║   ██║█████╗  ███████║██║   ██║██║   ]],
			[[   ██╔██╗ ██║   ██║██╔══╝  ██╔══██║██║   ██║██║   ]],
			[[  ██╔╝ ██╗╚██████╔╝███████╗██║  ██║╚██████╔╝██║   ]],
			[[  ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝   ]],
			[[                                                    ]],
			[[          ⟨  Code · Create · Conquer  ⟩             ]],
		}

		-- ══════════════════════════════════════════
		--  按钮
		-- ══════════════════════════════════════════
    dashboard.section.buttons.val = {
        dashboard.button("f", "Find File", ":Telescope find_files hidden=true <CR>"),
        dashboard.button("r", "Recent Files", ":Telescope oldfiles <CR>"),
        dashboard.button("w", "Find Word", ":Telescope live_grep <CR>"),
        dashboard.button("n", "New File", ":ene <BAR> startinsert <CR>"),
        dashboard.button("c", "Configuration", ":e $MYVIMRC <CR>"),
        dashboard.button("p", "Package Manager", ":Lazy <CR>"),
        dashboard.button("q", "Quit", ":qa<CR>"),
    }
		-- 按钮样式：快捷键高亮
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
			button.opts.width = 40
			button.opts.cursor = 0
		end

		-- ══════════════════════════════════════════
		--  页脚 (显示插件数量和启动时间)
		-- ══════════════════════════════════════════
		dashboard.section.footer.val = {
			"",
			"⚡ Neovim loaded successfully",
		}

		-- lazy.nvim 加载完成后更新页脚
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			once = true,
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				dashboard.section.footer.val = {
					"",
					"⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms",
				}
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		-- ══════════════════════════════════════════
		--  布局
		-- ══════════════════════════════════════════
		dashboard.config.layout = {
			{ type = "padding", val = 4 },
			dashboard.section.header,
			{ type = "padding", val = 3 },
			dashboard.section.buttons,
			{ type = "padding", val = 2 },
			dashboard.section.footer,
		}

		-- ══════════════════════════════════════════
		--  选项
		-- ══════════════════════════════════════════
		dashboard.config.opts.noautocmd = true

		-- ══════════════════════════════════════════
		--  Telescope
		-- ══════════════════════════════════════════
		require("telescope").setup({
			defaults = {
				mappings = {
					i = { ["<esc>"] = "close" },
					n = { ["<esc>"] = "close" },
				},
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
				},
			},
		})

		-- ══════════════════════════════════════════
		--  应用配置
		-- ══════════════════════════════════════════
		alpha.setup(dashboard.config)

		-- ══════════════════════════════════════════
		--  防止滚动和移动
		-- ══════════════════════════════════════════
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				local buf = vim.api.nvim_get_current_buf()
				local win = vim.api.nvim_get_current_win()

				vim.wo[win].scrolloff = 999
				vim.wo[win].sidescrolloff = 999

				local nop_keys = {
					"<C-d>", "<C-u>", "<C-f>", "<C-b>",
					"<C-e>", "<C-y>", "gg", "G",
					"<ScrollWheelUp>", "<ScrollWheelDown>",
					"<2-ScrollWheelUp>", "<2-ScrollWheelDown>",
					"k", "j", "<Up>", "<Down>",
					"h", "l", "<Left>", "<Right>",
					"0", "^", "$",
					"w", "W", "b", "B", "e", "E",
					"<C-h>", "<C-l>",
					"<ScrollWheelLeft>", "<ScrollWheelRight>",
					"<2-ScrollWheelLeft>", "<2-ScrollWheelRight>",
					"<S-Left>", "<S-Right>",
					"zh", "zl", "zH", "zL",
				}
				for _, key in ipairs(nop_keys) do
					vim.api.nvim_buf_set_keymap(buf, "n", key, "<Nop>", { noremap = true, silent = true })
				end
			end,
		})

		-- ══════════════════════════════════════════
		--  高亮 (多色渐变风格)
		-- ══════════════════════════════════════════
		local function set_alpha_highlights()
			-- 标题：柔和蓝紫渐变
			vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })
			-- 按钮文字：柔和白色
			vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#c0caf5" })
			-- 快捷键：亮青色，醒目
			vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#7dcfff", bold = true })
			-- 页脚：暗淡优雅
			vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#565f89", italic = true })

			-- 标题多行渐变色（可选，逐行不同颜色）
			local header_colors = {
				"#7aa2f7",
				"#7aa2f7",
				"#7dcfff",
				"#7dcfff",
				"#89ddff",
				"#89ddff",
				"#bb9af7",
				"#bb9af7",
				"#bb9af7",
				"#565f89",
			}
			for i, color in ipairs(header_colors) do
				local hl_name = "AlphaHeaderLine" .. i
				vim.api.nvim_set_hl(0, hl_name, { fg = color, bold = true })
			end
		end

		set_alpha_highlights()

		-- 标题逐行上色
		dashboard.section.header.opts.hl = {}
		for i = 1, #dashboard.section.header.val do
			table.insert(dashboard.section.header.opts.hl, {
				{ "AlphaHeaderLine" .. i, 0, -1 },
			})
		end

		-- 页脚高亮
		dashboard.section.footer.opts = dashboard.section.footer.opts or {}
		dashboard.section.footer.opts.hl = "AlphaFooter"

		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = set_alpha_highlights,
		})
	end,
}
