return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local nvimtree = require("nvim-tree")

		-- 禁用默认文件浏览器 netrw
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			-- ── 侧栏视图 ──────────────────────────────────────
			view = {
				width = 32,
				cursorline = true, -- 高亮当前行
				side = "left",
				signcolumn = "yes", -- 显示 git/diagnostics 标记列
			},

			-- ── 渲染器 ────────────────────────────────────────
			renderer = {
				group_empty = true, -- 将空文件夹合并为一行显示 (a/b/c)
				highlight_git = "name", -- 按 git 状态高亮文件名
				highlight_diagnostics = "icon", -- 按诊断状态高亮图标

				indent_markers = {
					enable = true,
					icons = {
						corner = "└",
						edge = "│",
						item = "│",
						bottom = "─",
						none = " ",
					},
				},

				icons = {
					git_placement = "signcolumn", -- git 状态放到标记列, 更整洁
					modified_placement = "signcolumn",
					diagnostics_placement = "signcolumn",

					glyphs = {
						default = "󰈚",
						symlink = "",
						modified = "●",
						folder = {
							arrow_closed = "",
							arrow_open = "",
							default = "",
							open = "",
							empty = "",
							empty_open = "",
							symlink = "",
							symlink_open = "",
						},
						git = {
							unstaged = "✗",
							staged = "✓",
							unmerged = "",
							renamed = "➜",
							untracked = "★",
							deleted = "",
							ignored = "◌",
						},
					},
				},
			},

			-- ── Git 集成 ──────────────────────────────────────
			git = {
				enable = true,
				ignore = false, -- 不隐藏 gitignored 文件
			},

			-- ── 诊断集成 (LSP) ───────────────────────────────
			diagnostics = {
				enable = true,
				show_on_dirs = true,
				show_on_open_dirs = false,
				icons = {
					hint = "",
					info = "",
					warning = "",
					error = "",
				},
			},

			-- ── 文件修改标记 ──────────────────────────────────
			modified = {
				enable = true,
			},

			-- ── 打开文件行为 ──────────────────────────────────
			actions = {
				open_file = {
					quit_on_open = false,
					window_picker = {
						enable = false, -- 与 splits 兼容
					},
				},
			},

			-- ── 过滤规则 ──────────────────────────────────────
			filters = {
				git_ignored = false,
				dotfiles = false,
				custom = {
					"^.git$",
					"^node_modules$",
					"^dist$",
					"^.next$",
					"^.idea$",
					"^.vscode$",
					"\\.pyc$",
					"__pycache__",
					".DS_Store",
				},
			},

			-- ── 更新聚焦文件 ─────────────────────────────────
			update_focused_file = {
				enable = true, -- 自动定位到当前打开的文件
				update_root = false,
			},
		})

		-- ── 快捷键 ────────────────────────────────────────────
		local keymap = vim.keymap
		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Find file in explorer" })
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse explorer" })
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh explorer" })

		-- ── 自动关闭: 最后一个窗口是 nvim-tree 时退出 ──────
		vim.api.nvim_create_autocmd("QuitPre", {
			callback = function()
				local tree_wins = {}
				local floating_wins = {}
				local wins = vim.api.nvim_list_wins()
				for _, w in ipairs(wins) do
					local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
					if bufname:match("NvimTree_") ~= nil then
						table.insert(tree_wins, w)
					end
					if vim.api.nvim_win_get_config(w).relative ~= "" then
						table.insert(floating_wins, w)
					end
				end
				if #wins - #floating_wins - #tree_wins == 1 then
					for _, w in ipairs(tree_wins) do
						vim.api.nvim_win_close(w, true)
					end
				end
			end,
		})
	end,
}
