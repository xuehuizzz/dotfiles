return {
	"akinsho/toggleterm.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local api = vim.api

		local function to_num(val)
			if type(val) == "number" then return val end
			if type(val) == "table" then return val[false] or val[1] or 0 end
			return 0
		end

		local drag = {}

		-- ═══ 终端光标: 闪烁竖线 ═══
		vim.opt.guicursor:append(
			"t:ver25-blinkon400-blinkoff400-blinkwait300-Cursor"
		)

		require("toggleterm").setup({
			direction = "float",
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = false,
			terminal_mappings = false,
			persist_size = true,
			persist_mode = true,
			close_on_exit = true,
			clear_env = false,
			auto_scroll = true,
			shell = vim.o.shell,
			float_opts = {
				border = "rounded",
				width = function() return math.floor(vim.o.columns * 0.85) end,
				height = function() return math.floor(vim.o.lines * 0.8) end,
				winblend = 8,
			},
			highlights = {
				FloatBorder = { link = "FloatBorder" },
				NormalFloat = { link = "NormalFloat" },
			},
			on_create = function(term)
				vim.opt.laststatus = 3
				local buf = term.bufnr
				local opts = { buffer = buf, noremap = true, silent = true }

				local normal_mouse = {
					"<LeftMouse>", "<2-LeftMouse>", "<3-LeftMouse>",
					"<RightMouse>", "<2-RightMouse>", "<3-RightMouse>",
					"<MiddleMouse>", "<2-MiddleMouse>", "<3-MiddleMouse>",
					"<LeftDrag>", "<RightDrag>", "<MiddleDrag>",
					"<LeftRelease>", "<RightRelease>", "<MiddleRelease>",
					"<ScrollWheelUp>", "<ScrollWheelDown>",
					"<ScrollWheelLeft>", "<ScrollWheelRight>",
				}
				for _, ev in ipairs(normal_mouse) do
					vim.keymap.set("n", ev, function() vim.cmd("startinsert!") end, opts)
				end

				api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
					buffer = buf,
					callback = function()
						vim.schedule(function()
							if api.nvim_buf_is_valid(buf) and api.nvim_get_current_buf() == buf then
								vim.cmd("startinsert!")
							end
						end)
					end,
				})
			end,
			on_open = function(term)
				vim.schedule(function() vim.cmd("startinsert!") end)

				local win = term.window
				if not win or not api.nvim_win_is_valid(win) then return end
				local cfg = api.nvim_win_get_config(win)
				if cfg.relative == "" then return end

				local buf = term.bufnr
				local opts = { buffer = buf, noremap = true, silent = true }

				-- ── 左键拖拽: 移动窗口 (锚点法，1:1 跟随) ──
				vim.keymap.set("t", "<LeftMouse>", function()
					if not api.nvim_win_is_valid(win) then return end
					local pos = vim.fn.getmousepos()
					local c = api.nvim_win_get_config(win)
					if c.relative == "" then return end
					drag = {
						mode = "move",
						anchor_row = pos.screenrow - to_num(c.row),
						anchor_col = pos.screencol - to_num(c.col),
						width = c.width,
						height = c.height,
					}
				end, opts)

				vim.keymap.set("t", "<LeftDrag>", function()
					if drag.mode ~= "move" then return end
					if not api.nvim_win_is_valid(win) then drag = {} return end
					local pos = vim.fn.getmousepos()
					local max_r = vim.o.lines - drag.height - 2
					local max_c = vim.o.columns - drag.width - 2
					api.nvim_win_set_config(win, {
						relative = "editor",
						row = math.max(0, math.min(pos.screenrow - drag.anchor_row, max_r)),
						col = math.max(0, math.min(pos.screencol - drag.anchor_col, max_c)),
						width = drag.width,
						height = drag.height,
					})
				end, opts)

				vim.keymap.set("t", "<LeftRelease>", function()
					if drag.mode == "move" then drag = {} end
				end, opts)

				-- ── 右键拖拽: 调整大小 (缓存初始状态) ──
				vim.keymap.set("t", "<RightMouse>", function()
					if not api.nvim_win_is_valid(win) then return end
					local pos = vim.fn.getmousepos()
					local c = api.nvim_win_get_config(win)
					if c.relative == "" then return end
					drag = {
						mode = "resize",
						start_mouse_row = pos.screenrow,
						start_mouse_col = pos.screencol,
						start_width = c.width,
						start_height = c.height,
						row = to_num(c.row),
						col = to_num(c.col),
					}
				end, opts)

				vim.keymap.set("t", "<RightDrag>", function()
					if drag.mode ~= "resize" then return end
					if not api.nvim_win_is_valid(win) then drag = {} return end
					local pos = vim.fn.getmousepos()
					local new_w = drag.start_width + (pos.screencol - drag.start_mouse_col)
					local new_h = drag.start_height + (pos.screenrow - drag.start_mouse_row)
					api.nvim_win_set_config(win, {
						relative = "editor",
						row = drag.row,
						col = drag.col,
						width = math.max(30, math.min(new_w, vim.o.columns - 2)),
						height = math.max(8, math.min(new_h, vim.o.lines - 2)),
					})
				end, opts)

				vim.keymap.set("t", "<RightRelease>", function()
					if drag.mode == "resize" then drag = {} end
				end, opts)

				-- ── 滚轮: 以中心为定点等比缩放 ──
				local function zoom(dw, dh)
					if not api.nvim_win_is_valid(win) then return end
					local c = api.nvim_win_get_config(win)
					if c.relative == "" then return end
					local row, col = to_num(c.row), to_num(c.col)
					local old_w, old_h = c.width, c.height
					local new_w = math.max(30, math.min(old_w + dw, vim.o.columns - 2))
					local new_h = math.max(8, math.min(old_h + dh, vim.o.lines - 2))
					local new_row = math.max(0, row - math.floor((new_h - old_h) / 2))
					local new_col = math.max(0, col - math.floor((new_w - old_w) / 2))
					api.nvim_win_set_config(win, {
						relative = "editor",
						row = new_row,
						col = new_col,
						width = new_w,
						height = new_h,
					})
				end

				vim.keymap.set("t", "<ScrollWheelUp>", function() zoom(4, 2) end, opts)
				vim.keymap.set("t", "<ScrollWheelDown>", function() zoom(-4, -2) end, opts)

				-- ── 中键单击: 居中窗口 ──
				vim.keymap.set("t", "<MiddleMouse>", function()
					if not api.nvim_win_is_valid(win) then return end
					local c = api.nvim_win_get_config(win)
					if c.relative == "" then return end
					c.row = math.floor((vim.o.lines - c.height) / 2)
					c.col = math.floor((vim.o.columns - c.width) / 2)
					api.nvim_win_set_config(win, c)
				end, opts)

				-- 屏蔽多余鼠标事件
				local nop = {
					"<2-LeftMouse>", "<3-LeftMouse>",
					"<2-RightMouse>", "<3-RightMouse>",
					"<2-MiddleMouse>", "<3-MiddleMouse>",
					"<MiddleDrag>", "<MiddleRelease>",
					"<ScrollWheelLeft>", "<ScrollWheelRight>",
				}
				for _, ev in ipairs(nop) do
					vim.keymap.set("t", ev, "<Nop>", opts)
				end
			end,
		})

		-- ── 唯一快捷键: Ctrl+J 开关终端 ──
		vim.keymap.set({ "n", "t" }, "<C-j>", "<Cmd>ToggleTerm direction=float<CR>", {
			desc = "Toggle floating terminal",
			silent = true,
		})
	end,
}
