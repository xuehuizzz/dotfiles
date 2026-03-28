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
		--  透明度设置 (0 = 完全不透明, 100 = 完全透明)
		--  调这一个值就够了，其余自动计算
		-- ══════════════════════════════════════════
		local transparency = 20

		-- ══════════════════════════════════════════
		--  标题
		-- ══════════════════════════════════════════
		dashboard.section.header.val = {
			[[                                                       ]],
			[[       ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗]],
			[[       ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║]],
			[[       ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║]],
			[[       ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║]],
			[[       ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║]],
			[[       ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝]],
			[[                                                       ]],
			[[              ─────────────────────────────             ]],
			[[                ✦  Code · Create · Conquer  ✦          ]],
			[[              ─────────────────────────────             ]],
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

		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
			button.opts.width = 45
			button.opts.cursor = 0
		end

		-- ══════════════════════════════════════════
		--  页脚
		-- ══════════════════════════════════════════
		dashboard.section.footer.val = {
			"",
			"Neovim loaded successfully",
		}

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			once = true,
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				dashboard.section.footer.val = {
					"",
					stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. ms .. "ms",
				}
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		-- ══════════════════════════════════════════
		--  布局
		-- ══════════════════════════════════════════
		dashboard.config.layout = {
			{ type = "padding", val = 3 },
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
		--  透明度工具函数
		--  将 base_color 按 transparency% 混向黑色
		--  transparency=0  → 原色
		--  transparency=100 → 纯黑 #000000
		-- ══════════════════════════════════════════
		local function blend(hex, amount)
			local r = tonumber(hex:sub(2, 3), 16)
			local g = tonumber(hex:sub(4, 5), 16)
			local b = tonumber(hex:sub(6, 7), 16)
			local factor = 1 - (amount / 100)
			r = math.floor(r * factor + 0.5)
			g = math.floor(g * factor + 0.5)
			b = math.floor(b * factor + 0.5)
			return string.format("#%02x%02x%02x", r, g, b)
		end

		-- ══════════════════════════════════════════
		--  高亮
		-- ══════════════════════════════════════════
		local function set_alpha_highlights()
			-- 基础背景色（你的 colorscheme 主背景色，按需修改）
			local base_bg = "#2B2B2B"
			local bg = blend(base_bg, transparency)

			-- 全局背景
			vim.api.nvim_set_hl(0, "Normal", { bg = bg })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = bg })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = blend(base_bg, math.max(0, transparency - 10)) })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = bg })
			vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = bg, bg = bg })
			vim.api.nvim_set_hl(0, "MsgArea", { bg = bg })

			-- 浮动窗口透明度
			vim.o.winblend = transparency
			vim.o.pumblend = transparency

			-- 标题渐变
			local header_colors = {
				"#89b4fa",
				"#89b4fa",
				"#89dceb",
				"#94e2d5",
				"#a6e3a1",
				"#cba6f7",
				"#f5c2e7",
				"#585b70",
				"#585b70",
				"#f2cdcd",
				"#585b70",
			}
			for i, color in ipairs(header_colors) do
				vim.api.nvim_set_hl(0, "AlphaHeaderLine" .. i, { fg = color, bg = bg, bold = true })
			end

			vim.api.nvim_set_hl(0, "AlphaButtons", { fg = "#cdd6f4", bg = bg })
			vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#f9e2af", bg = bg, bold = true })
			vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#6c7086", bg = bg, italic = true })
		end

		set_alpha_highlights()

		-- 标题逐行着色
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
	end,
}
