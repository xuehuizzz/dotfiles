return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local colors = {
			bg      = "#282a36",
			fg      = "#f8f8f2",
			yellow  = "#f1fa8c",
			cyan    = "#8be9fd",
			green   = "#50fa7b",
			orange  = "#ffb86c",
			magenta = "#ff79c6",
			purple  = "#bd93f9",
			red     = "#ff5555",
			comment = "#6272a4",
		}

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 80
		end

		-- ── 组件定义 ──────────────────────────────────────

		local mode = {
			"mode",
			fmt = function(str)
				-- 短模式名，节省空间又清晰
				local map = {
					["NORMAL"]   = " NOR",
					["INSERT"]   = " INS",
					["VISUAL"]   = "󰈈 VIS",
					["V-LINE"]   = "󰈈 V·L",
					["V-BLOCK"]  = "󰈈 V·B",
					["COMMAND"]  = " CMD",
					["REPLACE"]  = " REP",
					["TERMINAL"] = " TER",
					["SELECT"]   = "󰒅 SEL",
				}
				return map[str] or str:sub(1, 3)
			end,
			padding = { left = 1, right = 1 },
		}

		local branch = {
			"branch",
			icon = "",
			fmt = function(str)
				-- 分支名过长时截断
				return str:len() > 24 and str:sub(1, 21) .. "…" or str
			end,
		}

		local filename = {
			"filename",
			file_status = true,
			path = 1, -- 相对路径，比纯文件名提供更多上下文
			symbols = {
				modified = " ●",
				readonly = " ",
				unnamed  = "[Untitled]",
				newfile  = "[New]",
			},
			color = { fg = colors.fg },
		}

		local diagnostics = {
			"diagnostics",
			sources = { "nvim_diagnostic" },
			sections = { "error", "warn", "info", "hint" },
			symbols = {
				error = " ",
				warn  = " ",
				info  = " ",
				hint  = "󰌵 ",
			},
			colored = true,
			update_in_insert = false,
			always_visible = false,
			cond = hide_in_width,
		}

		local diff = {
			"diff",
			colored = true,
			diff_color = {
				added    = { fg = colors.green },
				modified = { fg = colors.orange },
				removed  = { fg = colors.red },
			},
			symbols = { added = " ", modified = " ", removed = " " },
			cond = hide_in_width,
		}

		local eol = {
			"fileformat",
			symbols = {
				unix = "",
				dos  = "",
				mac  = "",
			},
			cond = hide_in_width,
		}

		-- LSP 服务器名称
		local lsp = {
			function()
				local clients = vim.lsp.get_clients({ bufnr = 0 })
				if #clients == 0 then
					return ""
				end
				local names = {}
				for _, client in ipairs(clients) do
					table.insert(names, client.name)
				end
				return "  " .. table.concat(names, ", ")
			end,
			cond = hide_in_width,
			color = { fg = colors.cyan },
		}

		-- ── Setup ─────────────────────────────────────────

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "dracula",
				-- 圆角分隔符，视觉更柔和
				section_separators   = { left = "", right = "" },
				component_separators = { left = "│", right = "│" },
				disabled_filetypes = {
					statusline = { "alpha", "neo-tree", "dashboard" },
				},
				always_divide_middle = true,
				globalstatus = true, -- 全局状态栏，多窗口时更整洁
			},
			sections = {
				lualine_a = { mode },
				lualine_b = { branch, diff },
				lualine_c = { filename },
				lualine_x = { diagnostics, lsp, "filetype" },
				lualine_y = { eol, "encoding", "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive", "neo-tree", "lazy" },
		})
	end,
}
